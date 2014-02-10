#rem monkeydoc Module junglegui.econtrolstatus
	This module contains a representation of non-exclusive control status using the [[eControlStatus]] enum-like class.
#END
#rem monkeydoc
	This class contains a list of available control status
#END
Class eControlStatus

	#rem monkeydoc
		Represents a regular control status
	 #END
	Const NONE:Int = 0

	#rem monkeydoc
		Represents a focused status
	 #END
	Const FOCUSED:Int = 1

	#rem monkeydoc
		Represents a Focused status
	 #END
	Const HOOVER:Int = 2

	#rem monkeydoc
		Represents a disabled status
	#END
	Const DISABLED:Int = 4
	
End Class