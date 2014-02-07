Import junglegui

'summary: simple combobox for testing. 
Class ComboBox Extends BaseLabel Implements guiinterfaces.TextualAlignItem
	
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
	
	Method Msg(msg:BoxedMsg)
		if msg.sender = Self
			Select msg.e.messageSignature
				Case eMsgKinds.CLICK
					_listBox.Visible = Not _listBox.Visible
					_listBox.Position.SetValues(Self.Position.X, Self.Position.Y + Self.Size.Y)
					_listBox.Size.SetValues(Self.Size.X, _dropDownHeight)
					if _listBox.Visible Then
						_listBox.BringToFront()
					End
					if Not HasFocus Then GetFocus
			End
		End
		Super.Msg(msg)
	End
	
	
	Method Dispose()
		_listBox.Dispose()
		Super.Dispose()
	End
	
	Method Visible:Void(value:Bool) Property
		if value = False Then' make sure that listbox becomes also hidden
			_listBox.Visible = False
		End
		Super.Visible(value)
	End
	
	Method Visible:Bool() Property
		Return Super.Visible
	End
		
	Method Render:Void()
		Local drawingPos:=UnsafeRenderPosition()
		

		GetGui.Renderer.DrawButtonBackground(Status, drawingPos, Size, Self)
				
		GetGui.Renderer.DrawControlBorder(Status, drawingPos, Size, Self)
		
		If HasFocus Then GetGui.Renderer.DrawButtonFocusRect(Status, drawingPos, Size, Self)

		If _listBox.SelectedIndex >= 0 Then
			
			Text = _listBox.SelectedItem.Text

			GetGui.Renderer.DrawComboText(Status, drawingPos, Size, Self.Text, Self.TextAlign, Self.Font, Self)

		EndIf
	
		GetGui.Renderer.DrawComboArrow(Status, drawingPos, Size, Self)
		
		If HasFocus Then GetGui.Renderer.DrawFocusRect(Self, True)
	End
	
	Method Update()
		if Not Self.HasFocus And Not _listBox.HasFocus Then
			_listBox.Visible = False
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
	
	
	Method DropDownHeight:Float() Property
		Return _dropDownHeight
	End
	
	Method DropDownHeight:Void(value:Float) Property
		_dropDownHeight = value
	End
	
	Method ListBox:ListBox() Property
		Return _listBox
	End
Private
	
	Const DEFAULT_HEIGHT = 20
		
	Field _textAlign:Int = eTextAlign.LEFT
	Field _listBox:ListBox
	Field _dropDownHeight:int = 200
	Field _selectedIndexChanged:= new EventHandler<EventArgs>
	
	Method _InitComponent()
		ForeColor.SetColor(1,0,0,0)
		BackgroundColor = SystemColors.ControlFace
		BorderColor = SystemColors.ButtonBorderColor
		HooverColor = SystemColors.WindowColor
		TabStop = true
		AutoAdjustSize = false
		
		_listBox = New ListBox(Position.X, Position.Y + DEFAULT_HEIGHT, Size.X, _dropDownHeight, Parent)
		_listBox.Event_SelectedIndexChanged.Add(Self, "listBox1_SelectedIndexChanged")
		_listBox.Visible = false
		_listBox.Event_GotFocus.Add(Self, "_listBox_GotFocus")
		_listBox.Event_LostFocus.Add(Self, "_listBox_LostFocus")
		_listBox.Event_SelectedIndexChanged.Add(Self, "listBox1_SelectedIndexChanged")
	End
	
	Method Parent:ContainerControl(parentControl:ContainerControl) Property
		_listBox.Parent = parentControl
		Super.Parent(parentControl)
	End
	
	Method Parent:ContainerControl() Property
		Return Super.Parent
	End
	
	' something strange with got/lost-focus???
	Method _listBox_GotFocus(sender:Object, e:EventArgs)
		'_listBox.Visible = false
	End
	
	Method _listBox_LostFocus(sender:Object, e:EventArgs)
		'_listBox.Visible = false
	End
		
	Method listBox1_SelectedIndexChanged(sender:object, e:EventArgs)
		Self.Text = _listBox.SelectedItem.Text
		_listBox.Visible = false
		_selectedIndexChanged.RaiseEvent(Self, e)
	End
End
