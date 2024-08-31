package platform.client.models.commons.description
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.registry.ModelRegistry;

   public class DescriptionModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:platform.client.models.commons.description.DescriptionModelServer;

      private var client:platform.client.models.commons.description.IDescriptionModelBase;

      private var modelId:Long;

      public function DescriptionModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IDescriptionModelBase(this);
         this.modelId = Long.getLong(916213531, -841295065);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new platform.client.models.commons.description.DescriptionModelServer(IModel(this));
         var _loc1_:ModelRegistry = ModelRegistry(OSGi.getInstance().getService(ModelRegistry));
         _loc1_.registerModelConstructorCodec(this.modelId, this._protocol.getCodec(new TypeCodecInfo(DescriptionModelCC, false)));
      }

      protected function getInitParam():DescriptionModelCC
      {
         return DescriptionModelCC(initParams[Model.object]);
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
