package alternativa.math
{
   import flash.geom.Vector3D;

   public class Vector3 extends Vector3D
   {

      public static const ZERO:Vector3 = new Vector3(0, 0, 0);

      public static const X_AXIS:Vector3 = new Vector3(1, 0, 0);

      public static const Y_AXIS:Vector3 = new Vector3(0, 1, 0);

      public static const Z_AXIS:Vector3 = new Vector3(0, 0, 1);

      public static const DOWN:Vector3 = new Vector3(0, 0, -1);

      private var x_:Number;

      private var y_:Number;

      private var z_:Number;

      public function Vector3(x:Number = 0, y:Number = 0, z:Number = 0)
      {
         super();
         this.x = x;
         this.y = y;
         this.z = z;
      }

      public function setLengthAlongDirection(param1:Vector3, param2:Number):void
      {
         var _loc3_:Number = this.x * param1.x + this.y * param1.y + this.z * param1.z;
         var _loc4_:Number = param2 - _loc3_;
         this.x += _loc4_ * param1.x;
         this.y += _loc4_ * param1.y;
         this.z += _loc4_ * param1.z;
      }

      public static function interpolate(param1:Number, param2:Vector3, param3:Vector3, param4:Vector3):void
      {
         param4.x = param2.x + param1 * (param3.x - param2.x);
         param4.y = param2.y + param1 * (param3.y - param2.y);
         param4.z = param2.z + param1 * (param3.z - param2.z);
      }

      public static function distanceBetween(param1:Vector3, param2:Vector3):Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         var _loc5_:Number = param1.z - param2.z;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_);
      }

      public function vLength():Number
      {
         return Math.sqrt(x * x + y * y + z * z);
      }

      public function vLengthSqr():Number
      {
         return x * x + y * y + z * z;
      }

      public function vSetLength(length:Number):Vector3
      {
         var k:Number = NaN;
         var d:Number = x * x + y * y + z * z;
         if (d == 0)
         {
            x = length;
         }
         else
         {
            k = length / Math.sqrt(x * x + y * y + z * z);
            x *= k;
            y *= k;
            z *= k;
         }
         return this;
      }

      public function vNormalize():Vector3
      {
         var d:Number = x * x + y * y + z * z;
         if (d == 0)
         {
            x = 1;
         }
         else
         {
            d = Math.sqrt(d);
            x /= d;
            y /= d;
            z /= d;
         }
         return this;
      }

      public function vAdd(v:Vector3):Vector3
      {
         x += v.x;
         y += v.y;
         z += v.z;
         return this;
      }

      public function vRemove(v:Vector3):Vector3
      {
         x -= v.x;
         y -= v.y;
         z -= v.z;
         return this;
      }

      public function vAddScaled(k:Number, v:Vector3):Vector3
      {
         x += k * v.x;
         y += k * v.y;
         z += k * v.z;
         return this;
      }

      public function vSubtract(v:Vector3):Vector3
      {
         x -= v.x;
         y -= v.y;
         z -= v.z;
         return this;
      }

      public function vSum(a:Vector3, b:Vector3):Vector3
      {
         x = a.x + b.x;
         y = a.y + b.y;
         z = a.z + b.z;
         return this;
      }

      public function vDiff(a:Vector3, b:Vector3):Vector3
      {
         x = a.x - b.x;
         y = a.y - b.y;
         z = a.z - b.z;
         return this;
      }

      public function vCosAngle(v:Vector3):Number
      {
         return (x * v.x + y * v.y + z * v.z) / (Math.sqrt(x * x + y * y + z * z) * Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z));
      }

      public function vScale(k:Number):Vector3
      {
         x *= k;
         y *= k;
         z *= k;
         return this;
      }

      public function vReverse():Vector3
      {
         x = -x;
         y = -y;
         z = -z;
         return this;
      }

      public function distanceToSquared(param1:Vector3):Number
      {
         var _loc2_:Number = this.x - param1.x;
         var _loc3_:Number = this.y - param1.y;
         var _loc4_:Number = this.z - param1.z;
         return _loc2_ * _loc2_ + _loc3_ * _loc3_ + _loc4_ * _loc4_;
      }

      public function vDot(v:Vector3):Number
      {
         return x * v.x + y * v.y + z * v.z;
      }

      public function vCross(v:Vector3):Vector3
      {
         var xx:Number = y * v.z - z * v.y;
         var yy:Number = z * v.x - x * v.z;
         var zz:Number = x * v.y - y * v.x;
         x = xx;
         y = yy;
         z = zz;
         return this;
      }

      public function vCross2(a:Vector3, b:Vector3):Vector3
      {
         x = a.y * b.z - a.z * b.y;
         y = a.z * b.x - a.x * b.z;
         z = a.x * b.y - a.y * b.x;
         return this;
      }

      public function vTransformBy3(m:Matrix3):Vector3
      {
         var xx:Number = x;
         var yy:Number = y;
         var zz:Number = z;
         x = m.a * xx + m.b * yy + m.c * zz;
         y = m.e * xx + m.f * yy + m.g * zz;
         z = m.i * xx + m.j * yy + m.k * zz;
         return this;
      }

      public function vTransformBy3Tr(m:Matrix3):Vector3
      {
         var xx:Number = x;
         var yy:Number = y;
         var zz:Number = z;
         x = m.a * xx + m.e * yy + m.i * zz;
         y = m.b * xx + m.f * yy + m.j * zz;
         z = m.c * xx + m.g * yy + m.k * zz;
         return this;
      }

      public function vTransformBy4(m:Matrix4):Vector3
      {
         var xx:Number = x;
         var yy:Number = y;
         var zz:Number = z;
         x = m.a * xx + m.b * yy + m.c * zz + m.d;
         y = m.e * xx + m.f * yy + m.g * zz + m.h;
         z = m.i * xx + m.j * yy + m.k * zz + m.l;
         return this;
      }

      public function vTransformInverseBy4(m:Matrix4):Vector3
      {
         var xx:Number = x - m.d;
         var yy:Number = y - m.h;
         var zz:Number = z - m.l;
         x = m.a * xx + m.e * yy + m.i * zz;
         y = m.b * xx + m.f * yy + m.j * zz;
         z = m.c * xx + m.g * yy + m.k * zz;
         return this;
      }

      public function vDeltaTransformBy4(m:Matrix4):Vector3
      {
         var xx:Number = x;
         var yy:Number = y;
         var zz:Number = z;
         x = m.a * xx + m.b * yy + m.c * zz;
         y = m.e * xx + m.f * yy + m.g * zz;
         z = m.i * xx + m.j * yy + m.k * zz;
         return this;
      }

      public function deltaTransform4(param1:Matrix4):Vector3
      {
         var _loc2_:Number = this.x;
         var _loc3_:Number = this.y;
         var _loc4_:Number = this.z;
         this.x = param1.a * _loc2_ + param1.b * _loc3_ + param1.c * _loc4_;
         this.y = param1.e * _loc2_ + param1.f * _loc3_ + param1.g * _loc4_;
         this.z = param1.i * _loc2_ + param1.j * _loc3_ + param1.k * _loc4_;
         return this;
      }

      public function vReset(x:Number = 0, y:Number = 0, z:Number = 0):Vector3
      {
         this.x = x;
         this.y = y;
         this.z = z;
         return this;
      }

      public function vCopy(v:Vector3):Vector3
      {
         x = v.x;
         y = v.y;
         z = v.z;
         return this;
      }

      public function vClone():Vector3
      {
         return new Vector3(x, y, z);
      }

      public function toVector3D(result:Vector3D):Vector3D
      {
         result.x = x;
         result.y = y;
         result.z = z;
         return result;
      }

      public function copy(param1:Vector3):Vector3
      {
         this.x = param1.x;
         this.y = param1.y;
         this.z = param1.z;
         return this;
      }

      public function interpolate(param1:Number, param2:Vector3, param3:Vector3):void
      {
         this.x = param2.x + param1 * (param3.x - param2.x);
         this.y = param2.y + param1 * (param3.y - param2.y);
         this.z = param2.z + param1 * (param3.z - param2.z);
      }

      public function copyFromVector3D(source:Vector3D):Vector3
      {
         x = source.x;
         y = source.y;
         z = source.z;
         return this;
      }

      override public function copyFrom(source:Vector3D):void
      {
         x = source.x;
         y = source.y;
         z = source.z;
      }

      public function lengthSqr():Number
      {
         return this.x * this.x + this.y * this.y + this.z * this.z;
      }

      public function scale(param1:Number):Vector3
      {
         this.x *= param1;
         this.y *= param1;
         this.z *= param1;
         return this;
      }

      public function reset(param1:Number = 0, param2:Number = 0, param3:Number = 0):Vector3
      {
         this.x = param1;
         this.y = param2;
         this.z = param3;
         return this;
      }

      public function transformTransposed3(param1:Matrix3):Vector3
      {
         var _loc2_:Number = this.x;
         var _loc3_:Number = this.y;
         var _loc4_:Number = this.z;
         this.x = param1.a * _loc2_ + param1.e * _loc3_ + param1.i * _loc4_;
         this.y = param1.b * _loc2_ + param1.f * _loc3_ + param1.j * _loc4_;
         this.z = param1.c * _loc2_ + param1.g * _loc3_ + param1.k * _loc4_;
         return this;
      }

      public function distanceTo(param1:Vector3):Number
      {
         var _loc2_:Number = this.x - param1.x;
         var _loc3_:Number = this.y - param1.y;
         var _loc4_:Number = this.z - param1.z;
         return Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_ + _loc4_ * _loc4_);
      }

      override public function toString():String
      {
         return "Vector3(" + x + ", " + y + ", " + z + ")";
      }
   }
}
