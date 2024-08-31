package projects.tanks.client.panel.model.quest.notifier
{
   public interface IQuestNotifierModelBase
   {

      function completedDailyQuest():void;

      function completedWeeklyQuests():void;

      function hasMainQuestChanges():void;

      function newInDailyQuests():void;

      function newInWeeklyQuests():void;
   }
}
