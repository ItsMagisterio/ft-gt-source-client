package controls.rangicons
{
    import flash.display.MovieClip;
    import flash.display.DisplayObject;
    import flash.display.Bitmap;

    public class RangIconNormal extends RangIcon
    {

        private static const p1:Class = RangIconNormal_p1;
        private static const p2:Class = RangIconNormal_p2;
        private static const p3:Class = RangIconNormal_p3;
        private static const p4:Class = RangIconNormal_p4;
        private static const p5:Class = RangIconNormal_p5;
        private static const p6:Class = RangIconNormal_p6;
        private static const p7:Class = RangIconNormal_p7;
        private static const p8:Class = RangIconNormal_p8;
        private static const p9:Class = RangIconNormal_p9;
        private static const p10:Class = RangIconNormal_p10;
        private static const p11:Class = RangIconNormal_p11;
        private static const p12:Class = RangIconNormal_p12;
        private static const p13:Class = RangIconNormal_p13;
        private static const p14:Class = RangIconNormal_p14;
        private static const p15:Class = RangIconNormal_p15;
        private static const p16:Class = RangIconNormal_p16;
        private static const p17:Class = RangIconNormal_p17;
        private static const p18:Class = RangIconNormal_p18;
        private static const p19:Class = RangIconNormal_p19;
        private static const p20:Class = RangIconNormal_p20;
        private static const p21:Class = RangIconNormal_p21;
        private static const p22:Class = RangIconNormal_p22;
        private static const p23:Class = RangIconNormal_p23;
        private static const p24:Class = RangIconNormal_p24;
        private static const p25:Class = RangIconNormal_p25;
        private static const p26:Class = RangIconNormal_p26;
        private static const p27:Class = RangIconNormal_p27;
        private static const p28:Class = RangIconNormal_p28;
        private static const p29:Class = RangIconNormal_p29;
        private static const p30:Class = RangIconNormal_p30;

        private static const prem:Class = PremiumBG;

        public var g:MovieClip;
        private var gl:DisplayObject;
        private var rangs1:Array = [new p1(), new p2(), new p3(), new p4(), new p5(), new p6(), new p7(), new p8(), new p9(), new p10(), new p11(), new p12(), new p13(), new p14(), new p15(), new p16(), new p17(), new p18(), new p19(), new p20(), new p21(), new p22(), new p23(), new p24(), new p25(), new p26(), new p27(), new p28(), new p29(), new p30()];

        public function RangIconNormal(param1:int = 1)
        {
            addFrameScript(0, this.frame1);
            super(param1);
            this.removeChildren();
            this._rang = param1;
            this.addChild(new Bitmap(this.rangs1[(param1 - 1)].bitmapData));
        }
        public function set glow(param1:Boolean):void
        {
            this.gl.visible = param1;
        }
        public function set rang1(param1:int):void
        {
            this.removeChildren();
            this._rang = param1;
            var premm:Bitmap = new Bitmap(new prem().bitmapData);
            this.addChild(premm);
            premm.alpha = 0;
            var rankToAdd:Bitmap = new Bitmap(this.rangs1[(param1 - 1)].bitmapData);
            this.addChild(rankToAdd);
            rankToAdd.x = 10;
            rankToAdd.y = 5;
        }
        public function set premiumR(param1:int):void
        {
            this.removeChildren();
            this._rang = param1;
            this.addChild(new Bitmap(new prem().bitmapData));
            var rankToAdd:Bitmap = new Bitmap(this.rangs1[(param1 - 1)].bitmapData);
            this.addChild(rankToAdd);
            rankToAdd.x = 10;
            rankToAdd.y = 5;
        }
        private function frame1():void
        {
            stop();
        }

    }
}
