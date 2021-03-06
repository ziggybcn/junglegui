Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

Class Padding
	Method Top:Int() property
		Return top
	End
	Method Top:Int(value:Int) property
		top = value
		'ValuesChanged
		Return top
	End
	
	Method Left:Int() property
		Return left
	End
	Method Left:Int(value:Int) property
		left = value
		'ValuesChanged
		Return left
	End

	Method Right:Int() property
		Return right
	End
	Method Right:Int(value:Int) property
		right = value
		'ValuesChanged
		Return right
	End

	Method Bottom:Int() property
		Return bottom
	End
	Method Bottom:Int(value:Int) property
		bottom = value
		'ValuesChanged
		Return bottom
	End
	
	Method SetAll(top:Int, left:Int, bottom:Int, right:Int)
		Top = top
		Left = left
		Bottom = bottom
		Right = right
	End
	
	
	Method CloneHere:Void(newPadding:Padding)
		newPadding.left = left
		newPadding.top = top
		newPadding.right = right
		newPadding.bottom = bottom
	End
	
	Method Add(otherPadding:Padding)
		top += otherPadding.top
		left += otherPadding.left
		right += otherPadding.right
		bottom += otherPadding.bottom
	End
	
	Private
	Field top:int
	Field left:Int
	Field right:Int
	Field bottom:int
End

