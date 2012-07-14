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
		DrawRect(position.X,position.Y,Size.X,Size.Y)
		_borderColor.Activate()
		DrawBox(position,Size)
		if GetGui.ActiveControl = Self Then DrawFocusRect(Self)
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
