package controls
{
    import flash.display.MovieClip;
    import flash.display.BitmapData;
    import assets.icons.icon_SHORTAGE_ENERGY;
    import flash.display.Bitmap;
    import flash.text.TextFormatAlign;
    import flash.text.TextFieldAutoSize;
    import flash.filters.DropShadowFilter;
    import assets.button.bigbutton_UP_LEFT;
    import assets.button.bigbutton_UP_CENTER;
    import assets.button.bigbutton_UP_RIGHT;
    import assets.button.bigbutton_OVER_LEFT;
    import assets.button.bigbutton_OVER_CENTER;
    import assets.button.bigbutton_OVER_RIGHT;
    import assets.button.bigbutton_DOWN_LEFT;
    import assets.button.bigbutton_DOWN_CENTER;
    import assets.button.bigbutton_DOWN_RIGHT;
    import assets.button.bigbutton_OFF_LEFT;
    import assets.button.bigbutton_OFF_CENTER;
    import assets.button.bigbutton_OFF_RIGHT;
    import flash.events.MouseEvent;

    public class BigButton extends MovieClip
    {

        public static const SHORTAGE_ENERGY:BitmapData = new icon_SHORTAGE_ENERGY(35, 35);

        protected var stateUP:BigButtonState = new BigButtonState();
        protected var stateOVER:BigButtonState = new BigButtonState();
        protected var stateDOWN:BigButtonState = new BigButtonState();
        protected var stateOFF:BigButtonState = new BigButtonState();
        protected var _label:Label = new Label();
        protected var _info:Label = new Label();
        protected var _icon:Bitmap = new Bitmap();
        protected var _width:int = 100;
        protected var _enable:Boolean = true;
        public var en1:Boolean = true;

        public function BigButton()
        {
            this.configUI();
            this.enable = true;
            tabEnabled = false;
        }
        override public function set width(_arg_1:Number):void
        {
            this._width = int(_arg_1);
            this.stateDOWN.width = (this.stateOFF.width = (this.stateOVER.width = (this.stateUP.width = this._width)));
            this._info.width = (this._label.width = (this._width - 4));
            if (this._icon.bitmapData != null)
            {
                this._icon.x = ((this._width - this._icon.width) - 6);
                this._icon.y = int((25 - (this._icon.height / 2)));
                this._label.width = ((this._width - 4) - this._icon.width);
            }
        }
        public function set label(_arg_1:String):void
        {
            this._label.text = _arg_1;
        }
        public function set info(_arg_1:String):void
        {
            this._info.htmlText = _arg_1;
        }
        public function set icon(_arg_1:BitmapData):void
        {
            if (_arg_1 != null)
            {
                this._icon.visible = true;
                this._label.width = ((this._width - 4) - this._icon.width);
            }
            else
            {
                this._label.width = (this._width - 4);
                this._icon.visible = false;
            }
            this._icon.bitmapData = _arg_1;
            this.width = this._width;
        }
        private function configUI():void
        {
            addChild(this.stateOFF);
            addChild(this.stateDOWN);
            addChild(this.stateOVER);
            addChild(this.stateUP);
            addChild(this._label);
            addChild(this._icon);
            this._info.align = (this._label.align = TextFormatAlign.CENTER);
            this._info.autoSize = (this._label.autoSize = TextFieldAutoSize.NONE);
            this._info.selectable = (this._label.selectable = false);
            this._info.x = (this._label.x = 2);
            this._label.y = 15;
            this._info.y = 24;
            this._label.height = 24;
            this._info.height = 20;
            this._label.size = 14;
            this._info.mouseEnabled = (this._label.mouseEnabled = false);
            this._info.filters = (this._label.filters = [new DropShadowFilter(1, 45, 0, 0.7, 1, 1, 1)]);
            this.stateUP.bmpLeft = new bigbutton_UP_LEFT(1, 1);
            this.stateUP.bmpCenter = new bigbutton_UP_CENTER(1, 1);
            this.stateUP.bmpRight = new bigbutton_UP_RIGHT(1, 1);
            this.stateOVER.bmpLeft = new bigbutton_OVER_LEFT(1, 1);
            this.stateOVER.bmpCenter = new bigbutton_OVER_CENTER(1, 1);
            this.stateOVER.bmpRight = new bigbutton_OVER_RIGHT(1, 1);
            this.stateDOWN.bmpLeft = new bigbutton_DOWN_LEFT(1, 1);
            this.stateDOWN.bmpCenter = new bigbutton_DOWN_CENTER(1, 1);
            this.stateDOWN.bmpRight = new bigbutton_DOWN_RIGHT(1, 1);
            this.stateOFF.bmpLeft = new bigbutton_OFF_LEFT(1, 1);
            this.stateOFF.bmpCenter = new bigbutton_OFF_CENTER(1, 1);
            this.stateOFF.bmpRight = new bigbutton_OFF_RIGHT(1, 1);
            this.width = 120;
        }
        public function set enable(_arg_1:Boolean):void
        {
            this._enable = _arg_1;
            this.en1 = true;
            if (this._enable)
            {
                this.addListeners();
            }
            else
            {
                this.removeListeners();
            }
        }
        public function get enable():Boolean
        {
            return (this._enable);
        }

        public function ena():void
        {
            this.en1 = false;
            removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_UP, this.onMouseEvent);
            this.stateOFF.alpha = 1;
            this.stateUP.alpha = 0;
            this.stateOVER.alpha = 0;
            this.stateDOWN.alpha = 0;
        }

        public function forceEnable():void
        {
            this.en1 = true;
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_UP, this.onMouseEvent);
            this.stateOFF.alpha = 0;
            this.stateUP.alpha = 1;
            this.stateOVER.alpha = 0;
            this.stateDOWN.alpha = 0;
        }

        protected function addListeners():void
        {
            this.setState(1);
            buttonMode = true;
            mouseEnabled = true;
            mouseChildren = true;
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_UP, this.onMouseEvent);
        }
        protected function removeListeners():void
        {
            this.setState(0);
            buttonMode = false;
            mouseEnabled = false;
            mouseChildren = false;
            removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_UP, this.onMouseEvent);
        }
        protected function onMouseEvent(_arg_1:MouseEvent):void
        {
            if (this._enable)
            {
                switch (_arg_1.type)
                {
                    case MouseEvent.MOUSE_OVER:
                        this.setState(2);
                        this._label.y = 15;
                        this._info.y = 24;
                        break;
                    case MouseEvent.MOUSE_OUT:
                        this.setState(1);
                        this._label.y = 15;
                        this._info.y = 24;
                        break;
                    case MouseEvent.MOUSE_DOWN:
                        this.setState(3);
                        this._label.y = 16;
                        this._info.y = 25;
                        break;
                    case MouseEvent.MOUSE_UP:
                        this.setState(1);
                        this._label.y = 15;
                        this._info.y = 24;
                        break;
                }
                if (this._icon != null)
                {
                    this._icon.y = (int((25 - (this._icon.height / 2))) + ((_arg_1.type == MouseEvent.MOUSE_DOWN) ? 1 : 0));
                }
            }
        }
        protected function setState(_arg_1:int = 0):void
        {
            switch (_arg_1)
            {
                case 0:
                    this.stateOFF.alpha = 1;
                    this.stateUP.alpha = 0;
                    this.stateOVER.alpha = 0;
                    this.stateDOWN.alpha = 0;
                    return;
                case 1:
                    this.stateOFF.alpha = 0;
                    this.stateUP.alpha = 1;
                    this.stateOVER.alpha = 0;
                    this.stateDOWN.alpha = 0;
                    return;
                case 2:
                    this.stateOFF.alpha = 0;
                    this.stateUP.alpha = 0;
                    this.stateOVER.alpha = 1;
                    this.stateDOWN.alpha = 0;
                    return;
                case 3:
                    this.stateOFF.alpha = 0;
                    this.stateUP.alpha = 0;
                    this.stateOVER.alpha = 0;
                    this.stateDOWN.alpha = 1;
                    return;
            }
        }

    }
}
