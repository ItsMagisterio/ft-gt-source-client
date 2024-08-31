package platform.client.core.general.pushnotification.impl.model
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;

   public class FirebasePushNotificationPanelUserProfileModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:platform.client.core.general.pushnotification.impl.model.FirebasePushNotificationPanelUserProfileModelServer;

      private var client:platform.client.core.general.pushnotification.impl.model.IFirebasePushNotificationPanelUserProfileModelBase;

      private var modelId:Long;

      public function FirebasePushNotificationPanelUserProfileModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IFirebasePushNotificationPanelUserProfileModelBase(this);
         this.modelId = Long.getLong(2033956669, -1526848204);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new platform.client.core.general.pushnotification.impl.model.FirebasePushNotificationPanelUserProfileModelServer(IModel(this));
      }

      override public function invoke(param1:Long, param2:ProtocolBuffer):void
      {
         var _loc3_:* = param1;
         switch (0)
         {
         }
      }

      override public function get id():Long
      {
         return this.modelId;
      }
   }
}
