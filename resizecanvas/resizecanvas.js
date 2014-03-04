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
		//CANVAS_RESIZE_MODE=2;
		var rfs=canvas.requestFullscreen || canvas.webkitRequestFullScreen || canvas.mozRequestFullScreen;
		if( rfs ) rfs.call( canvas );
		//requestFullscreen();
		//canvas.width = window.innerWidth;
		//canvas.height = window.innerHeight;
		//canvas.updateSize();
	} else {alret("Hey!");}

}
