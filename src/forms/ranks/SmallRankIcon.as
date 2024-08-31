// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// forms.ranks.SmallRankIcon

package forms.ranks
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;

    public class SmallRankIcon extends RankIcon
    {

        private static const nullRankIcon:Bitmap = new Bitmap(new BitmapData(1, 1));

        public function SmallRankIcon(_arg_1:int = 1, premium:Boolean = false)
        {
            if(premium){
                setPremium(_arg_1);
                x -= 3;
            }else{
                setDefaultAccount(_arg_1);
            }
        }

        override protected function createDefaultRankBitmap(_arg_1:int):Bitmap
        {
            if (((_arg_1 <= 0) || (_arg_1 > DefaultRanksBitmaps.smallRanks.length)))
            {
                return (nullRankIcon);
            }
            return (new Bitmap(DefaultRanksBitmaps.smallRanks[(_arg_1 - 1)]));
        }

        override protected function createPremiumRankBitmap(_arg_1:int):Bitmap
        {
            if (((_arg_1 <= 0) || (_arg_1 > PremiumRankBitmaps.smallRanks.length)))
            {
                return (nullRankIcon);
            }
            return (new Bitmap(PremiumRankBitmaps.smallRanks[(_arg_1 - 1)]));
        }

    }
} // package forms.ranks