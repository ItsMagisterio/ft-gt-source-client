package alternativa.tanks.model.shop.items.base
{
    public class GreenShopItemSkin extends ButtonItemSkin
    {

        private static const normalStateClass:Class = GreenShopItemSkin_normalStateClass;
        private static const overStateClass:Class = GreenShopItemSkin_overStateClass;

        public function GreenShopItemSkin()
        {
            normalState = new normalStateClass().bitmapData;
            overState = new overStateClass().bitmapData;
        }
    }
}
