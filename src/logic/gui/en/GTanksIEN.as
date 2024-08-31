// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.gui.en.GTanksIEN

package logic.gui.en
{
    import logic.gui.GTanksLoaderImages;
    import flash.display.Bitmap;

    public class GTanksIEN implements GTanksLoaderImages
    {

        private static const coldload1:Class = GTanksIEN_coldload1;
        private static const coldload2:Class = GTanksIEN_coldload2;
        private static const coldload3:Class = GTanksIEN_coldload3;
        private static const coldload4:Class = GTanksIEN_coldload4;
        private static const coldload5:Class = GTanksIEN_coldload5;
        private static const coldload6:Class = GTanksIEN_coldload6;
        private static const coldload7:Class = GTanksIEN_coldload7;
        private static const coldload8:Class = GTanksIEN_coldload8;
        private static const coldload9:Class = GTanksIEN_coldload9;
        private static const coldload10:Class = GTanksIEN_coldload10;
        private static const coldload11:Class = GTanksIEN_coldload11;
        private static const coldload12:Class = GTanksIEN_coldload12;
        private static const coldload13:Class = GTanksIEN_coldload13;
        private static const coldload14:Class = GTanksIEN_coldload14;
        private static const coldload15:Class = GTanksIEN_coldload15;
        private static var items:Array = new Array(coldload1, coldload2, coldload3, coldload4, coldload5, coldload6, coldload7, coldload8, coldload9, coldload10, coldload11, coldload12, coldload13, coldload14, coldload15);

        private var prev:int;

        public function getRandomPict():Bitmap
        {
            var r:int;
            do
            {
            }
            while ((r = (Math.random() * items.length)) == this.prev);
            return (new Bitmap(new (items[r])().bitmapData));
        }

    }
} // package scpacker.gui.en