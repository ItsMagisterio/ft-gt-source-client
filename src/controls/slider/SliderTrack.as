package controls.slider
{
    import flash.display.Sprite;
    import assets.slider.slider_TRACK_LEFT;
    import assets.slider.slider_TRACK_CENTER;
    import assets.slider.slider_TRACK_RIGHT;
    import flash.geom.Matrix;
    import flash.display.Graphics;

    public class SliderTrack extends Sprite
    {

        protected var track_bmpLeft:slider_TRACK_LEFT = new slider_TRACK_LEFT(1, 1);
        protected var track_bmpCenter:slider_TRACK_CENTER = new slider_TRACK_CENTER(1, 1);
        protected var track_bmpRight:slider_TRACK_RIGHT = new slider_TRACK_RIGHT(1, 1);
        protected var _width:int;
        protected var _showTrack:Boolean;
        protected var _minValue:Number = 0;
        protected var _maxValue:Number = 100;
        protected var _tick:Number = 10;

        public function SliderTrack(showtrack:Boolean = true)
        {
            this._showTrack = showtrack;
        }
        override public function set width(w:Number):void
        {
            this._width = w;
            this.draw();
        }
        protected function draw():void
        {
            var matrix:Matrix;
            var tickDelta:Number;
            var curTickX:Number;
            var g:Graphics = this.graphics;
            g.clear();
            g.beginBitmapFill(this.track_bmpLeft);
            g.drawRect(0, 0, 5, 30);
            g.endFill();
            matrix = new Matrix();
            matrix.translate(5, 0);
            g.beginBitmapFill(this.track_bmpCenter, matrix);
            g.drawRect(5, 0, (this._width - 11), 30);
            g.endFill();
            matrix = new Matrix();
            matrix.translate((this._width - 6), 0);
            g.beginBitmapFill(this.track_bmpRight, matrix);
            g.drawRect((this._width - 6), 0, 6, 30);
            g.endFill();
            if (this._showTrack)
            {
                tickDelta = (width / ((this._maxValue - this._minValue) / this._tick));
                curTickX = tickDelta;
                while (curTickX < this._width)
                {
                    g.lineStyle(0, 0xFFFFFF, 0.4);
                    g.moveTo(curTickX, 5);
                    g.lineTo(curTickX, 25);
                    curTickX = (curTickX + tickDelta);
                }
            }
        }
        public function set minValue(minValue:Number):void
        {
            this._minValue = minValue;
            this.draw();
        }
        public function set maxValue(maxValue:Number):void
        {
            this._maxValue = maxValue;
            this.draw();
        }
        public function set tickInterval(tick:Number):void
        {
            this._tick = tick;
            this.draw();
        }

    }
}
