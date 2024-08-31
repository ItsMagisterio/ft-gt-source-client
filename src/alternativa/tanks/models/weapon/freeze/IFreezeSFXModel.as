package alternativa.tanks.models.weapon.freeze
{
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.models.weapon.common.WeaponCommonData;

    public interface IFreezeSFXModel
    {

        function createEffects(_arg_1:TankData, _arg_2:WeaponCommonData):void;
        function destroyEffects(_arg_1:TankData):void;

    }
}
