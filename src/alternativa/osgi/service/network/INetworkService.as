package alternativa.osgi.service.network
{
    public interface INetworkService
    {

        function addEventListener(_arg_1:INetworkListener):void;
        function removeEventListener(_arg_1:INetworkListener):void;
        function get server():String;
        function get ports():Array;
        function get resourcesPath():String;
        function get proxyHost():String;
        function get proxyPort():int;

    }
}
