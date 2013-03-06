Import junglegui

Function ExecuteApp(context:Object, initializeMethodName:String)

	Local JungleGuiApp:= New JungleGuiApplication
	JungleGuiApp._event_Instantiate.Add(context, initializeMethodName)
End


Class JungleGuiApplication Extends App
	Field mainForm:TopLevelControl
	Global gui:Gui
	Method OnCreate()
		SetUpdateRate(60)
		gui = New Gui
		Local appEvent:= New InitializeAppEvent
		_event_Instantiate.RaiseEvent(Self, appEvent)
		
		mainForm = appEvent.mainForm
		If mainForm = Null Then Error("Application could not be initialized becouse there was no MainForm associated. Be sure to add a TopLevelControl instance to mainForm field of the InitializeAppEvent instance.")
		
		mainForm.InitForm(gui)
	End
	Method OnUpdate()
		gui.Update()
		If mainForm.GetGui = Null Then Error("")
	End
	
	Method OnRender()
		Cls(255, 255, 255)
		gui.Render()
	End
	Private
	Field _event_Instantiate:= New EventHandler<InitializeAppEvent>
	
End

