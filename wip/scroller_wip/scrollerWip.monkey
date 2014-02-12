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
	Method OnInit()
		scrollable = New ScrollablePanel
		scrollable.Parent = Self
	End
	
End


Class ScrollablePanel Extends Panel
	
	Method New()
		Self.ControlBordersSizes.SetAll(20, 30, 40, 50)
	End

	Field but:Button
	
	Method OnInit()
		vsb = New Scroller
		vsb.Orientation = eScrollerOrientation.Vertical
		RegisterMsgListener(vsb)
		
		hsb = New Scroller
		hsb.Orientation = eScrollerOrientation.Horizontal
		RegisterMsgListener(hsb)
		
		'This is just for testing:
		but = New Button
		but.AutoAdjustSize = False
		but.Parent = Self
		but.Size.SetValues(Self.GetClientAreaSize.X, Self.GetClientAreaSize.Y)
		but.Text = "Buton!"
		
	End
	
	Method RenderForeground()
		'Render Scrollbars here!
		Super.RenderForeground
		
	End
	
	Method Update()
		Super.Update
		Local left, top, right, bottom

		'note:TODO Check for resize event!
		If hsb.ShouldBeRendered Then right = hsb.GrabberWidth
		If vsb.ShouldBeRendered Then bottom = vsb.GrabberWidth

		ControlBordersSizes.SetAll(top, left, bottom, right)
	End
	
	Private
	Field vsb:Scroller
	Field hsb:Scroller
End

