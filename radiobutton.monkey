#rem monkeydoc Module junglegui.radiobutton
	This module contains the implementation of a [[classical RadioButton]]
#END


Import junglegui 
#rem monkeydoc
	This Control is a classical RadioButton with a radial selectable option.
	When you place several radio buttons on a single container, they will automatically auto-toggñe selection and, when one is selected, the others won't, so a single option is selected at a time.	
#END
Class RadioButton Extends CheckBox
#rem monkeydoc
	This boolean property indicates if the [[RadioButton]] is checked or not.
#END
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
		
		Local drawPos:= UnsafeRenderPosition()

		If Not Transparent Then GetGui.Renderer.DrawControlBackground(Status, drawPos, Size, Self)

		GetGui.Renderer.DrawRadioCheckBox(Status, drawPos, Size, Self, Checked)
		Local offset:Int = GetGui.Renderer.RadioBoxSize.X
		drawPos.X += offset
		GetGui.Renderer.DrawLabelText(Status, drawPos, Size, Text, eTextAlign.LEFT, Self.Font, Self)
		drawPos.X -= offset
	End
 	
	#rem monkeydoc
		This method internally handles the radio button rendering.
	#END
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