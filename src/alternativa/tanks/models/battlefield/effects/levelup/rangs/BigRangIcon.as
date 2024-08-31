package alternativa.tanks.models.battlefield.effects.levelup.rangs
{
    import flash.display.BitmapData;

    public class BigRangIcon
    {

        private static const rang_1:Class = BigRangIcon_rang_1;
        private static const rang_2:Class = BigRangIcon_rang_2;
        private static const rang_3:Class = BigRangIcon_rang_3;
        private static const rang_4:Class = BigRangIcon_rang_4;
        private static const rang_5:Class = BigRangIcon_rang_5;
        private static const rang_6:Class = BigRangIcon_rang_6;
        private static const rang_7:Class = BigRangIcon_rang_7;
        private static const rang_8:Class = BigRangIcon_rang_8;
        private static const rang_9:Class = BigRangIcon_rang_9;
        private static const rang_10:Class = BigRangIcon_rang_10;
        private static const rang_11:Class = BigRangIcon_rang_11;
        private static const rang_12:Class = BigRangIcon_rang_12;
        private static const rang_13:Class = BigRangIcon_rang_13;
        private static const rang_14:Class = BigRangIcon_rang_14;
        private static const rang_15:Class = BigRangIcon_rang_15;
        private static const rang_16:Class = BigRangIcon_rang_16;
        private static const rang_17:Class = BigRangIcon_rang_17;
        private static const rang_18:Class = BigRangIcon_rang_18;
        private static const rang_19:Class = BigRangIcon_rang_19;
        private static const rang_20:Class = BigRangIcon_rang_20;
        private static const rang_21:Class = BigRangIcon_rang_21;
        private static const rang_22:Class = BigRangIcon_rang_22;
        private static const rang_23:Class = BigRangIcon_rang_23;
        private static const rang_24:Class = BigRangIcon_rang_24;
        private static const rang_25:Class = BigRangIcon_rang_25;
        private static const rang_26:Class = BigRangIcon_rang_26;
        private static const rang_27:Class = BigRangIcon_rang_27;
        private static const rang_28:Class = BigRangIcon_rang_28;
        private static const rang_29:Class = BigRangIcon_rang_29;
        private static const rang_30:Class = BigRangIcon_rang_30;
        private static var rangs:Array = [new rang_1(), new rang_2(), new rang_3(), new rang_4(), new rang_5(), new rang_6(), new rang_7(), new rang_8(), new rang_9(), new rang_10(), new rang_11(), new rang_12(), new rang_13(), new rang_14(), new rang_15(), new rang_16(), new rang_17(), new rang_18(), new rang_19(), new rang_20(), new rang_21(), new rang_22(), new rang_23(), new rang_24(), new rang_25(), new rang_26(), new rang_27(), new rang_28(), new rang_29(), new rang_30()];

        public static function getRangIcon(rang:int):BitmapData
        {
            return (rangs[(rang - 1)].bitmapData);
        }

    }
}
