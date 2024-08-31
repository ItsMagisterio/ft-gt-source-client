package com.lorentz.SVG.data.gradients
{
    import flash.display.GradientType;

    public class SVGLinearGradient extends SVGGradient
    {

        public var x1:String;
        public var y1:String;
        public var x2:String;
        public var y2:String;

        public function SVGLinearGradient()
        {
            super(GradientType.LINEAR);
        }
        override public function copyTo(target:SVGGradient):void
        {
            super.copyTo(target);
            var targetLinearGradient:SVGLinearGradient = (target as SVGLinearGradient);
            if (targetLinearGradient)
            {
                targetLinearGradient.x1 = this.x1;
                targetLinearGradient.y1 = this.y1;
                targetLinearGradient.x2 = this.x2;
                targetLinearGradient.y2 = this.y2;
            }
        }

    }
}
