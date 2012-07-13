Import junglegui
Class JungleGuiException extends Throwable
	
	Method New(description:String, control:Control)
		Self.description = description 
		Self.control= control
		
	end 
	Private
	Field description:String
	Field control:Control
End