'This is a very small minimal sample

Import junglegui
Import trans 

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
	Field listView1:ListView
	Field img2:Image 
	
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
		
		'''
		''' comboBox
		'''
		comboBox = new ComboBox(self, 150, 10, 130)
		For Local i = 0 until 20
			comboBox.Items.AddLast(New ListItem("comboBox Item " + i))
		Next
		comboBox.Event_SelectedIndexChanged.Add(Self, "combobox_SelectedIndexChanged")
		
		
		Local label:= new Label()
		label.Position.SetValues( 10,50)
		label.Parent = Self  
		label.Text = "Item Size: "
		'''
		''' trackbar
		'''
		local trackbar:= New TrackBar
		trackbar.Parent = Self
		trackbar.Position.SetValues(10, 70)
		trackbar.Event_ValueChanged.Add(Self, "Trackbar1_ValueChanged")
		trackbar.Minimum = 48
		trackbar.Maximum = 256
		trackbar.Tickfrequency = 4
		
		
		label= new Label()
		label.Position.SetValues( 230,50)
		label.Parent = Self  
		label.Text = "Item Spacing: "
		
		'''
		''' trackbar
		'''
		trackbar = New TrackBar
		trackbar.Parent = Self
		trackbar.Position.SetValues(230, 70)
		trackbar.Minimum = 2
		trackbar.Maximum = 64
		trackbar.Tickfrequency = 2
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
		''' listView1
		'''
		
		Local items:= LoadImage("icons.png")
		Local img1:= LoadImage("icon1.png")
		img2 = LoadImage("icon2.png")
		
		listView1 = New ListView(10, 120, 400, 200, Self)
		listView1.Items.AddLast( New ListViewItem( "Wall", img1 )) 
		listView1.Items.AddLast( New ListViewItem( "Chain Link", img2 )) 
		listView1.Items.AddLast( New ListViewItem( "Airstrip", img1 )) 
		listView1.Items.AddLast( New ListViewItem( "APC", img2 )) 
		listView1.Items.AddLast( New ListViewItem( "Artillery", img1 )) 
		listView1.Items.AddLast( New ListViewItem( "Nuclear Strike", img2 )) 
		listView1.Items.AddLast( New ListViewItem( "Advanced Guard", img1 )) 
		listView1.Items.AddLast( New ListViewItem( "NOD Buggy", img2 )) 
		
		listView1.Event_ItemAdded.Add(Self, "listView1_ItemAdded" )
		listView1.Event_ItemRemoved.Add(Self, "listView1_ItemRemoved" )
	End

	Method listView1_ItemAdded(sender:object, e:EventArgs)
		Print "listView1_ItemAdded"
	End
	
	Method listView1_ItemRemoved(sender:object, e:EventArgs)
		Print "listView1_ItemRemoved"
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
		listView1.Items.AddLast( New ListViewItem( "Item " + int(Rnd(0,100)), img2 )) 
	End
	
	Method Trackbar1_ValueChanged(sender:Object, e:EventArgs)
		Self.Text = "trackbar1 value changed: " + TrackBar(sender).Value
		listView1.SetItemSize(TrackBar(sender).Value,TrackBar(sender).Value )
	End
	
	Method Trackbar2_ValueChanged(sender:Object, e:EventArgs)
		Self.Text = "trackbar2 value changed: " + TrackBar(sender).Value
		listView1.SetItemSpacing(TrackBar(sender).Value,TrackBar(sender).Value)
	End

	Method MyForm_Moved(sender:Object, e:EventArgs)
		Self.Text = "Moved to: " + Self.Position.X + ", " + Self.Position.Y
	End
End