package projects.tanks.client.garage.models.item.properties
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.registry.ModelRegistry;

   public class ItemPropertiesModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:projects.tanks.client.garage.models.item.properties.ItemPropertiesModelServer;

      private var client:projects.tanks.client.garage.models.item.properties.IItemPropertiesModelBase;

      private var modelId:Long;

      public function ItemPropertiesModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IItemPropertiesModelBase(this);
         this.modelId = Long.getLong(988366120, -592971316);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new projects.tanks.client.garage.models.item.properties.ItemPropertiesModelServer(IModel(this));
         var _loc1_:ModelRegistry = ModelRegistry(OSGi.getInstance().getService(ModelRegistry));
         _loc1_.registerModelConstructorCodec(this.modelId, this._protocol.getCodec(new TypeCodecInfo(ItemPropertiesCC, false)));
      }

      protected function getInitParam():ItemPropertiesCC
      {
         return ItemPropertiesCC(initParams[Model.object]);
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
