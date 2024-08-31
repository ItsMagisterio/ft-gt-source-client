package alternativa.tanks.models.effects.common
{
    import alternativa.object.ClientObject;
    import alternativa.tanks.bonuses.IBonus;

    public interface IBonusCommonModel
    {

        function getBonus(_arg_1:ClientObject, _arg_2:String, _arg_3:int, _arg_4:Boolean):IBonus;

    }
}
