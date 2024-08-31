package alternativa.physics.collision.colliders
{
    import alternativa.physics.collision.ICollider;
    import alternativa.math.Vector3;
    import alternativa.physics.ContactPoint;
    import alternativa.physics.collision.primitives.CollisionSphere;
    import alternativa.physics.collision.CollisionPrimitive;
    import alternativa.physics.Contact;
    import alternativa.physics.altphysics;
    use namespace altphysics;

    public class SphereSphereCollider implements ICollider
    {

        private var p1:Vector3 = new Vector3();
        private var p2:Vector3 = new Vector3();

        public function getContact(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean
        {
            var cp:ContactPoint;
            var dy:Number;
            var s1:CollisionSphere;
            var s2:CollisionSphere;
            cp = null;
            if (prim1.body != null)
            {
                s1 = (prim1 as CollisionSphere);
                s2 = (prim2 as CollisionSphere);
            }
            else
            {
                s1 = (prim2 as CollisionSphere);
                s2 = (prim1 as CollisionSphere);
            }
            s1.transform.getAxis(3, this.p1);
            s2.transform.getAxis(3, this.p2);
            var dx:Number = (this.p1.x - this.p2.x);
            dy = (this.p1.y - this.p2.y);
            var dz:Number = (this.p1.z - this.p2.z);
            var len:Number = (((dx * dx) + (dy * dy)) + (dz * dz));
            var sum:Number = (s1.r + s2.r);
            if (len > (sum * sum))
            {
                return (false);
            }
            len = Math.sqrt(len);
            dx = (dx / len);
            dy = (dy / len);
            dz = (dz / len);
            contact.body1 = s1.body;
            contact.body2 = s2.body;
            contact.normal.x = dx;
            contact.normal.y = dy;
            contact.normal.z = dz;
            contact.pcount = 1;
            cp = contact.points[0];
            cp.penetration = (sum - len);
            cp.pos.x = (this.p1.x - (dx * s1.r));
            cp.pos.y = (this.p1.y - (dy * s1.r));
            cp.pos.z = (this.p1.z - (dz * s1.r));
            cp.r1.vDiff(cp.pos, this.p1);
            cp.r2.vDiff(cp.pos, this.p2);
            return (true);
        }
        public function haveCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean
        {
            return (false);
        }
        public function destroy():void
        {
            this.p1 = null;
            this.p2 = null;
        }

    }
}
