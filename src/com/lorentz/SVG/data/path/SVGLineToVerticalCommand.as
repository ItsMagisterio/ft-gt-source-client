package com.lorentz.SVG.data.path
{
    public class SVGLineToVerticalCommand extends SVGPathCommand
    {

        public var y:Number = 0;
        public var absolute:Boolean = false;

        public function SVGLineToVerticalCommand(absolute:Boolean, y:Number = 0)
        {
            this.absolute = absolute;
            this.y = y;
        }
        override public function get type():String
        {
            return ((this.absolute) ? "V" : "v");
        }
        override public function clone():Object
        {
            var copy:SVGLineToVerticalCommand = new SVGLineToVerticalCommand(this.absolute);
            copy.y = this.y;
            return (copy);
        }

    }
}
