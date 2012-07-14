function EnableAutoSize()
{
	window.onresize = ResizeCanvasFull;
	ResizeCanvasFull();
}

function DisableAutoSize()
{
	window.onresize = null;
}

function ResizeCanvasFull()
{

	var canvas = document.getElementById("GameCanvas");
	if (canvas)
	{
		canvas.width = window.innerWidth;
		canvas.height = window.innerHeight;
	}

}
