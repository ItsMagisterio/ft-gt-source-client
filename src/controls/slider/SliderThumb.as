package controls.slider
{
    import flash.display.Sprite;
    import assets.slider.slider_THUMB_LEFT;
    import assets.slider.slider_THUMB_CENTER;
    import assets.slider.slider_THUMB_RIGHT;
    import flash.geom.Matrix;
    import flash.display.Graphics;

    public class SliderThumb extends Sprite
    {

        protected var thumb_bmpLeft:slider_THUMB_LEFT = new slider_THUMB_LEFT(1, 1);
        protected var thumb_bmpCenter:slider_THUMB_CENTER = new slider_THUMB_CENTER(1, 1);
        protected var thumb_bmpRight:slider_THUMB_RIGHT = new slider_THUMB_RIGHT(1, 1);
        protected var _width:int;

        public function SliderThumb()
        {
            buttonMode = true;
        }
        override public function set width(w:Number):void
        {
            this._width = w;
            this.draw();
        }
        protected function draw():void
        {
            var matrix:Matrix;
            var g:Graphics = this.graphics;
            g.clear();
            g.beginBitmapFill(this.thumb_bmpLeft);
            g.drawRect(0, 0, 10, 30);
            g.endFill();
            matrix = new Matrix();
            matrix.translate(10, 0);
            g.beginBitmapFill(this.thumb_bmpCenter, matrix);
            g.drawRect(10, 0, (this._width - 20), 30);
            g.endFill();
            matrix = new Matrix();
            matrix.translate((this._width - 10), 0);
            g.beginBitmapFill(this.thumb_bmpRight, matrix);
            g.drawRect((this._width - 10), 0, 10, 30);
            g.endFill();
        }

    }
}
