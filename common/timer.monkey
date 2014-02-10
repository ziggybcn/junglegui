#rem monkeydoc Module junglegui.timer
	This is a Timer-like control
#END
'Private
Import junglegui
#REFLECTION_FILTER+="${MODPATH}"
'Public
#rem monkeydoc
	This is a frame-based Timer component, that works attached to a given ControlContainer.
	The fact that this timer works attached (is a child of) a control container brings it some useful functionality:
+ The timer will only fire events when its container is visible, active and visually accesible
+ The timer will stay idle if its container is hidden, so it won't consume resources.
	
#END
Class Timer extends Control

	#rem monkeydoc
		*IMPORTANT* This method is internally used by the Gui engine and should not be directly called.
	#END
	Method Update()
		_count+=1
		if _count>= _interval Then
			Msg(New BoxedMsg(Self, New EventArgs(eMsgKinds.TIMER_TICK)))
			_count = 0 
		EndIf
		Super.Update()
	End
	
	#rem monkeydoc
		*IMPORTANT* This method is internally used by the Gui engine and should not be directly called.
	#END
	Method Dispatch(msg:BoxedMsg)
		Super.Dispatch(msg)
		Select msg.e.messageSignature
			Case eMsgKinds.TIMER_TICK
			_timerTick.RaiseEvent(msg.sender, msg.e)
		End
	End
	
	#rem monkeydoc
		This event will be fired whenever the Timer interval has been raised.
		Notice that any Timer control will only fire events if its container is visible, active and on screen.
	#END
	Method Event_TimerTick:EventHandler<EventArgs>() Property; Return _timerTick; End
	
	#rem monkeydoc
		This method is inherited from [[Control]] and has no functionality on a [[Timer]]. Timers are never rendered as they do not have any graphical interface.
	#END
	Method Render:void()
		'note:TODO:We should be able to get rid of this by preventing the Render to be called on any control that does not have a Graphical Interface.
	End

	#rem monkeydoc
		Timers do not have any graphical interface. This method will always return False on a [[Timer]].
	#END
	Method HasGraphicalInterface:Bool() Property
		Return false
	End
	#rem monkeydoc
		This property contains the interval (in frames) between TimerTick events.
	#END
	Method Interval:Int() Property
		Return _interval
	End
	
	#rem monkeydoc
		This property can be used to set the minimum interval (in frames) between TimerTick events.
	#END
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
