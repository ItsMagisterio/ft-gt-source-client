package controls
{
    import flash.display.MovieClip;
    import flash.text.TextFormat;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.text.TextFormatAlign;
    import flash.text.TextFieldAutoSize;
    import flash.filters.DropShadowFilter;
    import flash.display.BitmapData;
    import assets.button.button_def_UP_LEFT;
    import assets.button.button_def_UP_CENTER;
    import assets.button.button_def_UP_RIGHT;
    import assets.button.button_def_OVER_LEFT;
    import assets.button.button_def_OVER_CENTER;
    import assets.button.button_def_OVER_RIGHT;
    import assets.button.button_def_DOWN_LEFT;
    import assets.button.button_def_DOWN_CENTER;
    import assets.button.button_def_DOWN_RIGHT;
    import assets.button.button_red_UP_LEFT;
    import assets.button.button_red_UP_CENTER;
    import assets.button.button_red_UP_RIGHT;
    import assets.button.button_red_OVER_LEFT;
    import assets.button.button_red_OVER_CENTER;
    import assets.button.button_red_OVER_RIGHT;
    import assets.button.button_red_DOWN_LEFT;
    import assets.button.button_red_DOWN_CENTER;
    import assets.button.button_red_DOWN_RIGHT;
    import assets.button.button_blue_UP_LEFT;
    import assets.button.button_blue_UP_CENTER;
    import assets.button.button_blue_UP_RIGHT;
    import assets.button.button_blue_OVER_LEFT;
    import assets.button.button_blue_OVER_CENTER;
    import assets.button.button_blue_OVER_RIGHT;
    import assets.button.button_blue_DOWN_LEFT;
    import assets.button.button_blue_DOWN_CENTER;
    import assets.button.button_blue_DOWN_RIGHT;
    import assets.button.button_OFF_LEFT;
    import assets.button.button_OFF_CENTER;
    import assets.button.button_OFF_RIGHT;

    public class ColorButton extends MovieClip
    {

        public static const DEFAULT:String = "def";
        public static const RED:String = "red";
        public static const BLUE:String = "blue";

        public var stateUP:ButtonState = new ButtonState();
        public var stateOVER:ButtonState = new ButtonState();
        public var stateDOWN:ButtonState = new ButtonState();
        public var stateOFF:ButtonState = new ButtonState();
        protected var _label:Label = new Label();
        protected var _hint:Hint;
        public var labelColor:uint = 0xFFFFFF;
        private var format:TextFormat = new TextFormat("MyriadPro", 12);
        private var _enable:Boolean = true;
        protected var _width:int;

        public function ColorButton()
        {
            this.configUI();
            this.enable = true;
            tabEnabled = false;
        }
        public function get label():String
        {
            return (this._label.text);
        }
        public function set label(_arg_1:String):void
        {
            this._label.text = _arg_1;
        }
        public function set hint(_arg_1:String):void
        {
            if (this._hint != null)
            {
                this._hint.text = _arg_1;
                return;
            }
            this._hint = new Hint();
            this._hint.text = _arg_1;
            addChild(this._hint);
            this._hint.visible = false;
            this._hint.y = -(this._hint.height);
            addEventListener(MouseEvent.MOUSE_OVER, this.showHint);
            addEventListener(MouseEvent.MOUSE_OUT, this.hideHint);
        }
        private function showHint(_arg_1:Event):void
        {
            this._hint.visible = true;
        }
        private function hideHint(_arg_1:Event):void
        {
            this._hint.visible = false;
        }
        public function set enable(_arg_1:Boolean):void
        {
            this._enable = _arg_1;
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
        override public function set width(_arg_1:Number):void
        {
            this._width = int(_arg_1);
            this.stateDOWN.width = (this.stateOFF.width = (this.stateOVER.width = (this.stateUP.width = this._width)));
            this._label.width = (this._width - 4);
        }
        public function configUI():void
        {
            addChild(this.stateOFF);
            addChild(this.stateDOWN);
            addChild(this.stateOVER);
            addChild(this.stateUP);
            addChild(this._label);
            this.format.align = "center";
            this.format.color = this.labelColor;
            this._label.align = TextFormatAlign.CENTER;
            this._label.autoSize = TextFieldAutoSize.NONE;
            this._label.selectable = false;
            this._label.x = 2;
            this._label.y = 6;
            this._label.width = 92;
            this._label.height = 22;
            this._label.mouseEnabled = false;
            this._label.filters = [new DropShadowFilter(1, 45, 0, 0.7, 1, 1, 1)];
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
                        this._label.y = 6;
                        return;
                    case MouseEvent.MOUSE_OUT:
                        this.setState(1);
                        this._label.y = 6;
                        return;
                    case MouseEvent.MOUSE_DOWN:
                        this.setState(3);
                        this._label.y = 7;
                        return;
                    case MouseEvent.MOUSE_UP:
                        this.setState(1);
                        this._label.y = 6;
                        return;
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
        public function setStyle(_arg_1:String = "def"):void
        {
            var _local_3:String;
            var _local_2:* = (("button_" + _arg_1) + "_");
            _local_3 = "UP";
            this.stateUP.bmpLeft = this.getBitmapByName(((_local_2 + _local_3) + "_LEFT"));
            this.stateUP.bmpCenter = this.getBitmapByName(((_local_2 + _local_3) + "_CENTER"));
            this.stateUP.bmpRight = this.getBitmapByName(((_local_2 + _local_3) + "_RIGHT"));
            _local_3 = "OVER";
            this.stateOVER.bmpLeft = this.getBitmapByName(((_local_2 + _local_3) + "_LEFT"));
            this.stateOVER.bmpCenter = this.getBitmapByName(((_local_2 + _local_3) + "_CENTER"));
            this.stateOVER.bmpRight = this.getBitmapByName(((_local_2 + _local_3) + "_RIGHT"));
            _local_3 = "DOWN";
            this.stateDOWN.bmpLeft = this.getBitmapByName(((_local_2 + _local_3) + "_LEFT"));
            this.stateDOWN.bmpCenter = this.getBitmapByName(((_local_2 + _local_3) + "_CENTER"));
            this.stateDOWN.bmpRight = this.getBitmapByName(((_local_2 + _local_3) + "_RIGHT"));
            _local_3 = "OFF";
            _local_2 = "button_";
            this.stateOFF.bmpLeft = this.getBitmapByName(((_local_2 + _local_3) + "_LEFT"));
            this.stateOFF.bmpCenter = this.getBitmapByName(((_local_2 + _local_3) + "_CENTER"));
            this.stateOFF.bmpRight = this.getBitmapByName(((_local_2 + _local_3) + "_RIGHT"));
            this.width = 96;
        }
        private function getBitmapByName(_arg_1:String):BitmapData
        {
            var _local_2:BitmapData = new BitmapData(1, 1);
            switch (_arg_1)
            {
                case "button_def_UP_LEFT":
                    _local_2 = new button_def_UP_LEFT(1, 1);
                    break;
                case "button_def_UP_CENTER":
                    _local_2 = new button_def_UP_CENTER(1, 1);
                    break;
                case "button_def_UP_RIGHT":
                    _local_2 = new button_def_UP_RIGHT(1, 1);
                    break;
                case "button_def_OVER_LEFT":
                    _local_2 = new button_def_OVER_LEFT(1, 1);
                    break;
                case "button_def_OVER_CENTER":
                    _local_2 = new button_def_OVER_CENTER(1, 1);
                    break;
                case "button_def_OVER_RIGHT":
                    _local_2 = new button_def_OVER_RIGHT(1, 1);
                    break;
                case "button_def_DOWN_LEFT":
                    _local_2 = new button_def_DOWN_LEFT(1, 1);
                    break;
                case "button_def_DOWN_CENTER":
                    _local_2 = new button_def_DOWN_CENTER(1, 1);
                    break;
                case "button_def_DOWN_RIGHT":
                    _local_2 = new button_def_DOWN_RIGHT(1, 1);
                    break;
                case "button_red_UP_LEFT":
                    _local_2 = new button_red_UP_LEFT(1, 1);
                    break;
                case "button_red_UP_CENTER":
                    _local_2 = new button_red_UP_CENTER(1, 1);
                    break;
                case "button_red_UP_RIGHT":
                    _local_2 = new button_red_UP_RIGHT(1, 1);
                    break;
                case "button_red_OVER_LEFT":
                    _local_2 = new button_red_OVER_LEFT(1, 1);
                    break;
                case "button_red_OVER_CENTER":
                    _local_2 = new button_red_OVER_CENTER(1, 1);
                    break;
                case "button_red_OVER_RIGHT":
                    _local_2 = new button_red_OVER_RIGHT(1, 1);
                    break;
                case "button_red_DOWN_LEFT":
                    _local_2 = new button_red_DOWN_LEFT(1, 1);
                    break;
                case "button_red_DOWN_CENTER":
                    _local_2 = new button_red_DOWN_CENTER(1, 1);
                    break;
                case "button_red_DOWN_RIGHT":
                    _local_2 = new button_red_DOWN_RIGHT(1, 1);
                    break;
                case "button_blue_UP_LEFT":
                    _local_2 = new button_blue_UP_LEFT(1, 1);
                    break;
                case "button_blue_UP_CENTER":
                    _local_2 = new button_blue_UP_CENTER(1, 1);
                    break;
                case "button_blue_UP_RIGHT":
                    _local_2 = new button_blue_UP_RIGHT(1, 1);
                    break;
                case "button_blue_OVER_LEFT":
                    _local_2 = new button_blue_OVER_LEFT(1, 1);
                    break;
                case "button_blue_OVER_CENTER":
                    _local_2 = new button_blue_OVER_CENTER(1, 1);
                    break;
                case "button_blue_OVER_RIGHT":
                    _local_2 = new button_blue_OVER_RIGHT(1, 1);
                    break;
                case "button_blue_DOWN_LEFT":
                    _local_2 = new button_blue_DOWN_LEFT(1, 1);
                    break;
                case "button_blue_DOWN_CENTER":
                    _local_2 = new button_blue_DOWN_CENTER(1, 1);
                    break;
                case "button_blue_DOWN_RIGHT":
                    _local_2 = new button_blue_DOWN_RIGHT(1, 1);
                    break;
                case "button_OFF_LEFT":
                    _local_2 = new button_OFF_LEFT(1, 1);
                    break;
                case "button_OFF_CENTER":
                    _local_2 = new button_OFF_CENTER(1, 1);
                    break;
                case "button_OFF_RIGHT":
                    _local_2 = new button_OFF_RIGHT(1, 1);
                    break;
            }
            return (_local_2);
        }

    }
}
