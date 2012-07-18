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
		'Events.Add(Self, eEventKinds.MOVED, "MyForm_Moved")
		
		'''
		''' button
		'''
		button = New Button
		button.Position.SetValues(10, 10)
		button.Text = "Sample button!"
		button.Parent = Self

		button.EventClick.Add(Self, "Button_Clicked")
		
		'''
		''' trackbar
		'''
		local trackbar:= New TrackBar
		trackbar.Parent = Self
		trackbar.Position.SetValues(100, 100)
		'Self.Events.Add(trackbar, eEventKinds.SLIDING_VALUE_CHANGED, "Trackbar1_ValueChanged")
		trackbar.Minimum = 0
		trackbar.Maximum = 10
		trackbar.Tickfrequency = 1
		
		trackbar = New TrackBar
		trackbar.Parent = Self
		trackbar.Position.SetValues(100, 150)
		trackbar.Minimum = -100
		trackbar.Maximum = 200
		trackbar.Tickfrequency = 10
		'Self.Events.Add(trackbar, eEventKinds.SLIDING_VALUE_CHANGED, "Trackbar2_ValueChanged")
		
		trackbar = New TrackBar
		trackbar.Parent = Self
		trackbar.Position.SetValues(10, 50)
		trackbar.Minimum = -5
		trackbar.Maximum = 5
		trackbar.Orientation = eOrientation.VERTICAL
		trackbar.Size.SetValues(40, 150)
		'trackbar.Tickfrequency = 1
		'Self.Events.Add(trackbar, eEventKinds.SLIDING_VALUE_CHANGED, "Trackbar2_ValueChanged")
	End

	Method Button_Clicked(sender:Object, e:MouseEventArgs)
		Self.Text = "Button was clicked in millisecond: " + Millisecs()
		button.EventClick.Remove(Self, "Button_Clicked")
	End
	
	Method Trackbar1_ValueChanged(sender:Control, e:EventArgs)
		Self.Text = "trackbar1 value changed: " + TrackBar(sender).Value
	End
	
	Method Trackbar2_ValueChanged(sender:Control, e:EventArgs)
		Self.Text = "trackbar2 value changed: " + TrackBar(sender).Value
	End

	Method MyForm_Moved(sender:Control, e:EventArgs)
		Self.Text = "Moved to: " + Self.Position.X + ", " + Self.Position.Y
	End
End