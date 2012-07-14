Import junglegui
Private
Import mojo
public
Import "data/trackbar.png"


Class TrackBar extends Control

Private

	Global _trackBarImage:Image
	
	Const FADER_WIDTH:Int = 10
	Const FADER_OFFSET:Int = 7
	Const FADER_OFFSET2:Int = 14
	
	Field _down:Bool = false
	Field _over:Bool = false
	Field _frame:int = 0
	
	Method _MouseOverFader:Bool(mx:Float, my:Float)
	
		Local x:Int = _ValueToPosition
		Select _orientation
					
			Case eOrientation.HORIZONTAL
				Return mx >= x And mx < x + FADER_WIDTH and my < Size.Y
				
			Case eOrientation.VERTICAL
				Return my >= x And my < x + FADER_WIDTH and mx < Size.X
		End
		
	End
	
	Method _ValueToPosition:Int() Property

		local m:Float = float(float(1 - 0) / float(_maximum - _minimum));
			
		Select _orientation
					
			Case eOrientation.HORIZONTAL

				return FADER_OFFSET + (m * _value - (m * _minimum)) * float(Size.X - FADER_WIDTH - FADER_OFFSET2)
				
			Case eOrientation.VERTICAL

				return FADER_OFFSET + (m * _value - (m * _minimum)) * float(Size.Y - FADER_WIDTH - FADER_OFFSET2)
		End
	
	End
	
	Method _RenderLine(drawpos:GuiVector2D)
	
		Select _orientation
		
			Case eOrientation.HORIZONTAL
			
				SetColor(176, 176, 176)
				DrawRect(drawpos.X + FADER_OFFSET, drawpos.Y + Size.Y / 2 - 8, Size.X - 1 - FADER_OFFSET2, 1)
				SetColor(242, 242, 242)
				DrawRect(drawpos.X + FADER_OFFSET, drawpos.Y + Size.Y / 2 - 7, Size.X - FADER_OFFSET2, 3)
				SetColor(231, 233, 234)
				DrawRect(drawpos.X + FADER_OFFSET, drawpos.Y + Size.Y / 2 - 7, Size.X - 1 - FADER_OFFSET2, 2)
				
			Case eOrientation.VERTICAL
				
				SetColor(176, 176, 176)
				DrawRect(drawpos.X + Size.X / 2 - 8, drawpos.Y + FADER_OFFSET, 1, Size.Y - 1 - FADER_OFFSET2)
				SetColor(242, 242, 242)
				DrawRect(drawpos.X + Size.X / 2 - 7, drawpos.Y + FADER_OFFSET, 3, Size.Y - FADER_OFFSET2)
				SetColor(231, 233, 234)
				DrawRect(drawpos.X + Size.X / 2 - 7, drawpos.Y + FADER_OFFSET, 2, Size.Y - 1 - FADER_OFFSET2)
				
		End
	End
	
	Method _RenderTicks(drawpos:GuiVector2D)
	
		Local length = Abs(_maximum - _minimum)
		Local count = length / _tickFrequency
		
		
		Select _orientation
		
			Case eOrientation.HORIZONTAL
			
				Local stepWidth:Float = float(Size.X - FADER_OFFSET2 - FADER_WIDTH) / float(count)
				SetColor 176, 176, 175
				DrawRect drawpos.X + FADER_OFFSET + 5, drawpos.Y + Size.Y / 2 + 7, 1, 5
				DrawRect drawpos.X + FADER_OFFSET + 5 + count * stepWidth, drawpos.Y + Size.Y / 2 + 7, 1, 5
				For Local i= 0 until count
					DrawRect 12 + drawpos.X + (i + 1) * stepWidth, drawpos.Y + Size.Y / 2 + 7, 1, 3
				Next
				
			Case eOrientation.VERTICAL
				
				Local stepWidth:Float = float(Size.Y - FADER_OFFSET2 - FADER_WIDTH) / float(count)
				
				SetColor 176, 176, 175
				DrawRect drawpos.X + Size.X / 2 + 7, FADER_OFFSET + 5 + drawpos.Y, 5, 1
				DrawRect drawpos.X + Size.X / 2 + 7, FADER_OFFSET + 5 + drawpos.Y + count * stepWidth, 5, 1
	
				For Local i= 0 until count
					DrawRect drawpos.X + Size.X / 2 + 7, 12 + drawpos.Y + (i + 1) * stepWidth, 3, 1
				Next
				
		End
		
	End
	
	Method _RenderFader(drawpos:GuiVector2D)
		Select _orientation
		
			Case eOrientation.HORIZONTAL
			
				SetColor 255, 255, 255
				DrawImage(_trackBarImage, drawpos.X + _ValueToPosition, drawpos.Y + Size.Y / 2 - 15, _frame)
				
			Case eOrientation.VERTICAL
				
				SetColor 255, 255, 255
				DrawImage(_trackBarImage,
				 drawpos.X +Size.X / 2 - 15,
				 drawpos.Y +_ValueToPosition + 10, ' add 10, cause of rotaion
				 90, 1, 1, _frame)
		End
		
	End
	
	Method _MouseDown(e:MouseEventArgs)
		if _MouseOverFader(e.position.X, e.position.Y) Then
			_down = true
			_frame = 2
		EndIf
	End
	
	Method _MouseUp(e:MouseEventArgs)
		if _MouseOverFader(e.position.X, e.position.Y) Then
			_frame = 1
		Else
			_frame = 0
		EndIf
		_down = false
	End
	
	Method _MouseMove(e:MouseEventArgs)
		if _down Then
			Select _orientation
			
				Case eOrientation.HORIZONTAL

					local tx:Float = Min(1.0, Max(0.0, float(e.position.X - FADER_OFFSET) / float(Size.X - FADER_OFFSET2 - FADER_WIDTH)))
					Value = tx * float(_maximum - _minimum) + _minimum
					
				Case eOrientation.VERTICAL
					
					local tx:Float = Min(1.0, Max(0.0, float(e.position.Y - FADER_OFFSET) / float(Size.Y - FADER_OFFSET2 - FADER_WIDTH)))
					Value = tx * float(_maximum - _minimum) + _minimum
					
			End
		Else
			if _MouseOverFader(e.position.X, e.position.Y) Then
				_frame = 1
			Else
				_frame = 0
			EndIf
		EndIf	
	End
	
Public
	
	Method Msg:Void(sender:Object, e:EventArgs)
		Select e.eventSignature
		
			Case eEventKinds.MOUSE_DOWN

				_MouseDown(MouseEventArgs(e))
				
			Case eEventKinds.MOUSE_UP
			
				_MouseUp(MouseEventArgs(e))
				
			Case eEventKinds.MOUSE_MOVE
			
				_MouseMove(MouseEventArgs(e))
				
		End
		Super.Msg(sender, e)
	End
	
	Method Orientation:Int() Property
		Return _orientation
	End
	
	Method Orientation(value:Int) Property
		if value <> eOrientation.HORIZONTAL And value <> eOrientation.VERTICAL Then
			Throw New JungleGuiException("", self)
		EndIf
		_orientation = value
	End
	
	Method Render:Void()

		Local drawpos := CalculateRenderPosition()

		SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
		DrawRect(drawpos.X, drawpos.Y, Size.X, Size.Y)
		
		_RenderLine(drawpos)

		_RenderFader(drawpos)

		_RenderTicks(drawpos)
		
		'if GetGui.ActiveControl = Self Then DrawFocusRect(Self, False)
		if GetGui.GetMousePointedControl = Self Then
			SystemColors.FocusColor.Activate()
			DrawBox(drawpos, Size)
		EndIf

	End

	Method New()
		if Not _trackBarImage Then _trackBarImage = LoadImage("trackbar.png", 10, 18, 3)
		BackgroundColor = SystemColors.WindowColor.Clone()
		Size.SetValues(200, 40)
		Orientation = eOrientation.HORIZONTAL
	End
	
	Method Value(value:Int) Property
		If _value <> value Then
			if value < _minimum Then value = _minimum
			if value > _maximum Then value = _maximum
			_value = value
			Msg(Self, New EventArgs(eEventKinds.SLIDING_VALUE_CHANGED))
		End
	End
	
	Method Value:Int() Property
		Return _value
	End
	
	Method Minimum:Int() Property
		Return _minimum 
	End
	
	Method Minimum(value%) Property 
		_minimum = value
		if _value < _minimum Then _value = _minimum
	End
	
	Method Maximum%() Property 
		Return _maximum 
	End
	
	Method Maximum(value%) Property 
		_maximum = value
		if _value > _maximum Then _value = _maximum
	End
	
	Method Tickfrequency%()
		Return _tickFrequency 
	End
	
	Method Tickfrequency(value:Int)
		if value < 1 Then value = 1
		_tickFrequency = value 
	End	

	
Private

	Field _state:Int = 0
	Field _value:Int = 0
	Field _tickFrequency:Int = 5
	Field _minimum:Int = 0
	Field _maximum:Int = 100
	Field _orientation:Int = eOrientation.VERTICAL
	
End

Class eOrientation Abstract
	Const VERTICAL:Int = 0
	Const HORIZONTAL:Int = 1
End