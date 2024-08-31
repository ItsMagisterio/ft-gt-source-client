// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.gui.combo.DPLBackground

package logic.gui.combo
{
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import assets.windowinner.elemets.WindowInnerTopLeftCorner;
    import assets.windowinner.elemets.WindowInnerTopRightCorner;
    import assets.windowinner.elemets.WindowInnerBottomLeftCorner;
    import assets.windowinner.elemets.WindowInnerBottomRightCorner;
    import assets.windowinner.bitmaps.WindowInnerTop;
    import assets.windowinner.bitmaps.WindowInnerBottom;
    import assets.windowinner.bitmaps.WindowInnerLeft;
    import assets.windowinner.bitmaps.WindowInnerRight;
    import flash.display.Shape;
    import flash.display.Graphics;

    public class DPLBackground extends Sprite
    {

        private static const b:Class = DPLBackground_b;

        private var bgBMP:BitmapData = new b().bitmapData;
        private var _width:int = 0;
        private var _height:int = 0;
        private var tl:WindowInnerTopLeftCorner = new WindowInnerTopLeftCorner();
        private var tr:WindowInnerTopRightCorner = new WindowInnerTopRightCorner();
        private var bl:WindowInnerBottomLeftCorner = new WindowInnerBottomLeftCorner();
        private var br:WindowInnerBottomRightCorner = new WindowInnerBottomRightCorner();
        private var topBMP:WindowInnerTop = new WindowInnerTop(0, 0);
        private var bottomBMP:WindowInnerBottom = new WindowInnerBottom(0, 0);
        private var leftBMP:WindowInnerLeft = new WindowInnerLeft(0, 0);
        private var rightBMP:WindowInnerRight = new WindowInnerRight(0, 0);
        private var bg:Sprite = new Sprite();
        private var top:Shape = new Shape();
        private var bottom:Shape = new Shape();
        private var left:Shape = new Shape();
        private var right:Shape = new Shape();

        public function DPLBackground(param1:int, param2:int)
        {
            this._width = param1;
            this._height = param2;
            addChild(this.bg);
            addChild(this.top);
            addChild(this.bottom);
            addChild(this.left);
            addChild(this.right);
            addChild(this.tl);
            addChild(this.tr);
            addChild(this.bl);
            addChild(this.br);
            this.draw();
        }
        protected function draw():void
        {
            var _loc1_:Graphics;
            _loc1_ = this.bg.graphics;
            _loc1_.clear();
            _loc1_.beginBitmapFill(this.bgBMP);
            _loc1_.drawRect(1, 1, (this._width - 2), (this._height - 2));
            _loc1_.endFill();
            _loc1_ = this.top.graphics;
            _loc1_.clear();
            _loc1_.beginBitmapFill(this.topBMP);
            _loc1_.drawRect(0, 0, (this._width - 12), 6);
            _loc1_.endFill();
            this.top.x = 6;
            _loc1_ = this.bottom.graphics;
            _loc1_.clear();
            _loc1_.beginBitmapFill(this.bottomBMP);
            _loc1_.drawRect(0, 0, (this._width - 12), 6);
            _loc1_.endFill();
            this.bottom.x = 6;
            this.bottom.y = (this._height - 6);
            _loc1_ = this.left.graphics;
            _loc1_.clear();
            _loc1_.beginBitmapFill(this.leftBMP);
            _loc1_.drawRect(0, 0, 6, (this._height - 12));
            _loc1_.endFill();
            this.left.x = 0;
            this.left.y = 6;
            _loc1_ = this.right.graphics;
            _loc1_.clear();
            _loc1_.beginBitmapFill(this.rightBMP);
            _loc1_.drawRect(0, 0, 6, (this._height - 12));
            _loc1_.endFill();
            this.right.x = (this._width - 6);
            this.right.y = 6;
            this.tl.x = 0;
            this.tl.y = 0;
            this.tr.x = (this._width - this.tr.width);
            this.tr.y = 0;
            this.bl.x = 0;
            this.bl.y = (this._height - this.bl.height);
            this.br.x = (this._width - this.br.width);
            this.br.y = (this._height - this.br.height);
        }
        override public function set width(param1:Number):void
        {
            if (this._width == int(param1))
            {
                return;
            }
            this._width = param1;
            this.draw();
        }
        override public function get width():Number
        {
            return (this._width);
        }
        override public function set height(param1:Number):void
        {
            if (this._height == int(param1))
            {
                return;
            }
            this._height = param1;
            this.draw();
        }
        override public function get height():Number
        {
            return (this._height);
        }
        public function setSize(param1:int, param2:int):void
        {
            this._width = param1;
            this._height = param2;
            this.draw();
        }

    }
} // package scpacker.gui.combo