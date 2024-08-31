package projects.tanks.client.panel.model.quest.daily
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

   public class DailyQuestShowingModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:DailyQuestShowingModelServer;

      private var client:IDailyQuestShowingModelBase;

      private var modelId:Long;

      private var _openDailyQuestId:Long;

      private var _openDailyQuest_infoCodec:ICodec;

      private var _prizeGivenId:Long;

      private var _prizeGiven_questClassIdCodec:ICodec;

      private var _skipQuestId:Long;

      private var _skipQuest_skippedQuestIdCodec:ICodec;

      private var _skipQuest_newQuestCodec:ICodec;

      public function DailyQuestShowingModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IDailyQuestShowingModelBase(this);
         this.modelId = Long.getLong(1734194361, -1013591761);
         this._openDailyQuestId = Long.getLong(27042981, -1604202185);
         this._prizeGivenId = Long.getLong(593457405, 1956535921);
         this._skipQuestId = Long.getLong(396498759, -254486753);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new DailyQuestShowingModelServer(IModel(this));
         var _loc1_:ModelRegistry = ModelRegistry(OSGi.getInstance().getService(ModelRegistry));
         _loc1_.registerModelConstructorCodec(this.modelId, this._protocol.getCodec(new TypeCodecInfo(DailyQuestShowingCC, false)));
         this._openDailyQuest_infoCodec = this._protocol.getCodec(new CollectionCodecInfo(new TypeCodecInfo(DailyQuestInfo, false), false, 1));
         this._prizeGiven_questClassIdCodec = this._protocol.getCodec(new TypeCodecInfo(Long, false));
         this._skipQuest_skippedQuestIdCodec = this._protocol.getCodec(new TypeCodecInfo(Long, false));
         this._skipQuest_newQuestCodec = this._protocol.getCodec(new TypeCodecInfo(DailyQuestInfo, false));
      }

      protected function getInitParam():DailyQuestShowingCC
      {
         return DailyQuestShowingCC(initParams[Model.object]);
      }

      override public function invoke(param1:Long, param2:ProtocolBuffer):void
      {
         switch (param1)
         {
            case this._openDailyQuestId:
               this.client.openDailyQuest(this._openDailyQuest_infoCodec.decode(param2) as Vector.<DailyQuestInfo>);
               break;
            case this._prizeGivenId:
               this.client.prizeGiven(Long(this._prizeGiven_questClassIdCodec.decode(param2)));
               break;
            case this._skipQuestId:
               this.client.skipQuest(Long(this._skipQuest_skippedQuestIdCodec.decode(param2)), DailyQuestInfo(this._skipQuest_newQuestCodec.decode(param2)));
         }
      }

      override public function get id():Long
      {
         return this.modelId;
      }
   }
}
