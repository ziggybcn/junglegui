Import reflection
Interface DesignTimeInfo
	Method PropertiesDescriptor:List<DTProperty>()
End

Class DTProperty
	Method New(name:String, valueKind:ClassInfo)
		Self.name = name
		Self.valueKind = valueKind
		
	End
	
	Method Validate:Bool(owner:DesignTimeInfo)
		Print "Validating"
		For Local s:MethodInfo = EachIn GetClass(owner).GetMethods(True)
			Print "Checking " + s.Name + " = " + name
			If name = s.Name Then
				Print "Getting parameters for " + s.Name
				If s.ParameterTypes.Length = 1 Then
					
					If s.ParameterTypes[0].ElementType() = valueKind Then
						Print "Found setter!"
						Print s.Name + "--> " + s.ParameterTypes[0].ElementType.Name()
						Return True
					EndIf
				ElseIf s.ParameterTypes.Length = 0 Then
					If s.ReturnType = valueKind Then
						Print "Found getter!"
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