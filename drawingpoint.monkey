Import junglegui
Class GuiVector2D
	'summary: X coordinate
	Method X:Float() property
		Return _x
	End
	Method X:Void(value:Float) Property
		_x = value
		PositionChanged()
	End
	
	'summary: Y coordinate
	Method Y:Float() property
		Return _y
	End
	Method Y:Void(value:Float) Property
		_y = value
		PositionChanged()
	End
	
	
	Method SetValues:Void(x:Float, y:Float)
		_x = x
		_y = y
		PositionChanged()
	End
	
	Method Clone:GuiVector2D()
		Local vector:=New GuiVector2D
		vector.SetValues(X,Y)
		Return vector
	End

	Private
	Field _x:Float, _y:Float

	Method PositionChanged()
		'Do nothing on the non event driven class.
	End

End

Class ControlGuiVector2D extends GuiVector2D
	Method SetNotifyControl(control:Control, eventSignature:Int)
		_notifyControl = control
		_eventSignature = eventSignature
	end
	Private 
	Field _notifyControl:Control
	Field _eventSignature:Int = eEventKinds.MOVED
	Method PositionChanged()
		if _notifyControl <> null then
			_notifyControl.Msg(New MsgBox(_notifyControl, New EventArgs(_eventSignature)))
		endif
	End
End