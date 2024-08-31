package alternativa.tanks.models.battlefield.inventory
{
    import projects.tanks.client.battlefield.gui.models.inventory.item.InventoryItemModelBase;
    import projects.tanks.client.battlefield.gui.models.inventory.item.IInventoryItemModelBase;
    import flash.utils.Dictionary;
    import alternativa.tanks.models.tank.TankModel;
    import alternativa.model.IModel;
    import alternativa.service.IModelService;
    import alternativa.init.Main;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.object.ClientObject;
    import alternativa.types.Long;
    import alternativa.tanks.models.inventory.IInventory;
    import flash.geom.Vector3D;
    import logic.networking.Network;
    import logic.networking.INetworker;

    public class InventoryItemModel extends InventoryItemModelBase implements IInventoryItemModelBase, IInventoryItemModel
    {

        private var inventoryPanel:IInventoryPanel;
        private var itemByObject:Dictionary = new Dictionary();
        private var tankInterface:TankModel;

        public function InventoryItemModel()
        {
            _interfaces.push(IModel, IInventoryItemModelBase, IInventoryItemModel);

        }
        public function initObject(clientObject:ClientObject, battleId:Long, count:int, itemEffectTime:int, itemId:int, itemRestSec:int):void
        {
            var modelService:IModelService = null;
            if (this.inventoryPanel == null)
            {
                modelService = IModelService(Main.osgi.getService(IModelService));
                this.inventoryPanel = IInventoryPanel(modelService.getModelsByInterface(IInventoryPanel)[0]);
                this.tankInterface = TankModel(Main.osgi.getService(ITank));
            }
            var item:InventoryItem = new InventoryItem(clientObject, itemId, count, ((itemRestSec + itemEffectTime) * 1000));
            this.itemByObject[clientObject] = item;

            var slotIndex:int = (itemId - 1);
            this.inventoryPanel.assignItemToSlot(item, slotIndex);
        }
        public function activated(clientObject:ClientObject):void
        {
            var item:InventoryItem = this.itemByObject[clientObject];
            if (item == null)
            {
                return;
            }

            item.startCooldown(0);
            item.count--;

            this.inventoryPanel.itemActivated(item);
        }
        public function updateItemCount(clientObject:ClientObject, count:int):void
        {
            var item:InventoryItem = this.itemByObject[clientObject];
            if (item == null)
            {
                return;
            }
            item.count = count;
            InventoryModel(IModelService(Main.osgi.getService(IModelService)).getModelsByInterface(IInventory)[0]).itemUpdated(item);
        }
        public function requestActivation(item:InventoryItem, slot:InventoryPanelSlot):void
        {
            var v:Vector3D;

            if (slot.canActivate())
            {

                v = new Vector3D();
                this.tankInterface.readLocalTankPosition(v);
                this.activate(item.getClientObject(), v);
            }

        }
        private function activate(clientObject:ClientObject, vector:Vector3D):void
        {
            Network(Main.osgi.getService(INetworker)).send(((((((("battle;activate_item;" + clientObject.id) + ";") + vector.x) + ";") + vector.y) + ";") + vector.z));
        }

    }
}
