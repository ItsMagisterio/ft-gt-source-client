package platform.client.core.general.pushnotification.api
{
   public class NotificationClientPlatform
   {

      public static const ANDROID:platform.client.core.general.pushnotification.api.NotificationClientPlatform = new platform.client.core.general.pushnotification.api.NotificationClientPlatform(0, "ANDROID");

      public static const WEB:platform.client.core.general.pushnotification.api.NotificationClientPlatform = new platform.client.core.general.pushnotification.api.NotificationClientPlatform(1, "WEB");

      private var _value:int;

      private var _name:String;

      public function NotificationClientPlatform(param1:int, param2:String)
      {
         super();
         this._value = param1;
         this._name = param2;
      }

      public static function get values():Vector.<platform.client.core.general.pushnotification.api.NotificationClientPlatform>
      {
         var _loc1_:Vector.<platform.client.core.general.pushnotification.api.NotificationClientPlatform> = new Vector.<NotificationClientPlatform>();
         _loc1_.push(ANDROID);
         _loc1_.push(WEB);
         return _loc1_;
      }

      public function toString():String
      {
         return "NotificationClientPlatform [" + this._name + "]";
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
