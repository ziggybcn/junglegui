
'This is required for this monkey document to be able to recieve Events form JungleGui:
Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

Function Main()
	'This will setup Mojo, and everything else required in order to handle the Gui for a simple JungleGui application:
	ExecuteApp(New MyApplication)
End

Class MyApplication Extends WindowFrame

	'This is where application contents and properties has to be set:
	Method OnInit()

		Self.Event_ParentResized.Add(Self, "AppCanvasResized")
		
	End
	
	
	Method AppCanvasResized(sender:Object, e:EventArgs)
		'This will make our JungleGui application container to fill the whole application size:
		Local currentGui:= JungleApp.gui
		Self.Position.SetValues(currentGui.DeviceToGuiX(0), currentGui.DeviceToGuiY(0))
		Self.Size.SetValues(currentGui.DeviceToGuiX(DeviceWidth), currentGui.DeviceToGuiY(DeviceHeight))
	End
			
End
