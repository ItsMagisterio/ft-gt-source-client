package projects.tanks.client.commons.types
{
   public class ItemCategoryEnum
   {

      public static const WEAPON:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(0, "WEAPON");

      public static const ARMOR:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(1, "ARMOR");

      public static const PAINT:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(2, "PAINT");

      public static const INVENTORY:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(3, "INVENTORY");

      public static const PLUGIN:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(4, "PLUGIN");

      public static const KIT:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(5, "KIT");

      public static const EMBLEM:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(6, "EMBLEM");

      public static const CRYSTAL:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(7, "CRYSTAL");

      public static const PRESENT:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(8, "PRESENT");

      public static const GIVEN_PRESENT:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(9, "GIVEN_PRESENT");

      public static const RESISTANCE_MODULE:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(10, "RESISTANCE_MODULE");

      public static const DEVICE:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(11, "DEVICE");

      public static const LICENSE:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(12, "LICENSE");

      public static const CONTAINER:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(13, "CONTAINER");

      public static const DRONE:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(14, "DRONE");

      public static const SKIN:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(15, "SKIN");

      public static const MOBILE_LOOT_BOX:projects.tanks.client.commons.types.ItemCategoryEnum = new projects.tanks.client.commons.types.ItemCategoryEnum(16, "MOBILE_LOOT_BOX");

      private var _value:int;

      private var _name:String;

      public function ItemCategoryEnum(param1:int, param2:String)
      {
         super();
         this._value = param1;
         this._name = param2;
      }

      public static function get values():Vector.<projects.tanks.client.commons.types.ItemCategoryEnum>
      {
         var _loc1_:Vector.<projects.tanks.client.commons.types.ItemCategoryEnum> = new Vector.<ItemCategoryEnum>();
         _loc1_.push(WEAPON);
         _loc1_.push(ARMOR);
         _loc1_.push(PAINT);
         _loc1_.push(INVENTORY);
         _loc1_.push(PLUGIN);
         _loc1_.push(KIT);
         _loc1_.push(EMBLEM);
         _loc1_.push(CRYSTAL);
         _loc1_.push(PRESENT);
         _loc1_.push(GIVEN_PRESENT);
         _loc1_.push(RESISTANCE_MODULE);
         _loc1_.push(DEVICE);
         _loc1_.push(LICENSE);
         _loc1_.push(CONTAINER);
         _loc1_.push(DRONE);
         _loc1_.push(SKIN);
         _loc1_.push(MOBILE_LOOT_BOX);
         return _loc1_;
      }

      public function toString():String
      {
         return "ItemCategoryEnum [" + this._name + "]";
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
