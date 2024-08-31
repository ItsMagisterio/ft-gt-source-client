package platform.client.core.general.socialnetwork.models.google
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;

   public class GoogleExternalLoginModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:platform.client.core.general.socialnetwork.models.google.GoogleExternalLoginModelServer;

      private var client:platform.client.core.general.socialnetwork.models.google.IGoogleExternalLoginModelBase;

      private var modelId:Long;

      public function GoogleExternalLoginModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IGoogleExternalLoginModelBase(this);
         this.modelId = Long.getLong(132443900, -1454404345);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new platform.client.core.general.socialnetwork.models.google.GoogleExternalLoginModelServer(IModel(this));
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
