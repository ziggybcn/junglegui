Import junglegui
Private 
Import mojo
public
Const TEXTVALIDCHARS:String = "+-*/=~q!@#$%&()?[]çÇñÑáéíóúàèìòùâêîôûäëïöüÁÉÍÓÚÀÈIÒÙÄËÏÖÜÂÊÎÔÛýÝ€0123456789,.:;{}¨'`´~|\ºª<>"

Class TextField extends BaseLabel

	Method CaretPos:Int() Property
		Return _caretPos
	End
	
	Method CaretPos:Void(value:Int) Property
		_caretPos = value
		if _caretPos<0 Then _caretPos = 0
		if _caretPos > Text.Length Then _caretPos = Text.Length 'It can be one more than the length
	End

	
	Method BorderColor:GuiColor() Property
		Return _bordercolor
	End
	Method BorderColor:GuiColor(value:GuiColor) Property
		if value <> null then _bordercolor = value
		Return _bordercolor
	End
	Method Render:Void()
		Const LEFTMARGIN:Int = 12
		Local Position:= CalculateRenderPosition
		Self.BackgroundColor.Activate()
		DrawRect(Position.X, Position.Y, Size.X, Size.Y)
		if GetGui.GetMousePointedControl = self and GetGui.ActiveControl <> self then
			SystemColors.FocusColor.Activate()
		Else
			Self.BorderColor.Activate
		EndIf
		DrawBox(Position, Size)
		local TextY:Int = Position.Y + Size.Y / 2 - Font.GetFontHeight / 2
		if GetGui.ActiveControl = Self Then
			Local text1:String = Text[ .. _caretPos]
			Local text2:String = Text[_caretPos ..]
			ForeColor.Activate()
			Font.DrawText(text1, Position.X - _drawOffset, TextY)
			
			Local xsize:Int = Font.GetTxtWidth(text1 + " ") - Font.GetFaceInfo(" "[0]).drawingWidth  '- Font.GetFaceInfo(" "[0]).drawingOffset.x
			
			SetAlpha(Abs(Sin(Millisecs() / 3.0)))
			BorderColor.Activate()
			DrawRect(Position.X + xsize - _drawOffset + 3, Position.Y, 1, Size.Y)
			xsize += 4
			if _drawOffset < 0 Then
				SetAlpha(1)
				DrawRect(Position.X, Position.Y, _drawOffset * -1, Size.Y)
			EndIf
			SetAlpha(1)
			ForeColor.Activate()
			Font.DrawText(text2, Position.X + xsize - _drawOffset, TextY)
			DrawFocusRect(Self)
			Local caretXPos:Int = xsize - _drawOffset
			if caretXPos >= (Size.X - Size.X / 4)
				Local sum:Int = (caretXPos - Size.X) / 2
				if sum<1 Then sum = 1
				_drawOffset += sum
			ElseIf(caretXPos < LEFTMARGIN And Size.X > LEFTMARGIN) or (caretXPos < 0)
				Local sum:Int = (xsize - _drawOffset) / 2
				if sum > - 1 Then sum = - 1
				_drawOffset += sum
			EndIf
		else
			'_drawOffset = 0 
			ForeColor.Activate()
			Font.DrawText(Text, Position.X - _drawOffset, TextY)
		EndIf
		'Font.DrawText(
	End
	Method New()
		_InitComponent()
	End

	
	Method Msg:Void(sender:Object,e:EventArgs)
		'Print("Got event!")
		if e.eventSignature = eEventKinds.KEY_PRESS Then
			'Print "got it!"
			Local keyevent:=KeyEventArgs(e)
			if e <> null
				If Font.GetFaceImage(keyevent.key)<>Null And keyevent.key <>127 then
					Text = Text[.. _caretPos] + String.FromChar(keyevent.key) + Text[_caretPos..]
					CaretPos+=1
				ElseIf keyevent.key = 127 Then	'Supr
					if _caretPos <Text.Length then Text = Text[.. _caretPos] + Text[_caretPos+1 ..]
				ElseIf keyevent.key = 8	'Del
					if _caretPos>0 Then 
						Text = Text[.. _caretPos-1] + Text[_caretPos ..]
						_caretPos-=1
					endif

				ElseIf keyevent.key = 65573 Then 'Left
					CaretPos-=1
				ElseIf keyevent.key = 65575 Then 'Right
					CaretPos+=1
				ElseIf keyevent.key = 65571 Then 'End
					CaretPos = Text.Length
				ElseIf keyevent.key = 65572 Then 'Home
					CaretPos = 0
				end
			EndIf
		ElseIf e.eventSignature = eEventKinds.CLICK
			local mouseEvent:=MouseEventArgs(e)
			if mouseEvent <> null Then _controlClicked(mouseEvent) 
		endif
		Super.Msg(sender,e)
	End
	
	Method SelectionLength:Int() Property
		return _selectionLength
	End
	Method SelectionLength(value:Int) Property
		if CaretPos+value>Text.Length + 1 Then
			value = Text.Length - CaretPos + 1
		EndIf
		_selectionLength = value
		Return value
	end
	Private
	field _caretPos:int
	field _bordercolor:GuiColor
	Field _drawOffset:Int = 0
	Field _selectionLength:Int = 0
	Method _InitComponent()
		_bordercolor = SystemColors.FormBorder.Clone()
		BackgroundColor = SystemColors.WindowColor.Clone()
		TabStop = true
		ForeColor.SetColor(1,0,0,0)
	End
	
	Method _controlClicked(e:MouseEventArgs)
		Local text:=Text, currentPos = -_drawOffset
		For Local i:Int = 0 until text.Length
			Local char:BitMapCharMetrics = Font.GetFaceInfo(text[i])
			if char = null Then 
				Continue
			endif
			if currentPos+char.drawingSize.x  > e.position.X Then
				CaretPos = i	'We throw events
				return
			EndIf
			if i=_caretPos Then currentPos+=4
			currentPos+=char.drawingWidth - char.drawingOffset.x
		next
		CaretPos = text.Length +1	'We throw events
	End
End