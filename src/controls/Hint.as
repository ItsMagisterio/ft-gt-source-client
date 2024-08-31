package controls
{
    import flash.display.Sprite;
    import flash.display.Graphics;

    public class Hint extends Sprite
    {

        private const MAX_WIDTH:* = 200;
        private const COLOR:* = 0xFFFFFF;
        private const ALPHA:* = 0.4;

        private var _label:Label = new Label();

        public function Hint()
        {
            addChild(this._label);
            this._label.size = 11;
        }
        public function set text(_arg_1:String):void
        {
            var _local_2:Graphics = this.graphics;
            this._label.text = _arg_1;
            if (this._label.textWidth > this.MAX_WIDTH)
            {
                this._label.width = this.MAX_WIDTH;
                this._label.multiline = true;
                this._label.wordWrap = true;
            }
            _local_2.clear();
            _local_2.beginFill(this.COLOR, this.ALPHA);
            _local_2.drawRect(-3, -3, (this._label.textWidth + 9), (this._label.textHeight + 9));
            _local_2.endFill();
        }

    }
}
