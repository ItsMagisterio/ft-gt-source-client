package alternativa.tanks.gui
{
    import flash.events.Event;

    public class GarageWindowEvent extends Event
    {

        public static const WAREHOUSE_ITEM_SELECTED:String = "GarageWindowEventWirehouseItemSelected";
        public static const STORE_ITEM_SELECTED:String = "GarageWindowEventStoreItemSelected";
        public static const BUY_ITEM:String = "GarageWindowEventBuyItem";
        public static const SETUP_ITEM:String = "GarageWindowEventSetupItem";
        public static const UPGRADE_ITEM:String = "GarageWindowEventUpgradeItem";
        public static const PROCESS_SKIN:String = "GarageWindowEventSkin";
        public static const ADD_CRYSTALS:String = "GarageWindowEventAddCrystals";
        public static const OPEN_ITEM:String = "GarageWindowEventOpenGift";
        public static const OPEN_CONTAINER_WINDOW:String = "GarageWindowEventOpenContainer";

        public var itemId:String;

        public function GarageWindowEvent(_arg_1:String, itemId:String)
        {
            super(_arg_1, true, false);
            this.itemId = itemId;
        }
    }
}
