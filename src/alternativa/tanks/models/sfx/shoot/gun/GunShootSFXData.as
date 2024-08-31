package alternativa.tanks.models.sfx.shoot.gun
{
    import alternativa.engine3d.materials.Material;
    import __AS3__.vec.Vector;
    import flash.media.Sound;
    import alternativa.tanks.engine3d.TextureAnimation;

    public class GunShootSFXData
    {

        public var shotMaterial:Material;
        public var explosionMaterials:Vector.<Material>;
        public var shotSound:Sound;
        public var explosionSound:Sound;
        public var shotData:TextureAnimation;
        public var explosionData:TextureAnimation;

    }
}
