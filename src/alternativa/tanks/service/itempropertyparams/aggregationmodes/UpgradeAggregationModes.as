package alternativa.tanks.service.itempropertyparams.aggregationmodes
{
   public class UpgradeAggregationModes
   {

      public static const SUM:alternativa.tanks.service.itempropertyparams.aggregationmodes.UpgradeAggregationMode = new SumUpgradeAggregationMode();

      public static const RANGE:alternativa.tanks.service.itempropertyparams.aggregationmodes.UpgradeAggregationMode = new RangeUpgradeAggregationMode();

      public static const CRIT:alternativa.tanks.service.itempropertyparams.aggregationmodes.UpgradeAggregationMode = new CritUpgradeAggregationMode();

      public static const INVERT:alternativa.tanks.service.itempropertyparams.aggregationmodes.UpgradeAggregationMode = new InvertUpgradeAggregationMode();

      public function UpgradeAggregationModes()
      {
         super();
      }
   }
}
