Import junglegui

'This interface is implemented by all controls that use text in their display
Interface TextualItem

	Method Text:Void(value:String) Property
	Method Text:String() Property

	Method Font:BitmapFont() Property
	Method Font:Void(font:BitmapFont) Property

End

Interface TextualAlignItem 'Extends TextualItem
	Method TextAlign:Int() Property
	Method TextAlign:Void(value:Int) Property	
End

Class eTextAlign abstract
	Const LEFT:Int = eDrawAlign.LEFT 
	Const RIGHT:Int = eDrawAlign.RIGHT
	Const CENTER:Int = eDrawAlign.CENTER 
End
