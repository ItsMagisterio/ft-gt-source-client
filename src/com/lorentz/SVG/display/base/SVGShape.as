package com.lorentz.SVG.display.base
{
    import __AS3__.vec.Vector;
    import com.lorentz.SVG.display.SVGMarker;
    import com.lorentz.SVG.data.MarkerPlace;
    import com.lorentz.SVG.drawing.GraphicsPathDrawer;
    import com.lorentz.SVG.drawing.DashedDrawer;
    import com.lorentz.SVG.drawing.MarkersPlacesCapturerDrawer;
    import com.lorentz.SVG.drawing.IDrawer;
    import flash.display.Graphics;
    import flash.display.GraphicsPathWinding;
    import com.lorentz.SVG.utils.SVGUtil;
    import flash.geom.Rectangle;
    import __AS3__.vec.*;

    public class SVGShape extends SVGGraphicsElement
    {

        private var _markers:Vector.<SVGMarker> = new Vector.<SVGMarker>();
        private var _markersPlaces:Vector.<MarkerPlace>;

        public function SVGShape(tagName:String)
        {
            super(tagName);
        }
        override protected function initialize():void
        {
            super.initialize();
            this.mouseChildren = false;
        }
        override protected function render():void
        {
            var dashedGraphicsPathDrawer:GraphicsPathDrawer;
            var dashedDrawer:DashedDrawer;
            super.render();
            this._markersPlaces = null;
            this.beforeDraw();
            content.graphics.clear();
            if (((hasStroke) && (!(hasDashedStroke))))
            {
                lineStyle(content.graphics);
            }
            beginFill(content.graphics, function():void
                {
                    drawWithAppropriateMethod();
                    content.graphics.endFill();
                });
            if (hasDashedStroke)
            {
                dashedGraphicsPathDrawer = new GraphicsPathDrawer();
                dashedDrawer = new DashedDrawer(dashedGraphicsPathDrawer);
                configureDashedDrawer(dashedDrawer);
                this.drawToDrawer(dashedDrawer);
                lineStyle(content.graphics);
                content.graphics.drawPath(dashedGraphicsPathDrawer.commands, dashedGraphicsPathDrawer.pathData);
                content.graphics.endFill();
            }
            this.renderMarkers();
        }
        private function drawWithAppropriateMethod():void
        {
            var graphicsPathDrawer:GraphicsPathDrawer;
            var extractMarkersInfoInterceptor:MarkersPlacesCapturerDrawer;
            var captureMarkers:Boolean = ((this.hasMarkers) && (this._markersPlaces == null));
            if (((!(captureMarkers)) && (this.hasDrawDirectlyToGraphics)))
            {
                this.drawDirectlyToGraphics(content.graphics);
            }
            else
            {
                graphicsPathDrawer = new GraphicsPathDrawer();
                if (captureMarkers)
                {
                    extractMarkersInfoInterceptor = new MarkersPlacesCapturerDrawer(graphicsPathDrawer);
                    content.graphics.drawPath(graphicsPathDrawer.commands, graphicsPathDrawer.pathData, this.getFlashWinding());
                    this.drawToDrawer(extractMarkersInfoInterceptor);
                    this._markersPlaces = extractMarkersInfoInterceptor.getMarkersInfo();
                }
                else
                {
                    this.drawToDrawer(graphicsPathDrawer);
                }
                content.graphics.drawPath(graphicsPathDrawer.commands, graphicsPathDrawer.pathData, this.getFlashWinding());
            }
        }
        protected function beforeDraw():void
        {
        }
        protected function drawToDrawer(drawer:IDrawer):void
        {
        }
        protected function drawDirectlyToGraphics(graphics:Graphics):void
        {
        }
        protected function get hasDrawDirectlyToGraphics():Boolean
        {
            return (false);
        }
        private function get hasMarkers():Boolean
        {
            return ((hasStroke) && ((((style.getPropertyValue("marker")) || (style.getPropertyValue("marker-start"))) || (style.getPropertyValue("marker-mid"))) || (style.getPropertyValue("marker-end"))));
        }
        private function getFlashWinding():String
        {
            var winding:String = ((finalStyle.getPropertyValue("fill-rule")) || ("nonzero"));
            switch (winding.toLowerCase())
            {
                case GraphicsPathWinding.EVEN_ODD.toLowerCase():
                    return (GraphicsPathWinding.EVEN_ODD);
                case GraphicsPathWinding.NON_ZERO.toLowerCase():
                    return (GraphicsPathWinding.NON_ZERO);
            }
            return (GraphicsPathWinding.NON_ZERO);
        }
        private function renderMarkers():void
        {
            var oldMarker:SVGMarker;
            var markerPlace:MarkerPlace;
            var markerStyle:String;
            var markerLink:String;
            var markerId:String;
            var marker:SVGMarker;
            var strokeWidth:Number;
            for each (oldMarker in this._markers)
            {
                detachElement(oldMarker);
                content.removeChild(oldMarker);
            }
            if (this._markersPlaces)
            {
                for each (markerPlace in this._markersPlaces)
                {
                    markerStyle = ("marker-" + markerPlace.type);
                    markerLink = ((finalStyle.getPropertyValue(markerStyle)) || (finalStyle.getPropertyValue("marker")));
                    if ((!(markerLink)))
                    {
                    }
                    else
                    {
                        markerId = SVGUtil.extractUrlId(markerLink);
                        if ((!(markerId)))
                        {
                        }
                        else
                        {
                            marker = (document.getDefinitionClone(markerId) as SVGMarker);
                            if ((!(marker)))
                            {
                            }
                            else
                            {
                                strokeWidth = 1;
                                if (finalStyle.getPropertyValue("stroke-width"))
                                {
                                    strokeWidth = getViewPortUserUnit(finalStyle.getPropertyValue("stroke-width"), SVGUtil.WIDTH_HEIGHT);
                                }
                                markerPlace.strokeWidth = strokeWidth;
                                marker.markerPlace = markerPlace;
                                content.addChild(marker);
                                attachElement(marker);
                                this._markers.push(marker);
                            }
                        }
                    }
                }
            }
        }
        override protected function getObjectBounds():Rectangle
        {
            graphics.beginFill(0);
            this.drawWithAppropriateMethod();
            return (content.getBounds(this));
        }

    }
}
