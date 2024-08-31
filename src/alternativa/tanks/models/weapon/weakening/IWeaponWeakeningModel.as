package alternativa.tanks.models.weapon.weakening
{
    import alternativa.object.ClientObject;

    public interface IWeaponWeakeningModel
    {

        function getImpactCoeff(_arg_1:ClientObject, _arg_2:Number):Number;
        function getFullDamageRadius(_arg_1:ClientObject):Number;

    }
}
