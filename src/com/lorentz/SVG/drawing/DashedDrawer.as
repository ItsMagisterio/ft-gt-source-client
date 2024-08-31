package com.lorentz.SVG.drawing
{
    import com.lorentz.SVG.utils.MathUtils;
    import com.lorentz.SVG.utils.Bezier;
    import flash.geom.Point;
    import com.lorentz.SVG.utils.ArcUtils;

    public class DashedDrawer implements IDrawer
    {

        private var _baseDrawer:IDrawer;
        private var _dashArray:Array = [10, 10];
        private var _dashOffset:Number = 0;
        private var _totalLength:Number = 20;
        private var _alignToCorners:Boolean = false;
        private var _curveAccuracy:Number = 6;
        private var isLine:Boolean = true;
        private var _dashIndex:uint = 0;
        private var _dashDrawnLength:Number = 0;
        private var _scaleToAlign:Number = 1;
        private var _isAligned:Boolean = false;

        public function DashedDrawer(baseDrawer:IDrawer)
        {
            this._baseDrawer = baseDrawer;
            this.initDash(this._dashOffset);
        }
        public function get penX():Number
        {
            return (this._baseDrawer.penX);
        }
        public function get penY():Number
        {
            return (this._baseDrawer.penY);
        }
        public function get dashArray():Array
        {
            return (this._dashArray);
        }
        public function set dashArray(value:Array):void
        {
            var v:Number;
            var i:uint;
            while (i < value.length)
            {
                if (((isNaN((value[i] = Number(value[i])))) || (value[i] < 0)))
                {
                    return;
                }
                i++;
            }
            if ((value.length & 0x01))
            {
                value = value.concat(value);
            }
            this._totalLength = 0;
            for each (v in value)
            {
                this._totalLength = (this._totalLength + v);
            }
            this._dashArray = value;
            this.initDash(this._dashOffset);
        }
        public function get dashOffset():Number
        {
            return (this._dashOffset);
        }
        public function set dashOffset(value:Number):void
        {
            this._dashOffset = value;
            this.initDash(this._dashOffset);
        }
        public function get alignToCorners():Boolean
        {
            return (this._alignToCorners);
        }
        public function set alignToCorners(value:Boolean):void
        {
            this._alignToCorners = value;
        }
        private function initDash(offset:Number):void
        {
            var i:uint;
            var v:Number;
            this.isLine = true;
            this._dashIndex = 0;
            this._dashDrawnLength = 0;
            offset = (offset % this._totalLength);
            if (offset < 0)
            {
                offset = (this._totalLength - offset);
            }
            while (offset > 0)
            {
                v = Math.min(offset, this._dashArray[this._dashIndex]);
                offset = (offset - v);
                this.moveInDashArray(v);
            }
        }
        private function getDashLength():Number
        {
            if (this._isAligned)
            {
                return (this._dashArray[this._dashIndex] * this._scaleToAlign);
            }
            return (this._dashArray[this._dashIndex]);
        }
        private function moveInDashArray(length:Number):void
        {
            this._dashDrawnLength = (this._dashDrawnLength + length);
            if (this._dashDrawnLength >= this.getDashLength())
            {
                this.isLine = (!(this.isLine));
                this._dashIndex++;
                if (this._dashIndex > (this.dashArray.length - 1))
                {
                    this._dashIndex = 0;
                }
                this._dashDrawnLength = 0;
            }
        }
        private function initDashAlign(length:Number):void
        {
            var startTrim:Number = (this._dashArray[0] / 2);
            var endTrim:Number = (this._dashArray[(this._dashArray.length - 1)] + (this._dashArray[(this._dashArray.length - 2)] / 2));
            length = (length + (startTrim + endTrim));
            var numDashArrayRepeats:int = int(Math.round((length / this._totalLength)));
            var dashesLength:Number = (this._totalLength * numDashArrayRepeats);
            this._scaleToAlign = (length / dashesLength);
            this.initDash(startTrim);
            this._isAligned = true;
        }
        private function endDashAlign():void
        {
            this._isAligned = false;
            this._scaleToAlign = 1;
        }
        public function moveTo(x:Number, y:Number):void
        {
            this._baseDrawer.moveTo(x, y);
        }
        public function lineTo(x:Number, y:Number):void
        {
            var dx:Number;
            var dy:Number;
            var lineLength:Number;
            var lengthToDraw:Number;
            var newX:Number;
            var newY:Number;
            var lineAngle:Number;
            if (((this._alignToCorners) && (!(this._isAligned))))
            {
                this.initDashAlign(this.lineLength((x - this.penX), (y - this.penY)));
                this.lineTo(x, y);
                this.endDashAlign();
                return;
            }
            do
            {
                dx = (x - this.penX);
                dy = (y - this.penY);
                lineLength = this.lineLength(dx, dy);
                lengthToDraw = Math.min(lineLength, (this.getDashLength() - this._dashDrawnLength));
                if (lengthToDraw < lineLength)
                {
                    lineAngle = Math.atan2(dy, dx);
                    newX = ((Math.cos(lineAngle) * lengthToDraw) + this.penX);
                    newY = ((Math.sin(lineAngle) * lengthToDraw) + this.penY);
                }
                else
                {
                    newX = x;
                    newY = y;
                }
                if (this.isLine)
                {
                    this._baseDrawer.lineTo(newX, newY);
                }
                else
                {
                    this._baseDrawer.moveTo(newX, newY);
                }
                this.moveInDashArray(lengthToDraw);
            }
            while (lengthToDraw < lineLength);
            this._scaleToAlign = 1;
        }
        public function curveTo(cx:Number, cy:Number, x:Number, y:Number):void
        {
            var curveLength:Number;
            var lengthToDraw:Number;
            var newCX:Number;
            var newCY:Number;
            var newX:Number;
            var newY:Number;
            var splitCurveFactor:Number;
            var curveToDraw:Array;
            var otherCurve:Array;
            if (((this._alignToCorners) && (!(this._isAligned))))
            {
                this.initDashAlign(this.curveLength(this.penX, this.penY, cx, cy, x, y, this._curveAccuracy));
                this.curveTo(cx, cy, x, y);
                this.endDashAlign();
                return;
            }
            do
            {
                curveLength = this.curveLength(this.penX, this.penY, cx, cy, x, y, this._curveAccuracy);
                lengthToDraw = Math.min(curveLength, (this.getDashLength() - this._dashDrawnLength));
                if (lengthToDraw < curveLength)
                {
                    splitCurveFactor = (lengthToDraw / curveLength);
                    curveToDraw = MathUtils.quadCurveSliceUpTo(this.penX, this.penY, cx, cy, x, y, splitCurveFactor);
                    newCX = curveToDraw[2];
                    newCY = curveToDraw[3];
                    newX = curveToDraw[4];
                    newY = curveToDraw[5];
                    otherCurve = MathUtils.quadCurveSliceFrom(this.penX, this.penY, cx, cy, x, y, splitCurveFactor);
                    cx = otherCurve[2];
                    cy = otherCurve[3];
                }
                else
                {
                    newCX = cx;
                    newCY = cy;
                    newX = x;
                    newY = y;
                }
                if (this.isLine)
                {
                    this._baseDrawer.curveTo(newCX, newCY, newX, newY);
                }
                else
                {
                    this._baseDrawer.moveTo(newX, newY);
                }
                this.moveInDashArray(lengthToDraw);
            }
            while (lengthToDraw < curveLength);
        }
        public function cubicCurveTo(cx1:Number, cy1:Number, cx2:Number, cy2:Number, x:Number, y:Number):void
        {
            var quadP:Object;
            if (((this._alignToCorners) && (!(this._isAligned))))
            {
                this.initDashAlign(this.cubicCurveLength(this.penX, this.penY, cx1, cy1, cx2, cy2, x, y, this._curveAccuracy));
                this.cubicCurveTo(cx1, cy1, cx2, cy2, x, y);
                this.endDashAlign();
                return;
            }
            var bezier:Bezier = new Bezier(new Point(this.penX, this.penY), new Point(cx1, cy1), new Point(cx2, cy2), new Point(x, y));
            for each (quadP in bezier.QPts)
            {
                this.curveTo(quadP.c.x, quadP.c.y, quadP.p.x, quadP.p.y);
            }
        }
        public function arcTo(rx:Number, ry:Number, angle:Number, largeArcFlag:Boolean, sweepFlag:Boolean, x:Number, y:Number):void
        {
            if (((this._alignToCorners) && (!(this._isAligned))))
            {
                this.initDashAlign(this.arcLength(this.penX, this.penY, rx, ry, angle, largeArcFlag, sweepFlag, x, y, this._curveAccuracy));
                this.arcTo(rx, ry, angle, largeArcFlag, sweepFlag, x, y);
                this.endDashAlign();
                return;
            }
            var ellipticalArc:Object = ArcUtils.computeSvgArc(rx, ry, angle, largeArcFlag, sweepFlag, x, y, this.penX, this.penY);
            var curves:Array = ArcUtils.convertToCurves(ellipticalArc.cx, ellipticalArc.cy, ellipticalArc.startAngle, ellipticalArc.arc, ellipticalArc.radius, ellipticalArc.yRadius, ellipticalArc.xAxisRotation);
            var i:int;
            while (i < curves.length)
            {
                this.curveTo(curves[i].c.x, curves[i].c.y, curves[i].p.x, curves[i].p.y);
                i++;
            }
        }
        private function lineLength(sx:Number, sy:Number, ex:Number = 0, ey:Number = 0):Number
        {
            if (arguments.length == 2)
            {
                return (Math.sqrt(((sx * sx) + (sy * sy))));
            }
            var dx:Number = (ex - sx);
            var dy:Number = (ey - sy);
            return (Math.sqrt(((dx * dx) + (dy * dy))));
        }
        private function curveLength(sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, accuracy:Number):Number
        {
            var px:Number;
            var py:Number;
            var t:Number;
            var it:Number;
            var a:Number;
            var b:Number;
            var c:Number;
            var total:Number = 0;
            var tx:Number = sx;
            var ty:Number = sy;
            var n:Number = ((accuracy) ? accuracy : this._curveAccuracy);
            var i:Number = 1;
            while (i <= n)
            {
                t = (i / n);
                it = (1 - t);
                a = (it * it);
                b = ((2 * t) * it);
                c = (t * t);
                px = (((a * sx) + (b * cx)) + (c * ex));
                py = (((a * sy) + (b * cy)) + (c * ey));
                total = (total + this.lineLength(tx, ty, px, py));
                tx = px;
                ty = py;
                i++;
            }
            return (total);
        }
        private function cubicCurveLength(sx:Number, sy:Number, cx1:Number, cy1:Number, cx2:Number, cy2:Number, x:Number, y:Number, accuracy:Number):Number
        {
            var quadP:Object;
            var bezier:Bezier = new Bezier(new Point(sx, sy), new Point(cx1, cy1), new Point(cx2, cy2), new Point(x, y));
            var length:Number = 0;
            var curX:Number = sx;
            var curY:Number = sy;
            for each (quadP in bezier.QPts)
            {
                length = (length + this.curveLength(curX, curY, quadP.c.x, quadP.c.y, quadP.p.x, quadP.p.y, accuracy));
                curX = quadP.p.x;
                curY = quadP.p.y;
            }
            return (length);
        }
        private function arcLength(sx:Number, sy:Number, rx:Number, ry:Number, angle:Number, largeArcFlag:Boolean, sweepFlag:Boolean, x:Number, y:Number, accuracy:Number):Number
        {
            var ellipticalArc:Object = ArcUtils.computeSvgArc(rx, ry, angle, largeArcFlag, sweepFlag, x, y, sx, sy);
            var curves:Array = ArcUtils.convertToCurves(ellipticalArc.cx, ellipticalArc.cy, ellipticalArc.startAngle, ellipticalArc.arc, ellipticalArc.radius, ellipticalArc.yRadius, ellipticalArc.xAxisRotation);
            var length:Number = 0;
            var curX:Number = sx;
            var curY:Number = sy;
            var i:int;
            while (i < curves.length)
            {
                length = (length + this.curveLength(curX, curY, curves[i].c.x, curves[i].c.y, curves[i].p.x, curves[i].p.y, accuracy));
                curX = curves[i].p.x;
                curY = curves[i].p.y;
                i++;
            }
            return (length);
        }

    }
}
