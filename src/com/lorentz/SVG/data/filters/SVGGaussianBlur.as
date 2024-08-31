package com.lorentz.SVG.data.filters
{
    import flash.filters.BlurFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BitmapFilter;

    public class SVGGaussianBlur implements ISVGFilter
    {

        public var stdDeviationX:Number = 0;
        public var stdDeviationY:Number = 0;

        public function getFlashFilter():BitmapFilter
        {
            return (new BlurFilter((this.stdDeviationX * 2), (this.stdDeviationY * 2), BitmapFilterQuality.HIGH));
        }
        public function clone():Object
        {
            var c:SVGGaussianBlur = new SVGGaussianBlur();
            c.stdDeviationX = this.stdDeviationX;
            c.stdDeviationY = this.stdDeviationY;
            return (c);
        }

    }
}
