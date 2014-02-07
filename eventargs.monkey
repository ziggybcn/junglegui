#Rem monkeydoc Module junglegui.eventargs
	 This module contains most event arguments classes.
#END

Import junglegui
Import reflection
Import guivector2d
#REFLECTION_FILER+="junglegui*"
#Rem monkeydoc
	 This class contains the details of a standard event.
#END
Class EventArgs Implements CallInfo
	#Rem monkeydoc
		This field contains the message signature that caused the event.
		This integer contains one of the values enumerated as consts in the [[eMsgKinds]] class, and they identify the kind of low level message that generated the Event, when the event is caused by a low level Msg.
	#END
	Field messageSignature:Int

	#rem monkeydoc
		This is the default constructor.
	#END
	Method New(signature:Int)
		messageSignature = signature
	End
	
	#Rem monkeydoc
		This method uses reflection to return a string representation of the current event.
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

	#Rem monkeydoc
		This method returns the expected signature of any Delegate using this EventArgs class. That's internaly used to inform during runtime of wrong conformed Delegates.
	#END
	Method SignatureDescription:String()
		Return "(sender:Object, e:EventArgs)"
	End
End

#rem monkeydoc
	This class represents a Mouse event arguments structure.
 #END
Class MouseEventArgs Extends EventArgs
	#Rem monkeydoc
		This field contains the location (relative to the control coordinates) where the event has been fired. 
		As an example, if this MouseEventArgs is part of a "Click" event, it will contain the X and Y corrdinates where the mouse or touch was performed on the sender control.
	#END
	Field position:GuiVector2D

	#Rem monkeydoc
		This field contains the number of clicks that have been included in the event, when the event is fired as a resoult of a click or touch operation.
	#END
	Field clicks:Int = 0
	#rem monkeydoc
		This is the MouseEventArgs constructor. Each parameter is set to the corresponding field.
	#END
	Method New(signature:Int, position:GuiVector2D, clicks:Int)
		messageSignature = signature
		Self.position = position
		Self.clicks = clicks
	End
	
	#Rem monkeydoc
		This method uses reflection to return a string representation of the current event, including mouse details.
	#END
	Method GetEventName:String()
		Local result:= super.GetEventName() + ", Position  = (" + position.X + ", " + position.Y + "), Clicks: " + clicks
		Return result
	End
	#rem monkeydoc
		This method returns the expected signature of any Delegate using this EventArgs class. That's internaly used to inform during runtime of wrong conformed Delegates.		
	#END
	Method SignatureDescription:String()
		Return "(sender:Object, e:MouseEventArgs)"
	End
	
End

#rem monkeydoc
	This class represents a initialize application event arguments structure.
	This is usefull when the whole App is built using the [[JungleGuiApp]] system.
#END
Class InitializeAppEvent Extends EventArgs
	#rem monkeydoc
		This field has to be set to contain the JungleGuiApp main TopLevelControl.
	#END
	Field mainForm:TopLevelControl

	'Method GetEventName:String()
	'	Local result:= Super.GetEventName() '+ ", Position  = (" + position.X + ", " + position.Y + "), Clicks: " + clicks
	'	Return result
	'End
	#rem monkeydoc
		This method returns the expected signature of any Delegate using this EventArgs class. That's internaly used to inform during runtime of wrong conformed Delegates.		
	#END
	Method SignatureDescription:String()
		Return "(sender:Object, e:InitializeAppEvent)"
	End

End


#rem monkeydoc
	This class represents a Key event arguments structure.
 #END
Class KeyEventArgs Extends EventArgs
	#rem monkeydoc
		This is the key code of the key involved in the event.
	 #END
	Field key:int
	#rem monkeydoc
		This is the default KeyEventArgs constructor
	 #END
	Method New(signature:Int, key:int)
		messageSignature = signature
		self.key = key
		
	End
	#Rem monkeydoc
		This method uses reflection to return a string representation of the current event, including key related details.
	#END
	Method GetEventName:String()
		Return Super.GetEventName + ", Key code = " + key
	End
	#rem monkeydoc
		This method returns the expected signature of any Delegate using this EventArgs class. That's internaly used to inform during runtime of wrong conformed Delegates.		
	#END
	Method SignatureDescription:String()
		Return "(sender:Object, e:KeyEventArgs)"
	End
End

#rem monkeydoc
	This class is a enumerator-like class that contains all event kind constants.
 #END
Class eMsgKinds Abstract

	#rem monkeydoc
		This identifies a non Msg based event. All highlevel events that are not the result of a internal Msg Dispatch have this value as their EventSignature.
	#END
	Const EMPTYMSG:Int = 0

	#rem monkeydoc
		 Control Position X and/or Y position values have been changed.
	 #END
	Const MOVED:Int = 1

	#rem monkeydoc
		 Control Parent has been removed. Control has been removed from its parent.	
	 #END
	Const PARENT_REMOVED:Int = 2
	
	#rem monkeydoc
		 Control Parent has been set. This control is contained in another control.
	 #END
	Const PARENT_SET:Int = 3

	#rem monkeydoc
		 Control has been brought to the front on the z-order.
	 #END
	Const BRING_TO_FRONT:Int = 4
	
	#rem monkeydoc
		 Control has been sent to the back of the z-order.
	 #END
	Const SEND_TO_BACK:Int = 5
	
	#rem monkeydoc
		 Mouse has entered the control area on the canvas.
	 #END
	Const MOUSE_ENTER:Int = 6
		
	#rem monkeydoc
		 Mouse has leaved the control area on the canvas.
	 #END
	Const MOUSE_LEAVE:Int = 7
	
	#rem monkeydoc
		 Control has lost focs.
	 #END
	Const LOST_FOCUS:Int = 8
	
	#rem monkeydoc
		 Control has got focs.
	 #END
	Const GOT_FOCUS:Int = 9
	
	#rem monkeydoc
		 Control has got a Mouse Down event.
	 #END
	Const MOUSE_DOWN:Int = 10
	
	#rem monkeydoc
		 Control has got a Mouse Up event.
	 #END
	Const MOUSE_UP:Int = 11
	
	#rem monkeydoc
		Control has been clicked.
	#END
	Const CLICK:Int = 12
	
	#rem monkeydoc
		Control has got a Key Down event.
	#END
	Const KEY_DOWN:Int = 13
	
	#rem monkeydoc
		Control has got a Key Up event.
	#END
	Const KEY_UP:Int = 14
	
	#rem monkeydoc
		Control has got a Key Press event.
	#END
	Const KEY_PRESS:Int = 15
	
	'----> summary: Control Padding has been modified. Not yet implemented. will fix!
	Const PADDING_MODIFIED:Int = 16
	
	#rem monkeydoc
		Control Parent has been resized.
		When this Msg signature is sent to a TopLevelControl, it means that the device canvas has been resized.
	#END
	Const PARENT_RESIZED:Int = 17
	
	#rem monkeydoc
		Control has been resized.
	#END
	Const RESIZED:Int = 18
	
	#rem monkeydoc
		Mouse has been moved over the control.
	 #END
	Const MOUSE_MOVE:Int = 19

	#rem monkeydoc
		This event is raised whenever a TopLevelControl is initialized. Used on low level operations mainly.
		The internal Form or WindowFrame classes initializes most of its internal sub-components here, such as the control box to be closeable.
	#END
	Const INIT_FORM:Int = 20	
	
	#rem monkeydoc
		This msg indicates that a Timer has raised its tick
	 #END
	Const TIMER_TICK:Int = 21
	
	#rem monkeydoc
		This msg indicates that a control has changed its visible status.
	 #END
	Const VISIBLE_CHANGED:Int = 22
	
	#rem monkeydoc
		This msg indicates that a control has changed its checked status.
	 #END
	Const CHECKED_CHANGED:Int = 23
	
	#rem monkeydoc
		This msg indicates that a control has changed its text.
	 #END
	Const TEXT_CHANGED:Int = 24
	
	#rem monkeydoc
		This msg indicates that a sliding control has changed its value.
	 #END
	Const SLIDING_VALUE_CHANGED:Int = 25
	
	#rem monkeydoc
		 This msg indicates that a sliding control has changed its maximum allowed value.
	 #END
	Const SLIDING_MAXIMUM_CHANGED:Int = 26
	
	#rem monkeydoc
		 This msg indicates that a renderer is attached to a Gui instance
	 #END
	Const RENDERER_ATTACHED:Int = 27
	
	#rem monkeydoc
	This msg indicates that a renderer is detached to a Gui instance
	 #end
	Const RENDERER_DETACHED:Int = 28
	
	#rem monkeydoc
		This msg indicates that a child has been removed from a container control
	#END
	Const CHILD_REMOVED:Int = 29
	
	#rem monkeydoc
		This msg indicates that a child has been added to a container control
	#END
	Const CHILD_ADDED:Int = 30
	
End

#Rem monkeydoc
	This is the interface used by any Event structure that provides proper signature information on runtime. Internaly used by EventArgs and its extended classes to provide runtime debug information when dealing with events.
#END
Interface CallInfo
	#rem monkeydoc
		That's the method that any EventDelegate providing implements in order to provide runtime information about its callback signature.
	 #END
	Method SignatureDescription:String()
End