package alternativa.tanks.model
{
    public interface IItemEffectListener
    {

        function setTimeRemaining(_arg_1:String, _arg_2:Number):void;
        function effectStopped(_arg_1:String):void;

    }
}
