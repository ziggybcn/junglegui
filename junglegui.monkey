#rem monkeydoc Module junglegui
	This is the JungleGui module.
#END
'----------
Import mojo
Import fontmachine
Import reflection

#If TARGET="html5"
Import dom
#End

'Imports:
Import core
Import events
Import common

Import wip.vscrollbar
Import wip.combobox
Import wip.scrollablecontrol
Import wip.multilinetexteditor



Import propertygrid

#print ""
#print ""
#print "Jungle Gui license:"
#print "-------------------"
#print "Copyright (c) 2014, Manel Ibáñez"
#print "All rights reserved."
#print ""
#print "Redistribution and use in source and binary forms, with or without"
#print "modification, are permitted provided that the following conditions are met: "
#print ""
#print "1. Redistributions of source code must retain the above copyright notice, this"
#print "   list of conditions and the following disclaimer. "
#print "2. Redistributions in binary form must reproduce the above copyright notice,"
#print "   this list of conditions and the following disclaimer in the documentation"
#print "   and/or other materials provided with the distribution. "
#print ""
#print "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND"
#print "ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED"
#print "WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE"
#print "DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR"
#print "ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES"
#print "(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;"
#print "LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND"
#print "ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT"
#print "(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS"
#print "SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
#print ""
#print "The views and conclusions contained in the software and documentation are those"
#print "of the authors and should not be interpreted as representing official policies,"
#print "either expressed or implied, of the FreeBSD Project."
#print ""
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

#IF TARGET="html5"
	Extern Private
		Global win:windowExtended = "window"
		Class windowExtended Extends Window = "Window"
			Field innerWidth
			Field innerHeight
			Method eval:Object(parameter:String) = "eval"
		End
	Public
#END

'--------
'Functions:

Function EnableAutoSize:Void(canvasName:String = "GameCanvas")
	#If TARGET="html5"
		Print "Working on Enable Auto size"
		Local elem:= document.getElementById(canvasName)
		If elem <> Null Then
			elem.setAttribute("style", "");
		EndIf
		win.eval("var canvas=document.getElementById( '" + canvasName + "' );canvas.onresize=null;");
		win.eval("window.onresize=function (e) {var canvas=document.getElementById( '" + canvasName + "' ); canvas.width = window.innerWidth; canvas.height = window.innerHeight; canvas.style='';} ;")		
		win.eval("window.onresize()")
		
<<<<<<< local
		Local console:= document.getElementById("GameConsole")
		If console <> Null Then
			console.setAttribute("height", "0");
			'console.parentNode.removeChild(console);
		EndIf


		Local splitter:= document.getElementById("Splitter")
		If splitter <> Null Then
			splitter.setAttribute("style", "height: 8px;")
			'splitter.setAttribute("clientHeight", "0")
			
			'splitter.parentNode.removeChild(splitter)
		EndIf

		document.execCommand("eval('window.onresize=null;');");
		Local el:= New EventListener
		
		
		
		Local elem:= document.getElementById(canvasName)
		Print elem.getAttribute("width") + ", " + elem.getAttribute("height")
		If elem <> Null Then
			Local nodesList:= elem.childNodes
			Print "Items + " nodesList.length
			For Local i:Int = 0 Until elem.childNodes.length
				Local nod:dom.Node = elem.childNodes.item(i)
				Print nod.toString
			Next
			elem.setAttribute("width", win.innerWidth)
			elem.setAttribute("height", win.innerHeight)
			elem.setAttribute("style", "")
		EndIf
=======
>>>>>>> other
	#End
End


'#IF TARGET="html5"
'	Extern
'	Function ResizeCanvasFull:Void()
'	Function EnableAutoSize:Void()
'	Function DisableAutoSize:Void()
'	Public
'	
'#ELSE
'	Function ResizeCanvasFull:Void()
'	End
'	Function EnableAutoSize:Void()
'	End
'	Function DisableAutoSize:Void()
'	End
'#END
'
 