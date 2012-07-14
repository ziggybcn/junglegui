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
				DrawBox(Int(pos.X), int(pos.Y + Size.Y / 2 - 1), int(Size.X), 2)
			Case eSliderOrientation.VERTICAL
				SystemColors.FocusColor.Activate()
				DrawBox(int(pos.X + Size.X / 2 - 1), Int(pos.Y), 2, int(Size.Y))
		End
	End
	
	Method RenderFader:Void(pos:GuiVector2D)
		Local distance:Int
		Select _orientation
			Case eSliderOrientation.HORIZONTAL
				if Max > 0 Then distance = Size.X * Value / Max Else distance = 0
				SystemColors.FocusColor.Activate()
				DrawCircle(pos.X + distance - 5, pos.Y + Size.Y / 2, 10)
			Case eSliderOrientation.VERTICAL
				if Max > 0 Then distance = Size.Y * Value / Max Else distance = 0
				'DrawCircle(pos.X + distance - 5, pos.Y + Size.Y / 2, 10)
				DrawCircle(pos.X + Size.X / 2, pos.Y + distance - 5, 10)
		End
	End
	
	
	Method Max:Void(value:Float) Property
		if _value > value Then _value = value
		_max = value
	End
	
	Method Max:Float() Property
		Return _max
	End
	
	Method Value:Float() Property
		Return _value
	End
	
	Method Value:Void(value:Float) Property
		if value>_max Then value = _max
		_value = value
	End
	
	Method SetValues(max:Float, value:Float)
		Max = max
		Value = value
	End
	
	
	Method New()
		BackgroundColor = SystemColors.InactiveFormBorder.Clone()
		Size.SetValues(250,20)
	End
	
	Private
	Field _max:Float
	Field _value:Float
	Field _orientation:Int = eSliderOrientation.HORIZONTAL
End

Class eSliderOrientation Abstract
	Const VERTICAL:Int = 0
	Const HORIZONTAL:Int = 1
End