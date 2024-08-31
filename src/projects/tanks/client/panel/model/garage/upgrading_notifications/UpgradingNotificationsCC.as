package projects.tanks.client.panel.model.garage.upgrading_notifications
{
   public class UpgradingNotificationsCC
   {

      private var _upgradingNotifications:Vector.<projects.tanks.client.panel.model.garage.upgrading_notifications.UpgradingNotification>;

      public function UpgradingNotificationsCC(param1:Vector.<projects.tanks.client.panel.model.garage.upgrading_notifications.UpgradingNotification> = null)
      {
         super();
         this._upgradingNotifications = param1;
      }

      public function get upgradingNotifications():Vector.<projects.tanks.client.panel.model.garage.upgrading_notifications.UpgradingNotification>
      {
         return this._upgradingNotifications;
      }

      public function set upgradingNotifications(param1:Vector.<projects.tanks.client.panel.model.garage.upgrading_notifications.UpgradingNotification>):void
      {
         this._upgradingNotifications = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "UpgradingNotificationsCC [";
         _loc1_ += "upgradingNotifications = " + this.upgradingNotifications + " ";
         return _loc1_ + "]";
      }
   }
}
