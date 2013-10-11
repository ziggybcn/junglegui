Import junglegui
#REFLECTION_FILTER+="junglegui.tabcontrol*"
#REM
	header: This control is [b]highly in development[/b]. It's not yet complete and not ready for production.
	Feel free to use it at your own risk, but current implementation is highly subject to change.
#End


Class eTabSizeMode
	'summary: The width of each tab is sized to accommodate what is displayed on the tab
	Const Normal = 0
	'summary: All tabs in a control are the same width.
	Const Fixed = 0	
End


'summary: Represents a single tab page in a TabControl.
Class TabPage extends ContainerControl

Private 

	Field _text:String 
	
Public 

	Method New(text:String)
		_text = text 
		BackgroundColor.SetColor(1,255,255,255)
	End
	
	Method Text:String() Property
		return _text 
	End
	
	Method Text:Void(text:String)
		_text = text 
	End
	
End 

Class TabControlCancelEventArgs Extends EventArgs 
	Field TabPage:TabPage
	Field TabPageIndex:Int 
	Field Cancel:Bool 
	Method new(  tabPage:TabPage, tabPageIndex, cancel:Bool)
		TabPage = tabPage
		TabPageIndex = tabPageIndex
		Cancel = cancel 
	End
End 

Class TabControlEventArgs Extends EventArgs 
	Field TabPage:TabPage
	Field TabPageIndex:Int 
	Method new(tabPage:TabPage, tabPageIndex)
		TabPage = tabPage
		TabPageIndex = tabPageIndex
	End
End 

'summary: Manages a related set of tab pages.
Class TabControl extends ContainerControl  


Private 

	Field _eventSelected:= new EventHandler<TabControlEventArgs>
	Field _eventSelecting:= new EventHandler<TabControlCancelEventArgs>
	
	Field _pages:TabPageCollection 
	Field _tabCount:Int = 0
	Field _selectedTab:TabPage  
	Field _selectIndex:Int  = -1
	Field _itemSize:= new GuiVector2D
	Field _font:BitmapFont 
	Field _sizeMode = eTabSizeMode.Normal 
	
Public 

	Method new()
		_pages = New TabPageCollection(Self)
		_itemSize.SetValues(32,24)
		Padding.Top = 4
		Padding.Left = 4
	End
	
	Method Dispatch(msg:BoxedMsg)
		Select msg.e.messageSignature

			Case eMsgKinds.RESIZED
				
				For Local p:TabPage = eachin _pages
					p.Size.SetValues(
						Size.X - Padding.Left*2, 
						Size.Y-_itemSize.Y-Padding.Top*2)
				End 

			Case eMsgKinds.CLICK
			
				Local me:= MouseEventArgs(msg.e)
				
				Local mx= me.position.X
				Local my= me.position.Y
				
				Local x= Padding.Left 
				Local height:= _itemSize.Y
				Local index = 0
					
				For Local p:TabPage = eachin _pages
						
					Local str:= p.Text 
					Local width = Font.GetTxtWidth(str) + Padding.Left * 2
					
					if mx >= x And mx < x +width And my < height Then 
						SetSelectedTabPage(p, index)
						Exit 
					EndIf
					
					index+=1
					x+=width 
				Next
			
		End
		
		Super.Dispatch(msg)
	End
	
	''
	'' Events
	'' 
	
	'summary: Occurs when a tab is selected.
	Method Event_Selected:EventHandler<TabControlEventArgs>() Property
		 return _eventSelected
	End

	'summary: Occurs before a tab is selected, enabling a handler to cancel the tab change.
	Method Event_Selecting:EventHandler<TabControlCancelEventArgs>() Property
		return _eventSelecting
	End	
	 
	
	''
	'' Properties
	''
	
	'summary: Gets the collection of tab pages in this tab control.
	Method TabPages:TabPageCollection() Property
		Return _pages
	End
	
	'summary: Gets the number of tabs in the tab strip.
	Method TabCount:Int() Property
		return _tabCount
	End
	
	'summary: Gets the currently selected tab page.
	Method SelectedTab:TabPage() Property
		return _selectedTab
	End 
	
	'summary: Gets the index of the currently selected tab page.
	Method SelectedIndex:Int() Property
		Return _selectIndex
	End 
	
	'summary: Sets the currently selected tab page.
	Method SelectedTab:Void(value:TabPage) Property
	
		if value = _selectedTab Then Return 
		
		Local index = 0
		For Local p:= eachin _pages
			if p = value Then 
				SetSelectedTabPage(p,index)
				Return  
			EndIf
			index+=1
		Next
		
		'' Error ?
		
	End 
	
	'summary: Sets the index of the currently selected tab page.
	Method SelectedIndex:Void(value:Int) Property
	
		if value = _selectIndex Then Return 
		
		if value < 0 Then 
			'' Error ?
		End 
		
		Local index = 0
		For Local p:= eachin _pages
			if index = value Then 
				SetSelectedTabPage(p,index)
				Return  
			EndIf
			index+=1
		Next
		
		'' Error ?
		
	End
	
	'summary: Gets or sets the size of the control's tabs.	
	Method ItemSize:GuiVector2D()
		Return _itemSize
	End
	
	'summary: Gets the font of the text displayed by the control.
	Method Font:BitmapFont() property
		if _font<>null Then Return _font Else Return GetGui.systemFont
	End
	
	'summary: Sets the font of the text displayed by the control.
	Method Font:Void(value:BitmapFont) Property
		_font = value
	End
	
	'summary: Gets the way that the control's tabs are sized.
	Method SizeMode:Int() Property
		Return _sizeMode
	End
	
	'summary: Sets the way that the control's tabs are sized.
	Method SizeMode:void(value:int) Property
		_sizeMode = value
	End
	
	
	''
	'' Control
	''

	Method Render:Void()
	
		Local drawpos:= UnsafeRenderPosition()
		Super.Render()
		
		Local index:= 0
		Local x:Float = drawpos.X
		Local y:Float = drawpos.Y
		Local height:Float = _itemSize.Y+1
		
		For Local p:TabPage = eachin _pages
				
			Local str:= p.Text 
			Local width:= Font.GetTxtWidth(str) + Padding.Left * 2 
			Local fontheight2:= Font.GetTxtHeight(str)/2
			
			SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
			DrawRect(x, y, width, height)
			
			if _selectedTab = p Then 
				SetColor(255,255,255)
				DrawRect(x ,  y ,width,height)
			End 

			ForeColor.Activate()
						Font.DrawText(str, 
						int(x + width / 2), 
						Int(y + height / 2  - fontheight2), 
						eTextAlign.CENTER)
			
			x+=width 
			index+=1
		Next
		
	End 
	
	
	''
	'' internal 
	''
	
Private 

	Method SetSelectedTabPage(p:TabPage, index:Int)
	
		Local eventArgs:= new TabControlCancelEventArgs(p, index, false)
											
		Event_Selecting.RaiseEvent( Self, eventArgs )
		
		if Not eventArgs.Cancel Then 
			
			if _selectedTab Then 
				_selectedTab.Visible = False 
			EndIf

			_selectedTab = p 
			_selectIndex = index 
			_selectedTab.Visible = True 
			
			Event_Selected.RaiseEvent(Self, New TabControlEventArgs(p,index))
		
		EndIf
		
	End
	
	Method OnPageAdd(page:TabPage)
		_tabCount+=1
		page.Parent = Self 
		page.Position.SetValues(0,_itemSize.Y+1)
		page.Size.SetValues( Self.Size.X-Padding.Left*2, Self.Size.Y -_itemSize.Y - Padding.Top  * 2-2)
	End 
	
	Method OnPageRemove(page:TabPage)
		_tabCount-=1
		page.Parent = Null 
	End
	
	Method OnClear()
		For Local p:TabPage = eachin _pages
			p.Parent = Null 
		End 
		_tabCount = 0
	End
	
End


Class TabPageCollection extends List<TabPage>

private

	Field _owner:TabControl
	
Public

	Method New(owner:TabControl)
		_owner = owner
	End

	Method Clear()
		_owner.OnClear()
		Super.Clear()
	End

	Method RemoveFirst:TabPage()
		local obj:= Super.RemoveFirst()
		_owner.OnPageRemove(obj)
		Return obj
	End

	Method RemoveLast:TabPage()
		local obj:= Super.RemoveLast()
		_owner.OnPageRemove(obj)
		Return obj
	End
	
	Method AddFirst:list.Node<TabPage>(data:TabPage)
		Local node:= Super.AddFirst(data)
		_owner.OnPageAdd(data)
		Return node
	End

	Method AddLast:list.Node<TabPage>(data:TabPage)
		Local node:= Super.AddLast(data)
		_owner.OnPageAdd(data)
		Return node
	End
	
	Method EstimatedCount:Int()
		Return _owner._tabCount
	End
	
	Method RemoveEach(value:TabPage)
		Local mynode:= FirstNode()
		While mynode
		        If mynode.Value = value Then
					mynode.Remove()
					_owner.OnPageRemove(value)	'We get track of how many times an item has been removed. One call each time.
		        Endif
		        mynode = mynode.NextNode()
		Wend
	End
	
End