#rem monkeydoc Module junglegui.trackbar
	This module contains the TrackBar control implementation.
#END

Import junglegui
Import "data/trackbar.png"

#rem monkeydoc
	Represents a standard TrackBar control.
 #END
Class TrackBar extends Control

Private

	Global _trackBarImage:Image
	Global _cachedPosition:= New GuiVector2D
	Const FADER_WIDTH:Int = 10
	Const FADER_OFFSET:Int = 12
	Const FADER_OFFSET2:Int = 24
	
	Field _down:Bool = false
	Field _over:Bool = false
	Field _frame:int = 0
	Field _dx:Float
	
	Method _MouseOverFader:Bool(mx:Float, my:Float)
	
		Local x:Int = _ValueToPosition
		
		Select _orientation
					
			Case eTrackBarOrientation.HORIZONTAL
				Return mx >= x - FADER_WIDTH / 2 And mx < x + FADER_WIDTH / 2 and my < Size.Y
				
			Case eTrackBarOrientation.VERTICAL
				Return my >= x - FADER_WIDTH / 2 And my < x + FADER_WIDTH / 2 and mx < Size.X
		End
		
	End
	
	Method _ValueToPosition:Int()
		if _maximum = _minimum Return 0
		local m:Float = float(1.0 / float(_maximum - _minimum));
			
		Select _orientation
					
			Case eTrackBarOrientation.HORIZONTAL

				return FADER_OFFSET + (m * _value - (m * _minimum)) * float(Size.X - FADER_OFFSET2)
				
			Case eTrackBarOrientation.VERTICAL

				return FADER_OFFSET + (m * _value - (m * _minimum)) * float(Size.Y - FADER_OFFSET2)
		End
	
	End
	
	Method _RenderLine(drawpos:GuiVector2D)
	
		Select _orientation
		
			Case eTrackBarOrientation.HORIZONTAL
			
				SetColor(176, 176, 176)
				DrawRect(Int(drawpos.X + FADER_OFFSET / 2 + 1), Int(drawpos.Y + Size.Y / 2 - 8), Int(Size.X - FADER_OFFSET - 3), 1)
				SetColor(242, 242, 242)
				DrawRect(Int(drawpos.X + FADER_OFFSET / 2 + 1), Int(drawpos.Y + Size.Y / 2 - 7), Int(Size.X - FADER_OFFSET - 2), 3)
				SetColor(231, 233, 234)
				DrawRect(Int(drawpos.X + FADER_OFFSET / 2 + 1), Int(drawpos.Y + Size.Y / 2 - 7), Int(Size.X - FADER_OFFSET - 3), 2)
				
			Case eTrackBarOrientation.VERTICAL
				
				SetColor(176, 176, 176)
				DrawRect(Int(drawpos.X + Size.X / 2 - 8), Int(drawpos.Y + FADER_OFFSET / 2 + 1), 1, Int(Size.Y - 3 - FADER_OFFSET))
				SetColor(242, 242, 242)
				DrawRect(Int(drawpos.X + Size.X / 2 - 7), Int(drawpos.Y + FADER_OFFSET / 2 + 1), 3, Int(Size.Y - 2 - FADER_OFFSET))
				SetColor(231, 233, 234)
				DrawRect(Int(drawpos.X + Size.X / 2 - 7), Int(drawpos.Y + FADER_OFFSET / 2 + 1), 2, Int(Size.Y - 3 - FADER_OFFSET))
				
		End
	End
	
	Method _RenderTicks(drawpos:GuiVector2D)
	
		Local length = Abs(_maximum - _minimum)
		Local count = length / _tickFrequency
		
		
		Select _orientation
		
			Case eTrackBarOrientation.HORIZONTAL
			
				Local stepWidth:Float = float(Size.X - FADER_OFFSET2) / float(count)
				SetColor 176, 176, 175
				DrawRect Int(drawpos.X + FADER_OFFSET), Int(drawpos.Y + Size.Y / 2 + 7), 1, 5
				DrawRect Int(drawpos.X + FADER_OFFSET + count * stepWidth), Int(drawpos.Y + Size.Y / 2 + 7), 1, 5
				For Local i= 0 until count
					DrawRect Int(FADER_OFFSET + drawpos.X + (i + 1) * stepWidth), Int(drawpos.Y + Size.Y / 2 + 7), 1, 3
				Next
				
			Case eTrackBarOrientation.VERTICAL
				
				Local stepWidth:Float = float(Size.Y - FADER_OFFSET2) / float(count)
				
				SetColor 176, 176, 175
				DrawRect Int(drawpos.X + Size.X / 2 + 7), Int(FADER_OFFSET + drawpos.Y), 5, 1
				DrawRect Int(drawpos.X + Size.X / 2 + 7), Int(FADER_OFFSET + drawpos.Y + count * stepWidth), 5, 1
	
				For Local i= 0 until count
					DrawRect Int(drawpos.X + Size.X / 2 + 7), Int(FADER_OFFSET + drawpos.Y + (i + 1) * stepWidth), 3, 1
				Next
				
		End
		
	End
	
	Method _RenderFader(drawpos:GuiVector2D)
		Select _orientation
		
			Case eTrackBarOrientation.HORIZONTAL
			
				SetColor 255, 255, 255
				DrawImage(_trackBarImage, Int(drawpos.X + _ValueToPosition), Int(drawpos.Y + Size.Y / 2 - 5), _frame)
				
			Case eTrackBarOrientation.VERTICAL
				
				SetColor 255, 255, 255
				DrawImage(_trackBarImage,
				 Int(drawpos.X + Size.X / 2 - 5),
				 Int(drawpos.Y + _ValueToPosition), ' add 10, cause of rotaion
				 90, 1, 1, _frame)
		End
		
	End
	
	Method _MouseDown(e:MouseEventArgs)
		_down = true
		_MouseMove(e)
	End
	
	Method _MouseUp(e:MouseEventArgs)
		if _MouseOverFader(e.position.X, e.position.Y) Then
			_dx = _ValueToPosition - e.position.X
			_frame = 1
		Else
			_frame = 0
		EndIf
		_down = false
	End
	
	Method _MouseMove(e:MouseEventArgs)

		if _down Then
			
			Select _orientation
			
				Case eTrackBarOrientation.HORIZONTAL

					Local length = float(Size.X - FADER_OFFSET2) / Abs(_maximum - _minimum) / _tickFrequency / 2
					local tx:Float = Min(1.0, Max(0.0, float(e.position.X - FADER_OFFSET + length) / float(Size.X - FADER_OFFSET2)))
					Value = tx * float(_maximum - _minimum) + _minimum
					
				Case eTrackBarOrientation.VERTICAL
					
					Local length = float(Size.Y - FADER_OFFSET2) / Abs(_maximum - _minimum) / _tickFrequency / 2
					local tx:Float = Min(1.0, Max(0.0, float(e.position.Y - FADER_OFFSET + length) / float(Size.Y - FADER_OFFSET2)))
					Value = tx * float(_maximum - _minimum) + _minimum
					
			End
			if Self.HasFocus = False Then Self.GetFocus()
		Else
			if _MouseOverFader(e.position.X, e.position.Y) Then
				_frame = 1
			Else
				_frame = 0
			EndIf
		EndIf	
	End
	
Public
	
	Method Update()
		if _down Then
			Local calculateRenderPos:= self.UnsafeRenderPosition
			_cachedPosition.X = GetGui.MousePos.X - calculateRenderPos.X
			_cachedPosition.Y = GetGui.MousePos.Y - calculateRenderPos.Y
			_MouseMove(New MouseEventArgs(eMsgKinds.MOUSE_MOVE, _cachedPosition, 0))
		EndIf
		Super.Update()
	End
	
	Method Msg(msg:BoxedMsg)
		if msg.sender = Self
			Select msg.e.messageSignature
			
				Case eMsgKinds.MOUSE_DOWN
	
					_MouseDown(MouseEventArgs(msg.e))
					
				Case eMsgKinds.MOUSE_UP
				
					_MouseUp(MouseEventArgs(msg.e))
					
				Case eMsgKinds.MOUSE_MOVE
				
					_MouseMove(MouseEventArgs(msg.e))
					
			End
		End
		Super.Msg(msg)
	End
	
	#rem monkeydoc
		Gets a value indicating the horizontal or vertical orientation of the track bar.
	 #END
	Method Orientation:Int() Property
		Return _orientation
	End
	
	#rem monkeydoc
		Sets a value indicating the horizontal or vertical orientation of the track bar.
	 #END
	Method Orientation:Void(value:Int) Property
		if value <> eTrackBarOrientation.HORIZONTAL And value <> eTrackBarOrientation.VERTICAL Then
			Throw New JungleGuiException("", self)
		EndIf
		_orientation = value
	End
	
	Method Render:Void()

		Local drawpos := UnsafeRenderPosition()

		'SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
		BackgroundColor.Activate()
		DrawRect(drawpos.X, drawpos.Y, Size.X, Size.Y)
		
		_RenderLine(drawpos)

		_RenderFader(drawpos)

		_RenderTicks(drawpos)
		
		'if HasFocus Then DrawFocusRect(Self, False)
		'if GetGui.GetMousePointedControl = Self Then
		'	SystemColors.FocusColor.Activate()
		'	DrawBox(drawpos, Size)
		'EndIf

	End

	Method New()
		if Not _trackBarImage Then _trackBarImage = LoadImage("trackbar.png", 10, 18, 3, Image.MidHandle)
		BackgroundColor = SystemColors.WindowColor
		Size.SetValues(200, 40)
		Orientation = eTrackBarOrientation.HORIZONTAL
	End
	
	#rem monkeydoc
		Sets a numeric value that represents the current position of the scroll box on the track bar.
	 #END
	Method Value:Void(value:Int) Property
		If _value <> value Then
			if value < _minimum Then value = _minimum
			if value > _maximum Then value = _maximum
			_value = value
			Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.SLIDING_VALUE_CHANGED)))
		End
	End
	
	#rem monkeydoc
		Gets a numeric value that represents the current position of the scroll box on the track bar.
	 #END
	Method Value:Int() Property
		Return _value
	End
	
	#rem monkeydoc
		Gets the lower limit of the range this TrackBar is working with.
	#END
	Method Minimum:Int() Property
		Return _minimum 
	End
	
	#rem monkeydoc
		Gets the lower limit of the range this TrackBar is working with.
	#end
	Method Minimum:Void(value:Int) Property
		_minimum = value
		if _value < _minimum Then _value = _minimum
	End
	
	#rem monkeydoc
		Get the upper limit of the range this TrackBar is working with.
	#END
	Method Maximum%() Property 
		Return _maximum 
	End
	
	#rem monkeydoc
		Set the upper limit of the range this TrackBar is working with.
	#end
	Method Maximum:Void(value:Int) Property
		_maximum = value
		if _value > _maximum Then _value = _maximum
	End
	
	#rem monkeydoc
		Gets a value that specifies the delta between ticks drawn on the control.
	#END
	Method Tickfrequency%()
		Return _tickFrequency 
	End
	
	#rem monkeydoc
		Sets a value that specifies the delta between ticks drawn on the control.
	#END
	Method Tickfrequency:Void(value:Int)
		if value < 1 Then value = 1
		_tickFrequency = value 
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
		This event will be fired every time the Value property is modified.
	#END
	Method Event_ValueChanged:EventHandler<EventArgs>() Property; Return _sliderValueChanged; End
	#rem monkeydoc
		This event will be fired every time the Maximum property is modified.
	#END
	Method Event_MaximumChanged:EventHandler<EventArgs>() Property; Return _sliderMaximumChanged; End
	
	Private
	
	Field _sliderValueChanged:= New EventHandler<EventArgs>
	Field _sliderMaximumChanged:= New EventHandler<EventArgs>

	Field _state:Int = 0
	Field _value:Int = 0
	Field _tickFrequency:Int = 5
	Field _minimum:Int = 0
	Field _maximum:Int = 100
	Field _orientation:Int = eTrackBarOrientation.VERTICAL
	
End

#rem monkeydoc
	This class contains all possible values for a [[TrackBar]] control orientation
#END
Class eTrackBarOrientation Abstract
	#rem monkeydoc
		Orientation is vertical
	#END
	Const VERTICAL:Int = 0
	#rem monkeydoc
		Orientation is horizontal
	#END
	Const HORIZONTAL:Int = 1
End
