package com.lorentz.SVG.drawing
{
    import __AS3__.vec.Vector;
    import flash.display.GraphicsPathCommand;
    import flash.geom.Point;
    import com.lorentz.SVG.utils.Bezier;
    import com.lorentz.SVG.utils.FlashPlayerUtils;
    import com.lorentz.SVG.utils.ArcUtils;
    import __AS3__.vec.*;

    public class GraphicsPathDrawer implements IDrawer
    {

        public var commands:Vector.<int>;
        public var pathData:Vector.<Number>;
        private var _penX:Number = 0;
        private var _penY:Number = 0;

        public function GraphicsPathDrawer()
        {
            this.commands = new Vector.<int>();
            this.pathData = new Vector.<Number>();
        }
        public function get penX():Number
        {
            return (this._penX);
        }
        public function get penY():Number
        {
            return (this._penY);
        }
        public function moveTo(x:Number, y:Number):void
        {
            this.commands.push(GraphicsPathCommand.MOVE_TO);
            this.pathData.push(x, y);
            this._penX = x;
            this._penY = y;
        }
        public function lineTo(x:Number, y:Number):void
        {
            this.commands.push(GraphicsPathCommand.LINE_TO);
            this.pathData.push(x, y);
            this._penX = x;
            this._penY = y;
        }
        public function curveTo(cx:Number, cy:Number, x:Number, y:Number):void
        {
            this.commands.push(GraphicsPathCommand.CURVE_TO);
            this.pathData.push(cx, cy, x, y);
            this._penX = x;
            this._penY = y;
        }
        public function cubicCurveTo(cx1:Number, cy1:Number, cx2:Number, cy2:Number, x:Number, y:Number):void
        {
            var anchor1:Point;
            var control1:Point;
            var control2:Point;
            var anchor2:Point;
            var bezier:Bezier;
            var quadP:Object;
            if (FlashPlayerUtils.supportsCubicCurves)
            {
                this.commands.push(GraphicsPathCommand["CUBIC_CURVE_TO"]);
                this.pathData.push(cx1, cy1, cx2, cy2, x, y);
                this._penX = x;
                this._penY = y;
            }
            else
            {
                anchor1 = new Point(this._penX, this._penY);
                control1 = new Point(cx1, cy1);
                control2 = new Point(cx2, cy2);
                anchor2 = new Point(x, y);
                bezier = new Bezier(anchor1, control1, control2, anchor2);
                for each (quadP in bezier.QPts)
                {
                    this.curveTo(quadP.c.x, quadP.c.y, quadP.p.x, quadP.p.y);
                }
            }
        }
        public function arcTo(rx:Number, ry:Number, angle:Number, largeArcFlag:Boolean, sweepFlag:Boolean, x:Number, y:Number):void
        {
            var ellipticalArc:Object = ArcUtils.computeSvgArc(rx, ry, angle, largeArcFlag, sweepFlag, x, y, this._penX, this._penY);
            var curves:Array = ArcUtils.convertToCurves(ellipticalArc.cx, ellipticalArc.cy, ellipticalArc.startAngle, ellipticalArc.arc, ellipticalArc.radius, ellipticalArc.yRadius, ellipticalArc.xAxisRotation);
            var i:int;
            while (i < curves.length)
            {
                this.curveTo(curves[i].c.x, curves[i].c.y, curves[i].p.x, curves[i].p.y);
                i++;
            }
        }

    }
}
