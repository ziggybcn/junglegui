Import junglegui
Import toolbox
Import simpleparticles
#REFLECTION_FILTER="particlessample*|toolbox*|junglegui*"
Global Sample:ParticlesSample
Function Main()
	Sample = New ParticlesSample
End


Class ParticlesSample extends App
	Field toolBox:ToolBox
	Field emiter:Emiter
	Global gui:Gui
	Method OnCreate()
		SetUpdateRate(60)
		EnableAutoSize()
		emiter = New Emiter
		
		if gui = null Then gui = New Gui
		toolBox = New ToolBox
		toolBox.InitForm(gui)
	End
	Method OnUpdate()
		emiter.Update()
		gui.Update()
		toolBox.particlesCount.Text = "Particles: " + emiter.count
	End
	Method OnRender()
		Cls(0, 0, 55)
		emiter.Draw()		
		SetColor(255, 255, 255)
		gui.Render()
	End
End