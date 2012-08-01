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


Class ParticleType
	Field Name:String				= "Default"			
	Field LifeTime:Int				= 10000
	Field Blend = 1
	Field Rotation:Int				= 90
	Field RotationMode:Int = 0
	Field Img:Image					= Null
	Field MidHandleImage:Bool		= True
	Field HandleX:Int				= 0
	Field HandleY:Int				= 0
	Field EmissionRadius:Float 		= 0
	Field EmissionShape:Int = 0
	Field EmissionRate:Int			= 10
	Field EmissionAngle:Int			= 45
	Field EmissionChange:Int		= 0
	Field Speed:Float				= 100
	Field SpeedVar:Float			= 30
	Field SpeedChange:Float			= 0
	Field Size:Float				= 0.2
	Field SizeVar:Float				= 0.1
	Field SizeChange:Float			= 2.0
	Field SizeMax:Float				= 5.0
	Field Weight:Float				= 0
	Field WeightVar:Float			= 0
	Field StartColorR:Int			= 128
	Field StartColorG:Int			= 128
	Field StartColorB:Int			= 128
	Field EndColorR:Float			= 0	
	Field EndColorG:Float			= 0
	Field EndColorB:Float			= 0
	Field BrightnessChange:Int		= 20
	Field BrightnessVar:Int			= 10
	Field Alpha:Float				= 1.0
	Field AlphaVar:Float			= 0.2
	Field AlphaChange:Float			= 0.01
	Field AlphaDelay:Int			= 0
	Field KillOutsideScreen:Bool	= True
	Field Enabled:Bool				= True
	Field TailEmissionRate:Float	= 0.0
	Field TailEmissionChange:Float	= 0.0
	
End


Class MyForm extends Form

	Field button:Button
	Field vScrollBar:VScrollBar
	Field listBox1:PropertyGrid
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
		button.Text = "Add List Item"
		button.Parent = Self
		button.Event_Click.Add(Self, "Button_Clicked")
		button.Event_LostFocus.Add(Self, "Button_LostFocus")
		button.Event_GotFocus.Add(Self, "Button_GotFocus")
		button.Parent = null
		button.Dispose()
		
		
		'''
		''' comboBox
		'''
		comboBox = new ComboBox(self, 150, 10, 130)
		For Local i = 0 until 20
			comboBox.Items.AddLast(New ListItem("comboBox Item " + i))
		Next
		comboBox.Event_SelectedIndexChanged.Add(Self, "combobox_SelectedIndexChanged")
		
		'''
		''' trackbar
		'''
		local trackbar:= New TrackBar
		trackbar.Parent = Self
		trackbar.Position.SetValues(10, 60)
		trackbar.Event_ValueChanged.Add(Self, "Trackbar1_ValueChanged")
		trackbar.Minimum = 0
		trackbar.Maximum = 10
		trackbar.Tickfrequency = 1
		
		trackbar = New TrackBar
		trackbar.Parent = Self
		trackbar.Position.SetValues(230, 60)
		trackbar.Minimum = -100
		trackbar.Maximum = 200
		trackbar.Tickfrequency = 10
		trackbar.Event_ValueChanged.Add(Self, "Trackbar2_ValueChanged")
		
		'''
		''' vertical scrollbar
		'''
		vScrollBar = New VScrollBar()
		vScrollBar.Parent = Self
		vScrollBar.Position.SetValues(Self.Size.X - 25 - Self.Padding.Left - Self.Padding.Right, 0)
		vScrollBar.Size.SetValues(25, Size.Y - Self.Padding.Top - Self.Padding.Bottom)
		vScrollBar.Event_ValueChanged.Add(Self, "vScrollBar_ValueChanged")
		
		'''
		''' listbox
		'''
		listBox1 = New PropertyGrid(10, 120, 250, 200, Self)
		listBox1.SelectedObject = New ParticleType
		'listBox1.Event_SelectedIndexChanged.Add(Self, "listBox1_SelectedIndexChanged")
		'listBox1.Items
		'listBox1.TipText = "This is a list box."
	'	For Local i = 0 until 6
		'	listBox1.Items.AddLast(New ListItem("listBox1 Item " + i))
	'	Next
	
	
	Local lstBox:= new ListBox()
	
		
	End
	
	Method Button_LostFocus(sender:Object, e:EventArgs)
		Print "LOST"
	End
	
	Method Button_GotFocus(sender:Object, e:EventArgs)
		Print "GOT"
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
		'if listBox1.SelectedItem then
		'	Self.Text = listBox1.SelectedItem.Text
		'End 
	End
	
	Method Button_Clicked(sender:Object, e:MouseEventArgs)
		Self.Text = "Button was clicked in millisecond: " + Millisecs()
		'Self.Dispose()
		'listBox1.Items.AddLast(New ListItem("Item " + Millisecs()))
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