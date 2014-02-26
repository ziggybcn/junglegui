Import junglegui

Class ScrollableContainer Extends ScrollablePanel

	Method OnInit()
		Super.OnInit()
		'Padding.SetAll(10, 10, 10, 10)
	End
	
	Method Msg(msg:BoxedMsg)
		Super.Msg(msg)
		Local control:= Control(msg.sender)
		If control = Null Return
		If control = Self 'or control.Parent = Self
			Select msg.e.messageSignature
				Case eMsgKinds.CHILD_ADDED, eMsgKinds.CHILD_REMOVED, eMsgKinds.PADDING_MODIFIED, eMsgKinds.RESIZED
				 	UpdateScrollbarMaximumMinimum
			End
		ElseIf control.Parent = Self
			Select msg.e.messageSignature
				Case eMsgKinds.MOVED, eMsgKinds.RESIZED, eMsgKinds.VISIBLE_CHANGED
					UpdateScrollbarMaximumMinimum
			End
		EndIf
	End
	
	Method PerformScrollingUpdate()
		If VerticalScroller = Null Then Return
		If HorizontalScroller = Null Then Return
	
		If Self.InternalScroll.Y <> Self.VerticalScroller.FirstItem Then Self.InternalScroll.Y = VerticalScroller.FirstItem
		If Self.InternalScroll.X <> Self.HorizontalScroller.FirstItem Then Self.InternalScroll.X = HorizontalScroller.FirstItem
	End
	
	Private
	Method UpdateScrollbarMaximumMinimum()
		If VerticalScroller = Null Then Return
		If HorizontalScroller = Null Then Return
		Local controls:= Self.GenerateControlsList(False)
		Local maxX:Int = 0, maxY:Int = 0
		For Local control:Control = EachIn controls
			maxX = Max(maxX, control.Position.X + control.Size.X)
			maxY = Max(maxY, control.Position.Y + control.Size.Y)
		Next
		HorizontalScroller.TotalItems = maxX
		HorizontalScroller.VisibleItems = Self.GetClientAreaSize.X
		'Print HorizontalScroller.TotalItems + ", " + HorizontalScroller.FirstItem + ", " + HorizontalScroller.VisibleItems
		If HorizontalScroller.VisibleItems + HorizontalScroller.FirstItem > HorizontalScroller.TotalItems Then HorizontalScroller.FirstItem = HorizontalScroller.TotalItems - HorizontalScroller.VisibleItems
		VerticalScroller.TotalItems = maxY
		VerticalScroller.VisibleItems = Self.GetClientAreaSize.Y
		If VerticalScroller.VisibleItems + VerticalScroller.FirstItem > VerticalScroller.TotalItems Then VerticalScroller.FirstItem = VerticalScroller.TotalItems - VerticalScroller.VisibleItems
		'Self.UpdateScrolling()
		
	End
End

