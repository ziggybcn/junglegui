Import junglegui
Import reflection
#REFLECTION_FILTER+="${MODPATH}"


#IF TARGET="glfw"
Extern
    'Function glfwInit:Int()
    Function glfwOpenWindowHint:Void(target:Int, hint:Int)
    Function glfwSetWindowSize:Void(width:Int, height:Int)
    Function glfwSetWindowPos:Void(x:Int, y:Int)
    'Function glfwOpenWindow:Int(width:Int, height:Int, redbits:Int, greenbits:Int, bluebits:Int, alphabits:Int, depthbits:Int, stencilbits:Int, mode:Int )
	Public
	Const GL_TRUE:Int = 1
	Const GL_FALSE:Int = 0
	
	Const GLFW_STEREO:Int           = $00020011
	Const GLFW_WINDOW_NO_RESIZE:Int = $00020012
	Const GLFW_FSAA_SAMPLES:Int     = $00020013
	Const GLFW_FULLSCREEN:Int       = $00010002
#END




Function Main()
	#if TARGET="glfw"
    glfwOpenWindowHint(GLFW_FSAA_SAMPLES, 8) ' AntiAliasing samples: 0 = disable AA
	#end
	New MyApp
End

Class MyApp Extends App
	Global gui:Gui
	Method OnCreate()
		SetUpdateRate(60)
		#if TARGET="glfw"
        'glfwSetWindowPos(0, 0)        ' set window position
        'glfwSetWindowSize(1280, 1024) ' resize window
		#end
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
	Field scrollable:ScrollableContainer
	
	Field button:Button
	Method OnInit()
		scrollable = New ScrollableContainer
		
		scrollable.Parent = Self
		
		For Local i:Int = 0 To 10
			button = New Button
			button.Parent = scrollable
			button.Text = "Hello!"
			button.Size.X = 180
			button.Size.Y = 130
			button.Position.Y = 0 + i * (button.Size.Y + 10)
		Next
		'Self.Transparent = True
		Self.Event_Resized.Add(Self, "Resized")
		Self.Event_Resized.RaiseEvent(Self, Null)
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

		'vsb.VisibleItems = 5
		'vsb.TotalItems = 15

		'hsb.VisibleItems = 10
		'hsb.TotalItems = 100
		'hsb.FirstItem = 90

						
		Padding.SetAll(2, 2, 2, 2)
		
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

		GetGui.Renderer.DrawControlBorder(Status, Self.LocationInDevice, Self.Size, Self)
	End
	
	Method RenderBackground()
		Super.RenderBackground()
	End
	
	Method Update()
		Super.Update()
		PerformScrollingUpdate()
	End
	
	Method PerformScrollingUpdate()
	End
	
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
			'Scroller.Render(vsb)
			vsb.Update(cache_cas, Size.Y - offset)
			'Print "Offset: " + offset
			
		EndIf

		If hsb.ShouldBeRendered Then
			Self.Size.CloneHere(cache_cas)
			
			cache_cas.Y -= hsb.GrabberWidth '+ 10
			cache_cas.X = 0
			'Scroller.Render(hsb)
			hsb.Update(cache_cas, Size.X - offset)
		EndIf
	End

	Field cache_cas:= New GuiVector2D	
	Field vsb:Scroller
	Field hsb:Scroller
End

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
		If vsb = Null Then Return
		If hsb = Null Then Return
	
		If Self.InternalScroll.Y <> Self.vsb.FirstItem Then Self.InternalScroll.Y = vsb.FirstItem
		If Self.InternalScroll.X <> Self.hsb.FirstItem Then Self.InternalScroll.X = hsb.FirstItem
	End
	
	Method UpdateScrollbarMaximumMinimum()
		If vsb = Null Then Return
		If hsb = Null Then Return
		Local controls:= Self.GenerateControlsList(False)
		Local maxX:Int = 0, maxY:Int = 0
		For Local control:Control = EachIn controls
			maxX = Max(maxX, control.Position.X + control.Size.X)
			maxY = Max(maxY, control.Position.Y + control.Size.Y)
		Next
		hsb.TotalItems = maxX
		hsb.VisibleItems = Self.GetClientAreaSize.X
		'Print hsb.TotalItems + ", " + hsb.FirstItem + ", " + hsb.VisibleItems
		If hsb.VisibleItems + hsb.FirstItem > hsb.TotalItems Then hsb.FirstItem = hsb.TotalItems - hsb.VisibleItems
		vsb.TotalItems = maxY
		vsb.VisibleItems = Self.GetClientAreaSize.Y
		If vsb.VisibleItems + vsb.FirstItem > vsb.TotalItems Then vsb.FirstItem = vsb.TotalItems - vsb.VisibleItems
		'Self.UpdateScrolling()
	End
End

