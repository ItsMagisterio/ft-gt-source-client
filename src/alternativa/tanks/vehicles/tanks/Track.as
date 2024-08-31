package alternativa.tanks.vehicles.tanks
{
   import alternativa.tanks.vehicles.tanks.TrackedChassisSuspensionParams;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.math.Vector3;
   import flash.display.Graphics;

   public class Track
   {

      public var tank:Tank;

      public var rays:Vector.<SuspensionRay>;

      public var raysNum:int;

      public var lastContactsNum:int;

      public var animationSpeed:Number = 0;

      public const averageSurfaceVelocity:Vector3 = new Vector3();

      public function Track(tank:Tank, raysNum:int, relPos:Vector3, trackLength:Number, trackedChassisParams:TrackedChassisSuspensionParams)
      {
         super();
         this.tank = tank;
         this.setTrackParams(raysNum, relPos, trackLength, trackedChassisParams);
      }

      public function set collisionGroup(value:int):void
      {
         for (var i:int = 0; i < this.raysNum; SuspensionRay(this.rays[i]).collisionGroup = value, i++)
         {
         }
      }

      public function setTrackParams(raysNum:int, relPos:Vector3, trackLength:Number, trackedChassisParams:TrackedChassisSuspensionParams):void
      {
         this.raysNum = raysNum;
         this.rays = new Vector.<SuspensionRay>(raysNum);
         var step:Number = trackLength / (raysNum - 1);
         for (var i:int = 0; i < raysNum; )
         {
            this.rays[i] = new SuspensionRay(this.tank, new Vector3(relPos.x, relPos.y + 0.5 * trackLength - i * step, relPos.z), new Vector3(0, 0, -1), trackedChassisParams);
            i++;
         }
      }

      public function addForces(dt:Number, throttle:Number, maxSpeed:Number, slipTerm:int, weight:Number, data:SuspensionData, brake:Boolean):void
      {
         this.lastContactsNum = 0;
         var i:int = 0;
         for (i = 0; i < this.raysNum; i++)
         {
            // SuspensionRay(this.rays[i]).addForce(dt,throttle,maxSpeed,i <= mid ? int(int(slipTerm)) : int(int(-slipTerm)),springCoeff,data,brake);
            SuspensionRay(this.rays[i]).update(dt);
            if (SuspensionRay(this.rays[i]).hasCollision)
            {
               ++ this.lastContactsNum;
            }
         }
         // var i:int = 0;
         // this.lastContactsNum = 0;
         // for(i = 0; i < this.raysNum; i++)
         // {
         // if(SuspensionRay(this.rays[i]).calculateIntersection(data.rayLength))
         // {
         // ++this.lastContactsNum;
         // }
         // }
         // if(this.lastContactsNum == 0)
         // {
         // return;
         // }
         // var springCoeff:Number = 0.5 * weight / (this.lastContactsNum * data.rayOptimalLength);
         // throttle *= this.raysNum / this.lastContactsNum;
         // var mid:int = this.raysNum >> 1;
         // if(this.raysNum & 1 == 0)
         // {
         // for(i = 0; i < this.raysNum; i++)
         // {
         // //SuspensionRay(this.rays[i]).addForce(dt,throttle,maxSpeed,i <= mid ? int(int(slipTerm)) : int(int(-slipTerm)),springCoeff,data,brake);
         // SuspensionRay(this.rays[i]).update(dt)
         // 
         // }
         // }
         // else
         // {
         // for(i = 0; i < this.raysNum; i++)
         // {
         // //SuspensionRay(this.rays[i]).addForce(dt,throttle,maxSpeed,i < mid ? int(int(slipTerm)) : (i > mid ? int(int(-slipTerm)) : int(int(0))),springCoeff,data,brake);
         // SuspensionRay(this.rays[i]).update(dt)
         // 
         // }
         // }
      }

      public function calculateSuspensionContacts(param1:Number):void
      {
         var _loc2_:Vector3 = null;
         var _loc4_:SuspensionRay = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         this.lastContactsNum = 0;
         this.averageSurfaceVelocity.x = 0;
         this.averageSurfaceVelocity.y = 0;
         this.averageSurfaceVelocity.z = 0;
         _loc2_ = this.tank.state.velocity;
         var _loc3_:int = 0;
         while (_loc3_ < this.raysNum)
         {
            _loc4_ = this.rays[_loc3_];
            _loc4_.update(param1);
            if (_loc4_.hasCollision)
            {
               ++ this.lastContactsNum;
               this.tank.addWorldForceScaled(_loc4_.getGlobalOrigin(), _loc4_.getGlobalDirection(), -_loc4_.springForce);
               this.averageSurfaceVelocity.x += _loc4_.contactVelocity.x;
               this.averageSurfaceVelocity.y += _loc4_.contactVelocity.y;
               this.averageSurfaceVelocity.z += _loc4_.contactVelocity.z;
               _loc5_ = _loc2_.x - _loc4_.contactVelocity.x;
               _loc6_ = _loc2_.y - _loc4_.contactVelocity.y;
               _loc7_ = _loc2_.z - _loc4_.contactVelocity.z;
               _loc4_.speed = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_ + _loc7_ * _loc7_);
            }
            else
            {
               _loc4_.speed = 0;
            }
            _loc3_++;
         }
         if (this.lastContactsNum > 1)
         {
            this.averageSurfaceVelocity.x /= this.lastContactsNum;
            this.averageSurfaceVelocity.y /= this.lastContactsNum;
            this.averageSurfaceVelocity.z /= this.lastContactsNum;
         }
      }

      public function debugDraw(g:Graphics, camera:Camera3D, data:SuspensionData):void
      {
         var ray:SuspensionRay = null;
         for each (ray in this.rays)
         {
            ray.debugDraw(g, camera, data);
         }
      }

      public function setAnimationSpeed(param1:Number, param2:Number):void
      {
         var _loc3_:Number = NaN;
         if (this.animationSpeed < param1)
         {
            _loc3_ = this.animationSpeed + param2;
            this.animationSpeed = _loc3_ > param1 ? Number(Number(Number(param1))) : Number(Number(Number(_loc3_)));
         }
         else if (this.animationSpeed > param1)
         {
            _loc3_ = this.animationSpeed - param2;
            this.animationSpeed = _loc3_ < param1 ? Number(Number(Number(param1))) : Number(Number(Number(_loc3_)));
         }
      }
   }
}
