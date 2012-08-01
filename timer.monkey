Import junglegui
Class Timer extends Control

	Method Update()
		_count+=1
		if _count>= _interval Then
			Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.TIMER_TICK)))
			_count = 0 
		EndIf
		Super.Update()
	End
	
	Method Dispatch(msg:BoxedMsg)
		Super.Dispatch(msg)
		Select msg.e.eventSignature
			Case eMsgKinds.TIMER_TICK
			_timerTick.RaiseEvent(msg.sender, msg.e)
		End
	End
	
	Method Event_TimerTick:EventHandler<EventArgs>() Property; Return _timerTick; End
	
	Method Render:void()

	End

	Method HasGraphicalInterface:Bool() Property
		Return false
	End
	
	Method Interval:Int() Property
		Return _interval
	End
	
	Method Interval:Void(value:Int) Property
		if value<0 Then value = 0
		_interval = value
	End
	
	Method New()
		Size.X = 0
		Size.Y = 0
		Position.SetValues(64000,64000)
	End
	Private
	Field _timerTick:= New EventHandler<EventArgs>
	Field _count:Int = 0
	Field _interval:Int = 100
End