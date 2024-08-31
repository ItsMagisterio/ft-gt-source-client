package projects.tanks.client.panel.model.garage.resistance
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.registry.ModelRegistry;

   public class ResistancesListModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:projects.tanks.client.panel.model.garage.resistance.ResistancesListModelServer;

      private var client:projects.tanks.client.panel.model.garage.resistance.IResistancesListModelBase;

      private var modelId:Long;

      public function ResistancesListModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IResistancesListModelBase(this);
         this.modelId = Long.getLong(1350664067, -353806112);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new projects.tanks.client.panel.model.garage.resistance.ResistancesListModelServer(IModel(this));
         var _loc1_:ModelRegistry = ModelRegistry(OSGi.getInstance().getService(ModelRegistry));
         _loc1_.registerModelConstructorCodec(this.modelId, this._protocol.getCodec(new TypeCodecInfo(ResistancesCC, false)));
      }

      protected function getInitParam():ResistancesCC
      {
         return ResistancesCC(initParams[Model.object]);
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
