Import junglegui
Private
Import mojo
Public

'summary: This is the BaseLabel class. This class is used by controls displaying and handling Text
Class BaseLabel Extends Control Implements TextualItem Abstract
	'summary: This is the text displayed by the control
	Method Text:String() property
		Return _text
	End
	Method Text:Void(value:String) Property
		if _text <> value then
			_text = value
			If AutoAdjustSize Then AdjustSize()
			'Msg(Self, eMsgKinds.TEXT_CHANGED)
			Local msg:BoxedMsg = New BoxedMsg(self, New EventArgs(eMsgKinds.TEXT_CHANGED))
			Msg(msg)
		endif
	End
	
	'summary: This property alows you to override the system font with a custom one for this control
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
		Local drawingPos:= CalculateRenderPosition()
		
		GetGui.Renderer.DrawControlBackground(Self.Status, drawingPos, Size, Self)
		GetGui.Renderer.DrawLabelText(Self.Status, drawingPos, Size, Self.Text, eTextAlign.LEFT, Self.Font, Self)
		
	End
	
	'summary: This method will resize the control to the contained text size
	Method AdjustSize:GuiVector2D()
		Local size:GuiVector2D = New GuiVector2D
		size.X = Font.GetTxtWidth(Text) 
		size.Y = Font.GetTxtHeight(Text)
		Self.Size.SetValues(size.X,size.Y)
		Return Self.Size
	End
	
	'summary: If this property is set to True, whenever the text of the control is modified, the control will be resized accordingly.
	Method AutoAdjustSize:Bool() Property
		Return _autoAdjust
	End
	Method AutoAdjustSize:Void(value:Bool) Property
		_autoAdjust = value
	End
	
	Method Dispatch(msg:BoxedMsg)
		Super.Dispatch(msg)
		Select msg.e.eventSignature
			Case eMsgKinds.TEXT_CHANGED
			_textModified.RaiseEvent(msg.sender, msg.e)
		End
	End
	'summary: This event is raised whenever the text contained in this control is modified.
	Method Event_TextModified:EventHandler<EventArgs>() Property; Return _textModified; End
	Private
	Field _textModified:= New EventHandler<EventArgs>
	Field _text:String
	Field _font:BitmapFont 
	Field _autoAdjust:Bool = true
	Method _InitComponent()
		Self.ForeColor.SetColor(1,0,0,0)
		Self.BackgroundColor = SystemColors.ControlFace.Clone()
		TabStop = false
	end
End
