Import reflection
Interface DesignTimeInfo
	Method PropertiesDescriptor:List<DTProperty>()
End

Class DTProperty
	Method New(name:String, value:Object)
		Self.name = name
		Self.valueKind = ClassInfo(valueKind)
		
	End
	
	Method New(name:String, value:String)
		Self.name = name
		Self.valueKind = ClassInfo(BoxString(value))
	End
	
	Method New(name:String, value:Int)
		Self.name = name
		Self.valueKind = ClassInfo(BoxInt(value))		
	End
	
	Method New(name:String, value:Float)
		Self.name = name
		Self.valueKind = ClassInfo(BoxFloat(value))
	End

	Method New(name:String, value:Bool)
		Self.name = name
		Self.valueKind = ClassInfo(BoxBool(value))
	End

	Private
	Method Validate:Bool(owner:DesignTimeInfo)
		For Local s:MethodInfo = EachIn GetClass(owner).GetMethods(True)
			If name = s.Name Then
				If s.ParameterTypes.Length = 1 Then
					
					If s.ParameterTypes[0].ElementType() = valueKind Then
						Print s.Name + "--> " + s.ParameterTypes[0].ElementType.Name()
						Return True
					EndIf
				ElseIf s.ParameterTypes.Length = 0 Then
					If s.ReturnType = valueKind Then
						Print s.Name 
						Return True
					EndIf
				EndIf
			EndIf
		Next
		Return False
	End
	
	Field name:String
	Field valueKind:ClassInfo
End