package alternativa.tanks.utils
{
   import alternativa.math.Vector3;

   public class MathUtils
   {

      public static const PI2:Number = 2 * Math.PI;

      public function MathUtils()
      {
         super();
      }

      public static function toRadians(param1:Number):Number
      {
         return param1 * Math.PI / 180;
      }

      public static function fillDirectionVector(param1:Vector3, param2:Number):void
      {
         param1.x = -Math.sin(param2);
         param1.y = Math.cos(param2);
         param1.z = 0;
      }

      public static function getDirectionAngle(param1:Vector3):Number
      {
         return Math.atan2(-param1.x, param1.y);
      }

      public static function changeBitValue(param1:int, param2:int, param3:Boolean):int
      {
         if (param3)
         {
            return param1 | 1 << param2;
         }
         return param1 & ~(1 << param2);
      }

      public static function clampAngleDelta(param1:Number, param2:Number):Number
      {
         var _loc3_:Number = param1 - param2;
         if (_loc3_ <= -Math.PI)
         {
            return _loc3_ + PI2;
         }
         if (_loc3_ > Math.PI)
         {
            return _loc3_ - PI2;
         }
         return _loc3_;
      }

      public static function numberSign(param1:Number, param2:Number):Number
      {
         if (param1 < 0)
         {
            return param1 < -param2 ? Number(-1) : Number(0);
         }
         if (param1 > 0)
         {
            return param1 > param2 ? Number(1) : Number(0);
         }
         return 0;
      }

      public static function sign(param1:Number):Number
      {
         if (param1 < 0)
         {
            return -1;
         }
         if (param1 > 0)
         {
            return 1;
         }
         return 0;
      }

      public static function snap(param1:Number, param2:Number, param3:Number):Number
      {
         if (param1 > param2 - param3 && param1 < param2 + param3)
         {
            return param2;
         }
         return param1;
      }

      public static function moveValueTowards(param1:Number, param2:Number, param3:Number):Number
      {
         if (param1 < param2)
         {
            param1 += param3;
            return param1 > param2 ? param2 : param1;
         }
         if (param1 > param2)
         {
            param1 -= param3;
            return param1 < param2 ? param2 : param1;
         }
         return param1;
      }

      public static function clamp(value:Number, min:Number, max:Number):Number
      {
         if (value < min)
         {
            return min;
         }
         if (value > max)
         {
            return max;
         }
         return value;
      }

      public static function clampAngle(radians:Number):Number
      {
         radians %= PI2;
         if (radians < -Math.PI)
         {
            return PI2 + radians;
         }
         if (radians > Math.PI)
         {
            return radians - PI2;
         }
         return radians;
      }

      public static function clampAngleFast(radians:Number):Number
      {
         if (radians < -Math.PI)
         {
            return PI2 + radians;
         }
         if (radians > Math.PI)
         {
            return radians - PI2;
         }
         return radians;
      }

      public static function getBitValue(param1:int, param2:int):int
      {
         return param1 >> param2 & 1;
      }

      public static function nearestPowerOf2(param1:int):int
      {
         return 1 << Math.ceil(Math.log(param1) / Math.LN2);
      }
   }
}
