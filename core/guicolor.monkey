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
		a = value
		If a > 1 Then
			a = 1
		ElseIf a < 0
			a = 0
		EndIf
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
		g = value
		If g < 0 Then
			g = 0
		ElseIf g > 255
			g = 255
		EndIf
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
		b = value
		If b < 0 Then
			b = 0
		ElseIf b > 255
			b = 255
		EndIf
	End

	
			
	#Rem monkeydoc
		This method allows you to set all color values at once.
	 #END
	Method SetColor(a:Float, r:Int, g:Int, b:Int)
		#IF CONFIG="debug" 
			If a > 1 or a < 0 or r > 255 or r < 0 or g > 255 or g < 0 or b > 255 or b < 0 Then
				Error("Color values are not valid.")
			EndIf
		#END
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
			Max(Min(r + brightness, 255), 0),
			Max(Min(g + brightness, 255), 0),
			Max(Min(b + brightness, 255), 0))
	End
	
	#rem monkeydoc 
		This method activates this color with additional darkness (more black)
	#END
	Method ActivateDark(darkness:Int = 15)
		ActivateBright(-darkness)
	End
End