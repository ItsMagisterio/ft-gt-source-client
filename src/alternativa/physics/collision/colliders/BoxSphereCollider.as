﻿package alternativa.physics.collision.colliders
{
    import alternativa.physics.collision.ICollider;
    import alternativa.math.Vector3;
    import alternativa.physics.collision.primitives.CollisionBox;
    import alternativa.physics.collision.primitives.CollisionSphere;
    import alternativa.physics.ContactPoint;
    import alternativa.physics.collision.CollisionPrimitive;
    import alternativa.physics.Contact;
    import alternativa.physics.altphysics;
    use namespace altphysics;

    public class BoxSphereCollider implements ICollider
    {

        private var center:Vector3 = new Vector3();
        private var closestPt:Vector3 = new Vector3();
        private var bPos:Vector3 = new Vector3();
        private var sPos:Vector3 = new Vector3();

        public function getContact(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean
        {
            var box:CollisionBox;
            var sphere:CollisionSphere = (prim1 as CollisionSphere);
            if (sphere == null)
            {
                sphere = (prim2 as CollisionSphere);
                box = (prim1 as CollisionBox);
            }
            else
            {
                box = (prim2 as CollisionBox);
            }
            sphere.transform.getAxis(3, this.sPos);
            box.transform.getAxis(3, this.bPos);
            box.transform.transformVectorInverse(this.sPos, this.center);
            var hs:Vector3 = box.hs;
            var sx:Number = (hs.x + sphere.r);
            var sy:Number = (hs.y + sphere.r);
            var sz:Number = (hs.z + sphere.r);
            if (((((((this.center.x > sx) || (this.center.x < -(sx))) || (this.center.y > sy)) || (this.center.y < -(sy))) || (this.center.z > sz)) || (this.center.z < -(sz))))
            {
                return (false);
            }
            if (this.center.x > hs.x)
            {
                this.closestPt.x = hs.x;
            }
            else
            {
                if (this.center.x < -(hs.x))
                {
                    this.closestPt.x = -(hs.x);
                }
                else
                {
                    this.closestPt.x = this.center.x;
                }
            }
            if (this.center.y > hs.y)
            {
                this.closestPt.y = hs.y;
            }
            else
            {
                if (this.center.y < -(hs.y))
                {
                    this.closestPt.y = -(hs.y);
                }
                else
                {
                    this.closestPt.y = this.center.y;
                }
            }
            if (this.center.z > hs.z)
            {
                this.closestPt.z = hs.z;
            }
            else
            {
                if (this.center.z < -(hs.z))
                {
                    this.closestPt.z = -(hs.z);
                }
                else
                {
                    this.closestPt.z = this.center.z;
                }
            }
            var distSqr:Number = this.center.vSubtract(this.closestPt).vLengthSqr();
            if (distSqr > (sphere.r * sphere.r))
            {
                return (false);
            }
            contact.body1 = sphere.body;
            contact.body2 = box.body;
            contact.normal.vCopy(this.closestPt).vTransformBy4(box.transform).vSubtract(this.sPos).vNormalize().vReverse();
            contact.pcount = 1;
            var cp:ContactPoint = contact.points[0];
            cp.penetration = (sphere.r - Math.sqrt(distSqr));
            cp.pos.vCopy(contact.normal).vScale(-(sphere.r)).vAdd(this.sPos);
            cp.r1.vDiff(cp.pos, this.sPos);
            cp.r2.vDiff(cp.pos, this.bPos);
            return (true);
        }
        public function haveCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean
        {
            var box:CollisionBox;
            var sphere:CollisionSphere = (prim1 as CollisionSphere);
            if (sphere == null)
            {
                sphere = (prim2 as CollisionSphere);
                box = (prim1 as CollisionBox);
            }
            else
            {
                box = (prim2 as CollisionBox);
            }
            sphere.transform.getAxis(3, this.sPos);
            box.transform.getAxis(3, this.bPos);
            box.transform.transformVectorInverse(this.sPos, this.center);
            var hs:Vector3 = box.hs;
            var sx:Number = (hs.x + sphere.r);
            var sy:Number = (hs.y + sphere.r);
            var sz:Number = (hs.z + sphere.r);
            if (((((((this.center.x > sx) || (this.center.x < -(sx))) || (this.center.y > sy)) || (this.center.y < -(sy))) || (this.center.z > sz)) || (this.center.z < -(sz))))
            {
                return (false);
            }
            if (this.center.x > hs.x)
            {
                this.closestPt.x = hs.x;
            }
            else
            {
                if (this.center.x < -(hs.x))
                {
                    this.closestPt.x = -(hs.x);
                }
                else
                {
                    this.closestPt.x = this.center.x;
                }
            }
            if (this.center.y > hs.y)
            {
                this.closestPt.y = hs.y;
            }
            else
            {
                if (this.center.y < -(hs.y))
                {
                    this.closestPt.y = -(hs.y);
                }
                else
                {
                    this.closestPt.y = this.center.y;
                }
            }
            if (this.center.z > hs.z)
            {
                this.closestPt.z = hs.z;
            }
            else
            {
                if (this.center.z < -(hs.z))
                {
                    this.closestPt.z = -(hs.z);
                }
                else
                {
                    this.closestPt.z = this.center.z;
                }
            }
            var distSqr:Number = this.center.vSubtract(this.closestPt).vLengthSqr();
            if (distSqr > (sphere.r * sphere.r))
            {
                return (false);
            }
            return (true);
        }
        public function destroy():void
        {
            this.center = null;
            this.closestPt = null;
            this.bPos = null;
            this.sPos = null;
        }

    }
}
