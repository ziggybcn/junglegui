Import junglegui
Private
Import mojo
Public
Class Button extends BaseLabel implements guiinterfaces.TextualAlignItem
	
	Method New()
		_InitComponent()
	End
	
	Method New(parent:ContainerControl, x:Int, y:Int, text:String,width:Int,height:Int)
		Self.Parent = parent
		Self.Position.X = x
		Self.Position.Y = y
		Self.Text = text
		Self.Size.X = width
		Self.Size.Y = height
		_InitComponent 
	End
	
	Method Render:Void()
		Local drawingPos:= CalculateRenderPosition()
		GetGui.Renderer.DrawButtonBackground(Self.Status, drawingPos, Self.Size, Self)
		GetGui.Renderer.DrawControlBorder(Self.Status, drawingPos, Self.Size, Self)
		If Self.HasFocus Then GetGui.Renderer.DrawButtonFocusRect(Self.Status, drawingPos, Self.Size, Self)
		GetGui.Renderer.DrawLabelText(Self.Status, drawingPos, Self.Size, Self.Text, Self.TextAlign, Self.Font, Self)
		If HasFocus Then GetGui.Renderer.DrawFocusRect(Self, True)
	End
	
	Method AdjustSize:GuiVector2D()
		Local size:GuiVector2D = New GuiVector2D 
		size.X = Font.GetTxtWidth(Text) + 19
		size.Y = Font.GetFontHeight() + 19
		Self.Size.SetValues(size.X,size.Y)
		Return size
	End
	'summary: This property allows you to set the desired text aligment for thsi control.
	Method TextAlign:Int() Property
		Return _textAlign	
	End
	
	Method TextAlign:Void(align:Int) Property
		Select align
			Case eTextAlign.CENTER, eTextAlign.LEFT, eTextAlign.RIGHT 
				_textAlign = align
			Default
				Throw(New JungleGuiException("Text align value is not valid",Self))	
		End
	End
	
	
	Private
	Field _textAlign:Int = eTextAlign.CENTER 

	Method _InitComponent()
		ForeColor.SetColor(1, 0, 0, 0)
		BackgroundColor = SystemColors.ControlFace
		BorderColor = SystemColors.ButtonBorderColor
		HooverColor = SystemColors.HooverBackgroundColor
		TabStop = true
	End
End

