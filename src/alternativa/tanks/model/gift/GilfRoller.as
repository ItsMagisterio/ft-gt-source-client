package alternativa.tanks.model.gift
{
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.display.Bitmap;

    public class GilfRoller extends Sprite
    {

        internal static var roller:Class = GilfRoller_roller;
        private static const rollerBMP:BitmapData = new roller().bitmapData;

        public var list:GiftRollerList;

        public function GilfRoller(items:Array, _width:Number = 0, _height:* = 0)
        {
            this.list = new GiftRollerList();
            this.list.width = (_width - 3);
            this.list.height = _height;
            this.list.y = 16;
            addChild(this.list);
            this.list.initData(items);
            addChild(new Bitmap(rollerBMP));
        }
        public function init(items:Array):void
        {
            this.list.initData(items);
        }

    }
}
