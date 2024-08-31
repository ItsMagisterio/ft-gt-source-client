package alternativa.tanks.models.weapon.plasma
{
    import alternativa.math.Vector3;
    import alternativa.physics.Body;

    public interface IPlasmaShotListener
    {

        function plasmaShotDissolved(_arg_1:PlasmaShot):void;
        function plasmaShotHit(_arg_1:PlasmaShot, _arg_2:Vector3, _arg_3:Vector3, _arg_4:Body):void;

    }
}
