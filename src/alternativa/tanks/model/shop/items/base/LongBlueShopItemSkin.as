package alternativa.tanks.model.shop.items.base
{
    public class LongBlueShopItemSkin extends ButtonItemSkin
    {

        private static const normalStateClass:Class = BlueNormal;
        private static const overStateClass:Class = BlueHover;

        public function LongBlueShopItemSkin()
        {
            normalState = new normalStateClass().bitmapData;
            overState = new overStateClass().bitmapData;
        }
    }
}
