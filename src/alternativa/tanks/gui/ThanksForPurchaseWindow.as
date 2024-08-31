package alternativa.tanks.gui
{
    import flash.display.Sprite;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import controls.base.DefaultButtonBase;
    import controls.TankWindow;
    import controls.TankWindowInner;
    import flash.display.Bitmap;
    import alternativa.tanks.gui.payment.controls.OrderingLine;
    import flash.display.Shape;
    import flash.display.DisplayObject;

    public class ThanksForPurchaseWindow extends Sprite
    {

        [Inject]
        public static var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);

        private const windowMargin:int = 12;
        private const margin:int = 9;

        private var bitmap:Class = ThanksForPurchaseWindow_bitmap;
        public var closeButton:DefaultButtonBase;
        public var donationCrystals:int;
        private var inner:Sprite;

        public function ThanksForPurchaseWindow(param2:int, param3:int, param4:int)
        {
            this.donationCrystals = param2;
            var _loc5_:int = (((this.windowMargin * 2) + (this.margin * 2)) + new this.bitmap().bitmapData.width);
            var _loc6_:TankWindow = new TankWindow();
            addChild(_loc6_);
            var _loc7_:TankWindowInner = new TankWindowInner((_loc5_ - (this.windowMargin * 2)), 0, TankWindowInner.GREEN);
            this.inner = _loc7_;
            _loc6_.addChild(_loc7_);
            _loc7_.x = this.windowMargin;
            _loc7_.y = this.windowMargin;
            var _loc8_:Bitmap = new Bitmap(new this.bitmap().bitmapData);
            _loc8_.x = ((_loc7_.width - _loc8_.width) / 2);
            this.addLine(_loc8_, this.windowMargin);
            var _loc9_:int = (_loc7_.width * 0.8);
            var _loc10_:OrderingLine = new OrderingLine("Crystals purchased:", param2);
            _loc10_.width = _loc9_;
            this.centerAlign(_loc10_, _loc7_.width);
            this.addLine(_loc10_, 0);
            if (param3 > 0)
            {
                _loc10_ = new OrderingLine("Package purchase bonus:", param3);
                _loc10_.width = _loc9_;
                this.centerAlign(_loc10_, _loc7_.width);
                this.addLine(_loc10_, -7);
            }
            if (param4 > 0)
            {
                _loc10_ = new OrderingLine("«Premium» Subscription:", param4);
                _loc10_.width = _loc9_;
                this.centerAlign(_loc10_, _loc7_.width);
                this.addLine(_loc10_, -7);
            }
            var _loc11_:Shape = new Shape();
            _loc11_.graphics.beginFill(5898034);
            var _loc12_:int;
            while (_loc12_ < (_loc9_ - 5))
            {
                _loc11_.graphics.drawRect(_loc12_, 0, 1, 1);
                _loc12_ = (_loc12_ + 3);
            }
            this.centerAlign(_loc11_, _loc7_.width);
            this.addLine(_loc11_, 4);
            _loc10_ = new OrderingLine("Total crystals received:", ((param4 + param2) + param3));
            _loc10_.width = _loc9_;
            this.centerAlign(_loc10_, _loc7_.width);
            this.addLine(_loc10_, 1);
            _loc7_.height = (_loc7_.height + this.windowMargin);
            this.closeButton = new DefaultButtonBase();
            if (localeService != null)
            {
                this.closeButton.label = "Close";
            }
            this.closeButton.y = ((_loc7_.x + _loc7_.height) + this.windowMargin);
            this.centerAlign(this.closeButton, _loc5_);
            _loc6_.addChild(this.closeButton);
            _loc6_.height = ((this.closeButton.y + this.closeButton.height) + this.windowMargin);
            _loc6_.width = _loc5_;
            addChild(_loc6_);
        }
        private function centerAlign(param1:DisplayObject, param2:Number):void
        {
            param1.x = ((param2 - param1.width) / 2);
        }
        private function addLine(param1:DisplayObject, param2:int):void
        {
            param1.y = (this.inner.height + param2);
            this.inner.addChild(param1);
        }

    }
}
