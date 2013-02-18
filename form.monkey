Import junglegui
Import mojo.input
Import "data/close_button.png"

Class Form Extends TopLevelControl
	
	Method New()
		BackgroundColor = SystemColors.AppWorkspace
		Size.SetValues(400, 400)
		'Padding.Left = 5
		'Padding.Top = 25
		'Padding.Right = 5
		'Padding.Bottom = 5
		'Padding = GetGui.Renderer.DefaultFormPadding
	End
	Method InitForm(gui:Gui)
		Super.InitForm(gui)
		Padding = gui.Renderer.DefaultFormPadding
	End
	
	Method RenderBackground()
		Local drawPos:GuiVector2D = CalculateRenderPosition()
		
		GetGui.Renderer.DrawFormBackground(Status, drawPos, Size, Padding, Text, Self)
		
		'SystemColors.FormMargin.Activate()
		'DrawRect(drawPos.X, drawPos.Y, Size.X, Size.Y)
		'SetColor(255, 255, 255)
		'SetAlpha(0.2)
		'DrawRect(drawPos.X + 2, drawPos.Y + 2, Size.X - 4, Padding.Top / 2 - 2)
		'SetAlpha(1)
		'ForeColor.Activate()
		'Local TextY:Int = drawPos.Y + Padding.Top / 2 - Gui.systemFont.GetFontHeight / 2
		'Gui.systemFont.DrawText(Text, int(drawPos.X + Self.Size.X / 2), TextY, eDrawAlign.CENTER)
		
		'BackgroundColor.Activate()
		'DrawRect(drawPos.X + Padding.Left, drawPos.Y + Padding.Top, Size.X - Padding.Left - Padding.Right, Size.Y - Padding.Bottom - Padding.Top)
		'if HasFocus Then
		'	DrawFocusRect(Self)
		'Else
		'	SystemColors.InactiveFormBorder.Activate()
		'	DrawBox(drawPos, Self.Size)
		'EndIf
		If ControlBox then RenderControlBox(drawPos)
	End
	Method RenderControlBox(FormScreenPos:GuiVector2D)
		SystemColors.ControlFace.Activate()
		Select ControlBoxMetrics.align
			Case BoxMetrics.HALIGN_LEFT
				_cacheDrawPos.X = FormScreenPos.X + ControlBoxMetrics.Offset.X
				_cacheDrawPos.Y = FormScreenPos.Y + ControlBoxMetrics.Offset.Y
			Default
				_cacheDrawPos.X = FormScreenPos.X + Self.Size.X - ControlBoxMetrics.Size.X - ControlBoxMetrics.Offset.X	
				_cacheDrawPos.Y = FormScreenPos.Y +  ControlBoxMetrics.Offset.Y	
		End
		SetColor(255,255,255)
		SetAlpha(.3)
		DrawImage(_imageCloseButton,_cacheDrawPos.X, _cacheDrawPos.Y)
		SetAlpha(1)
	End
	 
	Method Update()
		Super.Update()
		
		If resizeStatus = eResizeStatus.NONE
				If mouseIsDown Then	'Añadir propiedad "resizable true or false"
					Self.Position.X = GetGui.MousePos.X - _mouseHitPos.X
					Self.Position.Y = GetGui.MousePos.Y - _mouseHitPos.Y
				EndIf
			
		Else
			If HasFlag(resizeStatus, eResizeStatus.RESIZE_RIGHT)
				Local dif:Int = mouseHitSize.X - _mouseHitPos.X
				Local newSize:Int = GetGui.MousePos.X - Self.Position.X + dif
				If newSize < minimumSize.X Then newSize = minimumSize.X
				If newSize < 10 Then newSize = 10
				Self.Size.X = newSize
			End
			If HasFlag(resizeStatus, eResizeStatus.RESIZE_BOTTOM)
				Local dif:Int = mouseHitSize.Y - _mouseHitPos.Y
				Local newSize:Int = GetGui.MousePos.Y - Self.Position.Y + dif
				If newSize < minimumSize.Y Then newSize = minimumSize.Y
				If newSize < 10 Then newSize = 10
				Self.Size.Y = newSize
			End
		End
		'Self.Text = GetGui.MousePos.X + ", " + GetGui.MousePos.Y
	End
	
	Method Text:String() Property
		Return _text
	End
		
	Method Text:String(value:String) property 
		_text = value
		Return _text
	End
		
	Method Msg(msg:BoxedMsg)
		if msg.sender = Self Then
			Select msg.e.eventSignature
				Case  eMsgKinds.INIT_FORM 
					_InitInternalForm
				Case eMsgKinds.MOUSE_DOWN
					_CheckMouseDown(msg.sender, msg.e)
				Case eMsgKinds.MOUSE_UP
					_CheckMouseUp(msg.sender, msg.e)
				Case eMsgKinds.GOT_FOCUS
					Self.BringToFront()
				Case eMsgKinds.MOUSE_MOVE
					_CheckMouseMove(msg.sender, msg.e)
			End
		endif
		Super.Msg(msg)
	End
	
	Method ControlBox:Bool() Property
		Return _controlBox
	End
	
	Method ControlBox:Void(value:Bool) Property
		_controlBox = value
	End
	
	Method ControlBoxMetrics:BoxMetrics() Property
		Return _BoxPos
	End
	
	'Summary: This property is the form border style (resizable or fixed).<br>The constants are defined as <u>eFormBorder</u>.<b>FIXED</b> and <u>eFormBorder</u>.<b>RESIZABLE</b> 
	Method BorderStyle:Int() Property
		Return borderKind
	End
	
	Method BorderStyle:Void(value:Int) Property
		borderKind = value
	End
	
	'summary: This readonly property returns the minimum size that the user will be able to give to this form when it has a resizable border. Notice this does not affect programatical resizing of the form. It affects only interactive resizing made by the application user.
	Method MinumumSize:GuiVector2D() Property
		Return minimumSize
	End
	
	'summary: Returns the eResizeStatus const that informs on mouse-over resizing status.<br>That's useful to draw resizing interactive media on a form border.
	Method GetMouseOverReisingStatus:Int()
		Return Self.mouseOverStatus
	End
	
	Private
	
	Field _text:String = "Untitled form"
	Field _BoxPos:= New BoxMetrics 
	Field _cacheDrawPos:=New GuiVector2D 
	
	Method _InitInternalForm()
		_BoxPos.Offset.SetValues(5,5)
		_BoxPos.align = BoxMetrics.HALIGN_RIGHT
		minimumSize.SetValues(50, 50)
		if _imageCloseButton = null then _imageCloseButton = LoadImage("close_button.png")
		_BoxPos.Size.SetValues(_imageCloseButton.Width ,_imageCloseButton.Height)
		BackgroundColor = SystemColors.WindowColor
	End
	
	Field mouseIsDown:Bool = False, _mouseHitPos:GuiVector2D
	Field mouseHitSize:= New GuiVector2D
	Method _CheckMouseDown(sender:Object, e:EventArgs)
			
		BringToFront()
				
		Local mousee:MouseEventArgs = MouseEventArgs(e)
		if mousee = null Then Return
		mouseIsDown = true
		If _mouseHitPos = Null Then _mouseHitPos = New GuiVector2D
		_mouseHitPos.SetValues(mousee.position.X, mousee.position.Y)
		mouseHitSize.SetValues(Size.X, Size.Y)
		
		'Determine click area:
		resizeStatus = _getMouseOverResizingStatus(mousee)
		
		
	End
	
	Method _CheckMouseMove(sender:Object, e:EventArgs)
		'Determine click area:
		Local mousee:MouseEventArgs = MouseEventArgs(e)
		if mousee = null Then Return
		mouseOverStatus = _getMouseOverResizingStatus(mousee)
	End
	
	Method _getMouseOverResizingStatus:Int(mousee:MouseEventArgs)
		Local status:Int = eResizeStatus.NONE
		If borderKind = eFormBorder.RESIZABLE Then
			If mousee.position.X > Self.Size.X - Padding.Right Then status |= eResizeStatus.RESIZE_RIGHT
			If mousee.position.Y > Self.Size.Y - Padding.Bottom Then status |= eResizeStatus.RESIZE_BOTTOM
		EndIf
		Return status
	End
	
	Method _CheckMouseUp(Sender:Object, e:EventArgs)
		If resizeStatus <> eResizeStatus.NONE Then resizeStatus = eResizeStatus.NONE
		mouseIsDown = false		
	End
	
	Global _imageCloseButton:Image
	
	Field _controlBox:Bool = true
	
	'Const SIZEMARGIN:Int = 10
	
	Field resizeStatus:Int = eResizeStatus.NONE
	
	Field mouseOverStatus:Int = eResizeStatus.NONE
	
	Field minimumSize:= New GuiVector2D
	
	Field borderKind = eFormBorder.RESIZABLE
	
End

Class eResizeStatus
	Const NONE:Int = 0
	Const RESIZE_RIGHT:Int = 1
	Const RESIZE_BOTTOM:Int = 2
End


Class eFormBorder
	Const FIXED:Int = 1
	Const RESIZABLE:Int = 0
End
Class BoxMetrics
	Field align:Int = BoxMetrics.HALIGN_RIGHT 
	Const HALIGN_RIGHT:Int = 0
	Const HALIGN_LEFT:Int = 1
	'summary: Readonly Offset position for the ControlBox sub-component
	Method Offset:GuiVector2D() Property
		Return _offset
	End
	Method Size:GuiVector2D() Property
		Return _size
	End
	
	Private
	Field _offset:=New GuiVector2D
	Field _size:=New GuiVector2D
End