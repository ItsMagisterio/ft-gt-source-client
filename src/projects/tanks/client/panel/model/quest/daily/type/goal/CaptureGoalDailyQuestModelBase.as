package projects.tanks.client.panel.model.quest.daily.type.goal
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;

   public class CaptureGoalDailyQuestModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:CaptureGoalDailyQuestModelServer;

      private var client:ICaptureGoalDailyQuestModelBase;

      private var modelId:Long;

      public function CaptureGoalDailyQuestModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = ICaptureGoalDailyQuestModelBase(this);
         this.modelId = Long.getLong(835552943, 1303329520);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new CaptureGoalDailyQuestModelServer(IModel(this));
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
