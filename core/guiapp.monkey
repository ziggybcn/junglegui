Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

Function ExecuteApp:JungleGuiApplication(context:Object, initializeMethodName:String)

	Local JungleGuiApp:= New JungleGuiApplication
	JungleGuiApp._event_Instantiate.Add(context, initializeMethodName)
	Return JungleGuiApp
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
		_event_MojoOnUpdate.RaiseEvent(Self, emptyEventArgs)
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
	Method Event_MojoOnUpdate:EventHandler<EventArgs>() Property
		Return _event_MojoOnUpdate
	End
	Method Event_MojoOnSuspend:EventHandler<EventArgs>() Property
		Return _event_MojoOnSuspend
	End
	
	Method Event_MojoOnResume:EventHandler<EventArgs>() Property
		Return _event_MojoOnResume
	End
	
	Method Event_MojoOnBack:EventHandler<CancelableEvent>() Property
		Return _event_MojoOnBack
	End

	Method Event_MojoOnClose:EventHandler<CancelableEvent>() Property
		Return _event_MojoOnClose
	End
	Method OnSuspend()
		 _event_MojoOnSuspend.RaiseEvent(Self, emptyEventArgs)
	End
	
	Method OnResume()
		_event_MojoOnResume.RaiseEvent(Self, emptyEventArgs)
	End
	
	Method OnBack()
		Local ce:= New CancelableEvent
		ce.cancel = False
		_event_MojoOnBack.RaiseEvent(Self, ce)
		If ce.cancel = False Then
			Return Super.OnBack()
		Else
			Return 0
		EndIf
	End
	
	Method OnClose()
		Local ce:= New CancelableEvent
		ce.cancel = False
		_event_MojoOnClose.RaiseEvent(Self, ce)
		If ce.cancel = False Then
			Return Super.OnClose()
		Else
			Return 0
		EndIf
		
	End
	
	Private
	Field _event_Instantiate:= New EventHandler<InitializeAppEvent>
	Field _event_RenderBack:= New EventHandler<EventArgs>
	
	Field _event_MojoOnUpdate:= New EventHandler<EventArgs>
	Field _event_MojoOnLoading:= New EventHandler<EventArgs>
	Field _event_MojoOnSuspend:= New EventHandler<EventArgs>
	Field _event_MojoOnResume:= New EventHandler<EventArgs>
	Field _event_MojoOnBack:= New EventHandler<CancelableEvent>
	Field _event_MojoOnClose:= New EventHandler<CancelableEvent>
	
	
	
	Field mainForm:TopLevelControl
	Field emptyEventArgs:= New EventArgs
	Field transparent:Bool = False
End

Function ExecuteApp:JungleGuiApplication(mainAppContainer:TopLevelControl)
	 
	Local context:= New AppLauncher(mainAppContainer)
	Return ExecuteApp(context, "LaunchApp")
	
End
Private
Class AppLauncher Final
	Field mainContainer:TopLevelControl
	Method New(mainContainer:TopLevelControl)
		Self.mainContainer = mainContainer
	End
	Method LaunchApp(sender:Object, e:eventargs.InitializeAppEvent)
		e.mainForm = mainContainer
	End
End
