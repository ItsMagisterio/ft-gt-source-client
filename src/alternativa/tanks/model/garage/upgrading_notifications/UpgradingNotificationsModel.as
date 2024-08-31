package alternativa.tanks.model.garage.upgrading_notifications
{
   import projects.tanks.client.panel.model.garage.upgrading_notifications.IUpgradingNotificationsModelBase;
   import projects.tanks.client.panel.model.garage.upgrading_notifications.UpgradingNotification;
   import projects.tanks.client.panel.model.garage.upgrading_notifications.UpgradingNotificationsModelBase;

   [ModelInfo]
   public class UpgradingNotificationsModel extends UpgradingNotificationsModelBase implements IUpgradingNotificationsModelBase
   {

      public function UpgradingNotificationsModel()
      {
         super();
      }

      public function updateUpgradingNotifications(param1:Vector.<UpgradingNotification>):void
      {
      }
   }
}
