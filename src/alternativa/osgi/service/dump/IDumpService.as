package alternativa.osgi.service.dump
{
    import alternativa.osgi.service.dump.dumper.IDumper;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;

    public interface IDumpService
    {

        function registerDumper(_arg_1:IDumper):void;
        function unregisterDumper(_arg_1:String):void;
        function dump(_arg_1:Vector.<String>):String;
        function get dumpers():Dictionary;
        function get dumpersList():Vector.<IDumper>;

    }
}
