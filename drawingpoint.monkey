Import junglegui
'summary: This is a basic 2D integer vector used for Control metrics on JungleGui
Class GuiVector2D
	'summary: X value of this vector
	Method X:Int() property
		Return _x
	End
	Method X:Void(value:Int) Property
		_x = value
		PositionChanged()
	End
	
	'summary: Y value of this vector
	Method Y:Int() property
		Return _y
	End
	Method Y:Void(value:Int) Property
		_y = value
		PositionChanged()
	End
	
	'summary: This method allows you to set the X and Y values of this vector in one call
	Method SetValues:Void(x:Int, y:Int)
		_x = x
		_y = y
		PositionChanged()
	End
	
	'summary: This method returns a new GuiVector2D with the same X and Y values of this one
	Method Clone:GuiVector2D()
		Local vector:=New GuiVector2D
		vector.SetValues(X,Y)
		Return vector
	End

	Private
	Field _x:Int, _y:Int

	Method PositionChanged()
		'Do nothing on the non event driven class.
	End

End

Class ControlGuiVector2D extends GuiVector2D
	'summary:<b>Internal method used by Control.</b><br>Don't use unless you know what you're doing.
	Method SetNotifyControl(control:Control, eventSignature:Int)
		_notifyControl = control
		_eventSignature = eventSignature
	end
	Private 
	Field _notifyControl:Control
	Field _eventSignature:Int = eMsgKinds.MOVED
	Method PositionChanged()
		if _notifyControl <> null then
			_notifyControl.Msg(New BoxedMsg(_notifyControl, New EventArgs(_eventSignature)))
		endif
	End
End