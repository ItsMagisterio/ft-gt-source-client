package alternativa.debug
{
    public interface IDebugCommandProvider
    {

        function registerCommand(_arg_1:String, _arg_2:IDebugCommandHandler):void;
        function unregisterCommand(_arg_1:String):void;
        function executeCommand(_arg_1:String):String;

    }
}
