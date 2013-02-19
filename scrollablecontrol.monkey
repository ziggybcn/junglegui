Import junglegui

Class ScrollableControl extends ContainerControl
	
	Global _cachedPosition:= New GuiVector2D
		
	Field _scrollbar:= new ScrollBarContainer
	Field _scrollbarVisible:Bool = true
	
	Method ScrollbarVisible:Bool()
		Return _scrollbarVisible
	End
	
	Method Update()
		if _scrollbar._mouseDown 'And ScrollbarVisible Then

			if _scrollbar._fastMove Or _scrollbar._topButtonState = eButtonState.BUTTON_DOWN Or _scrollbar._bottomButtonState = eButtonState.BUTTON_DOWN Then
				
				Local calculateRenderPos:= self.CalculateRenderPosition
				_cachedPosition.X = GetGui.MousePos.X - calculateRenderPos.X
				_cachedPosition.Y = GetGui.MousePos.Y - calculateRenderPos.Y
				_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y - 2)
				_scrollbar._pos.SetValues(Size.X - _scrollbar.DefaultWidth, 0)
			
				_scrollbar.MouseDown(New MouseEventArgs(eMsgKinds.MOUSE_DOWN, _cachedPosition, 0))
			Else
			
				Local calculateRenderPos:= self.CalculateRenderPosition
				_cachedPosition.X = GetGui.MousePos.X - calculateRenderPos.X
				_cachedPosition.Y = GetGui.MousePos.Y - calculateRenderPos.Y
				_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y - 2)
				_scrollbar._pos.SetValues(Size.X - _scrollbar.DefaultWidth, 0)
			
				_scrollbar.MouseMove(New MouseEventArgs(eMsgKinds.MOUSE_MOVE, _cachedPosition, 0))
			EndIf
			
			if Self.HasFocus = False Then Self.GetFocus()
			
		EndIf
		If _scrollbarVisible Then Self.Padding.Right = _scrollbar._size.X
		Super.Update()
	End
	
	
	Method Msg(msg:BoxedMsg)
		Local isChild:Bool = False		
		Local control:= Control(msg.sender)
		If control <> Null And control.Parent = Self Then isChild = True
		If isChild Then
			Select msg.e.messageSignature
				Case eMsgKinds.RESIZED, eMsgKinds.MOVED
					'Scrolling has to be recalculated when a child control changes its size or its location into the parent.
					
			End
		
		ElseIf msg.sender = Self Then
			_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y - 2)
			_scrollbar._pos.SetValues(Size.X - _scrollbar.DefaultWidth + 1, 0)
			
			Select msg.e.messageSignature
			
				Case eMsgKinds.RESIZED, eMsgKinds.MOVED
			
				Case eMsgKinds.MOUSE_MOVE
					If ScrollbarVisible Then
						_scrollbar.MouseEnter()
						_scrollbar.MouseMove(MouseEventArgs(msg.e))
					endif
					
				Case eMsgKinds.MOUSE_UP
					If ScrollbarVisible Then _scrollbar.MouseUp(MouseEventArgs(msg.e))
					
				Case eMsgKinds.MOUSE_DOWN
					
					Local me:= MouseEventArgs(msg.e)
					if ScrollbarVisible And me.position.X >= _scrollbar._pos.X  ' TODO: either completele here or completely in scrollbar
						_scrollbar.MouseDown(me)
					End
				
				Case eMsgKinds.MOUSE_LEAVE
				
					if ScrollbarVisible then _scrollbar.MouseLeave()
					
				Case eMsgKinds.MOUSE_ENTER
				
					if ScrollbarVisible then _scrollbar.MouseEnter()
					
			End
		End
		Super.Msg(msg)
	End

	Method RenderBackground()
		Super.RenderBackground()
		Local drawpos:= CalculateRenderPosition()
		_scrollbar._size.SetValues(_scrollbar.DefaultWidth, Size.Y - 2)
		_scrollbar._pos.SetValues(drawpos.X + Size.X - _scrollbar.DefaultWidth - 1, drawpos.Y + 1)
		If ScrollbarVisible Then
			_scrollbar.Render(_scrollbar._pos, _scrollbar._size)
		EndIf
		
	End
		
End
