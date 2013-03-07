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
		
		Cls(SystemColors.AppWorkspace.r, SystemColors.AppWorkspace.g, SystemColors.AppWorkspace.b)
		
	End
End