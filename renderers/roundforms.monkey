Import junglegui
Class RoundForms Extends renderer.GuiRenderer

	Method InitRenderer()
'		'We modify some systemcolors when the Renderer is activated:
		SystemColors.FormMargin.SetColor(1, 120, 170, 30)
		SystemColors.FormBorder.SetColor(1, 100, 120, 0)

		SystemColors.ControlFace.SetColor(1, 220, 220, 220)
		SystemColors.ButtonBorderColor.SetColor(1, 182, 182, 182)
		SystemColors.FocussedButtonBorderColor.SetColor(1, 69, 251, 216)
		SystemColors.AppWorkspace.SetColor(1, 171, 171, 171)
		SystemColors.FocusColor.SetColor(1, 60, 177, 127)
		SystemColors.WindowColor.SetColor(1, 255, 255, 255)
		SystemColors.InactiveFormBorder.SetColor(1, 120, 120, 120)
		SystemColors.SelectedItemBackColor.SetColor(1, 51, 255, 153)
		SystemColors.HooverBackgroundColor.SetColor(1, 255, 255, 255)

		
'		#IF TARGET="html5"
'			Gui.systemFont = New bitmapfont.BitmapFont("concretejunglefont_html5.txt")
'		#ELSE
'			Gui.systemFont = New bitmapfont.BitmapFont("concretejunglefont.txt")
'		#END
	End

	Method DrawFormBackground(status:Int, position:GuiVector2D, size:GuiVector2D, padding:Padding, text:String, context:Control)
		'We modify the way a form is renderer.

		'We render the form "main" box:
		SystemColors.FormBorder.Activate()	'Select the form margin color
		SetAlpha(1)
		DrawRect(position.X + 15, position.Y, size.X - 30, 15)
		DrawRect(position.X, position.Y + 15, size.X, size.Y - 15)
		DrawOval(position.X, position.Y, 30, 30)
		DrawOval(position.X + size.X - 30, position.Y, 30, 30)

		SystemColors.FormMargin.Activate()	'Select the form margin color
		SetAlpha(1)
		DrawRect(position.X + 15 + 1, position.Y + 1, size.X - 30 - 1, 15 - 1)
		DrawRect(position.X + 1, position.Y + 15, size.X - 2, size.Y - 15 - 1)
		DrawOval(position.X + 1, position.Y + 1, 28, 28)
		DrawOval(position.X + size.X - 30 + 1, position.Y + 1, 28, 28)

		'Now we're rendering the form "container" area, where controls are placed:
		Local backcolor:guicolor.GuiColor
		If context = Null Then	'If we're just calling this to be used with systemcolors:
			backcolor = SystemColors.WindowColor
		Else	'If we're caling this to be used with a given real form, we use its background color instead:
			backcolor = context.BackgroundColor
		EndIf
		backcolor.Activate
		DrawRect(position.X + padding.Left, position.Y + padding.Top, size.X - padding.Left - padding.Right, size.Y - padding.Top - padding.Bottom)
		backcolor.ActivateDark(150)
		'SetColor(0, 0, 0)
		DrawBox(position.X + padding.Left, position.Y + padding.Top, size.X - padding.Left - padding.Right, size.Y - padding.Top - padding.Bottom)

		SetAlpha(1)	'We set alpha back to 1
		
		'We render for form caption (header):
		
'		'First a small gradient:
'		For Local i:Int = 0 To Gui.systemFont.GetFontHeight
'			SetAlpha(1 - float(i) / float(Gui.systemFont.GetFontHeight))
'			DrawLine(position.X, position.Y + i, position.X + size.X, position.Y + i)
'		Next
		'Then the text:
		SetAlpha 1
		#IF TARGET="html5" 
			SetColor(255, 255, 255)
		#ELSE
			SystemColors.WindowTextForeColor.Activate()
		#END
		Local f:Form = Form(context)
		If f <> Null Then
			Gui.systemFont.DrawText(text, position.X + size.X / 2, position.Y + f.Padding.Top / 2 - Gui.systemFont.GetFontHeight / 2, eDrawAlign.CENTER)
		Else
			Gui.systemFont.DrawText(text, position.X + size.X / 2, position.Y + 1 - Gui.systemFont.GetFontHeight / 2, eDrawAlign.CENTER)
		EndIf
'				
'		
'		
'		'Now we're rendering the form "container" area, where controls are placed:
'		Local backcolor:guicolor.GuiColor
'		If context = Null Then	'If we're just calling this to be used with systemcolors:
'			backcolor = SystemColors.WindowColor
'		Else	'If we're caling this to be used with a given real form, we use its background color instead:
'			backcolor = context.BackgroundColor
'		EndIf
'		backcolor.Activate
'		DrawRect(position.X + padding.Left, position.Y + padding.Top, size.X - padding.Left - padding.Right, size.Y - padding.Top - padding.Bottom)
'		
'		'Now we're adding a small gradient at the top and at the bottom of the form container area:
'		For Local i:Int = 0 To 20
'			'SetAlpha(1 - i / 20.0)
'			
'			backcolor.ActivateDark(2 * (40 - i * 2))'55)
'			
'			DrawLine(position.X + padding.Left,
'				position.Y +size.Y - padding.Bottom - i,
'				position.X +size.X - padding.Right,
'				position.Y +size.Y - padding.Bottom - i)
'			
'			backcolor.ActivateBright(2 * (40 - i * 2))'55)
'			'SetColor(255, 0, 0)
'			DrawLine(position.X + padding.Left,
'				position.Y +padding.Top + i,
'				position.X +size.X - padding.Right,
'				position.Y +padding.Top + i)
'			
'		Next		
'		SetAlpha(0.5)
'		SystemColors.FormBorder.Activate()
'		DrawBox(position, size)
'		SetAlpha(1)
	End
End