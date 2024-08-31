package alternativa.tanks.models.sfx.shoot.snowman
{
    import __AS3__.vec.Vector;
    import alternativa.engine3d.materials.Material;
    import flash.media.Sound;
    import flash.geom.ColorTransform;
    import alternativa.tanks.engine3d.TextureAnimation;

    public class SnowmanSFXData
    {

        public var shotMaterials:Vector.<Material>;
        public var explosionMaterials:Vector.<Material>;
        public var shotFlashMaterial:Material;
        public var shotSound:Sound;
        public var explosionSound:Sound;
        public var colorTransform:ColorTransform;
        public var shotData:TextureAnimation;
        public var explosionData:TextureAnimation;
        public var flashData:TextureAnimation;

    }
}
