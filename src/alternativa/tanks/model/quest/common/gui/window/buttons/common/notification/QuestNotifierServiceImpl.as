package alternativa.tanks.model.quest.common.notification
{
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import projects.tanks.client.panel.model.quest.QuestTypeEnum;
   import projects.tanks.clients.flash.commons.services.flashshutdown.FlashShutdownService;

   public class QuestNotifierServiceImpl extends EventDispatcher implements QuestNotifierService
   {

      [Inject]
      public static var flashShutdownService:FlashShutdownService;

      private var changes:Dictionary;

      public function QuestNotifierServiceImpl()
      {
         var _loc1_:QuestTypeEnum = null;
         this.changes = new Dictionary();
         super();
         for each (_loc1_ in QuestTypeEnum.values)
         {
            this.changes[_loc1_] = false;
         }
      }

      public function hasChange(param1:QuestTypeEnum):Boolean
      {
         return this.changes[param1];
      }

      public function showChanges(param1:QuestTypeEnum):void
      {
         this.changes[param1] = true;
         this.showNotification(param1);
      }

      public function changesViewed(param1:QuestTypeEnum):void
      {
         this.changes[param1] = false;
         this.hideNotification(param1);
      }

      public function isAllChangesViewed():Boolean
      {
         var _loc1_:Boolean = false;
         for each (_loc1_ in this.changes)
         {
            if (_loc1_)
            {
               return false;
            }
         }
         return true;
      }

      private function showNotification(param1:QuestTypeEnum):void
      {
         if (flashShutdownService.fullFeaturesEnabled)
         {
            dispatchEvent(new QuestNotificationEvent(QuestNotificationEvent.SHOW_NOTIFICATION, param1));
         }
      }

      private function hideNotification(param1:QuestTypeEnum = null):void
      {
         dispatchEvent(new QuestNotificationEvent(QuestNotificationEvent.HIDE_NOTIFICATION, param1));
      }
   }
}
