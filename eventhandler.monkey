Import junglegui

#Rem
	summary: This is the Delegate class. This class contains a reflection-based pointer to a method of a class instance with the signature: Sender:Obect, e:T, where T is a class defined generic.
#end
Class Delegate<T>
	Private
	Field _context:Object
	Field _callInfo:MethodInfo
	Field _methodName:String
	
	#Rem
		summary: This is the Delegate constructor.
		Context: This is the an instance for the class that contains the method that will be called.
		methodName: This is the name of the method that will be called by the Call function of this Delegate.
	#END
	Method New(context:Object, methodName:String)
		local classInfo:= GetClass(context)
		If Not classInfo Then
			Throw New JungleGuiException("Event context does not exist.", Control(context))
		endif
		Local newT:= New T
		Local methodInfo:= classInfo.GetMethod(methodName,[GetClass("Object"), GetClass(newT)])
		If Not methodInfo Then

			Local exceptionText:String = ""
			if CallInfo(newT) <> null then
				exceptionText = "Could not generate an Event Callback. The Method " + methodName + CallInfo(newT).SignatureDescription + " was not found. Be sure that the method does exists on " + classInfo.Name + " and that the reflection filter is properly set."
			Else
				exceptionText = "Could not generate an Event Callback. The method " + methodName + " seems to have a bad signature or be missing. Be sure that the reflection filter is properly set."
			endif
			if Control(context) <> null And Control(context).Name <> "" Then
				exceptionText += "~n~tThe context that caused the exception is named: ~q" + Control(context).Name + "~q"
			EndIf

			Error(exceptionText)
		EndIf
		
		_callInfo = methodInfo
		_context = context
		_methodName = methodName
	End
	#Rem
		summary: This method will execute the associated Method of the context class, with the given sender and event parameters.
	#END
	Method Call(sender:Object, event:T)
		if _callInfo <> null then
			_callInfo.Invoke(_context,[sender, event])
		Else
			Throw New JungleGuiException("Requested execution of invalid delegate.", Control(sender))
		Endif
	End
End


#Rem
	summary: This class represents an EventHandler.
#END
Class EventHandler<T>
	#Rem
		summary: This method can be used to add a new Callback to this event handler. When the event is raised, all methods registered here are called.
	#END
	Method Add(context:Object, methodName:String)
		Local delegate:= New Delegate<T>(context, methodName)
		_events.AddLast(delegate)
	End
	
	#Rem
		summary: This method returns signature description for the current Event Handler.
	#END
	Method SignatureDescription:String()
		Return "(sender:Object, e:EventArgs)"
	End
	
	#Rem
		summary: This method alows a given callback to be removed from this Event Handler.
	#END
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
	
	#Rem
		summary: Use this method to raise the given event. When this is called, all the event callbacks are executed.
	#END
	Method RaiseEvent(sender:Object, e:T)
	
		#rem
		Local source:= New List<Delegate<T>>
	
		For Local del:Delegate<T> = Eachin _events
			'del.Call(sender, e)  
			source.AddLast(del)
		Next
		For Local del:Delegate<T> = EachIn source
			del.Call(sender, e)
		Next
		#end
		
		For Local del:= EachIn _events
			del.Call(sender, e)
		Next
	End
	
	#Rem
		summary: This method removes all event callbacks from this Event Handler.
	#END
	Method Clear()
		_events.Clear()
	End
	
	Private
	Field _events:= New List<Delegate<T>>
End

