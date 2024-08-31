package alternativa.osgi.service.dump.dumper
{
    import __AS3__.vec.Vector;

    public interface IDumper
    {

        function dump(_arg_1:Vector.<String>):String;
        function get dumperName():String;

    }
}
