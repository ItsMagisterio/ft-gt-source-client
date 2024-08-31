package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGShape;
    import com.lorentz.SVG.utils.SVGUtil;
    import com.lorentz.SVG.drawing.IDrawer;
    import flash.display.Graphics;

    public class SVGCircle extends SVGShape
    {

        private var _cxUnits:Number;
        private var _cyUnits:Number;
        private var _rUnits:Number;
        private var _svgCx:String;
        private var _svgCy:String;
        private var _svgR:String;

        public function SVGCircle()
        {
            super("circle");
        }
        public function get svgCx():String
        {
            return (this._svgCx);
        }
        public function set svgCx(value:String):void
        {
            if (this._svgCx != value)
            {
                this._svgCx = value;
                invalidateRender();
            }
        }
        public function get svgCy():String
        {
            return (this._svgCy);
        }
        public function set svgCy(value:String):void
        {
            if (this._svgCy != value)
            {
                this._svgCy = value;
                invalidateRender();
            }
        }
        public function get svgR():String
        {
            return (this._svgR);
        }
        public function set svgR(value:String):void
        {
            this._svgR = value;
            invalidateRender();
        }
        override protected function beforeDraw():void
        {
            super.beforeDraw();
            this._cxUnits = getViewPortUserUnit(this.svgCx, SVGUtil.WIDTH);
            this._cyUnits = getViewPortUserUnit(this.svgCy, SVGUtil.HEIGHT);
            this._rUnits = getViewPortUserUnit(this.svgR, SVGUtil.WIDTH);
        }
        override protected function drawToDrawer(drawer:IDrawer):void
        {
            drawer.moveTo((this._cxUnits + this._rUnits), this._cyUnits);
            drawer.arcTo(this._rUnits, this._rUnits, 0, true, false, (this._cxUnits - this._rUnits), this._cyUnits);
            drawer.arcTo(this._rUnits, this._rUnits, 0, true, false, (this._cxUnits + this._rUnits), this._cyUnits);
        }
        override protected function drawDirectlyToGraphics(graphics:Graphics):void
        {
            graphics.drawCircle(this._cxUnits, this._cyUnits, this._rUnits);
        }
        override protected function get hasDrawDirectlyToGraphics():Boolean
        {
            return (true);
        }
        override public function clone():Object
        {
            var c:SVGCircle = (super.clone() as SVGCircle);
            c.svgCx = this.svgCx;
            c.svgCy = this.svgCy;
            c.svgR = this.svgR;
            return (c);
        }

    }
}
