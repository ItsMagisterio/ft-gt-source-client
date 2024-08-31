package alternativa.tanks.model.item.upgradable
{
   import alternativa.tanks.service.item.ItemService;
   import alternativa.tanks.service.itempropertyparams.ItemPropertyParams;
   import alternativa.tanks.service.itempropertyparams.ItemPropertyParamsService;
   import alternativa.tanks.service.upgradingitems.UpgradingItemsService;
   import controls.timer.CountDownTimer;
   import controls.timer.CountDownTimerOnCompleteAfter;
   import flash.utils.getTimer;
   import platform.client.fp10.core.type.IGameObject;
   import projects.tanks.client.commons.types.ItemGarageProperty;
   import projects.tanks.client.garage.models.item.upgradeable.UpgradeParamsCC;
   import projects.tanks.client.garage.models.item.upgradeable.types.GaragePropertyParams;
   import projects.tanks.client.garage.models.item.upgradeable.types.UpgradeParamsData;

   public class UpgradableItemParams implements CountDownTimerOnCompleteAfter
   {

      [Inject]
      public static var upgradingItemService:UpgradingItemsService;

      [Inject]
      public static var propertyService:ItemPropertyParamsService;

      [Inject]
      public static var itemService:ItemService;

      private static const SECONDS_IN_MINUTE:int = 60;

      public var properties:Vector.<alternativa.tanks.model.item.upgradable.UpgradableItemPropertyValue>;

      public var visibleProperties:Vector.<alternativa.tanks.model.item.upgradable.UpgradableItemPropertyValue>;

      public var timer:CountDownTimer = null;

      private var currentLevel:int;

      private var upgradeParams:UpgradeParamsData;

      private var speedUpDiscount:int;

      private var upgradeDiscount:int;

      private var timeDiscount:int;

      public function UpgradableItemParams(param1:UpgradeParamsCC, param2:IGameObject)
      {
         var _loc3_:GaragePropertyParams = null;
         var _loc4_:alternativa.tanks.model.item.upgradable.UpgradableItemPropertyValue = null;
         var _loc5_:alternativa.tanks.model.item.upgradable.UpgradableItemPropertyValue = null;
         var _loc6_:int = 0;
         super();
         this.currentLevel = param1.currentLevel;
         this.upgradeParams = param1.itemData;
         this.speedUpDiscount = param1.speedUpDiscount;
         this.upgradeDiscount = param1.upgradeDiscount;
         this.timeDiscount = param1.timeDiscount;
         this.properties = new Vector.<UpgradableItemPropertyValue>();
         if (param1.itemData != null)
         {
            for each (_loc3_ in param1.itemData.properties)
            {
               _loc5_ = new alternativa.tanks.model.item.upgradable.UpgradableItemPropertyValue(this.upgradeParams.upgradeLevelsCount, _loc3_);
               this.properties.push(_loc5_);
            }
         }
         this.properties.sort(this.compare);
         this.visibleProperties = new Vector.<UpgradableItemPropertyValue>();
         for each (_loc4_ in this.properties)
         {
            if (_loc4_.isVisibleInInfo())
            {
               this.visibleProperties.push(_loc4_);
            }
         }
         if (param1.remainingTimeInMS > 0)
         {
            this.timer = upgradingItemService.getCountDownTimer(param2);
            if (this.timer == null)
            {
               this.timer = new CountDownTimer();
               upgradingItemService.add(itemService.getGarageItemInfo(param2), this.timer);
            }
            _loc6_ = Math.max(this.timer.getEndTime(), getTimer() + param1.remainingTimeInMS);
            this.setTimer(this.timer);
            this.timer.start(_loc6_);
         }
      }

      private function compare(param1:alternativa.tanks.model.item.upgradable.UpgradableItemPropertyValue, param2:alternativa.tanks.model.item.upgradable.UpgradableItemPropertyValue):Number
      {
         var _loc3_:ItemPropertyParams = propertyService.getParams(param1.getProperty());
         var _loc4_:ItemPropertyParams = propertyService.getParams(param2.getProperty());
         var _loc5_:int = _loc3_ != null ? _loc3_.sortIndex : 0;
         var _loc6_:int = _loc4_ != null ? _loc4_.sortIndex : 0;
         if (_loc5_ < _loc6_)
         {
            return -1;
         }
         if (_loc5_ > _loc6_)
         {
            return 1;
         }
         return 0;
      }

      private function setTimer(param1:CountDownTimer):void
      {
         this.timer = param1;
         param1.addListener(CountDownTimerOnCompleteAfter, this);
      }

      public function getValue(param1:ItemGarageProperty):alternativa.tanks.model.item.upgradable.UpgradableItemPropertyValue
      {
         var _loc2_:alternativa.tanks.model.item.upgradable.UpgradableItemPropertyValue = null;
         for each (_loc2_ in this.properties)
         {
            if (_loc2_.getProperty() == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }

      public function startUpgrade(param1:CountDownTimer):void
      {
         this.setTimer(param1);
      }

      public function speedUp():void
      {
         ++ this.currentLevel;
         this.timer.removeListener(CountDownTimerOnCompleteAfter, this);
         this.timer = null;
      }

      public function isUpgrading():Boolean
      {
         return this.timer != null;
      }

      public function onCompleteAfter(param1:CountDownTimer, param2:Boolean):void
      {
         this.speedUp();
      }

      public function getLevelsCount():int
      {
         return this.upgradeParams.upgradeLevelsCount;
      }

      public function isFullUpgraded():Boolean
      {
         return this.currentLevel == this.getLevelsCount();
      }

      public function getLevel():int
      {
         return this.currentLevel;
      }

      public function getStartUpgradePrice():int
      {
         var _loc1_:int = this.getStartUpgradePriceForLevelWithoutDiscount(this.getLevel());
         return this.applyDiscount(_loc1_, this.upgradeDiscount);
      }

      private function getStartUpgradePriceForLevelWithoutDiscount(param1:int):int
      {
         if (this.getLevelsCount() == 1)
         {
            return this.upgradeParams.initialUpgradePrice;
         }
         var _loc2_:int = this.upgradeParams.initialUpgradePrice + (this.upgradeParams.finalUpgradePrice - this.upgradeParams.initialUpgradePrice) * param1 / (this.getLevelsCount() - 1) + 0.001;
         return int((_loc2_ + 5) / 10 + 0.01) * 10;
      }

      public function getSpeedUpPrice():int
      {
         var _loc1_:Number = this.getSpeedUpPriceWithoutDiscount(this.timer.getRemainingSeconds() / SECONDS_IN_MINUTE);
         return this.applyDiscount(_loc1_, this.speedUpDiscount);
      }

      public function getInitialSpeedUpPrice():int
      {
         var _loc1_:Number = this.getSpeedUpPriceWithoutDiscount(this.getTimeInMinutes());
         return this.applyDiscount(_loc1_, this.speedUpDiscount);
      }

      private function getSpeedUpPriceWithoutDiscount(param1:Number):int
      {
         return Math.round(param1 * this.upgradeParams.speedUpCoeff / this.upgradeParams.upgradeTimeCoeff) + 0.1;
      }

      public function getTimeInSeconds():int
      {
         return this.getTimeInMinutes() * SECONDS_IN_MINUTE + 0.1;
      }

      private function getTimeInMinutes():Number
      {
         var _loc1_:int = this.getTimeInMinutesForLevelWithoutDiscount(this.getLevel()) * SECONDS_IN_MINUTE;
         return this.applyDiscount(_loc1_, this.timeDiscount) / SECONDS_IN_MINUTE;
      }

      private function getTimeInMinutesForLevelWithoutDiscount(param1:int):Number
      {
         return Math.round(this.getStartUpgradePriceForLevelWithoutDiscount(param1) * this.upgradeParams.upgradeTimeCoeff);
      }

      private function applyDiscount(param1:int, param2:int):int
      {
         if (param2 == 0)
         {
            return param1;
         }
         return int(param1 * (100 - param2) / 100 + 0.001);
      }

      public function hasSpeedUpDiscount():Boolean
      {
         return this.speedUpDiscount > 0;
      }

      public function hasUpgradeDiscount():Boolean
      {
         return this.upgradeDiscount > 0 || this.timeDiscount > 0;
      }

      public function traceUpgrades():void
      {
         var _loc1_:alternativa.tanks.model.item.upgradable.UpgradableItemPropertyValue = null;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         for each (_loc1_ in this.properties)
         {
         }
         _loc2_ = 0;
         while (_loc2_ <= this.getLevelsCount())
         {
            for each (_loc1_ in this.properties)
            {
            }
            if (_loc2_ != this.getLevelsCount())
            {
               _loc3_ = this.getTimeInMinutesForLevelWithoutDiscount(_loc2_);
            }
            _loc2_++;
         }
      }
   }
}
