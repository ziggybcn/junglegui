Import junglegui
Import mojo

'summary: simple combobox for testing 
Class ComboBox extends BaseLabel implements guiinterfaces.TextualAlignItem

	Field _dropDownHeight:int = 200
	Field _selectedIndexChanged:= new EventHandler<EventArgs>
		
	Method New()
		_InitComponent()
	End
	
	Method New(parent:ContainerControl, x:Int, y:Int,width:Int)
		Self.Parent = parent
		Self.Position.X = x
		Self.Position.Y = y
		Self.Text = ""
		Self.Size.X = width
		Self.Size.Y = DEFAULT_HEIGHT
		
		_InitComponent
	End
	
	Method Items:ListItemCollection() Property
		Return _listBox.Items
	End
	
	Method SelectedItem:ListItem()
		Return _listBox.SelectedItem
	End
	
	Method SelectedIndex:Int()
		Return _listBox.SelectedIndex
	End
	
	Method SelectedIndex:Void(value:Int)
		_listBox.SelectedIndex = value
	End
	
	'
	' events
	'
	
	Method Event_SelectedIndexChanged:EventHandler<EventArgs>() Property
		return _selectedIndexChanged
	End
	
' something strange with got/lost-focus???
Method _listBox_GotFocus(sender:Object, e:EventArgs)
	Print "Got"
	'_listBox.Visible = false
End
Method _listBox_LostFocus(sender:Object, e:EventArgs)
	Print "Lost"
	'_listBox.Visible = false
End
	
	Method listBox1_SelectedIndexChanged(sender:object, e:EventArgs)
		Self.Text = _listBox.SelectedItem.Text
		_listBox.Visible = false
		_selectedIndexChanged.RaiseEvent(Self, e)
	End
	
	Method Msg(msg:BoxedMsg)
		if msg.sender = Self
			Select msg.e.eventSignature
				Case eMsgKinds.CLICK
					_listBox.Visible = Not _listBox.Visible
					if _listBox.Visible Then
						_listBox.BringToFront()
					End
			End
		End
		Super.Msg(msg)
	End
	
	Method BorderColor:GuiColor() Property
		Return _borderColor
	End
	Method BorderColor:GuiColor(value:GuiColor) Property
		_borderColor = value
	End
	
	Method HooverColor:GuiColor() Property
		Return _hooveColor
	End
	
	Method HooverColor:GuiColor(value:GuiColor) Property
		_hooveColor = value
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

		if _listBox.SelectedIndex >= 0 Then
			
			Text = _listBox.SelectedItem.Text
			
			SetColor(Self.ForeColor.r, ForeColor.g, ForeColor.b)
	
			Select TextAlign
				Case eTextAlign.CENTER 
					Font.DrawText(Text, int(drawingPos.X + Size.X / 2), int(drawingPos.Y + Size.Y / 2 - Font.GetFontHeight() / 2), eDrawAlign.CENTER)
				Case eTextAlign.LEFT 
					Font.DrawText(Text, int(2 + drawingPos.X), int(drawingPos.Y + Size.Y / 2 - Font.GetFontHeight() / 2), eDrawAlign.LEFT)
				Case eTextAlign.RIGHT
					Font.DrawText(Text, int(drawingPos.X + Size.X - 18), int(drawingPos.Y + Size.Y / 2 - Font.GetFontHeight() / 2), eDrawAlign.RIGHT)
			End
		
		EndIf
	
		
		DrawRect drawingPos.X + Size.X - 10, drawingPos.Y + Size.Y / 2 - 0, 1, 1
		DrawRect drawingPos.X + Size.X - 10 - 1, drawingPos.Y + Size.Y / 2 - 1 - 0, 3, 1
		DrawRect drawingPos.X + Size.X - 10 - 2, drawingPos.Y + Size.Y / 2 - 1 - 1, 5, 1
		
		if HasFocus Then DrawFocusRect(Self, true)
	End
	
	Method Update()
		if Not Self.HasFocus And Not _listBox.HasFocus Then
			_listBox.Visible = false
		EndIf
	End
	
	Method AdjustSize:GuiVector2D()
		Local size:GuiVector2D = New GuiVector2D 
		size.X = Font.GetTxtWidth(Text) + 19
		size.Y = Font.GetFontHeight() + 19
		Self.Size.SetValues(size.X,size.Y)
		Return size
	End
	
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
	
	Const DEFAULT_HEIGHT = 20
		
	Field _textAlign:Int = eTextAlign.RIGHT
	Field _borderColor:GuiColor = new GuiColor
	Field _hooveColor:GuiColor = New GuiColor
	Field _listBox:ListBox
	
	Method _InitComponent()
		ForeColor.SetColor(1,0,0,0)
		BackgroundColor = SystemColors.ControlFace.Clone()
		BorderColor = SystemColors.ButtonBorderColor.Clone()
		HooverColor = SystemColors.WindowColor.Clone()
		TabStop = true
		AutoAdjustSize = false
		
		_listBox = New ListBox(Position.X, Position.Y + DEFAULT_HEIGHT, Size.X, _dropDownHeight, Parent)
		_listBox.Event_SelectedIndexChanged.Add(Self, "listBox1_SelectedIndexChanged")
		_listBox.Visible = false
		_listBox.Event_GotFocus.Add(Self, "_listBox_GotFocus")
		_listBox.Event_LostFocus.Add(Self, "_listBox_LostFocus")
		_listBox.Event_SelectedIndexChanged.Add(Self, "listBox1_SelectedIndexChanged")
		
	End
End
