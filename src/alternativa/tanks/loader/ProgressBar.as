package alternativa.tanks.loader
{
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.display.Bitmap;

    public class ProgressBar extends Sprite
    {

        private static const bitmapBar:Class = ProgressBar_bitmapBar;
        public static const barBd:BitmapData = new bitmapBar().bitmapData;
        private static const bitmapLampOn:Class = ProgressBar_bitmapLampOn;
        private static const lampOnBd:BitmapData = new bitmapLampOn().bitmapData;
        private static const bitmapLampOff:Class = ProgressBar_bitmapLampOff;
        private static const lampOffBd:BitmapData = new bitmapLampOff().bitmapData;

        private const lampsNum:int = 20;
        private const margin:int = 6;
        private const space:int = -2;

        private var bar:Bitmap;
        private var lamps:Array;

        public function ProgressBar()
        {
            var lamp:Bitmap;
            super();
            this.bar = new Bitmap(barBd);
            addChild(this.bar);
            this.lamps = new Array();
            var i:int;
            while (i < this.lampsNum)
            {
                lamp = new Bitmap(lampOffBd);
                addChild(lamp);
                this.lamps.push(lamp);
                lamp.x = (this.margin + ((lampOffBd.width + this.space) * i));
                lamp.y = Math.round(((this.bar.height - lampOffBd.height) * 0.5));
                i++;
            }
        }
        public function set progress(value:Number):void
        {
            var lamp:Bitmap;
            var n:int = Math.floor((this.lampsNum * value));
            var i:int;
            while (i < this.lampsNum)
            {
                lamp = (this.lamps[i] as Bitmap);
                if (i < n)
                {
                    lamp.bitmapData = lampOnBd;
                }
                else
                {
                    lamp.bitmapData = lampOffBd;
                }
                i++;
            }
        }

    }
}
