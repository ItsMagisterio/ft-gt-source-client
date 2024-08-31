// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.test.UpdateRankPrize

package logic.test
{
    public class UpdateRankPrize
    {

        private static var crystalls:Array = [0, 10, 40, 120, 230, 420, 740, 950, 1400, 2000, 2500, 3100, 3900, 4600, 5600, 6600, 7900, 8900, 10000, 12000, 14000, 16000, 17000, 20000, 22000, 24000, 28000, 31000, 34000, 37000];

        public static function getCount(rang:int):int
        {
            return (crystalls[(rang - 1)]);
        }

    }
} // package scpacker.test