package alternativa.tanks.gui
{
    import alternativa.tanks.gui.category.CategoryButtonsList;
    import alternativa.tanks.gui.category.CategoryButtonsListEvent;
    import flash.display.Sprite;
    import flash.geom.Point;
    import alternativa.service.IResourceService;
    import alternativa.service.IModelService;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.tanks.model.GarageModel;
    import forms.garage.buttons.MainMenu;
    import controls.TankWindow;
    import controls.TankWindowInner;
    import forms.garage.PartsList;
    import alternativa.init.Main;
    import forms.events.PartsListEvent;
    import flash.events.MouseEvent;
    import alternativa.types.Long;
    import flash.events.Event;
    import alternativa.tanks.model.panel.IPanel;
    import projects.tanks.client.commons.types.ItemViewCategoryEnum;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import logic.resource.images.ImageResource;
    import alternativa.tanks.model.ItemParams;
    import com.alternativaplatform.projects.tanks.client.garage.garage.ItemInfo;
    import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;
    import flash.display.BitmapData;
    import alternativa.tanks.model.panel.PanelModel;
    import alternativa.tanks.model.garage.GarageLoadingEvent;
    import forms.events.MainButtonBarEvents;

    public class GarageWindow extends Sprite
    {

        private const windowMargin:int = 11;
        private const buttonSize:Point = new Point(104, 33);
        public const itemInfoPanelWidth:int = 412;

        private var resourceRegister:IResourceService;
        private var modelRegister:IModelService;
        private var localeService:ILocaleService;
        private var windowSize:Point;
        private var garageModel:GarageModel;
        private var menu:CategoryButtonsList;
        private var myItemsWindow:TankWindow;
        private var myItemsInner:TankWindowInner;
        private var warehouseList:PartsList;
        private var shopItemsWindow:TankWindow;
        private var shopItemsInner:TankWindowInner;
        public var itemInfoPanel:ItemInfoPanel;
        public var inventorySelected:Boolean;
        public var storeItemSelected:Boolean;
        public var selectedItemId:String;
        private var itemsInWarehouse:Array;
        private var itemsInStore:Array;
        public var tankPreview:TankPreview;
        public var myTurrets:Array = new Array();
        public var myHulls:Array = new Array();
        public var myColormaps:Array = new Array();
        public var myResistance:Array = new Array();
        public var mySpecialItems:Array = new Array();
        public var myInventory:Array = new Array();
        public var storeTurrets:Array = new Array();
        public var storeHulls:Array = new Array();
        public var storeColormaps:Array = new Array();
        public var storeResistance:Array = new Array();
        public var storeInventory:Array = new Array();
        public var storeKits:Array = new Array();
        public var storeSpecial:Array = new Array();
        private var i:int = 0;
        private var j:int = 0;

        public function GarageWindow(garageBoxId:Long, model:GarageModel)
        {
            this.garageModel = model;
            this.resourceRegister = (Main.osgi.getService(IResourceService) as IResourceService);
            this.modelRegister = (Main.osgi.getService(IModelService) as IModelService);
            this.localeService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            this.itemsInWarehouse = new Array();
            this.itemsInStore = new Array();
            this.windowSize = new Point(880, 737);
            if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
            {
                this.tankPreview = new TankPreview(garageBoxId, 10);
                addChild(this.tankPreview);
            }
            else
            {
                PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.closeButton.visible = false;
                PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.closeButton1.visible = true;
            }
            this.itemInfoPanel = new ItemInfoPanel();
            addChild(this.itemInfoPanel);
            this.myItemsWindow = new TankWindow();
            addChild(this.myItemsWindow);
            this.myItemsInner = new TankWindowInner(0, 0, TankWindowInner.GREEN);
            this.myItemsInner.showBlink = true;
            addChild(this.myItemsInner);
            this.warehouseList = new PartsList();
            addChild(this.warehouseList);
            this.warehouseList.addEventListener(PartsListEvent.SELECT_PARTS_LIST_ITEM, this.onWarehouseItemSelect);
            this.itemInfoPanel.buttonBuy.addEventListener(MouseEvent.CLICK, this.onButtonBuyClick);
            this.itemInfoPanel.buttonOpenContainer.addEventListener(MouseEvent.CLICK, this.onButtonOpenContainerClick);
            this.itemInfoPanel.buttonOpenShop.addEventListener(MouseEvent.CLICK, this.onButtonOpenShopClick);
            this.itemInfoPanel.buttonEquip.addEventListener(MouseEvent.CLICK, this.onButtonEquipClick);
            this.itemInfoPanel.buttonSkin.addEventListener(MouseEvent.CLICK, this.onSkinButtonClick);
            this.itemInfoPanel.buttonUpgrade.addEventListener(MouseEvent.CLICK, this.onModButtonClick);
            this.itemInfoPanel.buttonBuyCrystals.addEventListener(MouseEvent.CLICK, this.onButtonBuyCrystalsClick);
            this.menu = new CategoryButtonsList();
            addChild(this.menu);

            this.menu.addEventListener(CategoryButtonsListEvent.CATEGORY_SELECTED, this.onCategoryButtonsSelected);

        }
        private function onCategoryButtonsSelected(param1:CategoryButtonsListEvent):void
        {
            this.showCategory(param1.getCategory());
        }
        public function completeLoading():void
        {
            addEventListener(GarageLoadingEvent.COMPLETE, this.finishGarageLoading);
        }
        public function showCategory(param1:ItemViewCategoryEnum):void
        {
            switch (param1)
            {
                case ItemViewCategoryEnum.WEAPON:
                    this.showTurrets(null);
                    break;
                case ItemViewCategoryEnum.ARMOR:
                    this.showHulls(null);
                    break;
                case ItemViewCategoryEnum.PAINT:
                    this.showColormaps(null);
                    break;
                    // case ItemViewCategoryEnum.DRONE:
                    // // this.garageModel.openContainerWindow();
                    // break;
                case ItemViewCategoryEnum.KIT:
                    this.showKits(null);
                    break;
                case ItemViewCategoryEnum.SPECIAL:
                    this.showSpecial(null);
                    break;
                case ItemViewCategoryEnum.INVENTORY:
                    this.showInventory(null);
                    break;
                case ItemViewCategoryEnum.RESISTANCE:
                    this.showResistance(null);
                    break;
            }
        }

        private function finishGarageLoading(e:Event):void
        {
            removeEventListener(GarageLoadingEvent.COMPLETE, this.finishGarageLoading);
            this.showTurrets(null);
        }
        private function showTurrets(e:Event = null):void
        {
            this.removeaItemFromWarehouse();
            this.garageModel.initMarket(null, this.storeTurrets);
            this.garageModel.initDepot(null, this.myTurrets);
            this.mountItem(this.garageModel.mountedWeaponId);
            this.selectItemInWarehouse(this.garageModel.mountedWeaponId);
            this.resize(this.windowSize.x, this.windowSize.y);
        }
        private function showHulls(e:Event):void
        {
            this.removeaItemFromWarehouse();
            this.garageModel.initMarket(null, this.storeHulls);
            this.garageModel.initDepot(null, this.myHulls);
            this.mountItem(this.garageModel.mountedArmorId);
            this.selectItemInWarehouse(this.garageModel.mountedArmorId);
            this.resize(this.windowSize.x, this.windowSize.y);
        }
        private function showColormaps(e:Event):void
        {
            this.removeaItemFromWarehouse();
            this.garageModel.initMarket(null, this.storeColormaps);
            this.garageModel.initDepot(null, this.myColormaps);
            this.mountItem(this.garageModel.mountedColormapId);
            this.selectItemInWarehouse(this.garageModel.mountedColormapId);
            this.resize(this.windowSize.x, this.windowSize.y);
        }
        private function showInventory(e:Event):void
        {
            this.removeaItemFromWarehouse();
            this.garageModel.initMarket(null, this.storeInventory);
            this.garageModel.initDepot(null, this.myInventory);
            this.resize(this.windowSize.x, this.windowSize.y);
        }
        private function showKits(e:Event):void
        {
            this.removeaItemFromWarehouse();
            this.garageModel.initMarket(null, this.storeKits);
            this.resize(this.windowSize.x, this.windowSize.y);
        }
        private function showSpecial(e:Event):void
        {
            this.removeaItemFromWarehouse();
            this.garageModel.initDepot(null, this.mySpecialItems);
            this.resize(this.windowSize.x, this.windowSize.y);
        }
        private function showResistance(e:Event):void
        {
            this.removeaItemFromWarehouse();
            this.garageModel.initMarket(null, this.storeResistance);
            this.garageModel.initDepot(null, this.myResistance);
            this.mountItem(this.garageModel.mountedResistanceId);
            this.selectItemInWarehouse(this.garageModel.mountedResistanceId);
            this.resize(this.windowSize.x, this.windowSize.y);
        }
        public function buyUpdate(id:String):void
        {
            var i:int;
            i = 0;
            while (i < this.storeTurrets.length)
            {
                if (this.storeTurrets[i].itemId == id)
                {
                    this.myTurrets.push(this.storeTurrets[i]);
                    this.storeTurrets.splice(i, 1);
                    this.warehouseList.deleteItem(id);
                }
                i++;
            }
            i = 0;
            while (i < this.storeHulls.length)
            {
                if (this.storeHulls[i].itemId == id)
                {
                    this.myHulls.push(this.storeHulls[i]);
                    this.storeHulls.splice(i, 1);
                    this.warehouseList.deleteItem(id);
                }
                i++;
            }
            i = 0;
            while (i < this.storeColormaps.length)
            {
                if (this.storeColormaps[i].itemId == id)
                {
                    this.myColormaps.push(this.storeColormaps[i]);
                    this.storeColormaps.splice(i, 1);
                    this.warehouseList.deleteItem(id);
                }
                i++;
            }
            i = 0;
            while (i < this.storeKits.length)
            {
                if (this.storeKits[i].itemId == id)
                {
                    this.storeKits.splice(i, 1);
                    this.warehouseList.deleteItem(id);
                }
                i++;
            }
            i = 0;
            while (i < this.storeSpecial.length)
            {
                if (this.storeSpecial[i].itemId == id)
                {
                    this.storeSpecial.splice(i, 1);
                    this.warehouseList.deleteItem(id);
                }
                i++;
            }
            i = 0;
            while (i < this.storeResistance.length)
            {
                if (this.storeResistance[i].itemId == id)
                {
                    this.myResistance.push(this.storeResistance[i]);
                    this.storeResistance.splice(i, 1);
                    this.warehouseList.deleteItem(id);
                }
                i++;
            }
        }
        public function hide():void
        {
            if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
            {
                this.tankPreview.hide();
            }
            this.itemInfoPanel.hide();
            this.tankPreview = null;
            this.itemInfoPanel = null;
            this.resourceRegister = null;
            this.modelRegister = null;
            this.myItemsWindow = null;
            this.myItemsInner = null;
            this.warehouseList = null;
            this.shopItemsWindow = null;
            this.shopItemsInner = null;
            this.selectedItemId = null;
            this.itemsInWarehouse = null;
            this.itemsInStore = null;
        }
        public function resize(width:int, height:int):void
        {
            var leftHeaderWidth:int;
            this.windowSize = new Point(width, height);
            leftHeaderWidth = int((int(Math.max(100, Main.stage.stageWidth)) / 3));
            this.myItemsWindow.height = 205;
            this.myItemsInner.height = (169 - (this.windowMargin * 2));
            this.warehouseList.height = ((169 - (this.windowMargin * 2)) + 1);
            if (!PanelModel(Main.osgi.getService(IPanel)).isInBattle)
            {
                this.tankPreview.resize((width - this.itemInfoPanelWidth), (height - this.myItemsWindow.height), this.x, this.y);
                this.myItemsWindow.width = width;
                this.myItemsInner.width = (width - (this.windowMargin * 2));
                this.myItemsInner.x = this.windowMargin;
                this.warehouseList.width = ((this.myItemsWindow.width - (this.windowMargin * 2)) - 8);
                this.warehouseList.x = (this.windowMargin + 4);
                this.menu.x = (this.windowMargin + 4);
            }
            else
            {
                this.myItemsWindow.width = width;
                this.myItemsInner.width = (width - (this.windowMargin * 2));
                this.myItemsInner.x = this.windowMargin;
                this.warehouseList.width = ((this.myItemsWindow.width - (this.windowMargin * 2)) - 8);
                this.warehouseList.x = (this.windowMargin + 4);
                this.menu.x = (this.windowMargin + 4);
            }
            this.itemInfoPanel.resize(this.itemInfoPanelWidth, (height - this.myItemsWindow.height));
            this.itemInfoPanel.x = (width - this.itemInfoPanelWidth);
            this.myItemsWindow.y = (height - this.myItemsWindow.height);
            this.myItemsInner.y = (this.myItemsWindow.y + 12);
            this.warehouseList.y = (this.myItemsInner.y + 4);
            this.menu.y = (this.warehouseList.y + this.warehouseList.height);
            this.menu.width = width - this.windowMargin * 2 - 8;
        }
        public function selectFirstItemInWarehouse():void
        {
            this.warehouseList.selectByIndex(0);
        }
        public function selectItemInWarehouse(itemId:String):void
        {
            if (itemId.indexOf("HD_") != -1)
            {
                // TODO remove it
                itemId = itemId.replace("HD_", "");
            }
            this.warehouseList.select(itemId);
        }
        public function unselectInWarehouse():void
        {
            this.warehouseList.unselect();
        }
        public function selectItemInStore(itemId:String):void
        {
        }
        public function unselectInStore():void
        {
        }
        public function addItemToWarehouse(itemId:String, itemParams:ItemParams, itemInfo:ItemInfo, discount:int = 0):void
        {
            var panelModel:IPanel;
            var userRank:int;
            this.itemsInWarehouse.push(itemId);

            var resource:ImageResource = (ResourceUtil.getResource(ResourceType.IMAGE, (itemId + "_preview")) as ImageResource);
            if (itemInfo != null)
            {
                this.warehouseList.addItem(itemId, itemParams.name, itemParams.itemType, itemParams.itemIndex, itemParams.price, discount, itemParams.rankId, false, true, itemInfo.count, resource, true, itemParams.modificationIndex);
            }
            else
            {
                panelModel = (Main.osgi.getService(IPanel) as IPanel);
                userRank = panelModel.rank;
                this.warehouseList.addItem(itemId, itemParams.name, itemParams.itemType, itemParams.itemIndex, itemParams.price, discount, ((userRank >= itemParams.rankId) ? int(0) : int(itemParams.rankId)), false, false, 0, resource, false, 0);
            }
        }
        public function addItemToStore(itemId:String, itemParams:ItemParams, itemInfo:ItemInfo):void
        {
        }
        public function removeItemFromWarehouse(itemId:String):void
        {
            this.warehouseList.deleteItem(itemId);
            var index:int = this.itemsInWarehouse.indexOf(itemId);
            this.itemsInWarehouse.splice(index, 1);
        }
        public function removeItemFromStore(itemId:String):void
        {
            this.warehouseList.deleteItem(itemId);
            var index:int = this.itemsInWarehouse.indexOf(itemId);
            this.itemsInWarehouse.splice(index, 1);
        }
        public function lockItemInWarehouse(itemId:String):void
        {
            this.warehouseList.lock(itemId);
        }
        public function unlockItemInWarehouse(itemId:String):void
        {
            this.warehouseList.unlock(itemId);
        }
        public function removeaItemFromWarehouse():void
        {
            removeChild(this.warehouseList);
            this.warehouseList = new PartsList();
            addChild(this.warehouseList);
            this.warehouseList.addEventListener(PartsListEvent.SELECT_PARTS_LIST_ITEM, this.onWarehouseItemSelect);
            this.itemsInWarehouse = new Array();
        }
        public function lockItemInStore(itemId:String):void
        {
        }
        public function unlockItemInStore(itemId:String):void
        {
        }
        public function unmountItem(itemId:String):void
        {
            this.warehouseList.unmount(itemId);
        }
        public function mountItem(itemId:String):void
        {
            this.warehouseList.mount(itemId);
        }
        public function addSkin(itemId:String, itemParams:ItemParams, isBought:Boolean = true):void
        {
            if (isBought)
            {
                this.itemInfoPanel.availableSkins.push(itemId);
            }
            this.itemInfoPanel.skinsParams[itemId] = itemParams;
        }
        public function showItemInfo(itemId:String, itemParams:ItemParams, storeItem:Boolean, itemInfo:ItemInfo = null, mountedItems:Array = null):void
        {
            this.storeItemSelected = storeItem;
            this.inventorySelected = (itemParams.itemType == ItemTypeEnum.INVENTORY);
            if (((itemParams.inventoryItem) && (!(storeItem))))
            {
                this.warehouseList.updateCount(itemInfo.itemId, itemInfo.count);
            }
            this.itemInfoPanel.showItemInfo(itemId, itemParams, storeItem, itemInfo, mountedItems);
            this.itemInfoPanel.resize(this.itemInfoPanelWidth, (this.windowSize.y - this.myItemsWindow.height));
        }
        public function showOtherItemInfo(lastSelectedItemId:Long):void
        {
            var index:int = this.itemsInWarehouse.indexOf(lastSelectedItemId);
            if (this.itemsInWarehouse[int((index + 1))] != null)
            {
                this.selectedItemId = this.itemsInWarehouse[int((index + 1))];
                this.warehouseList.select(this.selectedItemId);
            }
            else
            {
                if (this.itemsInWarehouse[int((index - 1))] != null)
                {
                    this.selectedItemId = this.itemsInWarehouse[int((index - 1))];
                    this.warehouseList.select(this.selectedItemId);
                }
            }
            dispatchEvent(new GarageWindowEvent(GarageWindowEvent.WAREHOUSE_ITEM_SELECTED, this.selectedItemId));
        }
        public function updateItemInfo(itemId:String, itemInfo:ItemInfo, itemParams:ItemParams):void
        {
            if (itemParams.inventoryItem)
            {
                this.warehouseList.updateCount(itemId, itemInfo.count);
            }
        }
        public function scrollToItemInWarehouse(itemId:String):void
        {
            this.warehouseList.scrollTo(itemId);
        }
        public function scrollToItemInStore(itemId:String):void
        {
        }
        public function lockBuyButton():void
        {
            this.itemInfoPanel.buttonBuy.enable = false;
        }
        public function lockUpgradeButton():void
        {
            this.itemInfoPanel.buttonUpgrade.enable = false;
        }
        public function lockMountButton():void
        {
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", ("lockMountButton storeItemSelected: " + this.storeItemSelected));
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", ("lockMountButton inventorySelected: " + this.inventorySelected));
            if (((!(this.storeItemSelected)) && (!(this.inventorySelected))))
            {
                this.itemInfoPanel.buttonEquip.enable = false;
            }
        }
        public function unlockBuyButton():void
        {
            this.itemInfoPanel.buttonBuy.enable = true;
        }
        public function unlockUpgradeButton():void
        {
            this.itemInfoPanel.buttonUpgrade.enable = true;
        }
        public function unlockMountButton():void
        {
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", ("unlockMountButton storeItemSelected: " + this.storeItemSelected));
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", ("unlockMountButton inventorySelected: " + this.inventorySelected));
            if (((!(this.storeItemSelected)) && (!(this.inventorySelected))))
            {
                this.itemInfoPanel.buttonEquip.enable = true;
            }
        }
        public function setMountButtonInfo(icon:BitmapData):void
        {
            this.itemInfoPanel.buttonEquip.icon = icon;
        }
        public function setBuyButtonInfo(reset:Boolean, crystal:int = 0, rank:int = 0):void
        {
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "setBuyButtonInfo reset: %1, crystal: %2, rank: %3", reset, crystal, rank);
            if (reset)
            {
                this.itemInfoPanel.buttonBuy.icon = null;
            }
            else
            {
                this.itemInfoPanel.buttonBuy.setInfo(crystal, rank);
            }
        }
        private function onWarehouseItemSelect(e:Event):void
        {
            this.selectedItemId = (this.warehouseList.selectedItemID as String);
            dispatchEvent(new GarageWindowEvent(GarageWindowEvent.WAREHOUSE_ITEM_SELECTED, this.selectedItemId));
        }
        private function onStoreItemSelect(e:Event):void
        {
        }
        private function onButtonBuyClick(e:MouseEvent):void
        {
            dispatchEvent(new GarageWindowEvent(GarageWindowEvent.BUY_ITEM, this.selectedItemId));
        }
        private function onButtonBuyCrystalsClick(e:MouseEvent):void
        {
            dispatchEvent(new GarageWindowEvent(GarageWindowEvent.ADD_CRYSTALS, this.selectedItemId));
        }
        private function onButtonEquipClick(e:MouseEvent):void
        {
            dispatchEvent(new GarageWindowEvent(GarageWindowEvent.SETUP_ITEM, this.selectedItemId));
        }

        private function onButtonOpenShopClick(e:MouseEvent):void
        {
            PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.dispatchEvent(new MainButtonBarEvents(1));
        }
        private function onButtonOpenContainerClick(e:MouseEvent):void
        {
            dispatchEvent(new GarageWindowEvent(GarageWindowEvent.OPEN_CONTAINER_WINDOW, this.selectedItemId));
        }
        private function onModButtonClick(e:MouseEvent):void
        {
            dispatchEvent(new GarageWindowEvent(GarageWindowEvent.UPGRADE_ITEM, this.selectedItemId));
        }
        private function onSkinButtonClick(e:MouseEvent):void
        {
            dispatchEvent(new GarageWindowEvent(GarageWindowEvent.PROCESS_SKIN, this.selectedItemId));
        }

    }
}
