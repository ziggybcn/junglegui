Import listview

'' summary: Represents an item in a ListView control.
Class DefaultListViewItem extends ListViewItem 

Private 

	Field _img:Image 
	Field _textHeight
	Field _font:BitmapFont
	Field _showBorder? = false
	
Public 

	Method new(text$, img:Image)
		'_text = text 
		Text = text
		_img = img
	End
	
	'summary: This is a get/set property for the image associated to this listview item.
	Method Image:Image() Property
		Return Self._img
	End
	
	Method Image:Void(value:Image) Property
		Self._img = value
	End
	
	
	Method DrawBorder:Bool() Property
		Return _showBorder
	End
	
	Method DrawBorder:Void(val:Bool) Property
		_showBorder = val 
	End

	
	Method Font(value:BitmapFont) Property
		_font = value
		_textHeight = Font.GetTxtHeight(Self.Text) + 4 'Font.GetFontHeight + 4 'This will get _font or SytemFont if _font is null.
	End
	
	Method Font:BitmapFont() property
		if _font<>null Then Return _font Else Return GetGui.systemFont
	End
	
	Method Text:String() Property
		Return Super.Text
	End
	
	Method Text:Void(value:String) Property
		Super.Text(value)
		_textHeight = Font.GetTxtHeight(Self.Text) + 4
	End

	Method RenderBackground()
		Local drawpos:= UnsafeRenderPosition()

		'' over effect
		If Owner.HoverItem = Self Then
		
			SetColor 236,244,253
			DrawRect (drawpos.X ,  drawpos.Y ,Size.X, Size.Y)
			SetColor 184,214,251
			DrawRoundBox (drawpos.X ,  drawpos.Y ,Size.X, Size.Y)
			
		Else if _showBorder Then 
			
			BackgroundColor.Activate()
			DrawRect(drawpos.X + 1, drawpos.Y + 1, Size.X - 2, Size.Y - 2)
			BorderColor.Activate()
			DrawRoundBox(drawpos.X, drawpos.Y, Size.X, Size.Y)
		Else
			BackgroundColor.Activate()
			DrawRect(drawpos.X, drawpos.Y, Size.X, Size.Y)		
		EndIf
		
		'' selected item
		If Owner.SelectedItem = Self Then
		
			SetColor 202,225,252
			DrawRect (drawpos.X ,  drawpos.Y ,Size.X, Size.Y)
			SetColor 125,162,206
			DrawRoundBox (drawpos.X ,  drawpos.Y ,Size.X, Size.Y)

		EndIf
	
		

		
		
	End
	Method RenderChildren()
		Local drawpos:= UnsafeRenderPosition()
		'Draw Contents:
		if _img <> null Then 
			
		Local scale:Float = Min(
				float(Size.X - 10.0 * 2.0) / float(_img.Width),
				float(Size.X - 10.0 * 2.0) / float(_img.Height + _textHeight))
			
			'' Draw item image
			SetColor(255, 255, 255)
			DrawImage(_img, 
				drawpos.X + Size.X / 2 - float(_img.Width * scale) / 2 ,
				drawpos.Y + (Size.Y - _textHeight) / 2 - float(_img.Height * scale) / 2 , 
				0,scale, scale)
				
		End 

		If Text <> "" Then
		
			'' Draw item text
			Local textHeight = Font.GetTxtHeight(Text)
			Local textWidth = Font.GetTxtWidth(Text)
			
			Local i = 0
			Local displayStr$ = ""
			While (Text.Length > i)
				i+=1
				displayStr = Text[0 .. i]
				if Font.GetTxtWidth(displayStr) >= Size.X-20 Then 
					displayStr = Text[0..(i-1)] + ".."
					Exit 
				EndIf
			Wend  
#IF TARGET<>"html5"
			ForeColor.Activate()
#ELSE
			SystemColors.WindowTextForeColor.Activate()
#END
			Font.DrawText(displayStr, drawpos.X + Size.X / 2, drawpos.Y + Size.Y - _textHeight , eDrawAlign.CENTER )
		End
		SetColor(255, 255, 255)
		Super.RenderChildren()
	End
	
	Method RenderForeground()
		If HasFocus Then
			GetGui.Renderer.DrawFocusRect(Self, True)
		End
		
	End
End
