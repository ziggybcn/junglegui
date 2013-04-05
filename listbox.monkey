Import junglegui
Import mojo

Class eSelectionMode
	Const MODE_ONE = 0
	Const MODE_MULTIPLE = 1
End

'summary: Represents a Windows control to display a list of items.
Class ListBox extends Control

'#Region Private
Private

	Global _cachedPosition:= New GuiVector2D
	
	Const ItemMargin:Int = 4	'Maybe this could be done a property, or be defined on the Renderer?
 
	Field _allowSelection:Bool = true
	Field _horizontalScrollbar:Bool = false
	Field _itemHeight:Int = Gui.systemFont.GetFontHeight() + ItemMargin
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
'#End Region
	'
	' properties
	'
	'summary: This property alows you to get/set the font used to dipslay this control contents
	Method Font:BitmapFont() property
		If _font <> Null Then
			Return _font
		Else
			_itemHeight = GetGui.systemFont.GetFontHeight + ItemMargin 'This will get _font or SytemFont if _font is null.
			Return GetGui.systemFont
		EndIf
	End
	
	Method Font(value:BitmapFont) Property
		_font = value
		_itemHeight = Font.GetFontHeight + ItemMargin 'This will get _font or SytemFont if _font is null.
	End
	
	'summary: This readonly property returns the lists of items that have been included in the control contents.
	Method Items:ListItemCollection() Property
		Return _items
	End
	
	'summary: This property alows you to get/set the selected item.
	Method SelectedItem:ListItem() Property
		Return _selectedItem
	End
	
	Method SelectedItem:Bool(item:ListItem) Property
		Local i:Int = 0
		For Local li:ListItem = EachIn _items
			if li = item then
				if _selectedItem <> li Then
					_selectedItem = li
					_selectedIndex = i
					_selectedIndexChanged.RaiseEvent(Self, New EventArgs(0))
				endif
				Return true
			EndIf
			i += 1
		Next
		Return false
	End
	
	'summary: This property allows you to get/set the index of the currently selected item. If no item is selected, it will return -1.
	Method SelectedIndex:Int() Property
		Return _selectedIndex
	End
	
	Method SelectedIndex:Void(value:Int) Property

		Local i:Int = 0
		Local node:= _items.FirstNode(), done:Bool = false

		if value < 0 Then done = true

		While done = False And node <> null
			if i = value Then
				_selectedItem = node.Value
				_selectedIndex = value
				_selectedIndexChanged.RaiseEvent(Self, new EventArgs(0))
				return
			EndIf
			i += 1
			node = node.NextNode
		Wend
		'index out of bounds:
		_selectedItem = null
		_selectedIndex = -1

		_selectedIndexChanged.RaiseEvent(Self, new EventArgs(0))
		
	End

	
	'
	' events
	'
	'summary: This event is fired when the selected index has changed.	
	Method Event_SelectedIndexChanged:EventHandler<EventArgs>() Property
		return _selectedIndexChanged
	End
	
	'
	' methods
	'
	
	Method New()
		InitControl()
	End
	
	
	Method New(x:Float, y:Float, width:Float, height:Float, parent:ContainerControl)
		Position.SetValues(x, y)
		Size.SetValues(width, height)
		Parent = parent
		InitControl()
	End
	
	Method Update()
		if _scrollbar._mouseDown And ScrollbarVisible Then

			if _scrollbar._fastMove Or _scrollbar._topButtonState = eButtonState.BUTTON_DOWN Or _scrollbar._bottomButtonState = eButtonState.BUTTON_DOWN Then
				
				Local calculateRenderPos:= self.UnsafeRenderPosition
				_cachedPosition.X = GetGui.MousePos.X - calculateRenderPos.X
				_cachedPosition.Y = GetGui.MousePos.Y - calculateRenderPos.Y
				_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y - 2)
				_scrollbar._pos.SetValues(Size.X - _scrollbar.DefaultWidth, 0)
			
				_scrollbar.MouseDown(New MouseEventArgs(eMsgKinds.MOUSE_DOWN, _cachedPosition, 0))
				
			Else
			
				Local calculateRenderPos:= self.UnsafeRenderPosition
				_cachedPosition.X = GetGui.MousePos.X - calculateRenderPos.X
				_cachedPosition.Y = GetGui.MousePos.Y - calculateRenderPos.Y
				_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y - 2)
				_scrollbar._pos.SetValues(Size.X - _scrollbar.DefaultWidth, 0)
			
				_scrollbar.MouseMove(New MouseEventArgs(eMsgKinds.MOUSE_MOVE, _cachedPosition, 0))
			EndIf
			
			if Self.HasFocus = False Then Self.GetFocus()
		EndIf
		Super.Update()
	End
	
	Method Msg(msg:BoxedMsg)
		if msg.sender = Self Then
			_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y - 2)
			_scrollbar._pos.SetValues(Size.X - _scrollbar.DefaultWidth + 1, 0)
			
			Select msg.e.messageSignature
			
				Case eMsgKinds.RESIZED
					_scrollbar.UpdateFaderPosition()
					UpdateScrollBar(False)
					'ScrollSelectedItem()
					If _scrollbar.Value > _scrollbar.ItemsCount - _scrollbar.VisibleItems Then
						_scrollbar.Value = _scrollbar.ItemsCount - _scrollbar.VisibleItems
					EndIf
				Case eMsgKinds.MOVED
			
				Case eMsgKinds.MOUSE_MOVE
					if ScrollbarVisible then
						_scrollbar.MouseEnter()
						_scrollbar.MouseMove(MouseEventArgs(msg.e))
					endif
					
				Case eMsgKinds.MOUSE_UP
					if ScrollbarVisible Then _scrollbar.MouseUp(MouseEventArgs(msg.e))
					
				Case eMsgKinds.MOUSE_DOWN
					
					Local me:= MouseEventArgs(msg.e)
					if ScrollbarVisible And me.position.X >= _scrollbar._pos.X  ' TODO: either completele here or completely in scrollbar
						_scrollbar.MouseDown(me)
					Else
						PickItem(me.position.Y)
					End
				
				Case eMsgKinds.MOUSE_LEAVE
				
					if ScrollbarVisible then _scrollbar.MouseLeave()
					
				Case eMsgKinds.MOUSE_ENTER
				
					if ScrollbarVisible then _scrollbar.MouseEnter()
					
				Case eMsgKinds.KEY_PRESS
					Local keyEvent:= KeyEventArgs(msg.e)
					if Not (keyEvent = Null) Then
						Select keyEvent.key
							Case 65576	'Key Down
								if Self._selectedIndex < _itemsCount - 1 then self.SelectedIndex += 1
								ScrollSelectedItem()
							Case 65574	'Key Up
								Self.SelectedIndex -= 1
								ScrollSelectedItem()

							Case 65570	'PageDown
								Self.SelectedIndex = Min(_itemsCount - 1, _scrollbar.Value + _visibleItems)
								ScrollSelectedItem()

							Case 65569	'PageUp
								Self.SelectedIndex -= _scrollbar._visibleItems
								ScrollSelectedItem()

							Case 65572 'Home
								Self.SelectedIndex = 0
								ScrollSelectedItem()

							Case 65571
								Self.SelectedIndex = _itemsCount - 1
								ScrollSelectedItem()

						End
					EndIf
					
					
			End
		End
		Super.Msg(msg)
	End
	
	Method PickItem(y:Float)
		SelectedIndex = (y - 2) / _itemHeight + _scrollbar.Value
	End
	
	Method ScrollSelectedItem()
		if Not ScrollbarVisible then return
		if Self._selectedIndex >= _scrollbar.Value And Self._selectedIndex < _scrollbar.Value + _scrollbar.VisibleItems - 1 Then Return
		if _selectedIndex >= _scrollbar.Value + _scrollbar.VisibleItems - 1 then
			Self._scrollbar.Value = _selectedIndex - _scrollbar.VisibleItems + 1
		Else
			Self._scrollbar.Value = _selectedIndex '_selectedIndex + _scrollbar.VisibleItems - 1
		endif
		'Self._scrollbar.UpdateFaderPosition(_scrollbar._size)
	End
	
	Method Render:Void()
		Local drawpos:= UnsafeRenderPosition()
		
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
		
'		Local items:= _items.ToArray()	'Bottleneck?
'		
'		SetColor(0, 0, 0)
'		For Local i = _scrollbar.Value until _scrollbar.Value + _visibleItems
'		
'			if SelectedIndex = i Then
'			
'				SetColor 74, 120, 242
'				DrawRect 1 + drawpos.X, 2 + drawpos.Y + _itemHeight * (i - _scrollbar.Value), Size.X - _scrollbar.ButtonSize, _itemHeight
'				SetColor 255, 255, 255
'				Font.DrawText(items[i].Text, drawpos.X + 5, 2 + drawpos.Y + _itemHeight * (i - _scrollbar.Value), 0)
'				SetColor(0, 0, 0)
'				
'			Else
'			
'				Font.DrawText(items[i].Text, drawpos.X + 5, 2 + drawpos.Y + _itemHeight * (i - _scrollbar.Value), 0)
'				
'			EndIf
'			
'		End
'		
		'Version 2:
		
		ForeColor.Activate()	'It is 255,255,255 on HTML5 while 0,0,0 on non HTML5
		Local done:Bool = false, node:= _items.FirstNode(), i:Int = 0
		While done = false 'And node <> null
			if node = null Then
				done = True
				Continue
			EndIf
			if i >= _scrollbar.Value and i < (_scrollbar.Value + _visibleItems) Then
				if SelectedIndex = i Then
					Local margin:Int = 0
					if ScrollbarVisible Then margin = _scrollbar._buttonSize
				
					SystemColors.SelectedItemBackColor.Activate()
					DrawRect 1 + drawpos.X, 2 + drawpos.Y + _itemHeight * (i - _scrollbar.Value), Size.X - margin, _itemHeight
					SystemColors.SelectedItemForeColor.Activate()
					#IF TARGET="html5"
					SetColor(255, 255, 255)
					#END
					Font.DrawText(node.Value.Text, drawpos.X + 5, 2 + drawpos.Y + _itemHeight * (i - _scrollbar.Value) + ItemMargin / 2, 0)
				Else
					ForeColor.Activate()
					#IF TARGET="html5"
					SetColor(255, 255, 255)
					#END
					Font.DrawText(node.Value.Text, drawpos.X + 5, 2 + drawpos.Y + _itemHeight * (i - _scrollbar.Value) + ItemMargin / 2, 0)
					
				EndIf
			ElseIf i >= (_scrollbar.Value + _visibleItems)
				done = True
			ElseIf node = null
				done = true
			endif
			i += 1
			node = node.NextNode
		wend
		'/Version2		
		
		
		'
		' render scrollbar
		'
		_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y - 2)
		'_scrollbar._pos.SetValues(drawpos.X + Size.X - _scrollbar.DefaultWidth - 1, drawpos.Y + 1)
		_scrollbar._pos.SetValues(drawpos.X + Size.X - _scrollbar.DefaultWidth - 0, drawpos.Y + 1)
		if ScrollbarVisible then
			_scrollbar.Render(_scrollbar._pos, _scrollbar._size)
		endif
		If HasFocus Then
			GetGui.Renderer.DrawFocusRect(Self, True)
		Else
			GetGui.Renderer.DrawControlBorder(Status, drawpos, Size, Self)
		EndIf
	End

Private

	Method ItemsCleared()
		_itemsCount = 0
		UpdateScrollBar(false)
	End
	
	Method ItemRemoved(obj:object)
		_itemsCount -= 1
		UpdateScrollBar(false)
	End
	
	Method ItemAdded(obj:object)
		_itemsCount += 1
		UpdateScrollBar(false)
	End
	
	Method UpdateScrollBar(recountItems:Bool)
		If recountItems and _items <> Null Then _itemsCount = _items.Count
		_visibleItems = Max(0, Min(_itemsCount, int(Size.Y / _itemHeight)))
		_scrollbar.ItemsCount = _itemsCount
		_scrollbar.VisibleItems = _visibleItems
	End

	Method InitControl()
		_items = new ListItemCollection(Self)
		_itemHeight = Font.GetFontHeight() + ItemMargin		
	End
	
	Method ScrollbarVisible:Bool()
		Return _itemsCount > _scrollbar.VisibleItems
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
	
	Method EstimatedCount:Int()
		Return _owner._itemsCount
	End
	
	Method RemoveEach(value:ListItem)
		Local mynode:= FirstNode()
		While mynode
		        If mynode.Value = value Then
					mynode.Remove()
					_owner.ItemRemoved(value)	'We get track of how many times an item has been removed. One call each time.
		        Endif
		        mynode = mynode.NextNode()
		Wend
		'_owner.ItemRemoved(value)
	End
	
	Method RefreshChanges()
		_owner.UpdateScrollBar(True)
	End
End