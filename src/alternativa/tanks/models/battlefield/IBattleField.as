package alternativa.tanks.models.battlefield
{
    import alternativa.engine3d.objects.Decal;
    import alternativa.math.Vector3;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.tanks.models.battlefield.decals.RotationState;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.sfx.IGraphicEffect;
    import alternativa.tanks.sfx.ISound3DEffect;
    import alternativa.object.ClientObject;
    import alternativa.tanks.camera.ICameraController;
    import alternativa.tanks.vehicles.tanks.Tank;
    import alternativa.tanks.sound.ISoundManager;
    import alternativa.tanks.camera.ICameraStateModifier;

    public interface IBattleField
    {

        function addDecal(_arg_1:Vector3, _arg_2:Vector3, _arg_3:Number, _arg_4:TextureMaterial, _arg_5:RotationState = null, _arg_6:Boolean = false):Decal;
        function getBattlefieldData():BattlefieldData;
        function addTank(_arg_1:TankData):void;
        function removeTank(_arg_1:TankData):void;
        function addGraphicEffect(_arg_1:IGraphicEffect):void;
        function addSound3DEffect(_arg_1:ISound3DEffect):void;
        function setLocalUser(_arg_1:ClientObject):void;
        function initFlyCamera(_arg_1:Vector3, _arg_2:Vector3):void;
        function initFollowCamera(_arg_1:Vector3, _arg_2:Vector3):void;
        function initCameraController(_arg_1:ICameraController):void;
        function setCameraTarget(_arg_1:Tank):void;
        function removeTankFromField(_arg_1:TankData):void;
        function showSuicideIndicator(_arg_1:int):void;
        function hideSuicideIndicator():void;
        function getRespawnInvulnerabilityPeriod():int;
        function printDebugValue(_arg_1:String, _arg_2:String):void;
        function addPlugin(_arg_1:IBattlefieldPlugin):void;
        function removePlugin(_arg_1:IBattlefieldPlugin):void;
        function get soundManager():ISoundManager;
        function tankHit(_arg_1:TankData, _arg_2:Vector3, _arg_3:Number):void;
        function addFollowCameraModifier(_arg_1:ICameraStateModifier):void;

    }
}
