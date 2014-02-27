Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

Class ScrollablePanel Extends Panel Abstract
	
	Method OnInit()
		vsb = New Scroller
		vsb.Orientation = eScrollerOrientation.Vertical
		RegisterMsgListener(vsb)
		
		hsb = New Scroller
		hsb.Orientation = eScrollerOrientation.Horizontal
		RegisterMsgListener(hsb)
						
		Padding.SetAll(2, 2, 2, 2)
		
	End
	
	Method HorizontalScroller:Scroller()
		Return hsb
	End
	
	Method VerticalScroller:Scroller()
		Return vsb
	End
	
	Method RenderForeground()
		UpdateScrolling()
		'Render Scrollbars here!
		'Super.RenderForeground
		
		Local renders:Int = 0
		
		'We will render now the vertical scrollbar:
		If hsb = Null or vsb = Null Then Return
		If vsb.ShouldBeRendered Then
			Scroller.Render(vsb)
			renders += 1
		EndIf
		If hsb.ShouldBeRendered Then
			Scroller.Render(hsb)
			renders += 1
		EndIf
		If renders > 1 Then
			BackgroundColor.Activate()
			DrawRect(LocationInDevice.X + Size.X - hsb.GrabberWidth, LocationInDevice.Y + Size.Y - hsb.GrabberWidth, hsb.GrabberWidth, hsb.GrabberWidth)
		EndIf

		If DrawFocusRect Then
			GetGui.Renderer.DrawControlBorder(Status, Self.LocationInDevice, Self.Size, Self)
		EndIf
	End
	
	Method RenderBackground()
		Super.RenderBackground()
	End
	
	Method Update()
		Super.Update()
		PerformScrollingUpdate()
	End
	
	Method PerformScrollingUpdate() Abstract
	
	Private
	
	Method UpdateScrolling()
		Local left, top, right, bottom
		If hsb = Null or vsb = Null Then Return
		'note:TODO Check for resize event!
		If hsb.ShouldBeRendered Then bottom = hsb.GrabberWidth
		If vsb.ShouldBeRendered Then right = vsb.GrabberWidth

		Local renders:Int = 0, offset:Int = 0
		If vsb.ShouldBeRendered Then renders += 1
		If hsb.ShouldBeRendered Then renders += 1
		
		If renders > 1 Then offset += hsb.GrabberWidth

		ControlBordersSizes.SetAll(top, left, bottom, right)
		
		'We will render now the vertical scrollbar:
		If vsb.ShouldBeRendered Then
			Self.Size.CloneHere(cache_cas)
			
			cache_cas.X -= vsb.GrabberWidth '+ 10
			cache_cas.Y = 0
			vsb.Update(cache_cas, Size.Y - offset)
			
		EndIf

		If hsb.ShouldBeRendered Then
			Self.Size.CloneHere(cache_cas)
			
			cache_cas.Y -= hsb.GrabberWidth '+ 10
			cache_cas.X = 0
			hsb.Update(cache_cas, Size.X - offset)
		EndIf
	End

	Field cache_cas:= New GuiVector2D	
	Field vsb:Scroller
	Field hsb:Scroller
End
