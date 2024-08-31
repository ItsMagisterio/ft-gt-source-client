package alternativa.tanks
{
    import alternativa.engine3d.objects.Mesh;
    import flash.display.BitmapData;
    import flash.geom.Vector3D;
    import alternativa.engine3d.core.Object3D;

    public class Tank3DPart
    {

        public var mesh:Mesh;
        public var lightmap:BitmapData;
        public var details:BitmapData;
        public var turretMountPoint:Vector3D;
        public var animatedPaint:Boolean;
        public var objects:Vector.<Object3D>;
        public var id:String;

    }
}
