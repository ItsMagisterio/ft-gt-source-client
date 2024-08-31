package projects.tanks.client.garage.models.item.upgradeable.discount
{
   import alternativa.osgi.OSGi;
   import alternativa.protocol.IProtocol;
   import alternativa.protocol.ProtocolBuffer;
   import alternativa.types.Long;
   import platform.client.fp10.core.model.IModel;
   import platform.client.fp10.core.model.impl.Model;

   public class DiscountForUpgradeModelBase extends Model
   {

      private var _protocol:IProtocol;

      protected var server:projects.tanks.client.garage.models.item.upgradeable.discount.DiscountForUpgradeModelServer;

      private var client:projects.tanks.client.garage.models.item.upgradeable.discount.IDiscountForUpgradeModelBase;

      private var modelId:Long;

      public function DiscountForUpgradeModelBase()
      {
         this._protocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.client = IDiscountForUpgradeModelBase(this);
         this.modelId = Long.getLong(728120764, 157623916);
         super();
         this.initCodecs();
      }

      protected function initCodecs():void
      {
         this.server = new projects.tanks.client.garage.models.item.upgradeable.discount.DiscountForUpgradeModelServer(IModel(this));
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
