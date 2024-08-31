package projects.tanks.client.panel.model.quest.daily
{
   import projects.tanks.client.panel.model.quest.showing.QuestInfoWithLevel;

   public class DailyQuestInfo extends QuestInfoWithLevel
   {

      private var _canSkipForFree:Boolean;

      private var _skipCost:int;

      public function DailyQuestInfo(param1:Boolean = false, param2:int = 0)
      {
         super();
         this._canSkipForFree = param1;
         this._skipCost = param2;
      }

      public function get canSkipForFree():Boolean
      {
         return this._canSkipForFree;
      }

      public function set canSkipForFree(param1:Boolean):void
      {
         this._canSkipForFree = param1;
      }

      public function get skipCost():int
      {
         return this._skipCost;
      }

      public function set skipCost(param1:int):void
      {
         this._skipCost = param1;
      }

      override public function toString():String
      {
         var _loc1_:String = "DailyQuestInfo [";
         _loc1_ += "canSkipForFree = " + this.canSkipForFree + " ";
         _loc1_ += "skipCost = " + this.skipCost + " ";
         _loc1_ += super.toString();
         return _loc1_ + "]";
      }
   }
}
