﻿package alternativa.physics.collision.colliders
{
    import alternativa.math.Vector3;
    import __AS3__.vec.Vector;
    import alternativa.physics.ContactPoint;
    import alternativa.physics.collision.primitives.CollisionBox;
    import alternativa.physics.collision.CollisionPrimitive;
    import alternativa.physics.Contact;
    import alternativa.math.Matrix4;
    import __AS3__.vec.*;
    import alternativa.physics.altphysics;
    use namespace altphysics;

    public class BoxBoxCollider extends BoxCollider
    {

        private var epsilon:Number = 0.001;
        private var vectorToBox1:Vector3 = new Vector3();
        private var axis:Vector3 = new Vector3();
        private var axis10:Vector3 = new Vector3();
        private var axis11:Vector3 = new Vector3();
        private var axis12:Vector3 = new Vector3();
        private var axis20:Vector3 = new Vector3();
        private var axis21:Vector3 = new Vector3();
        private var axis22:Vector3 = new Vector3();
        private var bestAxisIndex:int;
        private var minOverlap:Number;
        private var points1:Vector.<Vector3> = new Vector.<Vector3>(8, true);
        private var points2:Vector.<Vector3> = new Vector.<Vector3>(8, true);
        private var tmpPoints:Vector.<ContactPoint> = new Vector.<ContactPoint>(8, true);
        private var pcount:int;

        public function BoxBoxCollider()
        {
            var i:int;
            while (i < 8)
            {
                this.tmpPoints[i] = new ContactPoint();
                this.points1[i] = new Vector3();
                this.points2[i] = new Vector3();
                i++;
            }
        }
        override public function getContact(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean
        {
            var box1:CollisionBox;
            var box2:CollisionBox;
            if ((!(this.haveCollision(prim1, prim2))))
            {
                return (false);
            }
            if (prim1.body != null)
            {
                box1 = (prim1 as CollisionBox);
                box2 = (prim2 as CollisionBox);
            }
            else
            {
                box1 = (prim2 as CollisionBox);
                box2 = (prim1 as CollisionBox);
            }
            if (this.bestAxisIndex < 6)
            {
                if ((!(this.findFaceContactPoints(box1, box2, this.vectorToBox1, this.bestAxisIndex, contact))))
                {
                    return (false);
                }
            }
            else
            {
                this.bestAxisIndex = (this.bestAxisIndex - 6);
                this.findEdgesIntersection(box1, box2, this.vectorToBox1, int((this.bestAxisIndex / 3)), (this.bestAxisIndex % 3), contact);
            }
            contact.body1 = box1.body;
            contact.body2 = box2.body;
            return (true);
        }
        override public function haveCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean
        {
            var box1:CollisionBox;
            var box2:CollisionBox;
            var transform1:Matrix4;
            box1 = null;
            box2 = null;
            transform1 = null;
            var transform2:Matrix4;
            this.minOverlap = 10000000000;
            if (prim1.body != null)
            {
                box1 = (prim1 as CollisionBox);
                box2 = (prim2 as CollisionBox);
            }
            else
            {
                box1 = (prim2 as CollisionBox);
                box2 = (prim1 as CollisionBox);
            }
            transform1 = box1.transform;
            transform2 = box2.transform;
            this.vectorToBox1.x = (transform1.d - transform2.d);
            this.vectorToBox1.y = (transform1.h - transform2.h);
            this.vectorToBox1.z = (transform1.l - transform2.l);
            this.axis10.x = transform1.a;
            this.axis10.y = transform1.e;
            this.axis10.z = transform1.i;
            if ((!(this.testMainAxis(box1, box2, this.axis10, 0, this.vectorToBox1))))
            {
                return (false);
            }
            this.axis11.x = transform1.b;
            this.axis11.y = transform1.f;
            this.axis11.z = transform1.j;
            if ((!(this.testMainAxis(box1, box2, this.axis11, 1, this.vectorToBox1))))
            {
                return (false);
            }
            this.axis12.x = transform1.c;
            this.axis12.y = transform1.g;
            this.axis12.z = transform1.k;
            if ((!(this.testMainAxis(box1, box2, this.axis12, 2, this.vectorToBox1))))
            {
                return (false);
            }
            this.axis20.x = transform2.a;
            this.axis20.y = transform2.e;
            this.axis20.z = transform2.i;
            if ((!(this.testMainAxis(box1, box2, this.axis20, 3, this.vectorToBox1))))
            {
                return (false);
            }
            this.axis21.x = transform2.b;
            this.axis21.y = transform2.f;
            this.axis21.z = transform2.j;
            if ((!(this.testMainAxis(box1, box2, this.axis21, 4, this.vectorToBox1))))
            {
                return (false);
            }
            this.axis22.x = transform2.c;
            this.axis22.y = transform2.g;
            this.axis22.z = transform2.k;
            if ((!(this.testMainAxis(box1, box2, this.axis22, 5, this.vectorToBox1))))
            {
                return (false);
            }
            if ((!(this.testDerivedAxis(box1, box2, this.axis10, this.axis20, 6, this.vectorToBox1))))
            {
                return (false);
            }
            if ((!(this.testDerivedAxis(box1, box2, this.axis10, this.axis21, 7, this.vectorToBox1))))
            {
                return (false);
            }
            if ((!(this.testDerivedAxis(box1, box2, this.axis10, this.axis22, 8, this.vectorToBox1))))
            {
                return (false);
            }
            if ((!(this.testDerivedAxis(box1, box2, this.axis11, this.axis20, 9, this.vectorToBox1))))
            {
                return (false);
            }
            if ((!(this.testDerivedAxis(box1, box2, this.axis11, this.axis21, 10, this.vectorToBox1))))
            {
                return (false);
            }
            if ((!(this.testDerivedAxis(box1, box2, this.axis11, this.axis22, 11, this.vectorToBox1))))
            {
                return (false);
            }
            if ((!(this.testDerivedAxis(box1, box2, this.axis12, this.axis20, 12, this.vectorToBox1))))
            {
                return (false);
            }
            if ((!(this.testDerivedAxis(box1, box2, this.axis12, this.axis21, 13, this.vectorToBox1))))
            {
                return (false);
            }
            if ((!(this.testDerivedAxis(box1, box2, this.axis12, this.axis22, 14, this.vectorToBox1))))
            {
                return (false);
            }
            return (true);
        }
        private function findFaceContactPoints(box1:CollisionBox, box2:CollisionBox, vectorToBox1:Vector3, faceAxisIdx:int, contact:Contact):Boolean
        {
            var pen:Number;
            var cp:ContactPoint;
            var cpPos:Vector3;
            var r:Vector3;
            var transform1:Matrix4;
            var transform2:Matrix4;
            var colAxis:Vector3;
            var incidentAxisDot:Number = NaN;
            pen = NaN;
            var tmpBox:CollisionBox;
            var dot:Number = NaN;
            var absDot:Number = NaN;
            var v:Vector3;
            cp = null;
            cpPos = null;
            r = null;
            var swapNormal:Boolean;
            if (faceAxisIdx > 2)
            {
                tmpBox = box1;
                box1 = box2;
                box2 = tmpBox;
                vectorToBox1.x = -(vectorToBox1.x);
                vectorToBox1.y = -(vectorToBox1.y);
                vectorToBox1.z = -(vectorToBox1.z);
                faceAxisIdx = (faceAxisIdx - 3);
                swapNormal = true;
            }
            transform1 = box1.transform;
            transform2 = box2.transform;
            colAxis = contact.normal;
            transform1.getAxis(faceAxisIdx, colAxis);
            var negativeFace:Boolean = ((((colAxis.x * vectorToBox1.x) + (colAxis.y * vectorToBox1.y)) + (colAxis.z * vectorToBox1.z)) > 0);
            var code:int = (1 << (faceAxisIdx << 1));
            if (negativeFace)
            {
                code = (code << 1);
            }
            if ((code & box1.excludedFaces) != 0)
            {
                return (false);
            }
            if ((!(negativeFace)))
            {
                colAxis.x = -(colAxis.x);
                colAxis.y = -(colAxis.y);
                colAxis.z = -(colAxis.z);
            }
            var incidentAxisIdx:int;
            var maxDot:Number = 0;
            var axisIdx:int;
            while (axisIdx < 3)
            {
                transform2.getAxis(axisIdx, this.axis);
                dot = (((this.axis.x * colAxis.x) + (this.axis.y * colAxis.y)) + (this.axis.z * colAxis.z));
                absDot = ((dot < 0) ? Number(-(dot)) : Number(dot));
                if (absDot > maxDot)
                {
                    maxDot = absDot;
                    incidentAxisDot = dot;
                    incidentAxisIdx = axisIdx;
                }
                axisIdx++;
            }
            transform2.getAxis(incidentAxisIdx, this.axis);
            getFaceVertsByAxis(box2.hs, incidentAxisIdx, (incidentAxisDot < 0), this.points1);
            transform2.transformVectorsN(this.points1, this.points2, 4);
            transform1.transformVectorsInverseN(this.points2, this.points1, 4);
            var pnum:int = this.clip(box1.hs, faceAxisIdx);
            this.pcount = 0;
            var i:int;
            while (i < pnum)
            {
                v = this.points1[i];
                if ((pen = this.getPointBoxPenetration(box1.hs, v, faceAxisIdx, negativeFace)) > -(this.epsilon))
                {
                    cp = this.tmpPoints[this.pcount++ ];
                    cpPos = cp.pos;
                    cpPos.x = ((((transform1.a * v.x) + (transform1.b * v.y)) + (transform1.c * v.z)) + transform1.d);
                    cpPos.y = ((((transform1.e * v.x) + (transform1.f * v.y)) + (transform1.g * v.z)) + transform1.h);
                    cpPos.z = ((((transform1.i * v.x) + (transform1.j * v.y)) + (transform1.k * v.z)) + transform1.l);
                    r = cp.r1;
                    r.x = (cpPos.x - transform1.d);
                    r.y = (cpPos.y - transform1.h);
                    r.z = (cpPos.z - transform1.l);
                    r = cp.r2;
                    r.x = (cpPos.x - transform2.d);
                    r.y = (cpPos.y - transform2.h);
                    r.z = (cpPos.z - transform2.l);
                    cp.penetration = pen;
                }
                i++;
            }
            if (swapNormal)
            {
                colAxis.x = -(colAxis.x);
                colAxis.y = -(colAxis.y);
                colAxis.z = -(colAxis.z);
            }
            if (this.pcount > 4)
            {
                this.reducePoints();
            }
            i = 0;
            while (i < this.pcount)
            {
                cp = contact.points[i];
                cp.copyFrom(this.tmpPoints[i]);
                i++;
            }
            contact.pcount = this.pcount;
            return (true);
        }
        private function reducePoints():void
        {
            var i:int;
            var minIdx:int;
            var cp1:ContactPoint;
            var cp2:ContactPoint;
            var minLen:Number = NaN;
            var p1:Vector3;
            var p2:Vector3;
            var ii:int;
            var dx:Number = NaN;
            var dy:Number = NaN;
            var dz:Number = NaN;
            var len:Number = NaN;
            while (this.pcount > 4)
            {
                minLen = 10000000000;
                p1 = (this.tmpPoints[int((this.pcount - 1))] as ContactPoint).pos;
                i = 0;
                while (i < this.pcount)
                {
                    p2 = (this.tmpPoints[i] as ContactPoint).pos;
                    dx = (p2.x - p1.x);
                    dy = (p2.y - p1.y);
                    dz = (p2.z - p1.z);
                    len = (((dx * dx) + (dy * dy)) + (dz * dz));
                    if (len < minLen)
                    {
                        minLen = len;
                        minIdx = i;
                    }
                    p1 = p2;
                    i++;
                }
                ii = ((minIdx == 0) ? int((this.pcount - 1)) : int((minIdx - 1)));
                cp1 = this.tmpPoints[ii];
                cp2 = this.tmpPoints[minIdx];
                p1 = cp1.pos;
                p2 = cp2.pos;
                p2.x = (0.5 * (p1.x + p2.x));
                p2.y = (0.5 * (p1.y + p2.y));
                p2.z = (0.5 * (p1.z + p2.z));
                cp2.penetration = (0.5 * (cp1.penetration + cp2.penetration));
                if (minIdx > 0)
                {
                    i = minIdx;
                    while (i < this.pcount)
                    {
                        this.tmpPoints[int((i - 1))] = this.tmpPoints[i];
                        i++;
                    }
                    this.tmpPoints[int((this.pcount - 1))] = cp1;
                }
                this.pcount--;
            }
        }
        private function getPointBoxPenetration(hs:Vector3, p:Vector3, faceAxisIdx:int, reverse:Boolean):Number
        {
            switch (faceAxisIdx)
            {
                case 0:
                    if (reverse)
                    {
                        return (p.x + hs.x);
                    }
                    return (hs.x - p.x);
                case 1:
                    if (reverse)
                    {
                        return (p.y + hs.y);
                    }
                    return (hs.y - p.y);
                case 2:
                    if (reverse)
                    {
                        return (p.z + hs.z);
                    }
                    return (hs.z - p.z);
                default:
                    return (0);
            }
        }
        private function clip(hs:Vector3, faceAxisIdx:int):int
        {
            var pnum:int = 4;
            switch (faceAxisIdx)
            {
                case 0:
                    if ((pnum = clipLowZ(-(hs.z), pnum, this.points1, this.points2, this.epsilon)) == 0)
                    {
                        return (0);
                    }
                    if ((pnum = clipHighZ(hs.z, pnum, this.points2, this.points1, this.epsilon)) == 0)
                    {
                        return (0);
                    }
                    if ((pnum = clipLowY(-(hs.y), pnum, this.points1, this.points2, this.epsilon)) == 0)
                    {
                        return (0);
                    }
                    return (clipHighY(hs.y, pnum, this.points2, this.points1, this.epsilon));
                case 1:
                    if ((pnum = clipLowZ(-(hs.z), pnum, this.points1, this.points2, this.epsilon)) == 0)
                    {
                        return (0);
                    }
                    if ((pnum = clipHighZ(hs.z, pnum, this.points2, this.points1, this.epsilon)) == 0)
                    {
                        return (0);
                    }
                    if ((pnum = clipLowX(-(hs.x), pnum, this.points1, this.points2, this.epsilon)) == 0)
                    {
                        return (0);
                    }
                    return (clipHighX(hs.x, pnum, this.points2, this.points1, this.epsilon));
                case 2:
                    if ((pnum = clipLowX(-(hs.x), pnum, this.points1, this.points2, this.epsilon)) == 0)
                    {
                        return (0);
                    }
                    if ((pnum = clipHighX(hs.x, pnum, this.points2, this.points1, this.epsilon)) == 0)
                    {
                        return (0);
                    }
                    if ((pnum = clipLowY(-(hs.y), pnum, this.points1, this.points2, this.epsilon)) == 0)
                    {
                        return (0);
                    }
                    return (clipHighY(hs.y, pnum, this.points2, this.points1, this.epsilon));
                default:
                    return (0);
            }
        }
        private function findEdgesIntersection(box1:CollisionBox, box2:CollisionBox, vectorToBox1:Vector3, axisIdx1:int, axisIdx2:int, contact:Contact):void
        {
            var halfLen1:Number = NaN;
            var halfLen2:Number = NaN;
            var transform1:Matrix4 = box1.transform;
            var transform2:Matrix4 = box2.transform;
            transform1.getAxis(axisIdx1, this.axis10);
            transform2.getAxis(axisIdx2, this.axis20);
            var colAxis:Vector3 = contact.normal;
            colAxis.x = ((this.axis10.y * this.axis20.z) - (this.axis10.z * this.axis20.y));
            colAxis.y = ((this.axis10.z * this.axis20.x) - (this.axis10.x * this.axis20.z));
            colAxis.z = ((this.axis10.x * this.axis20.y) - (this.axis10.y * this.axis20.x));
            var k:Number = (1 / Math.sqrt((((colAxis.x * colAxis.x) + (colAxis.y * colAxis.y)) + (colAxis.z * colAxis.z))));
            colAxis.x = (colAxis.x * k);
            colAxis.y = (colAxis.y * k);
            colAxis.z = (colAxis.z * k);
            if ((((colAxis.x * vectorToBox1.x) + (colAxis.y * vectorToBox1.y)) + (colAxis.z * vectorToBox1.z)) < 0)
            {
                colAxis.x = -(colAxis.x);
                colAxis.y = -(colAxis.y);
                colAxis.z = -(colAxis.z);
            }
            var tx:Number = box1.hs.x;
            var ty:Number = box1.hs.y;
            var tz:Number = box1.hs.z;
            var x2:Number = box2.hs.x;
            var y2:Number = box2.hs.y;
            var z2:Number = box2.hs.z;
            if (axisIdx1 == 0)
            {
                tx = 0;
                halfLen1 = box1.hs.x;
            }
            else
            {
                if ((((colAxis.x * transform1.a) + (colAxis.y * transform1.e)) + (colAxis.z * transform1.i)) > 0)
                {
                    tx = -(tx);
                }
            }
            if (axisIdx2 == 0)
            {
                x2 = 0;
                halfLen2 = box2.hs.x;
            }
            else
            {
                if ((((colAxis.x * transform2.a) + (colAxis.y * transform2.e)) + (colAxis.z * transform2.i)) < 0)
                {
                    x2 = -(x2);
                }
            }
            if (axisIdx1 == 1)
            {
                ty = 0;
                halfLen1 = box1.hs.y;
            }
            else
            {
                if ((((colAxis.x * transform1.b) + (colAxis.y * transform1.f)) + (colAxis.z * transform1.j)) > 0)
                {
                    ty = -(ty);
                }
            }
            if (axisIdx2 == 1)
            {
                y2 = 0;
                halfLen2 = box2.hs.y;
            }
            else
            {
                if ((((colAxis.x * transform2.b) + (colAxis.y * transform2.f)) + (colAxis.z * transform2.j)) < 0)
                {
                    y2 = -(y2);
                }
            }
            if (axisIdx1 == 2)
            {
                tz = 0;
                halfLen1 = box1.hs.z;
            }
            else
            {
                if ((((colAxis.x * transform1.c) + (colAxis.y * transform1.g)) + (colAxis.z * transform1.k)) > 0)
                {
                    tz = -(tz);
                }
            }
            if (axisIdx2 == 2)
            {
                z2 = 0;
                halfLen2 = box2.hs.z;
            }
            else
            {
                if ((((colAxis.x * transform2.c) + (colAxis.y * transform2.g)) + (colAxis.z * transform2.k)) < 0)
                {
                    z2 = -(z2);
                }
            }
            var x1:Number = ((((transform1.a * tx) + (transform1.b * ty)) + (transform1.c * tz)) + transform1.d);
            var y1:Number = ((((transform1.e * tx) + (transform1.f * ty)) + (transform1.g * tz)) + transform1.h);
            var z1:Number = ((((transform1.i * tx) + (transform1.j * ty)) + (transform1.k * tz)) + transform1.l);
            tx = x2;
            ty = y2;
            tz = z2;
            x2 = ((((transform2.a * tx) + (transform2.b * ty)) + (transform2.c * tz)) + transform2.d);
            y2 = ((((transform2.e * tx) + (transform2.f * ty)) + (transform2.g * tz)) + transform2.h);
            z2 = ((((transform2.i * tx) + (transform2.j * ty)) + (transform2.k * tz)) + transform2.l);
            k = (((this.axis10.x * this.axis20.x) + (this.axis10.y * this.axis20.y)) + (this.axis10.z * this.axis20.z));
            var det:Number = ((k * k) - 1);
            tx = (x2 - x1);
            ty = (y2 - y1);
            tz = (z2 - z1);
            var c1:Number = (((this.axis10.x * tx) + (this.axis10.y * ty)) + (this.axis10.z * tz));
            var c2:Number = (((this.axis20.x * tx) + (this.axis20.y * ty)) + (this.axis20.z * tz));
            var t1:Number = (((c2 * k) - c1) / det);
            var t2:Number = ((c2 - (c1 * k)) / det);
            contact.pcount = 1;
            var cp:ContactPoint = contact.points[0];
            var cpPos:Vector3 = cp.pos;
            cp.pos.x = (0.5 * (((x1 + (this.axis10.x * t1)) + x2) + (this.axis20.x * t2)));
            cp.pos.y = (0.5 * (((y1 + (this.axis10.y * t1)) + y2) + (this.axis20.y * t2)));
            cp.pos.z = (0.5 * (((z1 + (this.axis10.z * t1)) + z2) + (this.axis20.z * t2)));
            var r:Vector3 = cp.r1;
            r.x = (cpPos.x - transform1.d);
            r.y = (cpPos.y - transform1.h);
            r.z = (cpPos.z - transform1.l);
            r = cp.r2;
            r.x = (cpPos.x - transform2.d);
            r.y = (cpPos.y - transform2.h);
            r.z = (cpPos.z - transform2.l);
            cp.penetration = this.minOverlap;
        }
        private function testMainAxis(box1:CollisionBox, box2:CollisionBox, axis:Vector3, axisIndex:int, toBox1:Vector3):Boolean
        {
            var overlap:Number = this.overlapOnAxis(box1, box2, axis, toBox1);
            if (overlap < -(this.epsilon))
            {
                return (false);
            }
            if ((overlap + this.epsilon) < this.minOverlap)
            {
                this.minOverlap = overlap;
                this.bestAxisIndex = axisIndex;
            }
            return (true);
        }
        private function testDerivedAxis(box1:CollisionBox, box2:CollisionBox, axis1:Vector3, axis2:Vector3, axisIndex:int, toBox1:Vector3):Boolean
        {
            this.axis.x = ((axis1.y * axis2.z) - (axis1.z * axis2.y));
            this.axis.y = ((axis1.z * axis2.x) - (axis1.x * axis2.z));
            this.axis.z = ((axis1.x * axis2.y) - (axis1.y * axis2.x));
            var lenSqr:Number = (((this.axis.x * this.axis.x) + (this.axis.y * this.axis.y)) + (this.axis.z * this.axis.z));
            if (lenSqr < 0.0001)
            {
                return (true);
            }
            var k:Number = (1 / Math.sqrt(lenSqr));
            this.axis.x = (this.axis.x * k);
            this.axis.y = (this.axis.y * k);
            this.axis.z = (this.axis.z * k);
            var overlap:Number = this.overlapOnAxis(box1, box2, this.axis, toBox1);
            if (overlap < -(this.epsilon))
            {
                return (false);
            }
            if ((overlap + this.epsilon) < this.minOverlap)
            {
                this.minOverlap = overlap;
                this.bestAxisIndex = axisIndex;
            }
            return (true);
        }
        public function overlapOnAxis(box1:CollisionBox, box2:CollisionBox, axis:Vector3, vectorToBox1:Vector3):Number
        {
            var m:Matrix4 = box1.transform;
            var d:Number = ((((m.a * axis.x) + (m.e * axis.y)) + (m.i * axis.z)) * box1.hs.x);
            if (d < 0)
            {
                d = -(d);
            }
            var projection:Number = d;
            d = ((((m.b * axis.x) + (m.f * axis.y)) + (m.j * axis.z)) * box1.hs.y);
            if (d < 0)
            {
                d = -(d);
            }
            projection = (projection + d);
            d = ((((m.c * axis.x) + (m.g * axis.y)) + (m.k * axis.z)) * box1.hs.z);
            if (d < 0)
            {
                d = -(d);
            }
            projection = (projection + d);
            m = box2.transform;
            d = ((((m.a * axis.x) + (m.e * axis.y)) + (m.i * axis.z)) * box2.hs.x);
            if (d < 0)
            {
                d = -(d);
            }
            projection = (projection + d);
            d = ((((m.b * axis.x) + (m.f * axis.y)) + (m.j * axis.z)) * box2.hs.y);
            if (d < 0)
            {
                d = -(d);
            }
            projection = (projection + d);
            d = ((((m.c * axis.x) + (m.g * axis.y)) + (m.k * axis.z)) * box2.hs.z);
            if (d < 0)
            {
                d = -(d);
            }
            projection = (projection + d);
            d = (((vectorToBox1.x * axis.x) + (vectorToBox1.y * axis.y)) + (vectorToBox1.z * axis.z));
            if (d < 0)
            {
                d = -(d);
            }
            return (projection - d);
        }
        override public function destroy():void
        {
            var v:Vector3;
            var v1:Vector3;
            var p:ContactPoint;
            this.vectorToBox1 = null;
            this.axis = null;
            this.axis10 = null;
            this.axis11 = null;
            this.axis12 = null;
            this.axis20 = null;
            this.axis21 = null;
            this.axis22 = null;
            if (this.points1 != null)
            {
                for each (v in this.points1)
                {
                    v = null;
                }
                this.points1 = null;
            }
            if (this.points2 != null)
            {
                for each (v1 in this.points2)
                {
                    v1 = null;
                }
                this.points2 = null;
            }
            if (this.tmpPoints != null)
            {
                for each (p in this.tmpPoints)
                {
                    p.destroy();
                    p = null;
                }
                this.tmpPoints = null;
            }
        }

    }
}

import alternativa.math.Vector3;

class CollisionPointTmp
{

    public var pos:Vector3 = new Vector3();
    public var penetration:Number;
    public var feature1:int;
    public var feature2:int;

}
