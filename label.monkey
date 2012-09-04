Import junglegui
Class Label extends BaseLabel implements guiinterfaces.TextualAlignItem 

	Method Render:Void()
		Local drawingPos:=CalculateRenderPosition()
		if Not Transparent then
			SetColor(BackgroundColor.r,BackgroundColor.g,BackgroundColor.b)
			DrawRect(drawingPos.X,drawingPos.Y,Size.X,Size.Y)
		Endif
		
		SetColor(Self.ForeColor.r,ForeColor.g,ForeColor.b)
		local textHeight:Int = Font.GetTxtHeight(Text)
		Font.DrawText(Text,drawingPos.X,Int(drawingPos.Y + Size.Y/2 - textHeight/2))
		if _border Then
			BorderColor.Activate()
			DrawBox(drawingPos,Self.Size)
		EndIf
	End

	Method TextAlign:Int() Property
		Return _textAlign	
	End
	
	Method TextAlign:Void(align:Int) Property
		Select align
			Case eTextAlign.CENTER, eTextAlign.LEFT, eTextAlign.RIGHT 
				_textAlign = align
			Default
				Throw(New JungleGuiException("Text align value is not valid",Self))	
		End
	End
	
'	Method BorderColor:GuiColor() Property
'		Return _borderColor
'	End
'	
'	Method BorderColor:Void(color:GuiColor) Property
'		if color<> null then
'			_borderColor = color
'		Else
'			Throw New JungleGuiException("Border color can't be null.",Self)
'		endif
'	End
	
	Method Transparent:Bool() Property
		Return _transparent 
	End
	Method Transparent:Void(value:Bool) Property
		_transparent = value
	End
	
	Private
	Field _textAlign:Int = eTextAlign.LEFT 
	Field _border:Bool = false
	Field _transparent:Bool = true
end