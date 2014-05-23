Import junglegui
Import gui_elements.myform

'This is required for this document to be able to recieve events
#REFLECTION_FILTER+="${MODPATH}"

Function Main()
	New Game()
End

Class Game Extends App


	'summary:The OnCreate Method is called when mojo has been initialized and the application has been successfully created.
	Method OnCreate()
	
		'Set how many times per second the game should update and render itself
		SetUpdateRate(60)

		'We create a global gui instance. This will handle all gui elements:
		JungleGuiApplication.gui = New Gui
		
		InitializeJungleGuiElements()
		
	End
	
	Method InitializeJungleGuiElements:Void()
		'Create any forms or JungleGui elements here:
		Local form:= New MyForm
		form.InitForm(JungleGuiApplication.gui)
	End
	
	'summary: This method is automatically called when the application's update timer ticks. 
	Method OnUpdate()
		JungleGuiApplication.gui.Update()
	End
	
	'summary: This method is automatically called when the application should render itself, such as when the application first starts, or following an OnUpdate call. 
	Method OnRender()
		Cls()
		
		JungleGuiApplication.gui.Render()
		
		
	End

	'summary: This method is called instead of OnRender when the application should render itself, but there are still resources such as images or sounds in the process of being loaded. 
	Method OnLoading()
		
	End
	
	'summary: This method is called when the application's device window size changes. 
	Method OnResize()
		
	End
	
	'#REGION Code to handle susped status of the game goes here
	
	'summary: OnSuspend is called when your application is about to be suspended. 
	Method OnSuspend()
	
	End
	
	'summary: OnResume is called when your application is made active again after having been in a suspended state. 
	Method OnResume()
		
	End	
	'#END REGION
	
	'#REGION Code to handle game closing goes here:
	
	'summary: This method is called when the application's 'close' button is pressed. 
	Method OnClose()
		Super.OnClose()
	End

	'summary:This method is called when the application's 'back' button is pressed. 
	Method OnBack()
		Super.OnBack()
	End
	
	'#END REGION

End