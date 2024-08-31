package platform.core.general.resource.types.image
{
   public class ScaleEnum
   {

      public static const x10:platform.core.general.resource.types.image.ScaleEnum = new platform.core.general.resource.types.image.ScaleEnum(0, "x10");

      public static const x15:platform.core.general.resource.types.image.ScaleEnum = new platform.core.general.resource.types.image.ScaleEnum(1, "x15");

      public static const x20:platform.core.general.resource.types.image.ScaleEnum = new platform.core.general.resource.types.image.ScaleEnum(2, "x20");

      public static const x25:platform.core.general.resource.types.image.ScaleEnum = new platform.core.general.resource.types.image.ScaleEnum(3, "x25");

      public static const x30:platform.core.general.resource.types.image.ScaleEnum = new platform.core.general.resource.types.image.ScaleEnum(4, "x30");

      private var _value:int;

      private var _name:String;

      public function ScaleEnum(param1:int, param2:String)
      {
         super();
         this._value = param1;
         this._name = param2;
      }

      public static function get values():Vector.<platform.core.general.resource.types.image.ScaleEnum>
      {
         var _loc1_:Vector.<platform.core.general.resource.types.image.ScaleEnum> = new Vector.<ScaleEnum>();
         _loc1_.push(x10);
         _loc1_.push(x15);
         _loc1_.push(x20);
         _loc1_.push(x25);
         _loc1_.push(x30);
         return _loc1_;
      }

      public function toString():String
      {
         return "ScaleEnum [" + this._name + "]";
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
