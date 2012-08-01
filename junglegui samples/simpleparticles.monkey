Import particlessample

Class Emiter
	Field position:GuiVector2D
	Field stars:= New List<Particle>
	Field desiredParticles:Int = 100
	Field particleColor:= New GuiColor(1, 255, 255, 255)
	Field count:Int = 0
	Field kind:Int
	Field randomizeColors:Bool = false
	Method Update()
		position.SetValues(DeviceWidth / 2, DeviceHeight / 2)
		Local node:list.Node<Particle>
		count = 0
		node = stars.FirstNode()
		While node <> null And node <> null
			Local p:Particle = node.Value
			count += 1
			if p.Update(Self) = Particle.UPDATE_DIE Then
				Local node2:= node
				node = node.NextNode
				node2.Remove
				'Print "particle removed!"
			Else
				node = node.NextNode
			EndIf
		Wend
		while count < desiredParticles
			stars.AddLast(New Particle(Self))
			count += 1
		Wend
	End
	
	Method Draw()
		For local p:Particle = EachIn stars
			p.Draw(self)
		Next
	End 
	Method New()
		position = New GuiVector2D
		position.SetValues(DeviceWidth / 2, DeviceHeight / 2)
	End
	
	Const KIND_CIRCLE:Int = 0
	Const KIND_BOX:Int = 1
	Const KIND_DOT:Int = 2

End

Class Particle
	Field x:Float
	Field y:Float
	Field speed:Float
	Field color:GuiColor
	Method New(parent:Emiter)
		x = Rnd( - 100, 100)
		y = Rnd( - 100, 100)
		color = parent.particleColor.Clone()
		if parent.randomizeColors Then
			color = New GuiColor(1, Rnd(0, 255), Rnd(0, 255), Rnd(0, 255))
		else
			color = parent.particleColor.Clone()
		EndIf
		speed = Rnd(0.5, 3)
	End

	Method Draw(parent:Emiter)
		color.Activate()
		'DrawPoint(parent.position.X + x, parent.position.Y + y)
		Select parent.kind
			Case Emiter.KIND_BOX
				'DrawCircle(parent.position.X + x, parent.position.Y + y, 1 * (1 + speed))
				Local xPos:Int = parent.position.X + x
				Local yPos:Int = parent.position.Y + y
				Local size:Int = 1 * (1 + speed)
				DrawRect(int(xPos - size), int(yPos - size / 2), int(size * 2), int(size * 2))
			Case Emiter.KIND_CIRCLE
				DrawCircle(parent.position.X + x, parent.position.Y + y, 1 * (1 + speed))
			Case Emiter.KIND_DOT
				DrawPoint(int(parent.position.X + x), int(parent.position.Y + y))
		End
	End
	
	Method Update:Int(parent:Emiter)
		x = x * (1 + speed / 100.0)
		y = y * (1 + speed / 100.0)
		
		if(x + parent.position.X) > DeviceWidth or (x + parent.position.X) < 0 Then Return Particle.UPDATE_DIE
		if(y + parent.position.Y > DeviceHeight) or (y + parent.position.Y < 0) Then Return Particle.UPDATE_DIE
		Return Particle.UPDATE_OK
	End
	
	Const UPDATE_DIE:Int = 1
	Const UPDATE_OK:Int = 2
	
End