'This file was edited with Jungle IDE
Import junglegui

Import demoform

#REFLECTION_FILTER+="${MODPATH}"
#GLFW_WINDOW_RESIZABLE=true

Function Main()
	Local demo:= New Demo
	ExecuteApp(demo, "Launch_Demo")
	JungleApp.Event_RenderBackground.Add(demo, "Render_Background")
End

Class Demo
	Method Launch_Demo(sender:Object, e:InitializeAppEvent)
		EnableAutoSize()
		JungleGuiApplication.gui.ScaleX = 1
		JungleGuiApplication.gui.ScaleY = 1
		e.mainForm = New DemoForm
	End
	
	Method Render_Background(sender:Object, e:EventArgs)
		

		Local color:= New GuiColor(1, 0, 0, 0)
				
		Cls(color.Red, color.Green, color.Blue)
		Const SIZE:Int = 5, MAX:Int = 600
		For Local i:Int = 0 To MAX Step SIZE
			color.ActivateBright( (MAX - i) / 8.0)
			DrawRect(0, i, DeviceWidth, SIZE)
		Next
	End
End