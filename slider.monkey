Import junglegui

Class Slider extends Control

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
		Local renderPos:= CalculateRenderPosition()
		BackgroundColor.Activate()
		DrawRect(renderPos.X, renderPos.Y, Size.X, Size.Y)
		RenderLine(renderPos)
		RenderFader(renderPos)
	End
	
	Method RenderLine:Void(pos:GuiVector2D)
		Select _orientation
			Case eSliderOrientation.HORIZONTAL
				SystemColors.FocusColor.Activate()
				Local yPos:Int = pos.Y + Size.Y / 2
				For Local i:Int = pos.X to pos.X + Size.X step 6
					DrawPoint(i, yPos)
				Next
			Case eSliderOrientation.VERTICAL
				SystemColors.FocusColor.Activate()
				'DrawBox(int(pos.X + Size.X / 2 - 1), Int(pos.Y), 1, int(Size.Y))
				Local xPos:Int = pos.X + Size.X / 2
				For Local i:Int = pos.Y to pos.Y + Size.Y step 4
					DrawPoint(xPos, i)
				Next
				
		End
	End
	
	Method Update()
		if _sliding Then
			Local position:= New GuiVector2D
			Local calculateRenderPos:= self.CalculateRenderPosition
			position.X = GetGui.MousePos.X - calculateRenderPos.X
			position.Y = GetGui.MousePos.Y - calculateRenderPos.Y
			Mouse_Move(New MouseEventArgs(eEventKinds.MOUSE_MOVE, position, 0))
		EndIf
		Super.Update()
	End
	
	Method RenderFader:Void(pos:GuiVector2D)
		Local distance:Int
		Local posX:Float, posY:Float
		Local FaderSize:= GetFaderSize()
		Select _orientation
		
			Case eSliderOrientation.HORIZONTAL
				if Max > 0 Then distance = FaderSize + (Size.X - FaderSize * 2) * Value / Max Else distance = FaderSize
				SystemColors.FocusColor.Activate()
				posX = pos.X + distance
				posY = pos.Y + Size.Y / 2
				'DrawCircle(pos.X + distance, pos.Y + Size.Y / 2, FADERSIZE)
				
			Case eSliderOrientation.VERTICAL
				if Max > 0 Then distance = FaderSize + (Size.Y - FaderSize * 2) * Value / Max Else distance = FaderSize
				posX = pos.X + Size.X / 2
				posY = pos.Y + distance
				'DrawCircle(pos.X + Size.X / 2, pos.Y + distance, FADERSIZE)
		End
		if Self.HasFocus then
			SystemColors.FocusColor.Activate()		
			DrawCircle(posX, posY, FaderSize)
			SetAlpha(Abs(Sin(Millisecs() / 5)))
			SystemColors.ControlFace.Activate()
			DrawCircle(posX, posY, FaderSize - 2)
			SetAlpha(1)
		Else
			SystemColors.FocusColor.Activate()
			DrawCircle(posX, posY, FaderSize)
		endif
	End
	
	Method Max:Void(value:Int) Property
		if _value > value Then _value = value
		if _max <> value then
			_max = value
			Msg(Self, New EventArgs(eEventKinds.SLIDING_MAXIMUM_CHANGED))
		endif
	End
	
	Method Max:Int() Property
		Return _max
	End
	
	Method Value:Int() Property
		Return _value
	End
	
	Method Value:Void(value:Int) Property
		if value > _max Then value = _max
		if _value <> value then
			_value = value
			Msg(Self, New EventArgs(eEventKinds.SLIDING_VALUE_CHANGED))
		endif
	End
	
	Method SetValues(max:Int, value:Int)
		Max = max
		Value = value
	End
		
	Method New()
		Size.SetValues(250, 20)
		BackgroundColor = SystemColors.WindowColor.Clone()
	End
	
	Method Msg:Void(sender:Object, e:EventArgs)
		if sender = Self Then
			Select e.eventSignature
				Case eEventKinds.MOUSE_DOWN
					Mouse_Down(MouseEventArgs(e))
				Case eEventKinds.MOUSE_UP
					Mouse_Up()
				Case eEventKinds.MOUSE_MOVE
					Mouse_Move(MouseEventArgs(e))
			End
		EndIf
		Super.Msg(sender, e)
	End
	
	Private
	
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
					Value = 0.5 + newValue * Max / (Size.X - FaderSize * 2)
				Case eSliderOrientation.VERTICAL
					Local newValue:Int = e.position.Y - FaderSize
					if newValue < 0 Then newValue = 0
					Value = 0.5 + newValue * Max / (Size.Y - FaderSize * 2)
			End
			if Self.HasFocus = False Then Self.GetFocus()
		EndIf
	End
	Field _max:Int = 100
	Field _value:Int = 50
	Field _orientation:Int = eSliderOrientation.HORIZONTAL
	Field _sliding:Bool = false
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

Class eSliderOrientation Abstract
	Const VERTICAL:Int = 0
	Const HORIZONTAL:Int = 1
End