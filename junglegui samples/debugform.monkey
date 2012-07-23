Import particlessample

Class DebugForm extends Form
	'Field debugBox:ListBox
	Field msgInspector:ListBox
	Method OnInit()
		Self.Text = "Debug form"
		Self.Size.SetValues(500, 150)
		Self.Position.SetValues(10, 300)
		Self.Event_ParentResized.Add(Self, "Canvas_Resized")
			
		msgInspector = New ListBox
		msgInspector.Parent = Self
		msgInspector.Position.SetValues(0, 0)
		msgInspector.Size.SetValues(Self.Size.X - Self.Padding.Left - Self.Padding.Right - msgInspector.Position.X + 2, Self.Size.Y - Self.Padding.Top - Self.Padding.Bottom)
		msgInspector.Items.AddLast(New ListItem("Ready!"))

	End

	Method ShowDebugMsg(msg:BoxedMsg)
		if msg.e.eventSignature = eMsgKinds.MOUSE_MOVE Then Return
		if msg.e.eventSignature = eMsgKinds.PARENT_RESIZED Then return
		if msg.sender <> msgInspector and msgInspector <> null Then
			if msgInspector.Items.EstimatedCount > 1000 Then msgInspector.Items.RemoveFirst()
			Local name:String = "<no name>"
			if Control(msg.sender) <> null Then
				name = Control(msg.sender).Name
			EndIf
			msgInspector.Items.AddLast(name + " Msg " + msg.e.GetEventName())
			msgInspector.SelectedIndex = msgInspector.Items.EstimatedCount - 1
			msgInspector.ScrollSelectedItem()
		EndIf
	End
	
	Method Canvas_Resized(sender:Object, e:EventArgs)
		if Self.Position.X > DeviceWidth - Self.Size.X - 10 Then Self.Position.X = DeviceWidth - Self.Size.X - 10
		if Self.Position.Y > DeviceHeight - Self.Size.Y - 10 Then Self.Position.Y = DeviceHeight - Self.Size.Y - 10
	End
			
End
