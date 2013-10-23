#Rem monkeydoc Module junglegui.windowframe
This module contains the base core components of Jungle gui
#End
Private
Import junglegui.junglegui
Public
#Rem monkeydoc
	This control is a TopLevelControl that can be used to place controls in it.
	As oposite to what happens with a Form, this control does not have any borders or caption. It's just a plain control container.
	This is the perfect Gui component to be placed Over a game, as it can be Transparent, while it keeps its contained controls perfectly rendered.
#END
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
			Local drawPos:GuiVector2D = UnsafeRenderPosition()
			GetGui.Renderer.DrawControlBackground(Status, drawPos, Size, Self)
		End
	End
	
	Method DrawFocus()
		If Not Transparent Then Super.DrawFocus()
	End

	#rem monkeydoc
		This property is used to determine if this Window Frame component has a solid background
	 #END
	Method Transparent:Bool() Property
		Return _transparent
	End

	#rem monkeydoc
		This property is used to determine if this Window Frame component has a solid background
	 #END
	Method Transparent:Void(value:Bool) Property
		_transparent = value
	End
	
	#rem monkeydoc
		This will bring the WindowFrame to the top of the Z-Order.<br>Notice that WindowFrames do always get behind regular forms on the Z-Order.
	 #END
	Method BringToFront()
		Super.BringToFront
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

