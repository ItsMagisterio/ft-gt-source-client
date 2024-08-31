package alternativa.tanks.camera.controllers.spectator
{
   import alternativa.math.Vector3;
   import alternativa.osgi.service.console.variables.ConsoleVarFloat;
   import alternativa.tanks.camera.GameCamera;

   internal class WalkMovement implements MovementMethod
   {

      private static const direction:Vector3 = new Vector3();

      private static const localDirection:Vector3 = new Vector3();

      private var _accelerationInverted:Boolean = false;

      private var conSpeed:ConsoleVarFloat;

      private var conAcceleration:ConsoleVarFloat;

      private var conDeceleration:ConsoleVarFloat;

      public function WalkMovement(_arg_1:ConsoleVarFloat, _arg_2:ConsoleVarFloat, _arg_3:ConsoleVarFloat)
      {
         super();
         this.conSpeed = _arg_1;
         this.conAcceleration = _arg_2;
         this.conDeceleration = _arg_3;
      }

      public function getDisplacement(_arg_1:UserInput, _arg_2:GameCamera, _arg_3:Number):Vector3
      {
         localDirection.y = _arg_1.getForwardDirection();
         localDirection.x = _arg_1.getSideDirection();
         var _local_4:Number = Math.cos(_arg_2.rotationZ);
         var _local_5:Number = Math.sin(_arg_2.rotationZ);
         direction.x = localDirection.x * _local_4 - localDirection.y * _local_5;
         direction.y = localDirection.x * _local_5 + localDirection.y * _local_4;
         direction.z = _arg_1.getVerticalDirection();
         if (direction.lengthSqr() > 0)
         {
            direction.normalize();
         }
         if (_arg_1.isAccelerated())
         {
            if (this._accelerationInverted)
            {
               direction.scale(this.conSpeed.value * this.conDeceleration.value * _arg_3);
            }
            else
            {
               direction.scale(this.conSpeed.value * this.conAcceleration.value * _arg_3);
            }
         }
         else
         {
            direction.scale(this.conSpeed.value * _arg_3);
         }
         return direction;
      }

      public function invertAcceleration():void
      {
         this._accelerationInverted = !this._accelerationInverted;
      }

      public function accelerationInverted():Boolean
      {
         return this._accelerationInverted;
      }

      public function setAccelerationInverted(_arg_1:Boolean):void
      {
         this._accelerationInverted = _arg_1;
      }
   }
}
