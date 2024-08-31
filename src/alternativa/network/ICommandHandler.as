package alternativa.network
{
    public interface ICommandHandler
    {

        function open():void;
        function close():void;
        function disconnect(_arg_1:String):void;
        function executeCommand(_arg_1:Object):void;
        function get commandSender():ICommandSender;
        function set commandSender(_arg_1:ICommandSender):void;

    }
}
