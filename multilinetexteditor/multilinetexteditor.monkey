Import junglegui
Class MultilineTextbox Extends BaseLabel
	
	Method Render:Void()
		'Super.Render()
		
		Local i:int = 0
		Local drawpos:= CalculateRenderPosition
		GetGui.Renderer.DrawControlBackground(Self.Status, drawpos, Size, Self)
		
		#IF TARGET="html5"
			SetColor(255, 255, 255)
		#ELSE
			Self.ForeColor.Activate()
		#END
		For Local tl:TextLine = EachIn lines
			For Local interval:TxtInterval = EachIn tl.Intervals.contents
				
				'Self.Font.DrawText(tl.text[interval.InitOffset .. interval.EndOffset], drawpos.X, drawpos.Y + i * Font.GetFontHeight,eDrawAlign.LEFT)
				Self.Font.DrawText(tl.text, drawpos.X, drawpos.Y + i * Font.GetFontHeight, eDrawAlign.LEFT, interval.InitOffset + 1, interval.EndOffset)
				
				i += 1
			Next
		Next
	End

	
	Method Text:String() Property
		Local result:String, done:Bool = False
		For Local tl:TextLine = EachIn lines
			If not done Then
				result = tl.text
				done = True
			Else
				result += String.FromChar(13) + tl.text
			EndIf
		Next
		Return result
	End
	Method Text:Void(value:String) Property
		lines.Clear()
		Local Stringlines:= value.Split(String.FromChar(13))
		For Local s:String = EachIn Stringlines
			Local tl:= New TextLine
			tl.text = s
			tl.AdjustLine(Self.Font, Self.GetClientAreaSize.X)
			lines.AddLast(tl)
		Next
	End

	Method Msg(msg:BoxedMsg)
		If msg.sender = Self And msg.e.messageSignature = eMsgKinds.RESIZED Then
			For Local tl:TextLine = EachIn lines
				tl.AdjustLine(Self.Font, Self.GetClientAreaSize.X)
			Next
		EndIf
		Super.Msg(msg)
	End
		
	Private
	Field lines:= New List<TextLine>
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