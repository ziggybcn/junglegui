private
Import mojo

Public
'summary: This represents a color to be used on the Gui system
Class GuiColor

	Field r:Int, g:Int, b:Int, a:Float
	'summary: Sets the color values
	method SetColor(a,r,g,b)
		Self.r = r
		Self.g = g
		Self.b = b
		Self.a = a
	End
	'summary: Creates the JungleGui color with the given parameters (alpha, red, green and blue)
	Method New(a,r,g,b)
		SetColor(a,r,g,b)
	End
	
	'summary: Activates current color
	Method Activate()
		SetAlpha(a)
		graphics.SetColor(r,g,b)
	End
	
	'summary: Returns a clone of this color
	Method Clone:GuiColor()
		Return New GuiColor(a,r,g,b)
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

