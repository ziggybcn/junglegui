Import junglegui

Class GuiImage Extends Control
	Private
	Field image:Image
	Field transparent:Bool = False
	Field _imageSet:= New EventHandler<EventArgs>
	Field colorCache:= New Float[3]
	Public
	
	Method Event_ImageSet:EventHandler<EventArgs>() Property;
		Return _imageSet
	End
	
	Method Image:Image() Property
		Return image
	End
	
	Method Image:Void(image:Image) Property
		If image <> Self.image Then
			_imageSet.RaiseEvent(Self, New EventArgs(eMsgKinds.EMPTYMSG))
			Self.image = image
		EndIf
	End
	
	Method Transparent:Bool() Property
		Return transparent
	End
	
	Method Transparent:Void(value:Bool) Property
		transparent = value
	End
	
	Method Render:Void()

		Local location:= Self.UnsafeRenderPosition()
		'Local color:= New Float[3]
		Local resetcolor:Bool = False
		GetColor(colorCache)
	
		If Not transparent Then
			If colorCache[0] <> BackgroundColor.r And colorCache[1] <> BackgroundColor.g And colorCache[2] <> BackgroundColor.b Then
				SetColor(255, 255, 255)
				resetcolor = True
			EndIf
			BackgroundColor.Activate()
			DrawRect(location.X, location.Y, Size.X, Size.Y)
		EndIf
		
		If image <> Null
			If colorCache[0] <> 255 And colorCache[1] <> 255 And colorCache[2] <> 255 or resetcolor Then
				SetColor(255, 255, 255)
				resetcolor = True
			EndIf
			Local posx:Int, posy:Int
			posx = location.X + Size.X / 2
			posy = location.Y + Size.Y / 2
			Local handlex = image.HandleX, handley = image.HandleY
			image.SetHandle(image.Width / 2, image.Height / 2)
			DrawImage(image, posx, posy)
			image.SetHandle(handlex, handley)
		EndIf
		SetColor(colorCache[0], colorCache[1], colorCache[2])
	End
End