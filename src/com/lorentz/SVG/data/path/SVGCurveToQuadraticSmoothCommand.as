package com.lorentz.SVG.data.path
{
    public class SVGCurveToQuadraticSmoothCommand extends SVGPathCommand
    {

        public var x:Number = 0;
        public var y:Number = 0;
        public var absolute:Boolean = false;

        public function SVGCurveToQuadraticSmoothCommand(absolute:Boolean, x:Number = 0, y:Number = 0)
        {
            this.absolute = absolute;
            this.x = x;
            this.y = y;
        }
        override public function get type():String
        {
            return ((this.absolute) ? "T" : "t");
        }
        override public function clone():Object
        {
            var copy:SVGCurveToQuadraticSmoothCommand = new SVGCurveToQuadraticSmoothCommand(this.absolute);
            copy.x = this.x;
            copy.y = this.y;
            return (copy);
        }

    }
}
