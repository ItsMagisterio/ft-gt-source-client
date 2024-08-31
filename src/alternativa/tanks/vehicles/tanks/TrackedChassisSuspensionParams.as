package alternativa.tanks.vehicles.tanks
{
   public class TrackedChassisSuspensionParams
   {

      public static const MAX_RAY_LENGTH:Number = 50;

      public static const NOMINAL_RAY_LENGTH:Number = 25;

      public static const RAY_OFFSET:Number = 10;

      public static const NUM_RAYS_PER_TRACK:int = 5;

      public static const MAX_SLOPE_ANGLE:Number = Math.PI / 1.5;

      public static const MAX_SLOPE_ANGLE_COS:Number = Math.cos(MAX_SLOPE_ANGLE);

      private var _dampingCoeff:Number = 1000;

      private var _springCoeff:Number = 10000;

      public function TrackedChassisSuspensionParams()
      {
         super();
      }

      public function get dampingCoeff():Number
      {
         return this._dampingCoeff;
      }

      public function setDampingCoeff(param1:Number):*
      {
         this._dampingCoeff = param1;
      }

      public function setSpringCoeff(param1:Number):*
      {
         this._springCoeff = param1;
      }

      public function get springCoeff():Number
      {
         return this._springCoeff;
      }
   }
}
