package alternativa.tanks.models.sfx.healing
{
    import alternativa.tanks.models.tank.TankData;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.healing.IsisActionType;

    public interface IHealingSFXModel
    {

        function createOrUpdateEffects(_arg_1:TankData, _arg_2:IsisActionType, _arg_3:TankData):void;
        function destroyEffectsByOwner(_arg_1:TankData):void;
        function destroyEffectsByTarget(_arg_1:TankData):void;

    }
}
