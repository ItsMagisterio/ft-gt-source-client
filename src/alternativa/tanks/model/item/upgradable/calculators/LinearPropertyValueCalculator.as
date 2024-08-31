package alternativa.tanks.model.item.upgradable.calculators
{
   public class LinearPropertyValueCalculator implements PropertyValueCalculator
   {

      protected var calculator:alternativa.tanks.model.item.upgradable.calculators.UpgradeLinearCalculator;

      public function LinearPropertyValueCalculator(param1:Number, param2:Number, param3:int)
      {
         super();
         this.calculator = new alternativa.tanks.model.item.upgradable.calculators.UpgradeLinearCalculator(param1, param2, param3);
      }

      public function getNumberValue(param1:int):Number
      {
         return this.calculator.getValue(param1);
      }
   }
}
