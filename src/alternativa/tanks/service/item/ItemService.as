package alternativa.tanks.service.item
{
   import alternativa.tanks.model.item.properties.ItemPropertyValue;
   import alternativa.tanks.model.item.upgradable.UpgradableItemParams;
   import controls.timer.CountDownTimer;
   import flash.events.IEventDispatcher;
   import platform.client.fp10.core.resource.types.ImageResource;
   import platform.client.fp10.core.type.IGameClass;
   import platform.client.fp10.core.type.IGameObject;
   import projects.tanks.client.commons.types.ItemCategoryEnum;
   import projects.tanks.client.commons.types.ItemViewCategoryEnum;
   import projects.tanks.client.panel.model.garage.GarageItemInfo;

   public interface ItemService extends IEventDispatcher
   {

      function getPreviewResource(param1:IGameObject):ImageResource;

      function getCategory(param1:IGameObject):ItemCategoryEnum;

      function getViewCategory(param1:IGameObject):ItemViewCategoryEnum;

      function getName(param1:IGameObject):String;

      function getDescription(param1:IGameObject):String;

      function getModificationIndex(param1:IGameObject):int;

      function getModificationIndexText(param1:IGameObject):String;

      function getModifications(param1:IGameObject):Vector.<IGameObject>;

      function getModificationsCount(param1:IGameObject):int;

      function getPrice(param1:IGameObject):int;

      function getDiscount(param1:IGameObject):int;

      function getEndDiscountTimer(param1:IGameObject):CountDownTimer;

      function getPriceWithoutDiscount(param1:IGameObject):int;

      function isBuyable(param1:IGameObject):Boolean;

      function getProperties(param1:IGameObject):Vector.<ItemPropertyValue>;

      function getPropertiesForInfoWindow(param1:IGameObject):Vector.<ItemPropertyValue>;

      function getUpgradableItemParams(param1:IGameObject):UpgradableItemParams;

      function getCurrentValue(param1:IGameObject, param2:ItemPropertyValue):String;

      function isUpgradableItem(param1:IGameObject):Boolean;

      function getMinRankIndex(param1:IGameObject):int;

      function getMaxRankIndex(param1:IGameObject):int;

      function getPosition(param1:IGameObject):int;

      function getNextModification(param1:IGameObject):IGameObject;

      function hasNextModification(param1:IGameObject):Boolean;

      function getPreviousModification(param1:IGameObject):IGameObject;

      function getCount(param1:IGameObject):int;

      function setCount(param1:IGameObject, param2:int):void;

      function isCountable(param1:IGameObject):Boolean;

      function isKit(param1:IGameObject):Boolean;

      function isPresent(param1:IGameObject):Boolean;

      function isGrouped(param1:IGameObject):Boolean;

      function getGroup(param1:IGameObject):int;

      function isModificationItem(param1:IGameObject):Boolean;

      function hasItem(param1:IGameObject):Boolean;

      function reset():void;

      function addItem(param1:IGameObject):void;

      function removeItem(param1:IGameObject):void;

      function canBuy(param1:IGameObject):Boolean;

      function addMountableCategories(param1:Vector.<ItemCategoryEnum>):void;

      function isMountable(param1:IGameObject):Boolean;

      function isUpgrading(param1:IGameObject):Boolean;

      function getGarageItemInfo(param1:IGameObject):GarageItemInfo;

      function getMaxUserModificationItem(param1:IGameObject):IGameObject;

      function isMounted(param1:IGameObject):Boolean;

      function mountItem(param1:IGameObject):void;

      function unmountItem(param1:IGameObject):*;

      function isFullUpgraded(param1:IGameObject):Boolean;

      function getTimeLeftInSeconds(param1:IGameObject):int;

      function isEnabledItem(param1:IGameObject):Boolean;

      function isTimelessItem(param1:IGameObject):Boolean;

      function getTimeToStartInSeconds(param1:IGameObject):int;

      function getMaxAvailableOrNextNotAvailableModification(param1:IGameObject):IGameObject;

      function getMaxAvailableModification(param1:IGameObject):IGameObject;

      function isPremiumItem(param1:IGameObject):Boolean;

      function isGivenPresent(param1:IGameObject):Boolean;

      function getUserItemByClass(param1:IGameClass):IGameObject;

      function getMountedItemsByCategory(param1:ItemCategoryEnum):Vector.<IGameObject>;

      function isSellingForCoin(param1:IGameObject):Boolean;

      function isSellingForCrystal(param1:IGameObject):Boolean;
   }
}
