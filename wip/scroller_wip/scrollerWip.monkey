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
		'For Local i:Int = 0 To 10
			Local f:= New TestForm
			f.InitForm(gui)
		'Next
	End
	
	Method OnUpdate()
		gui.Update()
	End
	
	Method OnRender()
		Cls(155, 155, 155)
		gui.Render()
	End
End

Class TestForm Extends Form
	Field scrollable:ScrollableContainer
	
	Field button:Button
	
	Field list:ListBox
	Field panel:Panel
	Method OnInit()
	
		panel = New Panel
		panel.Parent = Self
		panel.Padding.SetAll(5, 5, 5, 5)
		scrollable = New ScrollableContainer
		
		scrollable.Parent = panel 'Self
		scrollable.DrawFocusRect = False
		For Local i:Int = 0 To 100
			button = New Button
			button.Parent = scrollable
			button.Text = "Hello number " + i
			button.Size.X = 180
			button.Size.Y = 40
			button.Position.Y = 0 + i * (button.Size.Y + 10)
		Next
		list = New ListBox(190, 0, 300, 200, Self.scrollable)
		For Local i:Int = 0 To 200
			list.Items.AddLast(New ListItem("List item " + i))
		Next
		Self.Event_Resized.Add(Self, "Resized")
 		Self.Event_Resized.RaiseEvent(Self, Null)
		scrollable.BackgroundColor = SystemColors.WindowColor
		scrollable.Padding.SetAll(5, 5, 5, 5)
		'Self.Padding.SetAll(2, 2, 2, 2)
	End
	
	Method Resized(sender:Object, e:EventArgs)
		panel.Size.CopyFrom(Self.GetClientAreaSize)
		scrollable.Size.CopyFrom(panel.GetClientAreaSize)
	End
End

