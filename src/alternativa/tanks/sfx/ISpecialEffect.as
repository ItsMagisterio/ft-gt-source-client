package alternativa.tanks.sfx
{
    import alternativa.tanks.camera.GameCamera;
    import alternativa.object.ClientObject;

    public interface ISpecialEffect
    {

        function play(_arg_1:int, _arg_2:GameCamera):Boolean;
        function destroy():void;
        function kill():void;
        function get owner():ClientObject;

    }
}
