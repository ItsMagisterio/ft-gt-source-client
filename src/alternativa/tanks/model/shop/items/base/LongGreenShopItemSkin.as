package alternativa.tanks.model.shop.items.base
{
    public class LongGreenShopItemSkin extends ButtonItemSkin
    {

        private static const normalStateClass:Class = GreenNormal;
        private static const overStateClass:Class = GreenHover;

        public function LongGreenShopItemSkin()
        {
            normalState = new normalStateClass().bitmapData;
            overState = new overStateClass().bitmapData;
        }
    }
}
