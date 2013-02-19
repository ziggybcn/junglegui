Import junglegui 
Import mojo 

#REFLECTION_FILTER+="junglegui.listview*"
#Rem
	summary: This is a ListViewItem control.
	The current implementation is based on the Controlclass
#END
Class ListViewItem Extends ContainerControl

Private 

	Field _owner:ListView 
	Field _text:String 
	
	Method OnEnter(sender:Object, e:EventArgs )
		_owner._overControl = Self
	End
	
	Method OnLeave(sender:Object, e:EventArgs )
		_owner._overControl = null
	End
	
	Method OnClick(sender:Object, e:MouseEventArgs )
		_owner._selectedItem = Self 
		Local index = 0
		'' TODO: Optimize!
		For Local i:= eachin _owner._items 
			if i = Self Then 
				_owner._selectedIndex = index; Exit  
			End 
			index+=1
		Next
	End
	

Public 

	'<MANEL>
	'Method New()
		'If the user clears the eventhandler contents, the control would become unstable.
		'We should not rely on eventhandlers for internal controls functionality.
		'This has ben reworked to use the Dispatch method (See just below)
		
		'Event_MouseEnter.Add( Self, "OnEnter" )
		'Event_MouseLeave.Add( Self, "OnLeave" )
		'Event_Click.Add(Self, "OnClick" )
	'End
'	Method Dispatch(msg:BoxedMsg)
'		Select msg.e.messageSignature
'			Case eMsgKinds.MOUSE_ENTER
'				OnEnter(msg.sender, msg.e)
'			Case eMsgKinds.MOUSE_LEAVE
'				OnLeave(msg.sender, msg.e)
'			Case eMsgKinds.CLICK
'				OnClick(msg.sender, MouseEventArgs(msg.e))
'		End
'		
'		Super.Dispatch(msg)
'	End
	
	Method Msg(msg:BoxedMsg)
		Select msg.e.messageSignature
			Case eMsgKinds.MOUSE_ENTER
				OnEnter(msg.sender, msg.e)
			Case eMsgKinds.MOUSE_LEAVE
				OnLeave(msg.sender, msg.e)
			Case eMsgKinds.CLICK
				OnClick(msg.sender, MouseEventArgs(msg.e))
		End
		Super.Msg(msg)
	End
	'</MANEL>
	
	Method Owner:ListView() Property 
		Return _owner 
	End
	
	
	Method RenderBackground()

		If _owner._overControl = Self Then	'That means we're over the control OR any control contained inside the control, so it's technically still a Hoover.
			GetGui.Renderer.DrawHooverSelectableBackground(Status | eControlStatus.HOOVER, CalculateRenderPosition, Size, Self, _owner.SelectedItem = Self)
		Else
			GetGui.Renderer.DrawHooverSelectableBackground(Status, CalculateRenderPosition, Size, Self, _owner.SelectedItem = Self)
		End If
		
	End
	
	Method Text:String() Property
		Return _text
	End
	
	Method Text:Void(val:String) Property
		_text = val 
	End
	
End

'' summary: Represents an item in a ListView control.
Class DefaultListViewItem extends ListViewItem 

Private 

	Field _img:Image 
	Field _textHeight
	Field _font:BitmapFont
	Field _showBorder? = false
	
Public 

	Method new(text$, img:Image)
		_text = text 
		_img = img
		_textHeight = Font.GetFontHeight + 4
	End
	
Private 
	
	Method BorderVisible?() Property
		Return _showBorder
	End
	
	Method BorderVisible:Void(val?) Property 
		_showBorder = val 
	End

Public 
	
	Method Font(value:BitmapFont) Property
		_font = value
		_textHeight = Font.GetFontHeight + 4 'This will get _font or SytemFont if _font is null.
	End
	
	Method Font:BitmapFont() property
		if _font<>null Then Return _font Else Return GetGui.systemFont
	End

	Method Render:Void()
		Local drawpos:= CalculateRenderPosition()

		'' over effect
		if _owner._overControl = Self Then 
		
			SetColor 236,244,253
			DrawRect (drawpos.X ,  drawpos.Y ,Size.X, Size.Y)
			SetColor 184,214,251
			DrawRoundBox (drawpos.X ,  drawpos.Y ,Size.X, Size.Y)
			
		Else if _showBorder Then 
			
			SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
			DrawRect(drawpos.X, drawpos.Y, Size.X, Size.Y)
			SetColor(255, 255, 255)
			DrawRect(drawpos.X + 1, drawpos.Y + 1, Size.X - 2, Size.Y - 2)
		
		EndIf
		
		'' selected item
		if _owner.SelectedItem = Self Then 
		
			SetColor 202,225,252
			DrawRect (drawpos.X ,  drawpos.Y ,Size.X, Size.Y)
			SetColor 125,162,206
			DrawRoundBox (drawpos.X ,  drawpos.Y ,Size.X, Size.Y)

		EndIf
	
		

		if _img <> null Then 
			
			'' Calculate image scaling factor
			Local scale# = Min( 
				float(Size.X-_owner._iconSpacing*2) / float(_img.Width),
				float(Size.X-_owner._iconSpacing*2) / float(_img.Height+_textHeight))
			
			'' Draw item image
			SetColor(255, 255, 255)
			DrawImage(_img, 
				drawpos.X + Size.X / 2 - float(_img.Width * scale) / 2 ,
				drawpos.Y + (Size.Y - _textHeight) / 2 - float(_img.Height * scale) / 2 , 
				0,scale, scale)
				
		End 

		if _text <> "" Then 
		
			'' Draw item text
			Local textHeight = Font.GetTxtHeight(_text)
			Local textWidth = Font.GetTxtWidth(_text)
			
			Local i = 0
			Local displayStr$ = ""
			While( _text.Length>i) 
				i+=1
				displayStr = _text[0..i]
				if Font.GetTxtWidth(displayStr) >= Size.X-20 Then 
					displayStr = _text[0..(i-1)] + ".."
					Exit 
				EndIf
			Wend  

			ForeColor.Activate()
			Font.DrawText(displayStr, drawpos.X + Size.X / 2, drawpos.Y + Size.Y - _textHeight , eDrawAlign.CENTER )
		End 
		
		if HasFocus Then
			GetGui.Renderer.DrawFocusRect(Self, True)
		End			 
	End 
End


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
	Field _vSpacing = 10, _hSpacing = 10
	Field _itemWidth = 96, _itemHeight = 96
	Field _font:BitmapFont
	Field _countX:Int 
	Field _countY:Int 
	Field _lastScroll = 0
	Field _overControl:Control
	Field _iconSpacing:Int = 10
	Field _hScrollStep = 10
	Field _autoSize? = true 
	
	Field _selectedIndexChanged:= new EventHandler<EventArgs>
	Field _event_ItemAdded:= new EventHandler<EventArgs>
	Field _event_ItemRemoved:= new EventHandler<EventArgs>
		
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
		lv._owner = Self 
		Event_ItemAdded.RaiseEvent( Self, new EventArgs())
		UpdateScrollBar()
	End
	
	Method InitControl()
		_items = New ListViewItemCollection(Self)
		Padding.Right = ScrollBarContainer.DefaultWidth
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
	
	Method SetItemSpacing(width, height)
		_vSpacing = width 
		_hSpacing = height 
		UpdateScrollBar()
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
	
	'' summary:  Gets the items that are selected in the control.
	Method SelectedItem:ListViewItem() Property
		Return _selectedItem
	End
	
	'' summary:  Gets a collection containing all items in the control.
	Method Items:ListViewItemCollection() Property
		Return _items
	End
	
	Method UpdateScrollBar( )
		
		if Items And Items.Count > 0 Then 
		
			_countX = Max(1, GetClientAreaSize.X / (_itemWidth + _vSpacing))
			_countY = Items.Count  / _countX  + 1 
	
			
			Local index = 0
			Local ix = 0
			Local iy = 0
			For Local item:= eachin _items
				
				item.Size.SetValues(_itemWidth,_itemHeight)
	
				item.Position.SetValues(
					_hSpacing + (_itemWidth + _hSpacing ) * ix,
					_vSpacing -_scrollbar.Value *_hScrollStep + (_itemHeight + _vSpacing ) * iy )
		
				ix+=1
				index+=1
				if index Mod _countX = 0 Then 
					iy+=1
					ix = 0
				End 
			Next
	
			''
			'' update scrollbar -  TODO: Does not work, needs to be fixed...
			''
			
			Local _visibleItems:= Max(0, int(GetClientAreaSize.Y / (_itemHeight + _vSpacing)))
			_scrollbar.ItemsCount = _countY*_itemHeight / _hScrollStep
			_scrollbar.VisibleItems = _visibleItems*_itemHeight / _hScrollStep 

			If _scrollbar.Value > _scrollbar._itemsCount - _scrollbar._visibleItems Then
				_scrollbar.Value = _scrollbar._itemsCount - _scrollbar._visibleItems
			EndIf
		End 
	End
	
	Method Update()
		Super.Update()
		if _lastScroll <> _scrollbar.Value Then 
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
End