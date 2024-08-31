package alternativa.tanks.bonuses
{
    public interface IBonusListener
    {

        function onBonusDropped(_arg_1:IBonus):void;
        function onTankCollision(_arg_1:IBonus):void;

    }
}
