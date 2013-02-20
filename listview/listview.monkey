Import junglegui 
Import mojo
Import listviewitem
Import defaultlistviewitem

#REFLECTION_FILTER+="junglegui.listview*"



Class ListViewItemCollection extends List<ListViewItem>

private

	Field _owner:ListView
	
Public

	Method New(owner:ListView)
		_owner = owner
	End

	Method Clear()
	
		'' Dispose nodes, in order to release ndes from ListView
		Local mynode:= FirstNode()
		While mynode
			 mynode.Value.Dispose(); mynode = mynode.NextNode(); 
		Wend
		
		'' Clear collection
		Super.Clear()
		
		'' notify owner ListView
		_owner.ItemsCleared()
	End

	Method RemoveFirst:ListViewItem()
		local obj:= Super.RemoveFirst()
		_owner.ItemRemoved(obj)
		Return obj
	End

	Method RemoveLast:ListViewItem()
		local obj:= Super.RemoveLast()
		_owner.ItemRemoved(obj)
		Return obj
	End
	
	Method AddFirst:list.Node<ListViewItem>(data:ListViewItem)
		Local node:= Super.AddFirst(data)
		_owner.ItemAdded(data)
		Return node
	End

	Method AddLast:list.Node<ListViewItem>(data:ListViewItem)
		Local node:= Super.AddLast(data)
		_owner.ItemAdded(data)
		Return node
	End
	
	Method EstimatedCount:Int()
		Return _owner._itemsCount
	End
	
	Method RecalculateEstimatedCount:Int()
		Local pre:Int = _owner._itemsCount
		_owner._itemsCount = Self.Count()
		If _owner._itemsCount <> pre Then RefreshChanges()
	End
	
	Method RemoveEach(value:ListViewItem)
		Local mynode:= FirstNode()
		While mynode
		        If mynode.Value = value Then
					mynode.Remove()
					_owner.ItemRemoved(value)
		        Endif
		        mynode = mynode.NextNode()
		Wend
	End
	
	Method RefreshChanges()
		_owner.UpdateScrollBar()
	End
End


'' summary: Represents a Windows list view control, which displays a collection of items.
Class ListView extends ScrollableControl

Private 

	Field _itemsContainer:ContainerControl 
	Field _items:ListViewItemCollection
	Field _itemsCount:Int 
	Field _selectedItem:ListViewItem
	Field _selectedIndex:Int
	Field _spacing:= New ControlGuiVector2D
	Field _itemWidth = 96, _itemHeight = 96
	Field _font:BitmapFont
	Field _lastScroll = 0
	Field _overControl:ListViewItem
	'Field _iconSpacing:Int = 10
	Field _hScrollStep = 10
	Field _autoSize? = true 
	
	Field _selectedIndexChanged:= new EventHandler<EventArgs>
	Field _event_ItemAdded:= new EventHandler<EventArgs>
	Field _event_ItemRemoved:= New EventHandler<EventArgs>
	
	Const SPACE_MODIFIED:Int = -1
		
	Method ItemsCleared()
		_itemsCount = 0
		UpdateScrollBar()
	End
	
	Method ItemRemoved(obj:object)
		_itemsCount -= 1
		Local lv:= ListViewItem(obj)
		lv.Dispose()
		Event_ItemRemoved.RaiseEvent( Self, new EventArgs())
		UpdateScrollBar()
	End
	
	Method ItemAdded(obj:object)
		_itemsCount += 1
		Local lv:= ListViewItem(obj) 
		lv.Parent = Self 
		'lv._owner = Self 
		Event_ItemAdded.RaiseEvent( Self, new EventArgs())
		UpdateScrollBar()
	End
	
	Method InitControl()
		_items = New ListViewItemCollection(Self)
		Padding.Right = ScrollBarContainer.DefaultWidth
		Self._spacing.SetValues(10, 10)
		_spacing.SetNotifyControl(Self, ListView.SPACE_MODIFIED)
	End
	
Public 	
				
	Method New(x:Float, y:Float, width:Float, height:Float, parent:ContainerControl)
		Position.SetValues(x, y)
		Size.SetValues(width, height)
		Parent = parent
		InitControl()
	End
	
	Method new()
		InitControl()
	End
	
	
	'
	' events
	'

	Method Event_SelectedIndexChanged:EventHandler<EventArgs>() Property
		return _selectedIndexChanged
	End
	
	Method Event_ItemAdded:EventHandler<EventArgs>() property
		Return _event_ItemAdded
	End
	
	Method Event_ItemRemoved:EventHandler<EventArgs>() property
		Return _event_ItemRemoved
	End
	
	
	'
	' methods
	'
	
	Method Msg(msg:BoxedMsg)
		If msg.sender = Self And msg.e.messageSignature = ListView.SPACE_MODIFIED Then UpdateScrollBar()
		Super.Msg(msg)
		If msg.sender = Self And msg.e.messageSignature = eMsgKinds.RESIZED Then UpdateScrollBar()
	End
	
	Method SetItemSize(width, height)
		_itemWidth = width 
		_itemHeight = height 
		UpdateScrollBar()
	End
	
	Method ItemWidth:Int() Property 
		Return _itemWidth
	End
	
	Method ItemWidth:Void(val:Int) Property
		_itemWidth = val
		UpdateScrollBar()
	End
	
	Method ItemHeight:Int() Property 
		Return _itemHeight
	End
	
	Method ItemHeight:Void(val:Int) Property
		_itemHeight = val
		UpdateScrollBar()
	End
	
	Method ItemSpacing:GuiVector2D() Property
		'_spacing.X = width 
		'_spacing.Y = height 
		'UpdateScrollBar()
		Return _spacing
	End
	
	
	
	''Method AutoSize?() Property
	''	Return _autoSize
	''End
	
	''Method AutoSize:Void(val?) Property 
	''	_autoSize = val
	''End
	
	'' summary:  Gets the indexes of the selected items in the control.
	Method SelectedIndex:Int() Property
		Return _selectedIndex
	End
	
	Method SelectedIndex:Void(value:Int) Property
		If value = _selectedIndex Then Return
		Local count:Int = 0
		For Local i:ListViewItem = EachIn _items
			If count = value Then
				 _selectedItem = i
				 _selectedIndex = count
				 Self.Event_SelectedIndexChanged.RaiseEvent(Self, New EventArgs)
				 Return
			 EndIf
			 count += 1
		Next
		_selectedItem = Null
		_selectedIndex = -1
		 Self.Event_SelectedIndexChanged.RaiseEvent(Self, New EventArgs)
	End
	
	'' summary:  Gets the items that are selected in the control.
	Method SelectedItem:ListViewItem() Property
		Return _selectedItem
	End
	
	Method SelectedItem:Void(value:ListViewItem) Property
		If value = _selectedItem Then Return
		Local count:Int = 0
		For Local i:ListViewItem = EachIn _items
			If i = value Then
				 _selectedItem = value
				 _selectedIndex = count
				 Self.Event_SelectedIndexChanged.RaiseEvent(Self, New EventArgs)
				 Return
			 EndIf
			 count += 1
		Next
		_selectedItem = Null
		_selectedIndex = -1
		 Self.Event_SelectedIndexChanged.RaiseEvent(Self, New EventArgs)
	End
	
	'' summary:  Gets a collection containing all items in the control.
	Method Items:ListViewItemCollection() Property
		Return _items
	End
	
	Method UpdateScrollBar( )
		Local _countX:Int
		'Local _countY:Float	'Prevent rounding errors

		if Items And Items.Count > 0 Then 
		
			_countX = Max(1, GetClientAreaSize.X / (_itemWidth + _spacing.X))
	
			
			Local index = 0
			Local ix = 0
			Local rows = 0
			For Local item:= eachin _items
				If index Mod _countX = 0 and index <> 0 Then
					rows+=1
					ix = 0
				End 
				
				item.Size.SetValues(_itemWidth,_itemHeight)
	
				item.Position.SetValues(
					_spacing.Y + (_itemWidth + _spacing.Y ) * ix,
					_spacing.X -_scrollbar.Value *_hScrollStep + (_itemHeight + _spacing.X ) * rows )
		
				ix+=1
				index+=1
			Next
			rows += 1

			''
			'' update scrollbar 
			''
			
			Local _visibleItems:Int = Max(0, int(GetClientAreaSize.Y / (_itemHeight + _spacing.X) + 0.5))
			
			_scrollbar.ItemsCount = rows * (_itemHeight + _spacing.X) / _hScrollStep
			_scrollbar.VisibleItems = _visibleItems * (_itemHeight + _spacing.X) / _hScrollStep

			If _scrollbar.Value > _scrollbar._itemsCount - _scrollbar._visibleItems Then
				_scrollbar.Value = _scrollbar._itemsCount - _scrollbar._visibleItems
			EndIf
		End 
	End
	
	Method Update()
		Super.Update()
		If _lastScroll <> _scrollbar.Value Then
			_lastScroll = _scrollbar.Value
			UpdateScrollBar()
		EndIf
	End
	
	Method Render:Void()
		Local drawpos:= CalculateRenderPosition()
		
		SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
		DrawRect(drawpos.X, drawpos.Y, Size.X, Size.Y)
		SetColor(255, 255, 255)
		DrawRect(drawpos.X + 1, drawpos.Y + 1, Size.X - 2, Size.Y - 2)

		Super.Render()
		
		'if HasFocus Then
		'	GetGui.Renderer.DrawFocusRect(Self, True)
		'End
	End
	Method RenderForeground()
		If HasFocus Then
			GetGui.Renderer.DrawFocusRect(Self, True)
		Else
			GetGui.Renderer.DrawControlBorder(Self.Status, CalculateRenderPosition, Size, Self)
		EndIf
	End
	
	Method HoverItem:ListViewItem() Property
		Return Self._overControl
	End
	
	Method HoverItem:Void(item:ListViewItem) Property
		Self._overControl = item
	End
End