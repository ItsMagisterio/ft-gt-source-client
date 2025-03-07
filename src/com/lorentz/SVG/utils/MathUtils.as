﻿package com.lorentz.SVG.utils
{
    import flash.geom.Point;

    public final class MathUtils
    {

        public static function intersect2Lines(p1:Point, p2:Point, p3:Point, p4:Point):Point
        {
            var x1:Number = p1.x;
            var y1:Number = p1.y;
            var x4:Number = p4.x;
            var y4:Number = p4.y;
            var dx1:Number = (p2.x - x1);
            var dx2:Number = (p3.x - x4);
            if (((!(dx1)) && (!(dx2))))
            {
                return (null);
            }
            var m1:Number = ((p2.y - y1) / dx1);
            var m2:Number = ((p3.y - y4) / dx2);
            if ((!(dx1)))
            {
                return (new Point(x1, ((m2 * (x1 - x4)) + y4)));
            }
            if ((!(dx2)))
            {
                return (new Point(x4, ((m1 * (x4 - x1)) + y1)));
            }
            var xInt:Number = (((((-(m2) * x4) + y4) + (m1 * x1)) - y1) / (m1 - m2));
            var yInt:Number = ((m1 * (xInt - x1)) + y1);
            return (new Point(xInt, yInt));
        }
        public static function midLine(a:Point, b:Point):Point
        {
            return (Point.interpolate(a, b, 0.5));
        }
        public static function bezierSplit(p0:Point, p1:Point, p2:Point, p3:Point):Object
        {
            var m:Function = MathUtils.midLine;
            var p01:Point = m(p0, p1);
            var p12:Point = m(p1, p2);
            var p23:Point = m(p2, p3);
            var p02:Point = m(p01, p12);
            var p13:Point = m(p12, p23);
            var p03:Point = m(p02, p13);
            return ( {
                        "b0": {
                            "a": p0,
                            "b": p01,
                            "c": p02,
                            "d": p03
                        },
                        "b1": {
                            "a": p03,
                            "b": p13,
                            "c": p23,
                            "d": p3
                        }
                    });
        }
        public static function degressToRadius(angle:Number):Number
        {
            return (angle * (Math.PI / 180));
        }
        public static function radiusToDegress(angle:Number):Number
        {
            return (angle * (180 / Math.PI));
        }
        public static function quadCurveSliceUpTo(sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, t:Number):Array
        {
            var midx:Number;
            var midy:Number;
            if (isNaN(t))
            {
                t = 1;
            }
            if (t != 1)
            {
                midx = (cx + ((ex - cx) * t));
                midy = (cy + ((ey - cy) * t));
                cx = (sx + ((cx - sx) * t));
                cy = (sy + ((cy - sy) * t));
                ex = (cx + ((midx - cx) * t));
                ey = (cy + ((midy - cy) * t));
            }
            return ([sx, sy, cx, cy, ex, ey]);
        }
        public static function quadCurveSliceFrom(sx:Number, sy:Number, cx:Number, cy:Number, ex:Number, ey:Number, t:Number):Array
        {
            var midx:Number;
            var midy:Number;
            if (isNaN(t))
            {
                t = 1;
            }
            if (t != 1)
            {
                midx = (sx + ((cx - sx) * t));
                midy = (sy + ((cy - sy) * t));
                cx = (cx + ((ex - cx) * t));
                cy = (cy + ((ey - cy) * t));
                sx = (midx + ((cx - midx) * t));
                sy = (midy + ((cy - midy) * t));
            }
            return ([sx, sy, cx, cy, ex, ey]);
        }

    }
}
