package alternativa.tanks.model.quest.common.notification
{
   import platform.client.fp10.core.model.ObjectLoadPostListener;
   import platform.client.fp10.core.model.ObjectUnloadListener;
   import projects.tanks.client.panel.model.quest.QuestTypeEnum;
   import projects.tanks.client.panel.model.quest.notifier.IQuestNotifierModelBase;
   import projects.tanks.client.panel.model.quest.notifier.QuestNotifierCC;
   import projects.tanks.client.panel.model.quest.notifier.QuestNotifierModelBase;

   [ModelInfo]
   public class QuestNotifierModel extends QuestNotifierModelBase implements IQuestNotifierModelBase, ObjectLoadPostListener, ObjectUnloadListener
   {

      [Inject]
      public static var questNotifierService:alternativa.tanks.model.quest.common.notification.QuestNotifierService;

      public function QuestNotifierModel()
      {
         super();
      }

      public function objectLoadedPost():void
      {
         var _loc1_:QuestNotifierCC = getInitParam();
         if (_loc1_.hasCompletedDailyQuests || _loc1_.hasNewDailyQuests)
         {
            questNotifierService.showChanges(QuestTypeEnum.DAILY);
         }
         if (_loc1_.hasCompletedWeeklyQuests || _loc1_.hasNewWeeklyQuests)
         {
            questNotifierService.showChanges(QuestTypeEnum.WEEKLY);
         }
         questNotifierService.addEventListener(QuestNotificationEvent.HIDE_NOTIFICATION, getFunctionWrapper(this.onHideNotification));
      }

      public function newInDailyQuests():void
      {
         questNotifierService.showChanges(QuestTypeEnum.DAILY);
      }

      public function newInWeeklyQuests():void
      {
         questNotifierService.showChanges(QuestTypeEnum.WEEKLY);
      }

      public function completedDailyQuest():void
      {
         questNotifierService.showChanges(QuestTypeEnum.DAILY);
      }

      public function completedWeeklyQuests():void
      {
         questNotifierService.showChanges(QuestTypeEnum.WEEKLY);
      }

      private function onHideNotification(param1:QuestNotificationEvent):void
      {
         switch (param1.questType)
         {
            case QuestTypeEnum.DAILY:
               server.completedDailyQuestViewed();
               server.newDailyQuestViewed();
               break;
            case QuestTypeEnum.WEEKLY:
               server.completedWeeklyQuestViewed();
               server.newWeeklyQuestViewed();
         }
      }

      public function hasMainQuestChanges():void
      {
      }

      public function objectUnloaded():void
      {
         questNotifierService.removeEventListener(QuestNotificationEvent.HIDE_NOTIFICATION, getFunctionWrapper(this.onHideNotification));
      }
   }
}
