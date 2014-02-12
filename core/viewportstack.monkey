#rem monkeydoc Module junglegui.viewportstack
	
#END
Import junglegui

#rem monkeydoc
	This is a ViewPort stack. This Stack contains a stack of viewports that can be used to calculate rendering areas on parent/child rendering clip areas.
#END 
Class ViewPortStack Extends Stack<ViewPort>
	
End


#Rem
	This is a ViewPort. This class represents a rendering clipping area.
#END
Class ViewPort
	#rem monkeydoc
		This field contains the position of the clipping rect into the canvas
	#END
	Field position:= New GuiVector2D
	#rem monkeydoc
		This field contains the size of the clipping rect
	#END
	Field size:= New GuiVector2D
	
	#rem monkeydoc
		This method combines current position and size with the given "parent" clipping rect and stores the result into the boxed result viewPort.
		This is usualy done to calculate what is the part of a control that needs to be drawn on the canvas according to its parent container.
	#END
	Method Calculate:ViewPort(parent:ViewPort, result:ViewPort)
		Local newView:= result 'New ViewPort
		newView.position.X = position.X
		newView.position.Y=position.Y
		newView.size.X = size.X
		newView.size.Y = size.Y 
		
		if parent.position.X>newView.position.X Then 
			newView.size.X -= parent.position.X -newView.position.X
			newView.position.X = parent.position.X
		endif
		if parent.position.Y>newView.position.Y Then 
			newView.size.Y -= parent.position.Y -newView.position.Y
			newView.position.Y = parent.position.Y
		endif
		
		If newView.position.X + newView.size.X > parent.position.X + parent.size.X Then
			newView.size.X = parent.position.X + parent.size.X - newView.position.X
		EndIf
		
		if newView.position.Y + newView.size.Y > parent.position.Y + parent.size.Y Then
			newView.size.Y = parent.position.Y + parent.size.Y - newView.position.Y
		EndIf
		Return newView
	End
	
	#rem monkeydoc
		This method will fill the position and size fields using a control position and size properties.
	#END
	Method SetValuesFromControl(control:Control)
		position = control.UnsafeRenderPosition().Clone()
		'size = New GuiVector2D
		size.SetValues(control.Size.X,control.Size.Y)
	End
 
	
	#rem monkeydoc
		This method will fill the position and size fields using a control position, size and padding properties.
	#END
	Method SetValuesFromControl(control:ContainerControl, padding:Padding, controlBorderSize:Padding)
		position = control.UnsafeRenderPosition().Clone()
		position.X += control.Padding.Left + controlBorderSize.Left
		position.Y += control.Padding.Top + controlBorderSize.Top
		'size = New GuiVector2D
		size.SetValues(control.Size.X,control.Size.Y)
		size.X -= (control.Padding.Right + controlBorderSize.Right + control.Padding.Left + controlBorderSize.Left)
		size.Y -= (control.Padding.Bottom + controlBorderSize.Bottom + control.Padding.Top + controlBorderSize.Top)
	End
	
	
	
End