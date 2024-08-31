package alternativa.tanks.models.weapon.pumpkingun
{
    import alternativa.math.Vector3;
    import alternativa.physics.Body;

    public interface IPumpkinShotListener
    {

        function shotHit(_arg_1:PumpkinShot, _arg_2:Vector3, _arg_3:Vector3, _arg_4:Body):void;

    }
}
