package com.lorentz.SVG.data.gradients
{
    import com.lorentz.SVG.utils.ICloneable;
    import flash.geom.Matrix;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    public class SVGGradient implements ICloneable
    {

        private var _type:String;
        public var gradientUnits:String;
        public var transform:Matrix;
        public var spreadMethod:String;
        public var colors:Array;
        public var alphas:Array;
        public var ratios:Array;

        public function SVGGradient(_arg_1:String)
        {
            this._type = _arg_1;
        }
        public function get type():String
        {
            return (this._type);
        }
        public function clone():Object
        {
            var clazz:Class = (getDefinitionByName(getQualifiedClassName(this)) as Class);
            var copy:SVGGradient = new (clazz)();
            this.copyTo(copy);
            return (copy);
        }
        public function copyTo(target:SVGGradient):void
        {
            target.gradientUnits = this.gradientUnits;
            target.transform = ((this.transform == null) ? null : this.transform.clone());
            target.spreadMethod = this.spreadMethod;
            target.colors = ((this.colors == null) ? null : this.colors.slice());
            target.alphas = ((this.alphas == null) ? null : this.alphas.slice());
            target.ratios = ((this.ratios == null) ? null : this.ratios.slice());
        }

    }
}
