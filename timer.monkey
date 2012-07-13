Import junglegui
Class Timer extends Control

	Method Update()
		_count+=1
		if _count>= _interval Then
			Msg(Self,New EventArgs(eEventKinds.TIMER_TICK))
			_count = 0 
		EndIf
		Super.Update()
	End
	
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
	Field _count:Int = 0
	Field _interval:Int = 100
End