package projects.tanks.client.panel.model.garage.upgrading_notifications
{
   import alternativa.types.Long;
   import projects.tanks.client.commons.types.ItemViewCategoryEnum;

   public class UpgradingNotification
   {

      private var _category:ItemViewCategoryEnum;

      private var _upgradeRemainingTime:Long;

      public function UpgradingNotification(param1:ItemViewCategoryEnum = null, param2:Long = null)
      {
         super();
         this._category = param1;
         this._upgradeRemainingTime = param2;
      }

      public function get category():ItemViewCategoryEnum
      {
         return this._category;
      }

      public function set category(param1:ItemViewCategoryEnum):void
      {
         this._category = param1;
      }

      public function get upgradeRemainingTime():Long
      {
         return this._upgradeRemainingTime;
      }

      public function set upgradeRemainingTime(param1:Long):void
      {
         this._upgradeRemainingTime = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "UpgradingNotification [";
         _loc1_ += "category = " + this.category + " ";
         _loc1_ += "upgradeRemainingTime = " + this.upgradeRemainingTime + " ";
         return _loc1_ + "]";
      }
   }
}
