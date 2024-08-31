package projects.tanks.client.panel.model.quest.showing
{
   import alternativa.types.Long;
   import logic.resource.images.ImageResource;

   public class QuestPrizeInfo
   {

      private var _count:int;

      private var _name:String;

      private var _preview:ImageResource;

      private var _prizeObject:Long;

      public function QuestPrizeInfo(param1:int = 0, param2:String = null, param3:ImageResource = null, param4:Long = null)
      {
         super();
         this._count = param1;
         this._name = param2;
         this._preview = param3;
         this._prizeObject = param4;
      }

      public function get count():int
      {
         return this._count;
      }

      public function set count(param1:int):void
      {
         this._count = param1;
      }

      public function get name():String
      {
         return this._name;
      }

      public function set name(param1:String):void
      {
         this._name = param1;
      }

      public function get preview():ImageResource
      {
         return this._preview;
      }

      public function set preview(param1:ImageResource):void
      {
         this._preview = param1;
      }

      public function get prizeObject():Long
      {
         return this._prizeObject;
      }

      public function set prizeObject(param1:Long):void
      {
         this._prizeObject = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "QuestPrizeInfo [";
         _loc1_ += "count = " + this.count + " ";
         _loc1_ += "name = " + this.name + " ";
         _loc1_ += "preview = " + this.preview + " ";
         _loc1_ += "prizeObject = " + this.prizeObject + " ";
         return _loc1_ + "]";
      }
   }
}
