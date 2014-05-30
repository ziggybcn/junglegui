Import junglegui

'This is required by the Events system to work on any file with event handling methods:
#REFLECTION_FILTER+="${MODPATH}"


Class MainGuiPanel Extends WindowFrame

	Field okButton:Button

	'This method is called when the Form needs to initialize its conained components:
	Method OnInit()
		
		'Create an initialize the Ok button:
		okButton = New Button
		okButton.AutoAdjustSize = False
		okButton.Parent = Self
		okButton.Text = "Ok"
		okButton.Size.SetValues(200, okButton.Font.GetFontHeight + 20)
		okButton.Event_Click.Add(Self, "OkButton_Click_Handler")
		

		Self.Transparent = True
		Self.Event_ParentResized.Add(Self, "CanvasResized_Handler")
		Self.Event_Resized.Add(Self, "Dialog_Resized_Handler")
		
		DoLayout()
		
	End
	
	'This method handles the Canvas Resized event:
	Method CanvasResized_Handler(sender:Object, e:EventArgs)

		'We scale the gui to fill the complete game graphical context
		Self.Position.SetValues(0, 0)
		Self.Size.SetValues(GetGui.DeviceToGuiX(DeviceWidth), GetGui.DeviceToGuiY(DeviceHeight))
				
	End
	
	'This method handles the dialog resized event:
	Method Dialog_Resized_Handler(sender:Object, e:EventArgs)
		DoLayout()
	End
	
	Method OkButton_Click_Handler(sender:Object, e:MouseEventArgs)
		'code to be done when the button is clicked or touched:
		
	End
	
	'Calculate all components re-position here:
	Method DoLayout()

		'Center the sample button at the bottom of the dialog:
		okButton.Position.X = Self.ClientSize.X / 2 - okButton.Size.X / 2
		okButton.Position.Y = Self.ClientSize.Y - okButton.Size.Y
	End


End