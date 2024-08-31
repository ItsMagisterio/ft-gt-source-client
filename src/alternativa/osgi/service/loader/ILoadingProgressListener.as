package alternativa.osgi.service.loader
{
    public interface ILoadingProgressListener
    {

        function processStarted(_arg_1:Object):void;
        function processStoped(_arg_1:Object):void;
        function changeStatus(_arg_1:Object, _arg_2:String):void;
        function changeProgress(_arg_1:Object, _arg_2:Number):void;

    }
}
