package com.lorentz.SVG.data.path
{
    public class SVGArcToCommand extends SVGPathCommand
    {

        public var rx:Number = 0;
        public var ry:Number = 0;
        public var xAxisRotation:Number = 0;
        public var largeArc:Boolean = false;
        public var sweep:Boolean = false;
        public var x:Number = 0;
        public var y:Number = 0;
        public var absolute:Boolean = false;

        public function SVGArcToCommand(absolute:Boolean = false, rx:Number = 0, ry:Number = 0, xAxisRotation:Number = 0, largeArc:Boolean = false, sweep:Boolean = false, x:Number = 0, y:Number = 0)
        {
            this.absolute = absolute;
            this.rx = rx;
            this.ry = ry;
            this.xAxisRotation = xAxisRotation;
            this.largeArc = largeArc;
            this.sweep = sweep;
            this.x = x;
            this.y = y;
        }
        override public function get type():String
        {
            return ((this.absolute) ? "A" : "a");
        }
        override public function clone():Object
        {
            var copy:SVGArcToCommand = new SVGArcToCommand(this.absolute);
            copy.rx = this.rx;
            copy.ry = this.ry;
            copy.xAxisRotation = this.xAxisRotation;
            copy.largeArc = this.largeArc;
            copy.sweep = this.sweep;
            copy.x = this.x;
            copy.y = this.y;
            return (copy);
        }

    }
}
