Import junglegui
Import "touch.data\pesofont.txt"
Import "touch.data\pesofont_P_1.png"

Class Touch Extends renderer.GuiRenderer

	Method InitRenderer()
		Gui.systemFont = New BitmapFont("pesofont.txt")
		'DefaultFormPadding.Top = 150
		DefaultFormPadding.Top = Gui.systemFont.GetFontHeight() +5
		DefaultFormPadding.Left = 15
		DefaultFormPadding.Right = 15
		DefaultFormPadding.Bottom = 15
	End
End