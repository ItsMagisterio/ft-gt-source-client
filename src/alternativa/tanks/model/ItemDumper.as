package alternativa.tanks.model
{
    import alternativa.osgi.service.dump.dumper.IDumper;
    import flash.utils.Dictionary;
    import alternativa.object.ClientObject;
    import __AS3__.vec.Vector;
    import alternativa.service.IModelService;
    import alternativa.init.Main;
    import alternativa.model.IModel;
    import alternativa.service.ISpaceService;
    import alternativa.register.SpaceInfo;
    import __AS3__.vec.*;

    public class ItemDumper implements IDumper
    {

        public function dump(params:Vector.<String>):String
        {
            var spaces:Array;
            var i:int;
            var objects:Dictionary;
            var obj:ClientObject;
            var models:Vector.<String>;
            var m:int;
            var itemParams:ItemParams;
            var result:String = "\n";
            var modelRegister:IModelService = IModelService(Main.osgi.getService(IModelService));
            var itemModel:IItem = ((modelRegister.getModelsByInterface(IItem) as Vector.<IModel>)[0] as IItem);
            if (itemModel != null)
            {
                spaces = ISpaceService(Main.osgi.getService(ISpaceService)).spaceList;
                i = 0;
                while (i < spaces.length)
                {
                    objects = SpaceInfo(spaces[i]).objectRegister.getObjects();
                    for each (obj in objects)
                    {
                        models = obj.getModels();
                        if (models.length > 0)
                        {
                            m = 0;
                            while (m < models.length)
                            {
                                if ((itemModel as IModel).id == (models[m] as String))
                                {
                                    itemParams = itemModel.getParams(obj);
                                    result = (result + ("\n" + itemParams.name));
                                    result = (result + (("   type: " + itemParams.itemType) + "\n"));
                                    result = (result + (("   description: " + itemParams.description) + "\n"));
                                    result = (result + (("   rankId: " + itemParams.rankId) + "\n"));
                                    result = (result + (("   price: " + itemParams.price) + "\n"));
                                }
                                m++;
                            }
                        }
                    }
                    i++;
                }
            }
            else
            {
                result = (result + "ItemModel not registered!");
            }
            result = (result + "\n");
            return (result);
        }
        public function get dumperName():String
        {
            return ("item");
        }

    }
}
