package projects.tanks.client.panel.model.quest.showing
{
   import projects.tanks.client.panel.model.quest.common.specification.QuestLevel;

   public class QuestInfoWithLevel extends CommonQuestInfo
   {

      private var _level:QuestLevel;

      public function QuestInfoWithLevel(param1:QuestLevel = null)
      {
         super();
         this._level = param1;
      }

      public function get level():QuestLevel
      {
         return this._level;
      }

      public function set level(param1:QuestLevel):void
      {
         this._level = param1;
      }

      override public function toString():String
      {
         var _loc1_:String = "QuestInfoWithLevel [";
         _loc1_ += "level = " + this.level + " ";
         _loc1_ += super.toString();
         return _loc1_ + "]";
      }
   }
}
