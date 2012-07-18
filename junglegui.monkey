'-----------
'Imports:
Import control
Import form
Import panel
Import fontmachine
Import baselabel
Import button
Import textfield
Import guiexception
Import progressbar
Import timer
Import guiinterfaces
Import label
Import checkbox
Import radiobutton
Import slider
Import trackbar
Import msgbox

#IF TARGET="html5"
	Import "resizecanvas/resizecanvas.js"
#END

#print ""
#print "           ----------------------------------------------------------------------"
#print "ATTENTION: This application uses the JungleGui module wich is ©Manel Ibáñez 2012"
#print "           Jungle Gui has been released as an open source project."
#print "           Use at your own risk."
#print "           ----------------------------------------------------------------------"
#print ""

#If TARGET="html5"
	Import "data\html5font.txt"
	Import "data\html5font_P_1.png"
	Import "data\html5TipFont.txt"
	Import "data\html5TipFont_P_1.png"
#ELSE
	Import "data\smallfont1_P_1.png" 
	Import "data\smallfont1.txt"
	Import "data\TipFont.txt"
	Import "data\TipFont_P_1.png"
#END

'--------
'Functions:

#IF TARGET="html5"
	Extern
	Function ResizeCanvasFull:Void()
	Function EnableAutoSize:Void()
	Function DisableAutoSize:Void()
	Public
	
#ELSE
	Function ResizeCanvasFull:Void()
	End
	Function EnableAutoSize:Void()
	End
	Function DisableAutoSize:Void()
	End
#END
 