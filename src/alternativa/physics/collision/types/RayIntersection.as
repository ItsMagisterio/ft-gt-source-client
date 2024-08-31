package alternativa.physics.collision.types
{
    import alternativa.physics.collision.CollisionPrimitive;
    import alternativa.math.Vector3;

    public class RayIntersection
    {

        public var primitive:CollisionPrimitive;
        public var pos:Vector3 = new Vector3();
        public var normal:Vector3 = new Vector3();
        public var t:Number = 0;

        public function copy(source:RayIntersection):void
        {
            this.primitive = source.primitive;
            this.pos.vCopy(source.pos);
            this.normal.vCopy(source.normal);
            this.t = source.t;
        }

    }
}
