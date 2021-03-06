#rem monkeydoc Module junglegui.renderer
	This module contains the implementation of the base JungleGui renderer. That is, the jungle gui skin.
#END

Import junglegui
Import "data/sombra01.png"
Import "data/sombra02.png"
#REFLECTION_FILTER+="${MODPATH}"

#Rem monkeydoc
	This is the base Jungle Gui renderer class. It's used to handle all controls drwing into the graphics canvas.<br>
	If you want to create your own skin for a JungleGui application, all you have to do is create your own renderer extending this one as the basis.<br>
	Most of the drawing commands include this parameters:
	
| Parameter | Description
| status:Int | This parameter is a construction of [[eControlStatus]] value(s) and indicates if the control being drawn has focus, has the mouse over it, etc.
| position:[[GuiVector2D]] | This parameter indicates the position in the graphics canvas where the draw operation should be done.
| size:[[GuiVector2D]] | This is the size of the area that needs to be rendered. It's usually the size of the control being drawn.
| context:[[Control]] | This can be Null for generic rendering, or a control. If the context parameter is not null, elements such as BackgroundColor, Border, Text, etc... have to be token form the context control.

#END
 
Class GuiRenderer

	#Rem monkeydoc
	This is an event that is fired everytime this renderer is attached to a Gui.
	#END
	Method Event_GuiAttached:EventHandler<EventArgs>() Property; Return _guiAttached; End
	#Rem monkeydoc
	This is an event that is fired everytime this renderer is detached from a Gui.
	#END
	Method Event_GuiDetached:EventHandler<EventArgs>() Property; Return _guiDetached; End

	Method New()
		ResetRendererValues(Self)
	End

	Method ScrollerGrabberWidth:Int()
		Return 17
	End
	
	#Rem monkeydoc
	This method should return the default form padding. That is, the space used to draw the caption and borders of any form control.
	This method should not be overriden. If you want to modify the default form padding, just modify the values of the padding returned by the property
	#END
	Method FormBordersSize:Padding() Property
		Return _defaultFormPadding
	End
	
	#Rem monkeydoc
		This method will draw the default background of a button-like contol.
	#END
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
	#rem monkeydoc
		This method will be called whenever a control needs to draw its border.
	#END
	Method DrawControlBorder(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null)
		if context then context.BorderColor.Activate() Else SystemColors.ButtonBorderColor.Activate()
		DrawRoundBox(position, size)
	End
	
	#rem monkeydoc
		This method will be called whenever a Button needs to draw its focus rectangle.
	#END
	Method DrawButtonFocusRect(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null)
		SystemColors.FocusColor.Activate
		SetAlpha 0.2
		DrawRect(position.X + 1, position.Y + 1, size.X - 2, size.Y - 2)
		SetAlpha 1
	End
	 
	#rem monkeydoc
		This method will be called whenever a Drop-down combo box needs to draw its down arrow.
	#END
	Method DrawComboArrow(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null)
		SetColor 0,0,0
		DrawRect position.X + size.X - 10, position.Y + size.Y / 2 - 0, 1, 1
		DrawRect position.X + size.X - 10 - 1, position.Y + size.Y / 2 - 1 - 0, 3, 1
		DrawRect position.X + size.X - 10 - 2, position.Y + size.Y / 2 - 1 - 1, 5, 1
	End

	#rem monkeydoc
		This method will be called whenever a control needs to draw its focus rectangle.
	#END
	Method DrawFocusRect(control:Control, round:Bool = False)
		Local alpha:Float = GetAlpha()
		Local oldcolor:Float[] = GetColor()
		SetAlpha(math.Abs(Sin(Millisecs() / 5.0)))
		SystemColors.FocusColor.Activate()
		Local pos:= control.UnsafeRenderPosition()
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
	
		
	#rem monkeydoc
		This method will be called whenever a control needs to draw its centered text. that's common rendering of Label controls, but also applies to Buttons and other controls.
	#END
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
	
	#rem monkeydoc
		This method will be called whenever a combo-box dropdown control needs to draw its text.
	#END
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


	#rem monkeydoc
		This method will be called whenever a control needs to draw its solid background.
	#END
	Method DrawControlBackground(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null)
		If context <> Null And context.BackgroundColor <> Null Then
			context.BackgroundColor.Activate()
		Else
			SystemColors.ControlFace.Activate()
		EndIf
		DrawRect(position.X, position.Y, size.X, size.Y)
	End
	
	#rem monkeydoc
		This method will be called whenever a control needs to draw its solid background, and the control can be selected. This is typical for ListViewItems. 
	#END
	Method DrawHooverSelectableBackground(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null, selected:Bool)
		If selected = False And HasFlag(status, eControlStatus.HOOVER) = False Then
			DrawControlBackground(status, position, size, context)
		Else
			If selected Then
				SystemColors.ItemsListSelectedBackColor.Activate()
			Else
				SystemColors.ItemsListHooverBackColor.Activate()
			EndIf
			DrawRect(position.X, position.Y, size.X, size.Y)
			
			If selected Then
				SystemColors.ItemsListSelectedBorderColor.Activate()
			Else
				SystemColors.ItemsListHooverBorderColor.Activate()
			EndIf
			DrawBox(position.X, position.Y, size.X, size.Y)

						
		EndIf
	End
	
	#rem monkeydoc
		This method will be called whenever a Form needs to draw its background, including the header part, borders, shadows, etc. 
	#END
	Method DrawFormBackground(status:Int, position:GuiVector2D, size:GuiVector2D, padding:Padding, text:String, context:Control)

		SystemColors.FormMargin.Activate()
		DrawRect(position.X, position.Y, size.X, padding.Top) 'size.Y)

		If context = Null or Form(context) = Null Then
			SystemColors.WindowColor.Activate()
		Else
			Local f:= Form(context)
			f.BackgroundColor.Activate()
		EndIf
		DrawRect(position.X, position.Y + padding.Top, size.X, size.Y - padding.Top)
		
		SystemColors.FormMargin.ActivateBright(15)
		DrawRect(position.X + 2, position.Y + 2, size.X - 4, padding.Top / 2 - 2)
		SystemColors.WindowTextForeColor.Activate()
		Local TextY:Int = position.Y + padding.Top / 2 - Gui.systemFont.GetFontHeight / 2
		#IF TARGET="html5"
		SetColor(255, 255, 255)
		#END
		Gui.systemFont.DrawText(text, int(position.X + size.X / 2), TextY, eDrawAlign.CENTER)
		Local resizeStatus:Int = eResizeStatus.NONE
		If context <> null Then
			context.BackgroundColor.Activate()
			If Form(context) <> Null Then
				Local f:= Form(context)
				If HasFlag(status, eControlStatus.HOOVER) Then resizeStatus = f.GetMouseOverReisingStatus()
			EndIf
		Else
			SystemColors.WindowColor.Activate()
		EndIf
		
		DrawRect(position.X + padding.Left,
			position.Y +padding.Top,
			size.X -padding.Left - padding.Right,
			size.Y - padding.Bottom - padding.Top)
			
		If HasFlag(resizeStatus, eResizeStatus.RESIZE_RIGHT)
			'SystemColors.HooverBackgroundColor.ActivateBright(Sin(Millisecs() / 2.0) * 40)
			SystemColors.FormMargin.ActivateBright(Sin(Millisecs() / 2.0) * 10)
			DrawRect(position.X + size.X - padding.Left, position.Y, padding.Left, size.Y)
		EndIf
		If HasFlag(resizeStatus, eResizeStatus.RESIZE_BOTTOM)
			SystemColors.FormMargin.ActivateBright(Sin(Millisecs() / 2.0) * 40)
			DrawRect(position.X, position.Y + size.Y - 5, size.X, 5)
		EndIf
		
		If HasFlag(status, eControlStatus.FOCUSED) Then
			DrawFocusRect(context)
		Else
			SystemColors.InactiveFormBorder.Activate()
			DrawBox(position, size)
		EndIf

		SetScissor(0, 0, DeviceWidth, DeviceHeight)
		
		If context <> Null Then
			If context = context.GetGui.ActiveTopLevelControl Then
				SetAlpha(1)
			Else
				SetAlpha(0.5)
			EndIf
			SetColor(255, 255, 255)
			Const ShadowSize:Float = 1
			If shadow2 = Null Then shadow2 = LoadImage("sombra02.png")
			If shadow1 = Null Then shadow1 = LoadImage("sombra01.png")
			'SetAlpha(1)
			If shadow2 <> Null Then
				'Up and down:
				DrawImage(shadow2, position.X, position.Y + size.Y, 0, Float(size.X) / shadow2.Width, ShadowSize)
				DrawImage(shadow2, position.X + size.X, position.Y, 180, Float(size.X) / shadow2.Width, ShadowSize)
				
				'Right:
				DrawImage(shadow2, position.X + size.X, position.Y + size.Y, 90, Float(size.Y) / shadow2.Width, ShadowSize)
				
				'Left:
				DrawImage(shadow2, position.X, position.Y, 270, Float(size.Y) / shadow2.Width, ShadowSize)
			End
			If shadow1 <> Null Then
				DrawImage(shadow1, position.X, position.Y, 180, ShadowSize, ShadowSize)
				DrawImage(shadow1, position.X, position.Y + size.Y, 270, ShadowSize, ShadowSize)
				DrawImage(shadow1, position.X + size.X, position.Y + size.Y, 0, ShadowSize, ShadowSize)
				DrawImage(shadow1, position.X + size.X, position.Y, 90, ShadowSize, ShadowSize)
			EndIf
			SetAlpha(1)
		EndIf
	End
 	#rem monkeydoc
		This method will be called whenever a control needs to draw a CheckBox mark.
	#END
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
			SystemColors.ButtonBorderColor.ActivateDark(50)
			DrawRoundBox(position.X + 2, position.Y + 2 + yOffset, CheckBoxSize.X - 4, CheckBoxSize.Y - 4)
			DrawRect(position.X + 3, position.Y + 3 + yOffset, CheckBoxSize.X - 6, CheckBoxSize.Y - 6)
		Else
			SystemColors.ControlFace.ActivateBright()
			DrawRoundBox(position.X + 2, position.Y + 2 + yOffset, CheckBoxSize.X - 4, CheckBoxSize.Y - 4)
			DrawRect(position.X + 3, position.Y + 3 + yOffset, CheckBoxSize.X - 6, CheckBoxSize.Y - 6)
		
		EndIf

	End
	
 	#rem monkeydoc
		This method will be called whenever a control needs to draw a circular selectable RadioButton mark.
	#END
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
	
 	#rem monkeydoc
		This method will be called whenever a control needs to measure the size of a RadioBox mark..
	#END
	Method RadioBoxSize:GuiVector2D() Property
		Return _radioBoxSize
	End
	
 	#rem monkeydoc
		This method will be called whenever a control needs to measure the size of a CheckBox mark..
	#END
	Method CheckBoxSize:GuiVector2D() Property
		Return _checkBoxSize
	End
	
 	#rem monkeydoc
		This method will be called whenever the Renderer needs to load its resources.
		If you're creating your own renderer, you should place any loading resources code in an overload of this method.
	#END
	Method InitRenderer()
		SystemColors.FormMargin.SetColor(1, 200, 200, 200)
		SystemColors.SelectedItemBackColor.SetColor(1, 151, 153, 145)

	End
	
 	#rem monkeydoc
		This method will be called whenever the Renderer needs to unload its resources.
		If you're creating your own renderer, you should place any freeing resources code in an overload of this method.
	#END
	Method FreeResources()
		If shadow1 <> Null Then shadow1.Discard()
		If shadow2 <> Null Then shadow2.Discard()
		shadow1 = Null
		shadow2 = Null
	End
	
	Method DrawFormControlBox(location:GuiVector2D, enabled:Bool, context:Control)
		'DrawButtonBackground(0, location, FormControlBoxMetrics.Size, Null)
		SetColor(255, 240, 240)
		DrawRect(location.X + 1, location.Y + 1, FormControlBoxMetrics.Size.X - 2, FormControlBoxMetrics.Size.Y - 2)
		DrawControlBorder(0, location, FormControlBoxMetrics.Size, Null)
		'DrawRoundBox(location.X + 3, location.Y + 3, FormControlBoxMetrics.Size.X - 6, FormControlBoxMetrics.Size.Y - 6)
		
	End
	
	Method FormControlBoxMetrics:BoxMetrics()
		Return _defaultBoxMetrics
	End
	
	Private
	Field _radioBoxSize:= New GuiVector2D
	Field _checkBoxSize:= New GuiVector2D
	
	Global defaultSystemFont:BitmapFont
	Global defaultTipFont:BitmapFont
	 
	Private
	Field _guiAttached:= New EventHandler<EventArgs>
	Field _guiDetached:= New EventHandler<EventArgs>
	
	Field shadow1:Image
	Field shadow2:Image
	
	Global _defaultFormPadding:= New Padding
	Global _defaultBoxMetrics:= New BoxMetrics
	'Method ResetRendererValues()
	'	renderer.ResetRendererValues(Self)
	'End
End

#rem monkeydoc
	This function is automatically called by the Gui system whenever the Gui system goes from one Renderer to another Renderer. It leaves everything on its default status in between.
#END
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

		If renderer._defaultFormPadding = Null Then
			renderer._defaultFormPadding = New Padding
		EndIf
		renderer._defaultFormPadding.Left = 5 ' Gui.systemFont.
		renderer._defaultFormPadding.Right = 5 ' Gui.systemFont.
		renderer._defaultFormPadding.Bottom = 5 ' Gui.systemFont.
		renderer._defaultFormPadding.Top = Gui.systemFont.GetFontHeight + 10

		renderer._defaultBoxMetrics.align = BoxMetrics.HALIGN_RIGHT
		renderer._defaultBoxMetrics.Offset.SetValues(5, 5)
		renderer._defaultBoxMetrics.Size.X = renderer._defaultFormPadding.Top - renderer._defaultBoxMetrics.Offset.Y * 2
		renderer._defaultBoxMetrics.Size.Y = renderer._defaultBoxMetrics.Size.X
		'Reset Renderer colors:
		
		SystemColors.ControlFace.SetColor(1, 220, 220, 220)
		SystemColors.ButtonBorderColor.SetColor(1, 182, 182, 182)
		SystemColors.FocussedButtonBorderColor.SetColor(1, 69, 216, 251)
		SystemColors.AppWorkspace.SetColor(1, 171, 171, 171)
		SystemColors.FocusColor.SetColor(1, 60, 127, 177)
		SystemColors.FormBorder.SetColor(1, 100, 110, 135)
		SystemColors.WindowColor.SetColor(1, 255, 255, 255)
		SystemColors.InactiveFormBorder.SetColor(1, 120, 120, 120)
		SystemColors.HooverBackgroundColor.SetColor(1, 255, 255, 255)
		SystemColors.FormMargin.SetColor(1, 200, 200, 200)
		SystemColors.SelectedItemBackColor.SetColor(1, 151, 153, 145)

		#IF TARGET<>"html5"
			SystemColors.WindowTextForeColor.SetColor(1, 0, 0, 0)
			SystemColors.SelectedItemForeColor.SetColor(1, 255, 255, 255)
		#ELSE 
			SystemColors.WindowTextForeColor.SetColor(1, 255, 255, 255)
			SystemColors.SelectedItemForeColor.SetColor(1, 255, 255, 255)
		#END
		SystemColors.ItemsListHooverBackColor.SetColor(1, 236, 244, 253)
		SystemColors.ItemsListSelectedBackColor.SetColor(1, 202, 225, 252)
		SystemColors.ItemsListHooverBorderColor.SetColor(1, 184, 214, 251)
		SystemColors.ItemsListSelectedBorderColor.SetColor(1, 125, 162, 206)
		
		SystemColors.ScrollerBackColor.SetColor(1, 230, 230, 230)
		SystemColors.ScrollerGrabberColor.SetColor(1, 220, 220, 220)
		
		
		

End