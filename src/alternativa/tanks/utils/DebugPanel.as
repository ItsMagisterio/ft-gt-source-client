package alternativa.tanks.utils
{
   import controls.base.LabelBase;
   import filters.Filters;
   import flash.display.Sprite;
   import flash.utils.Dictionary;

   public class DebugPanel extends Sprite
   {

      private var values:Dictionary;

      private var count:int;

      public function DebugPanel()
      {
         super();
         this.values = new Dictionary();
         filters = Filters.SHADOW_FILTERS;
         mouseEnabled = false;
         tabEnabled = false;
         mouseChildren = false;
         tabChildren = false;
      }

      public function printValue(param1:String, ...rest):void
      {
         var _loc3_:LabelBase = this.values[param1];
         if (_loc3_ == null)
         {
            _loc3_ = this.createLabel();
            this.values[param1] = _loc3_;
         }
         _loc3_.text = param1 + ": " + rest.join(" ");
      }

      public function printText(param1:String):void
      {
         this.createLabel().text = param1;
      }

      private function createLabel():LabelBase
      {
         var _loc1_:LabelBase = new LabelBase();
         _loc1_.size = 15;
         addChild(_loc1_);
         _loc1_.y = this.count * 23;
         ++this.count;
         return _loc1_;
      }
   }
}
