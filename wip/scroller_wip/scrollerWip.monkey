Import junglegui
Import reflection
#REFLECTION_FILTER+="${MODPATH}"


#IF TARGET="glfw"
Extern
    'Function glfwInit:Int()
    Function glfwOpenWindowHint:Void(target:Int, hint:Int)
    Function glfwSetWindowSize:Void(width:Int, height:Int)
    Function glfwSetWindowPos:Void(x:Int, y:Int)
    'Function glfwOpenWindow:Int(width:Int, height:Int, redbits:Int, greenbits:Int, bluebits:Int, alphabits:Int, depthbits:Int, stencilbits:Int, mode:Int )
	Public
	Const GL_TRUE:Int = 1
	Const GL_FALSE:Int = 0
	
	Const GLFW_STEREO:Int           = $00020011
	Const GLFW_WINDOW_NO_RESIZE:Int = $00020012
	Const GLFW_FSAA_SAMPLES:Int     = $00020013
	Const GLFW_FULLSCREEN:Int       = $00010002
#END




Function Main()
	#if TARGET="glfw"
    glfwOpenWindowHint(GLFW_FSAA_SAMPLES, 8) ' AntiAliasing samples: 0 = disable AA
	#end
	New MyApp
End

Class MyApp Extends App
	Global gui:Gui
	Method OnCreate()
		SetUpdateRate(60)
		#if TARGET="glfw"
        'glfwSetWindowPos(0, 0)        ' set window position
        'glfwSetWindowSize(1280, 1024) ' resize window
		#end
		gui = New Gui
		
		Local f:= New TestForm
		f.InitForm(gui)
	End
	
	Method OnUpdate()
		gui.Update()
	End
	
	Method OnRender()
		Cls(255, 255, 255)
		gui.Render()
	End
End

Class TestForm Extends Form
	Field scrollable:ScrollableContainer
	
	Field button:Button
	Method OnInit()
		scrollable = New ScrollableContainer
		
		scrollable.Parent = Self
		
		For Local i:Int = 0 To 10
			button = New Button
			button.Parent = scrollable
			button.Text = "Hello!"
			button.Size.X = 180
			button.Size.Y = 130
			button.Position.Y = 0 + i * (button.Size.Y + 10)
		Next
		'Self.Transparent = True
		Self.Event_Resized.Add(Self, "Resized")
		Self.Event_Resized.RaiseEvent(Self, Null)
	End
	
	Method Resized(sender:Object, e:EventArgs)
		Self.GetClientAreaSize.CloneHere(scrollable.Size)
	End
End
