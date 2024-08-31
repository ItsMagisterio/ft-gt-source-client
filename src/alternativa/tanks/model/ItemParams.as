package alternativa.tanks.model
{
    import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;

    public class ItemParams
    {

        public var baseItemId:String;
        public var description:String;
        public var inventoryItem:Boolean;
        public var itemIndex:int;
        public var itemProperties:Array;
        public var itemType:ItemTypeEnum;
        public var modificationIndex:int;
        public var name:String;
        public var nextModificationPrice:int;
        public var nextModificationProperties:Array;
        public var nextModificationRankId:int;
        public var previewId:String;
        public var price:int;
        public var rankId:int;
        public var modifications:Array;
        public var store:Boolean;
        public var hasSkins:Boolean;
        public var skins:Array;
        public var equippedSkin:String;
        public var microUpgradePrice:int;
        public var microUpgrades:int;
        public var hasShotEffects:Boolean;
        public var equippedShotEffect:String;

        public function ItemParams(baseItemId:String, description:String, inventoryItem:Boolean, itemIndex:int, itemProperties:Array, itemType:ItemTypeEnum, modificationIndex:int, name:String, nextModificationPrice:int, nextModificationProperties:Array, nextModificationRankId:int, previewId:String, price:int, rankId:int, modifications:Array, storeItem:Boolean, skins:Array, hasSkins:Boolean, equippedSkin:String, microUpgradePrice:int, microUpgrades:int, hasShoteffects:Boolean, equippedShotEffect:String)
        {
            this.baseItemId = baseItemId;
            this.description = description;
            this.inventoryItem = inventoryItem;
            this.itemIndex = itemIndex;
            this.itemProperties = itemProperties;
            this.itemType = itemType;
            if (baseItemId.indexOf("xt") >= 0)
            {
                this.modificationIndex = 3;
            }
            else
            {
                this.modificationIndex = modificationIndex;
            }
            this.name = name;
            this.nextModificationPrice = nextModificationPrice;
            this.nextModificationProperties = nextModificationProperties;
            this.nextModificationRankId = nextModificationRankId;
            this.previewId = previewId;
            this.price = price;
            this.rankId = rankId;
            this.modifications = modifications;
            this.store = storeItem;

            this.hasSkins = hasSkins;
            this.skins = skins;
            this.equippedSkin = equippedSkin;
            this.microUpgradePrice = microUpgradePrice;
            this.microUpgrades = microUpgrades;

            this.hasShotEffects = hasShoteffects;
            this.equippedShotEffect = equippedShotEffect;
        }
    }
}
