Import junglegui

#IF TARGET="html5"
	Import "concretejungle.data\concretejunglefont_html5.txt"
	Import "concretejungle.data\concretejunglefont_html5_P_1.png"
#ELSE
	Import "concretejungle.data\concretejunglefont.txt"
	Import "concretejungle.data\concretejunglefont_P_1.png"
#END

Class ConcreteJungle Extends renderer.GuiRenderer

	Method InitRenderer()
		'We modify some systemcolors when the Renderer is activated:
		SystemColors.FormMargin.SetColor(1, 200, 200, 190)
		SystemColors.WindowColor.SetColor(1, 220, 220, 200)
		SystemColors.ButtonBorderColor.SetColor(1, 55, 55, 35)
		SystemColors.ControlFace.SetColor(1, 180, 170, 160)
		SystemColors.HooverBackgroundColor.SetColor(1, 235, 235, 190)
		SystemColors.FocusColor.SetColor(1, 255, 255, 255)
		'SystemColors.FormBorder.SetColor(1, 250, 250, 230)
		SystemColors.FormBorder.SetColor(1, 0, 0, 0)
		SystemColors.SelectedItemBackColor.SetColor(1, 200, 200, 180)
		#IF TARGET="html5"
			Gui.systemFont = New bitmapfont.BitmapFont("concretejunglefont_html5.txt")
		#ELSE
			Gui.systemFont = New bitmapfont.BitmapFont("concretejunglefont.txt")
		#END
	End

	Method DrawFormBackground(status:Int, position:GuiVector2D, size:GuiVector2D, padding:Padding, text:String, context:Control)
		'We modify the way a form is renderer.

		'We render the form "main" box:
		If context <> Null And context = context.GetGui.ActiveTopLevelControl Then
			SystemColors.FormMargin.ActivateBright(25)	'Select the form margin color
		Else
			SystemColors.FormMargin.ActivateDark(55)	'Select the form margin color
		EndIf
		SetAlpha(0.75)	'Oue new skin has transparent form borders, so we set alpha
		'SetAlpha 1
		DrawRect(position.X, position.Y, size.X, size.Y)	'We draw the form rectangle
		SetAlpha(1)	'We set alpha back to 1
		
		'We render for form caption (header):
		
		'First a small gradient:
		For Local i:Int = 0 To Gui.systemFont.GetFontHeight
			SystemColors.FormMargin.ActivateBright(50)
			SetAlpha(1 - float(i) / float(Gui.systemFont.GetFontHeight))
			DrawLine(position.X, position.Y + i, position.X + size.X, position.Y + i)
		Next
		
		'Then the text:
		SetAlpha 1
		#IF TARGET="html5" 
			SetColor(255, 255, 255)
		#ELSE
			SystemColors.WindowTextForeColor.Activate()
		#END
		Gui.systemFont.DrawText(text, position.X + padding.Left + 1, position.Y + padding.Top / 2 - Gui.systemFont.GetFontHeight / 2)
				
		
		Local resizeStatus = eResizeStatus.NONE
		'Now we're rendering the form "container" area, where controls are placed:
		Local backcolor:guicolor.GuiColor
		If context = Null Then	'If we're just calling this to be used with systemcolors:
			backcolor = SystemColors.WindowColor
		Else	'If we're caling this to be used with a given real form, we use its background color instead:
			backcolor = context.BackgroundColor
			If Form(context) <> Null Then
				Local f:= Form(context)
				If HasFlag(status, eControlStatus.HOOVER) Then resizeStatus = f.GetMouseOverReisingStatus()
	
			EndIf
		EndIf
		backcolor.Activate
		DrawRect(position.X + padding.Left, position.Y + padding.Top, size.X - padding.Left - padding.Right, size.Y - padding.Top - padding.Bottom)
		
		'Now we're adding a small gradient at the top and at the bottom of the form container area:
		For Local i:Int = 0 To 20
			'SetAlpha(1 - i / 20.0)
			
			backcolor.ActivateDark(1 * (40 - i * 2))'55)
			
			DrawLine(position.X + padding.Left,
				position.Y +size.Y - padding.Bottom - i,
				position.X +size.X - padding.Right,
				position.Y +size.Y - padding.Bottom - i)
			
			backcolor.ActivateBright(1 * (40 - i * 2))'55)
			'SetColor(255, 0, 0)
			DrawLine(position.X + padding.Left,
				position.Y +padding.Top + i,
				position.X +size.X - padding.Right,
				position.Y +padding.Top + i)
			
		Next		

		SetAlpha(Abs(Sin(Millisecs() / 2.0)))
		If HasFlag(resizeStatus, eResizeStatus.RESIZE_RIGHT)
			SetColor(255, 255, 255)
			DrawRect(position.X + size.X - 5, position.Y, 5, size.Y)
		EndIf
		If HasFlag(resizeStatus, eResizeStatus.RESIZE_BOTTOM)
			SetColor(255, 255, 255)
			DrawRect(position.X, position.Y + size.Y - 5, size.X, 5)
		EndIf

		SystemColors.FormBorder.Activate()
		SetAlpha(0.5)
		DrawBox(position, size)

		SetAlpha(1)
		
	End

	Method DrawButtonBackground(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control)
		Local backColor:GuiColor
		If HasFlag(status, eControlStatus.HOOVER) Then
			If context Then
				backColor = context.HooverColor
			Else
				backColor = SystemColors.HooverBackgroundColor
			EndIf
		Else
			If context Then
				backColor = context.BackgroundColor
			Else
				backColor = SystemColors.ControlFace
			EndIf
		EndIf
		backColor.Activate()
		DrawRect(position.X + 1, position.Y + 1, size.X - 2, size.Y - 2)
	End
	
	
	Method DrawControlBorder(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control)
		If context Then context.BorderColor.Activate() Else SystemColors.ButtonBorderColor.Activate()
		'We draw a square control border on this skin:
		DrawBox(position, size)
	End
	
	Method DrawFocusRect(control:Control, round:Bool = False)
		SystemColors.FocusColor.Activate()
		Local pos:= control.UnsafeRenderPosition()
		Local size:= control.Size
		DrawBox(pos, size)
	End
	
	Method DrawCheckBox(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null, checked:Bool = True)
		SystemColors.ControlFace.Activate()
		Local yOffset:Int = size.Y / 2 - CheckBoxSize.Y / 2
		DrawRect(position.X + 1, position.Y + 1 + yOffset, CheckBoxSize.X - 2, CheckBoxSize.Y - 2)
		If HasFlag(status, eControlStatus.HOOVER) Then
			SystemColors.FocusColor.Activate()
		Else
			SystemColors.ButtonBorderColor.Activate()
		EndIf
		
		DrawRoundBox(int(position.X), int(position.Y + yOffset), CheckBoxSize.X, CheckBoxSize.Y)
		If checked Then
			SystemColors.FocusColor.Activate()
			SetAlpha(Abs(Sin(Millisecs() / 10.0)))
			'DrawRect(position.X + 4, position.Y + 4 + yOffset, BoxSize - 9, BoxSize - 8)
			DrawOval(position.X + 4, position.Y + 4 + yOffset, CheckBoxSize.X - 8, CheckBoxSize.Y - 7)
			SetAlpha 1
		EndIf
	End

	Method DrawRadioCheckBox(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null, checked:Bool = True)
		Local yOffset:Int = size.Y / 2 - RadioBoxSize.Y / 2
		If HasFlag(status, eControlStatus.HOOVER) Then
			SystemColors.FocusColor.Activate()
		Else
			SystemColors.ButtonBorderColor.Activate()
		EndIf
		DrawOval(position.X, position.Y + yOffset, RadioBoxSize.X, RadioBoxSize.Y)

		SystemColors.ControlFace.Activate()
		DrawOval(position.X + 1, position.Y + 1 + yOffset, RadioBoxSize.X - 2, RadioBoxSize.Y - 2)
		'DrawRoundBox(int(drawPos.X), int(drawPos.Y + yOffset), BoxSize, BoxSize)
		If checked Then
			SystemColors.FocusColor.Activate()
			SetAlpha(Abs(Sin(Millisecs() / 10.0)))
			DrawOval(position.X + 2, position.Y + 2 + yOffset, RadioBoxSize.X - 4, RadioBoxSize.Y - 4)
		EndIf
		
	End
	
End
