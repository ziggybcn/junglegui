Import junglegui
Private
Import mojo
public
Class Button extends BaseLabel implements guiinterfaces.TextualAlignItem
	'summary: This is the color used to draw the button border.
	Method BorderColor:GuiColor() Property
		Return _borderColor
	End
	'summary: This is the color used to draw the button border.
	Method BorderColor:GuiColor(value:GuiColor) Property
		_borderColor = value
	End
	
	'summary: This is the color used to draw the button background when the mouse is over the control.
	Method HooverColor:GuiColor() Property
		Return _hooveColor
	End
	Method HooverColor:GuiColor(value:GuiColor) Property
		_hooveColor = value
	End

	Method New()
		_InitComponent()
	End
	
	Method New(parent:ContainerControl, x:Int, y:Int, text:String,width:Int,height:Int)
		Self.Parent = parent
		Self.Position.X = x
		Self.Position.Y = y
		Self.Text = text
		Self.Size.X = width
		Self.Size.Y = height
		_InitComponent 
	End
	
	Method Render:Void()
		Local drawingPos:=CalculateRenderPosition()
		
		if GetGui.GetMousePointedControl() = Self Then
			SetColor(HooverColor.r,HooverColor.g,HooverColor.b)
		else
			SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
		EndIf
		
		DrawRect(drawingPos.X + 1, drawingPos.Y + 1, Size.X - 2, Size.Y - 2)
		
		SetAlpha(.5)
		SetColor(255,255,255)
		DrawRect(drawingPos.X + 1, drawingPos.Y + 1, Size.X - 2, Size.Y / 2)
		SetAlpha(1)
		
		SetColor(BorderColor.r,BorderColor.g,BorderColor.b) 
		
		DrawRoundBox(drawingPos,Size)
		
		
		if HasFocus Then
			SetAlpha 0.2
			SystemColors.FocusColor.Activate
			DrawRect(drawingPos.X + 1, drawingPos.Y + 1, Size.X - 2, Size.Y - 2)
			SetAlpha 1
		EndIf

		SetColor(Self.ForeColor.r, ForeColor.g, ForeColor.b)
		
		Select TextAlign
			Case eTextAlign.CENTER 
				Font.DrawText(Text,int(drawingPos.X + Size.X/2) ,int(drawingPos.Y + Size.Y/2 - Font.GetFontHeight()/2),eDrawAlign.CENTER )
			Case eTextAlign.LEFT 
				Font.DrawText(Text,int(drawingPos.X ) ,int(drawingPos.Y + Size.Y/2 - Font.GetFontHeight()/2),eDrawAlign.LEFT )
			Case eTextAlign.RIGHT
				Font.DrawText(Text,int(drawingPos.X + Size.X) ,int(drawingPos.Y + Size.Y/2 - Font.GetFontHeight()/2),eDrawAlign.RIGHT )
		End
		
		if HasFocus Then DrawFocusRect(Self, true)
	End
	Method AdjustSize:GuiVector2D()
		Local size:GuiVector2D = New GuiVector2D 
		size.X = Font.GetTxtWidth(Text) + 19
		size.Y = Font.GetFontHeight() + 19
		Self.Size.SetValues(size.X,size.Y)
		Return size
	End
	'summary: This property allows you to set the desired text aligment for thsi control.
	Method TextAlign:Int() Property
		Return _textAlign	
	End
	
	Method TextAlign:Void(align:Int) Property
		Select align
			Case eTextAlign.CENTER, eTextAlign.LEFT, eTextAlign.RIGHT 
				_textAlign = align
			Default
				Throw(New JungleGuiException("Text align value is not valid",Self))	
		End
	End
	
	
	Private
	Field _textAlign:Int = eTextAlign.CENTER 

	Field _borderColor:GuiColor = new GuiColor
	Field _hooveColor:GuiColor = New GuiColor
	Method _InitComponent()
		ForeColor.SetColor(1,0,0,0)
		BackgroundColor = SystemColors.ControlFace.Clone()
		BorderColor = SystemColors.ButtonBorderColor.Clone()
		HooverColor = SystemColors.WindowColor.Clone()
		TabStop = true
	End
End

