'This is a very small minimal sample

Import junglegui
Import junglegui.renderers.concretejungle

Import trans 

#REFLECTION_FILTER+="sample2*"

Function Main()
	New Sample2
End

Global gui:Gui
 
Class Sample2 extends App

	Field myForm:MyForm
	Method OnCreate()
		SetUpdateRate(60)
		EnableAutoSize()
		gui = New Gui	'We create the Gui manager.
		gui.Renderer = New ConcreteJungle
		myForm = New MyForm
		try
			myForm.InitForm(gui)
		Catch jge:JungleGuiException
			Print "Form could not be initialized becouse of an exception:"
			Print jge.ToString()
		End		
	End
	
	Method OnUpdate()
	
		
		try
			gui.Update()
		Catch jge:JungleGuiException
			Print "Error updating the Gui component:"
			Print jge.ToString()
			Error(jge.ToString())
		end
	End
	
	Method OnRender()
		Cls(0, 0, 105)
		try
		
			Local t:= Millisecs 
			
			
			gui.Render()
			
			SetColor 255,255,255
			Local time = Millisecs - t 
			DrawText time,10,10
			
		Catch jge:JungleGuiException
			Print "Error rendering the Gui component:"
			Print jge.ToString()
			Error(jge.ToString())
		end
	End
End

Class MyForm Extends Form

	Field listBox1:ListBox
	Field comboBox:ComboBox
	Field listView1:ListView
	Field listView2:ListView
	Field tabControl:TabControl 
	
	Method OnInit()
	
		'''
		''' MyForm
		'''
		Size.SetValues(500, 464)
		Position.SetValues(DeviceWidth / 2 - 255, DeviceHeight / 2 - 232)
		'Events.Add(Self, eMsgKinds.MOVED, "MyForm_Moved")
		Self.Event_Moved.Add(Self, "MyForm_Moved")
		
		local trackbar2:= New TrackBar
		listBox1 = New ListBox(10,10,150,250,Null)
		listView1 = New ListView(0,80, Self.Size.X-55, Self.Size.Y -260, Self)
		listView2  = New GameListView(0,0, 470, 180, Self)
		tabControl = New TabControl
		Local tabPage1:= new TabPage("Default")
		Local tabPage2:= new TabPage("Custom")
		Local tabPage3:= new TabPage("ListBox")
		Local label:= new Label()
		Local trackbar:= New TrackBar
		local label2:= New Label()
		
		'''
		''' tabControl
		'''
		tabControl.Position.SetValues(10,70)
		tabControl.Size.SetValues(Self.Size.X-40, Self.Size.Y -150)
		tabControl.Parent = Self 
		tabControl.TabPages.AddLast(tabPage1)
		tabControl.TabPages.AddLast(tabPage2)
		tabControl.TabPages.AddLast(tabPage3)
		tabControl.SelectedTab = tabPage3
		
		''
		'' label
		''
		label.Parent = tabPage1
		label.Position.SetValues(10, 5)
		label.Text = "Item Size: "
		
		'''
		''' trackbar
		'''
		trackbar.Parent = tabPage1
		trackbar.Parent = tabPage1
		trackbar.Position.SetValues(10, 25)
		trackbar.Event_ValueChanged.Add(Self, "Trackbar1_ValueChanged")
		trackbar.Minimum = 48
		trackbar.Maximum = 256
		trackbar.Tickfrequency = 4
		
		''
		'' label2
		''
		label2.Parent = tabPage1
		label2.Position.SetValues(230, 5)
		label2.Text = "Item Spacing: "
		
		'''
		''' trackbar
		'''
		trackbar2.Parent = tabPage1
		trackbar2.Position.SetValues(230, 25)
		trackbar2.Minimum = 2
		trackbar2.Maximum = 64
		trackbar2.Tickfrequency = 2
		trackbar2.Event_ValueChanged.Add(Self, "Trackbar2_ValueChanged")
		
		''
		'' listBox1
		''
		listBox1.Parent = tabPage3
		For Local i:= 0 until 20
			listBox1.Items.AddLast( New ListItem("test" + i) )
		Next

		'''
		''' listView1
		'''
		Local img1:= LoadImage("icon1.png")
		Local img2:= LoadImage("icon2.png")
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img1))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img2))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img1))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img2))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img1))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img2))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img1))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img2))
		listView1.Parent = tabPage1 
		listView1.Position.SetValues(10,80)
		listView1.Size.SetValues(tabPage1.Size.X-20, tabPage1.Size.Y-85)
		'''
		''' listView2
		'''
		Local map1:= LoadImage("map1.png")
		Local map2:= LoadImage("map2.png")
		Local map3:= LoadImage("map3.png") 
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map1))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map2))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map3))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map1))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map2))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map3))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", img1))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", img2))
		listView2.Parent = tabPage2 
		listView2.Position.SetValues(10,10)
		listView2.Size.SetValues(tabPage2.Size.X-20, tabPage2.Size.Y-20)
	End
	
	Method Trackbar1_ValueChanged(sender:Object, e:EventArgs)
		Self.Text = "trackbar1 value changed: " + TrackBar(sender).Value
		listView1.SetItemSize(TrackBar(sender).Value, TrackBar(sender).Value)
	End
	
	Method Trackbar2_ValueChanged(sender:Object, e:EventArgs)
		Self.Text = "trackbar2 value changed: " + TrackBar(sender).Value
		listView1.SetItemSpacing(TrackBar(sender).Value, TrackBar(sender).Value)
	End

	Method MyForm_Moved(sender:Object, e:EventArgs)
		Self.Text = "Moved to: " + Self.Position.X + ", " + Self.Position.Y
	End
	
End

'################################################################

Class GameListViewItem Extends ListViewItem

Private 

	Const WIDTH = 400
	Const HEIGHT = 72
 	
	Field _lblStatus:Label
	Field _lblIp:Label
	Field _lblMapName:Label
	Field _lblText:Label
	Field _img:Image

Public 
		
	Method New(text:String, status:String, ip:String, mapName:String, img:Image)
		
		Local boldFont:= New BitmapFont("boldFont.txt")
		Local normalFont:= New BitmapFont("normal.txt")
		
		_lblText = New Label
		_lblText.Text = text
		_lblText.Font = boldFont
		_lblText.Parent = Self 
		_lblText.Position.SetValues(96, 5)
		
		_lblMapName = New Label
		_lblMapName.Text = mapName
		_lblMapName.Parent = Self
		_lblMapName.Font = normalFont
		_lblMapName.Position.SetValues(96, 25)
		
		_lblStatus = New Label
		_lblStatus.Text = status
		_lblStatus.Parent = Self
		_lblStatus.Font = boldFont
		_lblStatus.TextAlign = eTextAlign.LEFT
		_lblStatus.Position.SetValues(WIDTH - 5 - _lblStatus.Font.GetTxtWidth(_lblStatus.Text), 5)
		
		_lblIp = New Label
		_lblIp.Text = ip
		_lblIp.Parent = Self 
		_lblIp.Font = normalFont
		_lblIp.TextAlign = eTextAlign.LEFT 
		_lblIp.Position.SetValues(WIDTH - 5 - _lblIp.Font.GetTxtWidth(_lblIp.Text), 25)
		
		_img = img
		
		Size.SetValues(WIDTH, HEIGHT)
	End

	Method Render:Void()
		Super.Render()
		
		Local drawpos:= CalculateRenderPosition()
		
		'' Calculate image scaling factor
		Local scale:Float = Min(
		float(HEIGHT - 8) / float(_img.Width),
		float(HEIGHT - 8) / float(_img.Height))
	
		'' Draw item image
		SetColor 255, 255, 255
		DrawImage(_img,
			drawpos.X +HEIGHT / 2 - float(_img.Width * scale) / 2,
			drawpos.Y + (HEIGHT) / 2 - float(_img.Height * scale) / 2,
			0, scale, scale)
	End
	
	Method Text:String()
		Return _lblText.Text 
	End
	
End

Class GameListView extends ListView 
	Method New(x:Int, y:Int, width:Int, height:Int, parent:ContainerControl)
		Super.New(x, y, width, height, parent)
		ItemHeight = GameListViewItem.HEIGHT
		ItemWidth = GameListViewItem.WIDTH
		SetItemSpacing(5, 5)
	End
End