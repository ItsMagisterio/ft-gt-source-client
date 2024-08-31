package alternativa.tanks.models.sfx.flame
{
    import alternativa.tanks.models.tank.TankData;
    import alternativa.math.Vector3;
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
    import alternativa.tanks.sfx.EffectsPair;

    public interface IFlamethrowerSFXModel
    {

        function getSpecialEffects(_arg_1:TankData, _arg_2:Vector3, _arg_3:Object3D, _arg_4:IWeaponWeakeningModel):EffectsPair;

    }
}
