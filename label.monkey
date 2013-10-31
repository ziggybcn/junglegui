Import junglegui
#Rem
	summary: This control shows a text label. It's useful to display text.
#END
Class Label extends BaseLabel implements guiinterfaces.TextualAlignItem 

	Method Render:Void()
		Local drawingPos:=UnsafeRenderPosition()
		if Not Transparent then
			'SetColor(BackgroundColor.r,BackgroundColor.g,BackgroundColor.b)
			BackgroundColor.Activate()
			DrawRect(drawingPos.X,drawingPos.Y,Size.X,Size.Y)
		Endif
		
		GetGui.Renderer.DrawLabelText(Status, drawingPos, Size, Text, TextAlign, Self.Font, Self)
		If _border Then
			BorderColor.Activate()
			DrawBox(drawingPos, Self.Size)
		EndIf
	End

	'summary: This property allows to set the text align property to one of the values defined in eTextAlign
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
	
	'summary: This control can have a transparent background. Set this boolean property to true or false accordingly
	Method Transparent:Bool() Property
		Return _transparent 
	End
	Method Transparent:Void(value:Bool) Property
		_transparent = value
	End
	 
	Private
	Field _textAlign:Int = eTextAlign.LEFT 
	Field _border:Bool = false
	Field _transparent:Bool = True
End