package alternativa.tanks.models.sfx.healing
{
    import alternativa.tanks.sfx.ISpecialEffect;

    public interface IHealingGunEffectListener
    {

        function onEffectDestroyed(_arg_1:ISpecialEffect):void;

    }
}
