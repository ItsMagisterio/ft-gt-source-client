package projects.tanks.client.panel.model.quest.daily.type.bonus
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;

   public class BonusCatchDailyQuestModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:BonusCatchDailyQuestModelServer;

      private var client:IBonusCatchDailyQuestModelBase;

      private var modelId:Long;

      public function BonusCatchDailyQuestModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IBonusCatchDailyQuestModelBase(this);
         this.modelId = Long.getLong(170908502, 1988359357);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new BonusCatchDailyQuestModelServer(IModel(this));
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
