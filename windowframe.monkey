Import junglegui

Class WindowFrame Extends TopLevelControl
	
	Method New()
		BackgroundColor = SystemColors.AppWorkspace.Clone()
		Size.SetValues(400, 400)
		Padding.Left = 0
		Padding.Top = 0
		Padding.Right = 0
		Padding.Bottom = 0
		BackgroundColor = SystemColors.WindowColor.Clone()
	End
	
	Method RenderBackground()
		If Not Transparent Then
			Local drawPos:GuiVector2D = CalculateRenderPosition()
			GetGui.Renderer.DrawControlBackground(Status, drawPos, Size, Self)
		End
	End
	
	Method DrawFocus()
		If Not Transparent Then Super.DrawFocus()
	End

	'summary: This property is used to determine if this Window Frame component has a solid background
	Method Transparent:Bool() Property
		Return _transparent
	End

	Method Transparent:Void(value:Bool) Property
		_transparent = value
	End
	Private
	Field _transparent:Bool
	
End

