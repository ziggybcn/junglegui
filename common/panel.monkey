Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

'note: TODO: Horizontal scrollbar support
Class Panel extends ContainerControl
	Method New()
		_InitComponent
	End
	Method RenderBackground()
		If Not transparent
			BackgroundColor.Activate()
			Local position:=self.UnsafeRenderPosition()
			DrawRect(position.X, position.Y, Size.X, Size.Y)
		EndIf
	End
	
	Method RenderForeground()
		If _drawFocusRect Then
			If HasFocus Then
				GetGui.Renderer.DrawFocusRect(Self, True)
			Else
				GetGui.Renderer.DrawControlBorder(Status, UnsafeRenderPosition, Size, Self)
			EndIf
		EndIf
	End
	
	Method DrawFocusRect:Bool() Property
		Return _drawFocusRect
	End
	Method DrawFocusRect:Void(value:Bool) Property
		_drawFocusRect = value
	End
	
	Method Transparent:Bool() Property
		Return transparent
	End
	
	Method Transparent:Void(value:Bool) Property
		transparent = value
	End
	
	Private
	Method _InitComponent()
		BorderColor = SystemColors.ButtonBorderColor 'FormBorder
		BackgroundColor = SystemColors.ControlFace
		Size.X = 200
		Size.Y = 200
		Padding.SetAll(5, 5, 5, 5)
	End
	Field _drawFocusRect:Bool = True
	Field transparent:Bool = False
end
