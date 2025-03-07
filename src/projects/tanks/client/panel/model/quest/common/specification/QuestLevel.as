package projects.tanks.client.panel.model.quest.common.specification
{
   public class QuestLevel
   {

      public static const EASY:QuestLevel = new QuestLevel(0, "EASY");

      public static const NORMAL:QuestLevel = new QuestLevel(1, "NORMAL");

      public static const HARD:QuestLevel = new QuestLevel(2, "HARD");

      private var _value:int;

      private var _name:String;

      public function QuestLevel(param1:int, param2:String)
      {
         super();
         this._value = param1;
         this._name = param2;
      }

      public static function get values():Vector.<QuestLevel>
      {
         var _loc1_:Vector.<QuestLevel> = new Vector.<QuestLevel>();
         _loc1_.push(EASY);
         _loc1_.push(NORMAL);
         _loc1_.push(HARD);
         return _loc1_;
      }

      public function toString():String
      {
         return "QuestLevel [" + this._name + "]";
      }

      public function get value():int
      {
         return this._value;
      }

      public function get name():String
      {
         return this._name;
      }
   }
}
