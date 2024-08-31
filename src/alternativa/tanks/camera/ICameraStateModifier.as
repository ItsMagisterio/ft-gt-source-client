package alternativa.tanks.camera
{
    import alternativa.math.Vector3;

    public interface ICameraStateModifier
    {

        function update(_arg_1:int, _arg_2:int, _arg_3:Vector3, _arg_4:Vector3):Boolean;
        function onAddedToController(_arg_1:IFollowCameraController):void;
        function destroy():void;

    }
}
