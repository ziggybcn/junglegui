#rem monkeydoc Module junglegui.tabcontrol
	This module contains the TabControl implementation for JungleGui
#END
Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

#rem monkeydoc
	This Control is a Tabbed Container.
	It works by containing [[TabPage]]s. Each tab page can have a name and some controls in it.
#END
Class TabControl Extends ContainerControl 
	Method New()
		Padding.Top = 25
		'BackgroundColor = New GuiColor(1, 0, 0, 50)
	End	
	
	Method Render:Void()
		Local posx:Int = Self.UnsafeRenderPosition.X
		Local posy:Int = Self.UnsafeRenderPosition.Y
		Super.Render()
		RenderHeaders()
	End
	
	#rem monkeydoc
		This method is internally called by the control whenever it needs to render the [[TabPage]] headers of the contained TabPages
	#END
	Method RenderHeaders()
		Local index:Int = 0
		For Local c:Control = EachIn Self.GenerateControlsList(True)
			Local tp:= TabPage(c)
			RenderOneHeader(tp, index)
			index += 1
		Next
		
	End
	
	#rem monkeydoc
		This method is internally called by the control whenever it needs to render one specific [[TabPage]] header.
	#END
	Method RenderOneHeader(tp:TabPage, index:Int)
		Local pos:= Self.LocationInDevice()
		Local width:Float = Size.X / Float(TabPagesCount)
		
		_cachePos.SetValues( (pos.X + width * index) + 0.5, pos.Y)
		_cacheSize.SetValues(width + 0.5, Padding.Top)
		Local status:Int = eControlStatus.NONE
		SetColor(255, 255, 255)
		If index = requestClickTab And tp <> selectedTab Then
			requestClickTab = -1
			SelectedTab = tp
		EndIf
		If tp = selectedTab Then
			tp.BorderColor.Activate()
			DrawRect(_cachePos.X, _cachePos.Y, _cacheSize.X, _cacheSize.Y)
			tp.BackgroundColor.Activate()
			DrawRect(_cachePos.X + tp.Padding.Left, _cachePos.Y + tp.Padding.Top, _cacheSize.X - tp.Padding.Left - tp.Padding.Left, _cacheSize.Y)
		Else
			If requestHoover = index Then status = eControlStatus.HOOVER
			GetGui.Renderer.DrawButtonBackground(status, _cachePos, _cacheSize, Null)
		EndIf
		GetGui.Renderer.DrawLabelText(status, _cachePos, _cacheSize, tp.Text, eDrawAlign.CENTER, Gui.systemFont, Null)
		SetColor(255, 255, 255)
	End
	
	Method Msg(msg:BoxedMsg)
	
		If msg.e.messageSignature = eMsgKinds.CHILD_ADDED
			Local control:= Control(msg.sender)
			If control <> Null And control.Parent = Self Then
				'Print("Added control to the TAB container")
				TabPagesCount += 1
				control.Position.SetValues(0, 0)
				control.Size.SetValues(ClientSize.X, ClientSize.Y)
				If TabPage(control) Then SelectedTab = TabPage(control)
			EndIf
		ElseIf msg.e.messageSignature = eMsgKinds.CHILD_REMOVED
			Local control:= Control(msg.sender)
			If control <> Null And control.Parent = Self Then
				TabPagesCount -= 1
			EndIf
		EndIf
		If msg.sender = Self Then
			Select msg.e.messageSignature
				Case eMsgKinds.RESIZED
					For Local c:Control = EachIn Self.GenerateControlsList(True)
						ClientSize.CloneHere(c.Size)
					Next
				Case eMsgKinds.MOUSE_MOVE
					Local mousee:= MouseEventArgs(msg.e)
					If mousee <> Null Then
						If mousee.position.Y < Padding.Top and TabPagesCount > 0 Then
							requestHoover = GetTabIndexByPos(mousee.position.X)
						Else
							requestHoover = -1
						EndIf
					EndIf
				Case eMsgKinds.CLICK
					Local mousee:= MouseEventArgs(msg.e)
					If mousee <> Null Then
						If mousee.position.Y < Padding.Top and TabPagesCount > 0 Then
							requestClickTab = GetTabIndexByPos(mousee.position.X)
						EndIf
					EndIf
				Case eMsgKinds.MOUSE_LEAVE
						requestHoover = -1
				
			End Select
		EndIf
	
		Super.Msg(msg)
	End
	
	
	#rem monkeydoc
		This property allows you to select a given [[TabPage]] as the currently active tab.
	#END
	Method SelectedTab:Void(value:TabPage) Property
		
		If value <> Null Then
			Local found:Bool = False
			For Local c:Control = EachIn Self.GenerateControlsList(True)
				If c = value Then
					found = True
					Exit
				EndIf
			Next
			If found = False Then
				'TODO: throw an exception?
				Return
			EndIf
		EndIf
		 If selectedTab <> Null and selectedTab.Visible Then selectedTab.Visible = False
		requestClickTab = -1
		selectedTab = value
		If selectedTab <> Null and selectedTab.Visible = False Then selectedTab.Visible = True
		Event_SelectedTabChanged.RaiseEvent(Self, New EventArgs(eMsgKinds.EMPTYMSG))
	End
	
	Method SelectedTab:TabPage() Property
		Return selectedTab
	End

	#rem monkeydoc
		This event is fired every time the selected tab changes.
	#END
	Method Event_SelectedTabChanged:EventHandler<EventArgs>() Property; Return _selectedTab; End

	Private
	Field TabPagesCount:Int = 0
	Field _cachePos:= New GuiVector2D
	Field _cacheSize:= New GuiVector2D
	Field selectedTab:TabPage
	Field requestHoover:Int = -1
	Field requestClickTab:Int = -1
	Field _selectedTab:= New EventHandler<EventArgs>
	
	Method GetTabIndexByPos:Int(x:Int)
		Return x / (Self.Size.X / Float(TabPagesCount))
	End
End

#rem monkeydoc
	This control is a TabPage. When a TabPage is the child of a TabControl it can be rendered in the form of a selectable multi-document tab interface.
#END
Class TabPage Extends ContainerControl

	Method New()
		_initControl
	End
	
	Method New(caption:String)
		_initControl
		Text = caption
	End

	#rem monkeydoc
		This property is the text of the tab caption.
	#END
	Method Text:String() Property
		Return text
	End
	Method Text:Void(value:String) Property
		If text = value Then Return
		text = value
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.TEXT_CHANGED)))
	End
	
'	Method BorderColor:GuiColor() Property
'		Return _borderColor
'	End
'	
'	Method BorderColor:Void(value:GuiColor) Property
'		If value = Null Then value = SystemColors.AppWorkspace
'		_borderColor = value
'		 
'	End
	
	Method RenderBackground()
		Local pos:= Self.UnsafeRenderPosition
		BorderColor.Activate()
		DrawRect(pos.X, pos.Y, Size.X, Size.Y)
		BackgroundColor.Activate()
		DrawRect(pos.X + Padding.Left, pos.Y + Padding.Top, Size.X - Padding.Left - Padding.Right, Size.Y - Padding.Top - Padding.Bottom)
		SetColor(255, 255, 255)
	End

	Private
	'Field _borderColor:GuiColor = SystemColors.AppWorkspace
	Field text:String
	
	
	
	Method _initControl()
		Padding.SetAll(2, 2, 2, 2)
		Self.BackgroundColor = SystemColors.HooverBackgroundColor
	End
End