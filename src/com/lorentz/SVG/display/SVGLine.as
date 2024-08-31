package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGShape;
    import com.lorentz.SVG.utils.SVGUtil;
    import com.lorentz.SVG.drawing.IDrawer;

    public class SVGLine extends SVGShape
    {

        private var _x1Units:Number;
        private var _y1Units:Number;
        private var _x2Units:Number;
        private var _y2Units:Number;
        private var _svgX1:String;
        private var _svgX2:String;
        private var _svgY1:String;
        private var _svgY2:String;

        public function SVGLine()
        {
            super("line");
        }
        public function get svgX1():String
        {
            return (this._svgX1);
        }
        public function set svgX1(value:String):void
        {
            if (this._svgX1 != value)
            {
                this._svgX1 = value;
                invalidateRender();
            }
        }
        public function get svgX2():String
        {
            return (this._svgX2);
        }
        public function set svgX2(value:String):void
        {
            if (this._svgX2 != value)
            {
                this._svgX2 = value;
                invalidateRender();
            }
        }
        public function get svgY1():String
        {
            return (this._svgY1);
        }
        public function set svgY1(value:String):void
        {
            if (this._svgY1 != value)
            {
                this._svgY1 = value;
                invalidateRender();
            }
        }
        public function get svgY2():String
        {
            return (this._svgY2);
        }
        public function set svgY2(value:String):void
        {
            if (this._svgY2 != value)
            {
                this._svgY2 = value;
                invalidateRender();
            }
        }
        override protected function get hasFill():Boolean
        {
            return (false);
        }
        override protected function beforeDraw():void
        {
            super.beforeDraw();
            this._x1Units = getViewPortUserUnit(this.svgX1, SVGUtil.WIDTH);
            this._y1Units = getViewPortUserUnit(this.svgY1, SVGUtil.HEIGHT);
            this._x2Units = getViewPortUserUnit(this.svgX2, SVGUtil.WIDTH);
            this._y2Units = getViewPortUserUnit(this.svgY2, SVGUtil.HEIGHT);
        }
        override protected function drawToDrawer(drawer:IDrawer):void
        {
            drawer.moveTo(this._x1Units, this._y1Units);
            drawer.lineTo(this._x2Units, this._y2Units);
        }
        override public function clone():Object
        {
            var c:SVGLine = (super.clone() as SVGLine);
            c.svgX1 = this.svgX1;
            c.svgX2 = this.svgX2;
            c.svgY1 = this.svgY1;
            c.svgY2 = this.svgY2;
            return (c);
        }

    }
}
