package alternativa.debug.dump
{
    import alternativa.osgi.service.dump.dumper.IDumper;
    import alternativa.service.IClassService;
    import alternativa.init.Main;
    import alternativa.register.ClientClass;
    import __AS3__.vec.Vector;

    public class ClassDumper implements IDumper
    {

        public function dump(params:Vector.<String>):String
        {
            var result:String = "\n";
            var classes:Array = IClassService(Main.osgi.getService(IClassService)).classList;
            var i:int;
            while (i < classes.length)
            {
                result = (result + ClientClass(classes[i]).toString());
                i++;
            }
            result = (result + "\n");
            return (result);
        }
        public function get dumperName():String
        {
            return ("class");
        }

    }
}
