Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

Class MyForm Extends Form

	Method OnInit()
	
		Self.Text = "My Dialog"
		
		'Add any control initialization here:
		Self.Event_Resized.Add(Self, "Form_Resized")
		
	End
	
	Method Form_Resized(sender:Object, e:EventArgs)
		'Reposition any control here:

	End
	
End