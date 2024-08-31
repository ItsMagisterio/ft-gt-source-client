package com.lorentz.SVG.display
{
    import com.lorentz.SVG.display.base.SVGContainer;
    import com.lorentz.SVG.display.base.ISVGViewBox;
    import flash.geom.Rectangle;
    import com.lorentz.SVG.utils.StringUtil;
    import com.lorentz.SVG.utils.SVGUtil;
    import flash.geom.Matrix;
    import com.lorentz.SVG.parser.SVGParserCommon;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.Graphics;

    public class SVGPattern extends SVGContainer implements ISVGViewBox
    {

        private var _finalSvgX:String;
        private var _finalSvgY:String;
        private var _finalSvgWidth:String;
        private var _finalSvgHeight:String;
        private var _finalPatternTransform:String;
        private var _svgHrefChanged:Boolean = false;
        private var _svgHref:String;
        private var _patternWithChildren:SVGPattern;

        public function SVGPattern()
        {
            super("pattern");
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
        public function get svgX():String
        {
            return (getAttribute("x") as String);
        }
        public function set svgX(value:String):void
        {
            setAttribute("x", value);
            invalidateProperties();
        }
        public function get svgY():String
        {
            return (getAttribute("y") as String);
        }
        public function set svgY(value:String):void
        {
            setAttribute("y", value);
            invalidateProperties();
        }
        public function get svgWidth():String
        {
            return (getAttribute("width") as String);
        }
        public function set svgWidth(value:String):void
        {
            setAttribute("width", value);
            invalidateProperties();
        }
        public function get svgHeight():String
        {
            return (getAttribute("height") as String);
        }
        public function set svgHeight(value:String):void
        {
            setAttribute("height", value);
            invalidateProperties();
        }
        public function get patternTransform():String
        {
            return (getAttribute("patternTransform") as String);
        }
        public function set patternTransform(value:String):void
        {
            setAttribute("patternTransform", value);
            invalidateProperties();
        }
        public function get svgViewBox():Rectangle
        {
            return (getAttribute("viewBox") as Rectangle);
        }
        public function set svgViewBox(value:Rectangle):void
        {
            setAttribute("viewBox", value);
            invalidateProperties();
        }
        override protected function commitProperties():void
        {
            var refPattern:SVGPattern;
            super.commitProperties();
            if (((this._patternWithChildren) && (!(this._patternWithChildren == this))))
            {
                detachElement(this._patternWithChildren);
                this._patternWithChildren = null;
            }
            this._finalSvgX = this.svgX;
            this._finalSvgY = this.svgY;
            this._finalSvgWidth = this.svgWidth;
            this._finalSvgHeight = this.svgHeight;
            this._finalPatternTransform = this.patternTransform;
            this._patternWithChildren = this;
            if (this.svgHref)
            {
                refPattern = this;
                while (refPattern.svgHref)
                {
                    refPattern = (document.getDefinition(StringUtil.ltrim(refPattern.svgHref, "#")) as SVGPattern);
                    if ((!(refPattern)))
                    {
                        break;
                    }
                    if (this._patternWithChildren.numElements == 0)
                    {
                        this._patternWithChildren = refPattern;
                    }
                    if ((!(this._finalSvgX)))
                    {
                        this._finalSvgX = refPattern.svgX;
                    }
                    if ((!(this._finalSvgY)))
                    {
                        this._finalSvgY = refPattern.svgY;
                    }
                    if ((!(this._finalSvgWidth)))
                    {
                        this._finalSvgWidth = refPattern.svgWidth;
                    }
                    if ((!(this._finalSvgHeight)))
                    {
                        this._finalSvgHeight = refPattern.svgHeight;
                    }
                    if ((!(this._finalPatternTransform)))
                    {
                        this._finalPatternTransform = refPattern.patternTransform;
                    }
                }
            }
            if (((this._patternWithChildren) && (!(this._patternWithChildren == this))))
            {
                this._patternWithChildren = (this._patternWithChildren.clone() as SVGPattern);
                attachElement(this._patternWithChildren);
            }
        }
        public function beginFill(graphics:Graphics):void
        {
            var drawX:Number;
            var x:Number = 0;
            if (this._finalSvgX)
            {
                x = getViewPortUserUnit(this._finalSvgX, SVGUtil.WIDTH);
            }
            var y:Number = 0;
            if (this._finalSvgY)
            {
                y = getViewPortUserUnit(this._finalSvgY, SVGUtil.HEIGHT);
            }
            var w:Number = 0;
            if (this._finalSvgWidth)
            {
                w = getViewPortUserUnit(this._finalSvgWidth, SVGUtil.WIDTH);
            }
            var h:Number = 0;
            if (this._finalSvgHeight)
            {
                h = getViewPortUserUnit(this._finalSvgHeight, SVGUtil.HEIGHT);
            }
            var patternMat:Matrix = new Matrix();
            patternMat.translate(x, y);
            if (this._finalPatternTransform)
            {
                patternMat.concat(SVGParserCommon.parseTransformation(this._finalPatternTransform));
            }
            var patScaleX:Number = Math.sqrt(((patternMat.a * patternMat.a) + (patternMat.c * patternMat.c)));
            var patScaleY:Number = Math.sqrt(((patternMat.b * patternMat.b) + (patternMat.d * patternMat.d)));
            var patScale:Number = Math.max(patScaleX, patScaleY);
            var bitmapW:int = Math.round((w * patScale));
            var bitmapH:int = Math.round((h * patScale));
            if (((bitmapW == 0) || (bitmapH == 0)))
            {
                return;
            }
            var bd:BitmapData = new BitmapData(bitmapW, bitmapH, true, 0);
            var spriteToRender:Sprite = new Sprite();
            var contentParent:Sprite = new Sprite();
            var content:Sprite = this._patternWithChildren.content;
            spriteToRender.addChild(contentParent);
            contentParent.addChild(content);
            content.transform.matrix = new Matrix();
            contentParent.scaleX = (contentParent.scaleY = patScale);
            var bounds:Rectangle = content.getBounds(content);
            var x0:Number = (Math.floor((bounds.left / w)) * w);
            var x1:Number = (Math.floor((bounds.right / w)) * w);
            var y0:Number = (Math.floor((bounds.top / h)) * h);
            var y1:Number = (Math.floor((bounds.bottom / h)) * h);
            var drawY:Number = -(y1);
            while (drawY <= -(y0))
            {
                drawX = -(x1);
                while (drawX <= -(x0))
                {
                    content.x = drawX;
                    content.y = drawY;
                    bd.draw(spriteToRender, null, null, null, null, true);
                    drawX = (drawX + w);
                }
                drawY = (drawY + h);
            }
            var mat:Matrix = contentParent.transform.matrix.clone();
            mat.invert();
            mat.concat(patternMat);
            graphics.beginBitmapFill(bd, mat, true, true);
            this._patternWithChildren.addChild(content);
        }
        override public function clone():Object
        {
            var c:SVGPattern = (super.clone() as SVGPattern);
            c.svgX = this.svgX;
            c.svgY = this.svgY;
            c.svgWidth = this.svgWidth;
            c.svgHeight = this.svgHeight;
            c.patternTransform = this.patternTransform;
            c.svgHref = this.svgHref;
            return (c);
        }

    }
}
