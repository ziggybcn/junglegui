Import junglegui

 
Class GuiRenderer

	Method DrawButtonBackground(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null)

		if HasFlag(status, eControlStatus.HOOVER) then
			if context then context.HooverColor.Activate() Else SystemColors.HooverBackgroundColor.Activate()
		else
			if context then context.BackgroundColor.Activate() Else SystemColors.ControlFace.Activate()
		EndIf
		
		DrawRect(position.X + 1, position.Y + 1, size.X - 2, size.Y - 2)
		
		SetAlpha(.5)
		SetColor(255,255,255)
		DrawRect(position.X + 1, position.Y + 1, size.X - 2, size.Y / 2)
		SetAlpha(1)
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
	
	Method DrawFormBackground(control:Control, position:GuiVector2D, size:GuiVector2D)
		
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
	
	Method DrawFocusRect(control:Control, position:GuiVector2D, size:GuiVector2D)
	
	end
	
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