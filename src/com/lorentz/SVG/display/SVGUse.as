package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGElement;
    import com.lorentz.SVG.display.base.ISVGViewPort;
    import com.lorentz.SVG.utils.SVGUtil;
    import com.lorentz.SVG.utils.StringUtil;
    import com.lorentz.SVG.display.base.ISVGViewBox;
    import flash.geom.Rectangle;

    public class SVGUse extends SVGElement implements ISVGViewPort
    {

        protected var _includedElement:SVGElement;
        private var _svgHrefChanged:Boolean = false;
        private var _svgHref:String;

        public function SVGUse()
        {
            super("use");
        }
        public function get svgHref():String
        {
            return (this._svgHref);
        }
        public function set svgHref(value:String):void
        {
            this._svgHref = value;
            this._svgHrefChanged = true;
            invalidateProperties();
        }
        public function get svgPreserveAspectRatio():String
        {
            return (getAttribute("preserveAspectRatio") as String);
        }
        public function set svgPreserveAspectRatio(value:String):void
        {
            setAttribute("preserveAspectRatio", value);
        }
        public function get svgX():String
        {
            return (getAttribute("x") as String);
        }
        public function set svgX(value:String):void
        {
            setAttribute("x", value);
        }
        public function get svgY():String
        {
            return (getAttribute("y") as String);
        }
        public function set svgY(value:String):void
        {
            setAttribute("y", value);
        }
        public function get svgWidth():String
        {
            return (getAttribute("width") as String);
        }
        public function set svgWidth(value:String):void
        {
            setAttribute("width", value);
        }
        public function get svgHeight():String
        {
            return (getAttribute("height") as String);
        }
        public function set svgHeight(value:String):void
        {
            setAttribute("height", value);
        }
        public function get svgOverflow():String
        {
            return (getAttribute("overflow") as String);
        }
        public function set svgOverflow(value:String):void
        {
            setAttribute("overflow", value);
        }
        override protected function commitProperties():void
        {
            var includedSVG:SVG;
            x = ((this.svgX) ? getViewPortUserUnit(this.svgX, SVGUtil.WIDTH) : 0);
            y = ((this.svgY) ? getViewPortUserUnit(this.svgY, SVGUtil.HEIGHT) : 0);
            super.commitProperties();
            if (this._svgHrefChanged)
            {
                this._svgHrefChanged = false;
                if (this._includedElement != null)
                {
                    content.removeChild(this._includedElement);
                    detachElement(this._includedElement);
                    this._includedElement = null;
                }
                if (this.svgHref)
                {
                    this._includedElement = (document.getDefinitionClone(StringUtil.ltrim(this.svgHref, "#")) as SVGElement);
                    if (this._includedElement != null)
                    {
                        attachElement(this._includedElement);
                        content.addChild(this._includedElement);
                    }
                }
            }
            if (this._includedElement)
            {
                if ((this._includedElement is SVG))
                {
                    includedSVG = (this._includedElement as SVG);
                    if (this.svgWidth)
                    {
                        includedSVG.svgWidth = this.svgWidth;
                    }
                    if (this.svgHeight)
                    {
                        includedSVG.svgHeight = this.svgHeight;
                    }
                }
            }
        }
        override protected function getContentBox():Rectangle
        {
            if ((this._includedElement is ISVGViewBox))
            {
                return ((this._includedElement as ISVGViewBox).svgViewBox);
            }
            return (null);
        }
        override public function clone():Object
        {
            var c:SVGUse = (super.clone() as SVGUse);
            c.svgHref = this.svgHref;
            return (c);
        }

    }
}
