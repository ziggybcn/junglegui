import junglegui
Class BoxedMsg
	Method New(sender:Object, e:EventArgs)
		Self.sender = sender
		Self.e = e
		Self.status = eMsgStatus.Sent
	End
	Field e:EventArgs
	Field sender:Object
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