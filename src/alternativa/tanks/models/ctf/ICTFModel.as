package alternativa.tanks.models.ctf
{
    import alternativa.math.Vector3;
    import projects.tanks.client.battleservice.model.team.BattleTeamType;
    import alternativa.tanks.models.tank.TankData;

    public interface ICTFModel
    {

        function isPositionInFlagProximity(_arg_1:Vector3, _arg_2:Number, _arg_3:BattleTeamType):Boolean;
        function isFlagCarrier(_arg_1:TankData):Boolean;

    }
}
