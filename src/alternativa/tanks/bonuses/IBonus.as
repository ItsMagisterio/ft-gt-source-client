package alternativa.tanks.bonuses
{
    import alternativa.math.Vector3;
    import alternativa.physics.PhysicsScene;
    import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;

    public interface IBonus
    {

        function get bonusId():String;
        function attach(_arg_1:Vector3, _arg_2:PhysicsScene, _arg_3:Scene3DContainer, _arg_4:IBonusListener):void;
        function update(_arg_1:int, _arg_2:int, _arg_3:Number):Boolean;
        function isFalling():Boolean;
        function setRestingState(_arg_1:Number, _arg_2:Number, _arg_3:Number):void;
        function setTakenState():void;
        function setRemovedState():void;
        function destroy():void;
        function readBonusPosition(_arg_1:Vector3):void;

    }
}
