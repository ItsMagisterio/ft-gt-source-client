package controls.slider
{
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.display.Graphics;
    import flash.geom.Matrix;
    import forms.ranks.SmallRankIcon;

    public class SelectRankThumb extends SliderThumb
    {

        private static const bitmapArrow:Class = SelectRankThumb_bitmapArrow;
        private static const arrow:BitmapData = new bitmapArrow().bitmapData;

        private var iconMin:SmallRankIcon = new SmallRankIcon();
        private var iconMax:SmallRankIcon = new SmallRankIcon();
        private var _minRang:int = 0;
        private var _maxRang:int = 0;
        public var leftDrag:Sprite;
        public var centerDrag:Sprite;
        public var rightDrag:Sprite;

        public function SelectRankThumb()
        {
            var g:Graphics;
            super();
            addChild(this.iconMax);
            addChild(this.iconMin);
            this.iconMin.y = (this.iconMax.y = 9);
            this.leftDrag = new Sprite();
            g = this.leftDrag.graphics;
            g.beginFill(0, 0);
            g.drawRect(0, 0, 10, 30);
            g.endFill();
            this.centerDrag = new Sprite();
            this.centerDrag.x = 10;
            this.rightDrag = new Sprite();
            g = this.rightDrag.graphics;
            g.beginFill(0, 0);
            g.drawRect(0, 0, 10, 30);
            g.endFill();
            addChild(this.leftDrag);
            addChild(this.centerDrag);
            addChild(this.rightDrag);
            this.leftDrag.buttonMode = true;
            this.centerDrag.buttonMode = true;
            this.rightDrag.buttonMode = true;
        }
        override protected function draw():void
        {
            var g:Graphics;
            var matrix:Matrix;
            super.draw();
            var rz:int = (this._maxRang - this._minRang);
            this.iconMin.setRank(this._minRang);
            this.iconMax.setRank(this._maxRang);
            this.iconMax.visible = (rz > 0);
            if (rz == 0)
            {
                this.iconMax.x = (this.iconMin.x = int(((_width - this.iconMin.width) / 2)));
            }
            else
            {
                this.iconMin.x = 11;
                this.iconMax.x = ((_width - this.iconMax.width) - 11);
                g = this.graphics;
                matrix = new Matrix();
                matrix.translate(5, 12);
                g.beginBitmapFill(arrow, matrix);
                g.drawRect(5, 12, 4, 7);
                g.endFill();
                matrix = new Matrix();
                matrix.rotate(Math.PI);
                matrix.translate((_width - 9), 12);
                g.beginBitmapFill(arrow, matrix);
                g.drawRect((_width - 9), 12, 4, 7);
                g.endFill();
            }
            g = this.centerDrag.graphics;
            g.clear();
            g.beginFill(0, 0);
            g.drawRect(0, 0, (_width - 20), 30);
            g.endFill();
            this.rightDrag.x = (_width - 10);
        }
        public function set minRang(minRang:int):void
        {
            this._minRang = minRang;
            this.draw();
        }
        public function set maxRang(maxRang:int):void
        {
            this._maxRang = maxRang;
            this.draw();
        }

    }
}
