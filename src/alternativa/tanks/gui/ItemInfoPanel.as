package alternativa.tanks.gui
{
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import alternativa.service.IResourceService;
    import alternativa.service.IModelService;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.tanks.model.panel.IPanel;
    import controls.TankWindow;
    import controls.TankWindowInner;
    import flash.display.Bitmap;
    import controls.Label;
    import forms.TankWindowWithHeader;
    import forms.garage.GarageButton;
    import forms.garage.GarageRenewalButton;
    import controls.NumStepper;
    import alternativa.tanks.model.ItemParams;
    import com.alternativaplatform.projects.tanks.client.garage.garage.ItemInfo;
    import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;
    import fl.containers.ScrollPane;
    import flash.display.Shape;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import alternativa.tanks.gui.shopitems.item.kits.description.KitPackageDescriptionView;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import controls.TankWindowHeader;
    import fl.controls.ScrollPolicy;
    import alternativa.tanks.model.user.UserData;
    import alternativa.tanks.model.user.IUserData;
    import flash.text.TextFieldType;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.events.Event;
    import assets.scroller.color.ScrollTrackGreen;
    import assets.scroller.color.ScrollThumbSkinGreen;
    import flash.display.DisplayObject;
    import com.alternativaplatform.projects.tanks.client.garage.item.ItemPropertyValue;
    import alternativa.tanks.gui.shopitems.item.kits.description.KitsData;
    import __AS3__.vec.Vector;
    import projects.tanks.client.panel.model.shop.kitpackage.KitPackageItemInfo;
    import com.alternativaplatform.projects.tanks.client.garage.item.ModificationInfo;
    import alternativa.tanks.model.IItemEffect;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import logic.resource.images.ImageResource;
    import alternativa.resource.StubBitmapData;
    import com.alternativaplatform.projects.tanks.client.commons.types.ItemProperty;
    import alternativa.tanks.gui.shopitems.item.kits.description.KitsInfoData;
    import alternativa.tanks.gui.shopitems.item.kits.KitPackage;
    import alternativa.tanks.model.GarageModel;
    import alternativa.model.IModel;
    import __AS3__.vec.*;
    import alternativa.tanks.gui.upgrade.UpgradeProgressForm;
    import alternativa.tanks.gui.upgrade.UpgradeWindowBase;
    import platform.client.fp10.core.model.impl.Model;
    import projects.tanks.client.garage.models.item.upgradeable.UpgradeParamsCC;
    import alternativa.tanks.model.item.upgradable.UpgradableItemParams;
    import forms.upgrade.UpgradeWindow;
    import forms.itemscategory.Ski;
    import flash.system.Capabilities;
    import forms.itemscategory.skin.SkinType;
    import alternativa.tanks.model.IGarage;
    import com.alternativaplatform.projects.tanks.client.garage.garage.IGarageModelBase;
    import alternativa.tanks.model.IItem;
    import forms.itemscategory.ShotEffectButton;

    public class ItemInfoPanel extends Sprite
    {

        private static const bitmapArea:Class = ItemInfoPanel_bitmapArea;
        private static const areaBd:BitmapData = new bitmapArea().bitmapData;
        private static const bitmapArmorWear:Class = ItemInfoPanel_bitmapArmorWear;
        private static const damageBd:BitmapData = new bitmapArmorWear().bitmapData;
        private static const bitmapArmor:Class = ItemInfoPanel_bitmapArmor;
        private static const armorBd:BitmapData = new bitmapArmor().bitmapData;
        private static const bitmapEnergyConsumption:Class = ItemInfoPanel_bitmapEnergyConsumption;
        private static const energyConsumptionBd:BitmapData = new bitmapEnergyConsumption().bitmapData;
        private static const bitmapPower:Class = ItemInfoPanel_bitmapPower;
        private static const powerBd:BitmapData = new bitmapPower().bitmapData;
        private static const bitmapRange:Class = ItemInfoPanel_bitmapRange;
        private static const rangeBd:BitmapData = new bitmapRange().bitmapData;
        private static const bitmapRateOfFire:Class = ItemInfoPanel_bitmapRateOfFire;
        private static const rateOfFireBd:BitmapData = new bitmapRateOfFire().bitmapData;
        private static const bitmapResourceWear:Class = ItemInfoPanel_bitmapResourceWear;
        private static const resourceWearBd:BitmapData = new bitmapResourceWear().bitmapData;
        private static const bitmapResource:Class = ItemInfoPanel_bitmapResource;
        private static const resourceBd:BitmapData = new bitmapResource().bitmapData;
        private static const bitmapSpread:Class = ItemInfoPanel_bitmapSpread;
        private static const spreadBd:BitmapData = new bitmapSpread().bitmapData;
        private static const bitmapTurretRotationRate:Class = ItemInfoPanel_bitmapTurretRotationRate;
        private static const turretRotationRateBd:BitmapData = new bitmapTurretRotationRate().bitmapData;
        private static const bitmapSpeed:Class = ItemInfoPanel_bitmapSpeed;
        private static const speedBd:BitmapData = new bitmapSpeed().bitmapData;
        private static const bitmapTurnSpeed:Class = ItemInfoPanel_bitmapTurnSpeed;
        private static const turnspeedBd:BitmapData = new bitmapTurnSpeed().bitmapData;
        private static const bitmapFireResistance:Class = ItemInfoPanel_bitmapFireResistance;
        private static const fireResistanceBd:BitmapData = new bitmapFireResistance().bitmapData;
        private static const bitmapPlasmaResistance:Class = ItemInfoPanel_bitmapPlasmaResistance;
        private static const plasmaResistanceBd:BitmapData = new bitmapPlasmaResistance().bitmapData;
        private static const bitmapMechResistance:Class = ItemInfoPanel_bitmapMechResistance;
        private static const mechResistanceBd:BitmapData = new bitmapMechResistance().bitmapData;
        private static const bitmapRailResistance:Class = ItemInfoPanel_bitmapRailResistance;
        private static const railResistanceBd:BitmapData = new bitmapRailResistance().bitmapData;
        private static const bitmapTerminatorResistance:Class = ItemInfoPanel_bitmapTerminatorResistance;
        private static const terminatorResistanceBd:BitmapData = new bitmapTerminatorResistance().bitmapData;
        private static const bitmapCriticalChance:Class = ItemInfoPanel_bitmapCriticalChance;
        private static const criticalChanceBd:BitmapData = new bitmapCriticalChance().bitmapData;
        private static const bitmapHeatingTime:Class = ItemInfoPanel_bitmapHeatingTime;
        private static const heatingTimeBd:BitmapData = new bitmapHeatingTime().bitmapData;
        private static const bitmapMineResistance:Class = ItemInfoPanel_bitmapMineResistance;
        private static const mineResistanceBd:BitmapData = new bitmapMineResistance().bitmapData;
        private static const bitmapVampireResistance:Class = ItemInfoPanel_bitmapVampireResistance;
        private static const vampireResistanceBd:BitmapData = new bitmapVampireResistance().bitmapData;
        private static const bitmapThunderResistance:Class = ItemInfoPanel_bitmapThunderResistance;
        private static const thunderResistanceBd:BitmapData = new bitmapThunderResistance().bitmapData;
        private static const bitmapFreezeResistance:Class = ItemInfoPanel_bitmapFreezeResistance;
        private static const freezeResistanceBd:BitmapData = new bitmapFreezeResistance().bitmapData;
        private static const bitmapRicochetResistance:Class = ItemInfoPanel_bitmapRicochetResistance;
        private static const ricochetResistanceBd:BitmapData = new bitmapRicochetResistance().bitmapData;
        private static const bitmapHealingRadius:Class = ItemInfoPanel_bitmapHealingRadius;
        private static const healingRadiusBd:BitmapData = new bitmapHealingRadius().bitmapData;
        private static const bitmapHealRate:Class = ItemInfoPanel_bitmapHealRate;
        private static const healRateBd:BitmapData = new bitmapHealRate().bitmapData;
        private static const bitmapVampireRate:Class = ItemInfoPanel_bitmapVampireRate;
        private static const vampireRateBd:BitmapData = new bitmapVampireRate().bitmapData;
        private static const shaftResistance:Class = ItemInfoPanel_shaftResistance;
        private static const shaftResistanceBd:BitmapData = new shaftResistance().bitmapData;
        private static const bitmapPropertiesLeft:Class = ItemInfoPanel_bitmapPropertiesLeft;
        private static const propertiesLeftBd:BitmapData = new bitmapPropertiesLeft().bitmapData;
        private static const bitmapPropertiesCenter:Class = ItemInfoPanel_bitmapPropertiesCenter;
        private static const propertiesCenterBd:BitmapData = new bitmapPropertiesCenter().bitmapData;
        private static const bitmapPropertiesRight:Class = ItemInfoPanel_bitmapPropertiesRight;
        private static const propertiesRightBd:BitmapData = new bitmapPropertiesRight().bitmapData;
        private static const bitmapUpgradeTableLeft:Class = ItemInfoPanel_bitmapUpgradeTableLeft;
        private static const upgradeTableLeftBd:BitmapData = new bitmapUpgradeTableLeft().bitmapData;
        private static const bitmapUpgradeTableCenter:Class = ItemInfoPanel_bitmapUpgradeTableCenter;
        private static const upgradeTableCenterBd:BitmapData = new bitmapUpgradeTableCenter().bitmapData;
        private static const bitmapUpgradeTableRight:Class = ItemInfoPanel_bitmapUpgradeTableRight;
        private static const upgradeTableRightBd:BitmapData = new bitmapUpgradeTableRight().bitmapData;
        private static const bitmapDamageShaft:Class = ItemInfoPanel_bitmapDamageShaft;
        private static const shaftDamageBd:BitmapData = new bitmapDamageShaft().bitmapData;
        private static const bitmapFireRateShaft:Class = ItemInfoPanel_bitmapFireRateShaft;
        private static const shaftFireRateBd:BitmapData = new bitmapFireRateShaft().bitmapData;
        public static const INVENTORY_MAX_VALUE:int = 9999;
        public static const INVENTORY_MIN_VALUE:int = 1;
        public static var instance:ItemInfoPanel;

        public const margin:int = 11;
        private const bottomMargin:int = 64;
        private const buttonSize:Point = new Point(120, 50);
        private const iconSpace:int = 10;

        private var resourceRegister:IResourceService;
        private var modelRegister:IModelService;
        private var localeService:ILocaleService;
        private var panelModel:IPanel;
        private var window:TankWindowWithHeader;
        public var size:Point;
        private var inner:TankWindowInner;
        private var preview:Bitmap;
        private var previewVisible:Boolean;
        public var nameTf:Label;
        public var alternations:Label;
        public var description:Label;
        public var descrTf:Label;
        public var buttonBuy:GarageButton;
        public var buttonEquip:GarageButton;
        public var buttonUpgrade:GarageButton;
        public var buttonMircoUpgrades:GarageButton;
        public var buttonOpenContainer:GarageButton;
        public var buttonOpenShop:GarageButton;

        public var buttonSkin:GarageButton;
        public var buttonBuyCrystals:GarageRenewalButton;
        public var inventoryNumStepper:NumStepper;
        public var areaIcon:ItemPropertyIcon;
        public var armorIcon:ItemPropertyIcon;
        public var damageIcon:ItemPropertyIcon;
        public var damagePerSecondIcon:ItemPropertyIcon;
        public var energyConsumptionIcon:ItemPropertyIcon;
        public var powerIcon:ItemPropertyIcon;
        public var rangeIcon:ItemPropertyIcon;
        public var rateOfFireIcon:ItemPropertyIcon;
        public var resourceIcon:ItemPropertyIcon;
        public var resourceWearIcon:ItemPropertyIcon;
        public var shotWearIcon:ItemPropertyIcon;
        public var timeWearIcon:ItemPropertyIcon;
        public var shotTimeWearIcon:ItemPropertyIcon;
        public var spreadIcon:ItemPropertyIcon;
        public var turretRotationRateIcon:ItemPropertyIcon;
        public var damageAngleIcon:ItemPropertyIcon;
        public var speedIcon:ItemPropertyIcon;
        public var turnSpeedIcon:ItemPropertyIcon;
        public var criticalChanceIcon:ItemPropertyIcon;
        public var heatingTimeIcon:ItemPropertyIcon;
        public var mechResistanceIcon:ItemPropertyIcon;
        public var plasmaResistanceIcon:ItemPropertyIcon;
        public var fireResistanceIcon:ItemPropertyIcon;
        public var railResistanceIcon:ItemPropertyIcon;
        public var mineResistanceIcon:ItemPropertyIcon;
        public var terminatorResistanceIcon:ItemPropertyIcon;
        public var vampireResistanceIcon:ItemPropertyIcon;
        public var thunderResistanceIcon:ItemPropertyIcon;
        public var freezeResistanceIcon:ItemPropertyIcon;
        public var ricochetResistanceIcon:ItemPropertyIcon;
        public var shaftResistanceIcon:ItemPropertyIcon;
        public var healingRadiusIcon:ItemPropertyIcon;
        public var healRateIcon:ItemPropertyIcon;
        public var vampireRateIcon:ItemPropertyIcon;
        public var shaftDamageIcon:ItemPropertyIcon;
        public var shaftRateOfFireIcon:ItemPropertyIcon;
        public var visibleIcons:Array;
        public static var visibleIconsArray:Array;
        private var id:String;
        private var params:ItemParams;
        private var info:ItemInfo;
        private var type:ItemTypeEnum;
        private var upgradeProperties:Array;
        private var scrollPane:ScrollPane;
        private var scrollContainer:Sprite;
        private var propertiesPanel:Sprite;
        private var propertiesPanelLeft:Bitmap;
        private var propertiesPanelCenter:Bitmap;
        private var propertiesPanelRight:Bitmap;
        private var area:Shape;
        private var area2:Shape;
        private var areaRect:Rectangle;
        private var areaRect2:Rectangle;
        private var horizMargin:int = 12;
        private var vertMargin:int = 9;
        private var spaceModule:int = 3;
        private var cutPreview:int = 0;
        private var hidePreviewLimit:int = 275;
        private var timeIndicator:Label;
        public var requiredCrystalsNum:int;
        private var modTable:ModTable;
        public var availableSkins:Array;
        public var skinsParams:Dictionary;
        private var skinText:String;
        private var isKit:Boolean = false;
        private var kitView:KitPackageDescriptionView;
        public static var skinButton:Ski;
        public static var shotEffectsButton:ShotEffectButton;
        public var upgradeForm:UpgradeWindow = new UpgradeWindow();
        public var hasSkins:Boolean = false;
        public var hasShotEffects:Boolean = false;
        public var selectedItemParams:ItemParams;
        private var upgradingProgress:int = 0;

        public function ItemInfoPanel()
        {
            super();
            instance = this;
            this.resourceRegister = (Main.osgi.getService(IResourceService) as IResourceService);
            this.modelRegister = (Main.osgi.getService(IModelService) as IModelService);
            this.localeService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            this.panelModel = (Main.osgi.getService(IPanel) as IPanel);
            this.availableSkins = new Array();
            this.skinsParams = new Dictionary();
            this.kitView = new KitPackageDescriptionView();
            this.size = new Point(400, 300);
            this.window = new TankWindowWithHeader("INFORMATION");
            this.window.width = this.size.x;
            this.window.height = this.size.y;
            addChild(this.window);
            this.inner = new TankWindowInner(164, 106, TankWindowInner.GREEN);
            this.inner.showBlink = true;
            addChild(this.inner);
            this.inner.x = this.margin;
            this.inner.y = this.margin;
            this.area = new Shape();
            this.area2 = new Shape();
            this.areaRect = new Rectangle();
            this.areaRect2 = new Rectangle(this.horizMargin, this.vertMargin, 0, 0);
            this.scrollContainer = new Sprite();
            this.scrollContainer.x = (this.margin + 1);
            this.scrollContainer.y = (this.margin + 1);
            this.scrollContainer.addChild(this.area);
            this.scrollContainer.addChild(this.area2);
            this.scrollPane = new ScrollPane();
            addChild(this.scrollPane);
            this.confScroll();
            this.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
            this.scrollPane.source = this.scrollContainer;
            this.scrollPane.focusEnabled = false;
            this.scrollPane.x = (this.margin + 1);
            this.scrollPane.y = ((this.margin + 1) + this.spaceModule);
            var userModel:UserData = (Main.osgi.getService(IUserData) as UserData);
            var userName:String = userModel.userName;
            this.nameTf = new Label();
            this.nameTf.type = TextFieldType.DYNAMIC;
            this.nameTf.text = (("Hello, " + userName) + "!");
            this.nameTf.size = 18;
            this.nameTf.color = 381208;
            this.scrollContainer.addChild(this.nameTf);
            this.nameTf.x = (this.horizMargin - 3);
            this.nameTf.y = (this.vertMargin - 7);

            this.alternations = new Label();
            this.alternations.type = TextFieldType.DYNAMIC;
            this.alternations.text = "Alterations";
            this.alternations.size = 18;
            this.alternations.color = 381208;
            this.scrollContainer.addChild(this.alternations);
            this.alternations.x = (this.horizMargin - 3);

            this.description = new Label();
            this.description.type = TextFieldType.DYNAMIC;
            this.description.text = "Description";
            this.description.size = 18;
            this.description.color = 381208;
            this.scrollContainer.addChild(this.description);
            this.description.x = (this.horizMargin - 3);

            this.descrTf = new Label();
            this.descrTf.multiline = true;
            this.descrTf.wordWrap = true;
            this.descrTf.color = 381208;
            this.descrTf.htmlText = "Description";
            this.scrollContainer.addChild(this.descrTf);
            this.descrTf.x = (this.horizMargin - 3);
            this.preview = new Bitmap();
            this.buttonBuy = new GarageButton();
            this.buttonOpenContainer = new GarageButton();
            this.buttonOpenShop = new GarageButton();

            this.buttonEquip = new GarageButton();
            this.buttonUpgrade = new GarageButton();
            this.buttonMircoUpgrades = new GarageButton();
            this.buttonSkin = new GarageButton();
            this.buttonBuyCrystals = new GarageRenewalButton();
            this.buttonBuy.icon = null;
            this.buttonBuy.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_BUY_TEXT);
            this.buttonOpenContainer.label = "Open"; // TODO: add locale
            this.buttonOpenShop.label = "Buy"; // TODO: add locale
            this.buttonEquip.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_EQUIP_TEXT);
            this.buttonUpgrade.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_UPGRADE_TEXT) + " M";
            this.buttonMircoUpgrades.label = "Upgrade";
            this.buttonBuyCrystals.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_ADD_CRYSTALS_TEXT);
            this.buttonBuyCrystals.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
                {
                    navigateToURL(new URLRequest(((("" + (-((panelModel.crystal >= params.price) ? params.price : -(params.price)) - panelModel.crystal)) + "&nick=") + panelModel.userName)), "_self");
                });
            this.buttonSkin.label = "";
            addChild(this.buttonBuy);
            addChild(this.buttonEquip);
            addChild(this.buttonUpgrade);
            addChild(this.buttonMircoUpgrades);
            addChild(this.buttonSkin);
            addChild(this.buttonOpenContainer);
            addChild(this.buttonOpenShop);
            this.buttonOpenShop.visible = false;
            this.buttonOpenContainer.visible = false;
            this.buttonBuy.visible = false;
            this.buttonUpgrade.visible = false;
            this.buttonMircoUpgrades.visible = false;
            this.buttonSkin.visible = false;
            // addChild(this.buttonBuyCrystals);
            this.inventoryNumStepper = new NumStepper();
            addChild(this.inventoryNumStepper);
            this.inventoryNumStepper.value = 1;
            this.inventoryNumStepper.minValue = 1;
            this.inventoryNumStepper.maxValue = ItemInfoPanel.INVENTORY_MAX_VALUE;
            this.inventoryNumStepper.visible = false;
            this.inventoryNumStepper.addEventListener(Event.CHANGE, this.inventoryNumChanged);
            this.propertiesPanel = new Sprite();
            this.propertiesPanelLeft = new Bitmap(propertiesLeftBd);
            this.propertiesPanel.addChild(this.propertiesPanelLeft);
            this.propertiesPanelCenter = new Bitmap(propertiesCenterBd);
            this.propertiesPanel.addChild(this.propertiesPanelCenter);
            this.propertiesPanelRight = new Bitmap(propertiesRightBd);
            this.propertiesPanel.addChild(this.propertiesPanelRight);
            this.propertiesPanelCenter.x = this.propertiesPanelLeft.width;
            this.propertiesPanel.x = this.horizMargin;
            this.propertiesPanel.y = Math.round((((this.vertMargin * 2) + this.nameTf.textHeight) - 7));
            this.areaIcon = new ItemPropertyIcon(areaBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DISTANCE_UNIT_TEXT));
            this.armorIcon = new ItemPropertyIcon(armorBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_HEALTH_UNIT_TEXT));
            this.damageIcon = new ItemPropertyIcon(damageBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_HEALTH_UNIT_TEXT));
            this.damagePerSecondIcon = new ItemPropertyIcon(damageBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DAMAGE_SPEED_UNIT_TEXT));
            this.energyConsumptionIcon = new ItemPropertyIcon(energyConsumptionBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_POWER_UNIT_TEXT));
            this.powerIcon = new ItemPropertyIcon(powerBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_POWER_UNIT_TEXT));
            this.rangeIcon = new ItemPropertyIcon(rangeBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DISTANCE_UNIT_TEXT));
            this.rateOfFireIcon = new ItemPropertyIcon(rateOfFireBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RATE_OF_FIRE_UNIT_TEXT));
            this.resourceIcon = new ItemPropertyIcon(resourceBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_UNIT_TEXT));
            this.resourceWearIcon = new ItemPropertyIcon(resourceWearBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_UNIT_TEXT));
            this.shotWearIcon = new ItemPropertyIcon(resourceWearBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_SHOT_WEAR_UNIT_TEXT));
            this.timeWearIcon = new ItemPropertyIcon(resourceWearBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_TIME_WEAR_UNIT_TEXT));
            this.shotTimeWearIcon = new ItemPropertyIcon(resourceWearBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_SHOT_TIME_WEAR_UNIT_TEXT));
            this.spreadIcon = new ItemPropertyIcon(spreadBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_ANGLE_UNIT_TEXT));
            this.turretRotationRateIcon = new ItemPropertyIcon(turretRotationRateBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_TURN_SPEED_UNIT_TEXT));
            this.damageAngleIcon = new ItemPropertyIcon(spreadBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_ANGLE_UNIT_TEXT));
            this.speedIcon = new ItemPropertyIcon(speedBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_SPEED_UNIT_TEXT));
            this.turnSpeedIcon = new ItemPropertyIcon(turnspeedBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_TURN_SPEED_UNIT_TEXT));
            this.criticalChanceIcon = new ItemPropertyIcon(criticalChanceBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_CRITICAL_CHANCE_UNIT_TEXT));
            this.heatingTimeIcon = new ItemPropertyIcon(heatingTimeBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_HEATING_TIME_UNIT_TEXT));
            this.mechResistanceIcon = new ItemPropertyIcon(mechResistanceBd, "", true);
            this.fireResistanceIcon = new ItemPropertyIcon(fireResistanceBd, "", true);
            this.plasmaResistanceIcon = new ItemPropertyIcon(plasmaResistanceBd, "", true);
            this.railResistanceIcon = new ItemPropertyIcon(railResistanceBd, "", true);
            this.terminatorResistanceIcon = new ItemPropertyIcon(terminatorResistanceBd, "", true);
            this.mineResistanceIcon = new ItemPropertyIcon(mineResistanceBd, "", true);
            this.vampireResistanceIcon = new ItemPropertyIcon(vampireResistanceBd, "", true);
            this.thunderResistanceIcon = new ItemPropertyIcon(thunderResistanceBd, "", true);
            this.freezeResistanceIcon = new ItemPropertyIcon(freezeResistanceBd, "", true);
            this.ricochetResistanceIcon = new ItemPropertyIcon(ricochetResistanceBd, "", true);
            this.shaftResistanceIcon = new ItemPropertyIcon(shaftResistanceBd, "", true);
            this.healingRadiusIcon = new ItemPropertyIcon(healingRadiusBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DISTANCE_UNIT_TEXT));
            this.healRateIcon = new ItemPropertyIcon(healRateBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DAMAGE_SPEED_UNIT_TEXT));
            this.vampireRateIcon = new ItemPropertyIcon(vampireRateBd, this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DAMAGE_SPEED_UNIT_TEXT));
            this.shaftDamageIcon = new ItemPropertyIcon(shaftDamageBd, "hp");
            this.shaftRateOfFireIcon = new ItemPropertyIcon(shaftFireRateBd, "shot/min");
            this.timeIndicator = new Label();
            this.timeIndicator.size = 18;
            this.timeIndicator.color = 381208;
            this.visibleIcons = new Array();
            visibleIconsArray = this.visibleIcons.concat();
            this.modTable = new ModTable();
            this.modTable.x = this.horizMargin;
        }
        public function hide():void
        {
            this.resourceRegister = null;
            this.modelRegister = null;
            this.panelModel = null;
            this.window = null;
            this.inner = null;
            this.preview = null;
            this.nameTf = null;
            this.descrTf = null;
            this.visibleIcons = null;
            this.id = null;
            this.type = null;
            this.upgradeProperties = null;
            this.scrollPane = null;
            this.scrollContainer = null;
            this.propertiesPanel = null;
            this.propertiesPanelLeft = null;
            this.propertiesPanelCenter = null;
            this.propertiesPanelRight = null;
            this.area = null;
            this.area2 = null;
            this.areaRect = null;
            this.areaRect2 = null;
            this.buttonBuy = null;
            this.buttonEquip = null;
            this.buttonUpgrade = null;
            this.buttonSkin = null;
            this.buttonBuyCrystals = null;
            this.areaIcon = null;
            this.armorIcon = null;
            this.damageIcon = null;
            this.damagePerSecondIcon = null;
            this.energyConsumptionIcon = null;
            this.powerIcon = null;
            this.rangeIcon = null;
            this.rateOfFireIcon = null;
            this.resourceIcon = null;
            this.resourceWearIcon = null;
            this.shotWearIcon = null;
            this.timeWearIcon = null;
            this.shotTimeWearIcon = null;
            this.spreadIcon = null;
            this.turretRotationRateIcon = null;
            this.damageAngleIcon = null;
            this.speedIcon = null;
            this.turnSpeedIcon = null;
            this.criticalChanceIcon = null;
            this.heatingTimeIcon = null;
            this.mechResistanceIcon = null;
            this.fireResistanceIcon = null;
            this.plasmaResistanceIcon = null;
            this.railResistanceIcon = null;
            this.terminatorResistanceIcon = null;
            this.mineResistanceIcon = null;
            this.vampireResistanceIcon = null;
            this.thunderResistanceIcon = null;
            this.freezeResistanceIcon = null;
            this.ricochetResistanceIcon = null;
            this.shaftResistanceIcon = null;
            this.healingRadiusIcon = null;
            this.healRateIcon = null;
            this.vampireRateIcon = null;
            this.vampireRateIcon = null;
            this.vampireRateIcon = null;
            this.vampireRateIcon = null;
            this.vampireRateIcon = null;
            this.shaftRateOfFireIcon = null;
            this.shaftDamageIcon = null;
        }
        private function confScroll():void
        {
            this.scrollPane.setStyle("downArrowUpSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("downArrowDownSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("downArrowOverSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("downArrowDisabledSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("upArrowUpSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("upArrowDownSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("upArrowOverSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("upArrowDisabledSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("trackUpSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("trackDownSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("trackOverSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("trackDisabledSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("thumbUpSkin", ScrollThumbSkinGreen);
            this.scrollPane.setStyle("thumbDownSkin", ScrollThumbSkinGreen);
            this.scrollPane.setStyle("thumbOverSkin", ScrollThumbSkinGreen);
            this.scrollPane.setStyle("thumbDisabledSkin", ScrollThumbSkinGreen);
        }
        private function hideAllIcons():void
        {
            var icon:DisplayObject;
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "hideAllIcons");
            var i:int;
            while (i < this.visibleIcons.length)
            {
                icon = (this.visibleIcons[i] as DisplayObject);
                if (this.propertiesPanel.contains(icon))
                {
                    this.propertiesPanel.removeChild(icon);
                }
                i++;
            }
        }
        private function showIcons():void
        {
            var icon:DisplayObject;
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "showIcons");
            var i:int;
            while (i < this.visibleIcons.length)
            {
                icon = (this.visibleIcons[i] as DisplayObject);
                if ((!(this.propertiesPanel.contains(icon))))
                {
                    this.propertiesPanel.addChild(icon);
                }
                icon.visible = true;
                i++;
            }
        }
        public function updateSkinButton(itemParams:ItemParams):void
        {
            var lastx:int = skinButton.x;
            var lasty:int = skinButton.y;
            if (skinButton != null && this.scrollContainer.contains(skinButton))
            {
                this.scrollContainer.removeChild(skinButton);
                skinButton = null;
            }
            if (itemParams.hasSkins)
            {
                skinButton = new Ski(itemParams.equippedSkin, itemParams.baseItemId);
                this.scrollContainer.addChild(skinButton);
                skinButton.x = lastx;
                skinButton.y = lasty;
            }
        }
        public function updateShotEffectsButton(itemParams:ItemParams):void
        {
            var lastx:int = shotEffectsButton.x;
            var lasty:int = shotEffectsButton.y;
            if (shotEffectsButton != null && this.scrollContainer.contains(shotEffectsButton))
            {
                this.scrollContainer.removeChild(shotEffectsButton);
                shotEffectsButton = null;
            }
            if (itemParams.hasShotEffects)
            {
                shotEffectsButton = new ShotEffectButton(itemParams.equippedShotEffect, itemParams.baseItemId);
                this.scrollContainer.addChild(shotEffectsButton);
                shotEffectsButton.x = lastx;
                shotEffectsButton.y = lasty;
            }
        }
        public function showItemInfo(itemId:String, itemParams:ItemParams, storeItem:Boolean, itemInfo:ItemInfo = null, mountedItems:Array = null):void
        {
            var i:int;
            var p:ItemPropertyValue;
            var j:int;
            var pv:ItemPropertyValue;
            var data:KitsData;
            var kitPackage:Vector.<KitPackageItemInfo>;
            var mods:Array;
            var text:Array;
            var m:int;
            var modInfo:ModificationInfo;
            var row:ModInfoRow;
            var maxWidth:int;
            var modProperties:Array;
            var rank:int;
            var cost:int;
            var acceptableNum:int;
            var itemEffectModel:IItemEffect;
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", " ");
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "showItemInfooooo (itemId: %1)", itemId);
            this.id = itemId;
            this.type = itemParams.itemType;
            this.params = itemParams;
            storeItem = itemParams.store;
            this.info = itemInfo;
            selectedItemParams = itemParams;
            if (this.type != ItemTypeEnum.SPECIAL)
            {
                this.buttonOpenShop.visible = false;

                this.buttonOpenContainer.visible = false;
            }
            if ((this.type == ItemTypeEnum.ARMOR) || (this.type == ItemTypeEnum.WEAPON))
            {
                this.nameTf.text = itemParams.name + " M" + itemParams.modificationIndex.toString();
            }
            else
            {
                this.nameTf.text = itemParams.name;
            }
            this.descrTf.htmlText = itemParams.description;
            var resource:ImageResource = (ResourceUtil.getResource(ResourceType.IMAGE, (itemId + "_preview")) as ImageResource);
            var previewBd:BitmapData;
            if (resource != null)
            {
                previewBd = (resource.bitmapData as BitmapData);
            }
            else
            {
                previewBd = new StubBitmapData(0xFF0000);
            }
            this.preview.bitmapData = previewBd;
            var showProperties:Boolean = (!((this.type == ItemTypeEnum.ARMOR) || (this.type == ItemTypeEnum.WEAPON) /*|| (this.type == ItemTypeEnum.RESISTANCE)*/));
            this.hideAllIcons();
            this.visibleIcons = new Array();
            var properties:Array = itemParams.itemProperties;
            if ((!(itemId.indexOf("shaft_") >= 0)))
            {
                if (properties != null)
                {
                    i = 0;
                    while (i < properties.length)
                    {
                        p = (properties[i] as ItemPropertyValue);
                        switch (p.property)
                        {
                            case ItemProperty.ARMOR:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: ARMOR");
                                if (showProperties)
                                {
                                    this.armorIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.armorIcon.labelText = "";
                                }
                                this.visibleIcons[5] = this.armorIcon;
                                break;
                            case ItemProperty.DAMAGE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: DAMAGE");
                                if (showProperties)
                                {
                                    this.damageIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.damageIcon.labelText = "";
                                }
                                this.visibleIcons[5] = this.damageIcon;
                                break;
                            case ItemProperty.DAMAGE_PER_SECOND:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: DAMAGE_PER_SECOND");
                                if (showProperties)
                                {
                                    this.damagePerSecondIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.damagePerSecondIcon.labelText = "";
                                }
                                this.visibleIcons[5] = this.damagePerSecondIcon;
                                break;
                            case ItemProperty.AIMING_ERROR:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: AIMING_ERROR");
                                if (showProperties)
                                {
                                    this.spreadIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.spreadIcon.labelText = "";
                                }
                                this.visibleIcons[8] = this.spreadIcon;
                                break;
                            case ItemProperty.CONE_ANGLE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: CONE_ANGLE");
                                if (showProperties)
                                {
                                    this.damageAngleIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.damageAngleIcon.labelText = "";
                                }
                                this.visibleIcons[8] = this.damageAngleIcon;
                                break;
                            case ItemProperty.SHOT_AREA:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: SHOT_AREA");
                                if (showProperties)
                                {
                                    this.areaIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.areaIcon.labelText = "";
                                }
                                this.visibleIcons[10] = this.areaIcon;
                                break;
                            case ItemProperty.SHOT_FREQUENCY:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: SHOT_FREQUENCY");
                                if (showProperties)
                                {
                                    this.rateOfFireIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.rateOfFireIcon.labelText = "";
                                }
                                this.visibleIcons[6] = this.rateOfFireIcon;
                                break;
                            case ItemProperty.SHAFT_DAMAGE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: SHOT_FREQUENCY");
                                if (showProperties)
                                {
                                    this.shaftDamageIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.shaftDamageIcon.labelText = "";
                                }
                                this.visibleIcons[7] = this.shaftDamageIcon;
                                break;
                            case ItemProperty.SHAFT_FIRE_RATE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: SHOT_FREQUENCY");
                                if (showProperties)
                                {
                                    this.shaftRateOfFireIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.shaftRateOfFireIcon.labelText = "";
                                }
                                this.visibleIcons[8] = this.shaftRateOfFireIcon;
                                break;
                            case ItemProperty.SHOT_RANGE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: SHOT_RANGE");
                                if (showProperties)
                                {
                                    this.rangeIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.rangeIcon.labelText = "";
                                }
                                this.visibleIcons[9] = this.rangeIcon;
                                break;
                            case ItemProperty.TURRET_TURN_SPEED:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: TURRET_TURN_SPEED");
                                if (showProperties)
                                {
                                    this.turretRotationRateIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.turretRotationRateIcon.labelText = "";
                                }
                                this.visibleIcons[7] = this.turretRotationRateIcon;
                                break;
                            case ItemProperty.SPEED:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: SPEED");
                                if (showProperties)
                                {
                                    this.speedIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.speedIcon.labelText = "";
                                }
                                this.visibleIcons[11] = this.speedIcon;
                                break;
                            case ItemProperty.TURN_SPEED:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: TURN_SPEED");
                                if (showProperties)
                                {
                                    this.turnSpeedIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.turnSpeedIcon.labelText = "";
                                }
                                this.visibleIcons[12] = this.turnSpeedIcon;
                                break;
                            case ItemProperty.CRITICAL_CHANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: CRITICAL_CHANCE");
                                if (showProperties)
                                {
                                    this.criticalChanceIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.criticalChanceIcon.labelText = "";
                                }
                                this.visibleIcons[25] = this.criticalChanceIcon;
                                break;
                            case ItemProperty.HEATING_TIME:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: HEATING_TIME");
                                if (showProperties)
                                {
                                    this.heatingTimeIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.heatingTimeIcon.labelText = "";
                                }
                                this.visibleIcons[26] = this.heatingTimeIcon;
                                break;
                            case ItemProperty.MECH_RESISTANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: MECH_RESISTANCE");
                                if (showProperties)
                                {
                                    this.mechResistanceIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.mechResistanceIcon.labelText = "";
                                }
                                this.visibleIcons[13] = this.mechResistanceIcon;
                                break;
                            case ItemProperty.FIRE_RESISTANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: FIRE_RESISTANCE");
                                if (showProperties)
                                {
                                    this.fireResistanceIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.fireResistanceIcon.labelText = "";
                                }
                                this.visibleIcons[14] = this.fireResistanceIcon;
                                break;
                            case ItemProperty.PLASMA_RESISTANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: PLASMA_RESISTANCE");
                                if (showProperties)
                                {
                                    this.plasmaResistanceIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.plasmaResistanceIcon.labelText = "";
                                }
                                this.visibleIcons[15] = this.plasmaResistanceIcon;
                                break;
                            case ItemProperty.RAIL_RESISTANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: RAIL_RESISTANCE");
                                if (showProperties)
                                {
                                    this.railResistanceIcon.labelText = p.value;
                                }
                                this.visibleIcons[16] = this.railResistanceIcon;
                                break;
                            case ItemProperty.TERMINATOR_RESISTANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: TERMINATOR_RESISTANCE");
                                if (showProperties)
                                {
                                    this.terminatorResistanceIcon.labelText = p.value;
                                }
                                this.visibleIcons[17] = this.terminatorResistanceIcon;
                                break;
                            case ItemProperty.MINE_RESISTANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: TERMINATOR_RESISTANCE");
                                if (showProperties)
                                {
                                    this.mineResistanceIcon.labelText = p.value;
                                }
                                this.visibleIcons[24] = this.mineResistanceIcon;
                                break;
                            case ItemProperty.VAMPIRE_RESISTANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: VAMPIRE_RESISTANCE");
                                if (showProperties)
                                {
                                    this.vampireResistanceIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.vampireResistanceIcon.labelText = "";
                                }
                                this.visibleIcons[18] = this.vampireResistanceIcon;
                                break;
                            case ItemProperty.THUNDER_RESISTANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: THUNDER_RESISTANCE");
                                if (showProperties)
                                {
                                    this.thunderResistanceIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.thunderResistanceIcon.labelText = "";
                                }
                                this.visibleIcons[19] = this.thunderResistanceIcon;
                                break;
                            case ItemProperty.FREEZE_RESISTANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: VAMPIRE_RESISTANCE");
                                if (showProperties)
                                {
                                    this.freezeResistanceIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.freezeResistanceIcon.labelText = "";
                                }
                                this.visibleIcons[20] = this.freezeResistanceIcon;
                                break;
                            case ItemProperty.RICOCHET_RESISTANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: VAMPIRE_RESISTANCE");
                                if (showProperties)
                                {
                                    this.ricochetResistanceIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.ricochetResistanceIcon.labelText = "";
                                }
                                this.visibleIcons[21] = this.ricochetResistanceIcon;
                                break;
                            case ItemProperty.SHAFT_RESISTANCE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: VAMPIRE_RESISTANCE");
                                if (showProperties)
                                {
                                    this.shaftResistanceIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.shaftResistanceIcon.labelText = "";
                                }
                                this.visibleIcons[22] = this.shaftResistanceIcon;
                                break;
                            case ItemProperty.HEALING_RADUIS:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: HEALING_RADUIS");
                                if (showProperties)
                                {
                                    this.healingRadiusIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.healingRadiusIcon.labelText = "";
                                }
                                this.visibleIcons[23] = this.healingRadiusIcon;
                                break;
                            case ItemProperty.HEAL_RATE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: HEAL_RATE");
                                if (showProperties)
                                {
                                    this.healRateIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.healRateIcon.labelText = "";
                                }
                                this.visibleIcons[5] = this.healRateIcon;
                                break;
                            case ItemProperty.VAMPIRE_RATE:
                                Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: VAMPIRE_RATE");
                                if (showProperties)
                                {
                                    this.vampireRateIcon.labelText = p.value;
                                }
                                else
                                {
                                    this.vampireRateIcon.labelText = "";
                                }
                                this.visibleIcons[6] = this.vampireRateIcon;
                                break;
                        }
                        i++;
                    }
                    Main.writeVarsToConsoleChannel("GARAGE WINDOW", " ");
                }
            }
            else
            {
                j = 0;
                while (j < properties.length)
                {
                    pv = (properties[j] as ItemPropertyValue);
                    switch (pv.property)
                    {
                        case ItemProperty.TURRET_TURN_SPEED:
                            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: TURRET_TURN_SPEED");
                            if (showProperties)
                            {
                                this.turretRotationRateIcon.labelText = p.value;
                            }
                            else
                            {
                                this.turretRotationRateIcon.labelText = "";
                            }
                            this.visibleIcons[4] = this.turretRotationRateIcon;
                            break;
                        case ItemProperty.SHAFT_DAMAGE:
                            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: SHOT_FREQUENCY");
                            if (showProperties)
                            {
                                this.shaftDamageIcon.labelText = p.value;
                            }
                            else
                            {
                                this.shaftDamageIcon.labelText = "";
                            }
                            this.visibleIcons[2] = this.shaftDamageIcon;
                            break;
                        case ItemProperty.SHAFT_FIRE_RATE:
                            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: SHOT_FREQUENCY");
                            if (showProperties)
                            {
                                this.shaftRateOfFireIcon.labelText = p.value;
                            }
                            else
                            {
                                this.shaftRateOfFireIcon.labelText = "";
                            }
                            this.visibleIcons[3] = this.shaftRateOfFireIcon;
                            break;
                        case ItemProperty.SHOT_FREQUENCY:
                            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: SHOT_FREQUENCY");
                            if (showProperties)
                            {
                                this.rateOfFireIcon.labelText = p.value;
                            }
                            else
                            {
                                this.rateOfFireIcon.labelText = "";
                            }
                            this.visibleIcons[1] = this.rateOfFireIcon;
                            break;
                        case ItemProperty.DAMAGE:
                            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemProperty: SHOT_FREQUENCY");
                            if (showProperties)
                            {
                                this.damageIcon.labelText = p.value;
                            }
                            else
                            {
                                this.damageIcon.labelText = "";
                            }
                            this.visibleIcons[0] = this.damageIcon;
                            break;
                    }
                    j++;
                }
            }
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "   visibleIcons.length before: %1", this.visibleIcons.length);
            i = 0;
            while (i < this.visibleIcons.length)
            {
                if (this.visibleIcons[i] == null)
                {
                    this.visibleIcons.splice(i, 1);
                }
                else
                {
                    i++;
                }
            }
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "   visibleIcons.length after: %1", this.visibleIcons.length);
            if (this.visibleIcons.length > 0)
            {
                this.showIcons();
                if ((!(this.scrollContainer.contains(this.propertiesPanel))))
                {
                    this.scrollContainer.addChild(this.propertiesPanel);
                }
            }
            else
            {
                if (this.scrollContainer.contains(this.propertiesPanel))
                {
                    this.scrollContainer.removeChild(this.propertiesPanel);
                }
            }
            if (itemParams.itemType == ItemTypeEnum.KIT)
            {
                data = KitsInfoData.getData(itemParams.baseItemId);
                if (data != null)
                {
                    kitPackage = data.info;
                    this.isKit = true;
                    this.hideKitInfoPanel();
                    this.kitView = new KitPackageDescriptionView();
                    this.addKitInfoPanel();
                    this.kitView.show(new KitPackage(kitPackage), data.discount);
                }
                else
                {
                    this.isKit = false;
                    this.hideKitInfoPanel();
                }
            }
            else
            {
                this.isKit = false;
                this.hideKitInfoPanel();
            }
            if (((this.type == ItemTypeEnum.ARMOR) || (this.type == ItemTypeEnum.WEAPON) /*|| (this.type == ItemTypeEnum.RESISTANCE)*/))
            {
                this.propertiesPanelLeft.bitmapData = upgradeTableLeftBd;
                this.propertiesPanelCenter.bitmapData = upgradeTableCenterBd;
                this.propertiesPanelRight.bitmapData = upgradeTableRightBd;
                mods = itemParams.modifications;
                this.showModTable();
                this.modTable.changeRowCount(mods.length);
                if (itemParams.name.indexOf("XT") >= 0)
                {
                    itemParams.modificationIndex = 0;
                }
                this.modTable.select(itemParams.modificationIndex);
                m = 0;
                while (m < mods.length)
                {
                    modInfo = ModificationInfo(mods[m]);
                    Main.writeVarsToConsoleChannel("GARAGE WINDOW", "   modInfo: %1", modInfo);
                    row = ModInfoRow(this.modTable.rows[m]);
                    if (row == null)
                    {
                    }
                    else
                    {
                        row.costLabel.text = modInfo.crystalPrice.toString();
                        if (maxWidth < row.costLabel.width)
                        {
                            maxWidth = row.costLabel.width;
                        }
                        this.modTable.maxCostWidth = maxWidth;
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW", "   maxCostWidth: %1", this.modTable.maxCostWidth);
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW", "   constWidth: %1", this.modTable.constWidth);
                        row.rankIcon.setRank(modInfo.rankId);
                        text = new Array();
                        modProperties = modInfo.itemProperties;
                        if ((!(itemId.indexOf("shaft_") >= 0)))
                        {
                            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "   modProperties: %1", modProperties);
                            i = 0;
                            while (i < modProperties.length)
                            {
                                p = (modProperties[i] as ItemPropertyValue);
                                switch (p.property)
                                {
                                    case ItemProperty.ARMOR:
                                        text[5] = p.value;
                                        break;
                                    case ItemProperty.DAMAGE:
                                        text[5] = p.value;
                                        break;
                                    case ItemProperty.DAMAGE_PER_SECOND:
                                        text[5] = p.value;
                                        break;
                                    case ItemProperty.AIMING_ERROR:
                                        text[8] = p.value;
                                        break;
                                    case ItemProperty.CONE_ANGLE:
                                        text[8] = p.value;
                                        break;
                                    case ItemProperty.SHOT_AREA:
                                        text[10] = p.value;
                                        break;
                                    case ItemProperty.SHOT_FREQUENCY:
                                        text[6] = p.value;
                                        break;
                                    case ItemProperty.SHAFT_DAMAGE:
                                        text[7] = p.value;
                                        break;
                                    case ItemProperty.SHAFT_FIRE_RATE:
                                        text[8] = p.value;
                                        break;
                                    case ItemProperty.SHOT_RANGE:
                                        text[9] = p.value;
                                        break;
                                    case ItemProperty.TURRET_TURN_SPEED:
                                        text[7] = p.value;
                                        break;
                                    case ItemProperty.SPEED:
                                        text[11] = p.value;
                                        break;
                                    case ItemProperty.TURN_SPEED:
                                        text[12] = p.value;
                                        break;
                                    case ItemProperty.MECH_RESISTANCE:
                                        text[13] = p.value;
                                        break;
                                    case ItemProperty.FIRE_RESISTANCE:
                                        text[14] = p.value;
                                        break;
                                    case ItemProperty.PLASMA_RESISTANCE:
                                        text[15] = p.value;
                                        break;
                                    case ItemProperty.RAIL_RESISTANCE:
                                        text[16] = p.value;
                                        break;
                                    case ItemProperty.VAMPIRE_RESISTANCE:
                                        text[17] = p.value;
                                        break;
                                    case ItemProperty.SHAFT_RESISTANCE:
                                        text[18] = p.value;
                                        break;
                                    case ItemProperty.HEALING_RADUIS:
                                        text[18] = p.value;
                                        break;
                                    case ItemProperty.CRITICAL_CHANCE:
                                        text[19] = p.value;
                                        break;
                                    case ItemProperty.HEATING_TIME:
                                        text[20] = p.value;
                                        break;
                                    case ItemProperty.HEAL_RATE:
                                        text[5] = p.value;
                                        break;
                                    case ItemProperty.VAMPIRE_RATE:
                                        text[6] = p.value;
                                        break;
                                }
                                i++;
                            }
                        }
                        else
                        {
                            i = 0;
                            while (i < modProperties.length)
                            {
                                p = (modProperties[i] as ItemPropertyValue);
                                switch (p.property)
                                {
                                    case ItemProperty.SHAFT_DAMAGE:
                                        text[2] = p.value;
                                        break;
                                    case ItemProperty.SHAFT_FIRE_RATE:
                                        text[3] = p.value;
                                        break;
                                    case ItemProperty.DAMAGE:
                                        text[0] = p.value;
                                        break;
                                    case ItemProperty.TURRET_TURN_SPEED:
                                        text[4] = p.value;
                                        break;
                                    case ItemProperty.SHOT_FREQUENCY:
                                        text[1] = p.value;
                                        break;
                                }
                                i++;
                            }
                        }
                        i = 0;
                        while (i < text.length)
                        {
                            if (text[i] == null)
                            {
                                text.splice(i, 1);
                            }
                            else
                            {
                                i++;
                            }
                        }
                        row.setLabelsNum(text.length);
                        row.setLabelsText(text);
                    }
                    m++;
                }
                this.modTable.correctNonintegralValues();
            }
            else
            {
                this.propertiesPanelLeft.bitmapData = propertiesLeftBd;
                this.propertiesPanelCenter.bitmapData = propertiesCenterBd;
                this.propertiesPanelRight.bitmapData = propertiesRightBd;
                this.hideModTable();
            }
            if (storeItem)
            {
                this.buttonBuy.visible = true;
                this.buttonEquip.visible = false;
                this.buttonUpgrade.visible = false;
                this.buttonMircoUpgrades.visible = false;
            }
            else
            {
                if (this.type == ItemTypeEnum.INVENTORY)
                {
                    this.buttonBuy.visible = true;
                    this.buttonEquip.visible = false;
                    this.buttonUpgrade.visible = false;
                    this.buttonMircoUpgrades.visible = false;
                }
                else
                {
                    this.buttonBuy.visible = false;
                    if (this.type == ItemTypeEnum.SPECIAL)
                    {
                        this.buttonOpenContainer.visible = true;

                        // if (itemInfo.count > 0)
                        // {
                        // }
                        this.buttonOpenShop.visible = true;
                        this.buttonEquip.visible = false;
                        this.buttonUpgrade.visible = false;
                        this.buttonBuyCrystals.visible = false;
                        this.buttonMircoUpgrades.visible = false;
                    }
                    else
                    {
                        this.buttonEquip.visible = true;
                        this.buttonMircoUpgrades.visible = false;
                        if (((this.type == ItemTypeEnum.ARMOR) || (this.type == ItemTypeEnum.WEAPON) /*|| (this.type == ItemTypeEnum.RESISTANCE)*/))
                        {
                            this.buttonUpgrade.visible = ((itemParams.modificationIndex < 3) && (itemParams.modifications.length > 1));
                            this.buttonUpgrade.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_UPGRADE_TEXT) + " M" + (itemParams.modificationIndex + 1).toString();
                            this.buttonMircoUpgrades.visible = true;
                        }
                        else
                        {
                            this.buttonUpgrade.visible = false;
                        }
                    }
                }
            }
            if (itemParams.name.indexOf("XT") >= 0)
            {
                itemParams.modificationIndex = 0;
            }
            if (this.buttonBuy.visible)
            {
                rank = ((this.panelModel.rank >= this.params.rankId) ? this.params.rankId : -(this.params.rankId));
                if (this.type == ItemTypeEnum.INVENTORY)
                {
                    cost = ((this.panelModel.crystal >= (this.inventoryNumStepper.value * this.params.price)) ? (this.inventoryNumStepper.value * this.params.price) : (-(this.inventoryNumStepper.value) * this.params.price));
                    this.inventoryNumStepper.visible = true;
                    acceptableNum = int(Math.min(ItemInfoPanel.INVENTORY_MAX_VALUE, Math.floor((this.panelModel.crystal / this.params.price))));
                    if (rank > 0)
                    {
                        if (acceptableNum > 0)
                        {
                            this.inventoryNumStepper.enabled = true;
                            this.inventoryNumStepper.alpha = 1;
                        }
                        else
                        {
                            this.inventoryNumStepper.enabled = false;
                            this.inventoryNumStepper.alpha = 0.7;
                        }
                    }
                    else
                    {
                        this.inventoryNumStepper.enabled = false;
                        this.inventoryNumStepper.alpha = 0.7;
                    }
                }
                else
                {
                    cost = ((this.panelModel.crystal >= this.params.price) ? this.params.price : -(this.params.price));
                    this.inventoryNumStepper.visible = false;
                }
                this.buttonBuy.setInfo(cost, rank);
                this.buttonBuy.enable = cost >= 0 && rank >= 0;
                if (((rank > 0) && (cost < 0)))
                {
                    this.requiredCrystalsNum = (-(cost) - this.panelModel.crystal);
                    this.buttonBuyCrystals.visible = true;
                    this.buttonBuyCrystals.setInfo(this.requiredCrystalsNum, (this.requiredCrystalsNum * GarageModel.buyCrystalRate));
                }
                else
                {
                    this.buttonBuyCrystals.visible = false;
                }
            }
            else
            {
                if (this.buttonUpgrade.visible)
                {
                    this.inventoryNumStepper.visible = false;
                    cost = ((this.params.nextModificationPrice > this.panelModel.crystal) ? -(this.params.nextModificationPrice) : this.params.nextModificationPrice);
                    rank = ((this.panelModel.rank >= this.params.nextModificationRankId) ? this.params.nextModificationRankId : -(this.params.nextModificationRankId));
                    this.buttonUpgrade.setInfo(cost, rank);
                    this.buttonUpgrade.enable = ((cost > 0) && (rank > 0));
                    if (((this.params.nextModificationPrice > this.panelModel.crystal) && (this.panelModel.rank >= this.params.nextModificationRankId)))
                    {
                        this.requiredCrystalsNum = (-(cost) - this.panelModel.crystal);
                        this.buttonBuyCrystals.visible = true;
                        this.buttonBuyCrystals.setInfo(this.requiredCrystalsNum, (this.requiredCrystalsNum * GarageModel.buyCrystalRate));
                    }
                    else
                    {
                        this.buttonBuyCrystals.visible = false;
                    }
                }
                else
                {
                    this.inventoryNumStepper.visible = false;
                    this.buttonBuyCrystals.visible = false;
                }
            }
            this.posButtons();
            if (((this.type == ItemTypeEnum.SPECIAL) && (!(storeItem))))
            {
                if ((!(this.scrollContainer.contains(this.timeIndicator))))
                {
                    this.scrollContainer.addChild(this.timeIndicator);
                }
                itemEffectModel = ((this.modelRegister.getModelsByInterface(IItemEffect) as Vector.<IModel>)[0] as IItemEffect);
                this.timeRemaining = new Date(itemEffectModel.getTimeRemaining(itemId));
                this.buttonMircoUpgrades.visible = false;
            }
            else
            {
                if (this.scrollContainer.contains(this.timeIndicator))
                {
                    this.scrollContainer.removeChild(this.timeIndicator);
                }
            }
            if (itemParams.hasSkins)
            {
                hasSkins = true;
            }
            else
            {
                hasSkins = false;
            }
            if (itemParams.hasShotEffects)
            {
                hasShotEffects = true;
            }
            else
            {
                hasShotEffects = false;
            }
            selectedItemParams = itemParams;
            this.buttonMircoUpgrades.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
                {
                    parseUpgradeWindow(itemParams);
                    upgradeForm.id = itemParams.baseItemId;
                });
            if (skinButton != null && this.scrollContainer.contains(skinButton))
            {
                this.scrollContainer.removeChild(skinButton);
                skinButton = null;
            }
            if (itemParams.hasSkins)
            {
                skinButton = new Ski(itemParams.equippedSkin, itemParams.baseItemId);
                this.scrollContainer.addChild(skinButton);
                skinButton.skIndex = itemParams.equippedSkin;
                skinButton.id = itemParams.baseItemId;
            }
            if (shotEffectsButton != null && this.scrollContainer.contains(shotEffectsButton))
            {
                this.scrollContainer.removeChild(shotEffectsButton);
                shotEffectsButton = null;
            }
            if (itemParams.hasShotEffects)
            {
                shotEffectsButton = new ShotEffectButton(itemParams.equippedShotEffect, itemParams.baseItemId);
                this.scrollContainer.addChild(shotEffectsButton);
                shotEffectsButton.skIndex = itemParams.equippedShotEffect;
                shotEffectsButton.id = itemParams.baseItemId;
            }
        }
        private function parseUpgradeWindow(itemParams:ItemParams):void
        {
            (Main.osgi.getService(IPanel) as IPanel).blur();
            upgradeForm.init();
            var progressMax:int = 10;
            var cost:int = itemParams.microUpgradePrice;
            upgradingProgress = itemParams.microUpgrades;

            this.configUpgradeWindow(cost, progressMax);

            upgradeForm.show();
            Main.stage.addChild(upgradeForm);
        }
        private function updateUpgradeWindow(price:int):void
        {
            var progressMax:int = 10;
            var cost:int = price;
            var itemModel:IItem = ((modelRegister.getModelsByInterface(IItem) as Vector.<IModel>)[0] as IItem);

            this.configUpgradeWindow(cost, progressMax);
        }
        private function configUpgradeWindow(cost:int, progressMax:int):void
        {
            var p1ProgressMax:int = 0;
            var p2ProgressMax:int = 0;
            var p3ProgressMax:int = 0;
            var p4ProgressMax:int = 0;
            var p5ProgressMax:int = 0;

            var currentItemModRow:ModInfoRow = (modTable.rows[selectedItemParams.modificationIndex] as ModInfoRow);
            var nextItemModRow:ModInfoRow = null;
            var previousItemModRow:ModInfoRow = null;

            if (selectedItemParams.modificationIndex < 3)
            {
                currentItemModRow = (modTable.rows[selectedItemParams.modificationIndex] as ModInfoRow);
                nextItemModRow = (modTable.rows[selectedItemParams.modificationIndex + 1] as ModInfoRow);

                var p1Progress:Number = Number(nextItemModRow.labels[0].text.split(" - ")[0]) - Number(currentItemModRow.labels[0].text.split(" - ")[0]);
                var p2Progress:Number = Number(nextItemModRow.labels[1].text.split(" - ")[0]) - Number(currentItemModRow.labels[1].text.split(" - ")[0]);
                var p3Progress:Number = Number(nextItemModRow.labels[2].text.split(" - ")[0]) - Number(currentItemModRow.labels[2].text.split(" - ")[0]);
                var p4Progress:Number = Number(nextItemModRow.labels[3].text.split(" - ")[0]) - Number(currentItemModRow.labels[3].text.split(" - ")[0]);
                var p5Progress:Number = Number(nextItemModRow.labels[4].text.split(" - ")[0]) - Number(currentItemModRow.labels[4].text.split(" - ")[0]);
            }
            else
            {
                currentItemModRow = (modTable.rows[selectedItemParams.modificationIndex] as ModInfoRow);
                previousItemModRow = (modTable.rows[selectedItemParams.modificationIndex - 1] as ModInfoRow);

                var p1Progress:Number = Number(currentItemModRow.labels[0].text.split(" - ")[0]) - Number(previousItemModRow.labels[0].text.split(" - ")[0]);
                var p2Progress:Number = Number(currentItemModRow.labels[1].text.split(" - ")[0]) - Number(previousItemModRow.labels[1].text.split(" - ")[0]);
                var p3Progress:Number = Number(currentItemModRow.labels[2].text.split(" - ")[0]) - Number(previousItemModRow.labels[2].text.split(" - ")[0]);
                var p4Progress:Number = Number(currentItemModRow.labels[3].text.split(" - ")[0]) - Number(previousItemModRow.labels[3].text.split(" - ")[0]);
                var p5Progress:Number = Number(currentItemModRow.labels[4].text.split(" - ")[0]) - Number(previousItemModRow.labels[4].text.split(" - ")[0]);
            }

            var p1Extra:Number = calculateNextUpgrade(p1Progress, upgradingProgress, progressMax);
            var p2Extra:Number = calculateNextUpgrade(p2Progress, upgradingProgress, progressMax);
            var p3Extra:Number = calculateNextUpgrade(p3Progress, upgradingProgress, progressMax);
            var p4Extra:Number = calculateNextUpgrade(p4Progress, upgradingProgress, progressMax);
            var p5Extra:Number = calculateNextUpgrade(p5Progress, upgradingProgress, progressMax);

            var p1Value:String = (modTable.rows[selectedItemParams.modificationIndex] as ModInfoRow).labels[0].text;
            var p2Value:String = (modTable.rows[selectedItemParams.modificationIndex] as ModInfoRow).labels[1].text;
            var p3Value:String = (modTable.rows[selectedItemParams.modificationIndex] as ModInfoRow).labels[2].text;
            var p4Value:String = (modTable.rows[selectedItemParams.modificationIndex] as ModInfoRow).labels[3].text;
            var p5Value:String = (modTable.rows[selectedItemParams.modificationIndex] as ModInfoRow).labels[4].text;

            if (p1Value.indexOf(" - ") >= 0) // first
            {
                if (selectedItemParams.modificationIndex < 3)
                {
                    p1ProgressMax = Number(nextItemModRow.labels[0].text.split(" - ")[1]) - Number(currentItemModRow.labels[0].text.split(" - ")[1]);
                }
                else
                {
                    p1ProgressMax = Number(currentItemModRow.labels[0].text.split(" - ")[1]) - Number(previousItemModRow.labels[0].text.split(" - ")[1]);
                }
            }
            else
            {
                p1ProgressMax = p1Progress;
            } // end first

            if (p2Value.indexOf(" - ") >= 0) // second
            {
                if (selectedItemParams.modificationIndex < 3)
                {
                    p2ProgressMax = Number(nextItemModRow.labels[1].text.split(" - ")[1]) - Number(currentItemModRow.labels[1].text.split(" - ")[1]);
                }
                else
                {
                    p2ProgressMax = Number(currentItemModRow.labels[1].text.split(" - ")[1]) - Number(previousItemModRow.labels[1].text.split(" - ")[1]);
                }
            }
            else
            {
                p2ProgressMax = p2Progress;
            } // end second

            if (p3Value.indexOf(" - ") >= 0) // third
            {
                if (selectedItemParams.modificationIndex < 3)
                {
                    p3ProgressMax = Number(nextItemModRow.labels[2].text.split(" - ")[1]) - Number(currentItemModRow.labels[2].text.split(" - ")[1]);
                }
                else
                {
                    p3ProgressMax = Number(currentItemModRow.labels[2].text.split(" - ")[1]) - Number(previousItemModRow.labels[2].text.split(" - ")[1]);
                }
            }
            else
            {
                p3ProgressMax = p3Progress;
            } // end third

            if (p4Value.indexOf(" - ") >= 0) // fourth
            {
                if (selectedItemParams.modificationIndex < 3)
                {
                    p4ProgressMax = Number(nextItemModRow.labels[3].text.split(" - ")[1]) - Number(currentItemModRow.labels[3].text.split(" - ")[1]);
                }
                else
                {
                    p4ProgressMax = Number(currentItemModRow.labels[3].text.split(" - ")[1]) - Number(previousItemModRow.labels[3].text.split(" - ")[1]);
                }
            }
            else
            {
                p4ProgressMax = p4Progress;
            } // end fourth

            if (p5Value.indexOf(" - ") >= 0) // fifth
            {
                if (selectedItemParams.modificationIndex < 3)
                {
                    p5ProgressMax = Number(nextItemModRow.labels[4].text.split(" - ")[1]) - Number(currentItemModRow.labels[4].text.split(" - ")[1]);
                }
                else
                {
                    p5ProgressMax = Number(currentItemModRow.labels[4].text.split(" - ")[1]) - Number(previousItemModRow.labels[4].text.split(" - ")[1]);
                }
            }
            else
            {
                p5ProgressMax = p5Progress;
            } // end fifth

            var p1ExtraMax:Number = p1Value.indexOf(" - ") == -1 ? p1Extra : calculateNextUpgrade(p1ProgressMax, upgradingProgress, progressMax);
            var p2ExtraMax:Number = p2Value.indexOf(" - ") == -1 ? p2Extra : calculateNextUpgrade(p2ProgressMax, upgradingProgress, progressMax);
            var p3ExtraMax:Number = p3Value.indexOf(" - ") == -1 ? p3Extra : calculateNextUpgrade(p3ProgressMax, upgradingProgress, progressMax);
            var p4ExtraMax:Number = p4Value.indexOf(" - ") == -1 ? p4Extra : calculateNextUpgrade(p4ProgressMax, upgradingProgress, progressMax);
            var p5ExtraMax:Number = p5Value.indexOf(" - ") == -1 ? p5Extra : calculateNextUpgrade(p5ProgressMax, upgradingProgress, progressMax);

            var p1NewValue:String = p1Value.indexOf(" - ") >= 0 ? String(Math.round(Number(Number(p1Value.split(" - ")[0]) + p1Extra) * 100) / 100) + " - " + String(Math.round(Number(Number(p1Value.split(" - ")[1]) + p1ExtraMax) * 100) / 100) : String(Math.round(Number(Number(p1Value) + p1Extra) * 100) / 100);
            var p2NewValue:String = p2Value.indexOf(" - ") >= 0 ? String(Math.round(Number(Number(p2Value.split(" - ")[0]) + p2Extra) * 100) / 100) + " - " + String(Math.round(Number(Number(p2Value.split(" - ")[1]) + p2ExtraMax) * 100) / 100) : String(Math.round(Number(Number(p2Value) + p2Extra) * 100) / 100);
            var p3NewValue:String = p3Value.indexOf(" - ") >= 0 ? String(Math.round(Number(Number(p3Value.split(" - ")[0]) + p3Extra) * 100) / 100) + " - " + String(Math.round(Number(Number(p3Value.split(" - ")[1]) + p3ExtraMax) * 100) / 100) : String(Math.round(Number(Number(p3Value) + p3Extra) * 100) / 100);
            var p4NewValue:String = p4Value.indexOf(" - ") >= 0 ? String(Math.round(Number(Number(p4Value.split(" - ")[0]) + p4Extra) * 100) / 100) + " - " + String(Math.round(Number(Number(p4Value.split(" - ")[1]) + p4ExtraMax) * 100) / 100) : String(Math.round(Number(Number(p4Value) + p4Extra) * 100) / 100);
            var p5NewValue:String = p5Value.indexOf(" - ") >= 0 ? String(Math.round(Number(Number(p5Value.split(" - ")[0]) + p5Extra) * 100) / 100) + " - " + String(Math.round(Number(Number(p5Value.split(" - ")[1]) + p5ExtraMax) * 100) / 100) : String(Math.round(Number(Number(p5Value) + p5Extra) * 100) / 100);

            if (upgradingProgress == progressMax)
            {
                p1Extra = 0;
                p2Extra = 0;
                p3Extra = 0;
                p4Extra = 0;
                p5Extra = 0;
                cost = 0;
            }

            var initialRow:Array = new Array(p1Value, p2Value, p3Value, p4Value, p5Value);
            var upgradesAddRow:Array = new Array(p1Extra, p2Extra, p3Extra, p4Extra, p5Extra);
            var resultRow:Array = new Array(p1NewValue, p2NewValue, p3NewValue, p4NewValue, p5NewValue);

            upgradeForm.davay(upgradingProgress, initialRow, upgradesAddRow, resultRow, cost, visibleIcons, selectedItemParams.itemType);
            upgradeForm.resize();
        }
        private function calculateNextUpgrade(propertyProgress:Number, progress:Number, progressMax:Number):Number
        {
            var upgradesGraph:Array = [8, 12, 17, 18, 20, 10, 6, 4, 3, 2];
            progress++;
            if (progress == 11)
            {
                progress--;
            }

            var totalUpgradePercentage:Number = 0;
            for (var i:int = 0; i < progress; i++)
            {
                totalUpgradePercentage += upgradesGraph[i];
            }

            var value:Number = Math.round(propertyProgress * (totalUpgradePercentage / 100) * 100) / 100;

            return value;
        }
        public function doUpgrade(progressMade:int, price:int):void
        {
            (GarageModel.itemsParams[selectedItemParams.baseItemId] as ItemParams).microUpgrades = progressMade;
            (GarageModel.itemsParams[selectedItemParams.baseItemId] as ItemParams).microUpgradePrice = price;
            this.upgradingProgress = progressMade;
            updateUpgradeWindow(price);
        }
        private function posButtons():void
        {
            var buttonY:int = (((this.size.y - this.margin) - this.buttonSize.y) + 1);
            if (this.buttonBuy.visible)
            {
                this.buttonBuy.y = buttonY;
                if (this.type == ItemTypeEnum.INVENTORY)
                {
                    this.inventoryNumStepper.x = -7;
                    this.inventoryNumStepper.y = (this.buttonBuy.y + Math.round(((this.buttonSize.y - this.inventoryNumStepper.height) * 0.5)));
                    this.buttonBuy.x = ((this.inventoryNumStepper.x + this.inventoryNumStepper.width) + 10);
                    this.buttonMircoUpgrades.visible = false;
                }
                else
                {
                    this.buttonBuy.x = this.margin;
                }
            }
            if (this.buttonOpenShop.visible)
            {
                this.buttonOpenShop.x = this.margin;
                this.buttonOpenShop.y = buttonY;
            }
            if (this.buttonOpenContainer.visible)
            {
                this.buttonOpenContainer.x = ((this.size.x - this.margin) - this.buttonSize.x);
                this.buttonOpenContainer.y = buttonY;
            }
            if (this.buttonEquip.visible)
            {
                this.buttonEquip.y = buttonY;
                this.buttonEquip.x = ((this.size.x - this.margin) - this.buttonSize.x);
            }
            if (this.buttonUpgrade.visible)
            {
                this.buttonUpgrade.y = buttonY;
                this.buttonUpgrade.x = this.margin;
            }
            if (this.buttonMircoUpgrades.visible)
            {
                this.buttonMircoUpgrades.y = buttonY;
                this.buttonMircoUpgrades.x = (this.buttonSize.x) + 26;
            }
            if (this.buttonBuyCrystals.visible)
            {
                this.buttonBuyCrystals.y = buttonY;
                if (this.buttonBuy.visible)
                {
                    this.buttonBuyCrystals.x = ((this.buttonBuy.x + this.buttonSize.x) + 15);
                }
                else
                {
                    this.buttonBuyCrystals.x = ((this.buttonUpgrade.x + this.buttonSize.x) + 15);
                }
            }
            if (skinButton != null)
            {
                skinButton.x = 12;
                skinButton.y = alternations.y + alternations.height + 10;
                if (shotEffectsButton != null)
                {
                    shotEffectsButton.x = skinButton.x + skinButton.width + 10;
                    shotEffectsButton.y = alternations.y + alternations.height + 10;
                }
            }
        }
        private function addKitInfoPanel():void
        {
            if ((!(this.scrollContainer.contains(this.kitView))))
            {
                this.scrollContainer.addChild(this.kitView);
            }
        }
        private function hideKitInfoPanel():void
        {
            if (this.scrollContainer.contains(this.kitView))
            {
                this.scrollContainer.removeChild(this.kitView);
            }
        }
        public function getSkinText():String
        {
            return (this.skinText);
        }
        public function resize(width:int, height:int):void
        {
            var minContainerHeight:int;
            var iconsNum:int;
            var iconY:int;
            var iconsWidth:int;
            var summWidth:int;
            var leftMargin:int;
            var coords:Array;
            var i:int;
            var icon:ItemPropertyIcon;
            var m:int;
            var row:ModInfoRow;
            this.upgradeForm.x = Main.stage.stageWidth / 2 - this.upgradeForm.width / 2;
            this.upgradeForm.y = Main.stage.stageHeight / 2 - this.upgradeForm.height / 2;
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "ItemInfoPanel resize width: %1, height: %2", width, height);
            this.scrollPane.update();
            this.size.x = width;
            this.size.y = height;
            this.window.width = width;
            this.window.height = height;
            this.inner.width = (width - (this.margin * 2));
            this.inner.height = ((height - this.margin) - this.bottomMargin);
            this.areaRect.width = ((width - (this.margin * 2)) - 2);
            this.areaRect2.width = (this.areaRect.width - (this.horizMargin * 2));
            this.description.x = (this.horizMargin - 3);
            this.descrTf.x = (this.horizMargin - 3);
            this.descrTf.width = this.areaRect2.width;
            if (this.visibleIcons != null)
            {
                iconsNum = this.visibleIcons.length;
                if (iconsNum > 0)
                {
                    minContainerHeight = ((this.propertiesPanel.y + this.propertiesPanel.height) + this.vertMargin);
                    this.propertiesPanelRight.x = (this.areaRect2.width - this.propertiesPanelRight.width);
                    this.propertiesPanelCenter.width = (this.propertiesPanelRight.x - this.propertiesPanelCenter.x);
                    iconY = 6;
                    iconsWidth = ((armorBd.width * iconsNum) + (this.iconSpace * (iconsNum - 1)));
                    summWidth = iconsWidth;
                    if (this.scrollContainer.contains(this.modTable))
                    {
                        summWidth = (summWidth + this.modTable.constWidth);
                    }
                    Main.writeVarsToConsoleChannel("GARAGE WINDOW", "   summWidth: %1", summWidth);
                    leftMargin = Math.round(((this.propertiesPanel.width - summWidth) * 0.5));
                    Main.writeVarsToConsoleChannel("GARAGE WINDOW", "   leftMargin: %1", leftMargin);
                    coords = new Array();
                    i = 0;
                    while (i < iconsNum)
                    {
                        icon = (this.visibleIcons[i] as ItemPropertyIcon);
                        icon.x = (leftMargin + (i * (armorBd.width + this.iconSpace)));
                        icon.y = iconY;
                        if (((this.type == ItemTypeEnum.ARMOR) || (this.type == ItemTypeEnum.WEAPON) /*|| (this.type == ItemTypeEnum.RESISTANCE)*/))
                        {
                            coords.push((((this.propertiesPanel.x + icon.x) - this.modTable.x) + (armorBd.width * 0.5)));
                            if (skinButton != null)
                            {
                                skinButton.x = 12;
                                skinButton.y = alternations.y + alternations.height + 10;
                            }
                            if (shotEffectsButton != null)
                            {
                                shotEffectsButton.x = 12;
                                shotEffectsButton.y = alternations.y + alternations.height + 10;
                            }
                        }
                        i++;
                    }
                    Main.writeVarsToConsoleChannel("GARAGE WINDOW", "   coords: %1", coords);
                    if (((this.type == ItemTypeEnum.ARMOR) || (this.type == ItemTypeEnum.WEAPON)/* || (this.type == ItemTypeEnum.RESISTANCE)*/))
                    {
                        this.modTable.y = (((this.propertiesPanel.y + 6) + icon.height) + 2) - 18;
                        this.modTable.resizeSelection(this.areaRect2.width);
                        m = 0;
                        while (m < 4)
                        {
                            row = ModInfoRow(this.modTable.rows[m]);
                            if (row == null)
                            {
                            }
                            else
                            {
                                row.setLabelsPos(coords);
                                row.setConstPartCoord(((leftMargin + iconsWidth) + row.hSpace));
                            }
                            m++;
                        }
                    }
                    this.description.y = (((this.propertiesPanel.y + this.propertiesPanel.height) + this.vertMargin) - 4);
                    this.descrTf.y = (((this.propertiesPanel.y + this.propertiesPanel.height) + this.vertMargin) - 4) + this.description.height + 10;
                }
                else
                {
                    this.description.y = ((this.areaRect2.y + 24) - 7);
                    this.descrTf.y = this.description.y + this.description.height + 10;
                }
            }
            else
            {
                this.description.y = ((this.areaRect2.y + 24) - 7);
                this.descrTf.y = this.description.y + this.description.height + 310;
            }
            if (hasSkins)
            {
                alternations.visible = true;
                alternations.y = this.description.y;
                skinButton.y = alternations.y + alternations.height + 10;
                this.description.y += alternations.height + skinButton.height + 20;
                this.descrTf.y += alternations.height + skinButton.height + 20;
                if (hasShotEffects)
                {
                    shotEffectsButton.y = alternations.y + alternations.height + 10;
                    shotEffectsButton.x = skinButton.x + skinButton.width + 10;
                }
            }
            else
            {
                alternations.visible = false;
            }
            if (this.description.y < 100)
            {
                this.description.visible = false;
                this.descrTf.y = ((this.areaRect2.y + 24) - 7);
            }
            else
            {
                this.description.visible = true;
            }
            minContainerHeight = (minContainerHeight + ((this.vertMargin + this.descrTf.textHeight) - 4));
            var withoutPreviewHeight:int = minContainerHeight;
            if (this.preview.bitmapData != null)
            {
                this.previewVisible = true;
                this.preview.x = (this.horizMargin - (this.horizMargin + this.cutPreview));
                if (iconsNum > 0)
                {
                    this.preview.y = descrTf.y;
                }
                else
                {
                    this.preview.y = descrTf.y;
                }
                this.descrTf.x = (((this.preview.x + this.preview.width) - this.cutPreview));
                this.descrTf.width = ((this.areaRect2.width - this.descrTf.x) - 3);
                minContainerHeight = Math.max((((this.descrTf.y + 3) + this.descrTf.textHeight) + this.vertMargin), ((this.preview.y + this.preview.height) + this.vertMargin));
            }
            else
            {
                minContainerHeight = (((this.descrTf.y + 3) + this.descrTf.textHeight) + this.vertMargin);
            }
            var containerHeight:int = Math.max(minContainerHeight, ((((height - this.margin) - this.bottomMargin) - 2) - (this.spaceModule * 2)));
            var delta:int = (((((this.preview.y + this.preview.height) + 10) + this.kitView.height) - containerHeight) + 15);
            this.areaRect.height = (containerHeight + ((this.isKit) ? ((delta > 0) ? delta : 0) : 0));
            this.areaRect2.height = (this.area.height - (this.vertMargin * 2));
            if (containerHeight > ((((height - this.margin) - this.bottomMargin) - 2) - (this.spaceModule * 2)))
            {
                this.previewVisible = false;
                this.descrTf.x = (this.horizMargin - 3);
                this.descrTf.width = this.areaRect2.width;
                minContainerHeight = withoutPreviewHeight;
                containerHeight = Math.max(minContainerHeight, ((((height - this.margin) - this.bottomMargin) - 2) - (this.spaceModule * 2)));
                this.areaRect.height = containerHeight;
                this.areaRect2.height = (this.area.height - (this.vertMargin * 2));
            }
            this.area.graphics.clear();
            this.area.graphics.beginFill(0xFF0000, 0);
            this.area.graphics.drawRect(this.areaRect.x, this.areaRect.y, this.areaRect.width, this.areaRect.height);
            if (this.previewVisible)
            {
                this.showPreview();
            }
            else
            {
                this.hidePreview();
            }
            this.posButtons();
            this.scrollPane.setSize((((width - (this.margin * 2)) - 2) + 6), ((((height - this.margin) - this.bottomMargin) - 2) - (this.spaceModule * 2)));
            this.scrollPane.update();
            if (this.scrollContainer.contains(this.timeIndicator))
            {
                this.timeIndicator.x = (((this.areaRect2.x + this.areaRect2.width) - this.timeIndicator.width) + 3);
                this.timeIndicator.y = (this.areaRect2.y - 7);
            }
            if (this.isKit)
            {
                if (this.kitView != null)
                {
                    this.kitView.x = Math.round(((this.scrollContainer.width - this.kitView.width) * 0.5));
                    this.kitView.y = ((this.preview.y + this.preview.height) + 10);
                }
            }
        }
        public function hideModTable():void
        {
            if (this.scrollContainer.contains(this.modTable))
            {
                this.scrollContainer.removeChild(this.modTable);
            }
        }
        public function showModTable():void
        {
            if ((!(this.scrollContainer.contains(this.modTable))))
            {
                this.scrollContainer.addChild(this.modTable);
            }
        }
        public function hidePreview():void
        {
            if (this.scrollContainer.contains(this.preview))
            {
                this.scrollContainer.removeChild(this.preview);
            }
        }
        public function showPreview():void
        {
            var previewId:String;
            var resource:ImageResource;
            var previewBd:BitmapData;
            if ((!(this.scrollContainer.contains(this.preview))))
            {
                this.scrollContainer.addChild(this.preview);
                if (this.id != null)
                {
                    previewId = (GarageModel.getItemParams(this.id) as ItemParams).previewId;
                    if (previewId != null)
                    {
                        resource = (ResourceUtil.getResource(ResourceType.IMAGE, (previewId + "_preview")) as ImageResource);
                        previewBd = null;
                        if (resource != null)
                        {
                            previewBd = (resource.bitmapData as BitmapData);
                        }
                        else
                        {
                            previewBd = new StubBitmapData(0xFF0000);
                        }
                        this.preview.bitmapData = previewBd;
                    }
                }
            }
        }
        public function set timeRemaining(time:Date):void
        {
            var dataString:String;
            Main.writeVarsToConsoleChannel("TIME INDICATOR", " ");
            var timeString:String = ((((time.hours < 10) ? ("0" + String(time.hours)) : String(time.hours)) + ":") + ((time.minutes < 10) ? ("0" + String(time.minutes)) : String(time.minutes)));
            var monthString:String = (((time.month + 1) < 10) ? ("0" + String((time.month + 1))) : String((time.month + 1)));
            var dayString:String = ((time.date < 10) ? ("0" + String(time.date)) : String(time.date));
            if (this.localeService.getText(TextConst.GUI_LANG) == "ru")
            {
                dataString = ((((dayString + "-") + monthString) + "-") + String(time.fullYear));
            }
            else
            {
                dataString = ((((monthString + "-") + dayString) + "-") + String(time.fullYear));
            }
            this.timeIndicator.text = ((!(dayString == "NaN")) ? ((timeString + "  ") + dataString) : " ");
            Main.writeVarsToConsoleChannel("TIME INDICATOR", ((("set remainingDate: " + timeString) + " ") + dataString));
            this.resize(this.size.x, this.size.y);
        }
        private function inventoryNumChanged(e:Event = null):void
        {
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", "inventoryNumChanged");
            Main.writeVarsToConsoleChannel("GARAGE WINDOW", ("totalPrice: " + (this.params.price * this.inventoryNumStepper.value)));
            var rank:int = ((this.panelModel.rank >= this.params.rankId) ? this.params.rankId : -(this.params.rankId));
            var cost:int = ((this.panelModel.crystal >= (this.params.price * this.inventoryNumStepper.value)) ? (this.params.price * this.inventoryNumStepper.value) : (-(this.params.price) * this.inventoryNumStepper.value));
            this.buttonBuy.setInfo(cost, rank);
            this.buttonBuy.enable = ((cost >= 0) && (rank > 0));
            if (((rank > 0) && (cost < 0)))
            {
                this.requiredCrystalsNum = (-(cost) - this.panelModel.crystal);
                this.buttonBuyCrystals.visible = true;
                this.buttonBuyCrystals.setInfo(this.requiredCrystalsNum, (this.requiredCrystalsNum * GarageModel.buyCrystalRate));
            }
            else
            {
                this.buttonBuyCrystals.visible = false;
            }
            this.posButtons();
        }

    }
} // package alternativa.tanks.gui