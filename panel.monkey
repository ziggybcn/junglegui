Import junglegui
Private 
Import mojo
Public
Class Panel extends ContainerControl
	Method New()
		_InitComponent
	End
	Method RenderBackground()
		BackgroundColor.Activate()
		Local position:=self.UnsafeRenderPosition()
		DrawRect(position.X + 1, position.Y + 1, Size.X - 2, Size.Y - 2)
		BorderColor.Activate()
		DrawRoundBox(position, Size)
		If HasFocus Then GetGui.Renderer.DrawFocusRect(Self, True)
		
	End
	
	Private
	Method _InitComponent()
		BorderColor = SystemColors.FormBorder
		BackgroundColor = SystemColors.ControlFace
		Size.X = 200
		Size.Y = 200		
	End
end
