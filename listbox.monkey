Import junglegui
Import mojo

Class eSelectionMode
	Const MODE_ONE = 0
	Const MODE_MULTIPLE = 1
End

'summary: Represents a Windows control to display a list of items.
Class ListBox extends Control

Private

	Global _cachedPosition:= New GuiVector2D
	
	Const DefaultItemHeight:Int = 13
 
	Field _allowSelection:Bool = true
	Field _horizontalScrollbar:Bool = false
	Field _itemHeight:Int = DefaultItemHeight
	Field _selectedIndex:Int = -1
	Field _selectedIndices:= new List<Int>
	Field _selectedItem:ListItem = null
	Field _selectedItems:= new List<ListItem>
	Field _selectionMode:Int = eSelectionMode.MODE_ONE
	Field _items:ListItemCollection
	Field _scrollbar:= new ScrollBarContainer
	Field _font:BitmapFont
	Field _visibleItems:int
	Field _itemsCount:int
	
	Field _selectedIndexChanged:= new EventHandler<EventArgs>
	
Public

	'
	' properties
	'
	
	Method Font:BitmapFont() property
		if _font<>null Then Return _font Else Return GetGui.systemFont
	End
	
	Method Items:ListItemCollection() Property
		Return _items
	End
	
	Method SelectedItem:ListItem()
		Return _selectedItem
	End
	
	Method SelectedIndex:Int()
		Return _selectedIndex
	End
	
	Method SelectedIndex:Void(value:Int)
		Local newVal:int = Max(0, Min(value, _items.Count))
		if newVal <> _selectedIndex Then
			_selectedIndex = newVal
			if newVal >= 0 And newVal < _items.Count Then
				_selectedItem = _items.ToArray()[newVal]
			Else
				_selectedIndex = -1
				_selectedItem = null
			End
			_selectedIndexChanged.RaiseEvent(Self, new EventArgs(0))
		EndIf
	End
	
	'
	' events
	'
	
	Method Event_SelectedIndexChanged:EventHandler<EventArgs>() Property
		return _selectedIndexChanged
	End
	
	'
	' methods
	'
	
	Method New()
		_items = new ListItemCollection(Self)
		_itemHeight = Font.GetFontHeight()
	End
	
	Method New(x:Float, y:Float, width:Float, height:Float, parent:ContainerControl)
		Position.SetValues(x, y)
		Size.SetValues(width, height)
		Parent = parent
		_items = new ListItemCollection(Self)
		_itemHeight = Font.GetFontHeight()
	End
	
	Method Update()
		if _scrollbar._mouseDown Then

			if _scrollbar._fastMove Or _scrollbar._topButtonState = eButtonState.BUTTON_DOWN Or _scrollbar._bottomButtonState = eButtonState.BUTTON_DOWN Then
				
				Local calculateRenderPos:= self.CalculateRenderPosition
				_cachedPosition.X = GetGui.MousePos.X - calculateRenderPos.X
				_cachedPosition.Y = GetGui.MousePos.Y - calculateRenderPos.Y
				_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y)
				_scrollbar._pos.SetValues(Size.X - _scrollbar.DefaultWidth, 0)
			
				_scrollbar.MouseDown(New MouseEventArgs(eMsgKinds.MOUSE_DOWN, _cachedPosition, 0))
			Else
			
				Local calculateRenderPos:= self.CalculateRenderPosition
				_cachedPosition.X = GetGui.MousePos.X - calculateRenderPos.X
				_cachedPosition.Y = GetGui.MousePos.Y - calculateRenderPos.Y
				_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y)
				_scrollbar._pos.SetValues(Size.X - _scrollbar.DefaultWidth, 0)
			
				_scrollbar.MouseMove(New MouseEventArgs(eMsgKinds.MOUSE_MOVE, _cachedPosition, 0))
			EndIf
			
			if Self.HasFocus = False Then Self.GetFocus()
		EndIf
		Super.Update()
	End
	
	Method Msg(msg:BoxedMsg)
		if msg.sender = Self Then
			_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y)
			_scrollbar._pos.SetValues(Size.X - _scrollbar.DefaultWidth, 0)
			
			Select msg.e.eventSignature
				Case eMsgKinds.MOUSE_MOVE
				
					_scrollbar.MouseEnter()
					_scrollbar.MouseMove(MouseEventArgs(msg.e))
					
				Case eMsgKinds.MOUSE_UP
				
					_scrollbar.MouseUp(MouseEventArgs(msg.e))
					
				Case eMsgKinds.MOUSE_DOWN
					
					Local me:= MouseEventArgs(msg.e)
					
					if me.position.X < _scrollbar._pos.X' TODO: either completele here or completely in scrollbar
						PickItem(me.position.Y)
					Else
						_scrollbar.MouseDown(me)
					End
				
				Case eMsgKinds.MOUSE_LEAVE
				
					_scrollbar.MouseLeave()
					
				Case eMsgKinds.MOUSE_ENTER
				
					_scrollbar.MouseEnter()
					
			End
		End
		Super.Msg(msg)
	End
	
	Method PickItem(y:Float)
		SelectedIndex = (y - 2) / _itemHeight + _scrollbar.Value
	End
	
	Method Render:Void()
		Local drawpos:= CalculateRenderPosition()
		
		'
		' render background
		'
		
		SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
		DrawRect(drawpos.X, drawpos.Y, Size.X, Size.Y)
		SetColor(255, 255, 255)
		DrawRect(drawpos.X + 1, drawpos.Y + 1, Size.X - 2, Size.Y - 2)
		
		
		
		'
		' render listbox items text
		'
		
		Local items:= _items.ToArray()
		
		SetColor(0, 0, 0)
		For Local i = _scrollbar.Value until _scrollbar.Value + _visibleItems
		
			if SelectedIndex = i Then
			
				SetColor 74, 120, 242
				DrawRect 1 + drawpos.X, 2 + drawpos.Y + _itemHeight * (i - _scrollbar.Value), Size.X - _scrollbar.ButtonSize, _itemHeight
				SetColor 255, 255, 255
				Font.DrawText(items[i].Text, drawpos.X + 5, 2 + drawpos.Y + _itemHeight * (i - _scrollbar.Value), 0)
				SetColor(0, 0, 0)
				
			Else
			
				Font.DrawText(items[i].Text, drawpos.X + 5, 2 + drawpos.Y + _itemHeight * (i - _scrollbar.Value), 0)
				
			EndIf
			
		End
		
		'
		' render scrollbar
		'
		_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y - 2)
		_scrollbar._pos.SetValues(drawpos.X + Size.X - _scrollbar.DefaultWidth - 1, drawpos.Y + 1)
		_scrollbar.Render(_scrollbar._pos, _scrollbar._size)
	End

Private

	Method ItemsCleared()
		UpdateScrollBar()
	End
	
	Method ItemRemoved(obj:object)
		UpdateScrollBar()
	End
	
	Method ItemAdded(obj:object)
		UpdateScrollBar()
	End
	
	Method UpdateScrollBar()
		_itemsCount = _items.Count
		_visibleItems = Max(0, Min(_itemsCount, int(Size.Y / _itemHeight)))
		_scrollbar.ItemsCount = _itemsCount
		_scrollbar.VisibleItems = _visibleItems
	End

End

Class ListItem

	Field Text:String
	Field Data:Object
	
	Method New(text:String)
		Text = text
	End
	
	Method New(text:String, data:Object)
		Text = text
		Data = data
	End
End

Class ListItemCollection extends List<ListItem>

private

	Field _owner:ListBox
	
Public

	Method New(owner:ListBox)
		_owner = owner
	End

	Method Clear()
		Super.Clear()
		_owner.ItemsCleared()
	End

	Method RemoveFirst:ListItem()
		local obj:= Super.RemoveFirst()
		_owner.ItemRemoved(obj)
		Return obj
	End

	Method RemoveLast:ListItem()
		local obj:= Super.RemoveLast()
		_owner.ItemRemoved(obj)
		Return obj
	End
	
	Method AddFirst:list.Node<ListItem>(data:ListItem)
		Local node:= Super.AddFirst(data)
		_owner.ItemAdded(data)
		Return node
	End

	Method AddLast:list.Node<ListItem>(data:ListItem)
		Local node:= Super.AddLast(data)
		_owner.ItemAdded(data)
		Return node
	End
	
	Method RemoveEach(value:ListItem)
		Local removed:Bool = false
		Local mynode:= FirstNode()
		While mynode
		        If mynode.Value = value Then
					mynode.Remove()
					removed = true
		        Endif
		        mynode = mynode.NextNode()
		Wend
		_owner.ItemRemoved(value)
	End
End