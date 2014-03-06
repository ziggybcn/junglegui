Import junglegui

#IF TARGET="html5"
Extern Private
Class Win = "Window"
	Method Execute:Object(param1:String) = "eval"
End
Global window:Win = "window"
Public
#END
Class MousePointer Final
	
	Function Pointer:Int()
		Return mousePointer
	End
	
	Function Pointer:Void(value:Int)
		If mousePointer = value Return
		mousePointer = value
		'Print "Set as " + value
	End
	
	Function PerformSystemInteraction()
		If mousePointer = cachedMousePointer Return
		
		#IF TARGET="html5"
			
			If doneBefore = False Then
				doneBefore = True
				elem = document.getElementById("GameCanvas")
				pre_mouse_style = elem.getAttribute("style")
			EndIf
			
			If elem <> Null Then
				Local cursor:String = "default"
				Select mousePointer
					Case eMouse.Arrow, eMouse.Auto
						cursor = "default"
					Case eMouse.Clock
						cursor = "wait"
					Case eMouse.Crosshair
						cursor = "crosshair"
					Case eMouse.E_Resize
						cursor = "e-resize"
					Case eMouse.Move
						cursor = "move"
					Case eMouse.N_Resize
						cursor = "n-resize"
					Case eMouse.NE_Resize
						cursor = "ne-resize"
					Case eMouse.Not_allowed
						cursor = "not-allowed"
					Case eMouse.NW_Resize
						cursor = "nw-resize"
					Case eMouse.Pointer
						cursor = "pointer"
					Case eMouse.Progress
						cursor = "progress"
					Case eMouse.S_Resize
						cursor = "s-resize"
					Case eMouse.SE_Resize
						cursor = "se-resize"
					Case eMouse.SW_Resize
						cursor = "sw-resize"
					Case eMouse.Text
						cursor = "text"
					Case eMouse.W_Resize
						cursor = "w-resize"
					Case eMouse.Wait
						cursor = "wait"
				End
				elem = document.getElementById("GameCanvas")
				Local raw_style:= elem.getAttribute("style")
				Local styles:= raw_style.Split(";"), found:Bool = False
				Local sStack:= New StringStack
				For Local i:Int = 0 Until styles.Length
					
					Local item:= styles[i].Trim.ToLower
					
					If item.StartsWith("cursor:") Then
						found = True
						styles[i] = "cursor:" + cursor
					EndIf
					sStack.Push(styles[i] + "; ")
				Next
				If found = False Then
					sStack.Push("cursor:" + cursor + ";")
				EndIf
				elem.setAttribute("style", sStack.Join);
				
			End
		
		#END
	
		cachedMousePointer = mousePointer
	
	End
	Private
	Global mousePointer:Int = 0
	Global cachedMousePointer:Int = -1000
	Global doneBefore:Bool = False
	#IF TARGET="html5"
	Global pre_mouse_style:String
	Global elem:Element
	#END
	
End

Class eMouse
	Const Auto:= 0
	Const Move:= 1
	Const Pointer:= 2
	Const Not_allowed:= 3
	Const Crosshair:= 4
	Const Progress:= 5
	Const Arrow:= 6
	Const Text:= 7
	Const N_Resize:= 8
	Const NW_Resize:= 9
	Const S_Resize:= 10
	Const SE_Resize:= 11
	Const E_Resize:= 12
	Const NE_Resize:= 13
	Const Wait:= 14
	Const W_Resize:= 15
	Const SW_Resize:= 16
	Const Clock:= 4
End