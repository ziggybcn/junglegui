Import junglegui
Private
Import mojo
public
Class BaseLabel extends Control implements TextualItem abstract
	Method Text:String() property
		Return _text
	End
	Method Text:Void(value:String) Property
		if _text <> value then
			_text = value
			If AutoAdjustSize Then AdjustSize()
			Msg(Self, eEventKinds.TEXT_CHANGED)
		endif
	End
	
	Method Font:BitmapFont() property
		if _font<>null Then Return _font Else Return GetGui.systemFont
	End
	
	Method Font:Void(value:BitmapFont) property 
		_font = value
	End
	
	Method New()
		_InitComponent 
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
		Local drawingPos:=CalculateRenderPosition()
		SetColor(BackgroundColor.r,BackgroundColor.g,BackgroundColor.b)
		DrawRect(drawingPos.X,drawingPos.Y,Size.X,Size.Y)
		
		SetColor(Self.ForeColor.r,ForeColor.g,ForeColor.b)
		Font.DrawText(Text,drawingPos.X,drawingPos.Y)
		if GetGui.ActiveControl = Self Then
			DrawFocusRect(Self)
		EndIf
	End
	
	Method AdjustSize:GuiVector2D()
		Local size:GuiVector2D = New GuiVector2D 
		size.X = Font.GetTxtWidth(Text) 
		size.Y = Font.GetFontHeight() 
		Self.Size.SetValues(size.X,size.Y)
		Return Self.Size
	End
	
	Method AutoAdjustSize?() Property
		Return _autoAdjust
	End
	Method AutoAdjustSize?(value:Bool) Property
		_autoAdjust = value
		Return value
	End
	
	
	
	Private
	Field _text:String
	Field _font:BitmapFont 
	Field _autoAdjust:Bool = true
	Method _InitComponent()
		Self.ForeColor.SetColor(1,0,0,0)
		Self.BackgroundColor = SystemColors.ControlFace.Clone()
		TabStop = false
	end
End
