Import junglegui
Class CheckBox extends BaseLabel

	Method Render:Void()
		Local drawPos:= CalculateRenderPosition()

		If Not _transparent Then GetGui.Renderer.DrawControlBackground(Status, drawPos, Size, Self)

		GetGui.Renderer.DrawCheckBox(Status, drawPos, Size, Self, BoxSize, Checked)
		drawPos.X += BoxSize
		GetGui.Renderer.DrawLabelText(Status, drawPos, Size, Text, eTextAlign.LEFT, Self.Font, Self)
	End

	Method Transparent:Bool() property
		Return _transparent
	End
	
	Method Transparent:Void(value:Bool) Property
		_transparent = value
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
			Msg(New BoxedMsg(Self, eMsgKinds.CHECKED_CHANGED))
		endif
	End
	
	Method Dispatch(msg:BoxedMsg)
		Select msg.e.eventSignature
			Case eMsgKinds.CHECKED_CHANGED
				_checkedChanged.RaiseEvent(msg.sender, msg.e)
		End
		Super.Dispatch(msg)
	End
	
	Method Event_CheckedChanged:EventHandler<EventArgs>() Property; return _checkedChanged; End
	
	Private
	Field _checkedChanged:= New EventHandler<EventArgs>
	
	Field _checked:Bool = False
	Field _transparent:Bool = true
	Const BoxSize:Int = 16
End