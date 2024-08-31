package alternativa.tanks.models.weapon.common
{
    import alternativa.object.ClientObject;
    import alternativa.tanks.vehicles.tanks.Tank;
    import alternativa.math.Vector3;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.tanks.models.tank.TankData;

    public interface IWeaponCommonModel
    {

        function getCommonData(_arg_1:ClientObject):WeaponCommonData;
        function createShotEffects(_arg_1:ClientObject, _arg_2:Tank, _arg_3:int, _arg_4:Vector3, _arg_5:Vector3, byWho:ClientObject):void;
        function createExplosionEffects(_arg_1:ClientObject, _arg_2:Camera3D, _arg_3:Boolean, _arg_4:Vector3, _arg_5:Vector3, _arg_6:TankData, _arg_7:Number, byWho:ClientObject):void;

    }
}
