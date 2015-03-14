# Creating a custom control for JungleGui #
First of all, when creating a custom control, you have to choose wich base class to extend. there are (currently) 3 base classes that can be choosen to create a custom control:

## Control ##
This is the base class for regular components that conform simple self-contained tasks such as Buttons, Labels, TextFields, etc. This control implements an internal Msg and Dispatch system so it is able to handle all low-level messages from the Gui system, and it also provides a set of Event handlers to let the control user interact with it.

## ControlContainer ##
This class inherits Control, and it is the base class that should be extended by any control that can contain any (whatever) other controls. As instance, the Panel class extends this control, as it is a typical control container.

## TopLevelControl ##
This is the base class for controls that can't be parented to other controls, such as Forms (windows).

## Extending other non-base controls ##
Obviously you can choose and extend any other control to create a new control, but you should be careful to choose a control that won't be modified a lot on further updates, as this could break usability on your newly created one.

It's highly recommended to extend directly the bases classes when possible, unless you're extending a control that has very similar usability and minor differences.