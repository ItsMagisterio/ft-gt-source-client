package com.lorentz.SVG.utils
{
    import flash.geom.Point;

    public class ArcUtils
    {

        public static function computeSvgArc(rx:Number, ry:Number, angle:Number, largeArcFlag:Boolean, sweepFlag:Boolean, x:Number, y:Number, LastPointX:Number, LastPointY:Number):Object
        {
            var p:Number;
            var n:Number;
            var xAxisRotation:Number = angle;
            var dx2:Number = ((LastPointX - x) / 2);
            var dy2:Number = ((LastPointY - y) / 2);
            angle = MathUtils.degressToRadius(angle);
            var cosAngle:Number = Math.cos(angle);
            var sinAngle:Number = Math.sin(angle);
            var x1:Number = ((cosAngle * dx2) + (sinAngle * dy2));
            var y1:Number = ((-(sinAngle) * dx2) + (cosAngle * dy2));
            rx = Math.abs(rx);
            ry = Math.abs(ry);
            var Prx:Number = (rx * rx);
            var Pry:Number = (ry * ry);
            var Px1:Number = (x1 * x1);
            var Py1:Number = (y1 * y1);
            var radiiCheck:Number = ((Px1 / Prx) + (Py1 / Pry));
            if (radiiCheck > 1)
            {
                rx = (Math.sqrt(radiiCheck) * rx);
                ry = (Math.sqrt(radiiCheck) * ry);
                Prx = (rx * rx);
                Pry = (ry * ry);
            }
            var sign:Number = ((largeArcFlag == sweepFlag) ? -1 : 1);
            var sq:Number = ((((Prx * Pry) - (Prx * Py1)) - (Pry * Px1)) / ((Prx * Py1) + (Pry * Px1)));
            sq = ((sq < 0) ? 0 : sq);
            var coef:Number = (sign * Math.sqrt(sq));
            var cx1:Number = (coef * ((rx * y1) / ry));
            var cy1:Number = (coef * -((ry * x1) / rx));
            var sx2:Number = ((LastPointX + x) / 2);
            var sy2:Number = ((LastPointY + y) / 2);
            var cx:Number = (sx2 + ((cosAngle * cx1) - (sinAngle * cy1)));
            var cy:Number = (sy2 + ((sinAngle * cx1) + (cosAngle * cy1)));
            var ux:Number = ((x1 - cx1) / rx);
            var uy:Number = ((y1 - cy1) / ry);
            var vx:Number = ((-(x1) - cx1) / rx);
            var vy:Number = ((-(y1) - cy1) / ry);
            n = Math.sqrt(((ux * ux) + (uy * uy)));
            p = ux;
            sign = ((uy < 0) ? -1 : 1);
            var angleStart:Number = MathUtils.radiusToDegress((sign * Math.acos((p / n))));
            n = Math.sqrt((((ux * ux) + (uy * uy)) * ((vx * vx) + (vy * vy))));
            p = ((ux * vx) + (uy * vy));
            sign = ((((ux * vy) - (uy * vx)) < 0) ? -1 : 1);
            var angleExtent:Number = MathUtils.radiusToDegress((sign * Math.acos((p / n))));
            if (((!(sweepFlag)) && (angleExtent > 0)))
            {
                angleExtent = (angleExtent - 360);
            }
            else
            {
                if (((sweepFlag) && (angleExtent < 0)))
                {
                    angleExtent = (angleExtent + 360);
                }
            }
            angleExtent = (angleExtent % 360);
            angleStart = (angleStart % 360);
            return (Object( {
                            "x": LastPointX,
                            "y": LastPointY,
                            "startAngle": angleStart,
                            "arc": angleExtent,
                            "radius": rx,
                            "yRadius": ry,
                            "xAxisRotation": xAxisRotation,
                            "cx": cx,
                            "cy": cy
                        }));
        }
        public static function convertToCurves(x:Number, y:Number, startAngle:Number, arcAngle:Number, xRadius:Number, yRadius:Number, xAxisRotation:Number = 0):Array
        {
            var beta:Number;
            var sinbeta:Number;
            var cosbeta:Number;
            var cx:Number;
            var cy:Number;
            var x1:Number;
            var y1:Number;
            var i:int;
            var sinangle:Number;
            var cosangle:Number;
            var div:Number;
            var curves:Array = [];
            if (Math.abs(arcAngle) > 360)
            {
                arcAngle = 360;
            }
            var segs:Number = Math.ceil((Math.abs(arcAngle) / 45));
            var segAngle:Number = (arcAngle / segs);
            var theta:Number = MathUtils.degressToRadius(segAngle);
            var angle:Number = MathUtils.degressToRadius(startAngle);
            if (segs > 0)
            {
                beta = MathUtils.degressToRadius(xAxisRotation);
                sinbeta = Math.sin(beta);
                cosbeta = Math.cos(beta);
                i = 0;
                while (i < segs)
                {
                    angle = (angle + theta);
                    sinangle = Math.sin((angle - (theta / 2)));
                    cosangle = Math.cos((angle - (theta / 2)));
                    div = Math.cos((theta / 2));
                    cx = (x + ((((xRadius * cosangle) * cosbeta) - ((yRadius * sinangle) * sinbeta)) / div));
                    cy = (y + ((((xRadius * cosangle) * sinbeta) + ((yRadius * sinangle) * cosbeta)) / div));
                    sinangle = Math.sin(angle);
                    cosangle = Math.cos(angle);
                    x1 = (x + (((xRadius * cosangle) * cosbeta) - ((yRadius * sinangle) * sinbeta)));
                    y1 = (y + (((xRadius * cosangle) * sinbeta) + ((yRadius * sinangle) * cosbeta)));
                    curves.push( {
                                "s": new Point(x, y),
                                "c": new Point(cx, cy),
                                "p": new Point(x1, y1)
                            });
                    i++;
                }
            }
            return (curves);
        }

    }
}
