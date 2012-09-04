Import particlessample
Class ToolBox extends form.Form
	Field particlesCount:Label
	Field explosionButton:Button
	
	Field desiredStars:TrackBar
	
	Field colorR:Slider
	Field colorG:Slider
	Field colorB:Slider
	
	Field shapeKind:ListBox
	
	Field randomizeColors:CheckBox
	Field word:TextField
	
	'Field msgInspector:ListBox
	Field debugForm:DebugForm
	
	Method OnInit()
		Local height:Int = 0
		'SELF:
		Self.Text = "Toolbox"
		Self.Size.X = 200
		Self.Size.Y = 400
		Self.Position.X = DeviceWidth - Self.Size.X - 20
		Self.TipText = "This is jsut a sample toolbar"
		Self.Event_ParentResized.Add(Self, "Canvas_Resized")
		Self.Name = "ToolBox"
		
		'''
		''' starCount
		'''
		particlesCount = New Label
		particlesCount.Parent = self
		particlesCount.Text = "Particles: ??"
		particlesCount.AutoAdjustSize = false
		particlesCount.Position.X = 10
		particlesCount.Position.Y = 10
		particlesCount.Size.X = Self.Size.X - Self.Padding.Left - Self.Padding.Right
		particlesCount.TipText = "This label shows the amount of used particles."
		particlesCount.Name = "particlesCount"
		height = GetNextHeight(particlesCount)
		
		'''
		'''explosionButton
		'''
		explosionButton = New Button
		explosionButton.Parent = self
		explosionButton.Text = "Explosion!"
		explosionButton.Size.Y = explosionButton.Font.GetFontHeight()
		explosionButton.Position.SetValues(10, height)
		explosionButton.Event_Click.Add(Self, "Explossion_Clicked")
		explosionButton.TipText = "Click here to generate an explosion"
		explosionButton.Name = "explosionButton"
		height = GetNextHeight(explosionButton)
		
		'''
		'''desiredStars
		'''
		Local tmpLabel:Label = New Label
		tmpLabel.Parent = self
		tmpLabel.Position.SetValues(10, height)
		tmpLabel.Text = "count:"
		tmpLabel.Name = "CountLabel"
		desiredStars = New TrackBar
		desiredStars.Parent = self
		desiredStars.Position.SetValues(tmpLabel.Position.X + tmpLabel.Size.X, height)
		desiredStars.Maximum = 500
		desiredStars.Minimum = 1
		height = GetNextHeight(desiredStars)
		desiredStars.Event_ValueChanged.Add(Self, "Desired_Changed")
		desiredStars.Value = 100
		desiredStars.Tickfrequency = 50
		desiredStars.Size.X = self.Size.X - desiredStars.Position.X - 10
		desiredStars.TipText = "This is the amount of desired particles."
		desiredStars.Name = "DesiredStars"
		

		'''
		''' red
		'''
		colorR = New Slider
		SetSliderValues(colorR, 0, "red", height)
		
		'''
		''' green
		'''
		colorG = New Slider
		SetSliderValues(colorG, 1, "green", height)

		'''
		''' blue
		'''
		colorB = New Slider
		SetSliderValues(colorB, 2, "blue", height)

		height = GetNextHeight(colorB)
		
				
		shapeKind = New ListBox(10, height, Self.Size.X - Self.Padding.Left - Self.Padding.Right - 20, 100, self)
		shapeKind.Items.AddLast("Round")
		shapeKind.Items.AddLast("Square")
		shapeKind.Items.AddLast("Dot")
		shapeKind.Items.AddLast("Round")
		shapeKind.Items.AddLast("Square")
		shapeKind.Items.AddLast("Dot")

		shapeKind.SelectedIndex = 0
		shapeKind.Event_SelectedIndexChanged.Add(Self, "ShapeKind_Selected_Changed")
		shapeKind.Name = "ShapeKind"

		height = GetNextHeight(shapeKind)
		
		'''
		'''Randomize
		'''
		randomizeColors = New CheckBox
		randomizeColors.Parent = Self
		randomizeColors.Text = "Randomize colors"
		randomizeColors.TipText = "Enable or disable randomize colors for particles"
		randomizeColors.Position.SetValues(10, height)
		randomizeColors.Size.Y = 18
		randomizeColors.Event_Click.Add(Self, "Randomize_Clicked")
		randomizeColors.Event_CheckedChanged.Add(Self, "Randomize_Checked_Changed")
		randomizeColors.Name = "RandomizeColors"
		height = GetNextHeight(randomizeColors)
		
		tmpLabel = New Label
		tmpLabel.Parent = self
		tmpLabel.Position.SetValues(10, height)
		tmpLabel.Text = "word:"
		tmpLabel.Name = "LabelWord"
		
		word = New TextField
		word.Parent = Self
		word.Position.Y = tmpLabel.Position.Y
		word.Position.X = tmpLabel.Position.X + tmpLabel.Size.X + 10
		word.Size.X = Self.Size.X - Self.Padding.Left - Self.Padding.Right - tmpLabel.Size.X - tmpLabel.Position.X * 2
		word.AutoAdjustSize = false
		word.Size.Y = tmpLabel.Size.Y
		word.Name = "Word"
		height = GetNextHeight(tmpLabel)
'
'		'''
'		''' MsgInspector
'		'''
'		msgInspector = New ListBox
'		msgInspector.Parent = Self
'		msgInspector.Position.SetValues(10, height)
'		msgInspector.Size.SetValues(Self.Size.X - Self.Padding.Left - Self.Padding.Right - msgInspector.Position.X + 2, 100)
'		msgInspector.Items.AddLast(New ListItem("Ready!"))		
'		height = GetNextHeight(msgInspector)
	
		'''
		''' Form size:
		'''
		Self.Size.Y = height + Padding.Top + Padding.Bottom
	End
	
	
	Method GetNextHeight(control:Control)
		Const Margin:Int = 5
		Return control.Position.Y + control.Size.Y + Margin
	End
	
	
	Method SetSliderValues(slider:Slider, Index:Int, name:String, height:Int)
		slider.Position.SetValues(70, height + Index * 20)
		slider.Parent = Self
		slider.Name = name
		slider.Maximum = 100
		slider.Size.SetValues(Self.Size.X - 70 - 10 - Self.Padding.Left - Self.Padding.Right, 15)
		slider.Maximum = 255
		slider.Value = 255
		slider.Event_ValueChanged.Add(Self, "Slider_Value_Changed")
		Local label:= New Label
		label.Parent = self
		label.Text = name
		label.Position.SetValues(10, height + Index * 20)
		label.Name = "Label" + name
		
		'We align the label:
		
		label.Position.Y = slider.Position.Y - (label.Size.Y - slider.Size.Y) / 2
		
		'label.Size.Y = 10
		
	End
	
	Method Explossion_Clicked(sender:Object, e:MouseEventArgs)
		For Local i:Int = 0 to 200
			Local particle:= New Particle(particlessample.ParticlesSample.emiter)
			particlessample.ParticlesSample.emiter.stars.AddLast(particle)
		next
	End
	
	Method Slider_Value_Changed(sender:Object, e:EventArgs)
		local slider:= Slider(sender)
		if slider = null Then Return
		Select slider
			Case colorR
				particlessample.ParticlesSample.emiter.particleColor.r = colorR.Value
				colorR.TipText = "Red has a value of " + colorR.Value
			Case colorG
				particlessample.ParticlesSample.emiter.particleColor.g = colorG.Value
				colorG.TipText = "Green has a value of " + colorG.Value
			Case colorB
				particlessample.ParticlesSample.emiter.particleColor.b = colorB.Value
				colorB.TipText = "Blue has a value of " + colorB.Value
		End

	End
	
	Method Desired_Changed(sender:Object, e:EventArgs)
		if particlessample.ParticlesSample <> null then particlessample.ParticlesSample.emiter.desiredParticles = desiredStars.Value
	End
	
	Method Canvas_Resized(sender:Object, e:EventArgs)
		if Self.Position.X > DeviceWidth - Self.Size.X - 10 Then Self.Position.X = DeviceWidth - Self.Size.X - 10
		if Self.Position.Y > DeviceHeight - Self.Size.Y - 10 Then Self.Position.Y = DeviceHeight - Self.Size.Y - 10
	End
	
	Method ShapeKind_Selected_Changed(sender:Object, e:EventArgs)
		if shapeKind.SelectedItem = null Then
			shapeKind.SelectedItem = shapeKind.Items.First()
		else
			Select shapeKind.SelectedItem.Text
				Case "Round"
					ParticlesSample.emiter.kind = Emiter.KIND_CIRCLE
				Case "Square"
					ParticlesSample.emiter.kind = Emiter.KIND_BOX
				Case "Dot"
					ParticlesSample.emiter.kind = Emiter.KIND_DOT
			End
		endif
	End
	
	Method Randomize_Clicked(sender:Object, e:MouseEventArgs)
		randomizeColors.Checked = Not randomizeColors.Checked
	End
	
	Method Randomize_Checked_Changed(sender:Object, e:EventArgs)
		ParticlesSample.emiter.randomizeColors = randomizeColors.Checked
	End
	
	Method Msg(msg:BoxedMsg)
		Super.Msg(msg)
		If debugForm = null And GetGui <> Null Then
			'DebugStop 
			debugForm = New DebugForm
			debugForm.InitForm(GetGui)
		endif
		if debugForm <> null then
			debugForm.ShowDebugMsg(msg)
		endif
	End
	
	
End
