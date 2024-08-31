package alternativa.debug.dump
{
    import alternativa.osgi.service.dump.dumper.IDumper;
    import alternativa.service.ISpaceService;
    import alternativa.init.Main;
    import alternativa.register.SpaceInfo;
    import __AS3__.vec.Vector;

    public class SpaceDumper implements IDumper
    {

        public function dump(params:Vector.<String>):String
        {
            var result:String = "\n";
            var spaces:Array = ISpaceService(Main.osgi.getService(ISpaceService)).spaceList;
            var i:int;
            while (i < spaces.length)
            {
                result = (result + (("   space id: " + ((SpaceInfo(spaces[i]).id == null) ? "X" : SpaceInfo(spaces[i]).id.toString())) + "\n"));
                i++;
            }
            result = (result + "\n");
            return (result);
        }
        public function get dumperName():String
        {
            return ("space");
        }

    }
}
