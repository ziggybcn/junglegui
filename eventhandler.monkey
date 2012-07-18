Import junglegui
Import reflection


Class Delegate < T >
	Private
	Field _context:Object
	Field _callInfo:MethodInfo
	Field _methodName:String
	
	Method New(context:Object, methodName:String)
		local classInfo:= GetClass(context)
		If Not classInfo Then
			Throw New JungleGuiException("Event context does not exist.", Control(context))
		endif
		Local newT:= New T
		Local methodInfo:= classInfo.GetMethod(methodName,[GetClass("Object"), GetClass(newT)])
		If Not methodInfo Then
			Local exceptionText:String =
				"Could not generate delegate with the given signature (methodname = '" + methodName + "').~n" +
				"Maybe the reflection filter is not properly set, or the Method is not properly written."
			if Control(context) <> null And Control(context).Name <> "" Then
				exceptionText += "~n~tThe context that caused the exception is named: ~q" + Control(context).Name + "~q"
			EndIf
			if CallInfo(newT) <> null then
				exceptionText += "~n~tIMPORTANT:Be sure that the Method associated with this event has the following signature:~n~t" + CallInfo(newT).SignatureDescription()
			EndIf
			Throw New JungleGuiException(exceptionText, Control(context))
		EndIf
		
		_callInfo = methodInfo
		_context = context
		_methodName = methodName
	End
	
	Method Call(sender:Object, event:T)
		if _callInfo <> null then
			_callInfo.Invoke(_context,[sender, event])
		Else
			Throw New JungleGuiException("Requested execution of invalid delegate.", Control(sender))
		Endif
	End
End

Class EventHandler < T >
	Method Add(context:Object, methodName:String)
		Local delegate:= New Delegate<T>(context, methodName)
		_events.AddLast(delegate)
	End
	
	Method SignatureDescription:String()
		Return "MethodName(sender:Object, e:EventArgs)"
	End
	
	Method Remove:Bool(context:Object, methodName:String)
		Local remover:= New List<Delegate<T>>
		For Local del:= EachIn _events
			if del._context = context And del._methodName = methodName then
				remover.AddLast(del)
			endif
		Next
		Local result:Bool = false
		For Local del:Delegate<T> = EachIn remover
			_events.Remove(del)
			result = true
		Next
		Return result
	End
	
	Method RaiseEvent(sender:Object, e:T)
	
		Local source:= New List<Delegate<T>>
	
		For Local del:Delegate<T> = Eachin _events
			'del.Call(sender, e)
			source.AddLast(del)
		Next
		For Local del:Delegate<T> = EachIn source
			del.Call(sender, e)
		Next
	End
	
	Private
	Field _events:= New List<Delegate<T>>
End

Interface CallInfo
	Method SignatureDescription:String()
End