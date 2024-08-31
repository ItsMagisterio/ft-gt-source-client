package alternativa.tanks.models.battlefield.scene3dcontainer
{
    import alternativa.engine3d.core.Object3D;
    import __AS3__.vec.Vector;

    public interface Scene3DContainer
    {

        function addChild(_arg_1:Object3D):void;
        function addChildAt(_arg_1:Object3D, _arg_2:int):void;
        function addChildren(_arg_1:Vector.<Object3D>):void;
        function removeChild(_arg_1:Object3D):void;

    }
}
