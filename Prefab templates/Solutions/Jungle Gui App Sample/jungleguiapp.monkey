
'This is required for this monkey document to be able to recieve Events form JungleGui:
Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

Function Main()
	'This will setup Mojo, and everything else required in order to handle the Gui for a simple JungleGui application:
	ExecuteApp(New MyApplication)
End

Class MyApplication Extends WindowFrame

	Field sampleButton:Button
 
	'This is where application contents and properties has to be set:
	Method OnInit()

		Self.Event_ParentResized.Add(Self, "AppCanvasResized")
		
		JungleApp.Event_MojoOnBack.Add(Self, "Application_BackClicked")
		JungleApp.Event_MojoOnClose.Add(Self, "Application_CloseClicked")

		'Add any additional initialization of gui components here:
		
		sampleButton = New Button
		sampleButton.Parent = Self
		sampleButton.Text = "Sample button"
		sampleButton.Position.SetValues(20, 20)
		sampleButton.Event_Click.Add(Self, "Button_Clicked")
		
	End
	
	Method Button_Clicked(sender:Object, e:MouseEventArgs)
		sampleButton.Text = "Button has been clicked!"
	End
	
	Method AppCanvasResized(sender:Object, e:EventArgs)
		'This will make our JungleGui application container to fill the whole application size:
		Local currentGui:= JungleApp.gui
		Self.Position.SetValues(currentGui.DeviceToGuiX(0), currentGui.DeviceToGuiY(0))
		Self.Size.SetValues(currentGui.DeviceToGuiX(DeviceWidth), currentGui.DeviceToGuiY(DeviceHeight))
	End
	
	Method Application_BackClicked(sender:Object, e:CancelableEvent)
		Print "Back clicked!"
		e.cancel = True	'Prevent the App from going "back"
	End
	
	Method Application_CloseClicked(sender:Object, e:CancelableEvent)
	
		Print "Tried to close application!"
		e.cancel = True	'This is to prevent the App from closing.
	
	End
	
		
End
