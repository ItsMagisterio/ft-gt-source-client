package projects.tanks.client.panel.model.garage.notification
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.ICodec;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.protocol.info.CollectionCodecInfo;
   import alternativa.protocol.info.EnumCodecInfo;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;
   import projects.tanks.client.commons.types.ItemViewCategoryEnum;

   public class GarageNotifierModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:projects.tanks.client.panel.model.garage.notification.GarageNotifierModelServer;

      private var client:projects.tanks.client.panel.model.garage.notification.IGarageNotifierModelBase;

      private var modelId:Long;

      private var _notifyDiscountsInGarageId:Long;

      private var _notifyDiscountsInGarage_categoriesCodec:ICodec;

      public function GarageNotifierModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IGarageNotifierModelBase(this);
         this.modelId = Long.getLong(1182350835, 2018490719);
         this._notifyDiscountsInGarageId = Long.getLong(2093836710, 240069855);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new projects.tanks.client.panel.model.garage.notification.GarageNotifierModelServer(IModel(this));
         this._notifyDiscountsInGarage_categoriesCodec = this._protocol.getCodec(new CollectionCodecInfo(new EnumCodecInfo(ItemViewCategoryEnum, false), false, 1));
      }

      override public function invoke(param1:Long, param2:ProtocolBuffer):void
      {
         switch (param1)
         {
            case this._notifyDiscountsInGarageId:
               this.client.notifyDiscountsInGarage(this._notifyDiscountsInGarage_categoriesCodec.decode(param2) as Vector.<ItemViewCategoryEnum>);
         }
      }

      override public function get id():Long
      {
         return this.modelId;
      }
   }
}
