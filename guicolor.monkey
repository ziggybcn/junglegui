Import mojo

'summary: This represents a color to be used on the Gui system
Class GuiColor

	Field r:Int, g:Int, b:Int, a:Float
	'summary: Sets the color values
	Method SetColor(a, r, g, b)
		#IF CONFIG="debug" 
			If a > 1 or a < 0 or r > 255 or r < 0 or g > 255 or g < 0 or b > 255 or b < 0 Then
				Error("Color values are not valid.")
			EndIf
		#END
		Self.r = r
		Self.g = g
		Self.b = b
		Self.a = a
	End
	'summary: Creates the JungleGui color with the given parameters (alpha, red, green and blue)
	Method New(a, r, g, b)
		#IF CONFIG="debug" 
			If a > 1 or a < 0 or r > 255 or r < 0 or g > 255 or g < 0 or b > 255 or b < 0 Then
				Error("Color values are not valid.")
			EndIf
		#END
		SetColor(a, r, g, b)
	End
	
	'summary: Activates current color
	Method Activate()
		Local a:Float = GetAlpha
		Local col:= New Float[3]
		GetColor(col)
		If a <> Self.a Then SetAlpha(a)
		If col[0] <> r or col[1] <> g or col[2] <> b Then graphics.SetColor(r, g, b)
	End
	
	'summary: Returns a clone of this color
	Method Clone:GuiColor()
		Return New GuiColor(a, r, g, b)
	End
	
	'Activates this color with additional bright (more white)
	Method ActivateBright(brightness:Int = 15)
		graphics.SetColor(
			Max(Min(r + brightness, 255), 0),
			Max(Min(g + brightness, 255), 0),
			Max(Min(b + brightness, 255), 0))
	End
	
	'Activates this color with additional dark (more black)
	Method ActivateDark(darkness:Int = 15)
		ActivateBright(-darkness)
	End
End