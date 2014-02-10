Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

Class Canvas Extends Control

	Method New()
		_logicsize.SetValues(640, 450)
		OnCreate()
	End
	
	Method LogicSize:GuiVector2D() Property
		Return _logicsize
	End
	
	Method Render:Void()
		Super.Render()
		
		'Make the matrix work!
		
		'Get the scale factor:
		'Local scalex:Float, scaley:Float
		PushMatrix()
		Local drawpos:GuiVector2D = Self.UnsafeRenderPosition()
		Translate(drawpos.X, drawpos.Y)
		Scale(scalex, scaley)
		PushMatrix()
		SetColor(255, 255, 255)
		SetAlpha(1)
		SetBlend AlphaBlend
		Event_Render.RaiseEvent(Self, voidEventArgs)
		OnRender()
		PopMatrix()
		PopMatrix()
		SetColor(255, 255, 255)
		SetAlpha(1)
		SetBlend AlphaBlend
	End
	
	Method Update()
		Super.Update()
		scalex = Float(Size.X) / _logicsize.X
		scaley = Float(Size.Y) / _logicsize.Y
		Event_Update.RaiseEvent(Self, voidEventArgs)
		OnUpdate()
	End
	
	Method OnRender:Int()
		
	End
	
	Method OnUpdate:Int()
		
	End
	
	Method OnCreate:Int()
		
	End
	
	Method MouseX:Float()
		Local gui:= GetGui
		If Not gui Then Return 0
		Local drawpos:= UnsafeRenderPosition()
		Local mousex = gui.MousePos.X
		Local result:Float = mousex - drawpos.X
		Return result / scalex
	End
	Method MouseY:Float()
		Local gui:= GetGui
		If Not gui Then Return 0
		Local drawpos:= UnsafeRenderPosition()
		Local mousey = gui.MousePos.Y
		Local result:Float = mousey - drawpos.Y
		Return result / scaley
	End
	
	
	Method Event_Render:EventHandler<EventArgs>() Property; Return _onRender; End
	Method Event_Update:EventHandler<EventArgs>() Property; Return _onUpdate; End
	Private
	Field _onRender:= New EventHandler<EventArgs>
	Field _onUpdate:= New EventHandler<EventArgs>
	Field _logicsize:= New GuiVector2D
	Field scalex:Float = 1, scaley:Float = 1
	Global voidEventArgs:EventArgs = New EventArgs
	
End