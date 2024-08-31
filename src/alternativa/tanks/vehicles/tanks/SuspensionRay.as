package alternativa.tanks.vehicles.tanks
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.RayHit;
   import alternativa.physics.collision.types.RayIntersection;
   import flash.display.Graphics;
   import alternativa.engine3d.core.Camera3D;
   import flash.display.Graphics;
   import alternativa.engine3d.core.Debug;

   public class SuspensionRay
   {

      public var collisionGroup:int;

      public var hasCollision:Boolean = false;

      public var rayHit:RayIntersection;

      public var springForce:Number = 0;

      public const contactVelocity:Vector3 = new Vector3();

      public var speed:Number = 0;

      public var body:Body;

      private var origin:Vector3;

      private var direction:Vector3;

      private var suspensionParams:TrackedChassisSuspensionParams;

      private var globalOrigin:Vector3;

      private var globalDirection:Vector3;

      private var prevCompression:Number = 0;

      private var collisionFilter:RayPredicate;

      public function SuspensionRay(param1:Body, param2:Vector3, param3:Vector3, param4:TrackedChassisSuspensionParams)
      {
         this.rayHit = new RayIntersection();
         this.origin = new Vector3();
         this.direction = new Vector3();
         this.globalOrigin = new Vector3();
         this.globalDirection = new Vector3();
         super();
         this.body = param1;
         this.origin.copy(param2);
         this.direction.copy(param3);
         this.suspensionParams = param4;
         this.collisionFilter = new RayPredicate(param1);
      }

      public function update(param1:Number):void
      {
         this.raycast();
         if (this.hasCollision)
         {
            this.calculateSpringForce(param1);
            this.calculateContactVelocity();
         }
      }

      private function raycast():void
      {
         var _loc2_:Vector3 = null;
         var _loc1_:Matrix3 = this.body.baseMatrix;
         this.globalDirection.x = _loc1_.a * this.direction.x + _loc1_.b * this.direction.y + _loc1_.c * this.direction.z;
         this.globalDirection.y = _loc1_.e * this.direction.x + _loc1_.f * this.direction.y + _loc1_.g * this.direction.z;
         this.globalDirection.z = _loc1_.i * this.direction.x + _loc1_.j * this.direction.y + _loc1_.k * this.direction.z;
         _loc2_ = this.body.state.pos;
         this.globalOrigin.x = _loc1_.a * this.origin.x + _loc1_.b * this.origin.y + _loc1_.c * this.origin.z;
         this.globalOrigin.y = _loc1_.e * this.origin.x + _loc1_.f * this.origin.y + _loc1_.g * this.origin.z;
         this.globalOrigin.z = _loc1_.i * this.origin.x + _loc1_.j * this.origin.y + _loc1_.k * this.origin.z;
         this.globalOrigin.x += _loc2_.x;
         this.globalOrigin.y += _loc2_.y;
         this.globalOrigin.z += _loc2_.z;
         if (this.hasCollision)
         {
            this.prevCompression = TrackedChassisSuspensionParams.MAX_RAY_LENGTH - this.rayHit.t;
         }
         this.hasCollision = this.body.world.collisionDetector.intersectRay(this.globalOrigin, this.globalDirection, this.collisionGroup, TrackedChassisSuspensionParams.MAX_RAY_LENGTH, this.collisionFilter, this.rayHit);
         if (this.hasCollision)
         {
            this.hasCollision = this.rayHit.normal.z > TrackedChassisSuspensionParams.MAX_SLOPE_ANGLE_COS;
         }
      }

      /*
      Makes the Tank wobbly
      --springForce--
      */
      public function calculateSpringForce(param1:Number):void
      {
         var _loc2_:Number = TrackedChassisSuspensionParams.MAX_RAY_LENGTH - this.rayHit.t;
         this.springForce = this.suspensionParams.springCoeff * _loc2_;
         var _loc3_:Number = (_loc2_ - this.prevCompression) / param1;
         this.springForce += _loc3_ * this.suspensionParams.dampingCoeff;
         if (this.springForce < 0)
         {
            this.springForce = 0;
         }
      }

      private function calculateContactVelocity():void
      {
         var _loc2_:Vector3 = null;
         var _loc3_:Vector3 = null;
         var currRotation:Vector3 = null;
         var _loc5_:Vector3 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc1_:Body = this.rayHit.primitive.body;
         // original if(_loc1_.tank != null)
         if (_loc1_ != null)
         {
            _loc2_ = _loc1_.state.pos;
            _loc3_ = _loc1_.state.velocity;
            currRotation = _loc1_.state.rotation;
            _loc5_ = this.rayHit.pos;
            _loc6_ = _loc5_.x - _loc2_.x;
            _loc7_ = _loc5_.y - _loc2_.y;
            _loc8_ = _loc5_.z - _loc2_.z;
            this.contactVelocity.x = currRotation.y * _loc8_ - currRotation.z * _loc7_;
            this.contactVelocity.y = currRotation.z * _loc6_ - currRotation.x * _loc8_;
            this.contactVelocity.z = currRotation.x * _loc7_ - currRotation.y * _loc6_;
            this.contactVelocity.x += _loc3_.x;
            this.contactVelocity.y += _loc3_.y;
            this.contactVelocity.z += _loc3_.z;
         }
         else
         {
            this.contactVelocity.x = 0;
            this.contactVelocity.y = 0;
            this.contactVelocity.z = 0;
         }
      }

      public function debugDraw(g:Graphics, camera:Camera3D, data:SuspensionData):void
      {
         this.contactVelocity.vCopy(this.body.world._gravity).vAddScaled(data.rayLength, this.body.state.rotation);
         this.drawLine(g, camera, this.body.world._gravity, this.body.state.velocity, 0xFFFF00, 4);
         if (this.hasCollision)
         {
            this.drawLine(g, camera, this.body.world._gravity, this.rayHit.pos, 0xFF0000, 4);
            this.contactVelocity.vCopy(this.rayHit.pos).vAddScaled(data.rayLength, this.rayHit.normal);
            this.drawLine(g, camera, this.rayHit.pos, this.contactVelocity, 0xFFFF, 1);
         }
      }

      private function drawLine(g:Graphics, camera:Camera3D, wBegin:Vector3, wEnd:Vector3, color:int, thickness:int = 0, alpha:Number = 1):void
      {
      }

      public function getGlobalOrigin():Vector3
      {
         return this.globalOrigin;
      }

      public function getGlobalDirection():Vector3
      {
         return this.globalDirection;
      }

      public function getOrigin():Vector3
      {
         return this.origin;
      }
   }
}
