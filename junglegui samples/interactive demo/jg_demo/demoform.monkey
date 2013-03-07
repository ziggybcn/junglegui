Import junglegui
Import junglegui.listview


Import demos.colors
Import demos.breakout

#REFLECTION_FILTER+="demoform"

Class DemoForm Extends Form
	
	Field list:ListView

	Method OnInit()
		list = New ListView
		list.Parent = Self
		AddDemo("breackout", New BrickSample)
		AddDemo("Sliders sample", New SliderSample)
		
		Self.Size.SetValues(100, 300)
		Self.Text = "Demo selector"
		Self.Event_Resized.Add(Self, "Form_Resized")
		
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
	End
	
	Method Item_Clicked(sender:Object, e:MouseEventArgs)
		LaunchDemo
	End
End