# BoxedMsg #
This is a class that represents a low level Gui Msg. This class is used to send messages from one control to its parent.This is useful to ensure any important status change (a focus change, an object resize, a mouse click, etc.) is known and notified to the whole chain of objects in the controls structure.

This is more or less a simpified version of this class contents:
```
Class BoxedMsg;
Field e:EventArgs;
Field sender:Object
Field status:int
End ```

In this class, sender is the control instance that is causing the status change or event (as instance, the control that has been clicked). "e" is the event signature data, that identifies the event as a CLICK event, a RESIZE event, etc.

The status identifies if the Msg has to be converted to an Event or not in the Dispatch process of the Control.
As instance, a CLICK message that has a status of eMsgStatus.CANCELED will never fire an Event, as this message is considered "handled" and canceled. this is useful to allow interesting tweaks such as making a TextField that only accepts numbers (canceling any keypress that would cause a non numeric character to be added to the control).
