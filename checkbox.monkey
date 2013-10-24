Import junglegui

#Rem
	summary: This control is a checkbox. It's useful to represent a GUI element that can have a checked/unchecked status.
#END
Class CheckBox Extends BaseLabel
 
	Method Render:Void()
		Local drawPos:= Self.UnsafeRenderPosition()

		If Not _transparent Then GetGui.Renderer.DrawControlBackground(Status, drawPos, Size, Self)

		GetGui.Renderer.DrawCheckBox(Status, drawPos, Size, Self, Checked)
		Local offset:Int = GetGui.Renderer.CheckBoxSize.X
		drawPos.X += offset
		GetGui.Renderer.DrawLabelText(Status, drawPos, Size, Text, eTextAlign.LEFT, Self.Font, Self)
		drawPos.X -= offset
	End

	'summary: Set this property to true/false in order to make the checkbox background transparent.
	Method Transparent:Bool() property
		Return _transparent
	End
	
	Method Transparent:Void(value:Bool) Property
		_transparent = value
	End

	Method AdjustSize:GuiVector2D()
		'Local size:GuiVector2D = New GuiVector2D
		'size.X = Font.GetTxtWidth(Text) + 20
		'size.Y = Font.GetFontHeight() 
		Self.Size.SetValues(Font.GetTxtWidth(Text) + 20, Font.GetFontHeight())
		Return Self.Size
	End
	
	'summart: Set this property to true/false to determine the status of the checkbox
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
		Select msg.e.messageSignature
			Case eMsgKinds.CHECKED_CHANGED
				_checkedChanged.RaiseEvent(msg.sender, msg.e)
		End
		Super.Dispatch(msg)
	End
	
	'summary: This event is fired when the Checked status of the checkbox changes.
	Method Event_CheckedChanged:EventHandler<EventArgs>() Property; return _checkedChanged; End
	
	Private
	Field _checkedChanged:= New EventHandler<EventArgs>
	
	Field _checked:Bool = False
	Field _transparent:Bool = true
End