'This file was edited with Jungle IDE
Import junglegui
Import demoform

#REFLECTION_FILTER+="demo"

Function Main()
	Local demo:= New Demo
	ExecuteApp(demo, "Launch_Demo")
	JungleApp.Event_RenderBackground.Add(demo, "Render_Background")
	JungleApp.Transparent = True
End

Class Demo
	Method Launch_Demo(sender:Object, e:InitializeAppEvent)
		EnableAutoSize()
		e.mainForm = New DemoForm
	End
	
	Method Render_Background(sender:Object, e:EventArgs)
		
		Local color:= New GuiColor(1, 0, 0, 0)
		Cls(color.r, color.g, color.b)
		Const SIZE:Int = 5, MAX:Int = 600
		For Local i:Int = 0 To MAX Step SIZE
			color.ActivateBright( (MAX - i) / 8.0)
			DrawRect(0, i, DeviceWidth, SIZE)
		Next
		
	End
End