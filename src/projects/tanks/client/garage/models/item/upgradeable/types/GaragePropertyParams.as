package projects.tanks.client.garage.models.item.upgradeable.types
{
   import projects.tanks.client.commons.types.ItemGarageProperty;

   public class GaragePropertyParams
   {

      private var _precision:int;

      private var _properties:Vector.<projects.tanks.client.garage.models.item.upgradeable.types.PropertyData>;

      private var _property:ItemGarageProperty;

      private var _visibleInInfo:Boolean;

      public function GaragePropertyParams(param1:int = 0, param2:Vector.<projects.tanks.client.garage.models.item.upgradeable.types.PropertyData> = null, param3:ItemGarageProperty = null, param4:Boolean = false)
      {
         super();
         this._precision = param1;
         this._properties = param2;
         this._property = param3;
         this._visibleInInfo = param4;
      }

      public function get precision():int
      {
         return this._precision;
      }

      public function set precision(param1:int):void
      {
         this._precision = param1;
      }

      public function get properties():Vector.<projects.tanks.client.garage.models.item.upgradeable.types.PropertyData>
      {
         return this._properties;
      }

      public function set properties(param1:Vector.<projects.tanks.client.garage.models.item.upgradeable.types.PropertyData>):void
      {
         this._properties = param1;
      }

      public function get property():ItemGarageProperty
      {
         return this._property;
      }

      public function set property(param1:ItemGarageProperty):void
      {
         this._property = param1;
      }

      public function get visibleInInfo():Boolean
      {
         return this._visibleInInfo;
      }

      public function set visibleInInfo(param1:Boolean):void
      {
         this._visibleInInfo = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "GaragePropertyParams [";
         _loc1_ += "precision = " + this.precision + " ";
         _loc1_ += "properties = " + this.properties + " ";
         _loc1_ += "property = " + this.property + " ";
         _loc1_ += "visibleInInfo = " + this.visibleInInfo + " ";
         return _loc1_ + "]";
      }
   }
}
