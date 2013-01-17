Import junglegui

Class JungleGuiException extends Throwable
	
	Method New(description:String, control:Control)
		Self.description = description 
		Self.control= control
		
	end
	
	Method ToString:String()
		Return Self.description
	End
	
	Method TargetControl:Control()
		Return control
	End
	Private
	Field description:String
	Field control:Control
End