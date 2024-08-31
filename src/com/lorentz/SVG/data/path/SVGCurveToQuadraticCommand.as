package com.lorentz.SVG.data.path
{
    public class SVGCurveToQuadraticCommand extends SVGPathCommand
    {

        public var x1:Number = 0;
        public var y1:Number = 0;
        public var x:Number = 0;
        public var y:Number = 0;
        public var absolute:Boolean = false;

        public function SVGCurveToQuadraticCommand(absolute:Boolean, x1:Number = 0, y1:Number = 0, x:Number = 0, y:Number = 0)
        {
            this.absolute = absolute;
            this.x1 = x1;
            this.y1 = y1;
            this.x = x;
            this.y = y;
        }
        override public function get type():String
        {
            return ((this.absolute) ? "Q" : "q");
        }
        override public function clone():Object
        {
            var copy:SVGCurveToQuadraticCommand = new SVGCurveToQuadraticCommand(this.absolute);
            copy.x1 = this.x1;
            copy.y1 = this.y1;
            copy.x = this.x;
            copy.y = this.y;
            return (copy);
        }

    }
}
