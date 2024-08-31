package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGTextContainer;
    import flash.display.Sprite;
    import com.lorentz.SVG.data.text.SVGDrawnText;
    import flash.geom.Rectangle;
    import com.lorentz.SVG.utils.SVGUtil;
    import flash.display.DisplayObject;
    import com.lorentz.SVG.utils.DisplayUtils;
    import __AS3__.vec.*;

    public class SVGTSpan extends SVGTextContainer
    {

        private var _svgDx:String;
        private var _svgDy:String;
        private var _start:Number = 0;
        private var _end:Number = 0;

        public function SVGTSpan()
        {
            super("tspan");
        }
        public function get svgDx():String
        {
            return (this._svgDx);
        }
        public function set svgDx(value:String):void
        {
            if (this._svgDx != value)
            {
                this._svgDx = value;
                invalidateRender();
            }
        }
        public function get svgDy():String
        {
            return (this._svgDy);
        }
        public function set svgDy(value:String):void
        {
            if (this._svgDy != value)
            {
                this._svgDy = value;
                invalidateRender();
            }
        }
        override protected function render():void
        {
            var fillTextsSprite:Sprite;
            var textElement:Object;
            var drawnText:SVGDrawnText;
            var tspan:SVGTextContainer;
            var bounds:Rectangle;
            var fill:Sprite;
            super.render();
            while (content.numChildren > 0)
            {
                content.removeChildAt(0);
            }
            if (this.numTextElements == 0)
            {
                return;
            }
            var direction:String = ((getDirectionFromStyles()) || ("lr"));
            var textDirection:String = direction;
            if (svgX)
            {
                textOwner.currentX = getViewPortUserUnit(svgX, SVGUtil.WIDTH);
            }
            if (svgY)
            {
                textOwner.currentY = getViewPortUserUnit(svgY, SVGUtil.HEIGHT);
            }
            this._start = textOwner.currentX;
            _renderObjects = new Vector.<DisplayObject>();
            if (this.svgDx)
            {
                textOwner.currentX = (textOwner.currentX + getViewPortUserUnit(this.svgDx, SVGUtil.WIDTH));
            }
            if (this.svgDy)
            {
                textOwner.currentY = (textOwner.currentY + getViewPortUserUnit(this.svgDy, SVGUtil.HEIGHT));
            }
            if (hasComplexFill)
            {
                fillTextsSprite = new Sprite();
                content.addChild(fillTextsSprite);
            }
            else
            {
                fillTextsSprite = content;
            }
            var i:int;
            while (i < numTextElements)
            {
                textElement = getTextElementAt(i);
                if ((textElement is String))
                {
                    drawnText = createTextSprite((textElement as String), document.textDrawer);
                    if (((drawnText.direction) || (direction)) == "lr")
                    {
                        drawnText.displayObject.x = (textOwner.currentX - drawnText.startX);
                        drawnText.displayObject.y = ((textOwner.currentY - drawnText.startY) - drawnText.baseLineShift);
                        textOwner.currentX = (textOwner.currentX + drawnText.textWidth);
                    }
                    else
                    {
                        drawnText.displayObject.x = ((textOwner.currentX - drawnText.textWidth) - drawnText.startX);
                        drawnText.displayObject.y = ((textOwner.currentY - drawnText.startY) - drawnText.baseLineShift);
                        textOwner.currentX = (textOwner.currentX - drawnText.textWidth);
                    }
                    if (drawnText.direction)
                    {
                        textDirection = drawnText.direction;
                    }
                    fillTextsSprite.addChild(drawnText.displayObject);
                    _renderObjects.push(drawnText.displayObject);
                }
                else
                {
                    if ((textElement is SVGTextContainer))
                    {
                        tspan = (textElement as SVGTextContainer);
                        if (tspan.hasOwnFill())
                        {
                            textOwner.textContainer.addChild(tspan);
                        }
                        else
                        {
                            fillTextsSprite.addChild(tspan);
                        }
                        tspan.invalidateRender();
                        tspan.validate();
                        _renderObjects.push(tspan);
                    }
                }
                i++;
            }
            this._end = textOwner.currentX;
            if (svgX)
            {
                doAnchorAlign(textDirection, this._start, this._end);
            }
            if (((hasComplexFill) && (fillTextsSprite.numChildren > 0)))
            {
                bounds = DisplayUtils.safeGetBounds(fillTextsSprite, content);
                bounds.inflate(2, 2);
                fill = new Sprite();
                beginFill(fill.graphics);
                fill.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
                fill.mask = fillTextsSprite;
                fillTextsSprite.cacheAsBitmap = true;
                fill.cacheAsBitmap = true;
                content.addChildAt(fill, 0);
                _renderObjects.push(fill);
            }
        }
        override public function clone():Object
        {
            var c:SVGTSpan = (super.clone() as SVGTSpan);
            c.svgX = svgX;
            c.svgY = svgY;
            c.svgDx = this.svgDx;
            c.svgDy = this.svgDy;
            return (c);
        }

    }
}
