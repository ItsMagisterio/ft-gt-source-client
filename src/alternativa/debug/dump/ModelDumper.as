package alternativa.debug.dump
{
    import alternativa.osgi.service.dump.dumper.IDumper;
    import alternativa.service.IModelService;
    import alternativa.init.Main;
    import __AS3__.vec.Vector;
    import alternativa.model.IModel;

    public class ModelDumper implements IDumper
    {

        public function dump(params:Vector.<String>):String
        {
            var result:String = "\n";
            var modelRegister:IModelService = IModelService(Main.osgi.getService(IModelService));
            var models:Vector.<IModel> = modelRegister.modelsList;
            var i:int;
            while (i < models.length)
            {
                result = (result + (("  " + models[i]) + "\n"));
                result = (result + (("      id: " + models[i].id) + "\n"));
                result = (result + (("      interfaces: " + modelRegister.getInterfacesForModel(models[i].id)) + "\n\n"));
                i++;
            }
            result = (result + "\n");
            return (result);
        }
        public function get dumperName():String
        {
            return ("model");
        }

    }
}
