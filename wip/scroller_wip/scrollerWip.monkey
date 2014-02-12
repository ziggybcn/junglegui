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
	
	Method OnInit()
		vsb = New Scroller
		vsb.Orientation = eScrollerOrientation.Vertical
		RegisterMsgListener(vsb)
		
		hsb = New Scroller
		hsb.Orientation = eScrollerOrientation.Horizontal
		RegisterMsgListener(hsb)	
	End
	
	
	
	Private
	Field vsb:Scroller
	Field hsb:Scroller
End