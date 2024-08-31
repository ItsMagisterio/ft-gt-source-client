package alternativa.tanks.loader
{
    public interface ILoaderWindowService
    {

        function setBatchIdForProcess(_arg_1:int, _arg_2:Object):void;
        function showLoaderWindow():void;
        function hideLoaderWindow():void;
        function lockLoaderWindow():void;
        function unlockLoaderWindow():void;

    }
}
