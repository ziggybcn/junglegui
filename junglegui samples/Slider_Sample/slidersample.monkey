'This is a very small minimal sample

Import junglegui
#REFLECTION_FILTER="slidersample*|junglegui*"

Function Main()
	New Sample2
End

Global gui:Gui

Class Sample2 extends App

	Field myForm:MyForm
	Method OnCreate()
		SetUpdateRate(60)
		gui = New Gui	'We create the Gui manager.
		myForm = New MyForm
		try
			myForm.InitForm(gui)
		Catch jge:JungleGuiException
			Print "Form could not be initialized becouse of an exception:"
			Print jge.ToString()
		End
	End
	
	Method OnUpdate()
		try
			gui.Update()
		Catch jge:JungleGuiException
			Print "Error updating the Gui component:"
			Print jge.ToString()
			Error(jge.ToString())
		end
	End
	
	Method OnRender()
		Cls(255, 255, 255)
		try
			gui.Render()
		Catch jge:JungleGuiException
			Print "Error rendering the Gui component:"
			Print jge.ToString()
			Error(jge.ToString())
		end
	End
End

Class MyForm extends Form

	Field slider:Slider

	Method OnInit()
		'''
		''' MyForm
		'''
		Events.Add(Self, eEventKinds.MOVED, "MyForm_Moved")
		Self.Name = "MyForm"
		
		'''
		''' button
		'''
		slider = New Slider
		slider.Position.SetValues(10, 10)
		slider.Parent = Self
		slider.Name = "slider"
		Events.Add(slider, eEventKinds.CLICK, "hello_world")
	End

	Method MyForm_Moved(sender:Control, e:EventArgs)
		Self.Text = "Moved to: " + Self.Position.X + ", " + Self.Position.Y
	End
End