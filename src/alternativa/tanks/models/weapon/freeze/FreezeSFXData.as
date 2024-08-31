package alternativa.tanks.models.weapon.freeze
{
    import __AS3__.vec.Vector;
    import alternativa.engine3d.materials.Material;
    import flash.media.Sound;
    import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;

    public class FreezeSFXData
    {

        public var particleMaterials:Vector.<Material>;
        public var planeMaterials:Vector.<Material>;
        public var shotSound:Sound;
        public var colorTransformPoints:Vector.<ColorTransformEntry>;
        public var particleSpeed:Number;

    }
}
