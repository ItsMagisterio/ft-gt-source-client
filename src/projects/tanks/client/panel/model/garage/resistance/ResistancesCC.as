package projects.tanks.client.panel.model.garage.resistance
{
   import projects.tanks.client.commons.types.ItemGarageProperty;

   public class ResistancesCC
   {

      private var _resistances:Vector.<ItemGarageProperty>;

      public function ResistancesCC(param1:Vector.<ItemGarageProperty> = null)
      {
         super();
         this._resistances = param1;
      }

      public function get resistances():Vector.<ItemGarageProperty>
      {
         return this._resistances;
      }

      public function set resistances(param1:Vector.<ItemGarageProperty>):void
      {
         this._resistances = param1;
      }

      public function toString():String
      {
         var _loc1_:String = "ResistancesCC [";
         _loc1_ += "resistances = " + this.resistances + " ";
         return _loc1_ + "]";
      }
   }
}
