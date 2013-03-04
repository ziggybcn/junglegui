Import junglegui
#REFLECTION_FILTER+="canvas_sample"
Function Main()
	New SampleApp
End


'We setup a GUI application:
Class SampleApp Extends App
	Field gui:Gui
	Field form:MyForm
	Method OnCreate()
		SetUpdateRate 60
		gui = New Gui
		form = New MyForm
		form.InitForm(gui)
	End
	Method OnUpdate()
		gui.Update()
	End
	
	Method OnRender()
		'Cls(255, 255, 255)
		Cls(SystemColors.AppWorkspace.r, SystemColors.AppWorkspace.g, SystemColors.AppWorkspace.b)
		gui.Render()
	End
End

Class MyForm Extends Form
	Field myCanvas:Canvas
	Method OnInit()
		myCanvas = New Canvas
		myCanvas.Parent = Self

		myCanvas.Event_Render.Add(Self, "Render_Canvas")
		myCanvas.LogicSize.SetValues(640, 480)	'This is the virtual resolution size for the canvas
		myCanvas.Size.SetValues(10, 10)
		
		Self.Event_Resized.Add(Self, "Form_Resized")
		Self.Size.SetValues(200, 150)
	End
	
	
	Method Form_Resized(sender:Object, e:EventArgs)
		myCanvas.Size.X = Self.GetClientAreaSize.X
		myCanvas.Size.Y = Self.GetClientAreaSize.Y
	End

	
	Method Update()
		Super.Update()
		Self.Text = myCanvas.Size.X + ", " + myCanvas.Size.Y '+ "   " + String.FromChar(Rnd("a"[0], "z"[0]))
		'Print "Updated..."
		If KeyDown(KEY_ESCAPE) Error("")
	End
	
	Method Render_Canvas(sender:Object, e:EventArgs)
		Cls(255, 255, 255)
		SetColor(0, 0, 0)
		DrawOval(0, 0, myCanvas.LogicSize.X, myCanvas.LogicSize.Y)
		SetColor(255, 0, 0)
		DrawCircle(myCanvas.MouseX, myCanvas.MouseY, 20)
		
	End
	
End