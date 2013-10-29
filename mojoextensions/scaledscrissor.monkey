Import junglegui
Function SetGuiScissor(gui:Gui, x:Float, y:Float, width:Float, height:Float)
	Local sx:= gui.ScaleX
	Local sy:= gui.ScaleY
	SetScissor(x * sx, y * sy, width * sx, height * sy)
End

