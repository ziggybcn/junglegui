#rem monkeydoc Module junglegui.guiimage
	This module contains the implementatio of the [[GuiImage]] [[Control]].
#END

Import junglegui
#REFLECTION_FILTER+="${MODPATH}"

#Rem monkeydoc
	This is the GuiImage control. This control renders as an image, but has all the [[Control]] functionality, such as being able to raise events, get mouse interaction, scale, etc.
	This is like a WindowsForms PictureBox, like an "Image Container". It's useful to add some image decorations to your application Gui design.
#END
Class GuiImage Extends Control
	Private
	Field image:Image
	Field transparent:Bool = False
	Field _imageSet:= New EventHandler<EventArgs>
	Field colorCache:= New Float[3]
	Public

	#rem monkeydoc
		This event will be fired when a new mojo Image is set as the Image property in this control.	
	#END
	Method Event_ImageSet:EventHandler<EventArgs>() Property;
		Return _imageSet
	End
	
	#rem monkeydoc
		This property is the Image that this control has to draw on the device canvas.
	#END
	Method Image:Image() Property
		Return image
	End
	
	Method Image:Void(image:Image) Property
		If image <> Self.image Then
			_imageSet.RaiseEvent(Self, New EventArgs(eMsgKinds.EMPTYMSG))
			Self.image = image
		EndIf
	End
	
	#rem monkeydoc
		This property can be set to True or False in order to make the background of this control transparent. That's useful when the contained Image has a properly designed transparent alpha channel.
	#END
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
			If colorCache[0] <> BackgroundColor.Red And colorCache[1] <> BackgroundColor.Green And colorCache[2] <> BackgroundColor.Blue Then
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