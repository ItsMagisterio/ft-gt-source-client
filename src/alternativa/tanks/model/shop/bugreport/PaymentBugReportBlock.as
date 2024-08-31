package alternativa.tanks.model.shop.bugreport
{
    import flash.display.Sprite;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import flash.display.BitmapData;
    import controls.TankWindowInner;
    import controls.base.DefaultButtonBase;
    import flash.display.Bitmap;
    import controls.base.LabelBase;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public class PaymentBugReportBlock extends Sprite
    {

        public static var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);
        public static const WINDOW_MARGIN:int = 11;
        public static const SPACE_MODULE:int = 7;
        private static const bitmapError:Class = PaymentBugReportBlock_bitmapError;
        private static const errorBd:BitmapData = new bitmapError().bitmapData;

        private var errorInner:TankWindowInner;
        public var errorButton:DefaultButtonBase;
        private var errorIcon:Bitmap;
        private var errorLabel:LabelBase;
        private var _height:Number;
        private var _width:Number;

        public function PaymentBugReportBlock()
        {
            this.errorInner = new TankWindowInner(0, 0, TankWindowInner.TRANSPARENT);
            addChild(this.errorInner);
            this.errorIcon = new Bitmap(errorBd);
            addChild(this.errorIcon);
            this.errorLabel = new LabelBase();
            addChild(this.errorLabel);
            this.errorLabel.multiline = true;
            this.errorLabel.wordWrap = true;
            this.errorLabel.text = "If your payment did not reach us, or there was problem with your transaction, please report the problem to us.";
            this.errorButton = new DefaultButtonBase();
            this.errorButton.label = "Report";
            this.errorButton.addEventListener(MouseEvent.CLICK, this.openGroup);
            addChild(this.errorButton);
            this.errorButton.y = SPACE_MODULE;
            this._height = 45;
            this.errorInner.height = this._height;
            this.errorIcon.x = WINDOW_MARGIN;
            this.errorIcon.y = int(((this._height - this.errorIcon.height) * 0.5));
            this.errorLabel.x = ((this.errorIcon.x + this.errorIcon.width) + WINDOW_MARGIN);
        }
        private function openGroup(param1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://cybertankz.com/"), "_blank");
        }
        override public function get height():Number
        {
            return (this._height);
        }
        override public function set height(param1:Number):void
        {
        }
        override public function get width():Number
        {
            return (this._width);
        }
        override public function set width(param1:Number):void
        {
            this._width = param1;
            this.errorInner.width = this._width;
            this.errorButton.x = ((this._width - this.errorButton.width) - WINDOW_MARGIN);
            this.errorLabel.width = ((this.errorButton.x - this.errorLabel.x) - WINDOW_MARGIN);
            this.errorLabel.y = int(((this._height - this.errorLabel.height) * 0.5));
        }

    }
} // package alternativa.tanks.model.shop.bugreport