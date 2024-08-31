package alternativa.tanks.models.weapon.snowman
{
    import alternativa.math.Vector3;
    import alternativa.physics.Body;

    public interface ISnowmanShotListener
    {

        function snowShotDissolved(_arg_1:SnowmanShot):void;
        function snowShotHit(_arg_1:SnowmanShot, _arg_2:Vector3, _arg_3:Vector3, _arg_4:Body):void;

    }
}
