package alternativa.tanks.gui.panel.buttons
{
    import controls.panel.BaseButton;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class MainPanelSmallButton extends BaseButton
    {

        public static const BUTTON_WIDTH:int = 28;

        protected var _icon:Bitmap;
        private var _x:int;
        private var _y:int;
        private var _bitmapData:BitmapData;

        public function MainPanelSmallButton(_arg_1:BitmapData, _arg_2:int, _arg_3:int)
        {
            this._bitmapData = _arg_1;
            this._x = _arg_2;
            this._y = _arg_3;
            super();
        }

        override protected function configUI():void
        {
            bg = (new MainPanelHelpButton().getChildByName("b") as MovieClip);
            addChild(bg);
            this._icon = new Bitmap(this._bitmapData);
            this._icon.x = this._x;
            this._icon.y = this._y;
            addChild(this._icon);
        }

        override protected function addListeners():void
        {
            bg.gotoAndStop(2);
            buttonMode = true;
            mouseEnabled = true;
            mouseChildren = true;
            addEventListener(MouseEvent.MOUSE_OVER, this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_OUT, this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseEvent);
            addEventListener(MouseEvent.MOUSE_UP, this.onMouseEvent);
        }

        override protected function removeListeners():void
        {
            bg.gotoAndStop(1);
            buttonMode = false;
            mouseEnabled = false;
            mouseChildren = false;
            removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseEvent);
            removeEventListener(MouseEvent.MOUSE_UP, this.onMouseEvent);
        }

        override protected function onMouseEvent(_arg_1:MouseEvent):void
        {
            switch (_arg_1.type)
            {
                case MouseEvent.MOUSE_OVER:
                    this._icon.y = this._y;
                    bg.gotoAndStop(3);
                    return;
                case MouseEvent.MOUSE_OUT:
                    this._icon.y = this._y;
                    bg.gotoAndStop(2);
                    return;
                case MouseEvent.MOUSE_DOWN:
                    this._icon.y = (this._y + 1);
                    bg.gotoAndStop(4);
                    return;
                case MouseEvent.MOUSE_UP:
                    this._icon.y = this._y;
                    bg.gotoAndStop(2);
                    return;
            }
        }

        override public function get width():Number
        {
            return (BUTTON_WIDTH);
        }

    }
} // package alternativa.tanks.gui.panel.buttons