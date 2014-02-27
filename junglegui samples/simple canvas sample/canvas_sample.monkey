Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

'We start the application here
Function Main()
	ExecuteApp(New AppLauncher, "CreateForm")
End

'This is the application launcher:
Class AppLauncher
	Method CreateForm(sender:Object, e:InitializeAppEvent)
		e.mainForm = New MyForm
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