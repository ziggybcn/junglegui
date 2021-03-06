Import junglegui
#REFLECTION_FILTER+="${MODPATH}"


Class SliderSample Extends Form

	Field red:Slider
	Field green:Slider
	Field blue:Slider

	Field panel:Panel
	
	
	
	Method OnInit()
		'''
		''' MyForm
		'''
		Self.Name = "MyForm"
		Self.Text = "Color Mixer"
		Self.Size.SetValues(380, 100)
		Self.BorderStyle = eFormBorder.FIXED
		
		'''
		''' red
		'''
		red = New Slider
		SetSliderValues(red, 0, "red")
		
		'''
		''' green
		'''
		green = New Slider
		SetSliderValues(green, 1, "green")

		'''
		''' blue
		'''
		blue = New Slider
		SetSliderValues(blue, 2, "blue")

		'''
		''' panel
		'''
		panel = New Panel
		panel.Parent = Self
		panel.Position.SetValues(310, 10)
		panel.Size.SetValues(50, 50)
		panel.BorderColor = SystemColors.FormBorder.Clone()
		panel.Name = "Color_Panel"
		
		panel.BackgroundColor = New GuiColor
		panel.BackgroundColor.SetColor(1, red.Value, green.Value, blue.Value)
		
	End
	
	Method SetSliderValues(slider:Slider, Index:Int, name:String)
		slider.Position.SetValues(70, 10 + Index * 20)
		slider.Parent = Self
		slider.Name = name
		slider.Maximum = 100
		slider.Size.SetValues(230, 10)
		slider.Maximum = 255
		slider.Value = 255
		slider.Event_ValueChanged.Add(Self, "Slider_Value_Changed")
		
		Local label:= New Label
		label.Parent = self
		label.Text = name
		label.Position.SetValues(10, 10 + Index * 20)
		
		'We align the label:
		
		label.Position.Y = slider.Position.Y - (label.Size.Y - slider.Size.Y) / 2
		
		'label.Size.Y = 10
		
	End

	Method Slider_Value_Changed(sender:Object, e:EventArgs)
		local slider:= Slider(sender)
		if slider = null Then Return
		Select slider
			Case red
				panel.BackgroundColor.Red = red.Value
				red.TipText = "Red has a value of " + red.Value
			Case green
				panel.BackgroundColor.Green = green.Value
				green.TipText = "Green has a value of " + green.Value
			Case blue
				panel.BackgroundColor.Blue = blue.Value
				blue.TipText = "Blue has a value of " + blue.Value
		End
	end
	
End