# Naming convention #

This project code should follow standard Monkey naming convention with some additions:

  * Any group of consts that are used for a single task, will be merged together on a single abstract class which name will start with a lowercase "e" followed by logical entity name. This lowercase "e" means "enumeration" and just indicates that this class is a collection of Const that are related and used for the same task. As instance, all message signatures are defined on the class eEventKinds with this code:
```

Class eMsgKinds Abstract
Const MOVED:Int = 1
Const PARENT_REMOVED:Int = 2
Const PARENT_SET:Int = 3
Const BRING_TO_FRONT:Int = 4
Const SEND_TO_BACK:Int = 5
Const MOUSE_ENTER:Int = 6
Const MOUSE_LEAVE:Int = 7
Const LOST_FOCUS:Int = 8
Const GOT_FOCUS:Int = 9
Const MOUSE_DOWN:Int = 10
...
...
End
```

**Note from the author**: I usualy make the mistake of using a first uppercase letter on parameters or local variables. Whenever you see this in code, it should be corrected.

# Datatype shortcuts. #

While the Monkey programing language supports datatype shortcuts such as ?, #, $ or #, we won't use them on the Jungle Gui source code. It makes source code harder to understand to people that does not come directly from the Blitz world.

# IDEs and editors #

We recommend that Jungle Ide is used for the coding of this module to keep code consistent (see below). This project hopefully will not reach the limit of 60 source code files of Jungle LITE, so you can use the free version of Jungle to participate on this module development.

As we're recommending [Jungle Ide](http://www.jungleide.com) as the default IDE for this project, we'll be including Jungle Solution and Jungle Project files in the repository. If you decide to not use Jungle, or you're coding on a Mac or in any platform not supported by Jungle Ide, feel free to ignore those files.

# Expressions on code #

We recommend the usage of Jungle Ide automatic source code formatting to make the source code of the whole project look the same everywhere. this will also make any merging easier.

**But I'm on a Mac!**
Why are you doing this!? Now... seriously, if you can't use Jungle Ide or LITE to contribute to this project, don't worry. Do it without it, all help is always welcome! (Jungle does work like a charm on Parallels or in VMWare'd windows).

# Strict mode #
We won't be using Strict mode on Jungle Gui source code. Standard Monkey syntax is strict enough