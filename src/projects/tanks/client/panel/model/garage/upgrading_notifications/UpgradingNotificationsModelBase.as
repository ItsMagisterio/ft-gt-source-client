package projects.tanks.client.panel.model.garage.upgrading_notifications
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

   public class UpgradingNotificationsModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:projects.tanks.client.panel.model.garage.upgrading_notifications.UpgradingNotificationsModelServer;

      private var client:projects.tanks.client.panel.model.garage.upgrading_notifications.IUpgradingNotificationsModelBase;

      private var modelId:Long;

      private var _updateUpgradingNotificationsId:Long;

      private var _updateUpgradingNotifications_upgradingNotificationsCodec:ICodec;

      public function UpgradingNotificationsModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IUpgradingNotificationsModelBase(this);
         this.modelId = Long.getLong(1399227420, 1583322696);
         this._updateUpgradingNotificationsId = Long.getLong(1755662077, -300870741);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new projects.tanks.client.panel.model.garage.upgrading_notifications.UpgradingNotificationsModelServer(IModel(this));
         var _loc1_:ModelRegistry = ModelRegistry(OSGi.getInstance().getService(ModelRegistry));
         _loc1_.registerModelConstructorCodec(this.modelId, this._protocol.getCodec(new TypeCodecInfo(UpgradingNotificationsCC, false)));
         this._updateUpgradingNotifications_upgradingNotificationsCodec = this._protocol.getCodec(new CollectionCodecInfo(new TypeCodecInfo(UpgradingNotification, false), false, 1));
      }

      protected function getInitParam():UpgradingNotificationsCC
      {
         return UpgradingNotificationsCC(initParams[Model.object]);
      }

      override public function invoke(param1:Long, param2:ProtocolBuffer):void
      {
         switch (param1)
         {
            case this._updateUpgradingNotificationsId:
               this.client.updateUpgradingNotifications(this._updateUpgradingNotifications_upgradingNotificationsCodec.decode(param2) as Vector.<UpgradingNotification>);
         }
      }

      override public function get id():Long
      {
         return this.modelId;
      }
   }
}
