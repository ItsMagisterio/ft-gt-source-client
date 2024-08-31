package alternativa.tanks.models.weapon.common
{
    import alternativa.physics.Body;
    import alternativa.math.Vector3;

    public class HitInfo
    {

        public var distance:Number;
        public var body:Body;
        public var position:Vector3 = new Vector3();
        public var direction:Vector3 = new Vector3();
        public var normal:Vector3 = new Vector3();

    }
}
