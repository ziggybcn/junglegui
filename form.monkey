Import junglegui
Import mojo.input
Import "data/close_button.png"

Class Form Extends TopLevelControl
	
	Method New()
		BackgroundColor = SystemColors.AppWorkspace.Clone()
		Size.SetValues(400, 400)
		Padding.Left = 5
		Padding.Top = 25
		Padding.Right = 5
		Padding.Bottom = 5
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
		'DrawRect(_cacheDrawPos.X ,_cacheDrawPos.Y,ControlBoxMetrics.Size.X, ControlBoxMetrics.Size.Y)
		'SystemColors.FocusColor.Activate()
		'DrawBox(_cacheDrawPos,ControlBoxMetrics.Size)
		'Gui.systemFont.DrawText("X",_cacheDrawPos.X+ControlBoxMetrics.Size.X/2, _cacheDrawPos.Y, eDrawAlign.CENTER )
		SetColor(255,255,255)
		SetAlpha(.3)
		DrawImage(_imageCloseButton,_cacheDrawPos.X, _cacheDrawPos.Y)
		SetAlpha(1)
	End
	 
	Method Update()
		Super.Update()
		if mouseIsDown Then
			Self.Position.X = GetGui.MousePos.X - _mouseHitPos.X
			Self.Position.Y = GetGui.MousePos.Y - _mouseHitPos.Y
		EndIf		
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
			end
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
	
	
	Private
	
	Field _text:String = "Untitled form"
	Field _BoxPos:= New BoxMetrics 
	Field _cacheDrawPos:=New GuiVector2D 
	
	Method _InitInternalForm()
		_BoxPos.Offset.SetValues(5,5)
		_BoxPos.align = BoxMetrics.HALIGN_RIGHT 
		if _imageCloseButton = null then _imageCloseButton = LoadImage("close_button.png")
		_BoxPos.Size.SetValues(_imageCloseButton.Width ,_imageCloseButton.Height)
		BackgroundColor = SystemColors.WindowColor.Clone()
	End
	
	Field mouseIsDown:Bool = false, _mouseHitPos:GuiVector2D
	Method _CheckMouseDown(sender:Object, e:EventArgs)
		BringToFront()
		Local mousee:MouseEventArgs = MouseEventArgs(e)
		if mousee = null Then Return
		mouseIsDown = true
		_mouseHitPos = New GuiVector2D
		_mouseHitPos.SetValues(mousee.position.X, mousee.position.Y)
	End
	
	Method _CheckMouseUp(Sender:Object, e:EventArgs)
		mouseIsDown = false		
	End
	
	Global _imageCloseButton:Image
	
	Field _controlBox:Bool = true
	
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