package projects.tanks.client.garage.models.item.upgradeable
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.registry.ModelRegistry;

   public class UpgradeableParamsConstructorModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:projects.tanks.client.garage.models.item.upgradeable.UpgradeableParamsConstructorModelServer;

      private var client:projects.tanks.client.garage.models.item.upgradeable.IUpgradeableParamsConstructorModelBase;

      private var modelId:Long;

      public function UpgradeableParamsConstructorModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IUpgradeableParamsConstructorModelBase(this);
         this.modelId = Long.getLong(1104447849, 1721128071);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new projects.tanks.client.garage.models.item.upgradeable.UpgradeableParamsConstructorModelServer(IModel(this));
         var _loc1_:ModelRegistry = ModelRegistry(OSGi.getInstance().getService(ModelRegistry));
         _loc1_.registerModelConstructorCodec(this.modelId, this._protocol.getCodec(new TypeCodecInfo(UpgradeParamsCC, false)));
      }

      protected function getInitParam():UpgradeParamsCC
      {
         return UpgradeParamsCC(initParams[Model.object]);
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
