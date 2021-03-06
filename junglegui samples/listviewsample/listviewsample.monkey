Import junglegui
Import junglegui.listview
#REFLECTION_FILTER+="${MODPATH}"


#GLFW_WINDOW_RESIZABLE=true
#GLFW_WINDOW_TITLE="Jungle Gui Sample"


Function Main()
	New Demo
End

Class Demo Extends App
	Field gui:Gui
	Field form:MyApp
	Field frame:Int = 0
	Method OnCreate()
		SetUpdateRate(60)
		gui = New Gui
		form = New MyApp
		form.InitForm(gui)
	End
	
	Method OnUpdate()
		gui.Update()
		frame += 1
	End
	
	Method OnRender()
		gui.Render()
	End
End

 
Class MyApp Extends WindowFrame

	Field list:ListView
	
	Field commands:Panel

	Field butOk:Button
	
	Field debug:Bool = False
	
	Global iconImage:Image
	
	Method OnInit()
	
		'''
		''' MyApp
		'''		
		Self.Event_ParentResized.Add(Self, "MyApp_ParentResized")
		Self.Position.SetValues(0, 0)
		Self.Size.SetValues(DeviceWidth, DeviceHeight)
		Self.Event_Resized.Add(Self, "MyApp_Resized")
		Self.Name = "MyApp"

		'''
		''' iconImage
		'''
		If iconImage = Null Then iconImage = LoadImage("icon.png")

		'''
		''' list
		'''
		list = New ListView(0, 0, Self.GetClientAreaSize.X, Self.GetClientAreaSize.Y, Self)
		list.BackgroundColor = SystemColors.WindowColor
		For Local i:Int = 0 To 100
			Local item:= New ModuleListItem 'DefaultListViewItem("Item " + i, iconImage)
			item.Text = "" '"Item " + i
			item.Name = "item" + i			
			list.Items.AddLast(item)
		Next
		list.Event_SelectedIndexChanged.Add(Self, "list_SelectionChanged")
		list.Name = "list"
		list.ItemHeight = 20
		list.ItemWidth = 200
		
		'''
		''' commands
		'''		
		commands = New Panel
		commands.Parent = Self
		commands.Size.SetValues(GetClientAreaSize.X, 10)
		commands.BackgroundColor = SystemColors.WindowColor
		commands.BorderColor = commands.BackgroundColor
		commands.Event_Resized.Add(Self, "Commands_Resized")
		commands.Name = "commands"

		'''
		''' butOk
		'''
		butOk = New Button(commands, 0, 0, "Ok", 100, 30)
		butOk.Name = "butOk"
		
		'We force a layout calculation:
		Self.Event_Resized.RaiseEvent(Self, New EventArgs)
	End
	
	Method Msg(msg:BoxedMsg)
		Super.Msg(msg)
		
		'Just used for debug purposes. 
		If Not debug Return
		Local details:= GetClass(msg.sender)
		Local additional:String
		If details <> Null Then
			additional = details.Name
		EndIf
		If Control(msg.sender) <> Null Then
			additional = Control(msg.sender).Name() + "(" + additional + ")"
		EndIf
		Print additional + " " + msg.e.GetEventName()
	End
	
	Method MyApp_ParentResized(sender:Object, e:EventArgs)
		Self.Size.SetValues(DeviceWidth, DeviceHeight)
		Self.Position.SetValues(0, 0)
	End
	
	Method MyApp_Resized(sender:Object, e:EventArgs)
		commands.Size.X = Self.GetClientAreaSize.X
		commands.Size.Y = 50
		commands.Position.Y = Self.GetClientAreaSize.Y - commands.Size.Y
		list.Size.SetValues(Self.GetClientAreaSize.X, Self.GetClientAreaSize.Y - commands.Size.Y)
		list.ItemHeight = 55
		list.ItemWidth = list.GetClientAreaSize.X - list.ItemSpacing.X * 2
		list.ItemSpacing.Y = 5
		
	End

	Method Commands_Resized(sender:Object, e:EventArgs)
		butOk.Position.X = commands.GetClientAreaSize.X - butOk.Size.X - 10
		butOk.Position.Y = 10
	End
	
	Method list_SelectionChanged(sender:Object, e:EventArgs)
		butOk.Text = "Selected: " + list.SelectedIndex
	End
End

Class ModuleListItem Extends DefaultListViewItem
	Field lblName:Label
	Field installedVers:Label
	Field availableVers:Label
	
	Method OnInit()
		
		lblName = New Label
		lblName.Text = "Module name"
		lblName.Parent = Self
		lblName.AdjustSize()
		lblName.Position.SetValues(0, 0)
		lblName.Transparent = False
		
		Self.Padding.Top = 1
		Self.Padding.Left = 1
		Self.Padding.Right = 1
		Self.Padding.Bottom = 1
		
	End
	
End