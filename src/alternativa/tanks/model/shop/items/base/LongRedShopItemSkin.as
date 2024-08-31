package alternativa.tanks.model.shop.items.base
{
    public class LongRedShopItemSkin extends ButtonItemSkin
    {

        private static const normalStateClass:Class = LongRedNormal;
        private static const overStateClass:Class = LongRedHover;

        public function LongRedShopItemSkin()
        {
            normalState = new normalStateClass().bitmapData;
            overState = new overStateClass().bitmapData;
        }
    }
}
