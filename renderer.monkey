Import junglegui
 
Class GuiRenderer

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
		SetAlpha 0.2
		SystemColors.FocusColor.Activate
		DrawRect(position.X + 1, position.Y + 1, size.X - 2, size.Y - 2)
		SetAlpha 1
	End
	 
	Method DrawLabelText(status:Int, position:GuiVector2D, size:GuiVector2D, text:String, align:Int, Font:BitmapFont, context:Control = Null)
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
				Font.DrawText(text, int(position.X + size.X / 2), int(position.Y + size.Y / 2 - Font.GetFontHeight() / 2), eDrawAlign.CENTER)
			Case eTextAlign.LEFT 
				Font.DrawText(text, int(position.X), int(position.Y + size.Y / 2 - Font.GetFontHeight() / 2), eDrawAlign.LEFT)
			Case eTextAlign.RIGHT
				Font.DrawText(text, int(position.X + size.X), int(position.Y + size.Y / 2 - Font.GetFontHeight() / 2), eDrawAlign.RIGHT)
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
		
		If context <> null Then
			context.ForeColor.Activate()
		Else
			SystemColors.WindowTextForeColor.Activate()
		EndIf
		Local TextY:Int = position.Y + padding.Top / 2 - Gui.systemFont.GetFontHeight / 2
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
	
	Method DrawFormClientArea(control:Control, position:GuiVector2D, size:GuiVector2D)
		
	End
	 
	Method DrawCheckBox(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = null, BoxSize:Int = 16, checked:Bool = True)
		SystemColors.ControlFace.Activate()
		Local yOffset:Int = size.Y / 2 - BoxSize / 2
		DrawRect(position.X + 1, position.Y + 1 + yOffset, BoxSize - 2, BoxSize - 2)
		If HasFlag(status, eControlStatus.HOOVER) Then
			SystemColors.FocusColor.Activate()
		Else
			SystemColors.ButtonBorderColor.Activate()
		EndIf
		
		DrawRoundBox(int(position.X), int(position.Y + yOffset), BoxSize, BoxSize)
		If checked Then
			SystemColors.AppWorkspace.Activate()
			DrawRect(position.X + 4, position.Y + 4 + yOffset, BoxSize - 9, BoxSize - 8)
		EndIf

	End
	
	Method DrawRadioBoxcontrol(control:Control, position:GuiVector2D, size:GuiVector2D, checked:bool)
	
	End
	

	Method DrawPanelBackground(control:Control, position:GuiVector2D, size:GuiVector2D)
		
	End
	
	Method DrawProgressBar(control:Control, position:GuiVector2D, size:GuiVector2D)
		
	End
	
	Method DrawHorizontalSliderGrabber(control:Control, position:GuiVector2D, size:GuiVector2D)
		
	End
	
	
	Method DrawVerticalSliderGrabber(control:Control, position:GuiVector2D, size:GuiVector2D)
		
	End
	
	Method GetSliderGrabberSizes:GuiVector2D()
		
	End
	
	Method SetDefaultFormPadding(form:Form)
		
	End
	
End

Class eControlStatus 

	'summary: Represents a regular control status
	Const NONE:Int = 0

	'summary: Represents a focused status
	Const FOCUSED:Int = 1

	'summary: Represents a Focused status
	Const HOOVER:Int = 2

	'summary: Represents a disabled status
	Const DISABLED:Int = 4
	
End Class