Import junglegui
Import reflection
#REFLECTION_FILER+="junglegui*"
#Rem
	summary: This class contains the details of an event.
#END
Class EventArgs Implements CallInfo
	#Rem
		summary: This field contains the message signature that caused the event.
		This integer contains one of the values enumerated as consts in the eMsgKinds class, and they identify the kind of message generated the Event, when the event is caused by a low level Msg.
	#END
	Field messageSignature:Int
	Method New(signature:Int)
		messageSignature = signature
	End
	
	#Rem
		summary: This method returns a string representation of the current event.
	#END
	Method GetEventName:String()
		Local classInfo:= GetClass("junglegui.eventargs.eMsgKinds")
		if classInfo = null Then Return "unknown class info. Can't get event name."
		local constInfo:= classInfo.GetConsts(True)
		For Local CI:ConstInfo = EachIn constInfo
			if UnboxInt(CI.GetValue) = self.messageSignature Then
				Return CI.Name
			endif
		next
		Return "unknown event"
	End

	#Rem
		summary: This method returns the expected signature of its delegates. That's internaly used to inform during runtime of wrong conformed callbaks.
	#END
	Method SignatureDescription:String()
		Return "(sender:Object, e:EventArgs)"
	End
End

'summary: This class represents a Mouse event arguments structure.
Class MouseEventArgs Extends EventArgs
	#Rem
		summary: This field contains the location (relative to the control coordinates) where the event has been fired. 
		As an example, if this MouseEventArgs is part of a "Click" event, it will contain the X and Y corrdinates where the mouse or touch was performed on the sender control.
	#END
	Field position:GuiVector2D

	#Rem
		summary: This field contains the number of clicks that have been included in the event, when the event is fired as a resoult of a click or touch operation.
	#END
	Field clicks:Int = 0
	'summary: This is the MouseEventArgs constructor. Each parameter is set to the corresponding field.
	Method New(signature:Int, position:GuiVector2D, clicks:Int)
		messageSignature = signature
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

'summary: This class represents a Key event arguments structure.
Class KeyEventArgs Extends EventArgs
	'summary: This is the key involved in the event.
	Field key:int
	Method New(signature:Int, key:int)
		messageSignature = signature
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

	'summary: This identifies a non Msg based event. All highlevel events that are not the result of a internal Msg Dispatch have this value as their EventSignature.
	Const EMPTYMSG:Int = 0

	'summary: Control Position X and/or Y position values have been changed.
	Const MOVED:Int = 1

	'summary: Control Parent has been removed. Control has been removed from its parent.	
	Const PARENT_REMOVED:Int = 2
	'summary: Control Parent has been set. This control is contained in another control.
	
	'summary: Control Parent has been set. This control is contained in another control.
	Const PARENT_SET:Int = 3

	'summary: Control has been brought to the front on the z-order.
	Const BRING_TO_FRONT:Int = 4
	
	'summary: Control has been sent to the back of the z-order.
	Const SEND_TO_BACK:Int = 5
	
	'summary: Mouse has entered the control area on the canvas.
	Const MOUSE_ENTER:Int = 6
		
	'summary: Mouse has leaved the control area on the canvas.
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
	
	'----> summary: Control Padding has been modified. Not yet implemented. will fix!
	Const PADDING_MODIFIED:Int = 16
	
	#Rem
		summary: Control Parent has been resized.
		When this Msg signature is sent to a TopLevelControl, it means that the device canvas has been resized.
	#END
	Const PARENT_RESIZED:Int = 17
	
	'summary: Control has been resized.
	Const RESIZED:Int = 18
	
	'summary: Mouse has been moved over the control.
	Const MOUSE_MOVE:Int = 19

	'summary: This event is raised whenever a TopLevelControl is initialized. Used on low level operations mainly.
	'The internal Form or WindowFrame classes initializes most of its internal sub-components here, such as the control box to be closeable.
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
	
	'summary: This msg indicates that a renderer is attached to a Gui instance
	Const RENDERER_ATTACHED:Int = 27
	
	'summary: This msg indicates that a renderer is detached to a Gui instance
	Const RENDERER_DETACHED:Int = 28
	
End

#Rem
	summary: This is the interface used by any Event structure that provides proper signature information on runtime. Internaly used by EventArgs and its extended classes to provide runtime debug information when dealing with events.
#END
Interface CallInfo
	'summary: That's the method that any EventDelegate providing implements in order to provide runtime information about its callback signature.
	Method SignatureDescription:String()
End