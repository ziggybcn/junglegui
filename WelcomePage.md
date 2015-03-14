# Introduction #

This module provides a simple but powerful and easy to use GUI system for Mojo games and applications.

Current status is that this project has very basic functionality. Main areas that need work are:
  * There are no menus
  * There are not tab controls
  * There is not any kind of multiline text control (maybe some changes to FontMachine will have to be done)

# About the documentation here #
**IMPORTANT:** The documentation here is not the usage documentation for this library. The documentation here is the advanced and lower level documentation regarding the library internals and how to extend it and create custom controls for it,etc. Library usage documentation is being built and it'll be available in the library itself.

current system supports:

Base classes:
  * Gui (this is the main gui handler, it "contains" everything)
  * Control
  * ControlContainer (extends Control)
  * TopLevelControl (extends ControlContainer)
  * BaseLabel (Extends control and handles text)

Then controls:
  * Form (extends TopLevelControl)
  * Panel (extends ControlContainer)
  * Label (extends BaseLabel)
  * Button (extends BaseLabel)
  * ProgressBar (extends Control)
  * EditField (extends BaseLabel)
  * Timer (extends Control)
  * CheckBox (extends BaseLabel)
  * RadioButton (extends CheckBox)

Current list of supported events:
MOVED, PARENT\_REMOVED, PARENT\_SET, BRING\_TO\_FRONT, SEND\_TO\_BACK, MOUSE\_ENTER, MOUSE\_LEAVE, LOST\_FOCUS, GOT\_FOCUS, MOUSE\_DOWN, MOUSE\_UP, CLICK, KEY\_DOWN, KEY\_UP, KEY\_PRESS, PADDING\_MODIFIED, PARENT\_RESIZED, RESIZED, MOUSE\_MOVE, INIT\_FORM, TIMER\_TICK, VISIBLE\_CHANGED, CHECKED\_CHANGED, TEXT\_CHANGED, SLIDING\_VALUE\_CHANGED, SLIDING\_MAXIMUM\_CHANGED, CUSTOM\_CREATED\_EVENT

# Details #

This project is currently on very early days of development. Details to come soon