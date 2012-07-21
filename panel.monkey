Import junglegui
Private 
Import mojo
public
Class Panel extends ContainerControl
	Method New()
		_InitComponent
	End
	Method BorderColor:GuiColor() Property
		Return _borderColor
	End
	Method BorderColor:GuiColor(color:GuiColor) property
		_borderColor = color
		Return color
	End
	Method RenderBackground()
		BackgroundColor.Activate()
		Local position:=self.CalculateRenderPosition()
		DrawRect(position.X + 1, position.Y + 1, Size.X - 2, Size.Y - 2)
		_borderColor.Activate()
		DrawRoundBox(position, Size)
		if HasFocus Then DrawFocusRect(Self, true)
		
	End
	
	Private
	Field _borderColor:GuiColor
	Method _InitComponent()
		_borderColor = SystemColors.FormBorder.Clone()
		BackgroundColor = SystemColors.ControlFace.Clone()
		Size.X = 200
		Size.Y = 200		
	End
end
