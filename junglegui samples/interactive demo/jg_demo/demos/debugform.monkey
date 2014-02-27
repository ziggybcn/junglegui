
Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

Class DebugForm Extends WindowFrame

	Field msgInspector:ListBox

	Method OnInit()
		'Self.Text = "Debug form"
		Self.Size.SetValues(500, 150)
		Self.Position.SetValues(10, 300)
		Self.Event_ParentResized.Add(Self, "Canvas_Resized")
		Self.Event_Resized.Add(Self, "Form_Resized")
		Self.Name = "Debug_Form"
		'Self.BorderStyle = eFormBorder.FIXED
			
		msgInspector = New ListBox
		msgInspector.Parent = Self
		msgInspector.Position.SetValues(0, 0)
		msgInspector.Size.SetValues(Self.Size.X - Self.Padding.Left - Self.Padding.Right - msgInspector.Position.X + 2, Self.Size.Y - Self.Padding.Top - Self.Padding.Bottom)
		msgInspector.Items.AddLast(New ListItem("Ready!"))
		msgInspector.Name = "Events_List"


		Self.Event_ParentResized.Add(Self, "Parent_Resized")
		LocateMe()

		'We add an event listener, any lowlevel event handled by the Gui system will be notified:
		Self.GetGui.Event_Msg.Add(Self, "Event_Fired")

	End

	Method ShowDebugMsg(msg:BoxedMsg)
		if msg.e.messageSignature = eMsgKinds.MOUSE_MOVE Then Return
		if msg.e.messageSignature = eMsgKinds.PARENT_RESIZED Then return
		If msg.sender <> msgInspector and msgInspector <> Null and msg.sender <> Self Then
			if msgInspector.Items.EstimatedCount > 1000 Then msgInspector.Items.RemoveFirst()
			Local name:String = "<no name>"
			If Control(msg.sender) <> Null Then
				name = Control(msg.sender).Name
				If name = "" Then name = "<no name>"
			EndIf
			msgInspector.Items.AddLast(name + " Msg " + msg.e.GetEventName())
			msgInspector.SelectedIndex = msgInspector.Items.EstimatedCount - 1
			msgInspector.ScrollSelectedItem()
		EndIf
	End
	
	Method Event_Fired(sender:Object, e:EventArgs)
		Local msg:= New BoxedMsg(sender, e)
		ShowDebugMsg(msg)
	End
	
	Method Canvas_Resized(sender:Object, e:EventArgs)
		If Self.Position.X > GetGui.DeviceToGuiX(DeviceWidth) - Self.Size.X - 10 Then Self.Position.X = GetGui.DeviceToGuiX(DeviceWidth) - Self.Size.X - 10
		If Self.Position.Y > GetGui.DeviceToGuiY(DeviceHeight) - Self.Size.Y - 10 Then Self.Position.Y = GetGui.DeviceToGuiY(DeviceHeight) - Self.Size.Y - 10
		
		'if Self.Position.X > DeviceWidth - Self.Size.X - 10 Then Self.Position.X = DeviceWidth - Self.Size.X - 10
		'if Self.Position.Y > DeviceHeight - Self.Size.Y - 10 Then Self.Position.Y = DeviceHeight - Self.Size.Y - 10
	End
	
	Method Form_Resized(sender:Object, e:EventArgs)
		Self.msgInspector.Size.SetValues(Self.GetClientAreaSize.X, Self.GetClientAreaSize.Y)
	End
	
	Method Parent_Resized(sender:Object, e:EventArgs)
		LocateMe()
	End
	
	Method LocateMe()
		Self.Position.Y = GetGui.DeviceToGuiY(DeviceHeight) - Self.Size.Y
		Self.Size.X = GetGui.DeviceToGuiX(DeviceWidth)
		Self.Position.X = 0
		
	End
End
