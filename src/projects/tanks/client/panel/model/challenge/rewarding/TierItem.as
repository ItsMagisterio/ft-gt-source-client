package projects.tanks.client.panel.model.challenge.rewarding
{
   import logic.resource.images.ImageResource;

   public class TierItem
   {

      private var _amount:int;

      private var _name:String;

      private var _preview:ImageResource;

      private var _received:Boolean;

      public function TierItem(param1:int = 0, param2:String = null, param3:ImageResource = null, param4:Boolean = false)
      {
         super();
         this._amount = param1;
         this._name = param2;
         this._preview = param3;
         this._received = param4;
      }

      public function get amount():int
      {
         return this._amount;
      }

      public function set amount(param1:int):void
      {
         this._amount = param1;
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

      public function get received():Boolean
      {
         return this._received;
      }

      public function set received(param1:Boolean):void
      {
         this._received = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "TierItem [";
         _loc1_ += "amount = " + this.amount + " ";
         _loc1_ += "name = " + this.name + " ";
         _loc1_ += "preview = " + this.preview + " ";
         _loc1_ += "received = " + this.received + " ";
         return _loc1_ + "]";
      }
   }
}
