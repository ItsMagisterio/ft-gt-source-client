package alternativa.tanks.model
{
    import com.alternativaplatform.projects.tanks.client.garage.garage.GarageModelBase;
    import com.alternativaplatform.projects.tanks.client.garage.garage.IGarageModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.osgi.service.dump.dumper.IDumper;
    import alternativa.tanks.service.money.IMoneyListener;
    import alternativa.model.IResourceLoadListener;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObjectContainer;
    import alternativa.tanks.help.IHelpService;
    import alternativa.service.IModelService;
    import alternativa.service.IResourceService;
    import alternativa.tanks.model.panel.IPanel;
    import alternativa.object.ClientObject;
    import alternativa.tanks.gui.GarageWindow;
    import com.alternativaplatform.projects.tanks.client.garage.garage.ItemInfo;
    import alternativa.types.Long;
    import alternativa.tanks.help.StoreListHelper;
    import alternativa.tanks.help.WarehouseListHelper;
    import alternativa.tanks.gui.ConfirmAlert;
    import logic.networking.Network;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import alternativa.osgi.service.mainContainer.IMainContainerService;
    import com.alternativaplatform.projects.tanks.client.garage.item.ItemPropertyValue;
    import com.alternativaplatform.projects.tanks.client.commons.types.ItemProperty;
    import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;
    import flash.utils.Timer;
    import flash.display.StageQuality;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import logic.gui.IGTanksLoader;
    import logic.gui.GTanksLoaderWindow;
    import logic.networking.INetworker;
    import alternativa.init.GarageModelActivator;
    import alternativa.tanks.service.money.IMoneyService;
    import alternativa.tanks.loader.ILoaderWindowService;
    import alternativa.tanks.gui.GarageWindowEvent;
    import logic.resource.images.ImageResource;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import com.alternativaplatform.projects.tanks.client.garage.item.ModificationInfo;
    import alternativa.tanks.locale.constants.TextConst;
    import flash.events.MouseEvent;
    import flash.display.BitmapData;
    import alternativa.osgi.service.storage.IStorageService;
    import flash.net.SharedObject;
    import alternativa.tanks.gui.PaymentWindow;
    import flash.geom.Point;
    import __AS3__.vec.*;
    import alternativa.tanks.gui.ItemInfoPanel;
    import alternativa.tanks.model.panel.PanelModel;
    import alternativa.tanks.gui.NewContainerWindow;
    import alternativa.tanks.model.garage.GarageLoadingEvent;
    import alternativa.tanks.models.battleOptions.BattleOptions;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
    import alternativa.tanks.models.battlefield.IBattleField;

    public class GarageModel extends GarageModelBase implements IGarageModelBase, IObjectLoadListener, IGarage, IItemListener, IDumper, IMoneyListener, IItemEffectListener, IResourceLoadListener
    {

        public static var itemsParams:Dictionary;
        public static var itemsInfo:Dictionary;
        public static var mounted:Vector.<String>;
        public static var buyCrystalCurrency:String;
        public static var buyCrystalRate:Number;
        public static var preparedItemId:String;

        private const HELPER_STORE:int = 2;
        private const HELPER_WAREHOUSE:int = 3;
        private const HELPER_GROUP_KEY:String = "GarageModel";

        private var dialogsLayer:DisplayObjectContainer;
        private var helpService:IHelpService;
        private var modelRegister:IModelService;
        private var resourceRegister:IResourceService;
        private var panelModel:IPanel;
        private var itemModel:IItem;
        private var clientObject:ClientObject;
        private var layer:DisplayObjectContainer;
        public var garageWindow:GarageWindow;
        private var itemsForMount:Array;
        public var mountedItems:Array;

        public var mountedWeaponId:String;
        public var mountedWeaponInfo:ItemInfo;
        public var mountedWeaponParams:ItemParams;

        public var mountedArmorId:String;
        public var mountedArmorInfo:ItemInfo;
        public var mountedArmorParams:ItemParams;

        public var mountedColormapId:String;
        public var mountedColormapInfo:ItemInfo;
        public var mountedColormapParams:ItemParams;
        
        public var mountedResistanceId:String;
        public var mountedResistanceInfo:ItemInfo;
        public var mountedResistanceParams:ItemParams;

        private var storeSelectedItem:String;
        private var warehouseSelectedItem:String;
        private var garageBoxId:Long;
        private var lockBuy:Boolean = false;
        private var lockSell:Boolean = false;
        private var lockMount:Boolean = false;
        private var lockReplace:Boolean = false;
        private var lockUpgrade:Boolean = false;
        private var storeHelper:StoreListHelper;
        private var warehouseHelper:WarehouseListHelper;
        private var confirmAlert:ConfirmAlert;
        private var itemWaitingForConfirmation:String;
        private var socket:Network;
        public var currentItemForUpdate:String;
        private var localeService:ILocaleService;
        public var kostil:Boolean = false;
        private var items:Dictionary = new Dictionary();
        private var i:int = 2;
        public static var instance:GarageModel;
        private var containerWindow:NewContainerWindow;

        public function GarageModel()
        {
            instance = this;
            _interfaces.push(IModel);
            _interfaces.push(IGarage);
            _interfaces.push(IGarageModelBase);
            _interfaces.push(IObjectLoadListener);
            _interfaces.push(IItemListener);
            _interfaces.push(IItemEffectListener);
            this.layer = Main.contentUILayer;
            itemsParams = new Dictionary();
            mounted = new Vector.<String>();
            mounted.push("");
            mounted.push("");
            mounted.push("");
            mounted.push("");
            this.resourceRegister = (Main.osgi.getService(IResourceService) as IResourceService);
            this.dialogsLayer = ((Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer);
        }
        public static function getPropertyValue(properties:Array, property:ItemProperty):String
        {
            var p:ItemPropertyValue;
            var i:int;
            while (i < properties.length)
            {
                p = (properties[i] as ItemPropertyValue);
                if (p.property == property)
                {
                    return (p.value);
                }
                i++;
            }
            return (null);
        }
        public static function getItemInfo(itemId:String):ItemInfo
        {
            return (itemsInfo[itemId]);
        }
        public static function replaceItemInfo(oldId:String, newId:String):void
        {
            var temp:ItemInfo = itemsInfo[oldId];
            temp.itemId = newId;
            itemsInfo[newId] = temp;
        }
        public static function replaceItemParams(oldId:String, newId:String):void
        {
            var temp:ItemParams = itemsParams[oldId];
            temp.baseItemId = newId;
            itemsParams[newId] = temp;
        }
        public static function getItemParams(itemId:String):ItemParams
        {
            return (itemsParams[itemId]);
        }
        public static function getItemParamsWithoutModification(itemId:String):ItemParams
        {
            for each (var i:ItemParams in itemsParams)
            {
                if (i.baseItemId.indexOf(itemId) >= 0)
                {
                    return i;
                }
            }
            return null;
        }
        public static function isTankPart(itemType:ItemTypeEnum):Boolean
        {
            return itemType == ItemTypeEnum.ARMOR || itemType == ItemTypeEnum.WEAPON || itemType == ItemTypeEnum.COLOR || itemType == ItemTypeEnum.RESISTANCE;
        }

        public function initObject(clientObject:ClientObject, country:String, rate:Number, garageBoxId:Long, networker:Network):void
        {
            this.garageBoxId = garageBoxId;
            this.localeService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            GarageModel.buyCrystalCurrency = "USD";
            GarageModel.buyCrystalRate = 5;
            this.socket = networker;
            this.objectLoaded(null);
        }
        public function objectLoaded(object:ClientObject):void
        {
            if (!this.kostil)
            {
                this.kostil = true;
                Main.writeVarsToConsoleChannel("GARAGE MODEL", "objectLoaded");
                this.clientObject = object;
                Main.stage.quality = StageQuality.HIGH;
                if (this.garageWindow == null)
                {
                    itemsInfo = new Dictionary();
                    this.mountedItems = new Array();
                    this.itemsForMount = new Array();
                    this.modelRegister = (Main.osgi.getService(IModelService) as IModelService);
                    this.itemModel = ((this.modelRegister.getModelsByInterface(IItem) as Vector.<IModel>)[0] as IItem);
                    this.panelModel = (Main.osgi.getService(IPanel) as IPanel);
                    this.garageWindow = new GarageWindow(this.garageBoxId, this);
                    this.helpService = (Main.osgi.getService(IHelpService) as IHelpService);
                    this.storeHelper = new StoreListHelper();
                    this.warehouseHelper = new WarehouseListHelper();
                    this.helpService.registerHelper(this.HELPER_GROUP_KEY, this.HELPER_STORE, this.storeHelper, true);
                    this.helpService.registerHelper(this.HELPER_GROUP_KEY, this.HELPER_WAREHOUSE, this.warehouseHelper, true);
                    Main.stage.addEventListener(Event.RESIZE, this.alignHelpers);
                    this.alignHelpers();
                }
            }
            if (object != null)
            {
                displayWindow();
            }
        }
        public function displayWindow():void
        {
            showWindow();
            panelModel.partSelected(1);
            (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).setFullAndClose(null);
            (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).hideLoaderWindow();
            (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).lockLoaderWindow();
            PanelModel(Main.osgi.getService(IPanel)).unlock();
            if (Lobby.firstInit)
            {
                Network(Main.osgi.getService(INetworker)).send("lobby;user_inited");
                Lobby.firstInit = false;
            }
            if (preparedItemId != null)
            {
                garageWindow.selectItemInStore(preparedItemId);
                preparedItemId = null;
            }
        }
        public function objectUnloaded(object:ClientObject):void
        {
            Main.writeVarsToConsoleChannel("GARAGE MODEL", "objectUnloaded");
            var moneyService:IMoneyService = (GarageModelActivator.osgi.getService(IMoneyService) as IMoneyService);
            if (moneyService != null)
            {
                moneyService.removeListener(this);
            }
            this.hideWindow();
            Main.stage.removeEventListener(Event.RESIZE, this.alignHelpers);
            this.helpService.unregisterHelper(this.HELPER_GROUP_KEY, this.HELPER_STORE);
            this.helpService.unregisterHelper(this.HELPER_GROUP_KEY, this.HELPER_WAREHOUSE);
            this.storeHelper = null;
            this.warehouseHelper = null;
            var loaderWindowService:ILoaderWindowService = (Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService);
            loaderWindowService.unlockLoaderWindow();
            this.garageWindow = null;
            this.clientObject = null;
            Main.stage.quality = StageQuality.HIGH;
        }
        public function initItem(id:String, item:ItemParams):void
        {
            this.items[id] = item;
        }
        public function initDepot(clientObject:ClientObject, itemsOnSklad:Array):void
        {
            var info:ItemInfo;
            var itemId:String;
            var itemParams:ItemParams;
            var i:int;
            while (i < itemsOnSklad.length)
            {
                info = (itemsOnSklad[i] as ItemInfo);
                itemId = info.itemId;
                itemParams = this.items[itemId];
                itemsParams[itemId] = ((itemParams == null) ? itemsParams[itemId] : itemParams);
                itemsInfo[itemId] = info;
                this.garageWindow.addItemToWarehouse(itemId, itemsParams[itemId], info);
                if (this.itemsForMount.indexOf(itemId) != -1)
                {
                    this.garageWindow.mountItem(itemId);
                    this.itemsForMount.splice(this.itemsForMount.indexOf(itemId), 1);
                    this.mountedItems.push(itemId);
                    switch (itemParams.itemType)
                    {
                        case ItemTypeEnum.WEAPON:
                            this.mountedWeaponId = itemId;
                            this.mountedWeaponInfo = info;
                            this.mountedWeaponParams = itemParams;
                            this.garageWindow.dispatchEvent(new GarageLoadingEvent(GarageLoadingEvent.COMPLETE));
                            this.objectLoaded(Game.getInstance.classObject);
                            break;
                        case ItemTypeEnum.ARMOR:
                            this.mountedArmorId = itemId;
                            this.mountedArmorInfo = info;
                            this.mountedArmorParams = itemParams;
                    }
                }
                i++;
            }
            this.garageWindow.addEventListener(GarageWindowEvent.WAREHOUSE_ITEM_SELECTED, this.onWarehouseListSelect);
            this.garageWindow.addEventListener(GarageWindowEvent.SETUP_ITEM, this.onSetupClick);
            this.garageWindow.addEventListener(GarageWindowEvent.UPGRADE_ITEM, this.onUpgradeClick);
            this.garageWindow.addEventListener(GarageWindowEvent.ADD_CRYSTALS, this.onBuyCrystalsClick);
            this.garageWindow.addEventListener(GarageWindowEvent.OPEN_CONTAINER_WINDOW, this.openContainerWindow);
            this.garageWindow.selectFirstItemInWarehouse();
        }
        public function initMarket(clientObject:ClientObject, itemsOnMarket:Array):void
        {
            var info:ItemInfo;
            var itemId:String;
            var itemParams:ItemParams;
            Main.writeVarsToConsoleChannel("GARAGE MODEL", ("initMarket itemsOnMarket: " + itemsOnMarket));
            this.modelRegister = (Main.osgi.getService(IModelService) as IModelService);
            var i:int;
            while (i < itemsOnMarket.length)
            {
                info = (itemsOnMarket[i] as ItemInfo);
                itemId = info.itemId;
                itemParams = this.items[itemId];
                itemsParams[itemId] = itemParams;
                if ((!(itemParams.inventoryItem)))
                {
                    itemsInfo[itemId] = info;
                }
                else
                {
                    itemsInfo[itemId] = info;
                }
                this.garageWindow.addItemToWarehouse(itemId, itemParams, null, info.discount);
                i++;
            }
            this.garageWindow.addEventListener(GarageWindowEvent.STORE_ITEM_SELECTED, this.onStoreListSelect);
            this.garageWindow.addEventListener(GarageWindowEvent.BUY_ITEM, this.onBuyClick);
        }
        public function crystalsChanged(value:int):void
        {
            var id:String;
            Main.writeVarsToConsoleChannel("GARAGE MODEL", "crystalsChanged: %1", value);
            if ((((((!(this.lockBuy)) && (!(this.lockMount))) && (!(this.lockReplace))) && (!(this.lockSell))) && (!(this.lockUpgrade))))
            {
                id = this.garageWindow.selectedItemId;
                if (id != null)
                {
                    if (this.garageWindow.storeItemSelected)
                    {
                        this.garageWindow.selectItemInStore(id);
                    }
                    else
                    {
                        this.garageWindow.selectItemInWarehouse(id);
                    }
                }
            }
        }
        public function itemLoaded(item:ClientObject, params:ItemParams):void
        {
            Main.writeVarsToConsoleChannel("GARAGE MODEL", (("itemLoaded (" + item.id) + ")"));
            itemsParams[item.id] = params;
        }
        private function onWarehouseListSelect(e:GarageWindowEvent):void
        {
            var itemId:String = e.itemId;
            var HD:Boolean = (!(itemId.indexOf("HD_") == -1));
            if (HD)
            {
                itemId = itemId.replace("HD_", "");
            }
            this.warehouseSelectedItem = itemId;
            var params:ItemParams = (itemsParams[itemId] as ItemParams);
            var info:ItemInfo = (itemsInfo[itemId] as ItemInfo);
            var itemType:ItemTypeEnum = params.itemType;
            this.garageWindow.showItemInfo(itemId, params, false, info, this.mountedItems);
            if(itemType == ItemTypeEnum.ARMOR || itemType == ItemTypeEnum.WEAPON || itemType == ItemTypeEnum.COLOR || itemType == ItemTypeEnum.RESISTANCE)
            {
                if (((!(this.mountedItems.indexOf(itemId) == -1)) || (!(this.mountedItems.indexOf(("HD_" + itemId)) == -1))))
                {
                    this.garageWindow.lockMountButton();
                }
                else
                {
                    this.garageWindow.unlockMountButton();
                    var battle:BattlefieldModel = BattlefieldModel(Main.osgi.getService(IBattleField));
                    if (battle != null)
                    {
                        if (battle.bfData != null)
                        {
                            var battleOptions:Object = battle.bfData.bfObject.getParams(BattleOptions);
                            if (battleOptions.equipmentChange == false)
                            {
                                this.garageWindow.lockMountButton();
                            }
                            else
                            {
                                this.garageWindow.unlockMountButton();
                            }
                        }
                    }
                }
            }
        }
        private function onStoreListSelect(e:GarageWindowEvent):void
        {
            var itemId:String = e.itemId;
            this.storeSelectedItem = itemId;
            var params:ItemParams = (itemsParams[itemId] as ItemParams);
            var itemType:ItemTypeEnum = params.itemType;
            var info:ItemInfo = (itemsInfo[itemId] as ItemInfo);
            this.garageWindow.showItemInfo(itemId, params, true, info);
        }
        private function onSetupClick(e:GarageWindowEvent):void
        {
            if ((!(this.lockMount)))
            {
                this.lockMount = true;
                Main.writeVarsToConsoleChannel("GARAGE MODEL", "tryMountItem");
                this.tryMountItem(this.clientObject, this.warehouseSelectedItem);
            }
        }
        public function tryMountItem(client:ClientObject, id:String):void
        {
            Network(Main.osgi.getService(INetworker)).send(("garage;try_mount_item;" + id));
        }
        private function onOpenItemClick(e:GarageWindowEvent):void
        {
            Network(Main.osgi.getService(INetworker)).send(("lobby;try_open_item;" + this.warehouseSelectedItem));
        }
        private function onBuyClick(e:GarageWindowEvent):void
        {
            var itemParams:ItemParams;
            var previewId:String;
            var resource:ImageResource;
            if ((!(this.lockBuy)))
            {
                this.itemWaitingForConfirmation = e.itemId;
                itemParams = (itemsParams[e.itemId] as ItemParams);
                previewId = itemParams.previewId;
                resource = (ResourceUtil.getResource(ResourceType.IMAGE, (previewId + "_preview")) as ImageResource);
                this.showConfirmAlert(itemParams.name, ((itemParams.itemType == ItemTypeEnum.INVENTORY) ? int((itemParams.price * this.garageWindow.itemInfoPanel.inventoryNumStepper.value)) : int(itemParams.price)), resource, true, (((itemParams.itemType == ItemTypeEnum.ARMOR) || (itemParams.itemType == ItemTypeEnum.WEAPON)) ? int(0) : int(-1)), ((itemParams.itemType == ItemTypeEnum.INVENTORY) ? int(this.garageWindow.itemInfoPanel.inventoryNumStepper.value) : int(-1)));
            }
        }
        private function onUpgradeClick(e:GarageWindowEvent):void
        {
            var itemParams:ItemParams;
            var mods:Array;
            var nextModIndex:int;
            var modInfo:ModificationInfo;
            var previewId:String;
            var resource:ImageResource;
            if ((!(this.lockUpgrade)))
            {
                this.itemWaitingForConfirmation = e.itemId;
                itemParams = (itemsParams[e.itemId] as ItemParams);
                mods = itemParams.modifications;
                nextModIndex = (itemParams.modificationIndex + 1);
                modInfo = ModificationInfo(mods[nextModIndex]);
                previewId = modInfo.previewId;
                resource = (ResourceUtil.getResource(ResourceType.IMAGE, (previewId + "_preview")) as ImageResource);
                this.showConfirmAlert(itemParams.name, itemParams.nextModificationPrice, resource, false, nextModIndex);
            }
        }
        public function openContainerWindow(e:GarageWindowEvent):void
        {
            // var itemInfo:ItemInfo = itemsInfo[e.itemId];
            // this.containerWindow = new NewContainerWindow(e.itemId, itemInfo.count);
            // Main.writeVarsToConsoleChannel("GARAGE WINDOW", "S -> C openContainerWindow");
            // panelModel.blur();
            // Main.dialogsLayer.addChild(this.containerWindow);
            // Main.stage.addEventListener(Event.RESIZE, this.alignContainerWindow);
            // this.alignContainerWindow();
            // this.containerWindow.closeButton.addEventListener(MouseEvent.CLICK, this.closeContainerWindow);
            Network(Main.osgi.getService(INetworker)).send(("lobby;try_open_item;" + this.warehouseSelectedItem));
        }
        private function closeContainerWindow(e:MouseEvent = null):void
        {
            this.containerWindow.closeButton.removeEventListener(MouseEvent.CLICK, this.closeContainerWindow);
            Main.stage.removeEventListener(Event.RESIZE, this.alignContainerWindow);
            this.dialogsLayer.removeChild(this.containerWindow);
            this.containerWindow = null;
            panelModel.unblur();
        }
        private function alignContainerWindow(e:Event = null):void
        {
            this.containerWindow.x = Math.round(((Main.stage.stageWidth - this.containerWindow.windowSize.x) * 0.5));
            this.containerWindow.y = Math.round(((Main.stage.stageHeight - this.containerWindow.windowSize.y) * 0.5));
        }
        private function showConfirmAlert(name:String, cost:int, previewBd:ImageResource, buyAlert:Boolean, modIndex:int, inventoryNum:int = -1):void
        {
            this.panelModel.blur();
            this.confirmAlert = new ConfirmAlert(name, cost, previewBd, buyAlert, modIndex, ((!(!(buyAlert))) ? this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_BUY_QEUSTION_TEXT) : this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_UPGRADE_QEUSTION_TEXT)), inventoryNum);
            this.dialogsLayer.addChild(this.confirmAlert);
            this.confirmAlert.confirmButton.addEventListener(MouseEvent.CLICK, ((!(!(buyAlert))) ? this.onBuyAlertConfirm : this.onUpgradeAlertConfirm));
            this.confirmAlert.cancelButton.addEventListener(MouseEvent.CLICK, this.hideConfirmAlert);
            this.alignConfirmAlert();
            Main.stage.addEventListener(Event.RESIZE, this.alignConfirmAlert);
            if (((!(previewBd == null)) && (!(previewBd.loaded()))))
            {
                previewBd.completeLoadListener = this;
                previewBd.load();
            }
        }
        public function resourceLoaded(resource:Object):void
        {
            if (((!(this.confirmAlert == null)) && (this.dialogsLayer.contains(this.confirmAlert))))
            {
                this.confirmAlert.setPreview((resource.bitmapData as BitmapData));
            }
        }
        public function resourceUnloaded(resourceId:Long):void
        {
        }
        private function alignConfirmAlert(e:Event = null):void
        {
            this.confirmAlert.x = Math.round(((Main.stage.stageWidth - this.confirmAlert.width) * 0.5));
            this.confirmAlert.y = Math.round(((Main.stage.stageHeight - this.confirmAlert.height) * 0.5));
        }
        private function hideConfirmAlert(e:MouseEvent = null):void
        {
            Main.stage.removeEventListener(Event.RESIZE, this.alignConfirmAlert);
            this.dialogsLayer.removeChild(this.confirmAlert);
            this.panelModel.unblur();
            this.confirmAlert = null;
        }
        private function onBuyAlertConfirm(e:MouseEvent):void
        {
            this.hideConfirmAlert();
            this.lockBuy = true;
            Main.writeVarsToConsoleChannel("GARAGE MODEL", "tryBuyItem");
            if ((itemsParams[this.itemWaitingForConfirmation] as ItemParams).itemType == ItemTypeEnum.INVENTORY)
            {
                this.tryBuyItem(this.clientObject, this.itemWaitingForConfirmation, this.garageWindow.itemInfoPanel.inventoryNumStepper.value);
            }
            else
            {
                this.tryBuyItem(this.clientObject, this.itemWaitingForConfirmation, 1);
            }
        }
        public function tryBuyItem(c:ClientObject, id:String, count:int):void
        {
            Network(Main.osgi.getService(INetworker)).send(((("garage;try_buy_item;" + id) + ";") + count));
        }
        private function onUpgradeAlertConfirm(e:MouseEvent):void
        {
            this.hideConfirmAlert();
            this.lockUpgrade = true;
            Main.writeVarsToConsoleChannel("GARAGE MODEL", "tryUpgradeItem");
            this.tryUpgradeItem(this.clientObject, this.itemWaitingForConfirmation);
        }
        public function tryUpgradeItem(client:ClientObject, id:String):void
        {
            this.currentItemForUpdate = id;
            Network(Main.osgi.getService(INetworker)).send(("garage;try_update_item;" + id));
        }
        public function onBuyCrystalsClick(e:GarageWindowEvent):void
        {
            var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
            storage.data.paymentLastInputValue = Math.abs(this.garageWindow.itemInfoPanel.requiredCrystalsNum);
            var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            if (((storage.data.paymentSystemType == null) || (storage.data.paymentSystemType == PaymentWindow.SYSTEM_TYPE_SMS)))
            {
                storage.data.paymentSystemType = ((localeService.language == "ru") ? PaymentWindow.SYSTEM_TYPE_QIWI : PaymentWindow.SYSTEM_TYPE_VISA);
            }
            storage.flush();
            this.panelModel.goToPayment();
        }
        public function mountItem(clientObject:ClientObject, itemToUnmountId:String, itemToMountId:String, skinDataId:String, keepSkin:Boolean = false):void
        {
            var toLoad:Vector.<String>;
            var index:int;
            var bar3xQuickSet:Boolean;
            var skinToEquip:String;
            if (skinDataId != null)
            {
                skinToEquip = skinDataId;
            }
            else
            {
                skinToEquip = itemToMountId;
            }
            if (itemToUnmountId != null)
            {
                index = this.mountedItems.indexOf(itemToUnmountId);
                if (index != -1)
                {
                    if (itemsParams[itemToUnmountId] != null)
                    {
                        this.garageWindow.unmountItem(itemToUnmountId);
                    }
                    this.mountedItems.splice(index, 1);
                }
            }
            else
            {
                bar3xQuickSet = true;
            }
            var params:ItemParams = itemsParams[itemToMountId];
            if (((!(params == null)) && (!(this.garageWindow == null))))
            {
                this.garageWindow.mountItem(itemToMountId);
                this.mountedItems.push(itemToMountId);
                if ((((params.itemType == ItemTypeEnum.WEAPON) || (params.itemType == ItemTypeEnum.ARMOR)) || (params.itemType == ItemTypeEnum.COLOR)|| (params.itemType == ItemTypeEnum.RESISTANCE)))
                {
                    switch (params.itemType)
                    {
                        case ItemTypeEnum.WEAPON:
                            this.objectLoaded(Game.getInstance.classObject);
                            this.mountedWeaponId = itemToMountId;
                            mounted[0] = this.mountedWeaponId;
                            this.mountedWeaponInfo = itemsInfo[itemToMountId];
                            this.mountedWeaponParams = params;
                            this.setTurret(skinToEquip);
                            this.garageWindow.dispatchEvent(new GarageLoadingEvent(GarageLoadingEvent.COMPLETE));
                            if (ItemInfoPanel.skinButton != null)
                            {
                                this.garageWindow.itemInfoPanel.updateSkinButton(params);
                            }
                            if (ItemInfoPanel.shotEffectsButton != null)
                            {
                                this.garageWindow.itemInfoPanel.updateShotEffectsButton(params);
                            }
                            break;
                        case ItemTypeEnum.ARMOR:
                            this.mountedArmorId = itemToMountId;
                            mounted[1] = this.mountedArmorId;
                            this.mountedArmorInfo = itemsInfo[itemToMountId];
                            this.mountedArmorParams = itemsParams[itemToMountId];
                            this.setHull(skinToEquip);
                            break;
                        case ItemTypeEnum.COLOR:
                            this.mountedColormapId = itemToMountId;
                            mounted[2] = this.mountedColormapId;
                            this.mountedColormapInfo = itemsInfo[itemToMountId];
                            this.mountedColormapParams = itemsParams[itemToMountId];
                            toLoad = new Vector.<String>();
                            toLoad.push(itemToMountId);
                            ResourceUtil.addEventListener(function():void
                                {
                                    setColorMap((ResourceUtil.getResource(ResourceType.IMAGE, itemToMountId) as ImageResource));
                                });
                            ResourceUtil.loadGraphics(toLoad);
                        case ItemTypeEnum.RESISTANCE:
                            this.mountedResistanceId = itemToMountId;
                            mounted[3] = this.mountedResistanceId;
                            this.mountedResistanceInfo = itemsInfo[itemToMountId];
                            this.mountedResistanceParams = itemsParams[itemToMountId];
                            toLoad = new Vector.<String>();
                            toLoad.push(itemToMountId);
                    }
                }
            }
            else
            {
                this.itemsForMount.push(itemToMountId);
            }
            if (((this.garageWindow.selectedItemId == itemToMountId) || (this.garageWindow.selectedItemId == itemToMountId.replace("HD_", ""))))
            {
                this.garageWindow.selectItemInWarehouse(itemToMountId.replace("HD_", ""));
                this.garageWindow.lockMountButton();
            }
            this.lockMount = false;
        }
        public function removeItemFromStore(id:String):void
        {
            this.garageWindow.removeItemFromStore(id);
            this.garageWindow.unselectInStore();
            this.garageWindow.selectFirstItemInWarehouse();
        }
        public function buyItem(clientObject:ClientObject, info:ItemInfo):void
        {
            var itemId:String = info.itemId;
            var p:ItemParams = this.items[itemId];
            if(p == null){
                return;
            }
            p.store = false;
            this.garageWindow.buyUpdate(itemId);
            if (itemId.indexOf("HD_") != -1)
            {
                itemsInfo[itemId] = info;
                this.garageWindow.addSkin(itemId, itemsParams[itemId]);
                this.garageWindow.removeItemFromStore(itemId);
                this.garageWindow.addItemToWarehouse(itemId, p, info);
                this.tryMountItem(clientObject, itemId);
            }
            else
            {
                if ((!(p.inventoryItem)))
                {
                    itemsInfo[itemId] = info;
                    this.garageWindow.removeItemFromStore(itemId);
                    this.garageWindow.addItemToWarehouse(itemId, p, info);
                    this.garageWindow.unselectInStore();
                    this.garageWindow.selectItemInWarehouse(itemId);
                }
                else
                {
                    if (itemsInfo[itemId] != null)
                    {
                        itemsInfo[itemId] = info;
                    }
                    else
                    {
                        itemsInfo[itemId] = info;
                        if (info.addable)
                        {
                            this.garageWindow.removeItemFromStore(itemId);
                            this.garageWindow.addItemToWarehouse(itemId, p, info);
                            this.garageWindow.unselectInStore();
                        }
                    }
                    if (info.addable)
                    {
                        this.garageWindow.selectItemInWarehouse(itemId);
                    }
                }
            }
            if (info.addable)
            {
                this.garageWindow.scrollToItemInWarehouse(itemId);
            }
            this.lockBuy = false;
        }
        public function decreaseCountItems(itemId:String):void
        {
            itemsInfo[itemId].count--;
            this.garageWindow.selectItemInWarehouse(itemId);
        }
        public function removeItemFromWarehouse(itemId:String):void
        {
            this.garageWindow.removeItemFromWarehouse(itemId);
            this.garageWindow.selectFirstItemInWarehouse();
            this.garageWindow.addItemToStore(itemId, this.items[itemId], itemsInfo[itemId]);
            itemsInfo[itemId] = null;
        }
        public function upgradeItem(clientObject:ClientObject, oldItem:String, newItemInfo:ItemInfo):void
        {
            Main.writeVarsToConsoleChannel("GARAGE MODEL", ("upgradeItem oldItem: " + (itemsParams[oldItem] as ItemParams).name));
            Main.writeVarsToConsoleChannel("GARAGE MODEL", ("upgradeItem newItemInfo: " + newItemInfo));
            var newItem:String = newItemInfo.itemId;
            itemsInfo[newItem] = newItemInfo;
            this.garageWindow.removeItemFromWarehouse(oldItem);
            var index:int = this.mountedItems.indexOf(oldItem);
            if (index != -1)
            {
                this.mountedItems.splice(index, 1);
            }
            var params:ItemParams = itemsParams[newItem];
            params.modificationIndex = parseInt(newItemInfo.itemId.charAt(newItemInfo.itemId.length - 1));
            params.nextModificationPrice = params.modifications[((params.modificationIndex >= 3) ? params.modificationIndex : (params.modificationIndex + 1))].crystalPrice;
            params.nextModificationProperties = params.modifications[((params.modificationIndex >= 3) ? params.modificationIndex : (params.modificationIndex + 1))].itemProperties;
            params.nextModificationRankId = params.modifications[((params.modificationIndex >= 3) ? params.modificationIndex : (params.modificationIndex + 1))].rankId;
            params.microUpgradePrice = 100;
            params.microUpgrades = 0;
            this.garageWindow.addItemToWarehouse(newItem, itemsParams[newItem], itemsInfo[newItem]);
            this.garageWindow.selectItemInWarehouse(newItem);
            this.warehouseSelectedItem = newItem;
            this.lockUpgrade = false;
            if (params.itemType == ItemTypeEnum.ARMOR || params.itemType == ItemTypeEnum.WEAPON)
            {
                this.tryMountItem(null, params.baseItemId);
            }
        }
        public function setHull(resource:String):void
        {
            var toLoad:Vector.<String> = new Vector.<String>();
            toLoad.push((resource + "_details"));
            toLoad.push((resource + "_lightmap"));
            if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
            {
                ResourceUtil.addEventListener(function():void
                    {
                        garageWindow.tankPreview.setHull(resource);
                    });
            }
            ResourceUtil.loadGraphics(toLoad);
        }
        public function setTurret(resource:String):void
        {
            var toLoad:Vector.<String> = new Vector.<String>();
            toLoad.push((resource + "_details"));
            toLoad.push((resource + "_lightmap"));
            if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
            {
                ResourceUtil.addEventListener(function():void
                    {
                        garageWindow.tankPreview.setTurret(resource);
                    });
            }
            ResourceUtil.loadGraphics(toLoad);
        }
        public function setColorMap(map:ImageResource):void
        {
            if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
            {
                this.garageWindow.tankPreview.setColorMap(map);
            }
        }
        public function setResistance(map:ImageResource) : void
        {
            this.garageWindow.tankPreview.setResistance(map);
        }
        public function setTimeRemaining(itemId:String, time:Number):void
        {
            var date:Date = new Date(time);
            Main.writeVarsToConsoleChannel("TIME INDICATOR", (((" incoming time " + time) + " : ") + date));
            if (this.garageWindow != null)
            {
                if ((((!(this.garageWindow.selectedItemId == null)) && (!(this.garageWindow.storeItemSelected))) && (itemId == this.garageWindow.selectedItemId)))
                {
                    this.garageWindow.itemInfoPanel.timeRemaining = date;
                }
            }
        }
        public function effectStopped(itemId:String):void
        {
            var info:ItemInfo;
            if (this.garageWindow != null)
            {
                this.garageWindow.removeItemFromWarehouse(itemId);
                if (((itemsParams[itemId] as ItemParams) && ((itemsParams[itemId] as ItemParams).price > 0)))
                {
                    info = (itemsInfo[itemId] as ItemInfo);
                    this.garageWindow.addItemToStore(itemId, itemsParams[itemId], info);
                    this.garageWindow.selectItemInStore(itemId);
                    this.garageWindow.scrollToItemInStore(itemId);
                }
            }
        }
        private function showWindow():void
        {
            if (this.garageWindow != null)
            {
                if (!(this.layer.contains(this.garageWindow)))
                {
                    Main.contentUILayer.addChild(this.garageWindow);
                    Main.stage.addEventListener(Event.RESIZE, this.alignWindow);
                    this.alignWindow();
                    this.garageWindow.completeLoading();
                }
            }
        }
        private function hideWindow():void
        {
            if (this.layer.contains(this.garageWindow))
            {
                this.garageWindow.hide();
                this.layer.removeChild(this.garageWindow);
                Main.stage.removeEventListener(Event.RESIZE, this.alignWindow);
            }
        }
        private function alignWindow(e:Event = null):void
        {
            var minWidth:int = int(Math.max(1000, Main.stage.stageWidth));
            if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
            {
                this.garageWindow.resize(Math.round(((minWidth * 2) / 3)), Math.max((Main.stage.stageHeight - 60), 530));
                this.garageWindow.x = Math.round((minWidth / 3));
            }
            else
            {
                this.garageWindow.resize(Math.round(((minWidth * 2) / 2)), Math.max((Main.stage.stageHeight - 60), 530));
                this.garageWindow.x = 0;
            }
            this.garageWindow.y = 60;
        }
        public function dump(params:Vector.<String>):String
        {
            var s:String = "\n";
            s = (s + "\n   ARMOR: ");
            s = (s + "\n");
            s = (s + "\n   WEAPON: ");
            s = (s + "\n");
            return (s);
        }
        public function get dumperName():String
        {
            return ("mounted");
        }
        private function alignHelpers(e:Event = null):void
        {
            var minWidth:int = int(Math.max(1000, Main.stage.stageWidth));
            var minHeight:int = int(Math.max(600, Main.stage.stageHeight));
            this.warehouseHelper.targetPoint = new Point((Math.round((minWidth * (1 / 3))) + 20), ((minHeight - (169 * 2)) + 27));
            this.storeHelper.targetPoint = new Point((Math.round((minWidth * (1 / 3))) + 20), ((minHeight - 169) + 27));
        }

    }
}
