package alternativa.tanks.models.weapon
{
    import alternativa.object.ClientObject;

    public interface IWeapon
    {

        function ownerLoaded(_arg_1:ClientObject):void;
        function ownerUnloaded(_arg_1:ClientObject):void;
        function ownerDisabled(_arg_1:ClientObject):void;
        function update(_arg_1:int, _arg_2:int):Number;
        function reset():void;
        function enable():void;
        function disable():void;
        function stop():void;
        function getTurretRotationAccel(_arg_1:ClientObject):Number;
        function getTurretRotationSpeed(_arg_1:ClientObject):Number;
        function getWeaponController():IWeaponController;

    }
}
