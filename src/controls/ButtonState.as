package controls
{
    import flash.display.Sprite;
    import flash.display.Shape;
    import flash.display.BitmapData;
    import flash.display.Graphics;

    public class ButtonState extends Sprite
    {

        public const l:Shape = new Shape();
        public const c:Shape = new Shape();
        public const r:Shape = new Shape();

        public var bmpLeft:BitmapData = new BitmapData(1, 1);
        public var bmpCenter:BitmapData = new BitmapData(1, 1);
        public var bmpRight:BitmapData = new BitmapData(1, 1);
        public var _width:int;

        public function ButtonState()
        {
            addChild(this.l);
            addChild(this.c);
            addChild(this.r);
        }
        override public function set width(_arg_1:Number):void
        {
            this._width = int(_arg_1);
            this.draw();
        }
        public function draw():void
        {
            var _local_1:Graphics;
            _local_1 = this.l.graphics;
            _local_1.clear();
            _local_1.beginBitmapFill(this.bmpLeft);
            _local_1.drawRect(0, 0, 7, 30);
            _local_1.endFill();
            this.l.x = 0;
            this.l.y = 0;
            _local_1 = this.c.graphics;
            _local_1.clear();
            _local_1.beginBitmapFill(this.bmpCenter);
            _local_1.drawRect(0, 0, (this._width - 14), 30);
            _local_1.endFill();
            this.c.x = 7;
            this.c.y = 0;
            _local_1 = this.r.graphics;
            _local_1.clear();
            _local_1.beginBitmapFill(this.bmpRight);
            _local_1.drawRect(0, 0, 7, 30);
            _local_1.endFill();
            this.r.x = (this._width - 7);
            this.r.y = 0;
        }

    }
}
