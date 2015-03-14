# Controls Events system #

All controls provide a collection of EventHandler(s) that can be used to raise events.

An EventHandler is a class to wich you can add classes instances and method names in a way that when an event is fired, all the registered methods for the registered classes will be called.

As instance, all the controls have a Event\_Clicked event handler, so doing this:
```
MyControl.Event_Clicked.Add(MyForm, "Button_Clicked")```Will make the Gui system automatically call the method Button\_Clicked of the class instance contained in the variable MyForm.

For this to work properly, the associated Method has to have the right event callback signature. If you don't know wich is the right signature for a given event callback, once you set it wrong and run the code, you'll get a nice exception with a description of what signature you should have used.

You can also see them here: EventCallbackSignatures

# Control Dispach method #

All controls also have an internal Msg system for low level status notification changes. This system is designed for low level control design and is not intended to be used directly by JungleGui coders, but just as a matter of documenting what's going on:

When a Msg has completed its whole Msg chain from the control that got the message in the first place, to the latest control in its parent chain (the Form or TopLevelControl), if the Msg has not been canceled, the Control will automatically call its Dispatch method, that will then check the msg signature and Raise an event in the corresponding EventHandler of the control.