#rem monkeydoc Module junglegui.slider
	 
#END
Import junglegui

#rem monkeydoc
	This control represents a slider bar that can be used to represent graphically a flaoting point value.
	It's designed to be easily used with a finger and it is the float-point approach for a [[TrackBar]]. 
	The difference is that a Slider can represent intermediate values, while a TrackBar is designed to represent whole units.
#END
Class Slider extends Control

	#rem monkeydoc
		This property returns the orientation of the Slider control.
		The available orientations are defined in the [[eSliderOrientation]] class.
	#END
	Method Orientation(value:Int) Property
		if value <> eSliderOrientation.HORIZONTAL And value <> eSliderOrientation.VERTICAL Then
			Throw New JungleGuiException("Invalid orientation value for slider control. Value was " + value, Self)
		EndIf
		_orientation = value
	End
	
	Method Orientation:Int() Property
		Return _orientation
	End
		
	Method Render:Void()
		Local renderPos:= UnsafeRenderPosition()
		BackgroundColor.Activate()
		DrawRect(Int(renderPos.X), Int(renderPos.Y), Int(Size.X), Int(Size.Y))
		RenderLine(renderPos)
		RenderFader(renderPos)
	End
	
	Method RenderLine:Void(pos:GuiVector2D)
		Select _orientation
			Case eSliderOrientation.HORIZONTAL
				Local init:Int = pos.X
				if Self.HasFocus Then init = pos.X + ( (Millisecs() / 120) mod 6)
				SystemColors.FocusColor.Activate()
				Local yPos:Int = pos.Y + Size.Y / 2
				For Local i:Int = init to pos.X + Size.X step 6
					DrawPoint(Int(i), Int(yPos))
				Next
			Case eSliderOrientation.VERTICAL
				Local init:Int = pos.X
				if Self.HasFocus Then init = pos.Y + ( (Millisecs() / 120) mod 6)
				SystemColors.FocusColor.Activate()
				'DrawBox(int(pos.X + Size.X / 2 - 1), Int(pos.Y), 1, int(Size.Y))
				Local xPos:Int = pos.X + Size.X / 2
				For Local i:Int = init to pos.Y + Size.Y step 4
					DrawPoint(Int(xPos), Int(i))
				Next
				
		End
	End
	
	Method Update()
		if _sliding Then
			Local calculateRenderPos:= self.UnsafeRenderPosition
			_cachedPosition.X = GetGui.MousePos.X - calculateRenderPos.X
			_cachedPosition.Y = GetGui.MousePos.Y - calculateRenderPos.Y
			Mouse_Move(New MouseEventArgs(eMsgKinds.MOUSE_MOVE, _cachedPosition, 0))
		EndIf
		Super.Update()
	End
	
	Method RenderFader:Void(pos:GuiVector2D)
		Local distance:Int
		Local posX:Float, posY:Float
		Local FaderSize:= GetFaderSize()
		Select _orientation
		
			Case eSliderOrientation.HORIZONTAL
				if Maximum > 0 Then distance = FaderSize + (Size.X - FaderSize * 2) * Value / Maximum Else distance = FaderSize
				SystemColors.FocusColor.Activate()
				posX = pos.X + distance
				posY = pos.Y + Size.Y / 2
				'DrawCircle(pos.X + distance, pos.Y + Size.Y / 2, FADERSIZE)
				
			Case eSliderOrientation.VERTICAL
				if Maximum > 0 Then distance = FaderSize + (Size.Y - FaderSize * 2) * Value / Maximum Else distance = FaderSize
				posX = pos.X + Size.X / 2
				posY = pos.Y + distance
				'DrawCircle(pos.X + Size.X / 2, pos.Y + distance, FADERSIZE)
		End
		if Self.HasFocus then
			SystemColors.FocusColor.Activate()		
			DrawCircle(Int(posX), Int(posY), FaderSize)
			SetAlpha(Abs(Sin(Millisecs() / 5)))
			SystemColors.ControlFace.Activate()
			DrawCircle(Int(posX), Int(posY), FaderSize - 2)
			SetAlpha(1)
		Else
			SystemColors.FocusColor.Activate()
			DrawCircle(Int(posX), Int(posY), FaderSize)
		endif
	End
	
	#rem monkeydoc
		This property is the maximum value that can be reached by the slider.
	#END
	Method Maximum:Void(value:Int) Property
		if _value > value Then _value = value
		if _max <> value then
			_max = value
			Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.SLIDING_MAXIMUM_CHANGED)))
		endif
	End
	
	Method Maximum:Int() Property
		Return _max
	End
	
	#rem monkeydoc
		This property is current slider value.
	#END
	Method Value:Int() Property
		Return _value
	End
	
	Method Value:Void(value:Int) Property
		if value > _max Then value = _max
		if _value <> value then
			_value = value
			Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.SLIDING_VALUE_CHANGED)))
		endif
	End
	
	#rem monkeydoc
		This method allows you to set both Value and Maximum in a single call.
	#END
	Method SetValues(max:Int, value:Int)
		Maximum = max
		Value = value
	End
		
	Method New()
		Size.SetValues(250, 20)
		BackgroundColor = SystemColors.WindowColor
	End
	
	Method Msg(msg:BoxedMsg)
		if msg.sender = Self Then
			Select msg.e.messageSignature
				Case eMsgKinds.MOUSE_DOWN
					Mouse_Down(MouseEventArgs(msg.e))
				Case eMsgKinds.MOUSE_UP
					Mouse_Up()
				Case eMsgKinds.MOUSE_MOVE
					Mouse_Move(MouseEventArgs(msg.e))
			End
		EndIf
		Super.Msg(msg)
	End
	
	Method Dispatch(msg:BoxedMsg)
		Super.Dispatch(msg)
		Select msg.e.messageSignature
			Case eMsgKinds.SLIDING_VALUE_CHANGED
				_sliderValueChanged.RaiseEvent(msg.sender, msg.e)
			Case eMsgKinds.SLIDING_MAXIMUM_CHANGED
				_sliderMaximumChanged.RaiseEvent(msg.sender, msg.e)
		End
	End
	
	#rem monkeydoc
		This event is fired every time the Value property is modified.
	#END
	Method Event_ValueChanged:EventHandler<EventArgs>() Property; Return _sliderValueChanged; End
	#rem monkeydoc
		This event is fired every time the Maximum property is modified.
	#END
	Method Event_MaximumChanged:EventHandler<EventArgs>() Property; Return _sliderMaximumChanged; End
	Private
	
	Field _sliderValueChanged:= New EventHandler<EventArgs>
	Field _sliderMaximumChanged:= New EventHandler<EventArgs>

	Method Mouse_Down(e:MouseEventArgs)
		_sliding = true
		Mouse_Move(e)
	End
	
	Method Mouse_Up()
		_sliding = false
	End
	
	Method Mouse_Move(e:MouseEventArgs)
		if _sliding
			Local FaderSize:= GetFaderSize()
			Select _orientation
				Case eSliderOrientation.HORIZONTAL
					Local newValue:Int = e.position.X - FaderSize
					if newValue < 0 Then newValue = 0
					Value = 0.5 + newValue * Maximum / (Size.X - FaderSize * 2)
				Case eSliderOrientation.VERTICAL
					Local newValue:Int = e.position.Y - FaderSize
					if newValue < 0 Then newValue = 0
					Value = 0.5 + newValue * Maximum / (Size.Y - FaderSize * 2)
			End
			if Self.HasFocus = False Then Self.GetFocus()
		EndIf
	End
	Field _max:Int = 100
	Field _value:Int = 50
	Field _orientation:Int = eSliderOrientation.HORIZONTAL
	Field _sliding:Bool = false
	
	Global _cachedPosition:= New GuiVector2D
	'Const FADERSIZE:Int = 6
	Method GetFaderSize:Float()
		Select _orientation
			Case eSliderOrientation.HORIZONTAL
				Return Size.Y / 2
			Default
				Return Size.X / 2
		End
	End
End

#rem monkeydoc
	This class contains the available slider orientations
#END
Class eSliderOrientation Abstract
	#rem monkeydoc
		This const indicates that a Slider should be rendered with a vertical orientation
	#END
	Const VERTICAL:Int = 0
	#rem monkeydoc
		This const indicates that a Slider should be rendered with a horizontal orientation
	#END
	Const HORIZONTAL:Int = 1
End