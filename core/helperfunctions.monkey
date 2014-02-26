Import junglegui
Import scaledscrissor

Function DrawBox(x:Int, y:Int, width:Int, height:Int)
	DrawBox(float(x), float(y), float(width), float(height))
End

Function DrawBox(x:Float, y:Float, width:Float, height:Float)
	DrawRect(x, y, width - 1, 1) '---
	DrawRect(x, y, 1, height - 1) '|--
	DrawRect(x + width - 1, y, 1, height - 1)'--| 
	DrawRect(x, y + height - 1, width, 1) '___	
End

Function DrawBox(position:GuiVector2D, size:GuiVector2D )
	DrawBox(position.X, position.Y, size.X, size.Y)
End

Function DrawRoundBox(x:Float, y:Float, width:Float, height:Float)
	DrawRect(x + 1, y, width - 2, 1) '---
	DrawRect(x, y + 1, 1, height - 2) '|--
	DrawRect(x + width - 1, y + 1, 1, height - 2)'--| 
	DrawRect(x + 1, y + height - 1, width - 2, 1) '___
End

Function DrawRoundBox(x:Int, y:Int, width:Int, height:Int)
	DrawRoundBox(float(x), float(y), float(width), float(height))
End

Function DrawRoundBox(position:GuiVector2D, size:GuiVector2D)
	'DrawRect(position.X+1,position.Y,size.X-2,1) '--- 
	'DrawRect(position.X,position.Y+1,1,size.Y-2) '|-- 
	'DrawRect(position.X+size.X-1,position.Y+1,1,size.Y-2)'--| 
	'DrawRect(position.X+1,position.Y+size.Y-1,size.X-2,1) '___ 
	DrawRoundBox(position.X, position.Y, size.X, size.Y)
End


'Function DrawFocusRect(control:Control, round:Bool = False)
'	Local alpha:Float = GetAlpha()
'	Local oldcolor:Float[] = GetColor()
'	SetAlpha(math.Abs(Sin(Millisecs() / 5.0)))
'	SystemColors.FocusColor.Activate()
'	Local pos:= control.UnsafeRenderPosition()
'	Local size:= control.Size.Clone()
'	If Not round Then
'		DrawBox(pos, size)
'	Else
'		DrawRoundBox(pos, size)
'	endif
'	SetColor 255, 255, 255
'	SetAlpha(alpha)
'	SetColor oldcolor[0], oldcolor[1], oldcolor[2]
'End

Class SystemColors
	'Color values are now set at the renderer initialization, so they are kept between renderer changes
	Global ControlFace:GuiColor = New GuiColor
	Global ButtonBorderColor:GuiColor = New GuiColor
	Global FocussedButtonBorderColor:GuiColor = New GuiColor
	Global AppWorkspace:GuiColor = New GuiColor
	Global FocusColor:GuiColor = New GuiColor
	Global FormBorder:GuiColor = New GuiColor
	Global WindowColor:GuiColor = New GuiColor
	Global FormMargin:GuiColor = New GuiColor
	Global InactiveFormBorder:GuiColor = New GuiColor
	Global SelectedItemBackColor:GuiColor = New GuiColor
	Global HooverBackgroundColor:GuiColor = New GuiColor
	#IF TARGET<>"html5"
		Global WindowTextForeColor:GuiColor = New GuiColor
		Global SelectedItemForeColor:GuiColor = New GuiColor
	#ELSE 
		Global WindowTextForeColor:GuiColor = New GuiColor
		Global SelectedItemForeColor:GuiColor = New GuiColor
	#END
	Global ItemsListHooverBackColor:= New GuiColor
	Global ItemsListSelectedBackColor:= New GuiColor
	Global ItemsListHooverBorderColor:= New GuiColor
	Global ItemsListSelectedBorderColor:= New GuiColor
	
	Global ScrollerBackColor:= New GuiColor
	Global ScrollerGrabberColor:= New GuiColor
	

End


Function HasFlag:Bool(value:Int, flag:Int)
	Return( (value & flag) = flag)
End

Function RemoveFlag:Int(value:Int, flag:Int)
	value = value & ~ flag
	Return value
End

Function SetFlag(value:Int, flag:Int)
	value = value | flag
	Return value
End

#REM
	
struct Rect 
{ 
    Rect(int x1, int x2, int y1, int y2) 
    : x1(x1), x2(x2), y1(y1), y2(y2) 
    { 
        assert(x1 < x2); 
        assert(y1 < y2); 
    } 
 
    int x1, x2, y1, y2; 
}; 
 
bool 
overlap(const Rect &r1, const Rect &r2) 
{ 
    // The rectangles don't overlap if 
    // one rectangle's minimum in some dimension  
    // is greater than the other's maximum in 
    // that dimension. 
 
    bool noOverlap = r1.x1 > r2.x2 || 
                     r2.x1 > r1.x2 || 
                     r1.y1 > r2.y2 || 
                     r2.y1 > r1.y2; 
 
    return !noOverlap; 
} 
#END

Function RectsOverlap:Bool(point1:GuiVector2D,size1:GuiVector2D,point2:GuiVector2D,size2:GuiVector2D)
   Local noOverlap:Int = (point1.X > (point2.X + size2.X)) ~
                     (point2.X > (point1.X + size1.X)) ~ 
                     (point1.Y > (point2.Y + size2.Y)) ~ 
                     (point2.Y > (point1.Y + size1.Y))  
 
    return noOverlap=0; 
	
End