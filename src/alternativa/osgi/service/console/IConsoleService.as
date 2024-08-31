package alternativa.osgi.service.console
{
    public interface IConsoleService
    {

        function showConsole():void;
        function hideConsole():void;
        function clearConsole():void;
        function writeToConsole(_arg_1:String, ..._args):void;
        function writeToConsoleChannel(_arg_1:String, _arg_2:String, ..._args):void;
        function get console():Object;

    }
}
