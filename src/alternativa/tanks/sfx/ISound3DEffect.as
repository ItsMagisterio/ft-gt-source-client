package alternativa.tanks.sfx
{
    import alternativa.math.Vector3;

    public interface ISound3DEffect extends ISpecialEffect
    {

        function set enabled(_arg_1:Boolean):void;
        function readPosition(_arg_1:Vector3):void;
        function get numSounds():int;

    }
}
