Import junglegui
Import junglegui.multilinetexteditor
#REFLECTION_FILTER+="demos.textbox"

Class TextBoxForm Extends Form
	Field textBox:MultilineTextbox
	
	Method OnInit()
		textBox = New MultilineTextbox
		textBox.Parent = Self
		textBox.Name = "MultilineTextBox"
		textBox.Text = "Hello world! Welcome to the multiline wordwrap textbox! It's amazing to see how a big and large textbox can be wrapped properly into several lines, so no horizontal scrolling is required "
		For Local i:Int = 0 To 3
			textBox.Text += textBox.Text
		Next
		
		Self.Event_Resized.Add(Self, "Form_Resized")
		
		
		DoLayout()
	End
	
	Method Form_Resized(sender:Object, e:EventArgs)
		DoLayout()
	End
	
	Method DoLayout()
		textBox.Size.SetValues(GetClientAreaSize.X, GetClientAreaSize.Y)
	End
End