package alternativa.osgi.service.dump.dumper
{
    import alternativa.init.OSGi;
    import __AS3__.vec.Vector;
    import alternativa.osgi.bundle.Bundle;

    public class BundleDumper implements IDumper
    {

        private var osgi:OSGi;

        public function BundleDumper(osgi:OSGi)
        {
            this.osgi = osgi;
        }
        public function dump(params:Vector.<String>):String
        {
            var result:String = "\n";
            var bundles:Vector.<Bundle> = this.osgi.bundleList;
            var i:int;
            while (i < bundles.length)
            {
                result = (result + (((("   bundle " + (i + 1).toString()) + ": ") + bundles[i].name) + "\n"));
                i++;
            }
            result = (result + "\n");
            return (result);
        }
        public function get dumperName():String
        {
            return ("bundle");
        }

    }
}
