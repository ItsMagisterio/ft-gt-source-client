package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGShape;
    import __AS3__.vec.Vector;
    import com.lorentz.SVG.drawing.IDrawer;

    public class SVGPolygon extends SVGShape
    {

        private var _points:Vector.<String>;

        public function SVGPolygon()
        {
            super("polygon");
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
            var j:int;
            if (this.points.length > 2)
            {
                drawer.moveTo(Number(this.points[0]), Number(this.points[1]));
                j = 2;
                while (j < (this.points.length - 1))
                {
                    drawer.lineTo(Number(this.points[j++ ]), Number(this.points[j++ ]));
                }
                drawer.lineTo(Number(this.points[0]), Number(this.points[1]));
            }
        }
        override public function clone():Object
        {
            var c:SVGPolygon = (super.clone() as SVGPolygon);
            c.points = this.points.slice();
            return (c);
        }

    }
}
