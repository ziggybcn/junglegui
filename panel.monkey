Import junglegui
Private 
Import mojo
public
Class Panel extends ContainerControl
	Method New()
		_InitComponent
	End
	Method RenderBackground()
		BackgroundColor.Activate()
		Local position:=self.CalculateRenderPosition()
		DrawRect(position.X + 1, position.Y + 1, Size.X - 2, Size.Y - 2)
		BorderColor.Activate()
		DrawRoundBox(position, Size)
		if HasFocus Then DrawFocusRect(Self, true)
		
	End
	
	Private
	Method _InitComponent()
		BorderColor = SystemColors.FormBorder.Clone()
		BackgroundColor = SystemColors.ControlFace.Clone()
		Size.X = 200
		Size.Y = 200		
	End
end
