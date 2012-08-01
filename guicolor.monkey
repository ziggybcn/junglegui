private
Import mojo
public
Class GuiColor

	Field r:Int, g:Int, b:Int, a:Float
	
	method SetColor(a,r,g,b)
		Self.r = r
		Self.g = g
		Self.b = b
		Self.a = a
	End
	
	Method New(a,r,g,b)
		SetColor(a,r,g,b)
	End
	
	Method Activate()
		graphics.SetColor(r,g,b)
	End
	
	Method Clone:GuiColor()
		Return New GuiColor(a,r,g,b)
	End
End

