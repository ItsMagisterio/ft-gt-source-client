package alternativa.tanks.model.shop.items.base
{
    public class GreyShopItemSkin extends ButtonItemSkin
    {

        private static const normalStateClass:Class = GreyShopItemSkin_normalStateClass;
        private static const overStateClass:Class = GreyShopItemSkin_overStateClass;

        public function GreyShopItemSkin()
        {
            normalState = new normalStateClass().bitmapData;
            overState = new overStateClass().bitmapData;
        }
    }
}
