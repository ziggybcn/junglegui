Import drawingpoint
Import eventargs
Import guicolor
Import viewportstack
Import helperfunctions
Import eventhandler
Import padding
private
Import mojo
public
'summary: this is the base class of a JungleGui control

Class Control

	Public

	Method Name:String() Property
		Return _name
	End
	
	Method Name:Void(value:String) Property
		_name = value
	End
	
	Method New()
		_GuiVector2D.SetNotifyControl(Self, eEventKinds.MOVED)
		_drawingSize.SetNotifyControl(Self, eEventKinds.RESIZED)
	End
	
	'summary: this is the location of the control in the parent container control
	Method Position:ControlGuiVector2D() Property
		Return _GuiVector2D
	end
	
	Method Position:Void(value:ControlGuiVector2D) Property
		if value<>null Then 
			_GuiVector2D = value 
			_GuiVector2D.SetNotifyControl(Self, eEventKinds.MOVED)	'We want to get events
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
			_drawingSize.SetNotifyControl(Self, eEventKinds.RESIZED)	'We want to get events
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
		return _htmlforecolor.Clone() 'SetColor(255,255,255)
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

	'This is automatically called when the control needs to be drawn on the screen.
	Method Render:Void()
		Local color:Float[] = GetColor()
		SetColor(Self.BackgroundColor.r, Self.BackgroundColor.g,Self.BackgroundColor.b)
		Local renderPos:GuiVector2D = self.CalculateRenderPosition()
		DrawRect(renderPos.X,renderPos.Y,Size.X,Size.Y)
		SetColor(color[0],color[1],color[2])
	End
	
	'This is the internal low-level event message pool. this method should not be overriden unless you know what you're doing.
	Method Msg:Void(sender:Object, e:EventArgs)
		Local targetControl := self
		if targetControl._parentControl<> null Then
			_parentControl.Msg(sender,e)		
		endif
'		While targetControl._parentControl <> null
'			targetControl = targetControl._parentControl
'		Wend
'		if targetControl.IsTopLevelControl Then
'			Local topLevel:TopLevelControl = TopLevelControl(targetControl)
'			topLevel.EventRaised(sender,e)
'		EndIf
	End
	
	'This returns the Gui component where this control is running.
	Method GetGui:Gui()
		Return _gui
	End
	
	'summary: this returns TRUE if this control is a Top level control (a window)
	Method IsTopLevelControl?()
		Return false
	End
	
	'summary: This returns TRUE if this control is a control container that has child controls.
	Method IsContainer?()
		Return false
	End

	'summary: This is a Get/Set property that allows us to control the parent of this control. That is, the control where this control is located.
	'On top level controls (windows) this method returns NULL and can't be set to anything other than NULL
	Method Parent:ContainerControl() Property
		Return _parentControl
	End


	'summary: A control'l parent container
	Method Parent:ContainerControl(parentControl:ContainerControl) Property
		if _parentControl = parentControl Then return
		if _parentControl <>null Then
			_parentControl.controls.Remove(Self)
			Msg(Self,New EventArgs(eEventKinds.PARENT_REMOVED))
		EndIf
		if parentControl <> null then 
			_parentControl = parentControl
			parentControl.controls.AddLast(Self)
			Msg(Self,New EventArgs(eEventKinds.PARENT_SET))
			_gui = parentControl._gui
		Else
			_gui = null
		EndIf
	End
	
	
	'summary: Bring a control to the front of the Z-Order
	Method BringToFront()
		if _parentControl = null Then Return
		_parentControl.controls.Remove(Self)
		_parentControl.controls.AddLast(Self)
		Msg(Self, New EventArgs(eEventKinds.BRING_TO_FRONT ))
	End
	
	'summary: send a control to the back of the Z-Order
	Method SendToBack()
		if _parentControl = null Then Return
		_parentControl.controls.Remove(Self)
		_parentControl.controls.AddFirst(Self)
		Msg(Self, New EventArgs(eEventKinds.SEND_TO_BACK ))
	End
	
	'summary: Clear all resources used by the control and its child controls. This is automatically called by the Gui system when the control needs to "die".
	Method Dispose()
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
	
	'summary: This is automatically called by the Gui engine when the control needs to be updated.
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
		if _gui._focusedControl <> null Then
			_gui._focusedControl.Msg(_gui._focusedControl,New EventArgs(eEventKinds.LOST_FOCUS))
		EndIf
		_gui._focusedControl = self
		Msg(Self,New EventArgs(eEventKinds.GOT_FOCUS))
	End
	
	'summary:This method will give the focus to the next control that can take it.
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
	
	Method HasGraphicalInterface:Bool() property
		Return True
	end

	Method HasFocus:Bool()
		Return _gui._focusedControl = self
	End
	
	
	Method Visible:Bool() Property
		Return _visible
	End
	
	Method Visible:Void(value:Bool) Property
		if value<> _visible then
			_visible = value
			Msg(Self,eEventKinds.VISIBLE_CHANGED)
		endif
	End

	Method TipText:Void(value:String) Property
		_tipText = value
	End
	
	Method TipText:String() Property
		Return _tipText
	End
	
	Private
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
			Local container:=ContainerControl(Self)
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
	Field _backgroundColor:GuiColor = SystemColors.ControlFace.Clone() 'new GuiColor(1,170,170,170)
	Field _foreColor:GuiColor = New GuiColor(1, 0, 0, 0)
	Global _htmlforecolor:GuiColor = New GuiColor(1, 255, 255, 255)
	Field _gui:Gui 
	Field _tabStop:Bool = true
	Field _name:String = ""
	'Cache items:
	Field _cacheRenderPosCalcuation:GuiVector2D

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
	
	Method Msg:Void(sender:Object, e:EventArgs)
		if e.eventSignature = eEventKinds.RESIZED Then
			For local control:Control = EachIn Self.controls
				control.Msg(control, New EventArgs(eEventKinds.PARENT_RESIZED))
			Next
		EndIf
		Super.Msg(sender, e)
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

		
		viewPort.SetValuesFromControl(Self,Padding)
		viewPort = viewPort.Calculate(_gui.viewPortStack.Stack.Last())
		_gui.viewPortStack.Stack.AddLast(viewPort)
				
		RenderChildren()
		_gui.viewPortStack.Stack.RemoveLast()	'eliminamos el post-padding
		_gui.viewPortStack.Stack.RemoveLast()	'eliminamos el borde del control
		
		if _gui._focusedControl = Self Then	DrawFocusRect(Self)
	End

	'summary: This method is called by the Gui system when a control container has to render its background, that is, the part of the component that is drawn behind the contained controls.
	Method RenderBackground()
		Super.Render()
	end

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
 
	'summary: This is the EventHandler of this Top Level Control.
	Method Events:EventHandler()
		Return _eventHandler
	End

	'summary: This method inits the Top Level Control internals. This method has to be called BEFORE the form is used to actually do anything, including attaching controls to it, etc.
	'Be sure to call it whenever a TopLevelControl has to be used. 
	'This initialization will also cause a call to the OnInit method of the given TopLevelControl
	Method InitForm(gui:Gui)
		SetGui(gui)
		InitEventHandler()
		Msg(Self, New EventArgs(eEventKinds.INIT_FORM))
	End
	
	'summary: This method will be called whenever a TopLevelControl has been properly init and we can start attaching controls to it and sending ang getting events.
	Method OnInit()
		
	End
	
	Method Msg:Void(sender:Object,e:EventArgs)
		Select e.eventSignature
			Case eEventKinds.INIT_FORM 
				OnInit()
			Case eEventKinds.GOT_FOCUS, eEventKinds.MOUSE_DOWN, eEventKinds.KEY_PRESS
				if _gui._components.Last() <> Self then BringToFront()
		End select
		Self.EventRaised(sender, e)
	End
	'summary: This method deals with all internal event handling.  
	Method EventRaised(sender:Object, e:EventArgs) Final
		if _eventHandler = null Then Return
		Local control:= Control(sender)
		if control = null Then return
		Local events:List<EventDelegate> = _eventHandler.FindAll(control, e.eventSignature)
		if events.IsEmpty = False Then
			For Local delegate:EventDelegate = EachIn events
				delegate.Invoke(Self, control, e)
			Next
		EndIf
	end
	
	'summary: This method returns TRUE if the control is a top level control (a window).
	Method IsTopLevelControl:Bool()
		Return true
	end
	Method Dispose()
		_gui._components.Remove(Self)
		_eventHandler.Clear()
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
		Msg(Self, New EventArgs(eEventKinds.BRING_TO_FRONT))
	End

	'summary: This method will send this Top Level Control to the bottom of the rendering z-order.
	Method SendToBack()
		_gui._components.Remove(Self)
		_gui._components.AddFirst(Self)
		Msg(Self, New EventArgs(eEventKinds.SEND_TO_BACK))
	End
	
	'summary: This method handles all required updating of the contained controls.
	Method Update() 
		if _eventHandler = null Then
			InitEventHandler
		end
		
		Super.Update()
	End
	Private
	Field _eventHandler:EventHandler
	Method InitEventHandler()
		_eventHandler = New EventHandler(Self)
	end
End

'summary: This is the main Gui element.
Class Gui

	'summary: This global contains a reference to the default system font.
	Global systemFont:BitmapFont
	Global tipFont:BitmapFont
	Method New()
#IF TARGET="html5"
		if systemFont = null Then systemFont = New BitmapFont("html5font.txt")	
		if tipFont = null Then tipFont = New BitmapFont("html5TipFont.txt")
#ELSE
		if systemFont = null Then systemFont = New BitmapFont("smallfont1.txt")	
		if tipFont = null Then tipFont = New BitmapFont("TipFont.txt")
#END
	End

	'summary: This method has to be called whenever the Gui has to be rendered.
	Method Render()
		local scissor:Float[] = GetScissor()
		For Local c:Control = eachin _components
			if c.Visible = False Then Continue
			c.Render()
			SetScissor(scissor[0],scissor[1],scissor[2],scissor[3])
		Next
		SetScissor(scissor[0],scissor[1],scissor[2],scissor[3])	
		if _waitingTipCount>10 Then
			_waitingTipCount = 10 + 1
			RenderTip()
		EndIf
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
			if sendParentResize Then
				c.Msg(c, New EventArgs(eEventKinds.PARENT_RESIZED))
			EndIf
		Next
		Local oldControl:= _mousePointerControl
		Local newControl:= _mouseControl
		Local mouseMoved:Bool = False
		_mousePointerControl = _mouseControl 
		_mouseControl = null
		if oldControl  <> newControl  Then
			if oldControl <> null Then oldControl.Msg(oldControl,New EventArgs(eEventKinds.MOUSE_LEAVE))
			if newControl <> null Then newControl.Msg(newControl, New EventArgs(eEventKinds.MOUSE_ENTER))
			mouseMoved = true
		end
		
		if _mousePointerControl <>null And (_oldMousePos.X <> _mousePos.X or _oldMousePos.Y <> _mousePos.Y) Then
			local cords:= _mousePointerControl.CalculateRenderPosition()
			cords.X = _mousePos.X - cords.X
			cords.Y = _mousePos.Y - cords.Y
			Local eArgs:=New MouseEventArgs(eEventKinds.MOUSE_MOVE,cords,0)
			_mousePointerControl.Msg(_mousePointerControl, eArgs)
		EndIf
		
		if oldMouseDown = False And _mouseDown = True Then
			'this is a MouseDownEvent
			if newControl <> null Then
				'local pos:=New GuiVector2D
				Local controlPos:= newControl.CalculateRenderPosition()
				controlPos.SetValues(_mousePos.X-controlPos.X,_mousePos.Y-controlPos.Y)
				newControl.Msg(newControl, New MouseEventArgs(eEventKinds.MOUSE_DOWN,controlPos,1))
				_DownControl = newControl
			EndIf
		ElseIf oldMouseDown = True And _mouseDown = False Then
			'Mouse up and possible click:
			if _DownControl <> null Then
				Local controlPos:= _DownControl.CalculateRenderPosition()
				controlPos.SetValues(_mousePos.X-controlPos.X,_mousePos.Y-controlPos.Y)
				_DownControl.Msg(_DownControl, New MouseEventArgs(eEventKinds.MOUSE_UP,controlPos,1))
			EndIf
			if _DownControl = newControl And _DownControl <> null Then
				local pos:GuiVector2D
				pos= newControl.CalculateRenderPosition()
				pos.SetValues(_mousePos.X-pos.X,_mousePos.Y-pos.Y)
				newControl.Msg(newControl, New MouseEventArgs(eEventKinds.CLICK,pos,1))
				newControl.GetFocus()
			EndIf
		EndIf
		Local keys:Int[] = New Int[256]
		Local doCheck:Bool = keys.Length = _oldKeys.Length And self._focusedControl <> null
		For Local i:Int = 0 to 255 'to name something
			keys[i] = KeyDown(i)
			if doCheck Then
				if keys[i] = True And _oldKeys[i] = false Then
					'KeyDown!
					_focusedControl.Msg(_focusedControl,New KeyEventArgs(eEventKinds.KEY_DOWN,i))
				ElseIf keys[i] = False And _oldKeys[i] = True Then
					_focusedControl.Msg(_focusedControl,New KeyEventArgs(eEventKinds.KEY_UP,i))
					'_focusedControl.Msg(_focusedControl,New KeyEventArgs(eEventKinds.KEY_PRESS,i))
					'KeyUp and KeyPress
				EndIf
			end if
		Next
		local char:Int = GetChar()
		if char<>0 and _focusedControl <> null Then
			_focusedControl.Msg(_focusedControl,New KeyEventArgs(eEventKinds.KEY_PRESS,char))
		EndIf
		if char = 9 and _focusedControl<>null Then 	'MODIFY_TAB!!!
			'Do focus chanche here!
			_focusedControl.FocusNext()
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
	
	Field _renderTipAlpha:Float=0
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