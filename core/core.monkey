#Rem monkeydoc Module junglegui.core
	This module contains the base core components of Jungle gui
#End

Import junglegui
Import designtimeinfo
Import econtrolstatus
Import guiapp
Import guicolor
Import guiexception
Import guiinterfaces
Import guivector2d
Import padding
Import renderer
Import viewportstack
Import helperfunctions
Import scaledscrissor
Import msglistener
Import mousepointer

#REFLECTION_FILTER+="${MODPATH}"

#Rem monkeydoc 
	this is the base class of a JungleGui control
#End
Class Control Implements DesignTimeInfo

	Public
	
	Method PropertiesDescriptor:List<DTProperty>()
		Local list:= New List<DTProperty>
		Local prop:= New DTProperty("Position", GetClass(Self.Position))
		list.AddLast(prop)
		prop.Validate(Self)
	End
	
	#Rem monkeydoc 
		This property contains the name of the control. Controls can have a Name that can be used for debugging purposes.
	#End
	Method Name:String() Property
		Return _name
	End
	
	Method Name:Void(value:String) Property
		_name = value
	End
	
	#Rem monkeydoc 
		This method the base control constructor.
	#End
	Method New()
		_GuiVector2D.SetNotifyControl(Self, eMsgKinds.MOVED)
		_drawingSize.SetNotifyControl(Self, eMsgKinds.RESIZED)
	End
	
	#Rem monkeydoc 
		This read-only property returns a GuiVector2D that contains the X and Y coordinates where the control is placed.
		Remember that this position is relative to the control container.
	#End
	Method Position:ControlGuiVector2D() Property
		Return _GuiVector2D
	end

	'summary: this is the location of the control in the parent container control
	#REM monkeydoc
		This read-only property returns a GuiVector2D that contains the X and Y size of the control.
		The X component represents the control Width, and the Y components represents the control Height
	#END
	Method Size:ControlGuiVector2D() Property
		Return _drawingSize
	end

	
	#Rem monkeydoc 
		This property returns the Background Color of this control. It's returned in the form of a GuiColor instance.
		Most controls have a default BackgroundColor that is defined into SystemColors, so modifying it in one control, could make the color to be modified also on any other control using the same color for rendering.
		If you want to modify the backgroun color of a control without affecting other colors that could be using the same BackgroundColor, you can set it to a clone:
		`myControl.BackgroundColor = myControl.BackgroundColor.Clone()`		
	#End
	Method BackgroundColor:GuiColor() Property 
		Return _backgroundColor
	End
	
	'This has to be overriden in control containers
	
	Method BackgroundColor:GuiColor(value:GuiColor) Property
		If value <> Null Then
			_backgroundColor = value 
		Else
			Throw New JungleGuiException("Background color can't be set to null", Self)
		EndIf
		Return _backgroundColor 
	End

	#Rem monkeydoc 
	This property returns the ForeColor of this control.
	Most controls have a default ForeColor that is defined into SystemColors, so modifying it in one control, could make the color to be modified also on any other control using the same color for rendering.
	#End
	Method ForeColor:GuiColor() Property 
	#if TARGET="html5" 
		Return _htmlforecolor  '.Clone() 'SetColor(255,255,255)
	#end
		Return _foreColor
	end
	
	Method ForeColor:GuiColor(value:GuiColor) Property
		if value<>null Then 
			_foreColor = value 
		Else
			Throw New JungleGuiException("Fore color can't be set to null",Self)
		EndIf
		Return _foreColor
	End

	#Rem monkeydoc 
	This Render method is automatically called when the control needs to be drawn on the screen.
	The Gui engine will determine if a control needs to be drawn or not depending of its placement on screen, device and containers visibility.
	#End
	Method Render:Void()
		Local color:Float[] = GetColor()
		Self.BackgroundColor.Activate()
		'DrawRect(_gui.currentRenderPos.X, _gui.currentRenderPos.X, Size.X, Size.Y)		
		DrawRect(UnsafeRenderPosition.X, UnsafeRenderPosition.Y, Size.X, Size.Y)
		SetColor(color[0], color[1], color[2])
	End
	
	#Rem monkeydoc 
		<font color=red><b>Advanced usage only</b></font><br>This method is internally used to build and control the internal status changes messaging system of the Gui system.
	#End	
	Method Msg(msg:BoxedMsg)
		If Not _gui Then Return
		If _parentControl <> Null Then
			Control(_parentControl).Msg(msg)
		EndIf
		NotifyMsgListeners(msg)
		If msg.sender = Self And msg.status = eMsgStatus.Sent Then
			Dispatch(msg)
		EndIf
		
	End
	
	#Rem monkeydoc
		This returns the Gui engine where this control is running.
	#END
	Method GetGui:Gui()
		Return _gui
	End
	
	#Rem monkeydoc
		 This method TRUE if this control is a Top level control (a window)
		 A Top Level Control is a control that can't be set as a child of another control. As instance, a window is a container of controls, but can't be set as a child of other controls.
		 The most typical Top Level Controls are a [[Form]] and a [[WindowsFrame]]
	 #END
	Method IsTopLevelControl?()
		Return false
	End
	
	#Rem monkeydoc
		This returns TRUE if this control is a control container that can contain child controls. Otherwise, this method returns False.
	#End
	Method IsContainer?()
		Return ContainerControl(Self) <> Null
	End

	
	Method DeviceToControlX:Float(x:float)
		Return x - UnsafeRenderPosition.X
	End
	
	Method DeviceToControlY:Float(y:Float)
		Return y - UnsafeRenderPosition.Y
	End
	
	Method ControlToDeviceX:Float(x:Float)
		Return x + UnsafeRenderPosition.X
	End
	
	Method ControlToDeviceY:Float(y:Float)
		Return y + UnsafeRenderPosition.Y
	End
	
	
	#Rem monkeydoc
		This get/set property can be used to set the container of a given control.
		As instance, to place a button in a Form or a Panel, you need to set the Parent property of the button to the desired container.
		Notice that any TopLevelControl will always have a null parent as those controls can't be children of other controls.
	#End
	Method Parent:ContainerControl() Property
		Return _parentControl
	End
  	
	#Rem monkeydoc
		 This get/set property can be used to set the container of a given control.
	 #END
	Method Parent:ContainerControl(parentControl:ContainerControl) Property
		If parentControl = Null And _parentControl = Null Then Return
		If _parentControl = parentControl Then
			If _gui <> parentControl._gui Then
				_gui = parentControl._gui
			Else
				Return
			EndIf
		EndIf
		If _parentControl <> Null Then
			_parentControl.controls.RemoveEach(Self)
			'Msg(Self,New EventArgs(eMsgKinds.PARENT_REMOVED))
			Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.PARENT_REMOVED)))
			_parentControl.Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.CHILD_REMOVED)))
		EndIf
		If parentControl <> Null Then
 			_parentControl = parentControl
 			parentControl.controls.AddLast(Self)
			'Msg(Self,New EventArgs(eMsgKinds.PARENT_SET))
 			Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.PARENT_SET)))
			_parentControl.Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.CHILD_ADDED)))
 			_gui = parentControl._gui
		Else
 			_gui = Null
		EndIf
	End
	
	
	#Rem monkeydoc
		This method brings the control to the front of the Z-Order
	 #END
	Method BringToFront()
		if _parentControl = null Then Return
		_parentControl.controls.RemoveEach(Self)
		_parentControl.controls.AddLast(Self)
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.BRING_TO_FRONT)))
	End
	
	#Rem monkeydoc
		This method sends the control to the back of the Z-Order
	 #END
	Method SendToBack()
		if _parentControl = null Then Return
		_parentControl.controls.RemoveEach(Self)
		_parentControl.controls.AddFirst(Self)
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.SEND_TO_BACK)))
	End
	
	#Rem monkeydoc
		This method will return the Top Level Container where this control is located.
		Notice that this Method can be slightly slow on complex Parent/Child control's chain, so it is advised to use with caution.
	#end
	Method GetTopLevelContainer:TopLevelControl()
		Local p:Control = Self
		While p.Parent <> Null
			p = p.Parent
		Wend
		Return TopLevelControl(p)
	End
	
	#Rem monkeydoc
		This method will clear all resources used by the control and its child controls. This is automatically called by the Gui system when the control needs to "die".
	 #END
	Method Dispose()
		Parent = null
		_parentControl = null
		_GuiVector2D.SetNotifyControl(null, 0)
		_drawingSize.SetNotifyControl(null, 0)
		_gui = Null
	End
	
	#Rem monkeydoc
		This method returns the internal GuiVector2D that contains the latest known render position on screen device.
		Calculating the exact render position of a control on screen can be a slow operation, so it's done just once per control render.
		The results of this calculation is stored internaly, and can be inspected by using this method.
		While this information is useful to perform quick render operations, modifying this vector values can cause rendering artifacts.<br>To use a safer way to manipulate this vector see [[LocationInDevice]]
	 #END
	Method UnsafeRenderPosition:GuiVector2D()
	
		Return _lastRenderPos '_gui.currentRenderPos
	
	End
	
		
	#Rem monkeydoc
		This is automatically called by the Gui engine when the control needs to be updated and process its internal logic.
		This method should only be overriden when designing controls that need to update or calculate its internal logic on every "OnUpdate" of the Mojo App.
		This is considered a low level method reserved for controls design. It is advised to not use it to control program flow or logic, as its internal usage may be modified in future JungleGui versions.
	 #END
	Method Update()
		If listeners <> Null And listeners.IsEmpty = False
		
			For Local listener:MsgListener = EachIn listeners
				listener.Update()
				
			Next
		EndIf
	End

	#Rem monkeydoc
		This is a Get/Set property that indicates if a control is navigable using the TAB key (keyboard navigation)
	#END
	Method TabStop:Bool() Property
		Return _tabStop
	End
	
	Method TabStop:Bool(value:Bool) Property
		_tabStop = value
		Return _tabStop
	end
	
	#Rem monkeydoc 
		This method will bring the Gui focus to this control.
	#END
	Method AssignFocus()
		if Not _gui Then return
		if _gui._focusedControl = Self Return
		If _gui._focusedControl <> Null Then
			_gui._focusedControl.Msg(New BoxedMsg(_gui._focusedControl, New EventArgs(eMsgKinds.LOST_FOCUS)))
		EndIf
		_gui._focusedControl = self
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.GOT_FOCUS)))
	End
	
	#Rem monkeydoc 
		This method will give the focus to the next control that can take it. It has the same effect that pressing the TAB key on keyboard navigation.
	#END
	Method FocusNext()
		if Parent = null Then return	'Unparented controls can't do focus next.
		Local currentheight = 16000000 'self.Position.Y-1
		Local currentWidth = 16000000
		Local focused:Control = null
		For Local c:Control = EachIn Self.Parent.controls
			if c.Position.Y<Self.Position.Y Then Continue
			if c = Self Then Continue
			if c.TabStop = False Then Continue
			if c.Position.Y<currentheight Then
				Local doSet:Bool = false
				if c.Position.Y<>Position.Y Then 
					doSet = true
				ElseIf c.Position.X>=Position.X 
					doSet = true
				EndIf
				if doSet then
					focused = c
					currentheight = c.Position.Y 
					currentWidth = c.Position.X
				endif
			ElseIf c.Position.Y=currentheight Then
				if c.Position.X<currentWidth Then
					Local doSet:Bool = false
					if (c.Position.Y <> Position.Y) Then 
						doSet = true
					ElseIf (c.Position.X>=Position.X)
						doSet = true
					endif
					if doSet Then
						focused = c
						currentWidth = 16000000
					EndIf
				EndIf
			EndIf
		Next
		if focused = null Then 
			if Parent <>null Then 
				Parent.AssignFocus()	'Era el último mohicano, volvemos al parent y escojemos el siguiente tío.
				Parent.FocusNext()
			Else
				_NavigationGotFocus()		
			endif
		ElseIf focused <> Self Then
			focused._NavigationGotFocus()
		Else
			_NavigationGotFocus()
		EndIf
	End

	#Rem monkeydoc 
		This will return True for all controls that are based on a graphical interface such as buttons, labels, etc.
		Non graphical controls, such as a Timer, return False.
	#END
	Method HasGraphicalInterface:Bool() property
		Return True
	end

	#Rem monkeydoc
		This method returns the client area location on the current mojo canvas. That is, the canvas X and Y location of the control contents.
		Notice that this information is based on latest known render location, and it will be updated on every frame.
	 #END
	Method ClientLocation:GuiVector2D()
		Local location:= New GuiVector2D
		ClientLocation(location)
		Return location
	End
	
	Method ClientLocation:Void(target:GuiVector2D)
		UnsafeRenderPosition().CloneHere(target)
		If ContainerControl(Self) Then
			Local container:= ContainerControl(Self)
			target.X += container.Padding.Left + container.ControlBordersSizes.Left
			target.Y += container.Padding.Top + container.ControlBordersSizes.Top
		EndIf
	End

	#Rem monkeydoc
		This method returns the client area size of the control on the current mojo canvas. That is, the width and height of the control.
	 #END
	Method ClientSize:GuiVector2D()
		Local size:= New GuiVector2D
		ClientSize(size)
		Return size
	End

	Method ClientSize(target:GuiVector2D)
		Size.CloneHere(target)
		If ContainerControl(Self) Then
			Local container:= ContainerControl(Self)
			target.X -= container.Padding.Left + container.Padding.Right + container.ControlBordersSizes.Left + container.ControlBordersSizes.Right
			target.Y -= container.Padding.Top + container.Padding.Bottom + container.ControlBordersSizes.Top + container.ControlBordersSizes.Bottom
		EndIf
	End
	
	#Rem monkeydoc
		This method returns the control location on the current mojo device. That is, the canvas X and Y location of the control location.
		This information is based on latest known render position of the control and it is updated once per frame.
	 #END
	Method LocationInDevice:GuiVector2D()
		Return UnsafeRenderPosition.Clone()
	End
	
	#Rem monkeydoc
		This method returns the control size on the current mojo device. That is, the canvas X and Y size of the control.
		While the Size property returns access to the direct Size vector, this proeprty is safer as it returns a clone of it.
	 #END
	Method SizeInDevice:GuiVector2D()
		Return Size.Clone()
	End

	
	#Rem monkeydoc
		Returs True if the control is currently the Gui focused control.
	 #END
	Method HasFocus:Bool()
		Return _gui._focusedControl = self
	End
	
	#Rem monkeydoc
		This property can be set to True or False in order to show or hide this control.
	 #END
	Method Visible:Bool() Property
		Return _visible
	End
	
	Method Visible:Void(value:Bool) Property
		If value <> _visible Then
			_visible = value
			Msg(New BoxedMsg(Self, eMsgKinds.VISIBLE_CHANGED))
		endif
	End

	#Rem monkeydoc
		This property alows you to get/set the text to be displayed as a control hint pop-up when the mouse is over the control.
	 #END
	Method TipText:Void(value:String) Property
		_tipText = value
	End
	
	Method TipText:String() Property
		Return _tipText
	End
		
	#Rem monkeydoc
		This is the color used to draw the control background when the mouse is over the control.
		Most controls have a default HooverColor that is defined into SystemColors, so modifying it in one control, could make the color to be modified also on any other controls using the same color instance for rendering.
	#End
	Method HooverColor:GuiColor() Property
		if _hooveColor <> null Then Return _hooveColor Else Return SystemColors.HooverBackgroundColor
	End
	
	Method HooverColor:GuiColor(value:GuiColor) Property
		_hooveColor = value
	End

	#Rem monkeydoc
		This property returns the color used to draw the control border (if any).
	 #END
	Method BorderColor:GuiColor() Property
		if _borderColor = Null then return SystemColors.ButtonBorderColor else Return _borderColor
	End

	Method BorderColor:GuiColor(value:GuiColor) Property
		If value <> Null Then
			_borderColor = value
		Else
			Throw New JungleGuiException("Border color can't be null.", Self)
		endif
	End

	#Rem monkeydoc
		summary: *Low level method* that deals with event signatures.
		This method is part of the internal core functionality of the control and should not be used on regular Jungle Gui coding.
		The Dispach method is internally used to convert low level messages to high level events. This method is automatically called by the internal Jungle Gui core engine whenever a message has been validated in all the message-parent-control chain and it hasn't been handled by any parent control.
		For more information, read the Jungle Gui wiki at googlecode here: [[http://code.google.com/p/junglegui/wiki/WelcomePage?tm=6|Jungle Gui wiki]].
	 #END
	Method Dispatch(msg:BoxedMsg)
		if Not _gui Then return
		Select msg.e.messageSignature
			Case eMsgKinds.BRING_TO_FRONT
				_bringToFront.RaiseEvent(msg.sender, msg.e)

				
			Case eMsgKinds.CHECKED_CHANGED	'Set on the checkbox control

			
			Case eMsgKinds.CLICK
				_eventClick.RaiseEvent(Self, MouseEventArgs(msg.e))

			Case eMsgKinds.GOT_FOCUS
				If _requiresVirtualKeyboard Then
					EnableKeyboard()
				Else
					DisableKeyboard()
				EndIf
				_gotFocus.RaiseEvent(Self, msg.e)
								
			Case eMsgKinds.INIT_FORM		'Set on TopLevel control

			
			Case eMsgKinds.KEY_DOWN
				_keyDown.RaiseEvent(msg.sender, KeyEventArgs(msg.e))
			Case eMsgKinds.KEY_PRESS
				_keyPress.RaiseEvent(msg.sender, KeyEventArgs(msg.e))
			Case eMsgKinds.KEY_UP
				_keyUp.RaiseEvent(msg.sender, KeyEventArgs(msg.e))
			Case eMsgKinds.LOST_FOCUS
				_lostFocus.RaiseEvent(msg.sender, msg.e)
			Case eMsgKinds.MOUSE_DOWN
				_mouseDown.RaiseEvent(msg.sender, MouseEventArgs(msg.e))
			Case eMsgKinds.MOUSE_MOVE
				_mouseMove.RaiseEvent(msg.sender, MouseEventArgs(msg.e))
			Case eMsgKinds.MOUSE_UP
				_mouseUp.RaiseEvent(msg.sender, MouseEventArgs(msg.e))
			Case eMsgKinds.MOUSE_ENTER
				_mouseEnter.RaiseEvent(msg.sender, msg.e)
			Case eMsgKinds.MOUSE_LEAVE
				_mouseLeave.RaiseEvent(msg.sender, msg.e)
			Case eMsgKinds.MOVED
				_moved.RaiseEvent(msg.sender, msg.e)
			Case eMsgKinds.PADDING_MODIFIED
				_paddingModified.RaiseEvent(msg.sender, msg.e)
			Case eMsgKinds.PARENT_REMOVED
				_parentRemoved.RaiseEvent(msg.sender, msg.e)
			Case eMsgKinds.PARENT_RESIZED
				_parentResized.RaiseEvent(msg.sender, msg.e)
			Case eMsgKinds.PARENT_SET
				_parentSet.RaiseEvent(msg.sender, msg.e)
			Case eMsgKinds.RESIZED
				_resized.RaiseEvent(msg.sender, msg.e)
			Case eMsgKinds.SEND_TO_BACK
				_sendToBack.RaiseEvent(msg.sender, msg.e)
				
			
			Case eMsgKinds.SLIDING_MAXIMUM_CHANGED	'PENDING: Has to be set on all slider controls
			
			Case eMsgKinds.SLIDING_VALUE_CHANGED
			
			Case eMsgKinds.TEXT_CHANGED	'Set on baselabel control

			Case eMsgKinds.TIMER_TICK	'Set on timer
			
			
			Case eMsgKinds.VISIBLE_CHANGED
				_visibleChanged.RaiseEvent(msg.sender, msg.e)
				
			Case eMsgKinds.INTERNAL_SCROLLCHANGED	'It has to be set on a ContainerControl
						
		End
	End
	
	#Rem monkeydoc
		monkeydoc This event is raised whenever the button is Clicked 
	#END
	Method Event_Click:EventHandler<MouseEventArgs>() Property; Return _eventClick; End
	#rem monkeydoc
		 This event is raised whenever the control is set a the top of its container Z-Order
	 #END
	Method Event_BringToFront:EventHandler<EventArgs>() Property; Return _bringToFront; end
	#rem monkeydoc
		This event is raised whenever the control gets the focus
	#END
	Method Event_GotFocus:EventHandler<EventArgs>() Property; Return _gotFocus; End
	#rem monkeydoc
		 This event is raised whenever a key is pressed down and the control has the focus.
	 #END
	Method Event_KeyDown:EventHandler<KeyEventArgs>() Property; Return _keyDown; End
	#rem monkeydoc
		This event is raised whenever a key stroke is completed and the control has the focus.
	 #END
	Method Event_KeyPress:EventHandler<KeyEventArgs>() Property; Return _keyPress; End
	#rem monkeydoc
		This event is raised whenever a key is raised up and the control has the focus.
	 #END
	Method Event_KeyUp:EventHandler<KeyEventArgs>() Property; Return _keyUp; End
	#rem monkeydoc
		This event is raised whenever the controls loses focus.
	 #END
	Method Event_LostFocus:EventHandler<EventArgs>() Property; Return _lostFocus; end
	#rem monkeydoc
		This event is raised whenever the mouse down button is pressed down over the control.
	#END
	Method Event_MouseDown:EventHandler<MouseEventArgs>() Property; Return _mouseDown; end
	#rem monkeydoc
		This event is raised whenever the mouse is moved over the control.
	#END
	Method Event_MouseMove:EventHandler<MouseEventArgs>() Property; Return _mouseMove; end
	#rem monkeydoc
		This event is raised whenever the mouse button is unpressed over the control.
	#END
	Method Event_MouseUp:EventHandler<MouseEventArgs>() Property; Return _mouseUp; end
	#rem monkeydoc
		This event is raised whenever the mouse pointer enters the control area.
	#END
	Method Event_MouseEnter:EventHandler<EventArgs>() Property; Return _mouseEnter; end
	#rem monkeydoc
		This event is raised whenever the mouse pointer leaves the control area.
	#END
	Method Event_MouseLeave:EventHandler<EventArgs>() Property; Return _mouseLeave; end
	#rem monkeydoc
		This event is raised whenever the control is moved from its parent-relative location.
	#END
	Method Event_Moved:EventHandler<EventArgs>() Property; Return _moved; end
	#rem monkeydoc
		This event is raised whenever the control padding is modified.
	#END
	Method Event_PaddingModified:EventHandler<EventArgs>() Property; Return _paddingModified; end
	#rem monkeydoc
		This event is raised whenever the control parent is removed.
	#END
	Method Event_ParentRemoved:EventHandler<EventArgs>() Property; Return _parentRemoved; end
	#rem monkeydoc
		This event is raised whenever the control parent is resized.<br>On TopLevelControls this indicates that the whole device canvas has been resized.
	#END
	Method Event_ParentResized:EventHandler<EventArgs>() Property; Return _parentResized; end
	#rem monkeydoc
		This event is raised whenever the control parent is set.
	#END
	Method Event_ParentSet:EventHandler<EventArgs>() Property; Return _parentSet; End
	#rem monkeydoc
		This event is raised whenever the control is sent to the bottom of its parent the Z-Order.
	#END
	Method Event_SendToBack:EventHandler<EventArgs>() Property; Return _sendToBack; end
	#rem monkeydoc
		This event is raised whenever the control visible property is modified.
	#END
	Method Event_VisibleChanged:EventHandler<EventArgs>() Property; Return _visibleChanged; end
	#rem monkeydoc
		This event is raised whenever the control is resized.
	#END
	Method Event_Resized:EventHandler<EventArgs>() Property; Return _resized; end
	
	#REM monkeydoc
		 This method returns the current state of the control. The result is an integer that can have any of the flags defined in eControlStatus.
		 Current available values are:
*  eControlStatus.FOCUSED
*  eControlStatus.HOOVER
*  eControlStatus.DISABLED
*  eControlStatus.NONE
	 #END
	Method Status:Int() Property
		Local status:Int = eControlStatus.NONE
		if _gui.ActiveControl = Self Then status = status | eControlStatus.FOCUSED
		if _gui.GetMousePointedControl = Self Then status = status | eControlStatus.HOOVER
		Return status
	End
	
	Method Pointer:Void(mousePointer:Int) Property
		_pointer = mousePointer
	End
	
	Method Pointer:Int() Property
		Return _pointer
	End
	
	#Rem monkeydoc
		This get/set Property indicates that this control should show the virtual keyboard when it gets focus.
	 #END
	Method RequiresVirtualKeyboard:Bool() Property
		Return _requiresVirtualKeyboard
	End

	Method RequiresVirtualKeyboard:Void(value:Bool) Property
		_requiresVirtualKeyboard = value
	End
	
	'Method LowLevelMsgListeners:List<MsgListener>()
		
	'End
	
	Method RegisterMsgListener(listener:MsgListener)
		If listeners = Null Then listeners = New List<MsgListener>
		listeners.AddLast(listener)
		listener.Register(Self)
	End
	
	Method UnRegisterMsgListener(listener:MsgListener)
		If listeners = Null Then Return
		If listeners.IsEmpty Then Return
		listeners.RemoveEach(listener)
		If listeners.IsEmpty Then listeners = Null
		listener.UnRegister(Self)
	End
	Private

	Field listeners:List<MsgListener>
	Method NotifyMsgListeners(msg:BoxedMsg)
		If listeners = Null Then Return
		If listeners.IsEmpty Then Return
		For Local msgl:MsgListener = EachIn listeners
			msgl.Msg(msg)
		Next
	End
	
'INTERNAL EVENT HANDLERS:
	Field _eventClick:= New EventHandler<MouseEventArgs>
	Field _bringToFront:= New EventHandler<EventArgs>
	Field _gotFocus:= New EventHandler<EventArgs>
	Field _keyDown:= New EventHandler<KeyEventArgs>
	Field _keyPress:= New EventHandler<KeyEventArgs>
	Field _keyUp:= New EventHandler<KeyEventArgs>
	Field _lostFocus:= New EventHandler<EventArgs>
	Field _mouseDown:= New EventHandler<MouseEventArgs>
	Field _mouseMove:= New EventHandler<MouseEventArgs>
	Field _mouseUp:= New EventHandler<MouseEventArgs>
	Field _mouseEnter:= New EventHandler<EventArgs>
	Field _mouseLeave:= New EventHandler<EventArgs>
	Field _moved:= New EventHandler<EventArgs>
	Field _paddingModified:= New EventHandler<EventArgs>
	Field _parentRemoved:= New EventHandler<EventArgs>
	Field _parentResized:= New EventHandler<EventArgs>
	Field _parentSet:= New EventHandler<EventArgs>
	Field _sendToBack:= New EventHandler<EventArgs>
	Field _visibleChanged:= New EventHandler<EventArgs>
	Field _resized:= New EventHandler<EventArgs>
		
'OTHER PRIVATES:	
	Field _tipText:String
	Field _visible:Bool = True
	Field _requiresVirtualKeyboard:Bool = False
	Field _outOfView
	
	Field _lastRenderPos:= New GuiVector2D
	
	Method StorePos()
		_gui.currentRenderPos.CloneHere(_lastRenderPos)
	End
	
	Method AddRenderPos()
		_gui.currentRenderPos.X += Position.X
		_gui.currentRenderPos.Y += Position.Y
		StorePos()
	End
	
	Field _vp_focusChecks:ViewPort = New ViewPort
	Field _vp_focusChecks2:ViewPort = New ViewPort
	
	
	Method _FocusChecks()
		
		If Self.Visible = False Then Return
		if Self.HasGraphicalInterface = False Then return
		
		if _gui = null Then
			return
		EndIf
		'RefreshRenderPosition()
		
		Local viewPort:= _vp_focusChecks 'new ViewPort
		'Ponemos los valores del control
		viewPort.SetValuesFromControl(Self)
		
		'Los ajustamos al viewport padre:
		If _gui.viewPortStack.IsEmpty = False Then viewPort = viewPort.Calculate(_gui.viewPortStack.Top(), viewPort)
			
		'Añadimos el viewport a la cola:
		_gui.viewPortStack.Push(viewPort)
		If _gui._mousePos = Null Then _gui._mousePos = New GuiVector2D'(0, 0)
		If HasGraphicalInterface and _outOfView = False Then 	'And is visible
			if _gui._mousePos.X>= viewPort.position.X And _gui._mousePos.X<= (viewPort.position.X + viewPort.size.X) Then
				If _gui._mousePos.Y >= viewPort.position.Y And _gui._mousePos.Y <= (viewPort.position.Y + viewPort.size.Y) Then
					
					If _gui._mouseControl <> Self Then _gui._mouseControl = Self
					If Self.Pointer <> eMouse.Auto Then _gui._pointer = Self.Pointer
				End
			End
		endif
		
		If Self.IsContainer and _outOfView = False Then
			Local container:= ContainerControl(Self)
			viewPort = _vp_focusChecks2  'New ViewPort
			viewPort.SetValuesFromControl(container, container.Padding, container.ControlBordersSizes)
			viewPort = viewPort.Calculate(_gui.viewPortStack.Top(), viewPort)
			_gui.viewPortStack.Push(viewPort)
			For Local c:Control = EachIn container.controls
				If c._outOfView = False Then c._FocusChecks()
			Next
			_gui.viewPortStack.Pop()	'eliminamos el post-padding
		EndIf
	
		_gui.viewPortStack.Pop()	'eliminamos el borde del control
	
	End
	
	Method _InformGui(gui:Gui)
		_gui = gui
	End
		
	Method _NavigationGotFocus()
		AssignFocus()
		
	End
	
	Field _GuiVector2D:ControlGuiVector2D = New ControlGuiVector2D
	Field _parentControl:ContainerControl 
	Field _drawingSize:ControlGuiVector2D = New ControlGuiVector2D
	Field _backgroundColor:GuiColor = SystemColors.ControlFace 'new GuiColor(1,170,170,170)
	Field _foreColor:GuiColor = SystemColors.WindowTextForeColor
	Global _htmlforecolor:GuiColor = New GuiColor(1, 255, 255, 255)
	Field _gui:Gui 
	Field _tabStop:Bool = true
	Field _name:String = ""
	'Cache items:
	'Field _cacheRenderPosCalcuation:GuiVector2D
	Field _hooveColor:GuiColor = Null
	Field _borderColor:GuiColor = Null
	
	Field _pointer:Int = eMouse.Auto
	
End

#Rem monkeydoc 
	This is the ContainerControl class, that extends the Control class.
	All controls that can contain other controls extend this class.
#End
Class ContainerControl Extends Control

	'summary: This is a Get/Set property that is useful to set the control container internal Padding space.
	Method Padding:Padding() Property
		Return _padding
	End
	
	Method ControlBordersSizes:Padding() Property
		Return _borderPadding
	End
	
	'note: TODO: Calculate scrolling here when requested
	Method DeviceToControlX:Float(x:float)
		Return x - UnsafeRenderPosition.X - Padding.Left - ControlBordersSizes.Left + Self.internalScroll.X		
	End
	
	Method DeviceToControlY:Float(y:Float)
		Return y - UnsafeRenderPosition.Y - Padding.Top - ControlBordersSizes.Top + Self.internalScroll.Y
	End
	
	Method ControlToDeviceX:Float(x:Float)
		Return x + UnsafeRenderPosition.X + Padding.Left + ControlBordersSizes.Left - Self.internalScroll.X
	End
	
	Method ControlToDeviceY:Float(y:Float)
			Return y + UnsafeRenderPosition.Y + Padding.Top - ControlBordersSizes.Top - Self.internalScroll.Y
	End

	Method Dispatch(msg:BoxedMsg)
		If Not _gui Then Return
		Super.Dispatch(msg)
		Select msg.e.messageSignature
			Case eMsgKinds.INTERNAL_SCROLLCHANGED
				_internalScrollChanged.RaiseEvent(msg.sender, msg.e)
				'_internalScroll
		End Select
	End
	
	Method New()
		Self.internalScroll = New ControlGuiVector2D(Self, eMsgKinds.INTERNAL_SCROLLCHANGED)
	End
	Method Event_InternalScrollChanged:EventHandler<EventArgs>() Property
		Return _internalScrollChanged
	End
	Method Padding:Void(value:Padding)
		If value <> Null Then _padding = value Else _padding = New Padding
	End
	

	'summary: Clear all resources used by the control and its child controls
	Method Dispose()
		For Local c:Control = EachIn controls
			c.Dispose()
		Next
		'viewPortStack = null
		Super.Dispose()
	End
	
	'This is done like this to prevent the getter to be unaccesible by Monkey rare overriding rules.
	Method Parent:ContainerControl() Property
		Return Super.Parent '_parentContro
	End

	
	Method Parent:ContainerControl(parentControl:ContainerControl) Property
		If _parentControl = parentControl Then Return
		Super.Parent(parentControl)
		If _initialized = False Then InitializeNow()
		'This is done to ensure the _gui is also updated, just in case...
		For Local child:Control = EachIn Self.controls
			child.Parent = Self
		Next
	End

	Private
	Field _msg_ParentResized:= New BoxedMsg(Null, eMsgKinds.PARENT_RESIZED)
	Public
	Method Msg(msg:BoxedMsg)
		If msg.e.messageSignature = eMsgKinds.RESIZED And msg.sender = Self Then
			
			For Local control:Control = EachIn Self.controls
				_msg_ParentResized.sender = control
				_msg_ParentResized.status = eMsgStatus.Sent
				control.Msg(_msg_ParentResized)
			Next
		EndIf
		Super.Msg(msg)
		
	End
	
	Private
		Field _vp_render:ViewPort = New ViewPort
		Field _vp_render2:ViewPort = New ViewPort
	Public
	
	Method Render:Void()
	
		Local viewPort:ViewPort = _vp_render
		'Ponemos los valores del control
		viewPort.SetValuesFromControl(Self)
		
		'Los ajustamos al viewport padre:
		If _gui.viewPortStack.IsEmpty = False Then viewPort.Calculate(_gui.viewPortStack.Top, viewPort)
		
		If viewPort.size.X < 1 or viewPort.size.Y < 1
			_outOfView = True
			Return 'Nothing to draw!
		EndIf
		_outOfView = False
		SetGuiScissor(_gui, viewPort.position.X, viewPort.position.Y, viewPort.size.X, viewPort.size.Y)
			
		
		'Añadimos el viewport a la cola:
		_gui.viewPortStack.Push(viewPort)
		RenderBackground()
		
		'We set the children viewport:
		viewPort = _vp_render2 'New ViewPort
		viewPort.SetValuesFromControl(Self, Padding, ControlBordersSizes)
		viewPort = viewPort.Calculate(_gui.viewPortStack.Top, viewPort) 'Stack.Last())
		_gui.viewPortStack.Push(viewPort)
		SetGuiScissor(_gui, viewPort.position.X, viewPort.position.Y, viewPort.size.X, viewPort.size.Y)
		RenderChildren()
		
		'we remove the children viewport
		_gui.viewPortStack.Pop()	'eliminamos el post-padding
		
		'We get the regular control viewport again and set it to render the foreground component:
		viewPort = _gui.viewPortStack.Top
		SetGuiScissor(_gui, viewPort.position.X, viewPort.position.Y, viewPort.size.X, viewPort.size.Y)
		RenderForeground()
		
		'We now remove the control viewport from the stack
		_gui.viewPortStack.Pop()	'eliminamos el borde del control
			
	End

	#Rem monkeydoc
		This method is called by the Gui system when a control container has to render its background, that is, the part of the component that is drawn behind the contained controls.
	 #END
	Method RenderBackground()
		Super.Render()
	End

	#Rem monkeydoc
		This method is called by the Gui system when a control container has to render its foregound. That is, the part of the component that is drawn over the container control background, and over its children.
	 #END
	Method RenderForeground()
		
	End

	Private
		Field _vp_renderChildren:= New ViewPort
	Public
	#Rem monkeydoc
		This method will render all the controls contained into this [[ControlContainer]], in the required order.
	 #END
	Method RenderChildren()
		Local viewPort:ViewPort = _vp_renderChildren 'New ViewPort
		
		Local prePaddingX:Int = _gui.currentRenderPos.X
		Local prePaddingY:Int = _gui.currentRenderPos.Y
		AddPaddingPos
		
		For Local c:Control = EachIn controls
			If c.Visible = False Then Continue

			Local preRenderX:Int = _gui.currentRenderPos.X
			Local preRenderY:Int = _gui.currentRenderPos.Y
			c.AddRenderPos()


			viewPort.SetValuesFromControl(c)
			If _gui.viewPortStack.IsEmpty = False Then
				viewPort = viewPort.Calculate(_gui.viewPortStack.Top, viewPort) 'Stack.Last())
			EndIf
			If viewPort.size.X > 0 And viewPort.size.Y > 0 Then
				SetGuiScissor(_gui, viewPort.position.X, viewPort.position.Y, viewPort.size.X, viewPort.size.Y)
				c._outOfView = False
				c.Render()
				SetColor(255, 255, 255)
				If GetAlpha <> 1 Then SetAlpha(1)
			Else
				c._outOfView = True
				'Print "optimized!"
			EndIf

			'c.RemoveRenderPos()
			_gui.currentRenderPos.X = preRenderX
			_gui.currentRenderPos.Y = preRenderY


		Next
		If _gui.viewPortStack.IsEmpty = False Then
			Local viewPort:ViewPort = _gui.viewPortStack.Top 'Stack.Last()
			SetGuiScissor(_gui, viewPort.position.X, viewPort.position.Y, viewPort.size.X, viewPort.size.Y)
		EndIf
		'RemovePaddingPos
		_gui.currentRenderPos.X = prePaddingX
		_gui.currentRenderPos.Y = prePaddingY
	End
	
	Private
	Method AddPaddingPos()
		_gui.currentRenderPos.X += Padding.Left + ControlBordersSizes.Left - InternalScroll.X
		_gui.currentRenderPos.Y += Padding.Top + ControlBordersSizes.Top - InternalScroll.Y
		
	End
	
	Public

	Method InternalScroll:GuiVector2D() Property
		Return internalScroll
	End
	Method Update()
		If _initialized = False Then
			_initialized = True
			OnInit()
		EndIf
		For Local c:Control = EachIn Self.controls
			If c.HasGraphicalInterface = False Then
				c.Update()
			Else
				If c.Visible = True and c._outOfView = False Then
					c.Update()
				Else
					'We don't update invisible controls
					'Print "Optimized update"
				EndIf
			EndIf
		Next
		Super.Update()
	End

	#Rem monkeydoc
		This method will be called when the container control has to be initialized.
		When you're creating your own control container, and you need to initialize its children on your application, you can safely do this by overriding this method and writing there your component initialization routines.
	 #END
	Method OnInit()
		
	End
	
	#Rem monkeydoc
		This method will force the OnInit call. You shouldn't usually call this method as controls are properly initialized by the Gui engine when required.
	#End
	Method InitializeNow()
		If _initialized Then
			Return
		Else
			_initialized = True
			OnInit()
		EndIf
	End
	
	#rem monkeydoc
		This method will generate a LinkedList that contains all contained controls, ordered by the ControlContainer Z-Order.
		When the *safe* parameter is set to False, this method will return the real internal list used by the control to handle its contained controls.
		Take into account that modifying wrong this list could result on stability of the whole Gui system.
		For general usage, the safe parameter should be used as "true". Doing it this way, this method will return a copy of the internal list used by the control, so its manipulation will not cause any stability issues.
	#END
	Method GenerateControlsList:List<Control>(safe:Bool = True)
		Local list:= New List<Control>
		If safe = False Then
			Return controls
		Else
			For Local control:= EachIn controls
				list.AddLast(control)
			Next
			Return list
		EndIf
	End
		
	Private

	Method _InformGui(gui:Gui)
		_gui = gui
		For Local c:Control = EachIn controls
			c._InformGui(gui)
		Next
		
	End
	
	Method _NavigationGotFocus()
		if Self.controls = null Then 
			return Super._NavigationGotFocus()
		endif
		if Self.controls.IsEmpty Then 
			return Super._NavigationGotFocus()
		EndIf
		'Determine proper first:
		Self.controls.First()._NavigationGotFocus()
	End

	Field controls:List<Control> = new List<Control>
	Field _padding:= New Padding
	Field _initialized:Bool = False
	Field internalScroll:ControlGuiVector2D
	Field _internalScrollChanged:= New EventHandler<EventArgs>
	Field _borderPadding:= New Padding
End

#REM monkeydoc
	This is the TopLevelControl class, that extends the ControlConainer class. This class represents the base of any Form control.
#end
Class TopLevelControl Extends ContainerControl
 
	#rem monkeydoc
		This method inits the Top Level Control internals. This method has to be called BEFORE the [[TopLevelControl]] is used to actually do anything, including attaching controls to it, etc.
		Be sure to call it whenever a TopLevelControl has to be used. 
		This initialization will also cause a call to the OnInit method of the given [[TopLevelControl]]
	 #END
	Method InitForm(gui:Gui)
		SetGui(gui)
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.INIT_FORM)))
	End
	
	#rem monkeydoc
		This method will be called whenever a TopLevelControl has been properly init and we can start attaching controls to it and sending ang getting events.
	 #END
	Method OnInit()
		
	End
	
	Method Msg(msg:BoxedMsg)
		Select msg.e.messageSignature
			Case eMsgKinds.INIT_FORM
				OnInit()
			Case eMsgKinds.GOT_FOCUS, eMsgKinds.MOUSE_DOWN, eMsgKinds.KEY_PRESS
				if _gui._components.Last() <> Self then BringToFront()
			End
		If _gui <> Null Then _gui.Msg(msg)
		Super.Msg(msg)
	End
	
	
	Method IsTopLevelControl:Bool()
		Return True
	end

	Method Dispose()
		_gui._components.RemoveEach(Self)
		Super.Dispose()
	End
	
'	#Rem monkeydoc
'		This method can be used to modify the Gui where a top level control is being executed. Modifying this during runtime is not recommended.
'	 #END
	Method SetGui(gui:Gui)
		If gui = Null Then
			Throw New JungleGuiException("A form can't be set to a null Gui manager", Self)
		Else
			If _gui <> Null Then _gui._components.RemoveEach(Self)
			_gui = gui
			_gui._components.AddFirst(Self)
			_InformGui(gui)
		EndIf
	End
	
	Method BringToFront()
		'Print "Called!"
		If _gui._components.Last() = Self Then Return
		_gui._components.RemoveEach(Self)
		_gui._components.AddLast(Self)
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.BRING_TO_FRONT)))
	End

	Method SendToBack()
		If _gui._components.First() = Self Then Return
		_gui._components.RemoveEach(Self)
		_gui._components.AddFirst(Self)
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.SEND_TO_BACK)))
	End
	
	Method Dispatch(msg:BoxedMsg)
		Super.Dispatch(msg)
		Select msg.e.messageSignature
			Case eMsgKinds.INIT_FORM
				Self._initialized = True
				_initForm.RaiseEvent(msg.sender, msg.e)
		End
	End

	
	Method Event_InitForm:EventHandler<EventArgs>() Property; Return _initForm; End
	
	
Private
	Field _initForm:= New EventHandler<EventArgs>
End

#REM monkeydoc
	This is the core Gui component
#END
Class Gui

	#rem monkeydoc
		This global contains a reference to the default system font.
	 #END
	Global systemFont:BitmapFont

	#rem monkeydoc
		This global contains a reference to the default Tool Tip font.
	#END
	Global tipFont:BitmapFont

	Method New()
		Renderer = Null	'Force default renderer
		If JungleGuiApplication.gui = Null Then JungleGuiApplication.gui = Self
	End

	
	#Rem monkeydoc
		This method has to be called whenever all the Gui elements have to be rendered.
	 #END
	Method Render()
		If _renderer = Null Then Renderer = Null	'Set default renderer in case it has not been set.
		GetMatrix(Self._renderer_matrix_cache)
		graphics.SetMatrix(1, 0, 0, 1, 0, 0)
		currentRenderPos.SetValues(0, 0)
		If scalex <> 1 or scaley <> 1 Then Scale(scalex, scaley)
		Local scissor:Float[] = GetScissor()
		For Local c:Control = EachIn _components
			If c.Visible = False Then Continue
			Local preRenderPosX:Int = Self.currentRenderPos.X
			Local preRenderPosY:Int = Self.currentRenderPos.Y
			
			c.AddRenderPos()
			c.Render()
			SetGuiScissor(Self, scissor[0], scissor[1], scissor[2], scissor[3])
			'c.RemoveRenderPos()
			'Print currentRenderPos.X + ", " + currentRenderPos.Y
			currentRenderPos.SetValues(preRenderPosX, preRenderPosY)
		Next
		SetScissor(scissor[0], scissor[1], scissor[2], scissor[3])
		
		if _waitingTipCount>10 Then
			_waitingTipCount = 10 + 1
			RenderTip()
		EndIf
		SetMatrix(Self._renderer_matrix_cache)
		MousePointer.PerformSystemInteraction
	End
	
	#Rem monkeydoc
		This get/set property can be used to scale the X coordinates of the whole Gui rendering and calculation.
	#END
	Method ScaleX:Float() Property
		Return scalex
	End

	#Rem monkeydoc
		This get/set property can be used to scale the X coordinates of the whole Gui rendering and calculation.
	#END
	Method ScaleX:Void(value:Float) Property
		scalex = value
	End
	
	#Rem monkeydoc
		This get/set property can be used to scale the Y coordinates of the whole Gui rendering and calculation.
	#END
	Method ScaleY:Float() Property
		Return scaley
	End
	
	#Rem monkeydoc
		This get/set property can be used to scale the Y coordinates of the whole Gui rendering and calculation.
	#END
	Method ScaleY:Void(value:Float) Property
		scaley = value
	End
	
	#Rem monkeydoc
		This method will convert phisical device X coordinate to a logical scaled X coordinate in the Gui system.
	#END	
	Method DeviceToGuiX:Float(x:Float)
		Return x / scalex
	End

	#Rem monkeydoc
		This method will convert phisical device Y coordinate to a logical scaled Y coordinate in the Gui system.
	#END	
	Method DeviceToGuiY:Float(y:Float)
		Return y / scaley
	End

	#Rem monkeydoc
		This method will convert a logical scaled X coordinate to a phisical device X.
	#END	
	Method GuiToDeviceX:Float(x:Float)
		Return x * scalex
	End
	
	#Rem monkeydoc
		This method will convert a logical scaled Y coordinate to a phisical device X.
	#END	
	Method GuiToDeviceY:Float(y:Float)
		Return y * scaley
	End


	#Rem monkeydoc
		This property will return the current Gui skin.
	#END	
	Method Renderer:GuiRenderer() Property
		Return _renderer
	End

	#Rem monkeydoc
		This property allows you to set a new skin to the whole Gui system.
	#END	
	Method Renderer:Void(renderer:GuiRenderer) Property
		If _renderer <> Null Then
			_renderer.FreeResources()
			_renderer.Event_GuiDetached.RaiseEvent(Self, New EventArgs(eMsgKinds.RENDERER_DETACHED))
		EndIf
		If renderer = Null Then
			_renderer = New GuiRenderer
		Else
			_renderer = renderer
		EndIf
		ResetRendererValues(_renderer)
		_renderer.InitRenderer()
		_renderer.Event_GuiAttached.RaiseEvent(Self, New EventArgs(eMsgKinds.RENDERER_ATTACHED))
	End

	#Rem monkeydoc
		This method will clear and [[Dispose]] all controls contained in the Gui system
	#END
	Method Clear()
		For Local form:TopLevelControl = EachIn _components
			form.Dispose()
		Next
		_mouseControl = null
		_mousePointerControl = null
	End

	Private
	Field _msg_parentResized:= New BoxedMsg(Null, New EventArgs(eMsgKinds.PARENT_RESIZED))
	Public

	#rem monkeydoc
		This method has to be called whenever the Gui system has to be updated.
		This is typically called once on the OnUpdate method of your [[mojo]] [[App]].
	#END
	Method Update()

		if _mousePos = Null then _mousePos = New GuiVector2D

		_oldMousePos.SetValues(_mousePos.X, _mousePos.Y)

		If TouchDown(1) Then
			_mousePos.SetValues(DeviceToGuiX(TouchX(1)), DeviceToGuiY(TouchY(1)))
		Else
			_mousePos.SetValues(DeviceToGuiX(MouseX()), DeviceToGuiY(MouseY()))
		EndIf
		
		'_mousePos = GetWorldPos(MouseX(), MouseY())
		
		If _mousePos.X < 0 Then _mousePos.X = 0 ElseIf _mousePos.X > DeviceWidth / scalex Then _mousePos.X = DeviceWidth / scalex
		
		If _mousePos.Y < 0 Then _mousePos.Y = 0 ElseIf _mousePos.Y > DeviceHeight / scaley Then _mousePos.Y = DeviceHeight / scaley

		Local devWidth:= DeviceWidth() / scalex
		Local devHeight:= DeviceHeight() / scaley
		Local sendParentResize:Bool = false
		if devWidth <> Self._guiSize.X or devHeight <> Self._guiSize.Y Then
			_guiSize.SetValues(devWidth, devHeight)
			sendParentResize = true;
		EndIf
		
		Local oldMouseDown = _mouseDown
		_mouseDown = MouseDown()
		_pointer = eMouse.Arrow
		For Local c:Control = EachIn _components
			_msg_parentResized.sender = c
			_msg_parentResized.status = eMsgStatus.Sent
			If sendParentResize Then c.Msg(_msg_parentResized)
			Local e:EventArgs
			
			If c.Visible Then
				If c._gui = Null or c._outOfView Then Continue
				c._FocusChecks()	'update control under mouse.
				c.Update()
			End
		Next
				
		Local oldControl:= _mousePointerControl
		Local newControl:= _mouseControl
		Local mouseMoved:Bool = False
		_mousePointerControl = _mouseControl 
		_mouseControl = null
		if oldControl  <> newControl  Then
			if oldControl <> null and oldControl._gui <> null Then oldControl.Msg(New BoxedMsg(oldControl, New EventArgs(eMsgKinds.MOUSE_LEAVE)))
			if newControl <> null and newControl._gui <> null Then newControl.Msg(New BoxedMsg(newControl, New EventArgs(eMsgKinds.MOUSE_ENTER)))
			mouseMoved = true
		end
		
		if _mousePointerControl <> null And (_oldMousePos.X <> _mousePos.X or _oldMousePos.Y <> _mousePos.Y) and _mousePointerControl._gui <> null Then
			Local cords:= _mousePointerControl.UnsafeRenderPosition.Clone() 'RefreshRenderPosition.Clone()
			cords.X = _mousePointerControl.DeviceToControlX(_mousePos.X) ' - cords.X
			cords.Y = _mousePointerControl.DeviceToControlY(_mousePos.Y) ' - cords.Y
			Local eArgs:= New MouseEventArgs(eMsgKinds.MOUSE_MOVE, cords, 0)
			_mousePointerControl.Msg(New BoxedMsg(_mousePointerControl, eArgs))
		EndIf
		
		if oldMouseDown = False And _mouseDown = True Then
			'this is a MouseDownEvent
			if newControl <> null Then
				Local controlPos:= newControl.UnsafeRenderPosition.Clone() 'RefreshRenderPosition.Clone() 'UnsafeRenderPosition().Clone()
				controlPos.SetValues(newControl.DeviceToControlX(_mousePos.X), newControl.DeviceToControlY(_mousePos.Y))
				If newControl._gui <> Null Then newControl.Msg(New BoxedMsg(newControl, New MouseEventArgs(eMsgKinds.MOUSE_DOWN, controlPos, 1)))
				_DownControl = newControl
			EndIf
		ElseIf oldMouseDown = True And _mouseDown = False Then
			'Mouse up and possible click:
			if _DownControl <> null and _DownControl._gui <> null Then
				Local controlPos:= _DownControl.UnsafeRenderPosition.Clone() 'RefreshRenderPosition.Clone()
				controlPos.SetValues(_DownControl.DeviceToControlX(_mousePos.X), _DownControl.DeviceToControlY(_mousePos.Y))
				If _DownControl._gui <> Null Then _DownControl.Msg(New BoxedMsg(_DownControl, New MouseEventArgs(eMsgKinds.MOUSE_UP, controlPos, 1)))
			EndIf
			if _DownControl = newControl And _DownControl <> null Then
				Local pos:= New GuiVector2D
				pos.SetValues(newControl.DeviceToControlX(_mousePos.X), newControl.DeviceToControlY(_mousePos.Y))
				
				if newControl._gui <> null then newControl.AssignFocus()
				If newControl._gui <> Null Then
					newControl.Msg(New BoxedMsg(newControl, New MouseEventArgs(eMsgKinds.CLICK, pos, 1)))
				EndIf
			EndIf
			_waitingReclickDelay = Gui.FirstReclick
		ElseIf oldMouseDown = True And _mouseDown = True and _DownControl <> Null Then
			Self._waitingReclickDelay += 1
			If _waitingReclickDelay >= Gui.PerformReclick
				_waitingReclickDelay = 0
				_DownControl.Msg(New BoxedMsg(_DownControl, New EventArgs(eMsgKinds.DELAY_CLICK)))
			EndIf
			_waitingReclickDelay += 1
		EndIf
		
		Local keys:Int[] = New Int[256]
		Local doCheck:Bool = keys.Length = _oldKeys.Length And self._focusedControl <> null
		For Local i:Int = 0 to 255 'to name something
			keys[i] = KeyDown(i)
			if doCheck Then
				if keys[i] = True And _oldKeys[i] = false Then
					'KeyDown!
					if _focusedControl._gui <> null then _focusedControl.Msg(New BoxedMsg(_focusedControl, New KeyEventArgs(eMsgKinds.KEY_DOWN, i)))
				ElseIf keys[i] = False And _oldKeys[i] = True Then
					if _focusedControl._gui <> null then _focusedControl.Msg(New BoxedMsg(_focusedControl, New KeyEventArgs(eMsgKinds.KEY_UP, i)))
					'_focusedControl.Msg(_focusedControl,New KeyEventArgs(eMsgKinds.KEY_PRESS,i))
					'KeyUp and KeyPress
				EndIf
			end if
		Next
		local char:Int = GetChar()
		if char <> 0 and _focusedControl <> null and _focusedControl._gui <> null Then
			_focusedControl.Msg(New BoxedMsg(_focusedControl, New KeyEventArgs(eMsgKinds.KEY_PRESS, char)))
		EndIf
		if char = 9 and _focusedControl<>null Then 	'MODIFY_TAB!!!
			'Do focus chanche here!
			if _focusedControl._gui <> null then _focusedControl.FocusNext()
		end
		_oldKeys = keys
		if mouseMoved Then
			_waitingTipCount=0
			_renderTipAlpha = 0
		Else
			
			_waitingTipCount+=1
		EndIf
		
		MousePointer.Pointer = _pointer
	End
	
	#rem monkeydoc
		This is *internaly used* by the Gui engine to deal with internal status changes and event dispatching. 
		This method should not be directly used unless you're doing some serious internal debug operations. Use with caution.
	#End
	Method Msg(msg:BoxedMsg)
		If _event_Msg.HasDelegates Then _event_Msg.RaiseEvent(msg.sender, msg.e)
	End
	#rem monkeydoc
		This event is fired whenever a low level msg is being processed by the Gui messaging system.
		This method exists to make it easier to debug internal status changes of the whole Gui system. You don't need to use this method usually.
	 #END
	Method Event_Msg:EventHandler<EventArgs>()
		Return _event_Msg
	End
	
'	Method GetWorldPos:GuiVector2D(DeviceX:Int, DeviceY:Int)
'		Local mat:Float[] = _renderMatrix 'GetMatrix()
'		If mat.Length = 0 Then
'			Local dp:= New GuiVector2D
'			dp.SetValues(DeviceX, DeviceY)
'			Return dp
'		Else
'			Local wx:Float = DeviceX * mat[0] + DeviceY * mat[2] + mat[4]
'			Local wy:Float = DeviceX * mat[1] + DeviceY * mat[3] + mat[5]
'			Local dp:= New GuiVector2D
'			dp.SetValues(wx, wy)
'			Return dp
'		EndIf
'	End
	
	#Rem monkeydoc
		This method returns TRUE if a given key is pressed.
	 #END
	Method IsKeydown?(keyCode:Int)
		if keyCode<_oldKeys.Length Then
			Return _oldKeys[keyCode] > 0
		Else 
			Return false
		EndIf
	End
	#rem monkeydoc
		This method the control that is being pointed by the mouse.
	 #END
	Method GetMousePointedControl:Control()
		Return _mousePointerControl
	End
	#rem monkeydoc
		This method returns the current Mouse position
	 #END
	Method MousePos:GuiVector2D()
		Return _mousePos
	End
	#rem monkeydoc
	 This method returns the current active control. That is, the control that has the focus.
	#End
	Method ActiveControl:Control()
		Return _focusedControl 
	End
	
	#Rem monkeydoc
		*(advanced)* This method gives access to the TopLevelControl components list currently being handled by the gui element.
		About the secure parameter:
		* True: This method will return a copy if the interal list used by the gui control.
		* False: This parameter will give *direct access* to the internal list being used by the gui system.
		In general therms, while creating a copy of the list is usually fast, it is a bit more CPU heavy than using the internal list. However, modifying the internal list directly can leave the GUI system on an inconsistent status if it is not properly done.
		So, all in all, it is not recommended to use an unsafe "GetComponentsList" *unless you know exactly what you're doing*.
	#END
	Method GetComponentsList:List<TopLevelControl>(secure:Bool = True)
		If secure = False Then Return Self._components
		Local copylist:= New List<TopLevelControl>
		For Local c:TopLevelControl = EachIn _components
			If c <> Null Then copylist.AddLast(c)
		Next
		Return copylist
	End

	#Rem monkeydoc
		This method returns the currently active [[TopLevelControl]]
	#END
	Method ActiveTopLevelControl:TopLevelControl()
		If _components.IsEmpty = False Then Return _components.Last() Else Return Null
	End
	
	Private



	Field currentRenderPos:= New GuiVector2D
	
	Field _renderer:GuiRenderer '= New GuiRenderer
	Field _renderTipAlpha:Float = 0
	Field scalex:Float = 1
	Field scaley:Float = 1
	
	Field _renderer_matrix_cache:Float[6]

	Method RenderTip()
		Local control:= GetMousePointedControl()
		if control  = null or control.TipText = "" Then 
			_renderTipAlpha = 0
			Return
		endif
		Local Width:Int = Gui.tipFont.GetTxtWidth(control.TipText)+12
		Local Height:Int = Gui.tipFont.GetTxtHeight(control.TipText) + 12
		Local DrawX:Int = _mousePos.X
		Local DrawY:Int = _mousePos.Y+10
		If DrawX + Width > _guiSize.X Then DrawX -= DrawX + Width - _guiSize.X
		 If DrawY + Height > _guiSize.Y Then DrawY -= DrawY + Height - _guiSize.Y + (_guiSize.Y - _mousePos.Y)
		
		'Shadow;
		'SetAlpha(_renderTipAlpha*0.2)
		'SetColor(0,0,0)
		'DrawRect(DrawX+2,DrawY+2,Width,Height)
		
		'Background:
		SetAlpha(_renderTipAlpha)
		SetColor(230,230,230)
		Local MidPoint:Int = (Height / 2.0 + 0.5) - 1
		DrawRect(DrawX+1,DrawY+1+MidPoint,Width-2,MidPoint)
		SetColor(242,242,242)
		DrawRect(DrawX+1,DrawY+1,Width-2,MidPoint)
		
		'Border:
		SetColor(100,100,100)
		DrawRoundBox(DrawX,DrawY,Width,Height)
		
		'Text:
#IF TARGET="html5" then
		SetColor(255,255,255)
		Gui.tipFont.DrawText(control.TipText,DrawX+5, DrawY+5)
#ELSE
		SetColor(40,40,40)
		Gui.tipFont.DrawText(control.TipText,DrawX+5, DrawY+5)
#END
		_renderTipAlpha+=.08
		if _renderTipAlpha>1 Then _renderTipAlpha = 1
		SetAlpha(1)
	End
	Field _components:List<TopLevelControl> = new List<TopLevelControl>	
	Field _mousePos:= New GuiVector2D
	Field _oldMousePos:= New GuiVector2D
	Field _mouseControl:Control
	Field _mousePointerControl:Control
	Field _focusedControl:Control
	Field _mouseDown:Int
	Field _DownControl:Control
	Field viewPortStack:ViewPortStack = New ViewPortStack 
	Field _oldKeys:Int[]
	Field _guiSize:GuiVector2D = New GuiVector2D
	Field _waitingTipCount:Int = 0
	Field _event_Msg:= New EventHandler<EventArgs>
	Field _waitingReclickDelay:Int = FirstReclick
	Const FirstReclick:= -55
	Const PerformReclick:= 5
	Field _pointer:Int = eMouse.Arrow
	'Field _renderMatrix:Float[]
End