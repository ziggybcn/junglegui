#Rem monkeydoc Module junglegui.guicolor
	This module contains the GuiColor implementation
#END
Import mojo
#REFLECTION_FILTER+="${MODPATH}"

#rem monkeydoc
	This represents a color to be used on the Gui system
 #END
Class GuiColor
	Private
	Field r:Int
	
	Field g:Int
	Field b:Int
	Field a:Float
	Public
	#Rem monkeydoc
		This property is the alpha component of this [[GuiColor]].
		The alpha component is represented by a Float value and it ranges from 0 to 1.
	#END
	Method Alpha:Float() Property
		Return a
	End
	#Rem monkeydoc
		This property is the alpha component of this [[GuiColor]]. The alpha component is represented by a Float value and it ranges from 0 to 1.
		If you set a value greater than 1, this property will be set to a 1, in the same way, if you set a value smoller than 0, this property will be set to 0.
	#END
	Method Alpha:Void(value:Float) Property
		a = Clamp(value, 0.0, 1.0)
	End
	
	#Rem monkeydoc
		This property is the red component of this [[GuiColor]].
		The red component is represented by an integer value and it ranges from 0 to 255.
	#END
	Method Red:Int() Property
		Return r
	End
	
	#Rem monkeydoc
		This property is the red component of this [[GuiColor]].
		The red component is represented by an integer value and it ranges from 0 to 255.
		If you set a value greater than 255, this property will be set to 255. Also, if you set a value smaller than 0, this property will be set to 0.
	#END
	Method Red:Void(value:Int) Property
		r = value
		If r < 0 Then
			r = 0
		ElseIf r > 255
			r = 255
		EndIf
	End

	#Rem monkeydoc
		This property is the green component of this [[GuiColor]].
		The green component is represented by an integer value and it ranges from 0 to 255.
	#END
	Method Green:Int() Property
		Return g
	End
	
	#Rem monkeydoc
		This property is the green component of this [[GuiColor]].
		The green component is represented by an integer value and it ranges from 0 to 255.
		If you set a value greater than 255, this property will be set to 255. Also, if you set a value smaller than 0, this property will be set to 0.
	#END
	Method Green:Void(value:Int) Property
		g = Clamp(value, 0, 255)
	End
	
	#Rem monkeydoc
		This property is the blue component of this [[GuiColor]].
		The blue component is represented by an integer value and it ranges from 0 to 255.
	#END
	Method Blue:Int() Property
		Return b
	End
	
	#Rem monkeydoc
		This property is the blue component of this [[GuiColor]].
		The blue component is represented by an integer value and it ranges from 0 to 255.
		If you set a value greater than 255, this property will be set to 255. Also, if you set a value smaller than 0, this property will be set to 0.
	#END
	Method Blue:Void(value:Int) Property
		b = Clamp(value, 0, 255)
	End

	
			
	#Rem monkeydoc
		This method allows you to set all color values at once.
	 #END
	Method SetColor(a:Float, r:Int, g:Int, b:Int)
		Red = r
		Green = g
		Blue = b
		Alpha = a
	End
	#rem monkeydoc
		This constructor creates the Jungle [[GuiColor]] with the given parameters (alpha, red, green and blue)
	#END
	Method New(a:Float, r:Int, g:Int, b:Int)
		SetColor(a, r, g, b)
	End
	
	#Rem monkeydoc
		Activates current color. Once this is called, all subsequent drawing operations will be affected by this color.
	 #END
	Method Activate()
		Local a:Float = GetAlpha
		Local col:= New Float[3]
		GetColor(col)
		If a <> Self.a Then SetAlpha(a)
		If col[0] <> r or col[1] <> g or col[2] <> b Then graphics.SetColor(r, g, b)
	End
	
	#rem monkeydoc 
		Returns a clone of this color. That is, a new GuiColor instance with the same color values.
	#END
	Method Clone:GuiColor()
		Return New GuiColor(a, r, g, b)
	End
	
	#rem monkeydoc 
		This method activates this color with additional bright (more white)
	#END
	Method ActivateBright(brightness:Int = 15)
		graphics.SetColor(
			Clamp(r + brightness, 0, 255),
			Clamp(g + brightness, 0, 255),
			Clamp(b + brightness, 0, 255))
	End
	
	#rem monkeydoc 
		This method activates this color with additional darkness (more black)
	#END
	Method ActivateDark(darkness:Int = 15)
		ActivateBright(-darkness)
	End
End