Import junglegui

Class ProgressBar extends Control

	Method Render:Void()
		Local drawpos := CalculateRenderPosition()
		BackgroundColor.Activate 
		DrawRect(drawpos.X,drawpos.Y,Size.X,Size.Y)
		
		Local width2:Float 
		if _max>0 then
			width2 = Size.X * ( _value / _max)
		Else
			width2 = 0
		endif
		
		BarColor.Activate()
		DrawRect(drawpos.X, drawpos.Y,width2,Size.Y)

		SetAlpha(.3)
		SetColor(255,255,255)
		DrawRect(drawpos.X, drawpos.Y,width2,Size.Y/2)

		SetAlpha(1)
				
		SystemColors.InactiveFormBorder.Activate()
		DrawBox(drawpos,Size)
		
		if GetGui.ActiveControl = Self Then DrawFocusRect(Self,False)
		if GetGui.GetMousePointedControl = Self Then
			SystemColors.FocusColor.Activate()
			DrawBox(drawpos,Size)
		EndIf
	End
	
	
	Method Maximum:Void(value:Float) Property
		if _value > value Then _value = value
		if _max <> value then
			_max = value
			Msg(Self, New EventArgs(eEventKinds.SLIDING_MAXIMUM_CHANGED))
			_value = value			
		endif
	End
	
	Method Maximum:Float() Property
		Return _max
	End
	
	Method Value:Float() Property
		Return _value
	End
	
	Method Value:Void(value:Float) Property
		if value > _max Then value = _max
		if _value <> value then
			Msg(Self, New EventArgs(eEventKinds.SLIDING_VALUE_CHANGED))
			_value = value
		endif
	End
	
	Method SetValues(max:Float, value:Float)
		Maximum = max
		Value = value
	End
	
	Method BarColor:GuiColor() Property
		Return _barColor	
	End
	
	Method BarColor:Void(color:GuiColor) Property
		if color = null Then
			Throw New JungleGuiException("BarColor property can't be set to null!", Self)
			return
		EndIf
		_barColor = color
	End
	
	Method New()
		BackgroundColor = SystemColors.InactiveFormBorder.Clone()
		_barColor = SystemColors.FormBorder.Clone()
		Size.SetValues(250,20)
	End
	
	Private
	Field _max:Float
	Field _value:Float
	Field _barColor:GuiColor
End