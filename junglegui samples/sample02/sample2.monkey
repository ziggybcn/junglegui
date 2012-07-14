'This is a very small minimal sample

Import junglegui
#REFLECTION_FILTER="sample2*|junglegui*"

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

	Field button:Button

	Method OnInit()
		'''
		''' MyForm
		'''
		Events.Add(Self, eEventKinds.MOVED, "MyForm_Moved")
		
		'''
		''' button
		'''
		button = New Button
		button.Position.SetValues(10, 10)
		button.Text = "Sample button!"
		button.Parent = Self
		Self.Events.Add(button, eEventKinds.CLICK, "Button_Clicked")
				
	End

	Method Button_Clicked(sender:Control, e:EventArgs)
		Self.Text = "Button was clicked in millisecond: " + Millisecs()
	End

	Method MyForm_Moved(sender:Control, e:EventArgs)
		Self.Text = "Moved to: " + Self.Position.X + ", " + Self.Position.Y
	End
End