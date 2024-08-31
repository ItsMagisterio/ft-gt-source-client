package alternativa.tanks.models.sfx.shoot.shaft
{
    import alternativa.tanks.sfx.IGraphicEffect;
    import alternativa.math.Vector3;
    import alternativa.engine3d.materials.Material;

    public interface ShaftTrailEffect extends IGraphicEffect
    {

        function init(_arg_1:Vector3, _arg_2:Vector3, _arg_3:Number, _arg_4:Number, _arg_5:Material, _arg_6:int):void;

    }
}
