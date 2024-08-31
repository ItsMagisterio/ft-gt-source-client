package com.lorentz.SVG.data.filters
{
    import flash.filters.ColorMatrixFilter;
    import flash.filters.BitmapFilter;

    public class SVGColorMatrix implements ISVGFilter
    {

        public var type:String;
        public var values:Array;

        public function getFlashFilter():BitmapFilter
        {
            return (new ColorMatrixFilter(this.values));
        }
        public function clone():Object
        {
            var c:SVGColorMatrix = new SVGColorMatrix();
            c.type = this.type;
            c.values = this.values.slice();
            return (c);
        }

    }
}
