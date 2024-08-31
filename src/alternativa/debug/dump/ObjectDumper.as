package alternativa.debug.dump
{
    import alternativa.osgi.service.dump.dumper.IDumper;
    import flash.utils.Dictionary;
    import alternativa.object.ClientObject;
    import __AS3__.vec.Vector;
    import alternativa.service.ISpaceService;
    import alternativa.init.Main;
    import alternativa.register.SpaceInfo;

    public class ObjectDumper implements IDumper
    {

        public function dump(params:Vector.<String>):String
        {
            var objects:Dictionary;
            var obj:ClientObject;
            var models:Vector.<String>;
            var m:int;
            var result:String = "\n";
            var spaces:Array = ISpaceService(Main.osgi.getService(ISpaceService)).spaceList;
            var i:int;
            while (i < spaces.length)
            {
                result = (result + (("   space id: " + SpaceInfo(spaces[i]).id) + "\n"));
                objects = SpaceInfo(spaces[i]).objectRegister.getObjects();
                for each (obj in objects)
                {
                    result = (result + (("      object id: " + obj.id) + "\n"));
                    models = obj.getModels();
                    if (models.length > 0)
                    {
                        result = (result + "         models id:");
                        m = 0;
                        while (m < models.length)
                        {
                            result = (result + (" " + models[m]));
                            m++;
                        }
                        result = (result + "\n");
                    }
                }
                result = (result + "\n");
                i++;
            }
            return (result);
        }
        public function get dumperName():String
        {
            return ("object");
        }

    }
}
