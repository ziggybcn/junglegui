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
		if msg.sender = Self And msg.e.eventSignature = eEventKinds.CLICK And Checked = false Then Checked = true
		Super.Msg(msg)
	End
	
	
	Method Render:Void()
		Super.Render
		local points:= CalculateRenderPosition
		if GetGui.ActiveControl = Self Then
			SystemColors.FocusColor.Activate
			SetAlpha(0.1)
			DrawRect(points.X, points.Y, Size.X, Size.Y)
			SetAlpha(1)
			'DrawFocusRect(self)
		EndIf
	End
	
	Method RenderCheckBox(drawPos:GuiVector2D)
		Local yOffset:Int = Size.Y / 2 - BoxSize / 2
		if GetGui.GetMousePointedControl = Self Then
			SystemColors.FocusColor.Activate()
		else
			SystemColors.ButtonBorderColor.Activate()
		EndIf
		DrawOval(drawPos.X, drawPos.Y + yOffset, BoxSize, BoxSize)

		SystemColors.ControlFace.Activate()
		DrawOval(drawPos.X + 1, drawPos.Y + 1 + yOffset, BoxSize - 2, BoxSize - 2)
		'DrawRoundBox(int(drawPos.X), int(drawPos.Y + yOffset), BoxSize, BoxSize)
		if Checked Then
			SystemColors.FocusColor.Activate()
			DrawOval(drawPos.X + 2, drawPos.Y + 2 + yOffset, BoxSize - 4, BoxSize - 4)
		EndIf
		
	End
	Private
	Const BoxSize:Int = 10
End