﻿package com.lorentz.SVG.data.path
{
    public class SVGCurveToCubicSmoothCommand extends SVGPathCommand
    {

        public var x2:Number = 0;
        public var y2:Number = 0;
        public var x:Number = 0;
        public var y:Number = 0;
        public var absolute:Boolean = false;

        public function SVGCurveToCubicSmoothCommand(absolute:Boolean, x2:Number = 0, y2:Number = 0, x:Number = 0, y:Number = 0)
        {
            this.absolute = absolute;
            this.x2 = x2;
            this.y2 = y2;
            this.x = x;
            this.y = y;
        }
        override public function get type():String
        {
            return ((this.absolute) ? "S" : "s");
        }
        override public function clone():Object
        {
            var copy:SVGCurveToCubicSmoothCommand = new SVGCurveToCubicSmoothCommand(this.absolute);
            copy.x2 = this.x2;
            copy.y2 = this.y2;
            copy.x = this.x;
            copy.y = this.y;
            return (copy);
        }

    }
}
