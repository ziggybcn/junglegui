# Dealing with Mouse and Keyboard on a Control #

When working with Jungle Gui, it is important to use the Gui built-in I/O options to deal with mouse and keyboard instead of calling Mojo functinoality, as it can conflict due of data being collected from the I/O stack from several places at the same time.

To do so, you may use this functions inside your controls:

### GetGui.**IsKeydown**(keycode:Int) ###
This method returns True or False if the specified key is down.

### GetGui.MousePos ###
This method returns the current mouse position in the form of a Gui2DVector. Check its X and Y properties to get the mouse position.

Additionaly, we provide this useful functions:

## GetGui.GetMousePointedControl ##
This returns the control that is under the mouse pointer, or Null if there is no control


## GetGui.ActiveControl ##
This returns the control that has the application focus