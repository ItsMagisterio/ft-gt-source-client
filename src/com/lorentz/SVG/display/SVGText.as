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

    public class SVGText extends SVGTextContainer
    {

        public var currentX:Number = 0;
        public var currentY:Number = 0;
        public var textContainer:Sprite;
        private var _start:Number = 0;
        private var _end:Number = 0;
        private var fillTextsSprite:Sprite;

        public function SVGText()
        {
            super("text");
        }
        override protected function render():void
        {
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
            this.textContainer = content;
            document.textDrawer.start();
            var direction:String = ((getDirectionFromStyles()) || ("lr"));
            var textDirection:String = direction;
            this.currentX = getViewPortUserUnit(svgX, SVGUtil.WIDTH);
            this.currentY = getViewPortUserUnit(svgY, SVGUtil.HEIGHT);
            this._start = this.currentX;
            _renderObjects = new Vector.<DisplayObject>();
            if (hasComplexFill)
            {
                this.fillTextsSprite = new Sprite();
                this.textContainer.addChild(this.fillTextsSprite);
            }
            else
            {
                this.fillTextsSprite = this.textContainer;
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
                        drawnText.displayObject.x = (this.currentX - drawnText.startX);
                        drawnText.displayObject.y = ((this.currentY - drawnText.startY) - drawnText.baseLineShift);
                        this.currentX = (this.currentX + drawnText.textWidth);
                    }
                    else
                    {
                        drawnText.displayObject.x = ((this.currentX - drawnText.textWidth) - drawnText.startX);
                        drawnText.displayObject.y = ((this.currentY - drawnText.startY) - drawnText.baseLineShift);
                        this.currentX = (this.currentX - drawnText.textWidth);
                    }
                    if (drawnText.direction)
                    {
                        textDirection = drawnText.direction;
                    }
                    this.fillTextsSprite.addChild(drawnText.displayObject);
                    _renderObjects.push(drawnText.displayObject);
                }
                else
                {
                    if ((textElement is SVGTextContainer))
                    {
                        tspan = (textElement as SVGTextContainer);
                        if (tspan.hasOwnFill())
                        {
                            this.textContainer.addChild(tspan);
                        }
                        else
                        {
                            this.fillTextsSprite.addChild(tspan);
                        }
                        tspan.invalidateRender();
                        tspan.validate();
                        _renderObjects.push(tspan);
                    }
                }
                i++;
            }
            this._end = this.currentX;
            doAnchorAlign(textDirection, this._start, this._end);
            document.textDrawer.end();
            if (((hasComplexFill) && (this.fillTextsSprite.numChildren > 0)))
            {
                bounds = DisplayUtils.safeGetBounds(this.fillTextsSprite, content);
                bounds.inflate(2, 2);
                fill = new Sprite();
                beginFill(fill.graphics);
                fill.graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
                fill.mask = this.fillTextsSprite;
                this.fillTextsSprite.cacheAsBitmap = true;
                fill.cacheAsBitmap = true;
                this.textContainer.addChildAt(fill, 0);
                _renderObjects.push(fill);
            }
        }
        override protected function getObjectBounds():Rectangle
        {
            return (content.getBounds(this));
        }
        override public function clone():Object
        {
            var c:SVGText = (super.clone() as SVGText);
            c.svgX = svgX;
            c.svgY = svgY;
            return (c);
        }

    }
}
