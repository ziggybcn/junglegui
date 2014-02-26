#Rem monkeydoc module junglegui.wip.scroller
What's a scroller?
A Scroller is a class that handles rendering of scrollbars.
This class is internally used by controls such as the ScrollablePanel
A Scroller is not a junglegui control, but a class that allows any control to draw a scrollbar that reacts to user input.

How this it work?


#end
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
	
	Method Update()
		If HasFlag(status, ScrollBarStatus.Grabbed)
			Select orientation
				Case eScrollerOrientation.Vertical
					FirstItem = PosToGrabber(listening.GetGui.MousePos.Y - updatedRectLocation.Y - mouseDownOffset)
				Case eScrollerOrientation.Horizontal
					 FirstItem = PosToGrabber(listening.GetGui.MousePos.X - updatedRectLocation.X - mouseDownOffset)
			End
		EndIf
		
	End
	
	Method Msg(msg:BoxedMsg)
		'We only listen to events of our control "container" (the listening control):
		'Print msg.e.GetEventName()
		If msg.sender <> listening Then Return
		'We react to several messages (mouse move, click, mouse leave, etc.)
		Select msg.e.messageSignature
			Case eMsgKinds.MOUSE_MOVE
				Local mEventArgs:= MouseEventArgs(msg.e)
				Local mx:= listening.ControlToDeviceX(mEventArgs.position.X)
				Local my:= listening.ControlToDeviceY(mEventArgs.position.Y)
				If mEventArgs <> Null
					Self.status = RemoveFlag(Self.status, ScrollBarStatus.Hoover)
					Select orientation
						Case eScrollerOrientation.Vertical
							If mx > updatedRectLocation.X And mx < updatedRectLocation.X + GrabberWidth Then
								If my > updatedRectLocation.Y And my < updatedRectLocation.Y + updateRectLength Then
									Self.status = Self.status | ScrollBarStatus.Hoover
								EndIf
							EndIf
						Case eScrollerOrientation.Horizontal
							
							If (mx > updatedRectLocation.X) And (mx < (updatedRectLocation.X + updateRectLength)) Then
							
								If my > (updatedRectLocation.Y) And my < (updatedRectLocation.Y + GrabberWidth) Then
									Self.status = Self.status | ScrollBarStatus.Hoover
								EndIf
							EndIf
					End
				EndIf
			Case eMsgKinds.MOUSE_LEAVE
				Self.status = RemoveFlag(Self.status, ScrollBarStatus.Hoover)
			Case eMsgKinds.MOUSE_DOWN
				Local mEventArgs:= MouseEventArgs(msg.e)
				Local mx:= listening.ControlToDeviceX(mEventArgs.position.X)
				Local my:= listening.ControlToDeviceY(mEventArgs.position.Y)
				If mEventArgs <> Null
					'Self.status = RemoveFlag(Self.status, ScrollBarStatus.Hoover)
					Select orientation
						Case eScrollerOrientation.Vertical
							If mx > updatedRectLocation.X And mx < updatedRectLocation.X + GrabberWidth Then
								If my > updatedRectLocation.Y And my < updatedRectLocation.Y + updateRectLength Then
									If IsInsideGrabber(my) Then
										status = status | ScrollBarStatus.Grabbed
										mouseDownOffset = my - GrabberPos - updatedRectLocation.Y 'mEventArgs.position.Y - GrabberPos
										'Print "INSIDE GRABBER: " + my + ", " + mouseDownOffset + ", " + GrabberPos + ", " + mEventArgs.position.Y
									EndIf
									'Self.status = Self.status + ScrollBarStatus.Hoover
								EndIf
							EndIf
						Case eScrollerOrientation.Horizontal
							
							If (mx > updatedRectLocation.X) And (mx < (updatedRectLocation.X + updateRectLength)) Then
							
								If my > (updatedRectLocation.Y) And my < (updatedRectLocation.Y + GrabberWidth) Then
									status = status | ScrollBarStatus.Grabbed
									mouseDownOffset = mx - GrabberPos - updatedRectLocation.X 'mEventArgs.position.X - GrabberPos
								EndIf
							EndIf
					End
				EndIf
			Case eMsgKinds.MOUSE_UP
				Self.status = RemoveFlag(Self.status, ScrollBarStatus.Grabbed)
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

				'Render grabber
				If HasFlag(scroller.status, ScrollBarStatus.Hoover)
					SystemColors.ScrollerGrabberColor.Activate()
				Else
					SystemColors.ScrollerGrabberColor.ActivateBright(15)
				EndIf
				Local yPos:= scroller.updatedRectLocation.Y
				Local xPos:= scroller.updatedRectLocation.X + scroller.GrabberPos '+ scroller.GrabberWidth + scroller.GrabberPos
				'Print scroller.totalItems + " -- " + scroller.firstItem + " -- " + scroller.GrabberPos
				DrawRect(
				 	xPos, yPos + 1,
					scroller.GrabberLength(),
					scroller.GrabberWidth -2)
				
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
				SetColor(255, 0, 0)
				DrawBox(Int(scroller.updatedRectLocation.X), Int(scroller.updatedRectLocation.Y) + 1, Int(scroller.GrabberWidth) - 1, Int(scroller.updateRectLength) - 2)

				'Render grabber
				If HasFlag(scroller.status, ScrollBarStatus.Hoover)
					SystemColors.ScrollerGrabberColor.Activate()
				Else
					SystemColors.ScrollerGrabberColor.ActivateBright(15)
				EndIf

				Local xPos:= scroller.updatedRectLocation.X
				Local yPos:= scroller.updatedRectLocation.Y + scroller.GrabberPos '+ scroller.GrabberWidth + scroller.GrabberPos
				DrawRect(
				 	xPos +1, yPos,
					scroller.GrabberWidth -2,
					scroller.GrabberLength() -2)
				
				'Render buttons :
				scroller.scrollerButton.Render(scroller.updatedRectLocation, eScrollerButtonKind.VerticalUp)
				Local preLoc:Int = scroller.updatedRectLocation.Y
				scroller.updatedRectLocation.Y = scroller.updatedRectLocation.Y + scroller.updateRectLength - scroller.GrabberWidth
				scroller.scrollerButton.Render(scroller.updatedRectLocation, eScrollerButtonKind.VerticalDown)
				scroller.updatedRectLocation.Y = preLoc
				Print scroller.updateRectLength + ", " + scroller.listening.Size.Y
		End
	End
	
	Method Update(anchor:GuiVector2D, length:Float)
		'note:TODO: Implement in renderer is pending		
		'anchor.Add(listening.LocationInDevice())
		'anchor.CloneHere(updatedRectLocation)
		updatedRectLocation.SetValues(anchor.X, anchor.Y)
		updatedRectLocation.Add(listening.LocationInDevice)
		updateRectLength = length
		
		'Draw Scroller Background:
		
	End
	
	Private
	
	Field mouseDownOffset:float = 0
	
	Method GrabberLength:Float()
		Local maxSize:= updateRectLength - Float(GrabberWidth * 2)
		Local size:= maxSize * (Float(visibleItems) / Float(totalItems))
		If size < GrabberWidth Then size = GrabberWidth
		Return size
	End
	
	'summary: Returns the position of the grabber relative to the updatedRenderLocation
	Method GrabberPos:Float()
		Local items:= Float(totalItems)
		Local area:= updateRectLength - (GrabberWidth * 2)
		Local pos:= (Float(area) / float(items)) * firstItem + GrabberWidth
		Return pos
	End
	
	Method PosToGrabber:Float(pos:Float)
		'Local items:= Float(totalItems)
		'Local area:= updateRectLength - (GrabberWidth * 2)
		'Local pos:= (Float(area) / float(items)) * firstItem + GrabberWidth
		'Return pos
		Local items:= Float(totalItems)
		Local area:= updateRectLength - (GrabberWidth * 2)
		Local first:Float = ( (pos - GrabberWidth) * items) / area
		'Print first
		Return first
	End
	
	Method IsInsideGrabber:Bool(pos:Float)
	
		Local solvedGrabberPos:Float
		Select orientation
			Case eScrollerOrientation.Vertical
				solvedGrabberPos = updatedRectLocation.Y + GrabberPos '+ GrabberWidth + GrabberPos

			Case eScrollerOrientation.Horizontal
				solvedGrabberPos = updatedRectLocation.X + GrabberPos '+ GrabberWidth + GrabberPos
		End
	
		If pos < solvedGrabberPos or pos > solvedGrabberPos + GrabberLength
			Return False
		Else
			Return True
		EndIf
	End
	
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
			'SetColor(255, 0, 0)
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