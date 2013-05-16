'HELLO NEWCOMER
'READ THIS BEFORE TAKING A LOOK TO THIS SAMPLE:
'
'	This is a sort of complex sample we'r using for regular junglegui development.
'	Refer to other samples for easier getting started.
'
'

'We import the module, otherwise nothing will work:  
Import junglegui
Import junglegui.renderers.concretejungle
Import junglegui.renderers.roundforms
Import junglegui.multilinetexteditor

'It's important to add this file to the reflection filter if we want it to be able to process event handlers
#REFLECTION_FILTER+="sample1"

'Start the application
Function Main()
	New Sample  
End

Class Sample Extends App
	Field gui:Gui
	Field background:Image
	Field MyForm:SampleForm
	Field instructions:InstructionsPanel
	Method OnCreate()
		SetUpdateRate(60)

		'We create a gui, wich is the component that handles all the gui:
		If gui = Null Then gui = New Gui
		'gui.Renderer = New RoundForms 'ConcreteJungle
		
		EnableAutoSize()

		'We create a SampleForm, and we attach it to the gui component:
		MyForm = New SampleForm
		Try
			MyForm.InitForm(gui)
			For Local i:int = 0 Until 3
				Const Margin:Int = 15
				Local sm:= New SampleForm
				sm.InitForm(gui)
				sm.Position.X = Margin + i * (sm.Size.X + Margin)
			Next
		Catch jge:JungleGuiException
			Print "Form could not be initialized becouse of an exception:"
			Print jge.ToString()
		End try
		background = LoadImage("background.jpg")
		
		instructions = New InstructionsPanel
		instructions.InitForm(gui)
		
		Local editform:= New EditorForm
		editform.InitForm(gui)
		
		gui.ScaleX = 1
		gui.ScaleY = 1
	End
	
	Method OnUpdate()
		gui.Update()
	End
	
	Method OnLoading()
		Cls(255, 255, 255)
		Translate(DeviceWidth / 2, DeviceHeight / 2)
		SetColor(0, 0, 180)
		Local baseRot = Millisecs() / 3 mod 360
		Rotate(baseRot)
		Const max:Int = 6
		For Local i:Int = 0 to max
			SetAlpha(float(i) / float(max))
			DrawOval( -2, - 20, 4, 4)
			Rotate(35)
		Next
	End
	
	Method OnRender()
		Cls(0, 0, 0)
		'Render a background desktop image:
		Local ScaleX:Float = Max(Float(DeviceWidth) / Float(background.Width), 1.0)
		Local ScaleY:Float = Max(Float(DeviceHeight) / Float(background.Height), 1.0)
		DrawImage(background, 0, 0, 0, ScaleX, ScaleY, 0)
		Scale(1.5, 1.5)
		gui.Render
	End
End

Class InstructionsPanel Extends WindowFrame
	Field ButDefault:Button
	Field ButConcrete:Button
	Field ButRound:Button
	Method OnInit()
		Self.Size.SetValues(400, 20)
		'Self.Transparent = True
		'Local lbl:Label = New Label
		'lbl.Parent = Self
		'lbl.Text = "1.- Default, 2.- Jungle Concrete, 3.- RoundForm"
		'lbl.AutoAdjustSize = False
		'lbl.Size.SetValues(400, 20)
		'lbl.TipText = "This is just a quick instructions panel~nPress this keys to change the current Jungle Gui renderer."
		
		ButDefault = New Button
		ButDefault.Parent = Self
		ButDefault.Text = "Default"
		ButDefault.AdjustSize()
		ButDefault.Position.SetValues(5, 5)
		ButDefault.Event_Click.Add(Self, "Button_Clicked")
		ButDefault.TipText = "Select the default Jungle Gui skin"
				
		ButConcrete = New Button
		ButConcrete.Parent = Self
		ButConcrete.Text = "Concrete"
		ButConcrete.AdjustSize()
		ButConcrete.Position.SetValues( ButDefault.Position.X + ButDefault.Size.X + 5,5)
		ButConcrete.Event_Click.Add(Self, "Button_Clicked")
		ButConcrete.TipText = "Select the concrete Jungle Gui skin"
		
		ButRound = New Button
		ButRound.Parent = Self
		ButRound.Text = "RoundForms"
		ButRound.AdjustSize()
		ButRound.Position.SetValues(ButConcrete.Position.X + ButConcrete.Size.X + 5, 5)
		ButRound.Event_Click.Add(Self, "Button_Clicked")
		ButRound.TipText = "Select the RoundForms Jungle Gui skin"
		
		Self.Size.Y = ButDefault.Size.Y + 10
		
	End
	
	Method Button_Clicked(sender:Object, e:MouseEventArgs)
		

		Select sender
			Case ButDefault
				GetGui.Renderer = Null
			Case ButConcrete
				GetGui.Renderer = New ConcreteJungle
			Case ButRound
				GetGui.Renderer = New RoundForms
		End
	End
	
End

Class SampleForm Extends Form
	Field button:Button
	Field editField:TextField
	Field progBar:ProgressBar
	Field timer:Timer
	
	Field butLeft:Button 
	Field butCenter:Button
	Field butRight:Button
	Field label:Label
	Field panel:Panel
			
	'This is called by the gui engine whenever the Form is suposed to create its internal components:
	Method OnInit()
		
		'''
		''' SampleForm:
		'''
		Self.Text = "Sample form."
		Self.Position.X = 20
		self.Position.Y = 20
		Self.ControlBox = true
		Self.Size.Y = 340
		Self.TipText = "This is a form that can be dragged."
		Self.Name = "MyForm"
		Self.BorderStyle = eFormBorder.FIXED


		'''
		''' button: 
		'''
		button = New Button
		button.Parent = Self
		button.Position.SetValues(100, 110)
		button.Text = "Hello world!"
		button.TipText = "This is a sample button. Click it to change the Form color."
		button.Name = "Button"
		
		HCenterControl(button)
		'We add an event handler for the click event of the button:
		'DebugStop()
		button.Event_Click.Add(Self, "Button_Clicked")
		
		'''
		''' Edit field
		'''
		editField = New TextField()
		editField.Parent = Self
		editField.Position.SetValues(20, 80)
		editField.Size.SetValues(200, 20)
		editField.AutoAdjustSize = false
		editField.Text = "Edit me!"
		editField.TipText = "Enter here some text. This field is editable."
		editField.Name = "EditField"
		
		HCenterControl(editField)
				
		''' 
		''' ProgBar 
		''' 
		progBar = New ProgressBar
		progBar.Parent = Self
		progBar.Position.SetValues(10, 50)
		progBar.Size.SetValues(200, 20)
		progBar.Maximum = 100
		progBar.Value = Rnd(0, 100)
		progBar.Name = "ProgressBar"
		HCenterControl(progBar)
		
		'''
		''' Timer: 
		''' 
		timer = New Timer
		timer.Parent = Self
		timer.Interval = Rnd(1, 5)	'The timer will trigger a Click event every "n" frames, so it is SetFrameRate dependant.
		timer.Name = "timer1"
		timer.Event_TimerTick.Add(Self, "Timer_Click")
		

		''' 
		''' Label 
		'''		 
		label = New Label
		label.Parent = Self
		label.Text = "Select aligment:"
		label.Position.SetValues(10, 10)
		label.Size.Y = 25
		label.TipText = "This is a label."
		label.Name = "label1"
	
		'''
		''' ButLeft, right and center
		'''
		butLeft = New Button(Self, 10 + label.Size.X, 10, "Left", 50, 20)
		butLeft.Event_Click.Add(Self, "Adjust_Button_Clicked")
		butLeft.TipText = "Align the button to the left."
		butLeft.Name = "butLeft"
		
		butCenter = New Button(Self, 70 + label.Size.X, 10, "Center", 50, 20)
		butCenter.Event_Click.Add(Self, "Adjust_Button_Clicked")
		butCenter.TipText = "Align the button to the center.~nAnd make it look standard, any other aligment looks weird on a button.~nThis is a multiline tip. Isn't it cool?"
		butCenter.Name = "butCenter"
				 
		butRight = New Button(Self, 130 + label.Size.X, 10, "Right", 50, 20)
		butRight.Event_Click.Add(Self, "Adjust_Button_Clicked")
		butRight.TipText = "This button does an obvious thing."
		butRight.Name = "butRight"
		
		'''
		''' Panel
		'''
		panel = New Panel
		panel.Parent = Self
		panel.Position.SetValues(10, 160)
		panel.Size.SetValues(280, 120)
		panel.BackgroundColor = Self.BackgroundColor
		panel.TipText = "This is a simple panel component"
		panel.Name = "panel"
		HCenterControl(panel)

		Local combo:ComboBox = New ComboBox(panel, 0, 0, 150)
		Local li:ListItem
		li = New ListItem("Item 1"); combo.Items.AddLast(li)
		li = New ListItem("Item 2"); combo.Items.AddLast(li)
		li = New ListItem("Item 3"); combo.Items.AddLast(li)
		combo.SelectedIndex = 0
				
		
		'''
		''' add random radio buttons
		'''
		For Local i:Int = 0 to 5
			Local radio:RadioButton = New RadioButton
			radio.Parent = panel
			radio.Position.SetValues(10, 20 + i * 20)
			radio.Size.SetValues(200, 20)
			radio.Text = "Option " + (i + 1)
			radio.TipText = "This is a selectable option #" + (i + 1)
			radio.Name = "radio" + i
		Next
		 
	End

	
	Method Button_Clicked(sender:Object, e:MouseEventArgs)
		Self.BackgroundColor = New GuiColor(1, Rnd(200, 255), Rnd(200, 255), Rnd(200, 255))
	End
	
	Method Timer_Click(sender:Object, e:EventArgs)
		Self.progBar.Value += 0.1
		if progBar.Value >= progBar.Maximum Then progBar.Value = 0
		'Self.Text = "Timer called at time: " + Millisecs() 
		progBar.TipText = "Current progress is " + Int(progBar.Value) + "%"
	End
	
	Method Adjust_Button_Clicked(sender:Object, e:MouseEventArgs)
		Select sender
			Case butLeft
				button.TextAlign = eTextAlign.LEFT
			Case butCenter
				button.TextAlign = eTextAlign.CENTER
			Case butRight
				button.TextAlign = eTextAlign.RIGHT
		End
	End
End

Function HCenterControl(control:Control)
	If control.IsTopLevelControl = True Then Return
	if control.Parent = Null Then Return
	control.Position.X = control.Parent.Size.X / 2 - control.Size.X / 2
End

Class EditorForm Extends Form
	Field EditBox:MultilineTextbox
	Method OnInit()
		Self.Text = "Editor"
		Self.Event_Resized.Add(Self, "Form_Resized")
		
		EditBox = New MultilineTextbox
		EditBox.Parent = Self
		EditBox.Text = "Hello world!"
		ArrangeSize()
	End
	
	Method Form_Resized(sender:Object, e:EventArgs)
		ArrangeSize
	End
	
	Method ArrangeSize()
		EditBox.Size.SetValues(Self.GetClientAreaSize.X, Self.GetClientAreaSize.Y)
	End
End