package controls.rangicons
{
    import flash.display.MovieClip;
    import flash.display.Bitmap;

    public class RangIcon extends MovieClip
    {

        private static const rangs:Array = ["Recruit", "Private", "Gefreiter", "Corporal", "Master Corporal", "Sergeant", "Staff Sergeant", "Master Sergeant", "First Sergeant", "Sergeant-Major", "Warrant Officer 1", "Warrant Officer 2", "Warrant Officer 3", "Warrant Officer 4", "Warrant Officer 5", "Third Lieutenant", "Second Lieutenant", "First Lieutenant", "Captain", "Major", "Lieutenant Colonel", "Colonel", "Brigadier", "Major General", "Lieutenant General", "General", "Marshal", "Field Marshal", "Commander", "Generallisimo"];
        private static const p1:Class = RangIcon_p1;
        private static const p2:Class = RangIcon_p2;
        private static const p3:Class = RangIcon_p3;
        private static const p4:Class = RangIcon_p4;
        private static const p5:Class = RangIcon_p5;
        private static const p6:Class = RangIcon_p6;
        private static const p7:Class = RangIcon_p7;
        private static const p8:Class = RangIcon_p8;
        private static const p9:Class = RangIcon_p9;
        private static const p10:Class = RangIcon_p10;
        private static const p11:Class = RangIcon_p11;
        private static const p12:Class = RangIcon_p12;
        private static const p13:Class = RangIcon_p13;
        private static const p14:Class = RangIcon_p14;
        private static const p15:Class = RangIcon_p15;
        private static const p16:Class = RangIcon_p16;
        private static const p17:Class = RangIcon_p17;
        private static const p18:Class = RangIcon_p18;
        private static const p19:Class = RangIcon_p19;
        private static const p20:Class = RangIcon_p20;
        private static const p21:Class = RangIcon_p21;
        private static const p22:Class = RangIcon_p22;
        private static const p23:Class = RangIcon_p23;
        private static const p24:Class = RangIcon_p24;
        private static const p25:Class = RangIcon_p25;
        private static const p26:Class = RangIcon_p26;
        private static const p27:Class = RangIcon_p27;
        private static const p28:Class = RangIcon_p28;
        private static const p29:Class = RangIcon_p29;
        private static const p30:Class = RangIcon_p30;

        public var _rang:int = 1;
        public var rangs12:Array = new Array((new p1() as Bitmap), (new p2() as Bitmap), (new p3() as Bitmap), (new p4() as Bitmap), (new p5() as Bitmap), (new p6() as Bitmap), (new p7() as Bitmap), (new p8() as Bitmap), (new p9() as Bitmap), (new p10() as Bitmap), (new p11() as Bitmap), (new p12() as Bitmap), (new p13() as Bitmap), (new p14() as Bitmap), (new p15() as Bitmap), (new p16() as Bitmap), (new p17() as Bitmap), (new p18() as Bitmap), (new p19() as Bitmap), (new p20() as Bitmap), (new p21() as Bitmap), (new p22() as Bitmap), (new p23() as Bitmap), (new p24() as Bitmap), (new p25() as Bitmap), (new p26() as Bitmap), (new p27() as Bitmap), (new p28() as Bitmap), (new p29() as Bitmap), (new p30() as Bitmap));

        public function RangIcon(param1:int = 1)
        {
            this.addChild(new Bitmap(this.rangs12[0].bitmapData));
            this.rang = param1;
        }
        public static function rangName(param1:int):String
        {
            return (rangs[(param1 - 1)]);
        }

        public function set rang(param1:int):void
        {
            this.removeChildren();
            this._rang = param1;
            if (param1 > 0)
            {
                this.addChild(new Bitmap(this.rangs12[(this._rang - 1)].bitmapData));
            }
            gotoAndStop(0);
        }
        public function get rang():int
        {
            return (this._rang);
        }

    }
}
