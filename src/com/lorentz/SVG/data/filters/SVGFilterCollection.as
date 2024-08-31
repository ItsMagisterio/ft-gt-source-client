package com.lorentz.SVG.data.filters
{
    import com.lorentz.SVG.utils.ICloneable;
    import __AS3__.vec.Vector;
    import flash.filters.BitmapFilter;
    import __AS3__.vec.*;

    public class SVGFilterCollection implements ICloneable
    {

        public var svgFilters:Vector.<ISVGFilter> = new Vector.<ISVGFilter>();

        public function getFlashFilters():Array
        {
            var svgFilter:ISVGFilter;
            var flashFilter:BitmapFilter;
            var flashFilters:Array = [];
            for each (svgFilter in this.svgFilters)
            {
                flashFilter = svgFilter.getFlashFilter();
                if (flashFilter)
                {
                    flashFilters.push(flashFilter);
                }
            }
            return (flashFilters);
        }
        public function clone():Object
        {
            var c:SVGFilterCollection = new SVGFilterCollection();
            var i:int;
            while (i < this.svgFilters.length)
            {
                c.svgFilters.push(this.svgFilters[i].clone());
                i++;
            }
            return (c);
        }

    }
}
