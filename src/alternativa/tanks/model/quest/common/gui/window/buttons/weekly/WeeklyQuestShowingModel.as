package alternativa.tanks.model.quest.weekly
{
   import alternativa.tanks.model.quest.common.MissionsWindowsService;
   import alternativa.tanks.model.quest.common.gui.window.events.QuestGetPrizeEvent;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.ObjectLoadPostListener;
   import platform.client.fp10.core.model.ObjectUnloadPostListener;
   import projects.tanks.client.panel.model.quest.QuestTypeEnum;
   import projects.tanks.client.panel.model.quest.weekly.IWeeklyQuestShowingModelBase;
   import projects.tanks.client.panel.model.quest.weekly.WeeklyQuestInfo;
   import projects.tanks.client.panel.model.quest.weekly.WeeklyQuestShowingModelBase;
   import projects.tanks.clients.flash.commons.services.flashshutdown.FlashShutdownService;

   [ModelInfo]
   public class WeeklyQuestShowingModel extends WeeklyQuestShowingModelBase implements IWeeklyQuestShowingModelBase, ObjectLoadPostListener, ObjectUnloadPostListener
   {

      [Inject]
      public static var missionsWindowsService:MissionsWindowsService;

      [Inject]
      public static var weeklyQuestsService:alternativa.tanks.model.quest.weekly.WeeklyQuestsService;

      [Inject]
      public static var flashShutdownService:FlashShutdownService;

      public function WeeklyQuestShowingModel()
      {
         super();
      }

      public function objectLoadedPost():void
      {
         weeklyQuestsService.addEventListener(QuestGetPrizeEvent.GET_QUEST_PRIZE, getFunctionWrapper(this.onQuestGetPrize));
         weeklyQuestsService.addEventListener(WeeklyQuestEvent.REQUEST_DATA, getFunctionWrapper(this.onDataRequest));
         weeklyQuestsService.setTimeToNextQuest(getInitParam().timeToNextQuest);
         if (flashShutdownService.fullFeaturesEnabled)
         {
            if (getInitParam().hasNewQuests && !missionsWindowsService.isWindowOpen())
            {
               missionsWindowsService.openInTab(QuestTypeEnum.WEEKLY);
            }
         }
      }

      private function onQuestGetPrize(param1:QuestGetPrizeEvent):void
      {
         server.givePrize(param1.questId);
      }

      private function onDataRequest(param1:WeeklyQuestEvent):void
      {
         server.openWindow();
      }

      public function openWeeklyQuest(param1:Vector.<WeeklyQuestInfo>):void
      {
         if (flashShutdownService.fullFeaturesEnabled)
         {
            weeklyQuestsService.questInfoChanged(param1);
            missionsWindowsService.openInTab(QuestTypeEnum.WEEKLY);
         }
      }

      public function prizeGiven(param1:Long):void
      {
         weeklyQuestsService.takePrize(param1);
      }

      public function objectUnloadedPost():void
      {
         weeklyQuestsService.removeEventListener(QuestGetPrizeEvent.GET_QUEST_PRIZE, getFunctionWrapper(this.onQuestGetPrize));
         weeklyQuestsService.removeEventListener(WeeklyQuestEvent.REQUEST_DATA, getFunctionWrapper(this.onDataRequest));
      }
   }
}
