Import junglegui

Class GuiImage Extends Control
	Private
	Field image:Image
	Field transparent:Bool = False
	Field _imageSet:= New EventHandler<EventArgs>
	Public
	
	Method Event_ImageSet:EventHandler<EventArgs>() Property;
		Return _imageSet
	End
	
	Method Image:Image() Property
		Return image
	End
	
	Method Image:Void(image:Image) Property
		_imageSet.RaiseEvent(Self, New EventArgs(eMsgKinds.EMPTYMSG))
		Self.image = image
	End
	
	Method Transparent:Bool() Property
		Return transparent
	End
	
	Method Transparent:Void(value:Bool) Property
		transparent = value
	End
	
	Method Render:Void()

		Local location:= Self.UnsafeRenderPosition()
		Local color:= New Float[3]
		GetColor(color)
	
		If Not transparent Then
			BackgroundColor.Activate()
			DrawRect(location.X, location.Y, Size.X, Size.Y)
		EndIf
		
		If image <> Null
			SetColor(255, 255, 255)
			Local posx:Int, posy:Int
			posx = location.X + Size.X / 2
			posy = location.Y + Size.Y / 2
			Local handlex = image.HandleX, handley = image.HandleY
			image.SetHandle(image.Width / 2, image.Height / 2)
			DrawImage(image, posx, posy)
			image.SetHandle(handlex, handley)
		EndIf
		SetColor(color[0], color[1], color[2])
	End
End