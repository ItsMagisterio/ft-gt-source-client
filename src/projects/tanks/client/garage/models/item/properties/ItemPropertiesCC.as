package projects.tanks.client.garage.models.item.properties
{
   public class ItemPropertiesCC
   {

      private var _properties:Vector.<projects.tanks.client.garage.models.item.properties.ItemGaragePropertyData>;

      public function ItemPropertiesCC(param1:Vector.<projects.tanks.client.garage.models.item.properties.ItemGaragePropertyData> = null)
      {
         super();
         this._properties = param1;
      }

      public function get properties():Vector.<projects.tanks.client.garage.models.item.properties.ItemGaragePropertyData>
      {
         return this._properties;
      }

      public function set properties(param1:Vector.<projects.tanks.client.garage.models.item.properties.ItemGaragePropertyData>):void
      {
         this._properties = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "ItemPropertiesCC [";
         _loc1_ += "properties = " + this.properties + " ";
         return _loc1_ + "]";
      }
   }
}
