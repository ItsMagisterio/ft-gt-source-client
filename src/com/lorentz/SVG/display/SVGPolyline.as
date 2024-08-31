package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGShape;
    import __AS3__.vec.Vector;
    import com.lorentz.SVG.drawing.IDrawer;

    public class SVGPolyline extends SVGShape
    {

        private var _points:Vector.<String>;

        public function SVGPolyline()
        {
            super("polyline");
        }
        public function get points():Vector.<String>
        {
            return (this._points);
        }
        public function set points(value:Vector.<String>):void
        {
            this._points = value;
            invalidateRender();
        }
        override protected function drawToDrawer(drawer:IDrawer):void
        {
            var i:int;
            if (this.points.length > 2)
            {
                drawer.moveTo(Number(this.points[0]), Number(this.points[1]));
                i = 2;
                while (i < (this.points.length - 1))
                {
                    drawer.lineTo(Number(this.points[i++ ]), Number(this.points[i++ ]));
                }
            }
        }
        override public function clone():Object
        {
            var c:SVGPolyline = (super.clone() as SVGPolyline);
            c.points = this.points.slice();
            return (c);
        }

    }
}
