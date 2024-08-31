package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGShape;
    import com.lorentz.SVG.utils.SVGUtil;
    import com.lorentz.SVG.drawing.IDrawer;
    import flash.display.Graphics;

    public class SVGEllipse extends SVGShape
    {

        private var _cxUnits:Number;
        private var _cyUnits:Number;
        private var _rxUnits:Number;
        private var _ryUnits:Number;
        private var _svgCx:String;
        private var _svgCy:String;
        private var _svgRx:String;
        private var _svgRy:String;

        public function SVGEllipse()
        {
            super("ellipse");
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
        public function get svgRx():String
        {
            return (this._svgRx);
        }
        public function set svgRx(value:String):void
        {
            this._svgRx = value;
            invalidateRender();
        }
        public function get svgRy():String
        {
            return (this._svgRy);
        }
        public function set svgRy(value:String):void
        {
            this._svgRy = value;
            invalidateRender();
        }
        override protected function beforeDraw():void
        {
            super.beforeDraw();
            this._cxUnits = getViewPortUserUnit(this.svgCx, SVGUtil.WIDTH);
            this._cyUnits = getViewPortUserUnit(this.svgCy, SVGUtil.HEIGHT);
            this._rxUnits = getViewPortUserUnit(this.svgRx, SVGUtil.WIDTH);
            this._ryUnits = getViewPortUserUnit(this.svgRy, SVGUtil.HEIGHT);
        }
        override protected function drawToDrawer(drawer:IDrawer):void
        {
            drawer.moveTo((this._cxUnits + this._rxUnits), this._cyUnits);
            drawer.arcTo(this._rxUnits, this._ryUnits, 0, true, false, (this._cxUnits - this._rxUnits), this._cyUnits);
            drawer.arcTo(this._rxUnits, this._ryUnits, 0, true, false, (this._cxUnits + this._rxUnits), this._cyUnits);
        }
        override protected function drawDirectlyToGraphics(graphics:Graphics):void
        {
            graphics.drawEllipse((this._cxUnits - this._rxUnits), (this._cyUnits - this._ryUnits), (this._rxUnits * 2), (this._ryUnits * 2));
        }
        override protected function get hasDrawDirectlyToGraphics():Boolean
        {
            return (true);
        }
        override public function clone():Object
        {
            var c:SVGEllipse = (super.clone() as SVGEllipse);
            c.svgCx = this.svgCx;
            c.svgCy = this.svgCy;
            c.svgRx = this.svgRx;
            c.svgRy = this.svgRy;
            return (c);
        }

    }
}
