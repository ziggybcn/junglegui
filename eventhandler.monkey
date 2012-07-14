Import junglegui
Import reflection


Class EventDelegate
	Field control:Control
	Field signature:Int
	Field methodName:String
	Field callBack:MethodInfo 
	
	Method New(form:TopLevelControl, control:Control, signature:Int, methodName:String)
		
		Local argTypes:=New ClassInfo[2]
		argTypes[0] = GetClass(New Control)
		argTypes[1] = GetClass(New EventArgs)
		Local myclass:=GetClass(form)
		callBack = myclass.GetMethod(methodName, argTypes)
		self.control = control
		Self.signature = signature
		Self.methodName = methodName
	End
	
	Method Invoke(form:TopLevelControl, sender:Control, e:EventArgs)
		Local arguments:Object[] = New Object[2]
		arguments[0] = sender
		arguments[1] = e
		callBack.Invoke(form,arguments)
	End
	
	Method Match:Bool(control:Control, signature:Int)
		if control = Self.control And signature = Self.signature Then Return True Else Return false
	End
End

'Summary: This class is the Event Handler used by top level controls to trap events and act accordingly
Class EventHandler Final
	'sumary: This is the Event Handler constructor. Any EventHandler has to be tied to a TopLevelControl on creation.
	Method New(form:TopLevelControl)
		_form = form	
	End
	
	'summary: This method is used to add an event handler method to a given event.
	'the parameters are:
	'Control: The control that raises the Event. As instance, a button in a CLICK event.
	'Signature: The event signature of the event we're handling. An event signature is a constant defined in the class eEventKinds
	'methodName: This is a string that contains the method name that will be called whenever the event is hanlded. JungleGui will internaly use reflection to convert this to the actual method call.
	Method Add:Bool(control:Control, signature:Int, methodName:String)
		Local delegate:=New EventDelegate(_form,control,signature,methodName)
		if delegate.callBack = null Then
			Local exceptionText:String =
				"Could not generate event with the given signature (methodname = '" + methodName + "').~n" +
				"Maybe the reflection filter is not properly set, or the Method is not properly written."
			if control.Name <> "" Then
				exceptionText += "~n~tThe control that caused the exception is named: ~q" + control.Name + "~q"
			Else
				exceptionText += "~n~tThe control that caused the exception has no name."
			EndIf
			if _form.Name <> "" Then
				exceptionText += "~n~tThe TopLevelControl that was trying to register the event signature is named: ~q" + _form.Name + "~q"
			Else
				exceptionText += "~n~tThe TopLevelControl that was trying to register the event signature has no name."
			EndIf
			Throw New JungleGuiException(exceptionText, _form)
		EndIf
		list.AddLast(delegate)
	end
	
	'summary: This method allows you to remove an event handler, by providing the associated control instance and the associated method name.
	Method Remove:Bool(control:Control, signature:Int, methodName:String)
		Local remover:EventDelegate = FindSpecific(control,signature,methodName)
		if remover<> null Then
			list.Remove(remover)
			Return true
		Else
			Return false
		EndIf
	end

	Method FindSpecific:EventDelegate(control:Control, e:EventArgs, methodName:String)
		Local result:EventDelegate = null
		For Local delegate:EventDelegate = EachIn list
			if delegate.control = control And delegate.signature = e.eventSignature  And delegate.methodName = methodName
				result = delegate
				Exit 
			end
		Next
		Return result
	end
	
	Method FindAll:List<EventDelegate>(control:Control, e:EventArgs)
		Local result:=New List<EventDelegate>
		For Local delegate:EventDelegate = EachIn list
			if delegate.control = control And delegate.signature = e.eventSignature 
				result.AddLast(delegate)
				Exit 
			end
		Next
		Return result
	end

	'summary: This method clears all event handlers
	Method Clear()
		list.Clear()
	End
	Private
	field _form:TopLevelControl
	Field list:=New List<EventDelegate> 
End