package alternativa.tanks.model
{
    import com.alternativaplatform.projects.tanks.client.garage.item.ItemModelBase;
    import com.alternativaplatform.projects.tanks.client.garage.item.IItemModelBase;
    import flash.utils.Dictionary;
    import alternativa.model.IModel;
    import com.alternativaplatform.projects.tanks.client.garage.item.ModificationInfo;
    import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;
    import alternativa.init.Main;
    import alternativa.service.IModelService;
    import __AS3__.vec.Vector;
    import alternativa.object.ClientObject;

    public class ItemModel extends ItemModelBase implements IItemModelBase, IItem
    {

        private var params:Dictionary;

        public function ItemModel()
        {
            _interfaces.push(IModel);
            _interfaces.push(IItem);
            _interfaces.push(IItemModelBase);
            this.params = new Dictionary();
        }
        public function initObject(clientObject:ClientObject, baseItemId:String, description:String, itemIndex:int, itemType:ItemTypeEnum, modificationIndex:int, modifications:Array, name:String, previewId:String):void
        {
            var nextModInfo:ModificationInfo;
            var i:int;
            var modInfo:ModificationInfo = ModificationInfo(modifications[modificationIndex]);
            if (modifications[(modificationIndex + 1)] != null)
            {
                nextModInfo = ModificationInfo(modifications[(modificationIndex + 1)]);
            }
            this.params[clientObject] = new ItemParams(baseItemId, description, (itemType == ItemTypeEnum.INVENTORY), itemIndex, modInfo.itemProperties, itemType, modificationIndex, name, ((!(nextModInfo == null)) ? int(nextModInfo.crystalPrice) : int(0)), ((!(nextModInfo == null)) ? nextModInfo.itemProperties : null), ((!(nextModInfo == null)) ? int(nextModInfo.rankId) : int(0)), previewId, modInfo.crystalPrice, modInfo.rankId, modifications, true, null, false, "", 0, 0, false, "");
            Main.writeVarsToConsoleChannel("ITEM MODEL", "initObject  baseItemId: %1", baseItemId);
            var modelRegister:IModelService = (Main.osgi.getService(IModelService) as IModelService);
            var listeners:Vector.<IModel> = modelRegister.getModelsByInterface(IItemListener);
            if (listeners != null)
            {
                i = 0;
                while (i < listeners.length)
                {
                    (listeners[i] as IItemListener).itemLoaded(clientObject, this.params[clientObject]);
                    i++;
                }
            }
        }
        public function getParams(item:ClientObject):ItemParams
        {
            return (this.params[item]);
        }

    }
}
