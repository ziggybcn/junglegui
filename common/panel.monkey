Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

'note: TODO: Horizontal scrollbar support
Class Panel extends ContainerControl
	Method New()
		_InitComponent
	End
	Method RenderBackground()
		BackgroundColor.Activate()
		Local position:=self.UnsafeRenderPosition()
		DrawRect(position.X + 1, position.Y + 1, Size.X - 2, Size.Y - 2)
		BorderColor.Activate()
		'DrawRoundBox(position, Size)
		GetGui.Renderer.DrawControlBorder(Status, position, Size, Self)
		If HasFocus And _drawFocusRect Then GetGui.Renderer.DrawFocusRect(Self, True)
	End
	
	Method DrawFocusRect:Bool() Property
		Return _drawFocusRect
	End
	Method DrawFocusRect:Void(value:Bool) Property
		_drawFocusRect = value
		
		
	End
	
	Private
	Method _InitComponent()
		BorderColor = SystemColors.FormBorder
		BackgroundColor = SystemColors.ControlFace
		Size.X = 200
		Size.Y = 200
		Padding.SetAll(5, 5, 5, 5)
	End
	Field _drawFocusRect:Bool = True
end
