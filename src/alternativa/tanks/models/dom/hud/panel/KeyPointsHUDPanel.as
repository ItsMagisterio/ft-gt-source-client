package alternativa.tanks.models.dom.hud.panel
{
    import flash.display.Sprite;
    import flash.display.Shape;
    import __AS3__.vec.Vector;
    import alternativa.tanks.models.dom.Point;
    import controls.Label;
    import controls.resultassets.WhiteFrame;
    import __AS3__.vec.*;

    public class KeyPointsHUDPanel extends Sprite
    {

        private static const SPACING:int = 1;

        private var shape:Shape = new Shape();
        private var indicators:Vector.<KeyPointHUDIndicator>;
        private var _width:int;
        private var _height:int;

        public function KeyPointsHUDPanel(param1:Vector.<Point>)
        {
            this.createIndicators(param1);
            this.createBorder(param1.length);
            addChild(this.shape);
            this.bringLabelsToFront();
        }
        public function removeFromParent():void
        {
            if (parent != null)
            {
                parent.removeChild(this);
            }
        }
        private function bringLabelsToFront():void
        {
            var _loc1_:KeyPointHUDIndicator;
            for each (_loc1_ in this.indicators)
            {
                addChild(_loc1_.getLabel());
            }
        }
        public function render(param1:int, param2:int):void
        {
            this.update();
        }
        public function update():void
        {
            var _loc1_:KeyPointHUDIndicator;
            for each (_loc1_ in this.indicators)
            {
                _loc1_.update();
            }
        }
        private function createIndicators(param1:Vector.<Point>):void
        {
            var _loc2_:Vector.<Point>;
            var _loc5_:Point;
            var _loc6_:KeyPointHUDIndicator;
            var _loc7_:Label;
            _loc2_ = this.sortPoints(param1);
            var _loc3_:int = 2;
            this.indicators = new Vector.<KeyPointHUDIndicator>(param1.length);
            var _loc4_:int;
            while (_loc4_ < _loc2_.length)
            {
                _loc5_ = _loc2_[_loc4_];
                _loc6_ = new KeyPointHUDIndicator(_loc5_);
                _loc6_.x = _loc3_;
                _loc6_.y = 2;
                addChild(_loc6_);
                _loc7_ = _loc6_.getLabel();
                _loc7_.y = 8;
                _loc7_.x = int((_loc6_.x + ((_loc6_.width - _loc7_.width) / 2)));
                if (_loc4_ < (_loc2_.length - 1))
                {
                    this.shape.graphics.lineStyle(0, 0xFFFFFF);
                    this.shape.graphics.moveTo((_loc6_.x + 36), 2);
                    this.shape.graphics.lineTo((_loc6_.x + 36), 38);
                }
                this.indicators[_loc4_] = _loc6_;
                _loc3_ = (_loc3_ + (_loc6_.width + SPACING));
                _loc4_++;
            }
        }
        private function sortPoints(param1:Vector.<Point>):Vector.<Point>
        {
            var points:Vector.<Point> = param1;
            return (points.concat().sort(function(param1:Point, param2:Point):Number
                    {
                        if (param1.id < param2.id)
                        {
                            return (-1);
                        }
                        if (param1.id > param2.id)
                        {
                            return (1);
                        }
                        return (0);
                    }));
        }
        private function createBorder(param1:int):void
        {
            var _loc2_:WhiteFrame = new WhiteFrame();
            _loc2_.width = (((param1 * (36 + SPACING)) - SPACING) + 4);
            addChild(_loc2_);
            this._width = _loc2_.width;
            this._height = _loc2_.height;
        }
        [Obfuscation(rename="false")]
        override public function get width():Number
        {
            return (this._width);
        }
        [Obfuscation(rename="false")]
        override public function get height():Number
        {
            return (this._height);
        }

    }
}
