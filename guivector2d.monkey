#rem monkeydoc Module junglegui.guivector2d
	This module contains the GuiVector2D implementation.
#end
Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

#rem monkeydoc
	This is a very basic 2D integer vector used for Control metrics on JungleGui
 #END
Class GuiVector2D
	#rem monkeydoc
		This property represents the X value of this vector
	 #END
	Method X:Int() property
		Return _x
	End
	Method X:Void(value:Int) Property
		If value = _x Then Return
		_x = value
		PositionChanged()
	End
	
	#rem monkeydoc
		This property represents the Y value of this vector
	 #END
	Method Y:Int() property
		Return _y
	End
	Method Y:Void(value:Int) Property
		If _y = value Then Return
		_y = value
		PositionChanged()
	End
	
	#rem monkeydoc
		This method allows you to set the X and Y values of this vector in one single call
	 #END
	Method SetValues:Void(x:Int, y:Int)
		If _x = x And _y = y Then Return
		_x = x
		_y = y
		PositionChanged()
	End
	
	#Rem monkeydoc
		This method returns a new GuiVector2D with the same X and Y values
	 #END
	Method Clone:GuiVector2D()
		Local vector:= New GuiVector2D
		CloneHere(vector)
		Return vector
	End
	
	#rem monkeydoc
		This method will copy the X and Y values to the given 2D Vector
	 #END
	Method CloneHere:Void(target:GuiVector2D)
		target.SetValues(X, Y)
	End

	Private
	Field _x:Int, _y:Int

	Method PositionChanged()
		'Do nothing on the non event driven class.
	End

End


#rem monkeydoc
	This is a basic 2D vector used to store an integer 2D position.
	This diferes from the official [[Guivector2d]] in that this one provides a callback mechanism internally used by JungleGui.
#END
Class ControlGuiVector2D Extends GuiVector2D
	#rem monkeydoc
		Internal constructor used in junguigui.core.<br>This constructor calls the internal SetNotifyControl in order to let this vector notify its control "parent" of its status changes.
		for regular usage of a GuiVector, you can ignore this constructor and use regular New()
	#END
	Method New(notifyControl:Control, messageSignature:Int)
		SetNotifyControl(notifyControl, messageSignature)
	End
	#rem monkeydoc
		<b>Internal method used by Control.</b><br>Don't use unless you know what you're doing.
	#END
	Method SetNotifyControl(control:Control, messageSignature:Int)
		_notifyControl = control
		_eventSignature = messageSignature
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