package alternativa.tanks.utils
{
   import flash.errors.IllegalOperationError;

   public class RangesUtils
   {

      public function RangesUtils()
      {
         super();
      }

      public static function coerceIn(param1:Number, param2:Number, param3:Number):Number
      {
         if (param2 > param3)
         {
            throw new IllegalOperationError("Not work!");
         }
         if (param1 < param2)
         {
            return param2;
         }
         return param1 > param3 ? param3 : param1;
      }

      public static function random(min:int = 0, max:int = 2147483647):int
      {
         if (min == max)
         {
            return min;
         }
         if (min < max)
         {
            return min + Math.random() * (max - min + 1);
         }
         return max + Math.random() * (min - max + 1);
      }

      public static function coerceAtMost(param1:Number, param2:Number):Number
      {
         return param1 > param2 ? param2 : param1;
      }
   }
}
