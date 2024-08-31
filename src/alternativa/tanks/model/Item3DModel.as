package alternativa.tanks.model
{
    import com.alternativaplatform.projects.tanks.client.garage.item3d.Item3DModelBase;
    import com.alternativaplatform.projects.tanks.client.garage.item3d.IItem3DModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.object.ClientObject;
    import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import alternativa.service.IModelService;
    import alternativa.models.object3ds.IObject3DS;
    import alternativa.models.coloring.IColoring;
    import alternativa.resource.Tanks3DSResource;
    import __AS3__.vec.Vector;
    import logic.resource.images.ImageResource;
    import __AS3__.vec.*;

    public class Item3DModel extends Item3DModelBase implements IItem3DModelBase, IObjectLoadListener
    {

        private var clientObject:ClientObject;
        private var itemType:ItemTypeEnum;

        public function Item3DModel()
        {
            _interfaces.push(IModel);
            _interfaces.push(IItem3DModelBase);
            _interfaces.push(IObjectLoadListener);
        }
        public function initObject(clientObject:ClientObject, itemType:ItemTypeEnum):void
        {
            Main.writeToConsole((("\n\n\nItem3DModel init clientObject id:" + clientObject.id) + "\n\n\n"));
            this.clientObject = clientObject;
            this.itemType = itemType;
        }
        public function objectLoaded(object:ClientObject):void
        {
            var modelRegister:IModelService;
            var object3DSmodel:IObject3DS;
            var coloringModel:IColoring;
            var resource:Tanks3DSResource;
            Main.writeToConsole("Item3DModel objectLoaded");
            modelRegister = (Main.osgi.getService(IModelService) as IModelService);
            var models:Vector.<IModel> = (modelRegister.getModelsByInterface(IGarage) as Vector.<IModel>);
            var garageModel:IGarage = (models[0] as IGarage);
            if (garageModel != null)
            {
                object3DSmodel = (modelRegister.getModelForObject(this.clientObject, IObject3DS) as IObject3DS);
                switch (this.itemType)
                {
                    case ItemTypeEnum.ARMOR:
                        if (object3DSmodel != null)
                        {
                            resource = object3DSmodel.getResource3DS(this.clientObject);
                            Main.writeToConsole(("Item3DModel setHull resource: " + resource));
                        }
                        break;
                    case ItemTypeEnum.WEAPON:
                        if (object3DSmodel != null)
                        {
                            resource = object3DSmodel.getResource3DS(this.clientObject);
                            Main.writeToConsole(("Item3DModel setTurret resource: " + resource));
                        }
                        break;
                    case ItemTypeEnum.COLOR:
                        coloringModel = (modelRegister.getModelForObject(this.clientObject, IColoring) as IColoring);
                        garageModel.setColorMap((coloringModel.getResource(this.clientObject) as ImageResource));
                        break;
                    case ItemTypeEnum.INVENTORY:
                        break;
                    case ItemTypeEnum.RESISTANCE:
                        break;
                }
            }
            else
            {
                Main.writeToConsole("Item3DModel garageModel = null");
            }
        }
        public function objectUnloaded(object:ClientObject):void
        {
            Main.writeToConsole("Item3DModel objectUnloaded");
            this.clientObject = null;
        }

    }
}
