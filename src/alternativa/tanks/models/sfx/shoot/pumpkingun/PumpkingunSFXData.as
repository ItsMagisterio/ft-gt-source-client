package alternativa.tanks.models.sfx.shoot.pumpkingun
{
    import __AS3__.vec.Vector;
    import alternativa.engine3d.materials.Material;
    import flash.media.Sound;
    import flash.geom.ColorTransform;
    import alternativa.tanks.engine3d.TextureAnimation;

    public class PumpkingunSFXData
    {

        public var shotMaterials:Vector.<Material>;
        public var shotFlashMaterial:Material;
        public var ricochetFlashMaterials:Vector.<Material>;
        public var explosionMaterials:Vector.<Material>;
        public var tailTrailMaterial:Material;
        public var shotSound:Sound;
        public var ricochetSound:Sound;
        public var explosionSound:Sound;
        public var colorTransform:ColorTransform;
        public var dataFlash:TextureAnimation;
        public var dataExplosion:TextureAnimation;
        public var dataShot:TextureAnimation;

    }
}
