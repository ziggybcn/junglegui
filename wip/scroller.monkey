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
		If msg.sender <> listening Then Return
		Select msg.e.messageSignature
			Case eMsgKinds.MOUSE_MOVE
				Local mEventArgs:= MouseEventArgs(msg.e)
				Local mx:= listening.ControlToDeviceX(mEventArgs.position.X)
				Local my:= listening.ControlToDeviceY(mEventArgs.position.Y)
				'Print "(" + mx + ", " + my + ")" + updatedRectLocation.X + ", " + updatedRectLocation.Y + " --> " + updateRectLength
				If mEventArgs <> Null
					Self.status = RemoveFlag(Self.status, ScrollBarStatus.Hoover)
					Select orientation
						Case eScrollerOrientation.Vertical
							If mx > updatedRectLocation.X And mx < updatedRectLocation.X + GrabberWidth Then
								If my > updatedRectLocation.Y And my < updatedRectLocation.Y + updateRectLength Then
									Self.status = Self.status + ScrollBarStatus.Hoover
								EndIf
							EndIf
						Case eScrollerOrientation.Horizontal
							
							If (mx > updatedRectLocation.X) And (mx < (updatedRectLocation.X + updateRectLength)) Then
							
								If my > (updatedRectLocation.Y) And my < (updatedRectLocation.Y + GrabberWidth) Then
									Self.status = Self.status + ScrollBarStatus.Hoover
								EndIf
							EndIf
					End
				EndIf
			Case eMsgKinds.MOUSE_LEAVE
				Self.status = RemoveFlag(Self.status, ScrollBarStatus.Hoover)
		End
		
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

				'Render buttons :
				scroller.scrollerButton.Render(scroller.updatedRectLocation, eScrollerButtonKind.HorizontalLeft)
				Local preLoc:Int = scroller.updatedRectLocation.X
				scroller.updatedRectLocation.X = scroller.updatedRectLocation.X + scroller.updateRectLength - scroller.GrabberWidth
				scroller.scrollerButton.Render(scroller.updatedRectLocation, eScrollerButtonKind.HorizontalRight)
				scroller.updatedRectLocation.X = preLoc
				
				
				
			Case eScrollerOrientation.Vertical
				'Render box:
				DrawRect(scroller.updatedRectLocation.X, scroller.updatedRectLocation.Y, scroller.GrabberWidth, scroller.updateRectLength)
				SystemColors.ScrollerBackColor.ActivateDark(30)
				DrawBox(Int(scroller.updatedRectLocation.X), Int(scroller.updatedRectLocation.Y), Int(scroller.GrabberWidth), Int(scroller.updateRectLength))
				
				'Render buttons :
				scroller.scrollerButton.Render(scroller.updatedRectLocation, eScrollerButtonKind.VerticalUp)
				Local preLoc:Int = scroller.updatedRectLocation.Y
				scroller.updatedRectLocation.Y = scroller.updatedRectLocation.Y + scroller.updateRectLength - scroller.GrabberWidth
				scroller.scrollerButton.Render(scroller.updatedRectLocation, eScrollerButtonKind.VerticalDown)
				scroller.updatedRectLocation.Y = preLoc
				
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
		If triangle.Length = 0 Then
			Const size:= 2.5
			triangle = New Float[6]
			triangle[0] = -size triangle[1] = -size
			triangle[2] = size triangle[3] = -size
			triangle[4] = 0 triangle[5] = size
			
		EndIf
	End


	Method Render(location:GuiVector2D, kind:int)
		Local scroller:Scroller = parent
		
		If HasFlag(scroller.status, ScrollBarStatus.Hoover) Then		
			SystemColors.WindowColor.Activate()
			'DrawBox(location.X, location.Y, scroller.GrabberWidth, scroller.GrabberWidth)
			DrawRect(location.X, location.Y, scroller.GrabberWidth, scroller.GrabberWidth)
			SystemColors.ScrollerGrabberColor.Activate()
			DrawBox(location.X, location.Y, scroller.GrabberWidth, scroller.GrabberWidth)
		EndIf
		
		PushMatrix()
		Translate(location.X + parent.GrabberWidth / 2, location.Y + parent.GrabberWidth / 2)
		Select kind
			Case eScrollerButtonKind.VerticalUp
				Rotate(180)
			Case eScrollerButtonKind.VerticalDown
				'Rotate(0)
			Case eScrollerButtonKind.HorizontalLeft
				Rotate(270)
			Case eScrollerButtonKind.HorizontalRight
				Rotate(90)

		End
		DrawPoly(triangle)
		PopMatrix
		
	End
	Private
	Field parent:Scroller
	Global triangle:Float[]
End

Class eScrollerButtonKind Final
	Const VerticalUp:= 1
	Const VerticalDown:= 2
	Const HorizontalRight:= 3
	Const HorizontalLeft:= 4
End