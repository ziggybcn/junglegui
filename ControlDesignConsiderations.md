# Including child controls #

The only controls allowed to include child controls are ControlContainer(s) and TopLevelControl(s).

Bear in mind that this will let the control users to add absolutely any control they wish to your newly created control, as your control will itself be a **control container**.

It is recommended to not include any sub-control in a control when possible. We will avoid as much as possible that a control, when it is created, it creates child controls to itself. We want to keep this Gui system fast end easy to maintain and it is usually a bad idea to over-complicate controls structure and tree in the core of the gui system.