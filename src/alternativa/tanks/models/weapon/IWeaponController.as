package alternativa.tanks.models.weapon
{
    import alternativa.tanks.models.tank.TankData;

    public interface IWeaponController
    {

        function stopEffects(_arg_1:TankData):void;
        function reset():void;
        function setLocalUser(_arg_1:TankData):void;
        function clearLocalUser():void;
        function activateWeapon(_arg_1:int):void;
        function deactivateWeapon(_arg_1:int, _arg_2:Boolean):void;
        function update(_arg_1:int, _arg_2:int):Number;

    }
}
