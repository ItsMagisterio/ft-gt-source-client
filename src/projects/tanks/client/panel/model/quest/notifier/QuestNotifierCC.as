package projects.tanks.client.panel.model.quest.notifier
{
   public class QuestNotifierCC
   {

      private var _hasCompletedDailyQuests:Boolean;

      private var _hasCompletedWeeklyQuests:Boolean;

      private var _hasMainQuestChanges:Boolean;

      private var _hasNewDailyQuests:Boolean;

      private var _hasNewWeeklyQuests:Boolean;

      private var _hasNotCompletedQuests:Boolean;

      public function QuestNotifierCC(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false)
      {
         super();
         this._hasCompletedDailyQuests = param1;
         this._hasCompletedWeeklyQuests = param2;
         this._hasMainQuestChanges = param3;
         this._hasNewDailyQuests = param4;
         this._hasNewWeeklyQuests = param5;
         this._hasNotCompletedQuests = param6;
      }

      public function get hasCompletedDailyQuests():Boolean
      {
         return this._hasCompletedDailyQuests;
      }

      public function set hasCompletedDailyQuests(param1:Boolean):void
      {
         this._hasCompletedDailyQuests = param1;
      }

      public function get hasCompletedWeeklyQuests():Boolean
      {
         return this._hasCompletedWeeklyQuests;
      }

      public function set hasCompletedWeeklyQuests(param1:Boolean):void
      {
         this._hasCompletedWeeklyQuests = param1;
      }

      public function get hasMainQuestChanges():Boolean
      {
         return this._hasMainQuestChanges;
      }

      public function set hasMainQuestChanges(param1:Boolean):void
      {
         this._hasMainQuestChanges = param1;
      }

      public function get hasNewDailyQuests():Boolean
      {
         return this._hasNewDailyQuests;
      }

      public function set hasNewDailyQuests(param1:Boolean):void
      {
         this._hasNewDailyQuests = param1;
      }

      public function get hasNewWeeklyQuests():Boolean
      {
         return this._hasNewWeeklyQuests;
      }

      public function set hasNewWeeklyQuests(param1:Boolean):void
      {
         this._hasNewWeeklyQuests = param1;
      }

      public function get hasNotCompletedQuests():Boolean
      {
         return this._hasNotCompletedQuests;
      }

      public function set hasNotCompletedQuests(param1:Boolean):void
      {
         this._hasNotCompletedQuests = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "QuestNotifierCC [";
         _loc1_ += "hasCompletedDailyQuests = " + this.hasCompletedDailyQuests + " ";
         _loc1_ += "hasCompletedWeeklyQuests = " + this.hasCompletedWeeklyQuests + " ";
         _loc1_ += "hasMainQuestChanges = " + this.hasMainQuestChanges + " ";
         _loc1_ += "hasNewDailyQuests = " + this.hasNewDailyQuests + " ";
         _loc1_ += "hasNewWeeklyQuests = " + this.hasNewWeeklyQuests + " ";
         _loc1_ += "hasNotCompletedQuests = " + this.hasNotCompletedQuests + " ";
         return _loc1_ + "]";
      }
   }
}
