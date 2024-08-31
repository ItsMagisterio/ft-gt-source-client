package projects.tanks.client.panel.model.challenge.stars
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.registry.ModelRegistry;

   public class StarsInfoModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:StarsInfoModelServer;

      private var client:IStarsInfoModelBase;

      private var modelId:Long;

      private var _setStarsId:Long;

      private var _setStars_starsCodec:ICodec;

      public function StarsInfoModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IStarsInfoModelBase(this);
         this.modelId = Long.getLong(2020503521, -1456828147);
         this._setStarsId = Long.getLong(1144166575, -1384472857);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new StarsInfoModelServer(IModel(this));
         var _loc1_:ModelRegistry = ModelRegistry(OSGi.getInstance().getService(ModelRegistry));
         _loc1_.registerModelConstructorCodec(this.modelId, this._protocol.getCodec(new TypeCodecInfo(StarsInfoCC, false)));
         this._setStars_starsCodec = this._protocol.getCodec(new TypeCodecInfo(int, false));
      }

      protected function getInitParam():StarsInfoCC
      {
         return StarsInfoCC(initParams[Model.object]);
      }

      override public function invoke(param1:Long, param2:ProtocolBuffer):void
      {
         switch (param1)
         {
            case this._setStarsId:
               this.client.setStars(int(this._setStars_starsCodec.decode(param2)));
         }
      }

      override public function get id():Long
      {
         return this.modelId;
      }
   }
}
