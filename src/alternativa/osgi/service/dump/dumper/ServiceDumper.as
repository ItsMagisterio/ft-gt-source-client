package alternativa.osgi.service.dump.dumper
{
    import alternativa.init.OSGi;
    import __AS3__.vec.Vector;

    public class ServiceDumper implements IDumper
    {

        private var osgi:OSGi;

        public function ServiceDumper(osgi:OSGi)
        {
            this.osgi = osgi;
        }
        public function dump(params:Vector.<String>):String
        {
            var result:String = "\n";
            var services:Vector.<Object> = this.osgi.serviceList;
            var i:int;
            while (i < services.length)
            {
                result = (result + (((("   service " + (i + 1).toString()) + ": ") + services[i]) + "\n"));
                i++;
            }
            result = (result + "\n");
            return (result);
        }
        public function get dumperName():String
        {
            return ("service");
        }

    }
}
