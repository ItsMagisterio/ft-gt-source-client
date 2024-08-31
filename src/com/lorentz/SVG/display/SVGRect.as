package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGShape;
    import com.lorentz.SVG.utils.SVGUtil;
    import com.lorentz.SVG.drawing.IDrawer;

    public class SVGRect extends SVGShape
    {

        private var _xUnits:Number;
        private var _yUnits:Number;
        private var _widthUnits:Number;
        private var _heightUnits:Number;
        private var _rxUnits:Number;
        private var _ryUnits:Number;
        private var _svgX:String;
        private var _svgY:String;
        private var _svgWidth:String;
        private var _svgHeight:String;
        private var _svgRx:String;
        private var _svgRy:String;

        public function SVGRect()
        {
            super("rect");
        }
        public function get svgX():String
        {
            return (this._svgX);
        }
        public function set svgX(value:String):void
        {
            if (this._svgX != value)
            {
                this._svgX = value;
                invalidateRender();
            }
        }
        public function get svgY():String
        {
            return (this._svgY);
        }
        public function set svgY(value:String):void
        {
            if (this._svgY != value)
            {
                this._svgY = value;
                invalidateRender();
            }
        }
        public function get svgWidth():String
        {
            return (this._svgWidth);
        }
        public function set svgWidth(value:String):void
        {
            if (this._svgWidth != value)
            {
                this._svgWidth = value;
                invalidateRender();
            }
        }
        public function get svgHeight():String
        {
            return (this._svgHeight);
        }
        public function set svgHeight(value:String):void
        {
            if (this._svgHeight != value)
            {
                this._svgHeight = value;
                invalidateRender();
            }
        }
        public function get svgRx():String
        {
            return (this._svgRx);
        }
        public function set svgRx(value:String):void
        {
            if (this._svgRx != value)
            {
                this._svgRx = value;
                invalidateRender();
            }
        }
        public function get svgRy():String
        {
            return (this._svgRy);
        }
        public function set svgRy(value:String):void
        {
            if (this._svgRy != value)
            {
                this._svgRy = value;
                invalidateRender();
            }
        }
        override protected function beforeDraw():void
        {
            super.beforeDraw();
            this._xUnits = getViewPortUserUnit(this.svgX, SVGUtil.WIDTH);
            this._yUnits = getViewPortUserUnit(this.svgY, SVGUtil.HEIGHT);
            this._widthUnits = getViewPortUserUnit(this.svgWidth, SVGUtil.WIDTH);
            this._heightUnits = getViewPortUserUnit(this.svgHeight, SVGUtil.HEIGHT);
            this._rxUnits = 0;
            this._ryUnits = 0;
            if (this.svgRx)
            {
                this._rxUnits = getViewPortUserUnit(this.svgRx, SVGUtil.WIDTH);
                if ((!(this.svgRy)))
                {
                    this._ryUnits = this._rxUnits;
                }
            }
            if (this.svgRy)
            {
                this._ryUnits = getViewPortUserUnit(this.svgRy, SVGUtil.HEIGHT);
                if ((!(this.svgRx)))
                {
                    this._rxUnits = this._ryUnits;
                }
            }
        }
        override protected function drawToDrawer(drawer:IDrawer):void
        {
            if (((this._rxUnits == 0) && (this._ryUnits == 0)))
            {
                drawer.moveTo(this._xUnits, this._yUnits);
                drawer.lineTo((this._xUnits + this._widthUnits), this._yUnits);
                drawer.lineTo((this._xUnits + this._widthUnits), (this._yUnits + this._heightUnits));
                drawer.lineTo(this._xUnits, (this._yUnits + this._heightUnits));
                drawer.lineTo(this._xUnits, this._yUnits);
            }
            else
            {
                drawer.moveTo((this._xUnits + this._rxUnits), this._yUnits);
                drawer.lineTo(((this._xUnits + this._widthUnits) - this._rxUnits), this._yUnits);
                drawer.arcTo(this._ryUnits, this._rxUnits, 90, false, true, (this._xUnits + this._widthUnits), (this._yUnits + this._ryUnits));
                drawer.lineTo((this._xUnits + this._widthUnits), ((this._yUnits + this._heightUnits) - this._ryUnits));
                drawer.arcTo(this._ryUnits, this._rxUnits, 90, false, true, ((this._xUnits + this._widthUnits) - this._rxUnits), (this._yUnits + this._heightUnits));
                drawer.lineTo((this._xUnits + this._rxUnits), (this._yUnits + this._heightUnits));
                drawer.arcTo(this._ryUnits, this._rxUnits, 90, false, true, this._xUnits, ((this._yUnits + this._heightUnits) - this._ryUnits));
                drawer.lineTo(this._xUnits, (this._yUnits + this._ryUnits));
                drawer.arcTo(this._ryUnits, this._rxUnits, 90, false, true, (this._xUnits + this._rxUnits), this._yUnits);
            }
        }
        override public function clone():Object
        {
            var c:SVGRect = (super.clone() as SVGRect);
            c.svgX = this.svgX;
            c.svgY = this.svgY;
            c.svgWidth = this.svgWidth;
            c.svgHeight = this.svgHeight;
            c.svgRx = this.svgRx;
            c.svgRy = this.svgRy;
            return (c);
        }

    }
}
