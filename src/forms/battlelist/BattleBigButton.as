package forms.battlelist
{
    import controls.BigButton;
    import assets.Diamond;
    import controls.Label;
    import flash.events.MouseEvent;

    public class BattleBigButton extends BigButton
    {

        private var diamond:Diamond = new Diamond();
        private var costLabel:Label = new Label();
        private var _cost:int = 0;

        public function BattleBigButton()
        {
            addChild(this.diamond);
            addChild(this.costLabel);
            this.diamond.visible = (this.costLabel.visible = false);
            label = "";
        }
        override public function set width(w:Number):void
        {
            _width = int(w);
            stateDOWN.width = (stateOFF.width = (stateOVER.width = (stateUP.width = _width)));
            _info.width = (_label.width = (_width - 4));
            if (_icon.bitmapData != null)
            {
                _icon.x = 6;
                _icon.y = int((25 - (_icon.height / 2)));
                _label.width = ((_width - 8) - _icon.width);
                _label.x = (_icon.width + 4);
                _label.y = ((this._cost == 0) ? 16 : 6);
            }
            if (this._cost > 0)
            {
                this.diamond.visible = (this.costLabel.visible = true);
                this.diamond.x = ((_icon.width + 4) + ((_label.width - _label.textWidth) / 2));
                this.diamond.y = 26;
                this.costLabel.y = 22;
                this.costLabel.text = String(this._cost);
                this.costLabel.x = (this.diamond.x + this.diamond.width);
            }
            else
            {
                this.diamond.visible = (this.costLabel.visible = false);
            }
        }
        public function set cost(value:int):void
        {
            this._cost = value;
            this.width = _width;
        }
        override protected function onMouseEvent(event:MouseEvent):void
        {
            if (_enable)
            {
                switch (event.type)
                {
                    case MouseEvent.MOUSE_OVER:
                        setState(2);
                        _label.y = ((this._cost == 0) ? 16 : 6);
                        this.diamond.y = 26;
                        this.costLabel.y = 22;
                        break;
                    case MouseEvent.MOUSE_OUT:
                        setState(1);
                        _label.y = ((this._cost == 0) ? 16 : 6);
                        this.diamond.y = 26;
                        this.costLabel.y = 22;
                        break;
                    case MouseEvent.MOUSE_DOWN:
                        setState(3);
                        _label.y = ((this._cost == 0) ? 17 : 7);
                        this.diamond.y = 26;
                        this.costLabel.y = 23;
                        break;
                    case MouseEvent.MOUSE_UP:
                        setState(1);
                        _label.y = ((this._cost == 0) ? 16 : 6);
                        this.diamond.y = 26;
                        this.costLabel.y = 22;
                        break;
                }
                if (_icon != null)
                {
                    _icon.y = (int((25 - (_icon.height / 2))) + ((event.type == MouseEvent.MOUSE_DOWN) ? 1 : 0));
                }
            }
        }

    }
}
