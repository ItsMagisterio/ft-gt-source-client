package com.lorentz.SVG.data.gradients
{
    import flash.display.GradientType;

    public class SVGRadialGradient extends SVGGradient
    {

        public var cx:String;
        public var cy:String;
        public var r:String;
        public var fx:String;
        public var fy:String;

        public function SVGRadialGradient()
        {
            super(GradientType.RADIAL);
        }
        override public function copyTo(target:SVGGradient):void
        {
            super.copyTo(target);
            var targetRadialGradient:SVGRadialGradient = (target as SVGRadialGradient);
            if (targetRadialGradient)
            {
                targetRadialGradient.cx = this.cx;
                targetRadialGradient.cy = this.cy;
                targetRadialGradient.r = this.r;
                targetRadialGradient.fx = this.fx;
                targetRadialGradient.fy = this.fy;
            }
        }

    }
}
