Import junglegui

Class EventArgs Implements CallInfo
	Field eventSignature:Int
	Field customSignature:Int = 0
	Method New(signature:Int)
		eventSignature = signature
	End
	
	Method GetEventName:String()
		Local classInfo:= GetClass("junglegui.eventargs.eMsgKinds")
		if classInfo = null Then Return "unknown class info. Can't get event name."
		local constInfo:= classInfo.GetConsts(True)
		For Local CI:ConstInfo = EachIn constInfo
			if UnboxInt(CI.GetValue) = self.eventSignature Then
				Return CI.Name
			endif
		next
		Return "unknown event"
	End

	Method SignatureDescription:String()
		Return "(sender:Object, e:EventArgs)"
	End

End

Class MouseEventArgs extends EventArgs
	Field position:GuiVector2D 
	Field clicks:Int = 0
	Method New(signature:Int, position:GuiVector2D, clicks:Int)
		eventSignature = signature
		Self.position = position
		Self.clicks = clicks
	End
	Method GetEventName:String()
		Local result:= super.GetEventName() + ", Position  = (" + position.X + ", " + position.Y + "), Clicks: " + clicks
		Return result
	End
	Method SignatureDescription:String()
		Return "(sender:Object, e:MouseEventArgs)"
	End
	
End

Class KeyEventArgs extends EventArgs
	Field key:int
	Method New(signature:Int, key:int)
		eventSignature = signature
		self.key = key
		
	End
	Method GetEventName:String()
		Return Super.GetEventName + ", Key code = " + key
	End
	Method SignatureDescription:String()
		Return "(sender:Object, e:KeyEventArgs)"
	End
End

'summary: This class is a enumerator-like class that contains all event kind constants.
Class eMsgKinds Abstract

	Const EMPTYMSG:Int = 0

	'summary: Control Position X and/or Y position values have been changed.
	Const MOVED:Int = 1

	'summary: Control Parent has been removed. Control has been removed from its parent.	
	Const PARENT_REMOVED:Int = 2
	'summary: Control Parent has been set. This control is contained in another control.
	
	Const PARENT_SET:Int = 3
	'summary: Control has been brought to fron on the z-order.
	Const BRING_TO_FRONT:Int = 4
	
	'summary: Control has been sent to back on the z-order.
	Const SEND_TO_BACK:Int = 5
	
	'summary: Mouse has entered the control drawing area.
	Const MOUSE_ENTER:Int = 6
		
	'summary: Mouse has leaved the control drawing area.
	Const MOUSE_LEAVE:Int = 7
	
	'summary: Control has lost focs.
	Const LOST_FOCUS:Int = 8
	
	'summary: Control has got focs.
	Const GOT_FOCUS:Int = 9
	
	'summary: Control has got a Mouse Down event.
	Const MOUSE_DOWN:Int = 10
	
	'summary: Control has got a Mouse Up event.
	Const MOUSE_UP:Int = 11
	
	'summary: Control has been clicked.
	Const CLICK:Int = 12
	
	'summary: Control has got a Key Down event.
	Const KEY_DOWN:Int = 13
	
	'summary: Control has got a Key Up event.
	Const KEY_UP:Int = 14
	
	'summary: Control has got a Key Press event.
	Const KEY_PRESS:Int = 15
	
	'summary: Control Padding has been modified.
	Const PADDING_MODIFIED:Int = 16
	
	'summary: Control Parent has been resized.
	Const PARENT_RESIZED:Int = 17
	
	'summary: Control has been resized.
	Const RESIZED:Int = 18
	
	'summary: Mouse has been moved over the control.
	Const MOUSE_MOVE:Int = 19

	'summary: This event is raised whenever a form is initialized. Used on low level operations mainly.
	'The internal FORM class initializes most of its internal sub-components here, such as the control box to be closeable.
	Const INIT_FORM:Int = 20	
	
	'summary: This msg indicates that a Timer has raised its tick
	Const TIMER_TICK:Int = 21
	
	'summary: This msg indicates that a control has changed its visible status.
	Const VISIBLE_CHANGED:Int = 22
	
	'summary: This msg indicates that a control has changed its checked status.
	Const CHECKED_CHANGED:Int = 23
	
	'summary: This msg indicates that a control has changed its text.
	Const TEXT_CHANGED:Int = 24
	
	'summary: This msg indicates that a sliding control has changed its value.
	Const SLIDING_VALUE_CHANGED:Int = 25
	
	'summary: This msg indicates that a sliding control has changed its maximum allowed value.
	Const SLIDING_MAXIMUM_CHANGED:Int = 26
	
End

Interface CallInfo
	Method SignatureDescription:String()
End