package alternativa.tanks.models.sfx.shoot.thunder
{
    import alternativa.object.ClientObject;
    import alternativa.math.Vector3;
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.sfx.EffectsPair;

    public interface IThunderSFXModel
    {

        function createShotEffects(_arg_1:ClientObject, _arg_2:Vector3, _arg_3:Object3D):EffectsPair;
        function createExplosionEffects(_arg_1:ClientObject, _arg_2:Vector3):EffectsPair;

    }
}
