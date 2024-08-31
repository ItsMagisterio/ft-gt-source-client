package alternativa.service
{
    import alternativa.resource.IResource;
    import alternativa.types.Long;
    import alternativa.resource.factory.IResourceFactory;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;

    public interface IResourceService
    {

        function registerResource(_arg_1:IResource):void;
        function unregisterResource(_arg_1:Long):void;
        function getResource(_arg_1:Long):IResource;
        function registerResourceFactory(_arg_1:IResourceFactory, _arg_2:int):void;
        function unregisterResourceFactory(_arg_1:Array):void;
        function getResourceFactory(_arg_1:int):IResourceFactory;
        function get resourcesList():Vector.<IResource>;
        function setResourceStatus(_arg_1:Long, _arg_2:int, _arg_3:String, _arg_4:String, _arg_5:String):void;
        function get batchLoadingHistory():Array;
        function get resourceLoadingHistory():Dictionary;
        function get resourceStatus():Dictionary;

    }
}
