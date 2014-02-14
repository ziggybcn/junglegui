Import junglegui
Class Scroller Implements MsgListener
	
	Method New()
		scrollerButton = New ScrollerButton(Self)
	End
	Method Register(obj:Control)
		listening = obj
	End
	
	Method UnRegister(obj:Control)
		listening = Null
	End
	
	Method Msg(msg:BoxedMsg)
		'Print msg.e.GetEventName()
		If msg.sender = listening And msg.e.messageSignature = eMsgKinds.MOUSE_MOVE Then
			If Self.orientation = eScrollerOrientation.Vertical
				Local mEventArgs:= MouseEventArgs(msg.e)
				If mEventArgs <> Null Then
				Print mEventArgs.position.X + ", " + mEventArgs.position.Y
				
				
'					If mEventArgs.position.X > (updatedRectLocation.X + listening.LocationInDevice.X) Then
'						If mEventArgs.position.X < (updatedRectLocation.X + listening.LocationInDevice.X) + GrabberWidth Then
'							If mEventArgs.position.Y > (updatedRectLocation.Y + listening.LocationInDevice.Y) Then
'								If mEventArgs.position.Y < (updatedRectLocation.Y + listening.LocationInDevice.Y) + GrabberWidth Then
'									Print "Inside vertical!"
'								EndIf
'							EndIf
'						EndIf
'					EndIf
				EndIf
			EndIf
		EndIf
		
	End

	Method Orientation:Int() Property
		Return orientation
	End
	
	Method Orientation:Void(value:Int) Property
		orientation = value
	End
	
	
	Method VisibleItems:Int() Property
		Return visibleItems
	End
	
	Method VisibleItems:Void(value:Int) Property
		visibleItems = value
	End
	
	Method TotalItems:Int() Property
		Return totalItems
	End
	
	Method TotalItems:Void(value:Int) Property
		totalItems = value
	End
	
	Method ShouldBeRendered:Bool()
		Return totalItems > visibleItems
	End
	
	'summary: This is zero based.
	Method FirstItem:Int() Property
		Return firstItem
	End
	
	'summary: This is zero based.
	Method FirstItem:Void(value:Int) Property
		If value > (totalItems - visibleItems) Then value = (totalItems - visibleItems)
		If value < 0 Then value = 0
		firstItem = value
	End
	
	Method GrabberWidth:Int()
		Return listening.GetGui.Renderer.ScrollerGrabberWidth
	End
	
	Function Render(scroller:Scroller)

		'Draw Scroller Background:
		SystemColors.ScrollerBackColor.Activate()
		Select scroller.orientation
			Case eScrollerOrientation.Horizontal
				'Render box:
				DrawRect(scroller.updatedRectLocation.X, scroller.updatedRectLocation.Y, scroller.updateRectLength, scroller.GrabberWidth)
				SystemColors.ScrollerBackColor.ActivateDark(30)
				DrawBox(Int(scroller.updatedRectLocation.X), Int(scroller.updatedRectLocation.Y), Int(scroller.updateRectLength), Int(scroller.GrabberWidth))
				
				
				
			Case eScrollerOrientation.Vertical
				'Render box:
				DrawRect(scroller.updatedRectLocation.X, scroller.updatedRectLocation.Y, scroller.GrabberWidth, scroller.updateRectLength)
				SystemColors.ScrollerBackColor.ActivateDark(30)
				DrawBox(Int(scroller.updatedRectLocation.X), Int(scroller.updatedRectLocation.Y), Int(scroller.GrabberWidth), Int(scroller.updateRectLength))
				
				'Render button Up:
				scroller.scrollerButton.Render(scroller.updatedRectLocation, eScrollerButtonKind.VerticalUp) '.X, scroller.updatedRectLocation.Y, scroller.GrabberWidth, scroller.GrabberWidth)
		End		
	End
	
	Method Update(anchor:GuiVector2D, length:Float)
		'note:TODO: Implement in renderer is pending		
		anchor.Add(listening.LocationInDevice())
		anchor.CloneHere(updatedRectLocation)
		updateRectLength = length
		
		'Draw Scroller Background:
		
	End
	
	
	Private
	Field updatedRectLocation:= New GuiVector2D
	Field updateRectLength:Float = 0
		
	Field orientation:Int
	Field listening:Control
	Field status:Int
	Field visibleItems:Int
	Field totalItems:Int
	Field firstItem:Int = 0
	Field scrollerButton:ScrollerButton
End

Class eScrollerOrientation
	Const Vertical:Int = 1
	Const Horizontal:Int = 2
End

Class ScrollBarStatus Final
	Const None:Int = 0
	Const Hoover:Int = 1
	Const Grabbed:Int = 2
End

Class ScrollerButton

	Method New(parent:Scroller)
		Self.parent = parent
	End


	Method Render(location:GuiVector2D, kind:int)
		Local scroller:Scroller = parent
		
		If HasFlag(scroller.status, ScrollBarStatus.Hoover) Then		
			SystemColors.ScrollerGrabberColor.Activate()
			DrawBox(location.X, location.Y, scroller.GrabberWidth, scroller.GrabberWidth)
		EndIf
	End
	Private
	Field parent:Scroller
End

Class eScrollerButtonKind Final
	Const VerticalUp:= 1
	Const VerticalDown:= 2
	Const HorizontalRight:= 3
	Const HorizontalLeft:= 4
End