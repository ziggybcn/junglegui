Import junglegui

Class RadioButton extends CheckBox
	Method Checked:Bool() Property
		Return Super.Checked()
	End
	Method Checked:Void(value:Bool) Property
   		if value = True and Checked = false Then
 			For Local control:= EachIn Parent.GenerateControlsList
				Local radio:= RadioButton(control)
				if radio = null Then Continue
				if radio <> Self and radio.Checked = True Then radio.Checked = false
			Next
		EndIf
		Super.Checked(value)
	End
	Method Msg(msg:BoxedMsg)
		if msg.sender = Self And msg.e.messageSignature = eMsgKinds.CLICK And Checked = false Then Checked = true
		Super.Msg(msg)
	End
	
	
	Method Render:Void()
		
		Local drawPos:= CalculateRenderPosition()

		If Not Transparent Then GetGui.Renderer.DrawControlBackground(Status, drawPos, Size, Self)

		GetGui.Renderer.DrawRadioCheckBox(Status, drawPos, Size, Self, Checked)
		drawPos.X += GetGui.Renderer.RadioBoxSize.X
		GetGui.Renderer.DrawLabelText(Status, drawPos, Size, Text, eTextAlign.LEFT, Self.Font, Self)

	End
 	
	Method RenderCheckBox(drawPos:GuiVector2D)
		Local yOffset:Int = Size.Y / 2 - GetGui.Renderer.RadioBoxSize.Y / 2
		if GetGui.GetMousePointedControl = Self Then
			SystemColors.FocusColor.Activate()
		else
			SystemColors.ButtonBorderColor.Activate()
		EndIf
		DrawOval(drawPos.X, drawPos.Y + yOffset, GetGui.Renderer.RadioBoxSize.X, GetGui.Renderer.RadioBoxSize.Y)

		SystemColors.ControlFace.Activate()
		DrawOval(drawPos.X + 1, drawPos.Y + 1 + yOffset, GetGui.Renderer.RadioBoxSize.X - 2, GetGui.Renderer.RadioBoxSize.Y - 2)
		'DrawRoundBox(int(drawPos.X), int(drawPos.Y + yOffset), BoxSize, BoxSize)
		if Checked Then
			SystemColors.FocusColor.Activate()
			DrawOval(drawPos.X + 2, drawPos.Y + 2 + yOffset, GetGui.Renderer.RadioBoxSize.X - 4, GetGui.Renderer.RadioBoxSize.Y - 4)
		EndIf
		
	End
End