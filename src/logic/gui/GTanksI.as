// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.gui.GTanksI

package logic.gui
{
    import flash.display.Bitmap;

    public class GTanksI implements GTanksLoaderImages
    {

        private static const coldload1:Class = GTanksI_coldload1;
        private static const coldload2:Class = GTanksI_coldload2;
        private static const coldload3:Class = GTanksI_coldload3;
        private static const coldload4:Class = GTanksI_coldload4;
        private static const coldload5:Class = GTanksI_coldload5;
        private static const coldload6:Class = GTanksI_coldload6;
        private static const coldload7:Class = GTanksI_coldload7;
        private static const coldload8:Class = GTanksI_coldload8;
        private static const coldload9:Class = GTanksI_coldload9;
        private static const coldload10:Class = GTanksI_coldload10;
        private static const coldload11:Class = GTanksI_coldload11;
        private static const coldload12:Class = GTanksI_coldload12;
        private static const coldload13:Class = GTanksI_coldload13;
        private static const coldload14:Class = GTanksI_coldload14;
        private static const coldload15:Class = GTanksI_coldload15;
        private static const coldload16:Class = GTanksI_coldload16;
        private static const coldload17:Class = GTanksI_coldload17;
        private static var items:Array = new Array(coldload1, coldload2, coldload3, coldload4, coldload5, coldload6, coldload7, coldload8, coldload9, coldload10, coldload11, coldload12, coldload13, coldload14, coldload15, coldload16, coldload17);

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
} // package scpacker.gui