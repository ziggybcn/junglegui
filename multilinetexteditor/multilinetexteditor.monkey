Import junglegui

Class MultilineTextbox Extends BaseLabel
	Method New()
		InitComponent()
	End
	
	Const CR:= "~n"
	Field caretPos:= New GuiVector2D
	
	Method ReadOnly:Bool()
		Return _readonly
	End
	
	Method ReadOnly:Void(value:Bool)
		
	End
	
	Method Render:Void()
		
		Local i:int = 0
		Local drawpos:= UnsafeRenderPosition
		GetGui.Renderer.DrawControlBackground(Self.Status, drawpos, Size, Self)
		
		#IF TARGET="html5"
			SetColor(255, 255, 255)
		#ELSE
			Self.ForeColor.Activate()
		#END
		SetAlpha(1)
		Local curline = 0, sBarCount:= 0
		For Local index:Int = 0 Until Self.Lines
			Local tl:TextLine = GetLine(index)
			For Local interval:TxtInterval = EachIn tl.Intervals.contents
				'If (i - sBar.Value + 1) * Font.GetFontHeight > Size.Y Then Exit
				If (i - sBar.Value) > sBar.VisibleItems Then Exit	'Finished rendering!
				If (i - sBar.Value) < 0 Then
					'No need to render!
				Else
					Self.Font.DrawText(tl.text, drawpos.X, drawpos.Y + (i - sBar.Value) * Font.GetFontHeight, eDrawAlign.LEFT, interval.InitOffset + 1, interval.EndOffset)
	
					'Draw caret!
					If caretPos.Y = curline and GetGui.ActiveControl = Self Then
						If caretPos.X >= interval.InitOffset And caretPos.X <= interval.EndOffset Then
							Local caretOffset:Int = tl.GetTxtSpacing(tl.text, Font, interval.InitOffset, caretPos.X) + 1'  Font.GetTxtWidth(tl.text, interval.InitOffset + 1, interval.InitOffset + caretPos.X)
							If Millisecs Mod 1000 < 500
								ForeColor.Activate()
								DrawRect(drawpos.X + caretOffset, drawpos.Y + i * Font.GetFontHeight, Font.GetFaceInfo(32).drawingWidth / 2.0, Font.GetFontHeight)
								#IF TARGET="html5"
									SetColor(255, 255, 255)
								#ELSE
									Self.ForeColor.Activate()
								#END							
							EndIf
						EndIf
					End
				EndIf

				i += 1
				sBarCount += 1
			Next
			'i -= 1
			'If (i + 1) * Font.GetFontHeight > drawpos.Y + Size.Y Then Exit
			curline += 1
		Next
		
		sBar._size.SetValues(sBar.DefaultWidth, Size.Y - 2)
		sBar._pos.SetValues(drawpos.X + Size.X - sBar.DefaultWidth - 0, drawpos.Y + 1)
		'If ScrollbarVisible Then
			sBar.Render(sBar._pos, sBar._size)
		'endif
		
	End

	
	
	Method Msg(msg:BoxedMsg)
		Const ScrollbarVisible = True
		If msg.sender = Self
			sBar._size.SetValues(ScrollBarContainer.DefaultWidth, Size.Y - 2)
			sBar._pos.SetValues(Size.X - ScrollBarContainer.DefaultWidth + 1, 0)

			
			Select msg.e.messageSignature

					Case eMsgKinds.MOUSE_MOVE
					if ScrollbarVisible then
						sBar.MouseEnter()
						sBar.MouseMove(MouseEventArgs(msg.e))
					endif
					
				Case eMsgKinds.MOUSE_UP
					If ScrollbarVisible Then sBar.MouseUp(MouseEventArgs(msg.e))
					
				Case eMsgKinds.MOUSE_DOWN
					
					Local me:= MouseEventArgs(msg.e)
					if ScrollbarVisible And me.position.X >= sBar._pos.X  ' TODO: either completele here or completely in scrollbar
						sBar.MouseDown(me)
					'Else
					'	PickItem(me.position.Y)
					End
				
				Case eMsgKinds.MOUSE_LEAVE
				
					If ScrollbarVisible Then sBar.MouseLeave()
					
				Case eMsgKinds.MOUSE_ENTER
				
					if ScrollbarVisible then sBar.MouseEnter()

			
				Case eMsgKinds.RESIZED
						AdjustWrap()
						If sBar.Value > sBar.ItemsCount - sBar.VisibleItems Then
							sBar.Value = sBar.ItemsCount - sBar.VisibleItems
						EndIf

				Case eMsgKinds.KEY_PRESS
					Local text:String = lines[caretPos.Y].text
					Local kpe:= KeyEventArgs(msg.e)
					If kpe <> Null And ReadOnly = False Then
					
						If (Font.GetFaceImage(kpe.key) <> Null) And (kpe.key <> 127)
		
							SetLine(caretPos.Y, text[ .. caretPos.X] + String.FromChar(kpe.key) + text[caretPos.X ..])
							caretPos.X += 1
							'AdjustWrap()
		
	                	ElseIf kpe.key = 8      'Del
	                        If caretPos.X > 0 Then
	                                text = text[ .. caretPos.X - 1] + text[caretPos.X ..]
	                                SetLine(caretPos.Y, text)
	                                caretPos.X-=1
	                        EndIf
						EndIf
						Select kpe.key
							Case 65575	'Key right
								MoveCaretRight()
							Case 65573	'Key left
								MoveCaretLeft()
							Case 65576 'Key down
								MoveCaretDown()
						End				
					EndIf
			End Select
		EndIf
		
		Super.Msg(msg)
	End
	
	Method MoveCaretRight()
		caretPos.X += 1
		If caretPos.X > GetLine(caretPos.Y).text.Length Then
			If caretPos.Y < Lines - 1
				caretPos.Y += 1
				caretPos.X = 0
			Else
				caretPos.X -= 1
			EndIf
			
		EndIf
	End
	
	Method MoveCaretLeft()
		caretPos.X -= 1
		If caretPos.X < 0 Then
			caretPos.Y -= 1
			If caretPos.Y < 0 Then
				caretPos.Y = 0
			Else
				caretPos.X = GetLine(caretPos.Y).text.Length - 1
			EndIf
		EndIf
	End
	
	Method SetLine(y:Int, text:String)
		#IF CONFIG="debug"
			If (y < 0) Error("SetLine with less than a 0 index.") 'Return;
			If (y >= Lines) Error("SetLine out of bounds") 'Return;
		#END
		lines[y].text = text
		lines[y].AdjustLine(Self.Font, Self.GetClientAreaSize.X)
	End Method

		
	Method MoveCaretDown()
		Local line:= GetLine(caretPos.Y)
		Local getNext:Bool = False, prevOffset:Int, lastInter:TxtInterval
		For Local inter:TxtInterval = EachIn line.Intervals.contents
			If getNext Then
				caretPos.X = caretPos.X - prevOffset + inter.InitOffset
				If caretPos.X >= line.text.Length Then caretPos.X = line.text.Length - 1
				Return
			ElseIf caretPos.X >= inter.InitOffset And caretPos.X < inter.EndOffset Then
				prevOffset = inter.InitOffset
				getNext = True
				lastInter = inter
			EndIf
		Next
		If lastInter = Null Then Return
		If caretPos.Y < Lines Then
			caretPos.Y += 1
			caretPos.X = caretPos.X - lastInter.InitOffset
		Else
			'beeeep!
		EndIf
	End
	
	
	Method Text:String() Property
		Local result:String, done:Bool = False
		For Local tl:TextLine = EachIn lines
			If tl = Null Then Continue	'Bug?
			If not done Then
				result = tl.text
				done = True
			Else
				result += CR + tl.text
			EndIf
		Next
		Return result
	End
	Method Text:Void(value:String) Property
		Clear()
		linesWithWrap = 0
		Local Stringlines:= value.Split(CR)
		For Local s:String = EachIn Stringlines
			Local tl:= AppendLine()
			'Local tl:= New TextLine
			tl.text = s
			tl.AdjustLine(Self.Font, Self.GetClientAreaSize.X)
			linesWithWrap += tl.Lines
		Next
		AdjustScrollBar
	End

	Method AppendLine:TextLine()
		linesCount += 1
		If linesCount >= lines.Length - 1 Then lines = lines.Resize(linesCount + LINES_RESIZING_FACTOR) 'lines[ .. lines.Length + 100]
		If lines[linesCount] = Null Then lines[linesCount] = New TextLine
		lines[linesCount].text = ""
		Return lines[linesCount]
	End
	
	Method Lines:Int()
		Return linesCount + 1
	End
	
	Method RemoveLastLine()
		linesCount -= 1
		If linesCount < - 1 Then linesCount = -1
	End

	Method GetLine:TextLine(index:Int)
		Return lines[index]
	End

	Method Clear()
		linesCount = -1
	End
		
	Private
	Field lines:= New TextLine[LINES_RESIZING_FACTOR]
	Field linesCount:Int = -1
	Field _readonly:Bool = True

	Const LINES_RESIZING_FACTOR = 1024
	Method InitComponent()
		Self.BackgroundColor = SystemColors.WindowColor
	End
	
	Method AdjustWrap()
		linesWithWrap = 0
		For Local i:Int = 0 Until Lines
			Local tl:= GetLine(i)
			tl.AdjustLine(Self.Font, Self.GetClientAreaSize.X - sBar._size.X)
			tl.Lines
			linesWithWrap += tl.Lines
		Next
		AdjustScrollBar
	End
	
	Method AdjustScrollBar()
		sBar.ItemsCount = linesWithWrap
		sBar.VisibleItems = Self.Size.Y / Font.GetFontHeight
		'Print sBar.ItemsCount + ", " + sBar.VisibleItems
		sBar.UpdateFaderPosition()
		
	End
	
	
	Field linesWithWrap:Int = 0
	Field sBar:= New ScrollBarContainer
End

Class TextLine
	Field text:String
	Field Intervals:= New IntervalsList
	
	Method Lines:Int()
		'Optimize later:
		If countIntervals = -1 Then countIntervals = Intervals.count
		Return countIntervals
	End
	
	Method AdjustLine(font:bitmapfont.BitmapFont, maxwidth:Int)
		Local tokeninit:Int = 0
		Local linestart:Int = 0
		Local linesize:Int = 0
		Local previousIsSeparator:Bool = False
		Local intCount:Int = 0
		Intervals.Clear()
		For Local i:Int = 0 Until text.Length
			Local char:Int = text[i]
			'This calculates the drawing VISUAL size, but not spacing (kerning, overlapping of chars, etc.)
			Local tokensize:Int = font.GetTxtWidth(text, tokeninit + 1, i + 1) '- font.GetTxtWidth(text, i, i)

			If (char >= "a"[0] And char <= "z"[0]) or (char >= "A"[0] And char <= "Z"[0]) or (char >= "0"[0] And char <= "9"[0]) Then
				If previousIsSeparator Then
					previousIsSeparator = False
					linesize += GetTxtSpacing(text, font, tokeninit, i)
					tokeninit = i
					tokensize = font.GetTxtWidth(text, tokeninit, i) '- font.GetTxtWidth(text, i, i)
				EndIf
			Else
				'This calculates text spacing:
				tokensize = GetTxtSpacing(text, font, tokeninit, i)
				linesize += tokensize
				tokeninit = i  	'We begin next token
				
				tokensize = 0	'No token, it was a separator
				previousIsSeparator = True
			EndIf
			
			
			If linesize + tokensize > maxwidth Then	'Slip the line!
				Intervals.AddInterval(linestart, tokeninit)	'previous line starts BEFORE splitting token
				intCount += 1
				linesize = 0
				linestart = tokeninit	'next line Starts at spliting token
			End
			
		Next
		
		Intervals.AddInterval(linestart, text.Length)	'previous line starts BEFORE splitting token
		intCount += 1
		countIntervals = intCount
	End
	
	Method GetTxtSpacing:Int(text:String, font:BitmapFont, init:Int, ending:Int)
		Local size:Int = 0
		For Local i:Int = init Until Min(ending, text.Length)
			Local charinfo:= font.GetFaceInfo(text[i])
			If charinfo = Null Continue
			size += charinfo.drawingWidth + font.Kerning.x
		Next
		Return size
	End
	Private
	Field countIntervals:Int = -1
	
End


Class IntervalsList

	Field count:Int = 0
	Method Clear()
		contents.Clear()
		count = 0
	End

	Method AddInterval(initPoint:Int, endPoint:Int)
		Local interval:= New TxtInterval
		interval.InitOffset = initPoint
		interval.EndOffset = endPoint
		contents.AddLast(interval)
	End
	Private
	Field contents:= New List<TxtInterval>
End


Class TxtInterval
	Field InitOffset:Int, EndOffset:Int
End