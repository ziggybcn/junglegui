# Internal usage of Status changes #
Junlge Gui provides an efficient low level Msg system to deal with status changes and messages on controls.

It is recommended that, when designing a core control for JunlgeGui, all status changes and notifications that could affect the behavior of other controls, or that are the consecuence of any low-level interaction from the Gui system are done using this Msg system instead of using EventHandlers.

The Event Handler system can be easily modified by anyone using the control and can't be encapsulated by containers, so it is unsafe for core operations.

If a Msg has to be also raised as an event (such as control clicked), we'll do this in the control Dispatch method.

Then, logical status changes that do not affect any other control behavious, such as selected item on a combo box, won't be based on the Msg system, and can be done by using EventHandlers directly.

## Internals of the Msg system ##

Let's see how it works:

When something that needs to be notified to a control happens, the Gui system calls the control Msg method, like this:

```
Local event:=New EventArgs(eMsgKinds.MOUSE_ENTER);
Local msg:= New BoxedMsg(sender, event);
sender.Msg(msg);```
This example is just showing how the Gui system will call the Msg method when the mouse "enters" the Control drawing area. Sender is the name of the control that has been sent this message.

When we're creating our custom control, sometimes we need to make the control react to Msg sent by the Gui. To do so, we will extend the Msg method likethis:

```
Method Msg(msg:BoxedMsg)
Super.Msg(msg)
End```

We can add any code we want in the middle of it. As instance, if our control has to do something when it's clicked:
```
Method Msg(msg:BoxedMsg)
If msg.sender = Self And msg.e.EventSignature = eEventKinds.CLICK Then
DoSomething()
End
Super.Msg(msg)
End```

Notice that we're checking that the control being notified is our control, and that the event is the kind of event we want to react to.

## Msg cascade ##
In the above example, why Are we checking the "msg.sender = self"? Shouldn't sender be always self?

The answer is "No". In details, Container controls do get Msg(s) from their child controls, so a container control will get notification for itself, and notifications for any contained control.

This gets to a point that Msg are populated in cascade, from the first control that gets an Msg, to the TopLevelControl where it is located.

In other words, it can happen that a button gets a CLICK message from itself (sent by the Gui), and then it sends it to its parent, that is a Panel, then this Panel will send it to its parent, that can be another Panel, and then it can be sent to a Form, that is a TopLevelControl.

This is an example of a CLICK Msg "traveling" in cascade from its first call (done by the Gui system) until it raises a TopLevelControl.

![http://wiki.junglegui.googlecode.com/hg/images/Dibujo3.png](http://wiki.junglegui.googlecode.com/hg/images/Dibujo3.png)

## Simple example of tweaking functionality ##

As an example, if we would like to make a Panel that prevents its contained buttons to raise CLICK events, all we wold have to do is override its internal Msg method like this:

```
Method Msg(msg:BoxedMsg)
If Button(msg.sender) <> Null And msg.e.EventSignature = eMsgKinds.CLICK Then
msg.status = eMsgStatus.Canceled
Else
Super.Msg(sender,e)
End
End```
This will prevent a CLICK Msg from any button contained into our Panel to continue its chain path alongside all the parents chain, and also it will be canceled when the Message gets back to the original control, to prevent the Event to be raised in the control Dispatch method.