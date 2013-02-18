Import junglegui

Class WindowFrame Extends TopLevelControl
	
	Method New()
		BackgroundColor = SystemColors.AppWorkspace
		Size.SetValues(400, 400)
		Padding.Left = 0
		Padding.Top = 0
		Padding.Right = 0
		Padding.Bottom = 0
		BackgroundColor = SystemColors.WindowColor
	End
	
	Method RenderBackground()
		If Not Transparent Then
			Local drawPos:GuiVector2D = CalculateRenderPosition()
			GetGui.Renderer.DrawControlBackground(Status, drawPos, Size, Self)
		End
	End
	
	Method DrawFocus()
		If Not Transparent Then Super.DrawFocus()
	End

	'summary: This property is used to determine if this Window Frame component has a solid background
	Method Transparent:Bool() Property
		Return _transparent
	End

	Method Transparent:Void(value:Bool) Property
		_transparent = value
	End
	
	Method BringToFront()
		Super.BringToFront
		'Red lights, red lights! We're accessing directly the internal gui components list:
		Local list:= GetGui.GetComponentsList(False)
		Local tarray:TopLevelControl[] = list.ToArray()
		Local current:Int = tarray.Length - 1
		For Local i:Int = current - 1 To 0 Step - 1
			Local tlc:TopLevelControl = tarray[i]
			If WindowFrame(tlc) Then Return
			Local aux:TopLevelControl = tarray[i]
			tarray[i] = tarray[current]
			tarray[current] = aux
			current = i
		Next
		list.Clear()
		For Local i:Int = 0 Until tarray.Length
			list.AddLast(tarray[i])
		Next
	End
	
	Private
	Field _transparent:Bool
	
End

