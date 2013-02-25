Import listview

#Rem
	summary: This is a ListViewItem control.
	The current implementation is based on the ContainerControl class
#END
Class ListViewItem Extends ContainerControl

Private 

	'Field _owner:ListView 
	Field _text:String 
	
	Method OnEnter(sender:Object, e:EventArgs)
		Owner.HoverItem = Self
	End
	
	Method OnLeave(sender:Object, e:EventArgs)
		Owner.HoverItem = Null
	End
	
	Method OnClick(sender:Object, e:MouseEventArgs )
		Owner.SelectedItem = Self
	End

Public 
	
	'TODO: Cambiar a MOUSE_INSIDE / MOUSE_OUTSIDE 
	Method Msg(msg:BoxedMsg)
		Select msg.e.messageSignature
			Case eMsgKinds.MOUSE_ENTER
				OnEnter(msg.sender, msg.e)
			Case eMsgKinds.MOUSE_LEAVE
				OnLeave(msg.sender, msg.e)
			Case eMsgKinds.CLICK
				OnClick(msg.sender, MouseEventArgs(msg.e))
		End
		Super.Msg(msg)
	End
	
	Method Owner:ListView() Property 
		Return ListView(Parent)
	End
	
	
	Method RenderBackground()

		If Owner.HoverItem = Self Then	'That means we're over the control OR any control contained inside the control, so it's technically still a Hoover.
			GetGui.Renderer.DrawHooverSelectableBackground(Status | eControlStatus.HOOVER, CalculateRenderPosition, Size, Self, Owner.SelectedItem = Self)
		Else
			GetGui.Renderer.DrawHooverSelectableBackground(Status, CalculateRenderPosition, Size, Self, Owner.SelectedItem = Self)
		End If
		
	End
	
	Method Text:String() Property
		Return _text
	End
	
	Method Text:Void(val:String) Property
		_text = val 
	End
	
	
End
