Import junglegui
Class CheckBox extends BaseLabel

	Method Render:Void()
		Local drawPos:= CalculateRenderPosition()
		if Not _transparent then
			BackgroundColor.Activate()
			DrawRect(drawPos.X, drawPos.Y, Size.X, Size.Y)
		endif
		RenderCheckBox(drawPos)
		ForeColor.Activate()
		Font.DrawText(self.Text, drawPos.X + BoxSize, drawPos.Y + Size.Y / 2 - Font.GetTxtHeight(Text) / 2)
	End

	Method Transparent:Bool() property
		Return _transparent
	End
	
	Method Transparent:Void(value:Bool) Property
		_transparent = value
	End
	
	Method RenderCheckBox(drawPos:GuiVector2D)
		SystemColors.ControlFace.Activate()
		Local yOffset:Int = Size.Y / 2 - BoxSize / 2
		DrawRect(drawPos.X + 1, drawPos.Y + 1 + yOffset, BoxSize - 2, BoxSize - 2)
		if GetGui.GetMousePointedControl = Self Then
			SystemColors.FocusColor.Activate()
		else
			SystemColors.ButtonBorderColor.Activate()
		EndIf
		DrawRoundBox(int(drawPos.X), int(drawPos.Y + yOffset), BoxSize, BoxSize)
		if Checked Then
			SystemColors.AppWorkspace.Activate()
			DrawRect(drawPos.X + 4, drawPos.Y + 4 + yOffset, BoxSize - 9, BoxSize - 8)
		EndIf
		
	End
	
	Method AdjustSize:GuiVector2D()
		Local size:GuiVector2D = New GuiVector2D
		size.X = Font.GetTxtWidth(Text) + 20
		size.Y = Font.GetFontHeight() 
		Self.Size.SetValues(size.X, size.Y)
		Return Self.Size
	End
	
	Method Checked:Bool() property
		Return _checked
	End
	
	Method Checked:Void(value:Bool) Property
		if _checked <> value then
			_checked = value
			Msg(New MsgBox(Self, eEventKinds.CHECKED_CHANGED))
		endif
	End
	
	Method Dispatch(msg:MsgBox)
		Select msg.e.eventSignature
			Case eEventKinds.CHECKED_CHANGED
				_checkedChanged.RaiseEvent(msg.sender, msg.e)
		End
		Super.Dispatch(msg)
	End
	
	Method Event_CheckedChanged:EventHandler<EventArgs>(); return _checkedChanged; End
	
	Private
	Field _checkedChanged:EventHandler<EventArgs>
	
	Field _checked:Bool = False
	Field _transparent:Bool = true
	Const BoxSize:Int = 16
End