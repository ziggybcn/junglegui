Import junglegui

'This is required by the Events system to work on any file with event handling methods:
#REFLECTION_FILTER+="${MODPATH}"


Class MyForm Extends Form

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
		
		Self.Text = "Untitled dialog"
		Self.Event_Resized.Add(Self, "Form_Resized_Handler")
		
		DoLayout()
		
	End
	
	'This method handles the Form Resized event, 
	Method Form_Resized_Handler(sender:Object, e:EventArgs)
		'Calculate controls layout here:
		DoLayout
	End
	
	Method OkButton_Click_Handler(sender:Object, e:MouseEventArgs)
		'code to be done when the button is clicked or touched:
		
	End
	
	Method DoLayout()
		'Center the sample button at the bottom of the dialog:
		okButton.Position.X = Self.ClientSize.X / 2 - okButton.Size.X / 2
		okButton.Position.Y = Self.ClientSize.Y - okButton.Size.Y
	End


End