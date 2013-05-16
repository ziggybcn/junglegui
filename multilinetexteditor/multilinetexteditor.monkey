Import junglegui

Class MultilineTextbox Extends BaseLabel
	Method New()
		InitComponent()
	End
	
	Const CR:= "~n"
	Field caretPos:= New GuiVector2D
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
		Local curline = 0
		For Local index:Int = 0 Until Self.Lines
			Local tl:TextLine = GetLine(index)
			For Local interval:TxtInterval = EachIn tl.Intervals.contents
				If (i + 1) * Font.GetFontHeight > drawpos.Y + Size.Y Then Exit
				Self.Font.DrawText(tl.text, drawpos.X, drawpos.Y + i * Font.GetFontHeight, eDrawAlign.LEFT, interval.InitOffset + 1, interval.EndOffset)

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
				i += 1
			Next
			'i -= 1
			If (i + 1) * Font.GetFontHeight > drawpos.Y + Size.Y Then Exit
			curline += 1
		Next
	End

	
	
	Method Msg(msg:BoxedMsg)
		If msg.sender = Self
			If msg.e.messageSignature = eMsgKinds.KEY_PRESS Then
				Local text:String = lines[caretPos.Y].text
				Local kpe:= KeyEventArgs(msg.e)
				If kpe <> Null Then
				
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
						Case KEY_RIGHT, 65575
							MoveCaretRight()
						Case KEY_LEFT, 65573
							MoveCaretLeft()
						Case KEY_DOWN, 65576
							MoveCaretDown()
					End				
				EndIf
			EndIf
		EndIf
		
		If msg.sender = Self And msg.e.messageSignature = eMsgKinds.RESIZED Then
			AdjustWrap()
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
		Local Stringlines:= value.Split(CR)
		For Local s:String = EachIn Stringlines
			Local tl:= AppendLine()
			'Local tl:= New TextLine
			tl.text = s
			tl.AdjustLine(Self.Font, Self.GetClientAreaSize.X)
		Next
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
	Const LINES_RESIZING_FACTOR = 1024
	Method InitComponent()
		Self.BackgroundColor = SystemColors.WindowColor
	End
	
	Method AdjustWrap()
		For Local i:Int = 0 Until Lines
			Local tl:= GetLine(i)
			tl.AdjustLine(Self.Font, Self.GetClientAreaSize.X)
		Next
	End
End

Class TextLine
	Field text:String
	Field Intervals:= New IntervalsList
	
	Method Lines:Int()
		'Optimize later:
		Return Intervals.count
	End
	
	Method AdjustLine(font:bitmapfont.BitmapFont, maxwidth:Int)
		Local tokeninit:Int = 0
		Local linestart:Int = 0
		Local linesize:Int = 0
		Local previousIsSeparator:Bool = False
		Intervals.Clear()
		For Local i:Int = 0 Until text.Length
			Local char:Int = text[i]
			'This calculates the drawing VISUAL size, but not spacing (kerning, overlapping of chars, etc.)
			Local tokensize:Int = font.GetTxtWidth(text, tokeninit, i) '- font.GetTxtWidth(text, i, i)

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
				linesize = 0
				linestart = tokeninit	'next line Starts at spliting token
			End
			
		Next
		Intervals.AddInterval(linestart, text.Length)	'previous line starts BEFORE splitting token
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