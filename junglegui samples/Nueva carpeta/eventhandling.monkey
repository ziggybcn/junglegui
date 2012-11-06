Import junglegui
#REFLECTION_FILTER+="eventhandling*"

Function Main()
	New Demo
End

Class Manel
	Method Draw()
		
	End
End

Class Demo Extends App
	Field gui:Gui
	Field form:MyForm
	Method OnCreate()
		For Local c:ClassInfo = EachIn GetClasses()
			Print c.Name
		Next
		SetUpdateRate(60)
		gui = New Gui
		form = New MyForm
		form.InitForm(gui)
		form.Event_Moved.Add(form, "FormMoved")
	End
	Method OnUpdate()
		gui.Update()
	End
	
	Method OnRender()
		Cls(255, 255, 255)
		gui.Render()
	End
End

Class MyForm Extends Form
	Method OnInit()
		Self.Text = "Hello!"
		Self.Size.SetValues(200, 200)
	End
	Method FormMoved(sender:Object, e:EventArgs)
		Print "Moved!"
	End
End