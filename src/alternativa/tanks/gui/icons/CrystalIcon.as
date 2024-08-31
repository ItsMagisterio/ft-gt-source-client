package alternativa.tanks.gui.icons
{
    import flash.display.BitmapData;
    import flash.display.Bitmap;

    public class CrystalIcon
    {

        private static const bitmapCrystal:Class = CrystalIcon_bitmapCrystal;
        private static const crystalBd:BitmapData = new bitmapCrystal().bitmapData;
        private static const smallCrystal:Class = CrystalIcon_smallCrystal;
        private static const smallBitmapData:BitmapData = new smallCrystal().bitmapData;

        public static function createInstance():Bitmap
        {
            return (new Bitmap(crystalBd));
        }
        public static function createSmallInstance():Bitmap
        {
            return (new Bitmap(smallBitmapData));
        }

    }
}
