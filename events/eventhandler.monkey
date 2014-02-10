#rem monkeydoc Module junglegui.eventhandler
	This module conains the junglegui event system.
#END
'Import reflection
'Import junglegui.guiexception
'Import junglegui.eventargs
Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

#Rem monkeydoc
	This is the Delegate class. This class contains a reflection-based pointer to a method of a class instance with the signature: Sender:Obect, e:T, where T is a class defined generic.
#end
Class Delegate<T>
	Private
	Field _context:Object
	Field _callInfo:MethodInfo
	Field _methodName:String
	Public
	#Rem monkeydoc
		This is the Delegate constructor.
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
	#Rem monkeydoc
		This method will invoke the pointed Method (using the context instance of the class). This invoke operation will be dobe with the given <i>sender</i> and <i>event</i> parameters.
	#END
	Method Invoke(sender:Object, event:T)
		if _callInfo <> null then
			_callInfo.Invoke(_context,[sender, event])
		Else
			Throw New JungleGuiException("Requested execution of invalid delegate.", Control(sender))
		Endif
	End
End


#Rem monkeydoc
	This class represents an EventHandler. 
	An EventHandler is a structure that contains a collection of Delegates that can be invoked when a specific action is performed.
	That is, an EventHandler can have a list or collection of registered "Methods", and invoke them in order when we call the raise the event.
#END
Class EventHandler<T>
	#Rem monkeydoc
		This method can be used to add a new [[Delegate]] to this event handler.
		When the event is raised, all delegates registered in this EventHandler are invoked.
	#END
	Method Add(context:Object, methodName:String)
		Local delegate:= New Delegate<T>(context, methodName)
		_events.AddLast(delegate)
	End
	
	#Rem monkeydoc
		This method returns signature description for the current Event Handler.
	#END
	Method SignatureDescription:String()
		Return "(sender:Object, e:EventArgs)"
	End
	
	#Rem monkeydoc
		This method will remove all [[Delegate]]s with a given signature (context and methodname) to be removed from this EventHandler.
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
			_events.RemoveEach(del)
			result = true
		Next
		Return result
	End
	
	#Rem monkeydoc
		Use this method to raise the given event.
		When this method called, all the event [[Delegate]]s will invoke their associated methods in their associated class instances.
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
		If _events.IsEmpty Then Return
		For Local del:Delegate<T> = EachIn _events
			del.Invoke(sender, e)
		Next
	End
	
	#Rem monkeydoc
		summary: This method removes all [[Delegate]]s from this Event Handler.
	#END
	Method Clear()
		_events.Clear()
	End
	
	#rem monkeydoc
		This method returns True is this EventHanlder has any associated [[Delegate]]s. Otherwise returns false.
	#END
	Method HasDelegates:Bool()
		Return Not _events.IsEmpty
	End
	
	Private
	Field _events:= New List<Delegate<T>>
End

