package alternativa.physics
{
    import alternativa.physics.collision.CollisionPrimitive;
    import alternativa.math.Vector3;

    public class RayHit
    {

        public var primitive:CollisionPrimitive;
        public var position:Vector3 = new Vector3();
        public var normal:Vector3 = new Vector3();
        public var t:Number = 0;

        public function copy(source:RayHit):void
        {
            this.primitive = source.primitive;
            this.position.vCopy(source.position);
            this.normal.vCopy(source.normal);
            this.t = source.t;
        }

    }
}
