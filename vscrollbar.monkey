#rem monkeydoc Module junglegui.vscrollbar
	This module contains a verticall scrollbar control implementation.	
#END

Import junglegui

#rem monkeydoc
	This class is a control that represents a vertical scrollbar.
#END
Class VScrollBar Extends Control

Private

	Global _cachedPosition:= New GuiVector2D
	
	Field _scrollbar:= new ScrollBarContainer
	Field _pos:GuiVector2D' position of ScrollBarRenderer
	Field _value:int = 0
	Field _valueChanged:= new EventHandler<EventArgs>
	
Public

	Method New()
		Self.Size.SetValues(17, 100)
		_pos = New GuiVector2D()
	End
	
	#rem monkeydoc
		This event is fired whenever the VScrollBar value is modified
	#END
	Method Event_ValueChanged:EventHandler<EventArgs>() Property
		Return _valueChanged
	End
	
	
	Method Update()
		if _scrollbar._mouseDown Then
			Local calculateRenderPos:= self.UnsafeRenderPosition
			_cachedPosition.X = GetGui.MousePos.X - calculateRenderPos.X
			_cachedPosition.Y = GetGui.MousePos.Y - calculateRenderPos.Y
			if _scrollbar._fastMove Or _scrollbar._topButtonState = eButtonState.BUTTON_DOWN Or _scrollbar._bottomButtonState = eButtonState.BUTTON_DOWN Then
				_scrollbar.MouseDown(New MouseEventArgs(eMsgKinds.MOUSE_DOWN, _cachedPosition, 0))
			Else
				_scrollbar.MouseMove(New MouseEventArgs(eMsgKinds.MOUSE_MOVE, _cachedPosition, 0))
			EndIf
			Value = _scrollbar.Value
			if Self.HasFocus = False Then Self.GetFocus()
		EndIf
		Super.Update()
	End
	
	'note: TODO: Place all rendering into the abstracted renderer class
	Method Render:Void()
	
		Local drawpos:= UnsafeRenderPosition()
		_scrollbar.Render(drawpos, Self.Size)
	End
	
	Method Msg(msg:BoxedMsg)
	
		_scrollbar._size = Size
		_scrollbar._pos = _pos
		
		Select msg.e.messageSignature
			Case eMsgKinds.MOUSE_MOVE
				_scrollbar.MouseMove(MouseEventArgs(msg.e))
			Case eMsgKinds.MOUSE_UP
				_scrollbar.MouseUp(MouseEventArgs(msg.e))
			Case eMsgKinds.MOUSE_DOWN
				_scrollbar.MouseDown(MouseEventArgs(msg.e))
			Case eMsgKinds.MOUSE_LEAVE
				_scrollbar.MouseLeave()
			Case eMsgKinds.MOUSE_ENTER
				_scrollbar.MouseEnter()
				
		End
		
		Value = _scrollbar.Value
		
		Super.Msg(msg)
	End

	#rem monkeydoc
			This property contains the minimum value of the [[VScrollBar]]
	#END
	Method Minimum:Int()
		return _scrollbar._minimum
	End
	
	Method Minimum:Void(value:Int) Property
		_scrollbar._minimum = value
	End
	
	#Rem monkeydoc
		This property contains the maximum value of the [[VScrollBar]]
	#END
	Method Maximum:Int()
		Return _scrollbar._maximum
	End
	
	Method Maximum:Void(value:Int) Property
		_scrollbar._maximum = value
	End
	#rem monkeydoc
		This property contains the current value of the [[VScrollBar]]
	#END
	Method Value:Int() Property
		Return _scrollbar.Value
	End

	Method Value:Void(value:Int)
		if _value <> value Then
			_value = value
			_scrollbar.Value = value
			_valueChanged.RaiseEvent(Self, New EventArgs( - 1))
		End
	End
	
End

#rem monkeydoc
	This enum-like class contains the available scroll modes for any scrollbar
#END
Class eScrollMode
	#rem monkeydoc
		Smooth scrolling
	#END
	Const Smooth = 0
	#rem monkeydoc
		Stepwise scrolling
	#END
	Const Stepwise = 1
End

#rem monkeydoc
	This class handles rendering of a scrollbar and interaction for any control that needs to draw a scrollbar as part of its rendering.<br>
	This class is used as a low-level resource for controls design and should not be required for regular high-level usage of JungleGui.<br>
	It's designed in a very open way, without almost any encapsulation as it is meant to be used on lower-level design of components.<br>
	If you're looking for a regular high-level scrolling contol, you should be taking a look to the [[VScrollBar]] control instead.
#END
Class ScrollBarContainer

	#rem monkeydoc
		This is the default width of a [[ScrollBar]]
	#END
	Const DefaultWidth = 17
	
	'
	' internal fields, used in update
	'
	#rem monkeydoc
		This field is the number of items handled by the scrollbar.
	#END
	Field _itemsCount:int = 0
	#rem monkeydoc
		This field is the number of items that fit on the visible area that the scrollbar handles.
		The relation between the _visibleItems and the_itemsCount is used to determine the grabber size.
	#END
	Field _visibleItems:int = 0
	#rem monkeydoc
		This field is the number of milliseconds that the scrollbar waits before performing a long change, when the up or down arrows are kept pressed.
	#END	
	Field _longDelay:Int = 750
	#rem monkeydoc
		This field is the number of milliseconds that the scrollbar waits before performing a small change, when the up or down arrows are kept pressed.
	#END	
	Field _shortDelay:Int = 35
	#rem monkeydoc
		This field is set to true or false when the mouse is pressing into the ScrollBarContainer draw area. It's also affected by Touch events.
	#END	
	field _mouseDown:Bool
	#rem monkeydoc
		This field is set to true or false when the ScrollBarContainer is performing a fast move (large change).
	#END	
	Field _fastMove:Bool
	#rem monkeydoc
		This field is set to true or false when the ScrollBarContainer is under the mouse or pointer focus.
	#END	
	Field _mouseOver:Bool
	#rem monkeydoc
		This field is set to the original  location of a drag operation when the grabber is being dragged and dropped to modify the ScrollBarContainer value.
	#END	
	Field _dragOrigin:GuiVector2D
	#rem monkeydoc
		This field is internally used to measure the required milliseconds delay to perform specific actions. It's usage is internal.
	#END	
	Field _delay:= new Countdown
	#rem monkeydoc
		This field is the location where the ScrollBarContainer is meant to be rendered.
	#END	
	Field _pos:= new GuiVector2D
	#rem monkeydoc
		This field is the size that is meant to be used in order to render the ScrollBarContainer.
	#END	
	Field _size:= new GuiVector2D
	#rem monkeydoc
		This field is the current grabber size.
	#END	
	Field _faderSize:Int = 50' the current fader size
	#rem monkeydoc
		This field is the current grabber position (like the visual Value of it).
	#END	
	Field _faderPosition:Int = DefaultWidth' the current fader position
	#rem monkeydoc
		This field is the current scroll mode. See [[eScrollMode]] for the available options.
	#END	
	Field _scrollMode:int = eScrollMode.Stepwise
	'
	' internal fields that indicates the state of different elements
	'
	#rem monkeydoc
		This indicates the status of the top button (see [[eButtonState]])
	#END
	Field _topButtonState:Int = eButtonState.BUTTON_UP
	
	#rem monkeydoc
		This indicates the status of the grabber button (see [[eButtonState]])
	#END
	Field _middleButtonState:Int = eButtonState.BUTTON_UP

	#rem monkeydoc
		This indicates the status of the bottom button (see [[eButtonState]])
	#END
	Field _bottomButtonState:Int = eButtonState.BUTTON_UP
	
	'
	' public scrollbar behavior
	'
	
	#rem monkeydoc
		This indicates the number of items that are increased or decreased on a small change operation.
	#END
	Field _smallChange:Int = 1
	#rem monkeydoc
		This indicates the number of items that are increased or decreased on a large change operation.
	#END
	Field _bigChange:int = 2
	#rem monkeydoc
		This indicates the minimum value of the ScrollBarContainer.
	#END
	Field _minimum:Int = 0
	#rem monkeydoc
		This indicates the maximum value of the ScrollBarContainer.
	#END
	Field _maximum:int = 10
	#rem monkeydoc
		This indicates the actual value of the ScrollBarContainer.
	#END
	Field _value:Int = 0
	
	'
	' public scrollbar appearance
	'
	
	#rem monkeydoc
		This indicates the orientation value of the ScrollBarContainer. See [[eTrackBarOrientation]] for available options.
	#END
	Field _orientation:Int = eTrackBarOrientation.VERTICAL
	
	#rem monkeydoc
		This indicates the minimum grabber size when the ScrollBarContainer is rendered.
	#END
	Field _minFaderSize:Int = 15 ' the minimum fader size
	#rem monkeydoc
		This indicates the top and bottom buttons size (width or height depending on orientation).
	#END
	Field _buttonSize:Int = 15' the width/height of an button
	
	#Rem monkeydoc
		Renders the scrollbar on its position. 
	 #END
	Method Render(drawPos:GuiVector2D, size:GuiVector2D)
	
		local ForeColor:= new GuiColor(1, 0, 0, 0)
		Local BackgroundColor:= SystemColors.ControlFace
		Local BorderColor:= SystemColors.ButtonBorderColor
		Local HooverColor:= SystemColors.WindowColor
		
		' background
		SetColor 235, 235, 235' lightborder
		DrawRect drawPos.X, drawPos.Y, size.X, size.Y
		SetColor 227, 227, 227' backcolor
		DrawRect drawPos.X + 1, drawPos.Y, size.X - 2, size.Y
		
		' draw top/bottom button only if mouse is over scrollbar
		if _mouseOver Then
		
			'SetColor(BorderColor.r, BorderColor.g, BorderColor.b)
			BorderColor.Activate()
			DrawRect drawPos.X + 1, drawPos.Y + 1, size.X - 2, _buttonSize
			DrawRect drawPos.X + 1, drawPos.Y + size.Y - _buttonSize - 1, size.X - 2, _buttonSize
			
			if _topButtonState = eButtonState.BUTTON_DOWN Then
			
				'SetColor(HooverColor.r, HooverColor.g, HooverColor.b)
				HooverColor.Activate()
				
			Else if _topButtonState = eButtonState.BUTTON_OVER Then
			
				'SetColor(HooverColor.r, HooverColor.g, HooverColor.b)
				HooverColor.Activate
				
			Else
			
				'SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
				BackgroundColor.Activate
				
			EndIf
			
			DrawRect drawPos.X + 2, drawPos.Y + 2, size.X - 4, _buttonSize - 2
			
			if _bottomButtonState = eButtonState.BUTTON_DOWN Then
			
				'SetColor(HooverColor.r, HooverColor.g, HooverColor.b)
				HooverColor.Activate
				
			Else if _bottomButtonState = eButtonState.BUTTON_OVER Then
			
				'SetColor(HooverColor.r, HooverColor.g, HooverColor.b)
				HooverColor.Activate()
				
			Else
			
				'SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
				BackgroundColor.Activate()
				
			EndIf
			
			DrawRect drawPos.X + 2, drawPos.Y + size.Y - _buttonSize, size.X - 4, _buttonSize - 2
			
		End
		
		SetColor(150, 150, 150)
		DrawRect drawPos.X + size.X / 2, drawPos.Y + _buttonSize / 2, 1, 3
		DrawRect drawPos.X + size.X / 2 - 1, drawPos.Y + _buttonSize / 2 + 1, 3, 1
		DrawRect drawPos.X + size.X / 2 - 2, drawPos.Y + _buttonSize / 2 + 2, 5, 1
		DrawRect drawPos.X + size.X / 2, drawPos.Y + size.Y - _buttonSize / 2 - 1, 1, 1
		DrawRect drawPos.X + size.X / 2 - 1, drawPos.Y + size.Y - _buttonSize / 2 - 1 - 1, 3, 1
		DrawRect drawPos.X + size.X / 2 - 2, drawPos.Y + size.Y - _buttonSize / 2 - 1 - 2, 5, 1

		' fader
		
		'SetColor(BorderColor.r, BorderColor.g, BorderColor.b)
		BorderColor.Activate()
		DrawRect drawPos.X + 1, drawPos.Y + _faderPosition, size.X - 2, _faderSize
		
		if _middleButtonState = eButtonState.BUTTON_DOWN Then
			'SetColor(HooverColor.r, HooverColor.g, HooverColor.b)
			HooverColor.Activate()
		Else if _middleButtonState = eButtonState.BUTTON_OVER Then
			'SetColor(HooverColor.r, HooverColor.g, HooverColor.b)
			HooverColor.Activate()
		Else
			'SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
			BackgroundColor.Activate()
		EndIf
			
		DrawRect drawPos.X + 2, drawPos.Y + _faderPosition + 1, size.X - 4, _faderSize - 2
		SetColor 255, 255, 255
	End
	
	
	#Rem monkeydoc
		This has to be called whenever a MouseUp operation is done inside the ScrollBarContainer rendering region.
	#END
	Method MouseUp(e:MouseEventArgs)
	
		Local x:Float = e.position.X' - _pos.X
		Local y:Float = e.position.Y' - _pos.Y
		
		_topButtonState = (y < _buttonSize)
		_bottomButtonState = (y > _size.Y - _buttonSize And y < _size.Y)
		_middleButtonState = (y > _faderPosition And y < _faderPosition + _faderSize)
		
		if x < _pos.X or x > _pos.X + _size.X Then
			MouseLeave()
		EndIf
		
		_fastMove = False
		_mouseDown = false
	End

	#Rem monkeydoc
		This has to be called whenever a MouseLeave operation is done inside the ScrollBarContainer rendering region.
	#END
	Method MouseLeave()
		
		_mouseOver = True
		
		If _topButtonState <> eButtonState.BUTTON_DOWN
			_topButtonState = eButtonState.BUTTON_UP
		End
		
		If _middleButtonState <> eButtonState.BUTTON_DOWN
			_middleButtonState = eButtonState.BUTTON_UP
		End
		
		If _bottomButtonState <> eButtonState.BUTTON_DOWN
			_bottomButtonState = eButtonState.BUTTON_UP
		End
		
		_mouseOver = not (_topButtonState = eButtonState.BUTTON_UP And
						_middleButtonState = eButtonState.BUTTON_UP And
							_bottomButtonState = eButtonState.BUTTON_UP)
	
	End
	
	#Rem monkeydoc
		This has to be called whenever a MouseEnter operation is done inside the ScrollBarContainer rendering region.
	#END
	Method MouseEnter()
		_mouseOver = true
	End
	
	#Rem monkeydoc
		This has to be called whenever a MouseMove operation is done inside the ScrollBarContainer rendering region.
	#END
	Method MouseMove(e:MouseEventArgs)
	
		Local x:Float = e.position.X' - _pos.X
		Local y:Float = e.position.Y '- _pos.Y
	
		if _middleButtonState <> eButtonState.BUTTON_DOWN and
		 		(x < _pos.X or x > _pos.X + _size.X) Then
			MouseLeave()
			Return
		End
		
		If _topButtonState <> eButtonState.BUTTON_DOWN
			_topButtonState = (y < _buttonSize)
		End
		
		If _bottomButtonState <> eButtonState.BUTTON_DOWN
			_bottomButtonState = (y > _size.Y - _buttonSize And y < _size.Y)
		End
				
		If _middleButtonState = eButtonState.BUTTON_DOWN Then
			
			_bottomButtonState = eButtonState.BUTTON_UP
			_topButtonState = eButtonState.BUTTON_UP
			
			' set new fader position
			Local max:Float = _size.Y - _buttonSize - 2 - _faderSize
			Local min:Float = _buttonSize + 2
			_faderPosition = int(Min(max, Max(min, y - _dragOrigin.Y)))
			
			' Converts  the current fader position to value
			Local length:Float = Abs(max - min)
			Local relPos:Float = float(_faderPosition - _buttonSize - 2) / length
			Local newVal:= float(_maximum - _minimum) * relPos + _minimum
			
			if _scrollMode = eScrollMode.Smooth Then
				_value = newVal
			Else
				Value = newVal
			End
		
		Else

			if Not (_topButtonState = eButtonState.BUTTON_DOWN Or
			   _bottomButtonState = eButtonState.BUTTON_DOWN) Then
			   
				_middleButtonState = (y > _faderPosition And y < _faderPosition + _faderSize)
			End

		End
			
	End

	#Rem monkeydoc
		This has to be called whenever a MouseDown or TouchDown operation is done inside the ScrollBarContainer rendering region.
	#END
	Method MouseDown(e:MouseEventArgs)

		Local x:Float = e.position.X' - _pos.X
		Local y:Float = e.position.Y' - _pos.Y

		if x < _pos.X or x > _pos.X + _size.X Then
			MouseLeave()
			Return
		End
		
		' if mouse over top button
		if _mouseOver and y < 15 Then
		
			' if the mouse had not been down
			If not _mouseDown And _topButtonState <> 2
				_topButtonState = 2
				Value -= _smallChange
				UpdateFaderPosition(_size)
				_delay.Reset(_longDelay)
				
			' if mouse has already been down and was pressed longer than 750ms
			Else if _delay.Value < 0 Then
				Value -= _smallChange
				UpdateFaderPosition(_size)
				_delay.Reset(_shortDelay)
			End
		
		' if mouse over bottom button
		Else If _mouseOver and y > _size.Y - 15 And y < _size.Y Then

			' if the mouse had not been down
			If not _mouseDown And _bottomButtonState <> 2
				_bottomButtonState = 2
				Value += _smallChange
				UpdateFaderPosition(_size)
				_delay.Reset(_longDelay)
				
			' if mouse has already been down and was pressed longer than 750ms
			Else if _delay.Value < 0 Then
				Value += _smallChange
				UpdateFaderPosition(_size)
				_delay.Reset(_shortDelay)
			End
			
		' if mouse over fader
		else If _mouseOver And y > _faderPosition And y < _faderPosition + _faderSize Then '
			
			if Not (_topButtonState = eButtonState.BUTTON_DOWN Or
			   _bottomButtonState = eButtonState.BUTTON_DOWN) Then
			   
				' if the mouse had not been down
				If not _mouseDown And _middleButtonState <> 2
					_middleButtonState = 2
					_dragOrigin = New GuiVector2D
					_dragOrigin.SetValues(x, y - _faderPosition)
				End
			End
			
		' Big step
		ElseIf _mouseOver And _middleButtonState <> 2
			
			' if mouse is above fader
			If y <= _faderPosition + _faderSize / 2

				' if scrollbar is not in fastmode yet
				If not _mouseDown And not _fastMove
					_fastMove = true
					Value -= _bigChange
					UpdateFaderPosition(_size)
					_delay.Reset(_longDelay)
					
				' if scrollbar has beed in fastmove mode for longer than 750ms
				Else If _fastMove and _delay.Value < 0
					Value -= _bigChange
					UpdateFaderPosition(_size)
					_delay.Reset(_shortDelay)
				End
				
			' if mouse is under fader
			else
				' if scrollbar is not in fastmode yet
				If not _mouseDown And not _fastMove
					_fastMove = true
					Value += _bigChange
					UpdateFaderPosition(_size)
					_delay.Reset(_longDelay)
					
				' if scrollbar has beed in fastmove mode for longer than 750ms
				Else If _fastMove And _delay.Value < 0
					Value += _bigChange
					UpdateFaderPosition(_size)
					_delay.Reset(_shortDelay)
				End
			End
		End
		
		_mouseDown = True
	End
	
	#Rem monkeydoc
		This property contains the current Value of the ScrollBarContainer.
	#END
	Method Value:Int() Property
		Return _value
	End
	
	Method Value:Void(val:int) Property
		if val < _minimum Then
			_value = _minimum
		Else If val > _maximum Then
			_value = _maximum
		Else
			_value = val
		End
		UpdateFaderPosition()
	End
	
	#Rem monkeydoc
		This method will update the grabber position after a value or size change on the ScrollBarContainer. It has to be called manually.
	#END
	Method UpdateFaderPosition()
		UpdateFaderPosition(_size)
	End
	
	#Rem monkeydoc
		This method will update the grabber position after a value or size change on the ScrollBarContainer. It has to be called manually.
	#END
	Method UpdateFaderPosition(size:GuiVector2D)

		if _minimum = _maximum Then
			_faderPosition = _buttonSize + 2
			Return
		EndIf
		
		' calculate relative value
		local m:Float = 1.0 / float(_maximum - _minimum);
		Local relVal:Float = m * Value - m * _minimum
		
		' set new fader position
		Local length:Float = Abs(size.Y - _buttonSize - _faderSize - _buttonSize - 4)
		_faderPosition = _buttonSize + 2 + length * relVal				
	End
	
	#Rem monkeydoc
		This property returns the number of items contained in the ScrollBarContainer.
	#END
	Method ItemsCount:int() Property
		return _itemsCount
	End
	
	Method ItemsCount:Void(value:int) Property
		if _itemsCount <> value Then
			Local scrollHeight:Float = float(_size.Y - (_buttonSize + 2) * 2)
			_itemsCount = Max(0, value)
			_faderSize = Min(int(scrollHeight), Max(_minFaderSize, int(scrollHeight * _visibleItems / _itemsCount)))
			_minimum = 0
			_maximum = _itemsCount - _visibleItems
			_bigChange = Max(2, _maximum / 5)
		End
	End
	
	#Rem monkeydoc
		This property returns the number of visible items contained in the rendering area of the control where the ScrollBarContainer is rendered.
	#END
	Method VisibleItems:int() Property
		return _visibleItems
	End
	
	Method VisibleItems:Void(value:int) Property
		if _visibleItems <> value Then
			Local scrollHeight:Float = float(_size.Y - (_buttonSize + 2) * 2)
			_visibleItems = Max(0, Min(_itemsCount, value))
			_faderSize = Min(scrollHeight, Max(32.0, scrollHeight * _visibleItems / _itemsCount))
			_minimum = 0
			_maximum = _itemsCount - _visibleItems
			_bigChange = Max(2, _maximum / 5)
		End
	End
	
End

Private
Class Countdown
private
	Field _val%
	Field _timer%
Public 
	Method Reset(val)
		_val = val
		_timer = Millisecs 
	End
	
	Method Value()
		Return  _val - (Millisecs() - _timer)
	End
End
Public
#rem monkeydoc
	This enum-like class contains the list of available states for a scrollbar button.
#END
Class eButtonState 
	Const BUTTON_UP = 0
	Const BUTTON_OVER = 1
	Const BUTTON_DOWN = 2
	Const BUTTON_SELECTED = 4
End


