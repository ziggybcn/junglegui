Import junglegui
#REFLECTION_FILTER+="junglegui.propertygrid*"

'summary: Provides a user interface for browsing the properties of an object.
Class PropertyGrid extends ScrollableControl

Private

	Global _cachedPosition:= New GuiVector2D
	
	field _selectedItem:PropertyItem
	field _selectedIndex:Int = 0
	Field _selectedObject:Object
	Field _properties:= new List<PropertyItem>
	Field _visibleItems:int = 0
	Field _selectedItemPos:= new GuiVector2D
	Field _itemsCount:Int
	Field _itemHeight:Int = Gui.systemFont.GetFontHeight() + 4
	Field _font:BitmapFont
	Field _leftPadding:Int
	Field _rightPadding:Int
	Field _leftWidth:Int
	Field _rightWidth:Int
	Field _lastItem:PropertyItem
	Field _useFields:Bool = true
	

Public
			
	Method New(x:Float, y:Float, width:Float, height:Float, parent:ContainerControl)
		Position.SetValues(x, y)
		Size.SetValues(width, height)
		Parent = parent
		_leftPadding = 15
		_rightPadding = _scrollbar.DefaultWidth
		_leftWidth = (width - _leftPadding - _rightPadding) / 2
		_rightWidth = (width - _leftPadding - _rightPadding) / 2
	End
	
	Method Update()
		Super.Update()
		if UiTypeEditor.ShowErrorDialog Then
			UiTypeEditor.ShowErrorDialog = false
			if _lastItem Then
				_lastItem.UiTypeEditor_.ShowDialog(Parent)
			End
		End
	End
	
	Method SelectedIndex:Void(value:Int) Property

		Local i:Int = 0
		Local node:= _properties.FirstNode(), done:Bool = false

		if value < 0 Then done = true
		While done = False And node <> null
			if i = value Then
				_selectedItem = node.Value
				_selectedIndex = value
				Local y:Float = (_itemHeight - 1) * (i - _scrollbar.Value)
				_selectedItemPos.SetValues(_leftPadding + _leftWidth, 1 + y)
				return
			EndIf
			i += 1
			node = node.NextNode
		Wend
		
		'index out of bounds:
		_selectedItem = null
		_selectedIndex = -1
	End
	
	'summary: Gets the object for which the grid displays properties.
	Method SelectedObject:Object()
		Return _selectedObject
	End
	
	'summary: Sets the object for which the grid displays properties.
	Method SelectedObject(value:Object)
		_selectedObject = value
		UpdateProperties()
	End
	
	Field _editable? = true 
	
	Method Editable?() Property
		Return _editable
	End
	
	Method Editable(val?) Property
		_editable = val 
	End
	
	Method Msg(msg:BoxedMsg)
		if Editable Then 
			if msg.sender = Self Then
			
				Select msg.e.messageSignature
				
					Case eMsgKinds.MOUSE_DOWN
						
						Local me:= MouseEventArgs(msg.e)
						if ScrollbarVisible And me.position.X >= _scrollbar._pos.X
						Else if me.position.X < Size.X - _scrollbar.DefaultWidth Then
							
							_lastItem = _selectedItem
							PickItem(me.position.Y)
		
							if me.position.X > _leftPadding + _leftWidth Then
								' show type ui editor
								if _selectedItem And _selectedItem.UiTypeEditor_ Then
									_selectedItem.UiTypeEditor_.EditValue(_selectedItem, me.position)
								EndIf
							End
							
						End
				End
			End
		End 
		Super.Msg(msg)
	End
	
	Method UpdateProperties()
		_properties.Clear()
		if _selectedObject Then
			Local ci:= GetClass(_selectedObject)
			Local fields:= ci.GetFields(true)
			For Local f:= eachin fields
				local p:= new PropertyItem(_selectedObject, f)
				p._propertyGrid = Self
				_properties.AddLast(p)
			Next
			UpdateScrollBar(true)
		EndIf
	End
	
	Method PickItem(y:Float)
		SelectedIndex = (y) / (_itemHeight - 1) + _scrollbar.Value
	End
	
	Method Render:Void()
		Local drawpos:= CalculateRenderPosition()
		
		'
		' render background
		'
		SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
		DrawRect(drawpos.X, drawpos.Y, Size.X, Size.Y)

		ForeColor.Activate()	'It is 255,255,255 on HTML5 while 0,0,0 on non HTML5
		Local done:Bool = false, node:= _properties.FirstNode(), i:Int = 0
		While done = false 'And node <> null
		
			if node = null Then
				done = True
				Continue
			EndIf
			
			Local p:= node.Value
			
			if i >= _scrollbar.Value and i < (_scrollbar.Value + _visibleItems+1) Then
			
				Local y:Float = (_itemHeight - 1) * (i - _scrollbar.Value)
				
				'
				' Draw the name
				'
				if SelectedIndex = i Then
					SystemColors.SelectedItemBackColor.Activate()
					DrawRect _leftPadding + drawpos.X + 1, y + drawpos.Y + 1, _leftWidth - 2, _itemHeight - 2					
					SystemColors.SelectedItemForeColor.Activate()
					#IF TARGET="html5"
					SetColor(255, 255, 255)
					#END
					Font.DrawText(p.Name, _leftPadding + 3 + drawpos.X + 1, y + 1 + drawpos.Y + 3, 0)
				Else
					SetColor(255, 255, 255)
					DrawRect _leftPadding + drawpos.X + 1, y + drawpos.Y + 1, _leftWidth - 2, _itemHeight - 2
					ForeColor.Activate()
					#IF TARGET="html5"
					SetColor(255, 255, 255)
					#END
					Font.DrawText(p.Name, _leftPadding + 3 + drawpos.X + 1, y + 1 + drawpos.Y + 3, 0)
				EndIf
				
				'
				' Draw the value
				'
				SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
				DrawRect _leftPadding + _leftWidth + drawpos.X, 1 + y + drawpos.Y, _leftWidth, _itemHeight
				SetColor 255, 255, 255
				DrawRect _leftPadding + _leftWidth + drawpos.X, y + drawpos.Y + 1, _rightWidth - 1, _itemHeight - 2
				if p.TypeConverter_ Then
					
					Local str:= p.TypeConverter_.ConvertToString(p.Value)
					ForeColor.Activate()
					#IF TARGET="html5"
					SetColor(255, 255, 255)
					#END
					Font.DrawText(str, _leftPadding + _leftWidth + drawpos.X + 3, y + 1 + drawpos.Y + 3, eDrawAlign.LEFT)
					
				EndIf
			
			ElseIf i >= (_scrollbar.Value + _visibleItems)
				done = True
			ElseIf node = null
				done = true
			endif
			i += 1
			node = node.NextNode
		wend
		
		
		if HasFocus Then
			'GetGui.Renderer.DrawFocusRect(Self, True)
		Else
			' bottom outline could be overwritten?
			SetColor(BackgroundColor.r, BackgroundColor.g, BackgroundColor.b)
			SetAlpha 1
			DrawLine drawpos.X, drawpos.Y + Size.Y, drawpos.X + Size.X, drawpos.Y + Size.Y
		End
		Super.Render()
	End
	
	Method RenderBackground()
		Super.RenderBackground()
		If HasFocus Then GetGui.Renderer.DrawFocusRect(Self, True)
'		Local drawpos:= CalculateRenderPosition
'		SetColor(255, 0, 0)
'		DrawRect(drawpos.X, drawpos.Y, Size.X, Size.Y)
'		SetColor(255, 255, 255)
	End
	
	Method SelectedItemPosition:GuiVector2D()
		Return _selectedItemPos
	End
		
	Method Font(value:BitmapFont) Property
		_font = value
		_itemHeight = Font.GetFontHeight + 4 'This will get _font or SytemFont if _font is null.
	End
	
	Method Font:BitmapFont() property
		if _font<>null Then Return _font Else Return GetGui.systemFont
	End
	
	Method UpdateScrollBar(recountItems:Bool)
		if recountItems then _itemsCount = _properties.Count
		_visibleItems = Max(0, Min(_itemsCount, int(Size.Y / (_itemHeight - 1))))
		_scrollbar.ItemsCount = _itemsCount
		_scrollbar.VisibleItems = _visibleItems
	End
	
	Method SelectedIndex:Int() Property
		Return _selectedIndex
	End
	
End


' summary: Encapsulates a propertygrids's item entry.	
Class PropertyItem
Private

	Global UiTypeEditorMap:= new StringMap<UiTypeEditor>
	
	' strings for displaying in the property-grid
	'Field _cathegory:String
	'Field _description:String
	'Field _displayName:String
	Field _name:String
	
	' ui / editing
	Field _uitypeEdit:UiTypeEditor
	Field _typeConv:TypeConverter
	
	' the accociated object/property
	Field _context:object
	Field _fieldInfo:FieldInfo
	Field _propertyGrid:PropertyGrid
	
Public

	Method GetUiTypeEditor:UiTypeEditor(typeName:String, context:Object)
		if UiTypeEditorMap.Contains(typeName) Then
			return UiTypeEditorMap.Get(typeName)
		else
			Local tmp:= UiTypeEditor.Create(typeName, context)
			UiTypeEditorMap.Set(typeName, tmp)
			Return tmp
		End
	End
	
	Method new(context:Object, f:FieldInfo)
		_context = context
		_fieldInfo = f
		_name = f.Name
		Try
			_typeConv = TypeConverter.Create(f.Type.Name)
			Select f.Type.Name
				Case "monkey.boxes.IntObject"
					_uitypeEdit = GetUiTypeEditor("Default_UiTypeEditor", _context)
				case "monkey.boxes.FloatObject"
					_uitypeEdit = GetUiTypeEditor("Default_UiTypeEditor", _context)
				case "monkey.boxes.StringObject"
					_uitypeEdit = GetUiTypeEditor("Default_UiTypeEditor", _context)
				Case "monkey.boxes.BoolObject"
					_uitypeEdit = GetUiTypeEditor("List_UiTypeEditor", _context)
				Default
					_uitypeEdit = GetUiTypeEditor(_name + "_UiTypeEditor", _context)
			End
		Catch err:Throwable
			Print "Failed to create propertyItem uiTypeEditor " + _name + ":" + f.Type.Name
		End Try
	End
	
#rem
	Method Cathegory:String() Property
		Return _cathegory
	End
	
	Method Description:String() Property
		Return _description
	End
	
	Method DisplayName:String() Property
		Return _displayName
	End
#end 

	Method Name:String() Property
		Return _name
	End
	
	Method UiTypeEditor_:UiTypeEditor() Property
		Return _uitypeEdit
	End
	
	Method TypeConverter_:TypeConverter() Property
		Return _typeConv
	End
	
	Method Value:Object() Property
		Return _fieldInfo.GetValue(_context)
	End
	
	Method Value:Void(value:Object) Property
		_fieldInfo.SetValue(_context, value)
	End
	
End

#rem
 summary:
 Provides a unified way of converting types of values to other types, as well as for accessing 
 standard values and subproperties.	
#END
Class TypeConverter

	Global TypeConverterMap:StringMap<TypeConverter>

	Function Create:TypeConverter(type:String)
	
		'' Inits type converter map, first time this is called
		if TypeConverterMap = Null Then
			Local base:= GetClass("TypeConverter")
			TypeConverterMap = new StringMap<TypeConverter>
			Local classes:= GetClasses()
			For Local c:ClassInfo = eachin classes
				if c.ExtendsClass(base) Then
					Local constr:= c.GetConstructors()
					if constr.Length > 0 Then
						Local value:= TypeConverter(constr[0].Invoke([]))
						if value Then TypeConverterMap.Set(value.SourceType(), value)
					End
				End
			End
		End
		
		'' try to get proper TypeConverter
		if TypeConverterMap.Contains(type) Then
		
			Return TypeConverterMap.Get(type)
			
		End
		
		Return null
	End
	
	Method SourceType:String() Abstract
	Method ConvertFromString:object(str:String) abstract
	Method ConvertToString:String(obj:Object) abstract
	Method GetStandardValuesSupported:Bool() abstract
	Method GetStandardValues:List<String>() Abstract
End

#rem
 summary:
 Provides a base class that can be used to design value editors that can provide
 a user interface (UI) for representing and editing the values of objects
 of the supported data types.
#end 
Class UiTypeEditor

	Global ShowErrorDialog:Bool = false' hacky
	Global ErrorString:String
	
	'' TODO: Init  global contructor stringmap, for fast object creation?
	Function Create:UiTypeEditor(type:String, context:Object)
		Local classInfo:= GetClass(type)
		if classInfo Then
			Local constructors:= classInfo.GetConstructors()
			if constructors.Length > 0 Then
				return UiTypeEditor(constructors[0].Invoke([context]))
			End
		End
		Return null
	End
	
	' Override the EditValue method to handle the user interface, user input processing, 
	' and value assignment.
	Method EditValue(obj:Object, pos:GuiVector2D) abstract
	
	' Override the GetEditStyle method to inform the Properties window of the type of editor 
	' style that the editor will use.
	Method GetEditStyle() abstract

	' Override GetPaintValueSupported to indicate that the editor supports displaying 
	' the value's representation.
	Method GetPaintValueSupported() abstract
	
	' Override PaintValue to implement the display of the value's representation.
	Method PaintValue(obj:Object, pos:GuiVector2D, size:GuiVector2D) Abstract
	
	Method Dispose() Abstract
	
	' TODO: 	Add proper type conversion error handling.
	' 			Currently its ugly, and this method sucks. 
	'			Format errors should be handled inside PropertyGrid?
	Method ShowDialog(parent:ContainerControl) abstract
	
End

' summary: Specifies identifiers that indicate the value editing style of a UITypeEditor.
Class eUITypeEditorEditStyle
	Const NONE:Int = 0
	Const MODAL:Int = 1
	Const DROPDOWN:Int = 2
End

' summary: TypeConverter for String type
Class String_TypeConverter extends TypeConverter

	Method SourceType:String()
		Return "monkey.boxes.StringObject"
	End
	
	Method ConvertFrom:object(obj:Object)
		Return StringObject(obj)
	End
	
	Method ConvertFromString:object(str:String)
		Return new StringObject(str)
	End
	
	Method ConvertToString:String(obj:Object)
		Return StringObject(obj)
	End
	
	Method GetStandardValuesSupported:Bool()
		Return False
	End
	
	Method GetStandardValues:List<String>()
		return Null
	End
End

' summary: TypeConverter for Bool type, using StandardValues
Class Bool_TypeConverter extends TypeConverter
	
	Field _stdValues:= new List<String>
	
	Method new()
		_stdValues.AddLast("TRUE")
		_stdValues.AddLast("FALSE")
	End
	
	Method SourceType:String()
		Return "monkey.boxes.BoolObject"
	End

	Method ConvertFromString:object(str:String)
		if str.ToUpper = "TRUE" Then
			Return new BoolObject(true)
		Else
			Return New BoolObject(false)
		EndIf
	End
	
	Method ConvertToString:String(obj:Object)
		local bo:= BoolObject(obj)
		if bo.value Then
			return New StringObject("TRUE")
		Else
			return New StringObject("FALSE")
		EndIf
	End
	
	Method GetStandardValuesSupported:Bool()
		Return True
	End
	
	Method GetStandardValues:List<String>()
		return _stdValues
	End
End

' summary: TypeConverter for Int type
Class Int_TypeConverter extends TypeConverter

	Method SourceType:String()
		Return "monkey.boxes.IntObject"
	End
	
	Method ConvertFromString:object(str:String)
	
		For Local i = 0 until str.Length
			if str[i] < 48 Or str[i] > 57 Then
				Throw New JungleGuiException("Int_TypeConverter: Wrong format.", Null)
			End
		Next
	
		Return New IntObject(Int(str))
	End
	
	Method ConvertToString:String(obj:Object)
		local io:= IntObject(obj)
		Return New StringObject(io.value)
	End
	
	Method GetStandardValuesSupported:Bool()
		Return false
	End
	
	Method GetStandardValues:List<String>()
		return null
	End
End

' summary: TypeConverter for Float type
Class Float_TypeConverter extends TypeConverter

	Method SourceType:String()
		Return "monkey.boxes.FloatObject"
	End
	
	Method ConvertFromString:object(str:String)
	
		' Todo: Do proper float parsing
		Local column:Bool = false
		
		For Local i = 0 until str.Length
			if Not column And str[i .. i + 1] = "." Then
				column = true
				Continue
			EndIf
			if str[i] < 48 Or str[i] > 57 Then
				Throw New JungleGuiException("Float_TypeConverter: Wrong format.", Null)
			End
		Next

		Return New FloatObject(float(str))
	End
	
	Method ConvertToString:String(obj:Object)
		local io:= FloatObject(obj)
		Return New StringObject(io.value)
	End
	
	Method GetStandardValuesSupported:Bool()
		Return false
	End
	
	Method GetStandardValues:List<String>()
		return null
	End
End

' summary: Used for string/int/float
Class Default_UiTypeEditor extends UiTypeEditor

	Field _tf:TextField
	field _selectedItem:PropertyItem
	
	
	Method EditValue(obj:Object, pos:GuiVector2D)

		if _tf <> null Then
			Dispose()
		End
		
		_selectedItem = PropertyItem(obj)

		_tf = New TextField
		_tf.AutoAdjustSize = false
		_tf.Event_LostFocus.Add(Self, "tf_LostFocus")
		_tf.Position.SetValues(_selectedItem._propertyGrid.Position.X + _selectedItem._propertyGrid.SelectedItemPosition.X,
							   _selectedItem._propertyGrid.Position.Y +_selectedItem._propertyGrid.SelectedItemPosition.Y)
							   
		_tf.Size.SetValues(_selectedItem._propertyGrid._rightWidth - 1, Gui.systemFont.GetFontHeight() + 2)
		_tf.Parent = _selectedItem._propertyGrid.Parent
		_tf.GetFocus()
		_tf.Visible = True
		_tf.BringToFront()
		_tf.Text = _selectedItem.TypeConverter_.ConvertToString(_selectedItem.Value)
		_selectedItem._propertyGrid.Event_GotFocus.Add(Self, "PropertyGrid_GotFocus")
		
	End
	
	Method GetEditStyle()
		Return eUITypeEditorEditStyle.NONE
	End

	Method GetPaintValueSupported()
		Return false
	End
	
	Method PaintValue(obj:Object, pos:GuiVector2D, size:GuiVector2D)
	End

	
Private

	Method ShowDialog(parent:ContainerControl)
		
		Local dlg:= new ErrorDialog(ErrorString)
		dlg.Position.SetValues(DeviceWidth / 2 - 100, DeviceHeight / 2 - 75)
		
		try
			dlg.InitForm(_selectedItem._propertyGrid.GetGui())
			dlg.BringToFront()
		Catch jge:JungleGuiException
			Print jge.ToString()
		End
			
	End
	
	Method PropertyGrid_GotFocus(sender:Object, e:EventArgs)
		Dispose()
	End
	
	Method tf_LostFocus(sender:Object, e:EventArgs)
		Dispose()
	End
	
	' the propertyItems value is also updated here, 
	' cause TextModified is called not just after the text change is finished.
	Method Dispose()
	
		
		' try update propertyItems value
		Try
		
			_selectedItem.Value = _selectedItem.TypeConverter_.ConvertFromString(_tf.Text)
			
		Catch err:JungleGuiException

			ShowErrorDialog = True
			ErrorString = err.ToString()
			
		End Try
		
		
		' release controls
		_tf.Dispose()
		_tf = null
		_selectedItem._propertyGrid.Event_GotFocus.Remove(Self, "PropertyGrid_GotFocus")
	End
End

'---------------------------------------------------------------------

Class List_UiTypeEditor extends UiTypeEditor

	Field _listBox:ComboBox
	Field _selectedItem:PropertyItem
	
	Method EditValue(obj:Object, pos:GuiVector2D)

		if _listBox <> null Then
			Dispose()
		EndIf
		
		Local item:= PropertyItem(obj)
		_selectedItem = item
		
		_listBox = New ComboBox(item._propertyGrid.Parent, 0, 0, 200)
		_listBox.Visible = false
		
		' add default values to combobox
		Local values:= item.TypeConverter_.GetStandardValues
		For Local v:= eachin values
			_listBox.Items.AddLast(New ListItem(v))
		Next
		
		Local str:= item.TypeConverter_.ConvertToString(item.Value)
		Local cnt = 0
		For Local v:= eachin values
			if str = v Then
				_listBox.SelectedIndex = cnt
				Exit
			EndIf
			cnt += 1
		Next

		_listBox.Event_LostFocus.Add(Self, "Lost_Focus")
		_listBox.Event_SelectedIndexChanged.Add(Self, "Combobox_IndexChanged")
		_listBox.GetFocus()
		_listBox.Parent = item._propertyGrid.Parent
		_listBox.Position.SetValues(item._propertyGrid.Position.X + item._propertyGrid.SelectedItemPosition.X,
									item._propertyGrid.Position.Y +item._propertyGrid.SelectedItemPosition.Y)
		_listBox.Size.SetValues(item._propertyGrid._rightWidth - 1, Gui.systemFont.GetFontHeight() + 2)
		_listBox.DropDownHeight = 60
		_listBox.Visible = True

		item._propertyGrid.Event_GotFocus.Add(Self, "PropertyGrid_GotFocus")
	End


	Method GetEditStyle()
		Return eUITypeEditorEditStyle.DROPDOWN
	End

	Method GetPaintValueSupported()
		Return false
	End
	
	Method PaintValue(obj:Object, pos:GuiVector2D, size:GuiVector2D)
	End
	
Private

	Method ShowDialog(parent:ContainerControl)
	End

	Method Combobox_IndexChanged(sender:Object, e:EventArgs)
		_selectedItem.Value = _selectedItem.TypeConverter_.ConvertFromString(_listBox.SelectedItem.Text)
	End
	
	Method PropertyGrid_GotFocus(sender:Object, e:EventArgs)
		Dispose()
	End
	
	Method Lost_Focus(sender:Object, e:EventArgs)
		if Not _listBox.ListBox.Visible Or Not _listBox.ListBox.HasFocus Then
			Dispose()
		End
	End
	
	Method Dispose()
		_listBox.Dispose()
		_listBox = null
		_selectedItem._propertyGrid.Event_GotFocus.Remove(Self, "PropertyGrid_GotFocus")
	End
End

'---------------------------------------------------------------------

Class GuiVector2_UiTypeEditor extends UiTypeEditor
End

'---------------------------------------------------------------------

Class GuiColor_UiTypeEditor extends UiTypeEditor
	
	function CreateInstance:UiTypeEditor()
		Return New GuiColor_UiTypeEditor
	End
	
	Method EditValue(obj:Object, pos:GuiVector2D)
		' show color selection dialog
	End
	
	Method GetEditStyle()
		Return eUITypeEditorEditStyle.NONE
	End

	Method GetPaintValueSupported()
		Return true
	End
	
	Method PaintValue(obj:Object, pos:GuiVector2D, size:GuiVector2D)
		SetColor 0, 0, 0
		DrawRect pos.X + 2, pos.Y + 2, size.X - 4, size.Y - 4
		Local color:= GuiColor(obj)
		if color Then
			SetColor color.r, color.g, color.b
			DrawRect pos.X + 2, pos.Y + 2, size.X - 4, size.Y - 4
		End
	End
	
	Method Dispose()
	End
	
	Method ShowDialog(parent:ContainerControl)
	End
End

Class ColorDialog
End


Class ErrorDialog extends Form

	Field button:Button
	Field _errStr:String
	
	Method new(str:String)
		_errStr = str
	End
	
	Method Update()
		Super.Update()
		BringToFront()' not modal, but at least always on top 
	End
	
	Method OnInit()
		Size.SetValues(200, 150)
		Text = "Format Error"
		
		'''
		''' button
		'''
		local button:= New Button
		button.Position.SetValues(10, 60)
		button.Text = "OK"
		button.AutoAdjustSize = false
		button.Size.SetValues(100, 25)
		button.Parent = Self
		button.Event_Click.Add(Self, "Button_Clicked")
		button.Parent = Self
		
		'''
		''' Info Label
		'''
		Local label:= new Label()
		label.Parent = Self
		label.Position.SetValues(10, 10)
		label.Text = _errStr
	End
	
	Method Button_Clicked(sender:Object, e:MouseEventArgs)
		Self.Dispose()
	End
	
End
