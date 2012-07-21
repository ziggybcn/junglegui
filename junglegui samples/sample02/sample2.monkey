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
		EnableAutoSize()
		gui = New Gui	'We create the Gui manager.
		myForm = New MyForm
		try
			myForm.InitForm(gui)
		Catch jge:JungleGuiException
			Print "Form could not be initialized becouse of an exception:"
			Print jge.ToString()
		End
	
'		For Local i:Int = 0 to 20
'			Local mf:= New MyForm
'			mf.InitForm(gui)
'			mf.Position.SetValues(int(Rnd(0, DeviceWidth - mf.Size.X)), Int(Rnd(0, DeviceHeight - mf.Size.Y)))
'		Next
'			
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
		Cls(0, 0, 105)
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
	Field vScrollBar:VScrollBar
	Field listBox1:ListBox
	Field comboBox:ComboBox
	
	Method OnInit()
		Size.SetValues(500, 400)
		'''
		''' MyForm
		'''
		'Events.Add(Self, eMsgKinds.MOVED, "MyForm_Moved")
		Self.Event_Moved.Add(Self, "MyForm_Moved")
		
		'''
		''' button
		'''
		button = New Button
		button.Position.SetValues(10, 10)
		button.Text = "Sample button!"
		button.Parent = Self
		button.Event_Click.Add(Self, "Button_Clicked")
		
		'''
		''' comboBox
		'''
		comboBox = new ComboBox(self, 150, 10, 130)
		For Local i = 0 until 33
			comboBox.Items.AddLast(New ListItem("comboBox Item " + i))
		Next
		comboBox.Event_SelectedIndexChanged.Add(Self, "combobox_SelectedIndexChanged")
		
		'''
		''' trackbar
		'''
		local trackbar:= New TrackBar
		trackbar.Parent = Self
		trackbar.Position.SetValues(230, 120)
		trackbar.Event_ValueChanged.Add(Self, "Trackbar1_ValueChanged")
		trackbar.Minimum = 0
		trackbar.Maximum = 10
		trackbar.Tickfrequency = 1
		
		trackbar = New TrackBar
		trackbar.Parent = Self
		trackbar.Position.SetValues(150, 60)
		trackbar.Minimum = -100
		trackbar.Maximum = 200
		trackbar.Tickfrequency = 10
		trackbar.Event_ValueChanged.Add(Self, "Trackbar2_ValueChanged")
		
		'''
		''' vertical scrollbar
		'''
		vScrollBar = New VScrollBar()
		vScrollBar.Parent = Self
		vScrollBar.Position.SetValues(Self.Size.X - 17 - Self.Padding.Left - Self.Padding.Right, 0)
		vScrollBar.Size.SetValues(17, Size.Y - Self.Padding.Top - Self.Padding.Bottom)
		vScrollBar.Event_ValueChanged.Add(Self, "vScrollBar_ValueChanged")
		
		'''
		''' listbox
		'''
		listBox1 = New ListBox(75, 120, 150, 200, Self)
		listBox1.Event_SelectedIndexChanged.Add(Self, "listBox1_SelectedIndexChanged")
		For Local i = 0 until 1013
			listBox1.Items.AddLast(New ListItem("listBox1 Item " + i))
		Next
		
	End

	Method combobox_SelectedIndexChanged(sender:object, e:EventArgs)
		if comboBox.SelectedItem Then
			Self.Text = comboBox.SelectedItem.Text
		End
	End
	
	Method vScrollBar_ValueChanged(sender:object, e:EventArgs)
		Self.Text = "vScrollBar value " + vScrollBar.Value
	End
	
	Method listBox1_SelectedIndexChanged(sender:object, e:EventArgs)
		if listBox1.SelectedItem then
			Self.Text = listBox1.SelectedItem.Text
		End 
	End
	
	Method Button_Clicked(sender:Object, e:MouseEventArgs)
		Self.Text = "Button was clicked in millisecond: " + Millisecs()
		Self.Dispose()
	End
	
	Method Trackbar1_ValueChanged(sender:Object, e:EventArgs)
		Self.Text = "trackbar1 value changed: " + TrackBar(sender).Value
	End
	
	Method Trackbar2_ValueChanged(sender:Object, e:EventArgs)
		Self.Text = "trackbar2 value changed: " + TrackBar(sender).Value
	End

	Method MyForm_Moved(sender:Object, e:EventArgs)
		Self.Text = "Moved to: " + Self.Position.X + ", " + Self.Position.Y
	End
End