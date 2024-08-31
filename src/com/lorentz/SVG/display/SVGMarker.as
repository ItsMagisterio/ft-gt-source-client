package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGContainer;
    import com.lorentz.SVG.display.base.ISVGViewBox;
    import com.lorentz.SVG.display.base.ISVGPreserveAspectRatio;
    import com.lorentz.SVG.data.MarkerPlace;
    import flash.geom.Rectangle;
    import com.lorentz.SVG.display.base.SVGElement;
    import flash.geom.Point;
    import com.lorentz.SVG.utils.SVGUtil;
    import com.lorentz.SVG.parser.SVGParserCommon;
    import com.lorentz.SVG.utils.SVGViewPortUtils;

    public class SVGMarker extends SVGContainer implements ISVGViewBox, ISVGPreserveAspectRatio
    {

        private var _invalidPlacement:Boolean = true;
        private var _markerPlace:MarkerPlace;

        public function SVGMarker()
        {
            super("marker");
        }
        public function get svgRefX():String
        {
            return (getAttribute("refX") as String);
        }
        public function set svgRefX(value:String):void
        {
            setAttribute("refX", value);
            this.invalidatePlacement();
        }
        public function get svgRefY():String
        {
            return (getAttribute("refY") as String);
        }
        public function set svgRefY(value:String):void
        {
            setAttribute("refY", value);
            this.invalidatePlacement();
        }
        public function get svgMarkerWidth():String
        {
            return (getAttribute("markerWidth") as String);
        }
        public function set svgMarkerWidth(value:String):void
        {
            setAttribute("markerWidth", value);
            this.invalidatePlacement();
        }
        public function get svgMarkerHeight():String
        {
            return (getAttribute("markerHeight") as String);
        }
        public function set svgMarkerHeight(value:String):void
        {
            setAttribute("markerHeight", value);
            this.invalidatePlacement();
        }
        public function get svgOrient():String
        {
            return (getAttribute("orient") as String);
        }
        public function set svgOrient(value:String):void
        {
            setAttribute("orient", value);
            this.invalidatePlacement();
        }
        public function get svgViewBox():Rectangle
        {
            return (getAttribute("viewBox") as Rectangle);
        }
        public function set svgViewBox(value:Rectangle):void
        {
            setAttribute("viewBox", value);
            this.invalidatePlacement();
        }
        public function get svgPreserveAspectRatio():String
        {
            return (getAttribute("preserveAspectRatio") as String);
        }
        public function set svgPreserveAspectRatio(value:String):void
        {
            setAttribute("preserveAspectRatio", value);
            this.invalidatePlacement();
        }
        protected function invalidatePlacement():void
        {
            if ((!(this._invalidPlacement)))
            {
                this._invalidPlacement = true;
                invalidate();
            }
        }
        override protected function getElementToInheritStyles():SVGElement
        {
            if ((!(parentElement)))
            {
                return (null);
            }
            return (parentElement.parentElement);
        }
        public function get markerPlace():MarkerPlace
        {
            return (this._markerPlace);
        }
        public function set markerPlace(value:MarkerPlace):void
        {
            this._markerPlace = value;
            this.invalidatePlacement();
        }
        override public function validate():void
        {
            var markerWidth:Number;
            var markerHeight:Number;
            var refX:Number;
            var refY:Number;
            var referenceGlobal:Point;
            var referencePointOnParentObject:Point;
            var viewPortBox:Rectangle;
            var preserveAspectRatio:Object;
            var viewPortContentMetrics:Object;
            super.validate();
            if (this._invalidPlacement)
            {
                this._invalidPlacement = false;
                scrollRect = null;
                content.scaleX = 1;
                content.scaleY = 1;
                content.x = 0;
                content.y = 0;
                markerWidth = 3;
                if (this.svgMarkerWidth)
                {
                    markerWidth = getViewPortUserUnit(this.svgMarkerWidth, SVGUtil.WIDTH);
                }
                markerHeight = 3;
                if (this.svgMarkerHeight)
                {
                    markerHeight = getViewPortUserUnit(this.svgMarkerHeight, SVGUtil.HEIGHT);
                }
                if (this.svgViewBox != null)
                {
                    if (this.svgPreserveAspectRatio != "none")
                    {
                        viewPortBox = new Rectangle(0, 0, markerWidth, markerHeight);
                        preserveAspectRatio = SVGParserCommon.parsePreserveAspectRatio(((this.svgPreserveAspectRatio) || ("")));
                        viewPortContentMetrics = SVGViewPortUtils.getContentMetrics(viewPortBox, this.svgViewBox, preserveAspectRatio.align, preserveAspectRatio.meetOrSlice);
                        if (preserveAspectRatio.meetOrSlice == "slice")
                        {
                            scrollRect = viewPortBox;
                        }
                        content.scaleX = viewPortContentMetrics.contentScaleX;
                        content.scaleY = viewPortContentMetrics.contentScaleY;
                        content.x = viewPortContentMetrics.contentX;
                        content.y = viewPortContentMetrics.contentY;
                    }
                    else
                    {
                        content.x = x;
                        content.y = y;
                        content.scaleX = (markerWidth / content.width);
                        content.scaleY = (markerHeight / content.height);
                    }
                }
                refX = 0;
                if (this.svgRefX)
                {
                    refX = getViewPortUserUnit(this.svgRefX, SVGUtil.WIDTH);
                }
                refY = 0;
                if (this.svgRefY)
                {
                    refY = getViewPortUserUnit(this.svgRefY, SVGUtil.HEIGHT);
                }
                rotation = (((!(this.svgOrient)) || (this.svgOrient == "auto")) ? this.markerPlace.angle : Number(this.svgOrient));
                scaleX = this.markerPlace.strokeWidth;
                scaleY = this.markerPlace.strokeWidth;
                referenceGlobal = content.localToGlobal(new Point(refX, refY));
                referencePointOnParentObject = parent.globalToLocal(referenceGlobal);
                x = ((this.markerPlace.position.x - referencePointOnParentObject.x) - x);
                y = ((this.markerPlace.position.y - referencePointOnParentObject.y) - y);
            }
        }
        override public function clone():Object
        {
            var c:SVGMarker = (super.clone() as SVGMarker);
            c.svgRefX = this.svgRefX;
            c.svgRefY = this.svgRefY;
            c.svgMarkerWidth = this.svgMarkerWidth;
            c.svgMarkerHeight = this.svgMarkerHeight;
            c.svgOrient = this.svgOrient;
            return (c);
        }

    }
}
