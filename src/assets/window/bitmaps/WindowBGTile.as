package assets.window.bitmaps
{
	import flash.display.BitmapData;

	[Embed(source="WindowBGTile.jpg")]

	public class WindowBGTile extends BitmapData
	{

		public function WindowBGTile(param1:int, param2:int, param3:Boolean = true, param4:uint = 0)
		{
			super(param1, param2, param3, param4);
		}
	}
}
