#Rem monkeydoc Module junglegui.guiexception
	This module contains the JungleGuiException class implementation
#END
Import junglegui
#Rem monkeydoc
	This class represents an exception thrown by JungleGui. 
	Exceptions in JungleGui implementation are not yet widely used, but the idea is to increase the usage of them.
#END
Class JungleGuiException extends Throwable
	#rem monkeydoc
		This is the default JungleGuiException constructor
	#END
	Method New(description:String, control:Control)
		Self.description = description 
		Self.control= control
		
	end
	
	#rem monkeydoc
		This method returns a string representation of the [[JungleguiException]]
	#END
	Method ToString:String()
		Return Self.description
	End
	
	#rem monkeydoc
		This method will return the Control that has raised the exception, if any. Otherwise, it'll be just Null.
	#END
	Method TargetControl:Control()
		Return control
	End
	Private
	Field description:String
	Field control:Control
End