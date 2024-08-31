package alternativa.network
{
    public interface ICommandSender
    {

        function sendCommand(_arg_1:Object, _arg_2:Boolean = false):void;
        function close():void;
        function get id():int;

    }
}
