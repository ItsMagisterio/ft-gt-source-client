package alternativa.tanks.model.shop.items.base
{
    public class RedShopItemSkin extends ButtonItemSkin
    {

        private static const normalStateClass:Class = RedShopItemSkin_normalStateClass;
        private static const overStateClass:Class = RedShopItemSkin_overStateClass;

        public function RedShopItemSkin()
        {
            normalState = new normalStateClass().bitmapData;
            overState = new overStateClass().bitmapData;
        }
    }
}
