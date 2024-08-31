package projects.tanks.client.panel.model.quest.notifier
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.TypeCodecInfo;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;
   import platform.client.fp10.core.registry.ModelRegistry;

   public class QuestNotifierModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:QuestNotifierModelServer;

      private var client:IQuestNotifierModelBase;

      private var modelId:Long;

      private var _completedDailyQuestId:Long;

      private var _completedWeeklyQuestsId:Long;

      private var _hasMainQuestChangesId:Long;

      private var _newInDailyQuestsId:Long;

      private var _newInWeeklyQuestsId:Long;

      public function QuestNotifierModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IQuestNotifierModelBase(this);
         this.modelId = Long.getLong(2083723058, -1617932508);
         this._completedDailyQuestId = Long.getLong(1649960148, -282513245);
         this._completedWeeklyQuestsId = Long.getLong(881910911, 183376780);
         this._hasMainQuestChangesId = Long.getLong(1328546632, -1774435395);
         this._newInDailyQuestsId = Long.getLong(68721805, 897135658);
         this._newInWeeklyQuestsId = Long.getLong(2017235952, 945739610);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new QuestNotifierModelServer(IModel(this));
         var _loc1_:ModelRegistry = ModelRegistry(OSGi.getInstance().getService(ModelRegistry));
         _loc1_.registerModelConstructorCodec(this.modelId, this._protocol.getCodec(new TypeCodecInfo(QuestNotifierCC, false)));
      }

      protected function getInitParam():QuestNotifierCC
      {
         return QuestNotifierCC(initParams[Model.object]);
      }

      override public function invoke(param1:Long, param2:ProtocolBuffer):void
      {
         switch (param1)
         {
            case this._completedDailyQuestId:
               this.client.completedDailyQuest();
               break;
            case this._completedWeeklyQuestsId:
               this.client.completedWeeklyQuests();
               break;
            case this._hasMainQuestChangesId:
               this.client.hasMainQuestChanges();
               break;
            case this._newInDailyQuestsId:
               this.client.newInDailyQuests();
               break;
            case this._newInWeeklyQuestsId:
               this.client.newInWeeklyQuests();
         }
      }

      override public function get id():Long
      {
         return this.modelId;
      }
   }
}
