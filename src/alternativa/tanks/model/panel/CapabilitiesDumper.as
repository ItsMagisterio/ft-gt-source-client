package alternativa.tanks.model.panel
{
    import alternativa.osgi.service.dump.dumper.IDumper;
    import flash.system.Capabilities;
    import __AS3__.vec.Vector;

    public class CapabilitiesDumper implements IDumper
    {

        public function dump(params:Vector.<String>):String
        {
            var s:String = "\n\nCapabilities\n";
            s = (s + ("\n   os: " + Capabilities.os));
            s = (s + ("\n   version: " + Capabilities.version));
            s = (s + ("\n   playerType: " + Capabilities.playerType));
            s = (s + ("\n   isDebugger: " + Capabilities.isDebugger));
            s = (s + ("\n   language: " + Capabilities.language));
            s = (s + ((("\n   screenResolution: " + Capabilities.screenResolutionX) + " x ") + Capabilities.screenResolutionY));
            return (s);
        }
        public function get dumperName():String
        {
            return ("capabilities");
        }

    }
}
