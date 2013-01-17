Import drawingpoint
Import eventargs
Import guicolor
Import viewportstack
Import helperfunctions
Import eventhandler
Import padding
Import econtrolstatus

Private
Import mojo
public
'summary: this is the base class of a JungleGui control

Class Control

	Public
	'summary: This property is meant to contain the runtime name of the control. This information can be useful when debugging the application and can also be retrieved by the usage of reflection.
	Method Name:String() Property
		Return _name
	End
	
	Method Name:Void(value:String) Property
		_name = value
	End
	
	Method New()
		_GuiVector2D.SetNotifyControl(Self, eMsgKinds.MOVED)
		_drawingSize.SetNotifyControl(Self, eMsgKinds.RESIZED)
	End
	
	'summary: this is the location of the control in the parent container control
	Method Position:ControlGuiVector2D() Property
		Return _GuiVector2D
	end
	
	Method Position:Void(value:ControlGuiVector2D) Property
		if value<>null Then 
			_GuiVector2D = value 
			_GuiVector2D.SetNotifyControl(Self, eMsgKinds.MOVED)	'We want to get events
		Else
			
			Throw New JungleGuiException("Null position set to a control." , Self)
		EndIf
	End
	
	'summary: this is the location of the control in the parent container control
	Method Size:ControlGuiVector2D() Property
		Return _drawingSize
	end
	
	Method Size:void(value:ControlGuiVector2D) Property
		if value<>null Then 
			_drawingSize = value 
			_drawingSize.SetNotifyControl(Self, eMsgKinds.RESIZED)	'We want to get events
		Else
			Throw New JungleGuiException("Null size set to a control." , Self)
		EndIf
	End

	'summary: this is the background color of the control
	Method BackgroundColor:GuiColor() Property 
		Return _backgroundColor
	end
	
	Method BackgroundColor:GuiColor(value:GuiColor) Property
		if value<>null Then 
			_backgroundColor = value 
		Else
			Throw New JungleGuiException("Background color can't be set to null",Self)
		EndIf
		Return _backgroundColor 
	End

	'summary: this is the Fore color of the control
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

	'summary: This is automatically called when the control needs to be drawn on the screen.
	Method Render:Void()
		Local color:Float[] = GetColor()
		SetColor(Self.BackgroundColor.r, Self.BackgroundColor.g,Self.BackgroundColor.b)
		Local renderPos:GuiVector2D = self.CalculateRenderPosition()
		DrawRect(renderPos.X,renderPos.Y,Size.X,Size.Y)
		SetColor(color[0],color[1],color[2])
	End
	
	'summary: <font color=red><b>Advanced usage only</b></font><br>This method is internally used to build and control the internal status changes messaging system of the Gui system.
	Method Msg(msg:BoxedMsg)
		if Not _gui Then return
		if Self._parentControl <> null Then
			_parentControl.Msg(msg)
		EndIf
		if msg.sender = Self And msg.status = eMsgStatus.Sent Then
			Dispatch(msg)
		EndIf
	End
	'summary: This returns the Gui engine where this control is running.
	Method GetGui:Gui()
		Return _gui
	End
	
	'summary: this returns TRUE if this control is a Top level control (a window)
	Method IsTopLevelControl?()
		Return false
	End
	
	'summary: This returns TRUE if this control is a control container that can contain child controls.
	Method IsContainer?()
		Return false
	End

	'summary: This property returns the parent control where this control is located.
	'On top level controls (windows) this method returns NULL and can't be set to anything other than NULL
	Method Parent:ContainerControl() Property
		Return _parentControl
	End


	'summary: You can use this property to set the container for this control.
	Method Parent:ContainerControl(parentControl:ContainerControl) Property
		If parentControl = Null And _parentControl = Null Then Return
		If _parentControl = parentControl Then
			If _gui <> parentControl._gui Then _gui = parentControl._gui
			Return
		EndIf
		If _parentControl <> Null Then
			_parentControl.controls.Remove(Self)
			'Msg(Self,New EventArgs(eMsgKinds.PARENT_REMOVED))
			Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.PARENT_REMOVED)))
		EndIf
		If parentControl <> Null Then
 			_parentControl = parentControl
 			parentControl.controls.AddLast(Self)
			'Msg(Self,New EventArgs(eMsgKinds.PARENT_SET))
 			Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.PARENT_SET)))
 			_gui = parentControl._gui
		Else
 			_gui = Null
		EndIf
	End
	
	
	'summary: Bring a control to the front of the Z-Order
	Method BringToFront()
		if _parentControl = null Then Return
		_parentControl.controls.Remove(Self)
		_parentControl.controls.AddLast(Self)
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.BRING_TO_FRONT)))
	End
	
	'summary: send a control to the back of the Z-Order
	Method SendToBack()
		if _parentControl = null Then Return
		_parentControl.controls.Remove(Self)
		_parentControl.controls.AddFirst(Self)
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.SEND_TO_BACK)))
	End
	
	'summary: Clear all resources used by the control and its child controls. This is automatically called by the Gui system when the control needs to "die".
	Method Dispose()
		Parent = null
		_parentControl = null
		_GuiVector2D.SetNotifyControl(null, 0)
		_drawingSize.SetNotifyControl(null, 0)
		_gui = Null
	End
	
	'summary: This returns the rendering position of this control. The result is presented on Device coordinates. (screen pixels)
	Method CalculateRenderPosition:GuiVector2D()
		if _cacheRenderPosCalcuation = null then _cacheRenderPosCalcuation = new GuiVector2D
		_cacheRenderPosCalcuation.SetValues (Position.X, Position.Y)
		Local parent:ContainerControl = _parentControl
		While parent<>null
			_cacheRenderPosCalcuation.X += parent.Position.X + parent.Padding.Left
			_cacheRenderPosCalcuation.Y += parent.Position.Y + parent.Padding.Top
			parent = parent._parentControl
		Wend
		Return _cacheRenderPosCalcuation
	End
	
	'summary: This is automatically called by the Gui engine when the control needs to be updated and process its internal logic.
	Method Update()
		
	End

	'summary:this is Get/Set property that indicates if a control is navigable using the TAB key (keyboard navigation)
	Method TabStop:Bool() Property
		Return _tabStop
	End
	
	Method TabStop:Bool(value:Bool) Property
		_tabStop = value
		Return _tabStop
	end
	
	'summary:This method will give this control the focus.
	Method GetFocus()
		if Not _gui Then return
		if _gui._focusedControl = Self Return
		if _gui._focusedControl <> null Then
			_gui._focusedControl.Msg(New BoxedMsg(_gui._focusedControl, New EventArgs(eMsgKinds.LOST_FOCUS)))
		EndIf
		_gui._focusedControl = self
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.GOT_FOCUS)))
	End
	
	'summary:This method will give the focus to the next control that can take it. It has the same effect that pressing the TAB key on keyboard navigation.
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
				Parent.GetFocus()	'Era el último mohicano, volvemos al parent y escojemos el siguiente tío.
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

	'summary: This will return True for all controls that are based on a graphical interface such as buttons, labels, etc.<br>Non graphical controls, such as Timer, return False.
	Method HasGraphicalInterface:Bool() property
		Return True
	end

	'summary: Returs True if the control is currently the Gui focused control.
	Method HasFocus:Bool()
		Return _gui._focusedControl = self
	End
	
	'summary: This property can be set to True or False in order to show or hide this control.
	Method Visible:Bool() Property
		Return _visible
	End
	
	'summary: This property can be set to True or False in order to show or hide this control.
	Method Visible:Void(value:Bool) Property
		if value<> _visible then
			_visible = value
			Msg(New BoxedMsg(Self, eMsgKinds.VISIBLE_CHANGED))
		endif
	End

	'summary: This property alows you to set the text to be displayed as a control hint pop-up when the mouse is over the control.
	Method TipText:Void(value:String) Property
		_tipText = value
	End
	
	'summary: This property returns the text that will be displayed as a control hint pop-up when the mouse is over the control.
	Method TipText:String() Property
		Return _tipText
	End
		
	'summary: This is the color used to draw the control background when the mouse is over the control. 
	Method HooverColor:GuiColor() Property
		if _hooveColor <> null Then Return _hooveColor Else Return SystemColors.HooverBackgroundColor
	End
	
	Method HooverColor:GuiColor(value:GuiColor) Property
		_hooveColor = value
	End

	'summary: This is the color used to draw the control border.
	Method BorderColor:GuiColor() Property
		if _borderColor = Null then return SystemColors.ButtonBorderColor else Return _borderColor
	End

	'summary: This is the color used to draw the control border.
	Method BorderColor:GuiColor(value:GuiColor) Property
		if value <> null then
			_borderColor = value
		Else
			Throw New JungleGuiException("Border color can't be null.", Self)
		endif
	End


	
	#Rem
		summary: Low level method that deals with event signatures. This method is part of the internal core functionality of the control.
		The Dispach method is internally used to convert low level messages to high level events. This method is automatically called by the internal Jungle Gui core engine whenever a message has been validated in all the message-parent-control chain and it hasn't been handled by any parent control.
		For more information, read the Jungle Gui wiki at googlecode here: <a http://code.google.com/p/junglegui/wiki/WelcomePage?tm=6>Jungle Gui wiki</a>.
	 #END
	Method Dispatch(msg:BoxedMsg)
		if Not _gui Then return
		Select msg.e.eventSignature
			Case eMsgKinds.BRING_TO_FRONT
				_bringToFront.RaiseEvent(msg.sender, msg.e)

				
			Case eMsgKinds.CHECKED_CHANGED	'Set on the checkbox control

			
			Case eMsgKinds.CLICK
				_eventClick.RaiseEvent(Self, MouseEventArgs(msg.e))

			Case eMsgKinds.GOT_FOCUS
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
		End
	End
	
	'summary: This event is raised whenever the button is Clicked 
	Method Event_Click:EventHandler<MouseEventArgs>() Property; Return _eventClick; End
	'summary: This event is raised whenever the control is set a the top of its container Z-Order
	Method Event_BringToFront:EventHandler<EventArgs>() Property; Return _bringToFront; end
	'summary: This event is raised whenever the control gets the focus
	Method Event_GotFocus:EventHandler<EventArgs>() Property; Return _gotFocus; End
	'summary: This event is raised whenever a key is pressed down and the control has the focus.
	Method Event_KeyDown:EventHandler<KeyEventArgs>() Property; Return _keyDown; End
	'summary: This event is raised whenever a key stroke is completed and the control has the focus.
	Method Event_KeyPress:EventHandler<KeyEventArgs>() Property; Return _keyPress; End
	'summary: This event is raised whenever a key is raised up and the control has the focus.
	Method Event_KeyUp:EventHandler<KeyEventArgs>() Property; Return _keyUp; End
	'summary: This event is raised whenever the controls loses focus.
	Method Event_LostFocus:EventHandler<EventArgs>() Property; Return _lostFocus; end
	'summary: This event is raised whenever the mouse down button is pressed down over the control.
	Method Event_MouseDown:EventHandler<MouseEventArgs>() Property; Return _mouseDown; end
	'summary: This event is raised whenever the mouse is moved over the control.
	Method Event_MouseMove:EventHandler<MouseEventArgs>() Property; Return _mouseMove; end
	'summary: This event is raised whenever the mouse button is unpressed over the control.
	Method Event_MouseUp:EventHandler<MouseEventArgs>() Property; Return _mouseUp; end
	'summary: This event is raised whenever the mouse pointer enters the control area.
	Method Event_MouseEnter:EventHandler<EventArgs>() Property; Return _mouseEnter; end
	'summary: This event is raised whenever the mouse pointer leaves the control area.
	Method Event_MouseLeave:EventHandler<EventArgs>() Property; Return _mouseLeave; end
	'summary: This event is raised whenever the control is moved from its parent-relative location.
	Method Event_Moved:EventHandler<EventArgs>() Property; Return _moved; end
	'summary: This event is raised whenever the control padding is modified.
	Method Event_PaddingModified:EventHandler<EventArgs>() Property; Return _paddingModified; end
	'summary: This event is raised whenever the control parent is removed.
	Method Event_ParentRemoved:EventHandler<EventArgs>() Property; Return _parentRemoved; end
'summary: This event is raised whenever the control parent is resized.<br>On TopLevelControls this indicates that the whole device canvas has been resized.
	Method Event_ParentResized:EventHandler<EventArgs>() Property; Return _parentResized; end
	'summary: This event is raised whenever the control parent is set.
	Method Event_ParentSet:EventHandler<EventArgs>() Property; Return _parentSet; end
	'summary: This event is raised whenever the control is sent to the bottom of its parent the Z-Order.
	Method Event_SendToBack:EventHandler<EventArgs>() Property; Return _sendToBack; end
	'summary: This event is raised whenever the control visible property is modified.
	Method Event_VisibleChanged:EventHandler<EventArgs>() Property; Return _visibleChanged; end
	'summary: This event is raised whenever the control is resized.
	Method Event_Resized:EventHandler<EventArgs>() Property; Return _resized; end
	
	
	#REM
		 summary:This method returns the current state of the control. The result is an integer that can have any of the flags defined in eControlStatus.
		 Current available values are:
		 eControlStatus.FOCUSED
		 eControlStatus.HOOVER
		 eControlStatus.DISABLED
		 eControlStatus.NONDE
	 #END
	Method Status:Int() Property
		Local status:Int = eControlStatus.NONE
		if _gui.ActiveControl = Self Then status = status | eControlStatus.FOCUSED
		if _gui.GetMousePointedControl = Self Then status = status | eControlStatus.HOOVER
		Return status
	end
	
	
	Private

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
	Field _visible:Bool = true
	Method _FocusChecks()
		
		if Self.Visible = False Then return
		if Self.HasGraphicalInterface = False Then return
		
		if _gui = null Then
			return
		EndIf

		Local viewPort:ViewPort = new ViewPort
		'Ponemos los valores del control
		viewPort.SetValuesFromControl(Self)
		
		'Los ajustamos al viewport padre:
		if _gui.viewPortStack.Stack.IsEmpty = False Then viewPort = viewPort.Calculate(_gui.viewPortStack.Stack.Last())
			
		'Añadimos el viewport a la cola:
		_gui.viewPortStack.Stack.AddLast(viewPort)
		if HasGraphicalInterface Then 	'And is visible
			if _gui._mousePos.X>= viewPort.position.X And _gui._mousePos.X<= (viewPort.position.X + viewPort.size.X) Then
				if _gui._mousePos.Y>=viewPort.position.Y And _gui._mousePos.Y<=(viewPort.position.Y + viewPort.size.Y) then
					_gui._mouseControl = self
				end
			End
		endif
		
		if Self.IsContainer then
			Local container:= ContainerControl(Self)
			viewPort = New ViewPort
			viewPort.SetValuesFromControl(container,container.Padding)
			viewPort = viewPort.Calculate(_gui.viewPortStack.Stack.Last())
			_gui.viewPortStack.Stack.AddLast(viewPort)
			For local c:Control = EachIn container.controls
				c._FocusChecks()
			Next
			_gui.viewPortStack.Stack.RemoveLast()	'eliminamos el post-padding
		endif
	
		_gui.viewPortStack.Stack.RemoveLast()	'eliminamos el borde del control
	
	End
	
	Method _InformGui(gui:Gui)
		_gui = gui
	End
		
	Method _NavigationGotFocus()
		GetFocus()
		
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
	Field _cacheRenderPosCalcuation:GuiVector2D
	Field _hooveColor:GuiColor = Null
	Field _borderColor:GuiColor = Null

End
'summary: This is the ContainerControl class, that extends the Control class.
Class ContainerControl extends Control

	'summary: This is a Get/Set property that is useful to set the control container internal Padding space.
	Method Padding:Padding()
		Return _padding
	End
	
	'summary: This method returns TRUE if the control is a container control.
	Method IsContainer?()
		Return true
	end
	
	'summary: Clear all resources used by the control and its child controls
	Method Dispose()
		For Local c:Control = EachIn controls
			c.Dispose()
		Next
		'viewPortStack = null
		Super.Dispose()
	End
	
	Method Parent:ContainerControl() Property
		Return Super.Parent '_parentControl
	End

	'summary: A control'l parent container
	Method Parent:ContainerControl(parentControl:ContainerControl) Property
		If _parentControl = parentControl Then Return
		Super.Parent(parentControl)
		For Local child:Control = EachIn Self.controls
			child.Parent = Self
		Next
	End	
	Method Msg(msg:BoxedMsg)
		if msg.e.eventSignature = eMsgKinds.RESIZED Then
			For local control:Control = EachIn Self.controls
				Local resizeMsg:= New BoxedMsg(control, eMsgKinds.PARENT_RESIZED)
				control.Msg(resizeMsg)
			Next
		EndIf
		Super.Msg(msg)
		
	End
	
	Method Render:Void()
		Local viewPort:ViewPort = new ViewPort
		'Ponemos los valores del control
		viewPort.SetValuesFromControl(Self)
		
		'Los ajustamos al viewport padre:
		if _gui.viewPortStack.Stack.IsEmpty = False Then viewPort = viewPort.Calculate(_gui.viewPortStack.Stack.Last())
		
'		SetAlpha(0.0200)
'		SetColor(0, 0, 0)
'		Const max:Int = 12
'		For Local i:Int = 1 to max
'		SetAlpha(1.0 - (float(i) / float(max))) / 8.0
'			DrawRect(viewPort.position.X - i, viewPort.position.Y - i, Size.X + i * 2, Size.Y + i * 2)
'		next
'		SetAlpha(1)
		
		'Hacemos tijeretazo:
		SetScissor(viewPort.position.X, viewPort.position.Y, viewPort.size.X, viewPort.size.Y)
		
		'Añadimos el viewport a la cola:
		_gui.viewPortStack.Stack.AddLast(viewPort)
		RenderBackground()

		viewPort = New ViewPort
		viewPort.SetValuesFromControl(Self,Padding)
		viewPort = viewPort.Calculate(_gui.viewPortStack.Stack.Last())
		_gui.viewPortStack.Stack.AddLast(viewPort)
		SetScissor(viewPort.position.X, viewPort.position.Y, viewPort.size.X, viewPort.size.Y)
		
		RenderChildren()
		_gui.viewPortStack.Stack.RemoveLast()	'eliminamos el post-padding
		_gui.viewPortStack.Stack.RemoveLast()	'eliminamos el borde del control
				
		'Is done by derived controls.
		''If _gui._focusedControl = Self Then DrawFocus
	End

	'summary: This method is called by the Gui system when a control container has to render its background, that is, the part of the component that is drawn behind the contained controls.
	Method RenderBackground()
		Super.Render()
	end

	Method DrawFocus()
		GetGui.Renderer.DrawFocusRect(Self)
	End
	'summary: This method renders all the contained controls, in the required order.
	Method RenderChildren()
		For Local c:Control = EachIn controls
			if c.Visible = False Then Continue
			Local viewPort:ViewPort = new ViewPort
			viewPort.SetValuesFromControl(c)
			if _gui.viewPortStack.Stack.IsEmpty = False Then
				viewPort = viewPort.Calculate(_gui.viewPortStack.Stack.Last())
			EndIf
			SetScissor(viewPort.position.X, viewPort.position.Y, viewPort.size.X, viewPort.size.Y)
			if viewPort.size.X > 0 And viewPort.size.Y > 0 then c.Render()
		Next
		if _gui.viewPortStack.Stack.IsEmpty = False Then
			Local viewPort:ViewPort = _gui.viewPortStack.Stack.Last()
			SetScissor(viewPort.position.X, viewPort.position.Y, viewPort.size.X, viewPort.size.Y)
		EndIf
	End
	
	Method Update()
		For Local c:=EachIn self.controls 
			c.Update()
		Next
	End
	
	Method GenerateControlsList:List<Control>()
		Local list:= New List<Control>
		For Local control:= EachIn controls
			list.AddLast(control)
		Next
		Return list
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
End

'summary: This is the TopLevelControl class, that extends the ControlConainer class. This class represents the base of any Form control.
Class TopLevelControl extends ContainerControl
 
	'summary: This method inits the Top Level Control internals. This method has to be called BEFORE the form is used to actually do anything, including attaching controls to it, etc.
	'Be sure to call it whenever a TopLevelControl has to be used. 
	'This initialization will also cause a call to the OnInit method of the given TopLevelControl
	Method InitForm(gui:Gui)
		SetGui(gui)
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.INIT_FORM)))
	End
	
	'summary: This method will be called whenever a TopLevelControl has been properly init and we can start attaching controls to it and sending ang getting events.
	Method OnInit()
		
	End
	
	Method Msg(msg:BoxedMsg)
		Select msg.e.eventSignature
			Case eMsgKinds.INIT_FORM
				OnInit()
			Case eMsgKinds.GOT_FOCUS, eMsgKinds.MOUSE_DOWN, eMsgKinds.KEY_PRESS
				if _gui._components.Last() <> Self then BringToFront()
			End
		Super.Msg(msg)
	End
	
	
	'summary: This method returns TRUE if the control is a top level control (a window).
	Method IsTopLevelControl:Bool()
		Return true
	end
	Method Dispose()
		_gui._components.Remove(Self)
		Super.Dispose()
	End
	
	'summary: This method can be used to modify the Gui where a top level control is being executed. Modifying this during runtime is not recommended unless you know exactly what you're doing.
	Method SetGui(gui:Gui)
		if gui = null Then
			Throw New JungleGuiException("A form can't be set to a null Gui manager", Self)
		else
			if _gui <> null Then _gui._components.Remove(Self)
			_gui = gui
			_gui._components.AddFirst(Self)
			_InformGui(gui)
		endif
	End
	
	'summary: This method will bring this Top Level Control to the top of the rendering z-order.
	Method BringToFront()
		'Print "Called!"
		_gui._components.Remove(Self)
		_gui._components.AddLast(Self)
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.BRING_TO_FRONT)))
	End

	'summary: This method will send this Top Level Control to the bottom of the rendering z-order.
	Method SendToBack()
		_gui._components.Remove(Self)
		_gui._components.AddFirst(Self)
		Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.SEND_TO_BACK)))
	End
	
	Method Dispatch(msg:BoxedMsg)
		Super.Dispatch(msg)
		Select msg.e.eventSignature
			Case eMsgKinds.INIT_FORM
				_initForm.RaiseEvent(msg.sender, msg.e)
		End
	End

	
	Method Event_InitForm:EventHandler<EventArgs>() Property; Return _initForm; End
	
	
Private
	Field _initForm:= New EventHandler<EventArgs>
End

'summary: This is the main Gui element.
Class Gui

	'summary: This global contains a reference to the default system font.
	Global systemFont:BitmapFont
	Global tipFont:BitmapFont
	Method New()
		Renderer = Null	'Force default renderer
	End

	'summary: This method has to be called whenever the Gui has to be rendered.
	Method Render()
		If _renderer = Null Then Renderer = Null	'Set default renderer in case it has not been set.
		local scissor:Float[] = GetScissor()
		For Local c:Control = eachin _components
			If c.Visible = False Then Continue
			c.Render()
			SetScissor(scissor[0], scissor[1], scissor[2], scissor[3])
		Next
		SetScissor(scissor[0], scissor[1], scissor[2], scissor[3])
		
		if _waitingTipCount>10 Then
			_waitingTipCount = 10 + 1
			RenderTip()
		EndIf
	End
	
	Method Renderer:GuiRenderer() Property
		Return _renderer
	End
	Method Renderer:Void(renderer:GuiRenderer) Property
		If _renderer <> Null Then
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

	'summary: This method will clear all controls contained in this Gui.
	Method Clear()
		For Local form:TopLevelControl = EachIn _components
			form.Dispose()
		Next
		_mouseControl = null
		_mousePointerControl = null
	End
	'summary: This method has to be called whenever the Gui has to be updated.
	Method Update()

		if _mousePos = Null then _mousePos = New GuiVector2D

		_oldMousePos.SetValues(_mousePos.X, _mousePos.Y)
		
		_mousePos.SetValues(MouseX(), MouseY())
		
		if _mousePos.X < 0 Then _mousePos.X = 0 ElseIf _mousePos.X > DeviceWidth then _mousePos.X = DeviceWidth
		
		if _mousePos.Y < 0 Then _mousePos.Y = 0 ElseIf _mousePos.Y > DeviceHeight Then _mousePos.Y = DeviceHeight

		Local devWidth:= DeviceWidth()
		Local devHeight:= DeviceHeight()
		Local sendParentResize:Bool = false
		if devWidth <> Self._guiSize.X or devHeight <> Self._guiSize.Y Then
			_guiSize.SetValues(devWidth, devHeight)
			sendParentResize = true;
		EndIf
		
		Local oldMouseDown = _mouseDown
		_mouseDown = MouseDown()
		For Local c:Control = eachin _components
			c._FocusChecks()	'update control under mouse.
			c.Update()
			if c._gui = null Then Continue
			if sendParentResize Then c.Msg(New BoxedMsg(c, New EventArgs(eMsgKinds.PARENT_RESIZED)))
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
			local cords:= _mousePointerControl.CalculateRenderPosition()
			cords.X = _mousePos.X - cords.X
			cords.Y = _mousePos.Y - cords.Y
			Local eArgs:=New MouseEventArgs(eMsgKinds.MOUSE_MOVE,cords,0)
			_mousePointerControl.Msg(New BoxedMsg(_mousePointerControl, eArgs))
		EndIf
		
		if oldMouseDown = False And _mouseDown = True Then
			'this is a MouseDownEvent
			if newControl <> null Then
				'local pos:=New GuiVector2D
				Local controlPos:= newControl.CalculateRenderPosition()
				controlPos.SetValues(_mousePos.X-controlPos.X,_mousePos.Y-controlPos.Y)
				if newControl._gui <> null then newControl.Msg(New BoxedMsg(newControl, New MouseEventArgs(eMsgKinds.MOUSE_DOWN, controlPos, 1)))
				_DownControl = newControl
			EndIf
		ElseIf oldMouseDown = True And _mouseDown = False Then
			'Mouse up and possible click:
			if _DownControl <> null and _DownControl._gui <> null Then
				Local controlPos:= _DownControl.CalculateRenderPosition()
				controlPos.SetValues(_mousePos.X-controlPos.X,_mousePos.Y-controlPos.Y)
				if _DownControl._gui <> null then _DownControl.Msg(New BoxedMsg(_DownControl, New MouseEventArgs(eMsgKinds.MOUSE_UP, controlPos, 1)))
			EndIf
			if _DownControl = newControl And _DownControl <> null Then
				local pos:GuiVector2D
				pos= newControl.CalculateRenderPosition()
				pos.SetValues(_mousePos.X-pos.X,_mousePos.Y-pos.Y)
				if newControl._gui <> null then newControl.Msg(New BoxedMsg(newControl, New MouseEventArgs(eMsgKinds.CLICK, pos, 1)))
				if newControl._gui <> null then newControl.GetFocus()
			EndIf
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
	End
	'summary: This method returns TRUE if a given key is pressed.
	Method IsKeydown?(keyCode:Int)
		if keyCode<_oldKeys.Length Then
			Return _oldKeys[keyCode]>0
		Else 
			Return false
		EndIf
	End
	'summary: This method the control that is being pointed by the mouse.
	Method GetMousePointedControl:Control()
		Return _mousePointerControl
	End
	'summary: This method returns the current Mouse position
	Method MousePos:GuiVector2D()
		Return _mousePos
	End
	'summary: This method returns the current active control. That is, the control that has the focus.
	Method ActiveControl:Control()
		Return _focusedControl 
	End
	
	Private
	
	Field _renderer:GuiRenderer '= New GuiRenderer
	Field _renderTipAlpha:Float = 0
	Method RenderTip()
		Local control:=GetMousePointedControl()
		if control  = null or control.TipText = "" Then 
			_renderTipAlpha = 0
			Return
		endif
		Local Width:Int = Gui.tipFont.GetTxtWidth(control.TipText)+12
		Local Height:Int = Gui.tipFont.GetTxtHeight(control.TipText)+12
		Local DrawX:Int = _mousePos.X
		Local DrawY:Int = _mousePos.Y+10
		if DrawX+Width > DeviceWidth Then DrawX-= DrawX+Width - DeviceWidth
		if DrawY+Height> DeviceHeight Then DrawY-= DrawY+Height - DeviceHeight + (DeviceHeight-_mousePos.Y)
		'Shadow;
		SetAlpha(_renderTipAlpha*0.2)
		SetColor(0,0,0)
		DrawRect(DrawX+2,DrawY+2,Width,Height)
		
		'Background:
		SetAlpha(_renderTipAlpha)
		SetColor(230,230,230)
		Local MidPoint:Int = Height/2-1
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
	Field _mousePos:GuiVector2D 
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
	
End