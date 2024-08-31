package alternativa.tanks.model.shop.items.base
{
    import flash.events.MouseEvent;
    import controls.base.LabelBase;
    import alternativa.tanks.model.shop.event.ShopItemChosen;

    public class ShopItemBase extends ButtonItemBase
    {

        protected static const WIDTH:int = 279;
        protected static const HEIGHT:int = 143;

        protected var itemId:String;
        protected var uniqueId:String;

        public function ShopItemBase(itemId:String, uniqueId:String, param2:ButtonItemSkin)
        {
            this.itemId = itemId;
            this.uniqueId = uniqueId;
            addEventListener(MouseEvent.CLICK, this.onMouseClick);
            super(param2);
        }
        protected function fixChineseCurrencyLabelRendering(param1:LabelBase):void
        {
        }
        private function onMouseClick(param1:MouseEvent):void
        {
            dispatchEvent(new ShopItemChosen(this.uniqueId, gridPosition));
        }
        override public function get width():Number
        {
            return (WIDTH);
        }
        override public function get height():Number
        {
            return (HEIGHT);
        }
        override public function destroy():void
        {
            super.destroy();
            removeEventListener(MouseEvent.CLICK, this.onMouseClick);
        }
        public function activateDisabledFilter():void
        {
            alpha = 0.9;
        }

    }
}
