'This is a very small minimal sample

Import junglegui
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
			gui.Render()
		Catch jge:JungleGuiException
			Print "Error rendering the Gui component:"
			Print jge.ToString()
			Error(jge.ToString())
		end
	End
End

Class MyForm extends Form

	Field listBox1:ListBox
	Field comboBox:ComboBox
	Field listView1:ListView
	Field listView2:ListView

	Method OnInit()
		Size.SetValues(500, 464)
		Position.SetValues(DeviceWidth / 2 - 255, DeviceHeight / 2 - 232 )
		'''
		''' MyForm
		'''
		'Events.Add(Self, eMsgKinds.MOVED, "MyForm_Moved")
		Self.Event_Moved.Add(Self, "MyForm_Moved")
		
		
		Local label:= new Label()
		label.Position.SetValues(10, 5)
		label.Parent = Self
		label.Text = "Item Size: "
		'''
		''' trackbar
		'''
		Local trackbar:= New TrackBar
		trackbar.Parent = Self
		trackbar.Position.SetValues(10, 25)
		trackbar.Event_ValueChanged.Add(Self, "Trackbar1_ValueChanged")
		trackbar.Minimum = 48
		trackbar.Maximum = 256
		trackbar.Tickfrequency = 4
		
		
		label = New Label()
		label.Position.SetValues(230, 5)
		label.Parent = Self
		label.Text = "Item Spacing: "
		
		'''
		''' trackbar
		'''
		trackbar = New TrackBar
		trackbar.Parent = Self
		trackbar.Position.SetValues(230, 25)
		trackbar.Minimum = 2
		trackbar.Maximum = 64
		trackbar.Tickfrequency = 2
		trackbar.Event_ValueChanged.Add(Self, "Trackbar2_ValueChanged")
		
		'''
		''' listView1
		'''
		
		Local img1:= LoadImage("icon1.png")
		Local img2:= LoadImage("icon2.png")
		Local map1:= LoadImage("map1.png")
		Local map2:= LoadImage("map2.png")
		Local map3:= LoadImage("map3.png") 
					 
		listView1 = New ListView(5, 60, 470, 180, Self)
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img1))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img2))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img1))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img2))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img1))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img2))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img1))
		listView1.Items.AddLast(New DefaultListViewItem("Bla", img2))

		listView2  = New GameListView(5, 250, 470, 180, Self)
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map1))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map2))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map3))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map1))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map2))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", map3))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", img1))
		listView2.Items.AddLast(New GameListViewItem("Bla Dedicated Server", "Waiting for players", "37.59.222.194:1234", "A Path Beyond", img2))
		 
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

	Const WIDTH = 440
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