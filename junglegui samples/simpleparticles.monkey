Import particlessample

Class Emiter
	Field position:GuiVector2D
	Field stars:= New List<Particle>
	Field desiredParticles:Int = 100
	Field particleColor:= New GuiColor(1, 255, 255, 255)
	Field count:Int = 0
	Method Update()
		position.SetValues(DeviceWidth / 2, DeviceHeight / 2)
		Local node:list.Node<Particle>
		count = 0
		node = stars.FirstNode()
		While node <> null And node.NextNode <> null
			Local p:Particle = node.Value
			count += 1
			if p.Update(Self) = Particle.DIE Then
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
		speed = Rnd(0.5, 3)
	End

	Method Draw(parent:Emiter)
		color.Activate()
		'DrawPoint(parent.position.X + x, parent.position.Y + y)
		DrawCircle(parent.position.X + x, parent.position.Y + y, 1 * (1 + speed))
	End
	
	Method Update:Int(parent:Emiter)
		x = x * (1 + speed / 100.0)
		y = y * (1 + speed / 100.0)
		
		if(x + parent.position.X) > DeviceWidth or (x + parent.position.X) < 0 Then Return Particle.DIE
		if(y + parent.position.Y > DeviceHeight) or (y + parent.position.Y < 0) Then Return Particle.DIE
		Return Particle.OK
	End
	
	Const DIE:Int = 1
	Const OK:Int = 2
End