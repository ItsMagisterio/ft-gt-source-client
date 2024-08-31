package controls.statassets
{
    import flash.display.BitmapData;
    import assets.stat.hall_HEADER;
    import assets.stat.hall_ARROW;

    public class StatLineHeader extends StatLineBase
    {

        protected var _selected:Boolean = false;
        protected var ar:BitmapData;

        public function StatLineHeader()
        {
            tl = new hall_HEADER(1, 1);
            px = new BitmapData(1, 1, false, 5898034);
            this.ar = new hall_ARROW(1, 1);
        }
        public function set selected(value:Boolean):void
        {
            this._selected = value;
            this.draw();
        }
        override protected function draw():void
        {
            super.draw();
        }

    }
}
