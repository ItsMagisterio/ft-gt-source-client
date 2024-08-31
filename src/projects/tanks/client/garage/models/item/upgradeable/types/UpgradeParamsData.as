package projects.tanks.client.garage.models.item.upgradeable.types
{
   public class UpgradeParamsData
   {

      private var _finalUpgradePrice:int;

      private var _initialUpgradePrice:int;

      private var _properties:Vector.<projects.tanks.client.garage.models.item.upgradeable.types.GaragePropertyParams>;

      private var _speedUpCoeff:Number;

      private var _upgradeLevelsCount:int;

      private var _upgradeTimeCoeff:Number;

      public function UpgradeParamsData(param1:int = 0, param2:int = 0, param3:Vector.<projects.tanks.client.garage.models.item.upgradeable.types.GaragePropertyParams> = null, param4:Number = 0, param5:int = 0, param6:Number = 0)
      {
         super();
         this._finalUpgradePrice = param1;
         this._initialUpgradePrice = param2;
         this._properties = param3;
         this._speedUpCoeff = param4;
         this._upgradeLevelsCount = param5;
         this._upgradeTimeCoeff = param6;
      }

      public function get finalUpgradePrice():int
      {
         return this._finalUpgradePrice;
      }

      public function set finalUpgradePrice(param1:int):void
      {
         this._finalUpgradePrice = param1;
      }

      public function get initialUpgradePrice():int
      {
         return this._initialUpgradePrice;
      }

      public function set initialUpgradePrice(param1:int):void
      {
         this._initialUpgradePrice = param1;
      }

      public function get properties():Vector.<projects.tanks.client.garage.models.item.upgradeable.types.GaragePropertyParams>
      {
         return this._properties;
      }

      public function set properties(param1:Vector.<projects.tanks.client.garage.models.item.upgradeable.types.GaragePropertyParams>):void
      {
         this._properties = param1;
      }

      public function get speedUpCoeff():Number
      {
         return this._speedUpCoeff;
      }

      public function set speedUpCoeff(param1:Number):void
      {
         this._speedUpCoeff = param1;
      }

      public function get upgradeLevelsCount():int
      {
         return this._upgradeLevelsCount;
      }

      public function set upgradeLevelsCount(param1:int):void
      {
         this._upgradeLevelsCount = param1;
      }

      public function get upgradeTimeCoeff():Number
      {
         return this._upgradeTimeCoeff;
      }

      public function set upgradeTimeCoeff(param1:Number):void
      {
         this._upgradeTimeCoeff = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "UpgradeParamsData [";
         _loc1_ += "finalUpgradePrice = " + this.finalUpgradePrice + " ";
         _loc1_ += "initialUpgradePrice = " + this.initialUpgradePrice + " ";
         _loc1_ += "properties = " + this.properties + " ";
         _loc1_ += "speedUpCoeff = " + this.speedUpCoeff + " ";
         _loc1_ += "upgradeLevelsCount = " + this.upgradeLevelsCount + " ";
         _loc1_ += "upgradeTimeCoeff = " + this.upgradeTimeCoeff + " ";
         return _loc1_ + "]";
      }
   }
}
