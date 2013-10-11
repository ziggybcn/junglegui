Import junglegui
Import junglegui.multilinetexteditor
#REFLECTION_FILTER+="demos.textbox"

Class TextBoxForm Extends Form
	Field textBox:MultilineTextbox
	
	Method OnInit()
		textBox = New MultilineTextbox
		textBox.Parent = Self
		textBox.Name = "MultilineTextBox"
		textBox.Text = LoadString("sampletext.txt")
		
		Self.Text = "Resize me!"
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
