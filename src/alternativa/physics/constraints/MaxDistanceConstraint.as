package alternativa.physics.constraints
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.altphysics;

   use namespace altphysics;

   public class MaxDistanceConstraint extends Constraint
   {

      altphysics var body1:Body;

      altphysics var body2:Body;

      altphysics var r1:Vector3;

      altphysics var r2:Vector3;

      altphysics var maxDistance:Number;

      altphysics var wr1:Vector3;

      altphysics var wr2:Vector3;

      private var minClosingVel:Number;

      private var velByUnitImpulseN:Number;

      private var impulseDirection:Vector3;

      public function MaxDistanceConstraint(body1:Body, body2:Body, r1:Vector3, r2:Vector3, maxDistance:Number)
      {
         this.altphysics::wr1 = new Vector3();
         this.altphysics::wr2 = new Vector3();
         this.impulseDirection = new Vector3();
         super();
         this.altphysics::body1 = body1;
         this.altphysics::body2 = body2;
         this.altphysics::r1 = r1.vClone();
         this.altphysics::r2 = r2.vClone();
         this.altphysics::maxDistance = maxDistance;
      }

      override public function preProcess(dt:Number):void
      {
         var len:Number = NaN;
         var p2:Vector3 = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         var vx:Number = NaN;
         var vy:Number = NaN;
         var vz:Number = NaN;
         var m:Matrix3 = this.altphysics::body1.baseMatrix;
         this.altphysics::wr1.x = m.a * this.altphysics::r1.x + m.b * this.altphysics::r1.y + m.c * this.altphysics::r1.z;
         this.altphysics::wr1.y = m.e * this.altphysics::r1.x + m.f * this.altphysics::r1.y + m.g * this.altphysics::r1.z;
         this.altphysics::wr1.z = m.i * this.altphysics::r1.x + m.j * this.altphysics::r1.y + m.k * this.altphysics::r1.z;
         if (this.altphysics::body2 != null)
         {
            m = this.altphysics::body2.baseMatrix;
            this.altphysics::wr2.x = m.a * this.altphysics::r2.x + m.b * this.altphysics::r2.y + m.c * this.altphysics::r2.z;
            this.altphysics::wr2.y = m.e * this.altphysics::r2.x + m.f * this.altphysics::r2.y + m.g * this.altphysics::r2.z;
            this.altphysics::wr2.z = m.i * this.altphysics::r2.x + m.j * this.altphysics::r2.y + m.k * this.altphysics::r2.z;
         }
         else
         {
            this.altphysics::wr2.x = this.altphysics::r2.x;
            this.altphysics::wr2.y = this.altphysics::r2.y;
            this.altphysics::wr2.z = this.altphysics::r2.z;
         }
         var p1:Vector3 = this.altphysics::body1.state.pos;
         this.impulseDirection.x = this.altphysics::wr2.x - this.altphysics::wr1.x - p1.x;
         this.impulseDirection.y = this.altphysics::wr2.y - this.altphysics::wr1.y - p1.y;
         this.impulseDirection.z = this.altphysics::wr2.z - this.altphysics::wr1.z - p1.z;
         if (this.altphysics::body2 != null)
         {
            p2 = this.altphysics::body2.state.pos;
            this.impulseDirection.x += p2.x;
            this.impulseDirection.y += p2.y;
            this.impulseDirection.z += p2.z;
         }
         len = Math.sqrt(this.impulseDirection.x * this.impulseDirection.x + this.impulseDirection.y * this.impulseDirection.y + this.impulseDirection.z * this.impulseDirection.z);
         var delta:Number = len - this.altphysics::maxDistance;
         if (delta > 0)
         {
            altphysics::satisfied = false;
            if (len < 0.001)
            {
               this.impulseDirection.x = 1;
            }
            else
            {
               len = 1 / len;
               this.impulseDirection.x *= len;
               this.impulseDirection.y *= len;
               this.impulseDirection.z *= len;
            }
            this.minClosingVel = delta / (altphysics::world.penResolutionSteps * dt);
            if (this.minClosingVel > altphysics::world.maxPenResolutionSpeed)
            {
               this.minClosingVel = altphysics::world.maxPenResolutionSpeed;
            }
            this.velByUnitImpulseN = 0;
            if (this.altphysics::body1.movable)
            {
               vx = this.altphysics::wr1.y * this.impulseDirection.z - this.altphysics::wr1.z * this.impulseDirection.y;
               vy = this.altphysics::wr1.z * this.impulseDirection.x - this.altphysics::wr1.x * this.impulseDirection.z;
               vz = this.altphysics::wr1.x * this.impulseDirection.y - this.altphysics::wr1.y * this.impulseDirection.x;
               m = this.altphysics::body1.invInertiaWorld;
               x = m.a * vx + m.b * vy + m.c * vz;
               y = m.e * vx + m.f * vy + m.g * vz;
               z = m.i * vx + m.j * vy + m.k * vz;
               vx = y * this.altphysics::wr1.z - z * this.altphysics::wr1.y;
               vy = z * this.altphysics::wr1.x - x * this.altphysics::wr1.z;
               vz = x * this.altphysics::wr1.y - y * this.altphysics::wr1.x;
               this.velByUnitImpulseN += this.altphysics::body1.invMass + vx * this.impulseDirection.x + vy * this.impulseDirection.y + vz * this.impulseDirection.z;
            }
            if (this.altphysics::body2 != null && this.altphysics::body2.movable)
            {
               vx = this.altphysics::wr2.y * this.impulseDirection.z - this.altphysics::wr2.z * this.impulseDirection.y;
               vy = this.altphysics::wr2.z * this.impulseDirection.x - this.altphysics::wr2.x * this.impulseDirection.z;
               vz = this.altphysics::wr2.x * this.impulseDirection.y - this.altphysics::wr2.y * this.impulseDirection.x;
               m = this.altphysics::body2.invInertiaWorld;
               x = m.a * vx + m.b * vy + m.c * vz;
               y = m.e * vx + m.f * vy + m.g * vz;
               z = m.i * vx + m.j * vy + m.k * vz;
               vx = y * this.altphysics::wr2.z - z * this.altphysics::wr2.y;
               vy = z * this.altphysics::wr2.x - x * this.altphysics::wr2.z;
               vz = x * this.altphysics::wr2.y - y * this.altphysics::wr2.x;
               this.velByUnitImpulseN += this.altphysics::body2.invMass + vx * this.impulseDirection.x + vy * this.impulseDirection.y + vz * this.impulseDirection.z;
            }
         }
         else
         {
            altphysics::satisfied = true;
         }
      }

      override public function apply(dt:Number):void
      {
         if (altphysics::satisfied)
         {
            return;
         }
         var vel:Vector3 = this.altphysics::body1.state.velocity;
         var rot:Vector3 = this.altphysics::body1.state.rotation;
         var vx:Number = vel.x + rot.y * this.altphysics::wr1.z - rot.z * this.altphysics::wr1.y;
         var vy:Number = vel.y + rot.z * this.altphysics::wr1.x - rot.x * this.altphysics::wr1.z;
         var vz:Number = vel.z + rot.x * this.altphysics::wr1.y - rot.y * this.altphysics::wr1.x;
         if (this.altphysics::body2 != null)
         {
            vel = this.altphysics::body2.state.velocity;
            rot = this.altphysics::body2.state.rotation;
            vx -= vel.x + rot.y * this.altphysics::wr2.z - rot.z * this.altphysics::wr2.y;
            vy -= vel.y + rot.z * this.altphysics::wr2.x - rot.x * this.altphysics::wr2.z;
            vz -= vel.z + rot.x * this.altphysics::wr2.y - rot.y * this.altphysics::wr2.x;
         }
         var closingVel:Number = vx * this.impulseDirection.x + vy * this.impulseDirection.y + vz * this.impulseDirection.z;
         if (closingVel > this.minClosingVel)
         {
            return;
         }
         var impulse:Number = (this.minClosingVel - closingVel) / this.velByUnitImpulseN;
         if (this.altphysics::body1.movable)
         {
            this.altphysics::body1.applyRelPosWorldImpulse(this.altphysics::wr1, this.impulseDirection, impulse);
         }
         if (this.altphysics::body2 != null && this.altphysics::body2.movable)
         {
            this.altphysics::body2.applyRelPosWorldImpulse(this.altphysics::wr2, this.impulseDirection, -impulse);
         }
      }
   }
}
