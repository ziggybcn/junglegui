Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

#Rem
	summary:This class contains all the required information to represent an internal low-level Msg that represents a status change on a control.
	Those Msg structures are internally used to propagate runtime status changes that can be later converted to Events on the Dispatch method of each control.
	This class acts mostly as a structure to allocate the required data. It hasn't any specific functionality other than alow the data to be kept together and to be internally sent by reference.
	
	Notice that this class is internaly used on low level operations of the Jungle Gui class. It's usage is basically used on internal Controls design.
#END
Class BoxedMsg
	'summary: This is the Msg constructor
	Method New(sender:Object, e:EventArgs)
		Self.sender = sender
		Self.e = e
		Self.status = eMsgStatus.Sent
	End
	'summary: This field that contains the arguments that will be part of any event potentially created by this Msg structure on the Dispatch method.
	Field e:EventArgs
	#Rem
		summary: This is the sender. That is, the object (usually a control) that triggers the Msg system. That is, if this Msg is later converted to an Event, it will be the Event sender.
		As instance, if this Msg structure contains the information about a control being clicked. The sender will be the control itself.
	#End
	Field sender:Object
	#Rem
		summary: This field contains the current status of the Msg.
		Msg can have several status, all of them defined in then eMsgStatus class:
		[list]
		[*]eMsgStatus.[b]Sent[/b] This means that the Msg has been sent. That is, the Msg is valid an it is likely to cause an Event being fired on the Dispatch method of its sender control.
		[*]eMsgStatus.[b]Canceled[/b] This means that the Msg has been canceled so it won't raise any event.
		[*]eMsgStatus.[b]Raised[/b] This means that the Msg has already raised an Event on the Dispatch method of its sender control.
		[/list]
	#END
	Field status:int
End

Class eMsgStatus
	'summary: The Msg has been sent as a regular low-level message:
	Const Sent:Int = 0
	
	'summary: The Msg has been canceled duting its internal validation:
	Const Canceled:Int = 1
	
	'summary: The Msg has been sent to an event pool and raised as an event.
	Const Raised:Int = 2
End