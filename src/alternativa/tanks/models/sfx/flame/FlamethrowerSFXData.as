package alternativa.tanks.models.sfx.flame
{
    import __AS3__.vec.Vector;
    import alternativa.engine3d.materials.Material;
    import flash.media.Sound;
    import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
    import alternativa.tanks.engine3d.TextureAnimation;

    public class FlamethrowerSFXData
    {

        public var materials:Vector.<Material>;
        public var planeMaterials:Vector.<Material>;
        public var flameSound:Sound;
        public var colorTransformPoints:Vector.<ColorTransformEntry>;
        public var data:TextureAnimation;

    }
}
