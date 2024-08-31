package platform.client.models.commons.types
{
   public class ValidationStatus
   {

      public static const TOO_SHORT:platform.client.models.commons.types.ValidationStatus = new platform.client.models.commons.types.ValidationStatus(0, "TOO_SHORT");

      public static const TOO_LONG:platform.client.models.commons.types.ValidationStatus = new platform.client.models.commons.types.ValidationStatus(1, "TOO_LONG");

      public static const NOT_UNIQUE:platform.client.models.commons.types.ValidationStatus = new platform.client.models.commons.types.ValidationStatus(2, "NOT_UNIQUE");

      public static const NOT_MATCH_PATTERN:platform.client.models.commons.types.ValidationStatus = new platform.client.models.commons.types.ValidationStatus(3, "NOT_MATCH_PATTERN");

      public static const FORBIDDEN:platform.client.models.commons.types.ValidationStatus = new platform.client.models.commons.types.ValidationStatus(4, "FORBIDDEN");

      public static const CORRECT:platform.client.models.commons.types.ValidationStatus = new platform.client.models.commons.types.ValidationStatus(5, "CORRECT");

      private var _value:int;

      private var _name:String;

      public function ValidationStatus(param1:int, param2:String)
      {
         super();
         this._value = param1;
         this._name = param2;
      }

      public static function get values():Vector.<platform.client.models.commons.types.ValidationStatus>
      {
         var _loc1_:Vector.<platform.client.models.commons.types.ValidationStatus> = new Vector.<ValidationStatus>();
         _loc1_.push(TOO_SHORT);
         _loc1_.push(TOO_LONG);
         _loc1_.push(NOT_UNIQUE);
         _loc1_.push(NOT_MATCH_PATTERN);
         _loc1_.push(FORBIDDEN);
         _loc1_.push(CORRECT);
         return _loc1_;
      }

      public function toString():String
      {
         return "ValidationStatus [" + this._name + "]";
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
