# Introduction #

JungleGui defines 4 classes that encapsulate mostly all of the Gui system. Those classes are:

  * Gui
  * Control
  * ContainerControl
  * TopLevelControl

# Gui #

This class encapsulates all the management of Gui elements on an application. If an application has several Forms, and each Form has several controls in it, you don't have to deal with each control separatelly, a Gui class instance will handle everything for you. You may think about the Gui class as it is the "Gui" engine itself. When you create a form in your source code, you attach it to a Gui, so it is handled properly.

# Control #

All elements that are hanled by a Gui are controls. A control can be a Window, a Button, a TextField, a Panel, a Timer. Anything that can be attached to a Form is a control. That means that all Gui controls on JungleGui extend this base class.

# ContainerControl #

This is a control (extends it) that has the hability to contain other controls inside. All controls that can contain other controls do extend the ContainerControl class.

# TopLevelControl #

This is a control that can contain other controls (extends ContainerControl) and that also is the final target of events raised by any of its contained controls, no mather how nested they are.

As instance, a Form (a window) is a TopLevelControl. Whenever a button inside this window is Clicked, this event will reach the window in a way that a speciffic action can be performed.