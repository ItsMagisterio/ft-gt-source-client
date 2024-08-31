package com.lorentz.SVG.drawing
{
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import com.lorentz.SVG.data.path.SVGPathCommand;
    import com.lorentz.SVG.data.path.SVGMoveToCommand;
    import com.lorentz.SVG.data.path.SVGLineToCommand;
    import com.lorentz.SVG.data.path.SVGLineToHorizontalCommand;
    import com.lorentz.SVG.data.path.SVGLineToVerticalCommand;
    import com.lorentz.SVG.data.path.SVGCurveToQuadraticCommand;
    import com.lorentz.SVG.data.path.SVGCurveToQuadraticSmoothCommand;
    import com.lorentz.SVG.data.path.SVGCurveToCubicCommand;
    import com.lorentz.SVG.data.path.SVGCurveToCubicSmoothCommand;
    import com.lorentz.SVG.data.path.SVGArcToCommand;

    public class SVGPathRenderer
    {

        private var firstPoint:Point;
        private var lastControlPoint:Point;
        private var commands:Vector.<SVGPathCommand>;
        private var _drawer:IDrawer;

        public function SVGPathRenderer(commands:Vector.<SVGPathCommand>)
        {
            this.commands = commands;
        }
        public function render(drawer:IDrawer):void
        {
            var pathCommand:SVGPathCommand;
            this._drawer = drawer;
            if (((!(this._drawer.penX == 0)) || (!(this._drawer.penY == 0))))
            {
                this._drawer.moveTo(0, 0);
            }
            for each (pathCommand in this.commands)
            {
                switch (pathCommand.type)
                {
                    case "M":
                    case "m":
                        this.moveTo((pathCommand as SVGMoveToCommand));
                        break;
                    case "L":
                    case "l":
                        this.lineTo((pathCommand as SVGLineToCommand));
                        break;
                    case "H":
                    case "h":
                        this.lineToHorizontal((pathCommand as SVGLineToHorizontalCommand));
                        break;
                    case "V":
                    case "v":
                        this.lineToVertical((pathCommand as SVGLineToVerticalCommand));
                        break;
                    case "Q":
                    case "q":
                        this.curveToQuadratic((pathCommand as SVGCurveToQuadraticCommand));
                        break;
                    case "T":
                    case "t":
                        this.curveToQuadraticSmooth((pathCommand as SVGCurveToQuadraticSmoothCommand));
                        break;
                    case "C":
                    case "c":
                        this.curveToCubic((pathCommand as SVGCurveToCubicCommand));
                        break;
                    case "S":
                    case "s":
                        this.curveToCubicSmooth((pathCommand as SVGCurveToCubicSmoothCommand));
                        break;
                    case "A":
                    case "a":
                        this.arcTo((pathCommand as SVGArcToCommand));
                        break;
                    case "Z":
                    case "z":
                        this.closePath();
                        break;
                }
            }
        }
        private function closePath():void
        {
            this._drawer.lineTo(this.firstPoint.x, this.firstPoint.y);
        }
        private function moveTo(command:SVGMoveToCommand):void
        {
            var x:Number = command.x;
            var y:Number = command.y;
            if ((!(command.absolute)))
            {
                x = (x + this._drawer.penX);
                y = (y + this._drawer.penY);
            }
            this._drawer.moveTo(x, y);
            this.firstPoint = new Point(x, y);
        }
        private function lineTo(command:SVGLineToCommand):void
        {
            var x:Number = command.x;
            var y:Number = command.y;
            if ((!(command.absolute)))
            {
                x = (x + this._drawer.penX);
                y = (y + this._drawer.penY);
            }
            this._drawer.lineTo(x, y);
        }
        private function lineToHorizontal(command:SVGLineToHorizontalCommand):void
        {
            var x:Number = command.x;
            if ((!(command.absolute)))
            {
                x = (x + this._drawer.penX);
            }
            this._drawer.lineTo(x, this._drawer.penY);
        }
        private function lineToVertical(command:SVGLineToVerticalCommand):void
        {
            var y:Number = command.y;
            if ((!(command.absolute)))
            {
                y = (y + this._drawer.penY);
            }
            this._drawer.lineTo(this._drawer.penX, y);
        }
        private function curveToQuadratic(command:SVGCurveToQuadraticCommand):void
        {
            var x1:Number = command.x1;
            var y1:Number = command.y1;
            var x:Number = command.x;
            var y:Number = command.y;
            if ((!(command.absolute)))
            {
                x1 = (x1 + this._drawer.penX);
                y1 = (y1 + this._drawer.penY);
                x = (x + this._drawer.penX);
                y = (y + this._drawer.penY);
            }
            this._drawer.curveTo(x1, y1, x, y);
            this.lastControlPoint = new Point(x1, y1);
        }
        private function curveToQuadraticSmooth(command:SVGCurveToQuadraticSmoothCommand):void
        {
            if ((!(this.lastControlPoint)))
            {
                this.lastControlPoint = new Point(this._drawer.penX, this._drawer.penY);
            }
            var x1:Number = (this._drawer.penX + (this._drawer.penX - this.lastControlPoint.x));
            var y1:Number = (this._drawer.penY + (this._drawer.penY - this.lastControlPoint.y));
            var x:Number = command.x;
            var y:Number = command.y;
            if ((!(command.absolute)))
            {
                x = (x + this._drawer.penX);
                y = (y + this._drawer.penY);
            }
            this._drawer.curveTo(x1, y1, x, y);
            this.lastControlPoint = new Point(x1, y1);
        }
        private function curveToCubic(command:SVGCurveToCubicCommand):void
        {
            var x1:Number = command.x1;
            var y1:Number = command.y1;
            var x2:Number = command.x2;
            var y2:Number = command.y2;
            var x:Number = command.x;
            var y:Number = command.y;
            if ((!(command.absolute)))
            {
                x1 = (x1 + this._drawer.penX);
                y1 = (y1 + this._drawer.penY);
                x2 = (x2 + this._drawer.penX);
                y2 = (y2 + this._drawer.penY);
                x = (x + this._drawer.penX);
                y = (y + this._drawer.penY);
            }
            this._drawer.cubicCurveTo(x1, y1, x2, y2, x, y);
            this.lastControlPoint = new Point(x2, y2);
        }
        private function curveToCubicSmooth(command:SVGCurveToCubicSmoothCommand):void
        {
            if ((!(this.lastControlPoint)))
            {
                this.lastControlPoint = new Point(this._drawer.penX, this._drawer.penY);
            }
            var x1:Number = (this._drawer.penX + (this._drawer.penX - this.lastControlPoint.x));
            var y1:Number = (this._drawer.penY + (this._drawer.penY - this.lastControlPoint.y));
            var x2:Number = command.x2;
            var y2:Number = command.y2;
            var x:Number = command.x;
            var y:Number = command.y;
            if ((!(command.absolute)))
            {
                x2 = (x2 + this._drawer.penX);
                y2 = (y2 + this._drawer.penY);
                x = (x + this._drawer.penX);
                y = (y + this._drawer.penY);
            }
            this._drawer.cubicCurveTo(x1, y1, x2, y2, x, y);
            this.lastControlPoint = new Point(x2, y2);
        }
        private function arcTo(command:SVGArcToCommand):void
        {
            var x:Number = command.x;
            var y:Number = command.y;
            if ((!(command.absolute)))
            {
                x = (x + this._drawer.penX);
                y = (y + this._drawer.penY);
            }
            this._drawer.arcTo(command.rx, command.ry, command.xAxisRotation, command.largeArc, command.sweep, x, y);
        }

    }
}
