package alternativa.tanks.sfx
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.camera.GameCamera;

    public interface Object3DPositionProvider
    {

        function initPosition(_arg_1:Object3D):void;
        function updateObjectPosition(_arg_1:Object3D, _arg_2:GameCamera, _arg_3:int):void;
        function destroy():void;

    }
}
