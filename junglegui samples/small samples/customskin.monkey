Import junglegui

#REFLECTION_FILTER+="customskin"
Function Main()
	New Game
End

Class Game Extends App
	Field gui:Gui
	Field background:Image
	Method OnCreate()
		SetUpdateRate(60)
		EnableAutoSize()
		gui = New Gui
		gui.Renderer = New MySkin
		Local mainForm:= New ToolBox
		mainForm.InitForm(gui)
		background = LoadImage("background.jpg")
	End
	
	Method OnRender()
		Cls(255, 255, 255)

		'Render a background desktop image:
		Local ScaleX:Float = Max(Float(DeviceWidth) / Float(background.Width), 1.0)
		Local ScaleY:Float = Max(Float(DeviceHeight) / Float(background.Height),1.0)
		DrawImage(background,0,0,0,ScaleX, ScaleY,0 )

		gui.Render
	End
	
	Method OnUpdate()
		gui.Update()
	End
End


Class MySkin Extends renderer.GuiRenderer

	Method InitRenderer()
		'We modify some systemcolors when the Renderer is activated:
		SystemColors.FormMargin.SetColor(255, 200, 200, 190)
		SystemColors.WindowColor.SetColor(255, 220, 220, 200)
		SystemColors.ButtonBorderColor.SetColor(255, 255, 255, 235)
		SystemColors.ControlFace.SetColor(255, 180, 170, 160)
		SystemColors.HooverBackgroundColor.SetColor(255, 235, 235, 190)
		SystemColors.FocusColor.SetColor(255, 255, 255, 255)
		SystemColors.FormBorder.SetColor(255, 250, 250, 230)
		SystemColors.SelectedItemBackColor.SetColor(255, 200, 200, 180)
		#IF TARGET="html5"
			Gui.systemFont = New bitmapfont.BitmapFont("skinfont_html5.txt")
		#ELSE
			Gui.systemFont = New bitmapfont.BitmapFont("skinfont.txt")
		#END
	End

	Method DrawFormBackground(status:Int, position:GuiVector2D, size:GuiVector2D, padding:Padding, text:String, context:Control)
		'We modify the way a form is renderer.

		'We render the form "main" box:
		SystemColors.FormMargin.Activate()	'Select the form margin color
		SetAlpha(0.2)	'Oue new skin has transparent form borders, so we set alpha to 0.2
		DrawRect(position.X, position.Y, size.X, size.Y)	'We draw the form rectangle
		SetAlpha(1)	'We set alpha back to 1
		
		
		'We render for form caption (header):
		
		'First a small gradient:
		For Local i:Int = 0 To Gui.systemFont.GetFontHeight
			SetAlpha(1 - float(i) / float(Gui.systemFont.GetFontHeight))
			DrawLine(position.X, position.Y + i, position.X + size.X, position.Y + i)
		Next
		'Then the text:
		SetAlpha 1
		Gui.systemFont.DrawText(text, position.X + 1, position.Y + 1)
		
		
		
		'Now we're rendering the form "container" area, where controls are placed:
		Local backcolor:guicolor.GuiColor
		If context = Null Then	'If we're just calling this to be used with systemcolors:
			backcolor = SystemColors.WindowColor
		Else	'If we're caling this to be used with a given real form, we use its background color instead:
			backcolor = context.BackgroundColor
		EndIf
		backcolor.Activate
		DrawRect(position.X + padding.Left, position.Y + padding.Top, size.X - padding.Left - padding.Right, size.Y - padding.Top - padding.Bottom)
		
		'Now we're adding a small gradient at the top and at the bottom of the form container area:
		For Local i:Int = 0 To 20
			SetAlpha(1 - i / 20.0)
			backcolor.ActivateDark(55)
			
			DrawLine(position.X + padding.Left,
				position.Y +size.Y - padding.Bottom - i,
				position.X +size.X - padding.Right,
				position.Y +size.Y - padding.Bottom - i)
			
			backcolor.ActivateBright(55)
			'SetColor(255, 0, 0)
			DrawLine(position.X + padding.Left,
				position.Y +padding.Top + i,
				position.X +size.X - padding.Right,
				position.Y +padding.Top + i)
			
		Next		
		SetAlpha(0.5)
		SystemColors.FormBorder.Activate()
		DrawBox(position, size)
		SetAlpha(1)
	End

	Method DrawButtonBackground(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control)
		Local backColor:GuiColor
		If HasFlag(status, eControlStatus.HOOVER) Then
			If context Then
				backColor = context.HooverColor
			Else
				backColor = SystemColors.HooverBackgroundColor
			EndIf
		Else
			If context Then
				backColor = context.BackgroundColor
			Else
				backColor = SystemColors.ControlFace
			EndIf
		EndIf
		backColor.Activate()
		DrawRect(position.X + 1, position.Y + 1, size.X - 2, size.Y - 2)
	End
	
	
	Method DrawControlBorder(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control)
		If context Then context.BorderColor.Activate() Else SystemColors.ButtonBorderColor.Activate()
		'We draw a square control border on this skin:
		DrawBox(position, size)
	End
	
	Method DrawFocusRect(control:Control, round:Bool = False)
		SystemColors.FocusColor.Activate()
		Local pos:= control.CalculateRenderPosition()
		Local size:= control.Size
		DrawBox(pos, size)
	End
	
	
	Method DrawCheckBox(status:Int, position:GuiVector2D, size:GuiVector2D, context:Control = Null, checked:Bool = True)
		SystemColors.ControlFace.Activate()
		Local yOffset:Int = size.Y / 2 - CheckBoxSize.Y / 2
		DrawRect(position.X + 1, position.Y + 1 + yOffset, CheckBoxSize.X - 2, CheckBoxSize.Y - 2)
		If HasFlag(status, eControlStatus.HOOVER) Then
			SystemColors.FocusColor.Activate()
		Else
			SystemColors.ButtonBorderColor.Activate()
		EndIf
		
		DrawRoundBox(int(position.X), int(position.Y + yOffset), CheckBoxSize.X, CheckBoxSize.Y)
		If checked Then
			SystemColors.SelectedItemForeColor.Activate()
			SetAlpha(Abs(Sin(Millisecs() / 10.0)))
			'DrawRect(position.X + 4, position.Y + 4 + yOffset, BoxSize - 9, BoxSize - 8)
			DrawOval(position.X + 4, position.Y + 4 + yOffset, CheckBoxSize.X - 8, CheckBoxSize.Y - 7)
			SetAlpha 1
		EndIf
	End


End



Class ToolBox extends form.Form
	Field particlesCount:Label
	Field explosionButton:Button
	
	Field desiredStars:TrackBar
	
	Field colorR:Slider
	Field colorG:Slider
	Field colorB:Slider
	
	Field shapeKind:ListBox
	
	Field randomizeColors:CheckBox
	Field word:TextField
	
	'Field msgInspector:ListBox
'	Field debugForm:DebugForm
	
	Method OnInit()
		Local height:Int = 0
		'SELF:
		Self.Text = "Toolbox"
		Self.Size.X = 200
		Self.Size.Y = 400
		Self.Position.X = DeviceWidth - Self.Size.X - 20
		Self.TipText = "This is jsut a sample toolbar"
		Self.Name = "ToolBox"
		
		'''
		''' starCount
		'''
		particlesCount = New Label
		particlesCount.Parent = self
		particlesCount.Text = "Particles: ??"
		particlesCount.AutoAdjustSize = false
		particlesCount.Position.X = 10
		particlesCount.Position.Y = 10
		particlesCount.Size.X = Self.Size.X - Self.Padding.Left - Self.Padding.Right
		particlesCount.TipText = "This label shows the amount of used particles."
		particlesCount.Name = "particlesCount"
		height = GetNextHeight(particlesCount)
		
		'''
		'''explosionButton
		'''
		explosionButton = New Button
		explosionButton.Parent = self
		explosionButton.Text = "Explosion!"
		explosionButton.Size.Y = explosionButton.Font.GetFontHeight() +30
		explosionButton.Position.SetValues(10, height)
		explosionButton.TipText = "Click here to generate an explosion"
		explosionButton.Name = "explosionButton"
		height = GetNextHeight(explosionButton)
		
		'''
		'''desiredStars
		'''
		Local tmpLabel:Label = New Label
		tmpLabel.Parent = self
		tmpLabel.Position.SetValues(10, height)
		tmpLabel.Text = "count:"
		tmpLabel.Name = "CountLabel"
		desiredStars = New TrackBar
		desiredStars.Parent = self
		desiredStars.Position.SetValues(tmpLabel.Position.X + tmpLabel.Size.X, height)
		desiredStars.Maximum = 500
		desiredStars.Minimum = 1
		height = GetNextHeight(desiredStars)
		desiredStars.Value = 100
		desiredStars.Tickfrequency = 50
		desiredStars.Size.X = self.Size.X - desiredStars.Position.X - 10
		desiredStars.TipText = "This is the amount of desired particles."
		desiredStars.Name = "DesiredStars"
		

		'''
		''' red
		'''
		colorR = New Slider
		SetSliderValues(colorR, 0, "red", height)
		
		'''
		''' green
		'''
		colorG = New Slider
		SetSliderValues(colorG, 1, "green", height)

		'''
		''' blue
		'''
		colorB = New Slider
		SetSliderValues(colorB, 2, "blue", height)

		height = GetNextHeight(colorB)
		
				
		shapeKind = New ListBox(10, height, Self.Size.X - Self.Padding.Left - Self.Padding.Right - 20, 100, self)
		shapeKind.Items.AddLast("Round")
		shapeKind.Items.AddLast("Square")
		shapeKind.Items.AddLast("Dot")
		shapeKind.Items.AddLast("Round")
		shapeKind.Items.AddLast("Square")
		shapeKind.Items.AddLast("Dot")

		shapeKind.SelectedIndex = 0
		shapeKind.Name = "ShapeKind"

		height = GetNextHeight(shapeKind)
		
		'''
		'''Randomize
		'''
		randomizeColors = New CheckBox
		randomizeColors.Parent = Self
		randomizeColors.Text = "Randomize colors"
		randomizeColors.TipText = "Enable or disable randomize colors for particles"
		randomizeColors.Position.SetValues(10, height)
		randomizeColors.Size.Y = 18
		randomizeColors.Name = "RandomizeColors"
		randomizeColors.Checked = True
		height = GetNextHeight(randomizeColors)
		
		tmpLabel = New Label
		tmpLabel.Parent = self
		tmpLabel.Position.SetValues(10, height)
		tmpLabel.Text = "word:"
		tmpLabel.Name = "LabelWord"
		
		word = New TextField
		word.Parent = Self
		word.Position.Y = tmpLabel.Position.Y
		word.Position.X = tmpLabel.Position.X + tmpLabel.Size.X + 10
		word.Size.X = Self.Size.X - Self.Padding.Left - Self.Padding.Right - tmpLabel.Size.X - tmpLabel.Position.X * 2
		word.AutoAdjustSize = false
		word.Size.Y = tmpLabel.Size.Y
		word.Name = "Word"
		height = GetNextHeight(tmpLabel)
	
		'''
		''' Form size:
		'''
		Self.Size.Y = height + Padding.Top + Padding.Bottom
	End
	
	
	Method GetNextHeight(control:Control)
		Const Margin:Int = 5
		Return control.Position.Y + control.Size.Y + Margin
	End
	
	
	Method SetSliderValues(slider:Slider, Index:Int, name:String, height:Int)
		slider.Position.SetValues(70, height + Index * 20)
		slider.Parent = Self
		slider.Name = name
		slider.Maximum = 100
		slider.Size.SetValues(Self.Size.X - 70 - 10 - Self.Padding.Left - Self.Padding.Right, 15)
		slider.Maximum = 255
		slider.Value = 255
		Local label:= New Label
		label.Parent = Self
		label.Text = name
		label.Position.SetValues(10, height + Index * 20)
		label.Name = "Label" + name
		
		'We align the label: 
		
		label.Position.Y = slider.Position.Y - (label.Size.Y - slider.Size.Y) / 2
		
		'label.Size.Y = 10
		
	End
	
	
		
End
