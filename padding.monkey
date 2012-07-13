Import junglegui

Class Padding
	Method Top:Int() property
		Return top
	End
	Method Top:Int(value:Int) property
		top = value
		ValuesChanged
		Return top
	End
	
	Method Left:Int() property
		Return left
	End
	Method Left:Int(value:Int) property
		left = value
		ValuesChanged
		Return left
	End

	Method Right:Int() property
		Return right
	End
	Method Right:Int(value:Int) property
		right = value
		ValuesChanged
		Return right
	End

	Method Bottom:Int() property
		Return bottom
	End
	Method Bottom:Int(value:Int) property
		bottom = value
		ValuesChanged
		Return bottom
	End
	Method SetNotifyControl(control:Control)
		_notifyControl = control
	end
	Private 
	Field _notifyControl:Control
	
	Private
	Method ValuesChanged()
		if _notifyControl <> null then 	_notifyControl.Msg(_notifyControl,New EventArgs(eEventKinds.PADDING_MODIFIED))		
	End
	Field top:int
	Field left:Int
	Field right:Int
	Field bottom:int
End


