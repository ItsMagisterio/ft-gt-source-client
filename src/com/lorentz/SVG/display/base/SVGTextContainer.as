package com.lorentz.SVG.display.base
{
    import com.lorentz.SVG.display.SVGText;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import com.lorentz.SVG.utils.TextUtils;
    import com.lorentz.SVG.data.text.SVGTextToDraw;
    import com.lorentz.SVG.utils.SVGUtil;
    import com.lorentz.SVG.data.text.SVGDrawnText;
    import com.lorentz.SVG.text.ISVGTextDrawer;
    import com.lorentz.SVG.utils.SVGColorUtils;
    import __AS3__.vec.*;

    public class SVGTextContainer extends SVGGraphicsElement
    {

        private var _svgX:String;
        private var _svgY:String;
        private var _textOwner:SVGText;
        protected var _renderObjects:Vector.<DisplayObject>;
        private var _textElements:Vector.<Object> = new Vector.<Object>();

        public function SVGTextContainer(tagName:String)
        {
            super(tagName);
            if ((this is SVGText))
            {
                this._textOwner = (this as SVGText);
            }
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
                this.invalidateRender();
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
                this.invalidateRender();
            }
        }
        protected function get textOwner():SVGText
        {
            return (this._textOwner);
        }
        override protected function setParentElement(value:SVGElement):void
        {
            super.setParentElement(value);
            if ((value is SVGText))
            {
                this.setTextOwner((value as SVGText));
            }
            else
            {
                if ((value is SVGTextContainer))
                {
                    this.setTextOwner((value as SVGTextContainer).textOwner);
                }
                else
                {
                    this.setTextOwner((this as SVGText));
                }
            }
        }
        private function setTextOwner(value:SVGText):void
        {
            var element:Object;
            if (this._textOwner != value)
            {
                this._textOwner = value;
                for each (element in this._textElements)
                {
                    if ((element is SVGTextContainer))
                    {
                        (element as SVGTextContainer).setTextOwner(value);
                    }
                }
            }
        }
        public function addTextElement(element:Object):void
        {
            this.addTextElementAt(element, this.numTextElements);
        }
        public function addTextElementAt(element:Object, index:int):void
        {
            this._textElements.splice(index, 0, element);
            if ((element is SVGElement))
            {
                attachElement((element as SVGElement));
            }
            this.invalidateRender();
        }
        public function getTextElementAt(index:int):Object
        {
            return (this._textElements[index]);
        }
        public function get numTextElements():int
        {
            return (this._textElements.length);
        }
        public function removeTextElementAt(index:int):void
        {
            if (((index < 0) || (index >= this.numTextElements)))
            {
                return;
            }
            var element:Object = this._textElements[index];
            if ((element is SVGElement))
            {
                detachElement((element as SVGElement));
            }
            this.invalidateRender();
        }
        override public function invalidateRender():void
        {
            super.invalidateRender();
            if (((this.textOwner) && (!(this.textOwner == this))))
            {
                this.textOwner.invalidateRender();
            }
        }
        override protected function onStyleChanged(styleName:String, oldValue:String, newValue:String):void
        {
            super.onStyleChanged(styleName, oldValue, newValue);
            switch (styleName)
            {
                case "font-size":
                case "font-family":
                case "font-weight":
                    this.invalidateRender();
                    break;
            }
        }
        protected function createTextSprite(text:String, textDrawer:ISVGTextDrawer):SVGDrawnText
        {
            var direction:String = TextUtils.getParagraphDirection(text);
            if (direction == "rl")
            {
                text = ((String.fromCharCode(8207) + text) + String.fromCharCode(8207));
            }
            else
            {
                if (direction == "lr")
                {
                    text = ((String.fromCharCode(8206) + text) + String.fromCharCode(8206));
                }
            }
            var textToDraw:SVGTextToDraw = new SVGTextToDraw();
            textToDraw.text = text;
            textToDraw.useEmbeddedFonts = document.useEmbeddedFonts;
            textToDraw.parentFontSize = ((parentElement) ? parentElement.currentFontSize : currentFontSize);
            textToDraw.fontSize = currentFontSize;
            textToDraw.fontFamily = String(((finalStyle.getPropertyValue("font-family")) || (document.defaultFontName)));
            textToDraw.fontWeight = ((finalStyle.getPropertyValue("font-weight")) || ("normal"));
            textToDraw.fontStyle = ((finalStyle.getPropertyValue("font-style")) || ("normal"));
            textToDraw.baselineShift = ((finalStyle.getPropertyValue("baseline-shift")) || ("baseline"));
            var letterSpacing:String = ((finalStyle.getPropertyValue("letter-spacing")) || ("normal"));
            if (((letterSpacing) && (!(letterSpacing.toLowerCase() == "normal"))))
            {
                textToDraw.letterSpacing = SVGUtil.getUserUnit(letterSpacing, currentFontSize, viewPortWidth, viewPortHeight, SVGUtil.FONT_SIZE);
            }
            if (document.textDrawingInterceptor != null)
            {
                document.textDrawingInterceptor(textToDraw);
            }
            if ((!(this.hasComplexFill)))
            {
                textToDraw.color = this.getFillColor();
            }
            var drawnText:SVGDrawnText = textDrawer.drawText(textToDraw);
            if ((!(this.hasComplexFill)))
            {
                if (hasFill)
                {
                    drawnText.displayObject.alpha = this.getFillOpacity();
                }
                else
                {
                    drawnText.displayObject.alpha = 0;
                }
            }
            drawnText.direction = direction;
            return (drawnText);
        }
        protected function get hasComplexFill():Boolean
        {
            var fill:String = finalStyle.getPropertyValue("fill");
            return ((fill) && (!(fill.indexOf("url") == -1)));
        }
        private function getFillColor():uint
        {
            var fill:String = finalStyle.getPropertyValue("fill");
            if (((fill == null) || (fill.indexOf("url") > -1)))
            {
                return (0);
            }
            return (SVGColorUtils.parseToUint(fill));
        }
        private function getFillOpacity():Number
        {
            return (Number(((finalStyle.getPropertyValue("fill-opacity")) || (1))));
        }
        protected function getDirectionFromStyles():String
        {
            var direction:String = finalStyle.getPropertyValue("direction");
            if (direction)
            {
                switch (direction)
                {
                    case "ltr":
                        return ("lr");
                    case "tlr":
                        return ("rl");
                }
            }
            var writingMode:String = finalStyle.getPropertyValue("writing-mode");
            switch (writingMode)
            {
                case "lr":
                case "lr-tb":
                    return ("lr");
                case "rl":
                case "rl-tb":
                    return ("rl");
                case "tb":
                case "tb-rl":
                    return ("tb");
            }
            return (null);
        }
        public function doAnchorAlign(direction:String, textStartX:Number, textEndX:Number):void
        {
            var textAnchor:String = ((finalStyle.getPropertyValue("text-anchor")) || ("start"));
            var anchorX:Number = getViewPortUserUnit(this.svgX, SVGUtil.WIDTH);
            var offsetX:Number = 0;
            if (direction == "lr")
            {
                if (textAnchor == "start")
                {
                    offsetX = (offsetX + (anchorX - textStartX));
                }
                if (textAnchor == "middle")
                {
                    offsetX = (offsetX + (anchorX - ((textEndX + textStartX) / 2)));
                }
                else
                {
                    if (textAnchor == "end")
                    {
                        offsetX = (offsetX + (anchorX - textEndX));
                    }
                }
            }
            else
            {
                if (textAnchor == "start")
                {
                    offsetX = (offsetX + (anchorX - textEndX));
                }
                if (textAnchor == "middle")
                {
                    offsetX = (offsetX + (anchorX - ((textEndX + textStartX) / 2)));
                }
                else
                {
                    if (textAnchor == "end")
                    {
                        offsetX = (offsetX + (anchorX - textStartX));
                    }
                }
            }
            this.offset(offsetX);
        }
        public function offset(offsetX:Number):void
        {
            var renderedText:DisplayObject;
            var textContainer:SVGTextContainer;
            if (this._renderObjects == null)
            {
                return;
            }
            for each (renderedText in this._renderObjects)
            {
                if ((renderedText is SVGTextContainer))
                {
                    textContainer = (renderedText as SVGTextContainer);
                    if ((!(textContainer.svgX)))
                    {
                        textContainer.offset(offsetX);
                    }
                }
                else
                {
                    renderedText.x = (renderedText.x + offsetX);
                }
            }
        }
        public function hasOwnFill():Boolean
        {
            return (((!(style.getPropertyValue("fill") == null)) && (!(style.getPropertyValue("fill") == ""))) && (!(style.getPropertyValue("fill") == "none")));
        }
        override public function clone():Object
        {
            var textElement:Object;
            var c:SVGTextContainer = (super.clone() as SVGTextContainer);
            var i:int;
            while (i < this.numTextElements)
            {
                textElement = this.getTextElementAt(i);
                if ((textElement is SVGElement))
                {
                    c.addTextElement((textElement as SVGElement).clone());
                }
                else
                {
                    c.addTextElement(textElement);
                }
                i++;
            }
            return (c);
        }

    }
}
