Import junglegui
Import reflection
'Import dom
#REFLECTION_FILTER+="${MODPATH}" 
'#CANVAS_RESIZE_MODE=2

Import spiralmatrix

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
	Field background:Image
	Field form:TestForm

	Method OnCreate()
		SetUpdateRate(120)
		#if TARGET="glfw"
        'glfwSetWindowPos(0, 0)        ' set window position
        'glfwSetWindowSize(1280, 1024) ' resize window
		#end
		background = LoadImage("background.png")
		gui = New Gui
		For Local i:Int = 0 To 10
		form = New TestForm
		form.InitForm(gui)
		Next
		background = LoadImage("background.png")
		Local elem:= document.getElementById("GameCanvas")
		EnableAutoSize();
		
'		If elem <> Null Then
'			elem.setAttribute("style", "cursor:n-resize;");
'		End
	End
	
	Method OnUpdate()
		gui.Update()
	End
	
	Method OnRender()
		Cls(200, 200, 190)
		Scale(1, 1)
		If background <> Null Then
			Local ScaleX:Float = Max(Float(DeviceWidth) / Float(background.Width), 1.0)
			Local ScaleY:Float = Max(Float(DeviceHeight) / Float(background.Height), 1.0)			
			DrawImage(background, 0, 0, 0, ScaleX, ScaleY, 0)
		Else
			Print "background is null!"
		EndIf
		gui.Render()
	End
End

Class TestForm Extends Form
	Field scrollable:ScrollableContainer
	
	Field button:Button
	
	Field list:ListBox
	
	Field tabs:TabControl
	
	Field tabPage1:TabPage
	Field tabPage2:TabPage
	Field tabPage3:TabPage
	
	Field image:GuiImage
	Field label:Label
	Field canv:SpiralMatrix
'	Field textBox:MultilineTextbox
	
	'Field panel:Panel
	Method OnInit()
	
	
		tabs = New TabControl
		tabs.Parent = Self
		
		'TAB PAGE 1:
		
		tabPage1 = New TabPage
		tabPage1.Text = "Init"
		tabPage1.Parent = tabs
		
		image = New guiimage.GuiImage
		image.Image = LoadImage("icon.png")
		image.Parent = tabPage1
		image.Size.X = image.Image.Width
		image.Size.Y = image.Image.Height
		image.Transparent = True
		
		label = New Label
		label.Text = "This is a small Jungle Gui sample"
		label.Parent = tabPage1
		label.AdjustSize()
	
		
		'label.Position.X = image.Position.X + image.Size.X + 10
		'label.Position.Y = image.Position.Y + image.Size.Y / 2 - label.Size.Y / 2
		tabPage1.Event_Resized.Add(Self, "TabPage1_Resized")
		
		'TAB PAGE 2:
		tabPage2 = New TabPage
		tabPage2.Text = "Sample"
		tabPage2.Parent = tabs
		
		tabs.Event_Resized.Add(Self, "Tab_Resized")
		
		scrollable = New ScrollableContainer
		
		scrollable.Parent = tabPage2
		scrollable.DrawFocusRect = False
		
		For Local i:Int = 0 To 100
			button = New Button
			button.Parent = scrollable
			button.Text = "Hello number " + i
			button.Size.X = 180
			button.Size.Y = 20
			button.Position.Y = 0 + i * (button.Size.Y + 5)
		Next
		list = New ListBox(190, 0, 300, 200, Self.scrollable)
		For Local i:Int = 0 To 200
			list.Items.AddLast(New ListItem("List item " + i))
		Next
		
		Local tb:= New MultilineTextbox
		tb.Parent = scrollable
		tb.Text = "This is a very long text that is rendering on a multiline textbox that is not *yet* editable, but will be soon.~n~nLet's have a bit more of text here, so we get some additional scrolling on the text area. Isn't it interesting?~nWhat do you think about long lines of text, is it worth it to have them on a scrollable widget like this one?"
		tb.Size.SetValues(300, 100)
		tb.Position.CopyFrom(list.Position)
		tb.Position.Y += list.Size.Y + 10
		
		scrollable.BackgroundColor = SystemColors.WindowColor
		scrollable.Padding.SetAll(5, 5, 5, 5)

		'tabpage3
		tabPage3 = New TabPage
		tabPage3.Parent = tabs
		tabPage3.Text = "Spiral matrix!"
		canv = New SpiralMatrix
		canv.Parent = tabPage3
		canv.Size.SetValues(200, 200)
		canv.LogicSize.SetValues(640, 480)		
		
		'tab:
		tabs.SelectedTab = tabPage1
		
		'SELF:
		Self.Event_Resized.Add(Self, "Resized")
		Self.Text = "Small tab and scrolling sample. Resize Me!"
		
 		'Self.Event_Resized.RaiseEvent(Self, Null)
		
		Self.Size.SetValues(500, 440)

		Self.Position.X = DeviceWidth / 2 - Self.Size.X / 2
		Self.Position.Y = DeviceHeight / 2 - Self.Size.Y / 2
	End
	
	Method Resized(sender:Object, e:EventArgs)
		tabs.Size.CopyFrom(Self.ClientSize)
	End
	
	Method Tab_Resized(sender:Object, e:EventArgs)
		scrollable.Size.CopyFrom(tabPage2.ClientSize)
		canv.Size.CopyFrom(tabPage3.ClientSize)
	End
	
	Method TabPage1_Resized(sender:Object, e:EventArgs)
	
		Local rest:= New GuiVector2D
		rest.SetValues(tabPage1.ClientSize.X, tabPage1.ClientSize.Y)
		
		image.Position.X = rest.X / 2 - image.Size.X / 2
		image.Position.Y = rest.Y / 2 - image.Size.Y / 2 - 20
		
		label.Position.X = rest.X / 2 - label.Size.X / 2
		label.Position.Y = image.Position.Y + image.Size.Y + 5
		
	End

End