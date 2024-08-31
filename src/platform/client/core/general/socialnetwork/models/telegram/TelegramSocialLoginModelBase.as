package platform.client.core.general.socialnetwork.models.telegram
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;

   public class TelegramSocialLoginModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:platform.client.core.general.socialnetwork.models.telegram.TelegramSocialLoginModelServer;

      private var client:platform.client.core.general.socialnetwork.models.telegram.ITelegramSocialLoginModelBase;

      private var modelId:Long;

      public function TelegramSocialLoginModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = ITelegramSocialLoginModelBase(this);
         this.modelId = Long.getLong(1704658995, -863360489);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new platform.client.core.general.socialnetwork.models.telegram.TelegramSocialLoginModelServer(IModel(this));
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
