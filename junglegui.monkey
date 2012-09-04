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
Import boxedmsg
Import scrollbar
Import listbox
Import combobox
Import propertygrid
Import renderer

#IF TARGET="html5"
	Import "resizecanvas/resizecanvas.js"
#END

#print ""
#print "           ----------------------------------------------------------------------"
#print "ATTENTION: This  JungleGui module wich is released under the BSD-2 License "
#print "           Use at your own risk. See the source code for license details"
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

#REM
Copyright (c) 2012, Manel Ibáñez
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#END
 