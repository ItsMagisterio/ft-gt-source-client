package com.lorentz.SVG.utils
{
    import flash.geom.Point;

    public final class Bezier
    {

        public static var tolerance:Number = 1;
        public static var savedBeziers:Object = new Object();

        public var p1:Point = null;
        public var p2:Point = null;
        public var c1:Point = null;
        public var c2:Point = null;
        public var QPts:Array = null;

        public function Bezier(p1Anchor:Point, c1Control:Point, c2Control:Point, p2Anchor:Point):void
        {
            this.p1 = p1Anchor;
            this.p2 = p2Anchor;
            this.c1 = c1Control;
            this.c2 = c2Control;
            this.QPts = new Array();
            this.getQuadBezier(this.p1, this.c1, this.c2, this.p2);
        }
        private function getQuadBezier(p1Anchor:Point, c1Control:Point, c2Control:Point, p2Anchor:Point):void
        {
            if (tolerance == 0)
            {
                this.GetQuadBez_TG(p1Anchor, c1Control, c2Control, p2Anchor);
            }
            else
            {
                this.GetQuadBez_RP(p1Anchor, c1Control, c2Control, p2Anchor);
            }
        }
        private function GetQuadBez_TG(P0:Point, P1:Point, P2:Point, P3:Point):void
        {
            var PA:Point = Point.interpolate(P0, P1, (3 / 4));
            var PB:Point = Point.interpolate(P3, P2, (3 / 4));
            var dx:Number = ((P3.x - P0.x) / 16);
            var dy:Number = ((P3.y - P0.y) / 16);
            var Pc_1:Point = Point.interpolate(P0, P1, (3 / 8));
            var Pc_2:Point = Point.interpolate(PA, PB, (3 / 8));
            Pc_2.x = (Pc_2.x - dx);
            Pc_2.y = (Pc_2.y - dy);
            var Pc_3:Point = Point.interpolate(PB, PA, (3 / 8));
            Pc_3.x = (Pc_3.x + dx);
            Pc_3.y = (Pc_3.y + dy);
            var Pc_4:Point = Point.interpolate(P3, P2, (3 / 8));
            var Pa_1:Point = Point.interpolate(Pc_1, Pc_2, 0.5);
            var Pa_2:Point = Point.interpolate(PA, PB, 0.5);
            var Pa_3:Point = Point.interpolate(Pc_3, Pc_4, 0.5);
            this.QPts = [ {
                        "s": P0,
                        "p": Pa_1,
                        "c": Pc_1
                    }, {
                        "s": Pa_1,
                        "p": Pa_2,
                        "c": Pc_2
                    }, {
                        "s": Pa_2,
                        "p": Pa_3,
                        "c": Pc_3
                    }, {
                        "s": Pa_3,
                        "p": P3,
                        "c": Pc_4
                    }];
        }
        private function GetQuadBez_RP(a:Point, b:Point, c:Point, d:Point):void
        {
            var dx:Number;
            var dy:Number;
            var mp:Point;
            var s:Point = MathUtils.intersect2Lines(a, b, c, d);
            if (((((s) && (!(isNaN(s.x)))) && (!(isNaN(s.y)))) && (!(s.length == Infinity))))
            {
                dx = ((((a.x + d.x) + (s.x * 4)) - ((b.x + c.x) * 3)) * 0.125);
                dy = ((((a.y + d.y) + (s.y * 4)) - ((b.y + c.y) * 3)) * 0.125);
                if (((dx * dx) + (dy * dy)) <= (tolerance * tolerance))
                {
                    this.QPts.push( {
                                "s": a,
                                "p": d,
                                "c": s
                            });
                    return;
                }
            }
            else
            {
                mp = Point.interpolate(a, d, 0.5);
                if (Point.distance(a, mp) <= tolerance)
                {
                    this.QPts.push( {
                                "s": a,
                                "p": d,
                                "c": mp
                            });
                    return;
                }
            }
            var halves:Object = MathUtils.bezierSplit(a, b, c, d);
            var b0:Object = halves.b0;
            var b1:Object = halves.b1;
            this.GetQuadBez_RP(a, b0.b, b0.c, b0.d);
            this.GetQuadBez_RP(b1.a, b1.b, b1.c, d);
        }

    }
}
