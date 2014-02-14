Import junglegui
Import reflection
#REFLECTION_FILTER+="${MODPATH}"
Function Main()
	New MyApp
End

Class MyApp Extends App
	Global gui:Gui
	Method OnCreate()
		SetUpdateRate(60)
		gui = New Gui
		
		Local f:= New TestForm
		f.InitForm(gui)
	End
	
	Method OnUpdate()
		gui.Update()
	End
	
	Method OnRender()
		Cls(255, 255, 255)
		gui.Render()
	End
End

Class TestForm Extends Form
	Field scrollable:ScrollablePanel
	
	Field button:Button
	Method OnInit()
		scrollable = New ScrollablePanel
		scrollable.Parent = Self
		button = New Button
		button.Parent = scrollable
		button.Text = "Hello!"
		button.Size.X = 80
		button.Size.Y = 30
		
		Self.Event_Resized.Add(Self, "Resized")
	End
	
	Method Resized(sender:Object, e:EventArgs)
		Self.GetClientAreaSize.CloneHere(scrollable.Size)
	End
End




Class ScrollablePanel Extends Panel
	
	Method OnInit()
		vsb = New Scroller
		vsb.Orientation = eScrollerOrientation.Vertical
		RegisterMsgListener(vsb)
		
		hsb = New Scroller
		hsb.Orientation = eScrollerOrientation.Horizontal
		RegisterMsgListener(hsb)

		vsb.VisibleItems = 5
		vsb.TotalItems = 15

		hsb.VisibleItems = 25
		hsb.TotalItems = 145
				
		Padding.SetAll(2, 10, 2, 2)
		
	End
	
	Private
	Field cache_cas:= New GuiVector2D
	Public
	Method RenderForeground()
		'Render Scrollbars here!
		'Super.RenderForeground
		
		Local renders:Int = 0
		
		'We will render now the vertical scrollbar:
		If vsb.ShouldBeRendered Then
			Scroller.Render(vsb)
			renders += 1
		EndIf
		If hsb.ShouldBeRendered Then
			Scroller.Render(hsb)
			renders += 1
		EndIf
		If renders > 0 Then
			SystemColors.WindowColor.Activate()
			DrawRect(LocationInDevice.X + Size.X - hsb.GrabberWidth, LocationInDevice.Y + Size.Y - hsb.GrabberWidth, hsb.GrabberWidth, hsb.GrabberWidth)
		EndIf

		GetGui.Renderer.DrawControlBorder(Status, Self.LocationInDevice, Self.Size, Self)
	End
	
	Method UpdateScrolling()
		Local left, top, right, bottom

		'note:TODO Check for resize event!
		If hsb.ShouldBeRendered Then bottom = hsb.GrabberWidth
		If vsb.ShouldBeRendered Then right = vsb.GrabberWidth

		Local renders:Int = 0, offset:Int = 0
		If vsb.ShouldBeRendered Then renders += 1
		If hsb.ShouldBeRendered Then renders += 1
		
		If renders > 1 Then offset += hsb.GrabberWidth
		
		'We will render now the vertical scrollbar:
		If vsb.ShouldBeRendered Then
			Self.Size.CloneHere(cache_cas)
			
			cache_cas.X -= vsb.GrabberWidth '+ 10
			cache_cas.Y = 0
			'Scroller.Render(vsb)
			vsb.Update(cache_cas, Size.Y - offset)
		EndIf

		If hsb.ShouldBeRendered Then
			Self.Size.CloneHere(cache_cas)
			
			cache_cas.Y -= vsb.GrabberWidth '+ 10
			cache_cas.X = 0
			'Scroller.Render(hsb)
			hsb.Update(cache_cas, Size.X - offset)
		EndIf
		ControlBordersSizes.SetAll(top, left, bottom, right)
	End
	
	Method RenderBackground()
		UpdateScrolling()
		Super.RenderBackground()
		SetColor(255, 255, 255)
		DrawRect(GetClientAreaLocation.X, GetClientAreaLocation.Y, GetClientAreaSize.X, GetClientAreaSize.Y)
	End
	Private
	Field vsb:Scroller
	Field hsb:Scroller
End


