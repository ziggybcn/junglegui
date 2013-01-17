Import junglegui

Class GuiRenderer

	Method Event_GuiAttached:EventHandler<EventArgs>() Property; Return _guiAttached; End
	Method Event_GuiDetached:EventHandler<EventArgs>() Property; Return _guiDetached; End

	Method New()
		ResetRendererValues(Self)
	End

	Method DrawButtonBackground(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null)
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
		backColor.Activate
		
		DrawRect(position.X + 1, position.Y + 1, size.X - 2, size.Y - 2)
		
		backColor.ActivateBright()
		DrawRect(position.X + 1, position.Y + 1, size.X - 2, size.Y / 2)

	End
	
	Method DrawControlBorder(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null)
		if context then context.BorderColor.Activate() Else SystemColors.ButtonBorderColor.Activate()
		DrawRoundBox(position, size)
	End
	
	Method DrawButtonFocusRect(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null)
		SystemColors.FocusColor.Activate
		SetAlpha 0.2
		DrawRect(position.X + 1, position.Y + 1, size.X - 2, size.Y - 2)
		SetAlpha 1
	End
	 
	Method DrawComboArrow(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null)
		SetColor 0,0,0
		DrawRect position.X + size.X - 10, position.Y + size.Y / 2 - 0, 1, 1
		DrawRect position.X + size.X - 10 - 1, position.Y + size.Y / 2 - 1 - 0, 3, 1
		DrawRect position.X + size.X - 10 - 2, position.Y + size.Y / 2 - 1 - 1, 5, 1
	End

	Method DrawFocusRect(control:Control, round:Bool = False)
		Local alpha:Float = GetAlpha()
		Local oldcolor:Float[] = GetColor()
		SetAlpha(math.Abs(Sin(Millisecs() / 5.0)))
		SystemColors.FocusColor.Activate()
		Local pos:= control.CalculateRenderPosition()
		Local size:= control.Size.Clone()
		If Not round Then
			DrawBox(pos, size)
		Else
			DrawRoundBox(pos, size)
		EndIf
		SetColor 255, 255, 255
		SetAlpha(alpha)
		SetColor oldcolor[0], oldcolor[1], oldcolor[2]

	End
	
	
	Method DrawLabelText(status:Int, position:GuiVector2D, size:GuiVector2D, text:String, align:Int, font:BitmapFont, context:Control = Null)
		'SetColor(Self.ForeColor.r, ForeColor.g, ForeColor.b)
			
		if context then
			context.ForeColor.Activate()
		Else
			SystemColors.WindowTextForeColor.Activate()
		Endif
		#IF TARGET="html5" 
			SetColor(255, 255, 255)
		#END
		Select align
			Case eTextAlign.CENTER 
				font.DrawText(text, int(position.X + size.X / 2), int(position.Y + size.Y / 2 - font.GetFontHeight() / 2), eDrawAlign.CENTER)
			Case eTextAlign.LEFT 
				font.DrawText(text, int(position.X), int(position.Y + size.Y / 2 - font.GetFontHeight() / 2), eDrawAlign.LEFT)
			Case eTextAlign.RIGHT
				font.DrawText(text, int(position.X + size.X), int(position.Y + size.Y / 2 - font.GetFontHeight() / 2), eDrawAlign.RIGHT)
		End
	
	End
	
	Method DrawComboText(status:Int, position:GuiVector2D, size:GuiVector2D, text:String, align:Int, font:BitmapFont, context:Control = Null)
		'SetColor(Self.ForeColor.r, ForeColor.g, ForeColor.b)
			
		if context then
			context.ForeColor.Activate()
		Else
			SystemColors.WindowTextForeColor.Activate()
		Endif
		#IF TARGET="html5" 
			SetColor(255, 255, 255)
		#END
		Select align
			Case eTextAlign.CENTER
				font.DrawText(text, int(position.X + size.X / 2), int(position.Y + size.Y / 2 - font.GetFontHeight() / 2), eDrawAlign.CENTER)
			Case eTextAlign.LEFT
				font.DrawText(text, int(2 + position.X), int(position.Y + size.Y / 2 - font.GetFontHeight() / 2), eDrawAlign.LEFT)
			Case eTextAlign.RIGHT
				font.DrawText(text, int(position.X + size.X - 18), int(position.Y + size.Y / 2 - font.GetFontHeight() / 2), eDrawAlign.RIGHT)
		End
	
	End


	Method DrawControlBackground(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = null)
		If context <> null And context.BackgroundColor <> Null Then
			context.BackgroundColor.Activate()
		Else
			SystemColors.ControlFace.Activate()
		EndIf
		DrawRect(position.X, position.Y, size.X, size.Y)

	End
	
	Method DrawFormBackground(status:Int, position:GuiVector2D, size:GuiVector2D, padding:Padding, text:String, context:Control)
		SystemColors.FormMargin.Activate()
		DrawRect(position.X, position.Y, size.X, size.Y)
		'SetColor(SystemColors.FormMargin.r + 10, SystemColors.FormMargin.g + 10, SystemColors.FormMargin.b + 10)
		SystemColors.FormMargin.ActivateBright(15)
		DrawRect(position.X + 2, position.Y + 2, size.X - 4, padding.Top / 2 - 2)	
		SystemColors.WindowTextForeColor.Activate()
		Local TextY:Int = position.Y + padding.Top / 2 - Gui.systemFont.GetFontHeight / 2
		#IF TARGET="html5"
		SetColor(255, 255, 255)
		#END
		Gui.systemFont.DrawText(text, int(position.X + size.X / 2), TextY, eDrawAlign.CENTER)
		
		If context <> null Then
			context.BackgroundColor.Activate()
		Else
			SystemColors.WindowColor.Activate()
		EndIf
		
		DrawRect(position.X + padding.Left, position.Y + padding.Top, size.X - padding.Left - padding.Right, size.Y - padding.Bottom - padding.Top)
		If HasFlag(status, eControlStatus.FOCUSED) Then
			DrawFocusRect(context)
		Else
			SystemColors.InactiveFormBorder.Activate()
			DrawBox(position, size)
		EndIf

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
			SystemColors.AppWorkspace.Activate()
			DrawRect(position.X + 4, position.Y + 4 + yOffset, CheckBoxSize.X - 9, CheckBoxSize.Y - 8)
		EndIf

	End
	
	Method DrawRadioCheckBox(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null, checked:Bool = True)
		Local yOffset:Int = size.Y / 2 - RadioBoxSize.Y / 2
		If HasFlag(status, eControlStatus.HOOVER) Then
			SystemColors.FocusColor.Activate()
		else
			SystemColors.ButtonBorderColor.Activate()
		EndIf
		DrawOval(position.X, position.Y + yOffset, RadioBoxSize.X, RadioBoxSize.Y)

		SystemColors.ControlFace.Activate()
		DrawOval(position.X + 1, position.Y + 1 + yOffset, RadioBoxSize.X - 2, RadioBoxSize.Y - 2)
		'DrawRoundBox(int(drawPos.X), int(drawPos.Y + yOffset), BoxSize, BoxSize)
		If checked Then
			SystemColors.FocusColor.Activate()
			DrawOval(position.X + 2, position.Y + 2 + yOffset, RadioBoxSize.X - 4, RadioBoxSize.Y - 4)
		EndIf
	End
	
	Method RadioBoxSize:GuiVector2D() Property
		Return _radioBoxSize
	End
	
	Method CheckBoxSize:GuiVector2D() Property
		Return _checkBoxSize
	End
	
	Method InitRenderer()
		
	End
	
	Private
	Field _radioBoxSize:= New GuiVector2D
	Field _checkBoxSize:= New GuiVector2D
	
	Global defaultSystemFont:BitmapFont
	Global defaultTipFont:BitmapFont
	 
	Private
	Field _guiAttached:= New EventHandler<EventArgs>
	Field _guiDetached:= New EventHandler<EventArgs>
	'Method ResetRendererValues()
	'	renderer.ResetRendererValues(Self)
	'End
End

Function ResetRendererValues(renderer:GuiRenderer)
		'Reset Renderer metrics:
		renderer._radioBoxSize.SetValues(12, 12)
		renderer._checkBoxSize.SetValues(12, 12)
		
		'Reset Renderer typo:
		
		If GuiRenderer.defaultSystemFont = Null Then
			#IF TARGET="html5"
				GuiRenderer.defaultSystemFont = New BitmapFont("html5font.txt")
				GuiRenderer.defaultTipFont = New BitmapFont("html5TipFont.txt")
			#ELSE
				GuiRenderer.defaultSystemFont = New BitmapFont("smallfont1.txt")
				GuiRenderer.defaultTipFont = New BitmapFont("TipFont.txt")
			#END
		End
		If Gui.systemFont <> GuiRenderer.defaultSystemFont Then Gui.systemFont = GuiRenderer.defaultSystemFont
		If Gui.tipFont <> GuiRenderer.defaultTipFont Then Gui.tipFont = GuiRenderer.defaultTipFont

		'Reset Renderer colors:
		
		SystemColors.ControlFace.SetColor(1, 220, 220, 220)
		SystemColors.ButtonBorderColor.SetColor(1, 182, 182, 182)
		SystemColors.FocussedButtonBorderColor.SetColor(1, 69, 216, 251)
		SystemColors.AppWorkspace.SetColor(1, 171, 171, 171)
		SystemColors.FocusColor.SetColor(1, 60, 127, 177)
		SystemColors.FormBorder.SetColor(1, 185, 209, 234)
		SystemColors.WindowColor.SetColor(1, 255, 255, 255)
		SystemColors.FormMargin.SetColor(1, 174, 199, 225)
		SystemColors.InactiveFormBorder.SetColor(1, 120, 120, 120)
		SystemColors.SelectedItemBackColor.SetColor(1, 51, 153, 255)
		SystemColors.HooverBackgroundColor.SetColor(1, 255, 255, 255)
		#IF TARGET<>"html5"
			SystemColors.WindowTextForeColor.SetColor(1, 0, 0, 0)
			SystemColors.SelectedItemForeColor.SetColor(1, 255, 255, 255)
		#ELSE 
			SystemColors.WindowTextForeColor.SetColor(1, 255, 255, 255)
			SystemColors.SelectedItemForeColor.SetColor(1, 255, 255, 255)
		#END


	
End