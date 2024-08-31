package projects.tanks.client.panel.model.quest.weekly
{
   import projects.tanks.client.panel.model.quest.showing.QuestInfoWithLevel;

   public class WeeklyQuestInfo extends QuestInfoWithLevel
   {

      public function WeeklyQuestInfo()
      {
         super();
      }

      override public function toString():String
      {
         var _loc1_:String = "WeeklyQuestInfo [";
         _loc1_ += super.toString();
         return _loc1_ + "]";
      }
   }
}
