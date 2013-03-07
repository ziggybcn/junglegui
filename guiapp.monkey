Import junglegui

Function ExecuteApp(context:Object, initializeMethodName:String)

	Local JungleGuiApp:= New JungleGuiApplication
	JungleGuiApp._event_Instantiate.Add(context, initializeMethodName)
End

Global JungleApp:JungleGuiApplication


Class JungleGuiApplication Extends App
	Global gui:Gui
	
	Method New()
		If JungleApp <> Null Then Error("Only a jungle gui application can be executed")
		JungleApp = Self
	End
	
	Method OnCreate()
		SetUpdateRate(60)
		gui = New Gui
		Local appEvent:= New InitializeAppEvent
	
		'We raise the initialize form event here:
		_event_Instantiate.RaiseEvent(Self, appEvent)
		
		'We check that the event has set a proper mainForm:
		mainForm = appEvent.mainForm
		If mainForm = Null Then Error("Application could not be initialized becouse there was no MainForm associated. Be sure to add a TopLevelControl instance to mainForm field of the InitializeAppEvent instance.")
		
		'We init the mainform:
		mainForm.InitForm(gui)
	End
	Method OnUpdate()
		gui.Update()

		'If the mainform is closed, we end the app:
		If mainForm.GetGui = Null Then Error("")
	End
	
	Method OnRender()

		If Not Transparent Then Cls(255, 255, 255)
		_event_RenderBack.RaiseEvent(Self, emptyEventArgs)
		gui.Render()
	End
	
	'Summary: Set this property to try/false to force this Jungle Gui application a white background.
	Method Transparent:Bool() Property
		Return transparent
	End
	
	Method Transparent:Void(value:Bool) Property
		transparent = value
	End
	
	Method MainForm:TopLevelControl() Property
		Return mainForm
	End
	
	Method Event_RenderBackground:EventHandler<EventArgs>() Property
		Return _event_RenderBack
	End
	Private
	Field _event_Instantiate:= New EventHandler<InitializeAppEvent>
	Field _event_RenderBack:= New EventHandler<EventArgs>
	Field mainForm:TopLevelControl
	Field emptyEventArgs:= New EventArgs
	Field transparent:Bool = False
End

