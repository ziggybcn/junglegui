'This is a very small minimal sample

Import junglegui
#REFLECTION_FILTER="slidersample*|junglegui*"

Function Main()
	New Sample2
End

Global gui:Gui

Class Sample2 extends App

	Field myForm:MyForm
	Method OnCreate()
		SetUpdateRate(60)
		gui = New Gui	'We create the Gui manager.
		myForm = New MyForm
		try
			myForm.InitForm(gui)
		Catch jge:JungleGuiException
			Print "Form could not be initialized becouse of an exception:"
			Print jge.ToString()
		End
	End
	
	Method OnUpdate()
		try
			gui.Update()
		Catch jge:JungleGuiException
			Print "Error updating the Gui component:"
			Print jge.ToString()
			Error(jge.ToString())
		end
	End
	
	Method OnRender()
		Cls(255, 255, 255)
		try
			gui.Render()
		Catch jge:JungleGuiException
			Print "Error rendering the Gui component:"
			Print jge.ToString()
			Error(jge.ToString())
		end
	End
End

Class MyForm extends Form

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
		panel.BackgroundColor.SetColor(1, red.Value, green.Value, blue.Value)
		
	End
	
	Method SetSliderValues(slider:Slider, Index:Int, name:String)
		slider.Position.SetValues(10, 10 + Index * 20)
		slider.Parent = Self
		slider.Name = name
		slider.Max = 100
		slider.Size.SetValues(280, 10)
		slider.Max = 255
		slider.Value = 255
		Events.Add(slider, eEventKinds.SLIDING_VALUE_CHANGED, "Slider_Value_Changed")
		
	End

	Method Slider_Value_Changed(sender:Control, e:EventArgs)
		local slider:= Slider(sender)
		if slider = null Then Return
		Select slider
			Case red
				panel.BackgroundColor.r = red.Value
			Case green
				panel.BackgroundColor.g = green.Value
			Case blue
				panel.BackgroundColor.b = blue.Value
		End
	end
	
End