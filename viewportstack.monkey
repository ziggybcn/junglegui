Import junglegui
Class ViewPortStack
	Field Stack:List<ViewPort> = New List<ViewPort>
End

Class ViewPort
	Field position:=New GuiVector2D 
	Field size:= New GuiVector2D
	Method Calculate:ViewPort(parent:ViewPort)
		Local newView:= New ViewPort
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
		
		if newView.position.X + newView.size.X > parent.position.X + parent.size.X Then
			newView.size.X = parent.position.X + parent.size.X - newView.position.X
		EndIf
		
		if newView.position.Y + newView.size.Y > parent.position.Y + parent.size.Y Then
			newView.size.Y = parent.position.Y + parent.size.Y - newView.position.Y
		EndIf
		Return newView
	End
	
	Method SetValuesFromControl(control:Control)
		position = control.CalculateRenderPosition()
		size = New GuiVector2D
		size.SetValues(control.Size.X,control.Size.Y)
	End

	method SetValuesFromControl(control:ContainerControl,padding:Padding) 
		position = control.CalculateRenderPosition()
		position.X+=control.Padding.Left 
		position.Y+=control.Padding.Top 
		size = New GuiVector2D
		size.SetValues(control.Size.X,control.Size.Y)
		size.X-= (control.Padding.Right + control.Padding.Left)
		size.Y-= (control.Padding.Bottom + control.Padding.Top)
	End
	
End