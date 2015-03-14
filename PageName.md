# Internal usage of Status changes #
Junlge Gui provides an efficient lower level Msg system to deal with status changes and messages on controls. Regular controls won't handle "events" as you would do on a regular TopLevelControl. Instead, they use the a much more flexible Msg system. This system is a bit lower level, does not rely on Reflection and allow messages encapsulation on any container control.

## Internals ##

Let's see how it works:

When something that needs to be notified to a control happens, the Gui system calls the control Msg method, like this:

```

sender.Msg(sender, New EventArgs(eEventKinds.MOVED))```
This example is just showing how the Gui system will call the Msg method when a control is moved. Sender is the name of the control that has been moved.

When we're creating our custom control, sometimes we need to make the control react to Msg sent by the Gui. To do so, we will extend the Msg method likethis:

```
Method Msg:Void(sender:Object, e:EventArgs)
Super.Msg(sender,e)
End```

We can add any code we want in the middle of it. As instance, if our control has to do something when it's clicked:
```
Method Msg:Void(sender:Object, e:EventArgs)
If sender = Self And e.EventSignature = eEventKinds.CLICK Then
DoSomething()
End
Super.Msg(sender,e)
End```

Notice that we're checking that the control being notified is our control, and that the event is the kind of event we want to react to.

## Msg cascade ##
In the above example, why Are we checking the "sender = self"? Shouldn't sender be always self?

The answer is "No". In details, Container controls do get Msg(s) from their child controls, so a container control will get notification for itself, and notifications for any contained control.

This gets to a point that Msg are populated in cascade, from the first control that gets an Msg, to the TopLevelControl where it is located.

In other words, it can happen that a button gets a CLICK message from itself (sent by the Gui), and then it sends it to its parent, that is a Panel, then this Panel will send it to its parent, that can be another Panel, and then it can be sent to a Form, that is a TopLevelControl.

## Msg on a TopLevelControl and Events ##
When a Msg call gets to a TopLevelControl, this Msg will be converted to an event that can be handled by the TopLevelControl itself. **Regular controls do not handle events in this way and should stik with regular Msg rules.**

## Simple example of tweaking functionality ##

As an example, if we would like to make a Panel that prevents its contained buttons to raise CLICK events, all we wold have to do is override its internal Msg method like this:

```
Method Msg:Void(sender:Object, e:EventArgs)
If Button(sender) <> Null And e.EventSignature = eEventKinds.CLICK Then
Return  'We prevent the CLICK Msg go continue the "cascade". It gets handled and lost here. '
Else
Super.Msg(sender,e)
End
End```
This will prevent a CLICK Msg from any button contained into our Panel to reach the TopLevelContainer so those Buttons will never generate a CLICK event into the TopLevelControl.

## Raising an event ##
Sometimes a control has to be able to raise its own Msg, so they can be converted to Events and used accordingly on applications.
To do so, all what's required is forcing a call to the Msg method of the control that is going to "raise" the event:
```
myControl.Msg(myControl, New EventArgs(eEventKinds.CLICK))```
In this example, we're generating a CLICK Msg on the control named myControl.