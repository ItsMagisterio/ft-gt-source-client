package alternativa.tanks.model.quest.common.gui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;

   public class QuestChangesIndicator extends Sprite
   {

      private static var questsChangesIconClass:Class = QuestChangesIndicator_questsChangesIconClass;

      private static var questsChangesIconBitmapData:BitmapData = Bitmap(new questsChangesIconClass()).bitmapData;

      public function QuestChangesIndicator()
      {
         super();
         var _loc1_:Bitmap = new Bitmap(questsChangesIconBitmapData);
         addChild(_loc1_);
         visible = false;
      }
   }
}
