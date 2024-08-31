package alternativa.tanks.model.gift.icons
{
    import flash.display.BitmapData;

    public class ItemGiftBackgrounds
    {

        private static const _bg_common:Class = ItemGiftBackgrounds__bg_common;
        private static const _bg_legendary:Class = ItemGiftBackgrounds__bg_legendary;
        private static const _bg_rare:Class = ItemGiftBackgrounds__bg_rare;
        private static const _bg_uncommon:Class = ItemGiftBackgrounds__bg_uncommon;
        private static const _bg_unique:Class = ItemGiftBackgrounds__bg_unique;
        private static const bgCommon:BitmapData = new _bg_common().bitmapData;
        private static const bgLegendary:BitmapData = new _bg_legendary().bitmapData;
        private static const bgRare:BitmapData = new _bg_rare().bitmapData;
        private static const bgUncommon:BitmapData = new _bg_uncommon().bitmapData;
        private static const bgUnique:BitmapData = new _bg_unique().bitmapData;
        private static const array:Array = new Array(bgCommon, bgUncommon, bgRare, bgUnique, bgLegendary);

        public static function getBG(i:int):BitmapData
        {
            return (array[i]);
        }
        public static function getColor(i:int):uint
        {
            if (i == 0)
            {
                return (0xC0C0C0);
            }
            if (i == 1)
            {
                return (0xFFFF);
            }
            if (i == 2)
            {
                return (11163135);
            }
            if (i == 3)
            {
                return (0xFF6000);
            }
            if (i == 4)
            {
                return (0xFFFF00);
            }
            return (0);
        }

    }
}
