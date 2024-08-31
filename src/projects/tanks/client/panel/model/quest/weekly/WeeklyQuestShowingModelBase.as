package projects.tanks.client.panel.model.quest.weekly
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.CollectionCodecInfo;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.registry.ModelRegistry;

   public class WeeklyQuestShowingModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:WeeklyQuestShowingModelServer;

      private var client:IWeeklyQuestShowingModelBase;

      private var modelId:Long;

      private var _openWeeklyQuestId:Long;

      private var _openWeeklyQuest_infoCodec:ICodec;

      private var _prizeGivenId:Long;

      private var _prizeGiven_questIdCodec:ICodec;

      public function WeeklyQuestShowingModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IWeeklyQuestShowingModelBase(this);
         this.modelId = Long.getLong(616930387, 851653221);
         this._openWeeklyQuestId = Long.getLong(1625498279, -1320504899);
         this._prizeGivenId = Long.getLong(1025488993, -1514758469);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new WeeklyQuestShowingModelServer(IModel(this));
         var _loc1_:ModelRegistry = ModelRegistry(OSGi.getInstance().getService(ModelRegistry));
         _loc1_.registerModelConstructorCodec(this.modelId, this._protocol.getCodec(new TypeCodecInfo(WeeklyQuestShowingCC, false)));
         this._openWeeklyQuest_infoCodec = this._protocol.getCodec(new CollectionCodecInfo(new TypeCodecInfo(WeeklyQuestInfo, false), false, 1));
         this._prizeGiven_questIdCodec = this._protocol.getCodec(new TypeCodecInfo(Long, false));
      }

      protected function getInitParam():WeeklyQuestShowingCC
      {
         return WeeklyQuestShowingCC(initParams[Model.object]);
      }

      override public function invoke(param1:Long, param2:ProtocolBuffer):void
      {
         switch (param1)
         {
            case this._openWeeklyQuestId:
               this.client.openWeeklyQuest(this._openWeeklyQuest_infoCodec.decode(param2) as Vector.<WeeklyQuestInfo>);
               break;
            case this._prizeGivenId:
               this.client.prizeGiven(Long(this._prizeGiven_questIdCodec.decode(param2)));
         }
      }

      override public function get id():Long
      {
         return this.modelId;
      }
   }
}
