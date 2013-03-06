'This file was edited with Jungle IDE
Import junglegui
Import demoform

#REFLECTION_FILTER+="demo"

Function Main()
	ExecuteApp(New Demo, "Launch_Demo")
End

Class Demo
	Method Launch_Demo(sender:Object, e:InitializeAppEvent)
		'EnableAutoSize()
		e.mainForm = New DemoForm
	End
End