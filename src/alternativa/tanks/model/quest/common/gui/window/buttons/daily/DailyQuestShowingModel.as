package alternativa.tanks.model.quest.daily
{
   import alternativa.tanks.model.quest.common.MissionsWindowsService;
   import alternativa.tanks.model.quest.common.gui.window.events.QuestGetPrizeEvent;
   import alternativa.tanks.service.money.IMoneyService;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.ObjectLoadListener;
   import platform.client.fp10.core.model.ObjectUnloadPostListener;
   import projects.tanks.client.panel.model.quest.QuestTypeEnum;
   import projects.tanks.client.panel.model.quest.daily.DailyQuestInfo;
   import projects.tanks.client.panel.model.quest.daily.DailyQuestShowingModelBase;
   import projects.tanks.client.panel.model.quest.daily.IDailyQuestShowingModelBase;
   import projects.tanks.clients.flash.commons.services.flashshutdown.FlashShutdownService;

   [ModelInfo]
   public class DailyQuestShowingModel extends DailyQuestShowingModelBase implements IDailyQuestShowingModelBase, ObjectLoadListener, ObjectUnloadPostListener
   {

      [Inject]
      public static var moneyService:IMoneyService;

      [Inject]
      public static var dailyQuestService:alternativa.tanks.model.quest.daily.DailyQuestsService;

      [Inject]
      public static var missionsWindowsService:MissionsWindowsService;

      [Inject]
      public static var flashShutdownService:FlashShutdownService;

      public function DailyQuestShowingModel()
      {
         super();
      }

      public function objectLoaded():void
      {
         dailyQuestService.addEventListener(DailyQuestChangeEvent.DAILY_QUEST_CHANGE, getFunctionWrapper(this.onDailyQuestChange));
         dailyQuestService.addEventListener(QuestGetPrizeEvent.GET_QUEST_PRIZE, getFunctionWrapper(this.onQuestGetPrize));
         dailyQuestService.addEventListener(DailyQuestEvent.REQUEST_DATA, getFunctionWrapper(this.onDataRequest));
         dailyQuestService.setTimeToNextQuest(getInitParam().timeToNextQuest);
         missionsWindowsService.initWindow();
         if (flashShutdownService.fullFeaturesEnabled)
         {
            if (getInitParam().hasNewQuests && !missionsWindowsService.isWindowOpen())
            {
               missionsWindowsService.openInTab(QuestTypeEnum.DAILY);
            }
         }
      }

      private function onDailyQuestChange(param1:DailyQuestChangeEvent):void
      {
         var _loc2_:DailyQuestInfo = param1.dailyQuestInfo;
         if (_loc2_.canSkipForFree)
         {
            server.skipQuestForFree(_loc2_.questId);
         }
         else
         {
            moneyService.spend(_loc2_.skipCost);
            server.skipQuestForCrystals(_loc2_.questId, _loc2_.skipCost);
         }
      }

      private function onQuestGetPrize(param1:QuestGetPrizeEvent):void
      {
         server.givePrize(param1.questId);
      }

      private function onDataRequest(param1:DailyQuestEvent):void
      {
         server.openWindow();
      }

      public function openDailyQuest(param1:Vector.<DailyQuestInfo>):void
      {
         if (flashShutdownService.fullFeaturesEnabled)
         {
            dailyQuestService.questInfoChanged(param1);
            missionsWindowsService.openInTab(QuestTypeEnum.DAILY);
         }
      }

      public function prizeGiven(param1:Long):void
      {
         dailyQuestService.takePrize(param1);
      }

      public function skipQuest(param1:Long, param2:DailyQuestInfo):void
      {
         dailyQuestService.changeSkippedQuest(param1, param2);
      }

      public function objectUnloadedPost():void
      {
         dailyQuestService.removeEventListener(DailyQuestChangeEvent.DAILY_QUEST_CHANGE, getFunctionWrapper(this.onDailyQuestChange));
         dailyQuestService.removeEventListener(QuestGetPrizeEvent.GET_QUEST_PRIZE, getFunctionWrapper(this.onQuestGetPrize));
         dailyQuestService.removeEventListener(DailyQuestEvent.REQUEST_DATA, getFunctionWrapper(this.onDataRequest));
      }
   }
}
