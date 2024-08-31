package alternativa.tanks.models.sfx.shoot
{
    import alternativa.object.ClientObject;
    import alternativa.math.Vector3;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.tanks.sfx.EffectsPair;

    public interface ICommonShootSFX
    {

        function createShotEffects(_arg_1:ClientObject, _arg_2:Vector3, _arg_3:Object3D, _arg_4:Camera3D, _arg_5:ClientObject):EffectsPair;
        function createExplosionEffects(_arg_1:ClientObject, _arg_2:Vector3, _arg_3:Camera3D, _arg_4:Number, _arg_5:ClientObject):EffectsPair;

    }
}
