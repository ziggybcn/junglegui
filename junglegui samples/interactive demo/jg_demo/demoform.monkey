Import junglegui
Import junglegui.listview


Import demos.colors
Import demos.breakout
Import demos.debugform
Import demos.textbox

#REFLECTION_FILTER+="demoform"

Class DemoForm Extends Form
	
	Field list:ListView

	Method OnInit()
		list = New ListView
		list.Parent = Self
		list.Name = "Demos_List"
		AddDemo("breackout", New BrickSample)
		AddDemo("Sliders sample", New SliderSample)
		AddDemo("Debug Form", New DebugForm)
		AddDemo("TextBox", New TextBoxForm)
		
		Self.Size.SetValues(190, 300)
		Self.Text = "Demo selector"
		Self.Event_Resized.Add(Self, "Form_Resized")
		Self.Name = "Demos_Form"
		
		Self.Position.X = DeviceWidth - Self.Size.X
		
		Layout()
		
	End
	
	Method Form_Resized(sender:Object, e:EventArgs)
		Layout()
	End
	
	Method Layout()
		list.Position.SetValues(0, 0)
		list.Size.SetValues(Self.GetClientAreaSize.X, Self.GetClientAreaSize.Y)
		list.ItemWidth = list.GetClientAreaSize.X - list.ItemSpacing.X * 2
		list.ItemHeight = 30
	End
	
	Method AddDemo(demoName:String, demoForm:TopLevelControl)
		Local item:= New DemoListItem
		item.Name = demoName + "_ListViewItem"
		item.Text = demoName
		list.Items.AddLast(item)
		item.demoform = demoForm
	End
End


Class DemoListItem Extends DefaultListViewItem
	Field demoform:TopLevelControl
	
	Method OnInit()
		Self.Event_Click.Add(Self, "Item_Clicked")
	End
	
	Method LaunchDemo()
		If demoform = Null Then Return
		If demoform.GetGui = Null Then
			demoform.InitForm(JungleGuiApplication.gui)
		EndIf
		'DebugStop()
		demoform.BringToFront()
		Self.GetTopLevelContainer.BringToFront()
	End
	
	Method Item_Clicked(sender:Object, e:MouseEventArgs)
		LaunchDemo
	End
End