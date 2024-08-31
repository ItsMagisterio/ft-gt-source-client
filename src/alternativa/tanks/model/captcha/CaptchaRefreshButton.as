package alternativa.tanks.model.captcha
{
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.events.MouseEvent;

    public class CaptchaRefreshButton extends Sprite
    {

        private static const _bitmapData:Class = CaptchaRefreshButton__bitmapData;
        private static const bitmapData:BitmapData = new _bitmapData().bitmapData;

        private var bitmap:Bitmap;

        public function CaptchaRefreshButton()
        {
            this.bitmap = new Bitmap(bitmapData);
            addChild(this.bitmap);
            addEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
            addEventListener(MouseEvent.MOUSE_UP, this.mouseHandler);
        }
        private function mouseHandler(event:MouseEvent):void
        {
            this.bitmap.y = ((event.type == MouseEvent.MOUSE_DOWN) ? Number(1) : Number(0));
        }

    }
}
