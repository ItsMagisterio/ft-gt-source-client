package alternativa.tanks.model.shop.items.base
{
    public class LongYellowShopItemSkin extends ButtonItemSkin
    {

        private static const normalStateClass:Class = YellowNormal;
        private static const overStateClass:Class = YellowHover;

        public function LongYellowShopItemSkin()
        {
            normalState = new normalStateClass().bitmapData;
            overState = new overStateClass().bitmapData;
        }
    }
}
