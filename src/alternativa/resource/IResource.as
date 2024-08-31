package alternativa.resource
{
    import alternativa.types.Long;

    public interface IResource
    {

        function get name():String;
        function get id():Long;
        function set id(_arg_1:Long):void;
        function get version():int;
        function set version(_arg_1:int):void;
        function load(_arg_1:String):void;
        function close():void;
        function unload():void;

    }
}
