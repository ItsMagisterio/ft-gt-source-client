package projects.tanks.client.panel.model.garage.availableitems
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
   import projects.tanks.client.panel.model.garage.GarageItemInfo;

   public class AvailableItemsModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:projects.tanks.client.panel.model.garage.availableitems.AvailableItemsModelServer;

      private var client:projects.tanks.client.panel.model.garage.availableitems.IAvailableItemsModelBase;

      private var modelId:Long;

      private var _showAvailableItemsId:Long;

      private var _showAvailableItems_itemsCodec:ICodec;

      public function AvailableItemsModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IAvailableItemsModelBase(this);
         this.modelId = Long.getLong(1203966282, 1135370561);
         this._showAvailableItemsId = Long.getLong(1961101871, -1859061910);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new projects.tanks.client.panel.model.garage.availableitems.AvailableItemsModelServer(IModel(this));
         this._showAvailableItems_itemsCodec = this._protocol.getCodec(new CollectionCodecInfo(new TypeCodecInfo(GarageItemInfo, false), false, 1));
      }

      override public function invoke(param1:Long, param2:ProtocolBuffer):void
      {
         switch (param1)
         {
            case this._showAvailableItemsId:
               this.client.showAvailableItems(this._showAvailableItems_itemsCodec.decode(param2) as Vector.<GarageItemInfo>);
         }
      }

      override public function get id():Long
      {
         return this.modelId;
      }
   }
}
