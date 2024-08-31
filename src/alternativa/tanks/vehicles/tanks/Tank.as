package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.physics.CollisionPrimitiveListItem;
   import alternativa.physics.altphysics;
   import alternativa.physics.collision.primitives.CollisionBox;
   import alternativa.physics.rigid.Body3D;
   import alternativa.tanks.display.usertitle.UserTitle;
   import alternativa.tanks.models.battlefield.logic.updaters.HullTransformUpdater;
   import alternativa.tanks.models.battlefield.logic.updaters.LocalHullTransformUpdater;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.turret.TurretController;
   import alternativa.tanks.models.weapon.AllGlobalGunParams;
   import alternativa.tanks.models.weapon.WeaponUtils;
   import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
   import flash.display.Graphics;
   import flash.utils.Dictionary;
   import alternativa.tanks.utils.MathUtils;
   import alternativa.tanks.camera.CameraTarget;
   import alternativa.tanks.battle.BattleUtils;
   import alternativa.tanks.camera.FollowCameraController;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.init.Main;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.console.IConsole;

   use namespace altphysics;

   public class Tank extends Body3D implements CameraTarget
   {

      private static const FORWARD:int = 1;

      private static const BACK:int = 2;

      private static const LEFT:int = 4;

      private static const RIGHT:int = 8;

      private static const TURRET_LEFT:int = 16;

      private static const TURRET_RIGHT:int = 32;

      private static const CENTER_TURRET:int = 64;

      private static const REVERSE_TURN_BIT:int = 128;

      private static const PI:Number = Math.PI;

      private static const PI2:Number = 2 * Math.PI;

      private static var _m:Matrix3 = new Matrix3();

      private static const m41:Matrix4 = new Matrix4();

      private static const m42:Matrix4 = new Matrix4();

      private static var _orient:Quaternion = new Quaternion();

      private static var _pos:Vector3 = new Vector3();

      private static var _v:Vector3 = new Vector3();

      private static var _vMouse:Vector3 = new Vector3();

      private static var _vin:Vector.<Number> = Vector.<Number>([0, 0, 0]);

      private static var _vout:Vector.<Number> = Vector.<Number>([0, 0, 0]);

      public var tankData:TankData;

      public var maxSpeed:Number = 0;

      private var maxSpeedSmoother:IValueSmoother;

      public var maxTurnSpeed:Number = 0;

      private var maxTurnSpeedSmoother:ValueSmoother;

      public var maxTurretTurnSpeed:Number = 0;

      private var maxTurretTurnSpeedSmoother:ValueSmoother;

      public var turretTurnAcceleration:Number = 0;

      public var turretTurnSpeed:Number = 0;

      public var mass:Number;

      public var suspensionData:SuspensionData;

      public var skinZCorrection:Number = 0;

      public var mainCollisionBox:CollisionBox;

      public var visibilityPoints:Vector.<Vector3>;

      private const RAY_OFFSET:Number = 5;

      private var dimensions:Vector3;

      public var _skin:TankSkin;

      private var _title:UserTitle;

      public var leftTrack:Track;

      public var rightTrack:Track;

      private var trackSpeed:calculateTrackSpeed;

      public var leftThrottle:Number = 0;

      public var rightThrottle:Number = 0;

      private var leftBrake:Boolean;

      private var rightBrake:Boolean;

      private var bbs:Dictionary;

      private var container:Scene3DContainer;

      private var _showCollisionGeometry:Boolean;

      private var titleContainer:Scene3DContainer;

      private var local:Boolean;

      private var jumpActivated:Boolean;

      private var shpereRadius:Number;

      public var hullTransformUpdater:HullTransformUpdater;

      private var notLockedHullUpdater:HullTransformUpdater;

      private var lockedHullTransformUpdater:LocalHullTransformUpdater;

      public var interpolatedPosition:Vector3;

      public var interpolatedOrientation:Quaternion;

      public var skinCenterOffset:Vector3;

      private const _acceleration:Number = 0;

      private var turretController:TurretController;

      private var animatedTracks:Boolean;

      private static const _xAxis:Vector3 = new Vector3();

      private static const _yAxis:Vector3 = new Vector3();

      private static const _zAxis:Vector3 = new Vector3();

      private static const _surfaceVelocity:Vector3 = new Vector3();

      private static const _surfaceAngularVelocity:Vector3 = new Vector3();

      private static const _relativeVelocity:Vector3 = new Vector3();

      private static const _relativeAngularVelocity:Vector3 = new Vector3();

      private static const _forceVector:Vector3 = new Vector3();

      private static const _midPoint:Vector3 = new Vector3();

      public var movementDirection:int;

      private var speedCharacteristics:SpeedCharacteristics;

      public static const TURN_SPEED_COUNT:int = 7;

      private static const MIN_ACCELERATION:Number = 400;

      public var turnSpeedNumber:int;

      public var turnDirection:int;

      public var inverseBackTurnMovement:Boolean;

      private var suspensionParams:TrackedChassisSuspensionParams;

      private static const ANGLE_EPSILON:Number = MathUtils.toRadians(0.5);

      public function Tank(skin:TankSkin, mass:Number, maxSpeed:Number, maxTurnSpeed:Number, turretMaxTurnSpeed:Number, turretTurnAcceleration:Number, isLocal:Boolean, titleContainer:Scene3DContainer, rayLength:Number = 50, rayOptimalLength:Number = 25, dampingCoeff:Number = 1000, friction:Number = 0.1, rays:Number = 5)
      {
         this.suspensionParams = new TrackedChassisSuspensionParams();
         this.maxTurnSpeedSmoother = new ValueSmoother(100, 1000, 0, 0);
         this.maxTurretTurnSpeedSmoother = new ValueSmoother(100, 1000, 0, 0);
         this.suspensionData = new SuspensionData();
         this.dimensions = new Vector3();
         this.trackSpeed = new calculateTrackSpeed();
         this.bbs = new Dictionary();
         this.skinCenterOffset = new Vector3();
         super(0, Matrix3.ZERO, isLocal);
         this._skin = skin;
         this.maxSpeed = maxSpeed;
         this.maxTurnSpeed = maxTurnSpeed;
         this.maxTurretTurnSpeed = turretMaxTurnSpeed;
         this.turretTurnAcceleration = turretTurnAcceleration;
         this.titleContainer = titleContainer;
         this.local = isLocal;
         this._title = new UserTitle(this.local);
         this.lockedHullTransformUpdater = new LocalHullTransformUpdater(this);
         if (isLocal)
         {
            this.maxSpeedSmoother = new SecureValueSmoother(100, 1000, 0, 0);
         }
         else
         {
            this.maxSpeedSmoother = new ValueSmoother(100, 1000, 0, 0);
         }
         var mesh:Mesh = skin.hullDescriptor.mesh;
         mesh.calculateBounds();
         var dimensions:Vector3 = new Vector3(2 * mesh.boundMaxX, 2 * mesh.boundMaxY, mesh.boundMaxZ);
         this.setMassAndDimensions(mass, dimensions);
         var trackLengthMultiplier:int = 0.8;
         this.createTracks(rays, dimensions.y * 0.8, dimensions.x - 40);
         this.suspensionData.rayLength = rayLength;
         this.suspensionData.rayOptimalLength = rayOptimalLength;
         this.suspensionData.dampingCoeff = dampingCoeff;
         material.friction = friction;
         this.setOptimalZCorrection();
         var raduis:Vector3 = this.calculateSizeFromMesh(mesh);
         var hall:Vector3 = new Vector3(raduis.x / 2, raduis.y / 2, raduis.z / 2);
         var p1:Number = 2 * hall.z - (this.suspensionData.rayOptimalLength - 10);
         this.interpolatedOrientation = new Quaternion();
         this.interpolatedPosition = new Vector3();

         // set tank speed params (this is for new physics)
         this.speedCharacteristics = new SpeedCharacteristics();
         this.speedCharacteristics.acceleration = 1200;
         this.speedCharacteristics.deceleration = 350;
         if (mass >= 1300)
         {
            this.speedCharacteristics.acceleration = 700;
            this.speedCharacteristics.deceleration = 100;
            // this.suspensionData.dampingCoeff = dampingCoeff * 2;
         }
         this.speedCharacteristics.reverseAcceleration = 1200;
         this.speedCharacteristics.turnMaxSpeed = 4;
         this.speedCharacteristics.turnAcceleration = 2.8;
         this.speedCharacteristics.turnReverseAcceleration = 5;
         this.speedCharacteristics.turnDeceleration = 50;
         this.speedCharacteristics.sideAcceleration = 1400.27;
         if (mass == 1041)
         {
            this.speedCharacteristics.sideAcceleration = 2400.27;
            this.speedCharacteristics.acceleration = 1200;
            this.speedCharacteristics.reverseAcceleration = 1300;
         }

         this.turnDirection = 0;
         this.movementDirection = 0;
         this.turnSpeedNumber = 7;
      }

      public function getCameraParams(position:Vector3, direction:Vector3):void
      {
         this.interpolatedOrientation.toMatrix3(_m);
         _v.vCopy(this.interpolatedPosition);
         var h:Number = this.dimensions.vClone().vScale(0.5).z + 25;
         _v.x -= h * _m.c;
         _v.y -= h * _m.f;
         _v.z -= h * _m.i;
         m41.setFromMatrix3(_m, _v);
         var turretMountPoint:Vector3 = this._skin.turretPosition;
         m42.setMatrix(turretMountPoint.x, turretMountPoint.y, turretMountPoint.z, 0, 0, -this._skin.turretDirection);
         m42.append(m41);
         // position.reset(m42.d, m42.h, m42.l);
         // if (FollowCameraController.CAMERA_FOLLOWS_TURRET)
         // {
         // direction.reset(m42.d, m42.f, m42.j); // TODO: find out what this does
         // }
         // else
         // {
         // // MathUtils.fillDirectionVector(direction, FollowCameraController.getFollowCameraDirection());
         // }
         // 
         // 
      }

      private function applySlopeHack():void
      {
         var hack:SuspensionRay = this.leftTrack.rays[0];
         var bodyBaseMatrix:Matrix3 = null;
         var worldGravity:Vector3 = null;
         var tiltCoiefficient:Number = NaN;
         var worldGravityLength:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var vec3:Vector3 = new Vector3();
         vec3 = hack.body.state.orientation.getEulerAngles(vec3);
         var maxRotation:Number = 720.5766380478634;
         bodyBaseMatrix = hack.body.baseMatrix;
         worldGravity = this.world.gravity;
         tiltCoiefficient = worldGravity.x * bodyBaseMatrix.c + worldGravity.y * bodyBaseMatrix.g + worldGravity.z * bodyBaseMatrix.k;
         if (this.rightTrack.lastContactsNum >= this.rightTrack.raysNum >> 1 || this.leftTrack.lastContactsNum >= this.leftTrack.raysNum >> 1)
         {
            worldGravityLength = worldGravity.length;
            _loc5_ = Math.SQRT1_2 * worldGravityLength;
            this.setupCollisionPrimitives(1);
            if (tiltCoiefficient < -_loc5_ || tiltCoiefficient > _loc5_)
            {
               this.setupCollisionPrimitives(1);
               _loc6_ = (bodyBaseMatrix.c * tiltCoiefficient - worldGravity.x) * this.tankData.mass;
               _loc7_ = (bodyBaseMatrix.g * tiltCoiefficient - worldGravity.y) * this.tankData.mass;
               _loc8_ = (bodyBaseMatrix.k * tiltCoiefficient - worldGravity.z) * this.tankData.mass;
               hack.body.addForceXYZ(_loc6_, _loc7_, _loc8_);
            }
            else if (vec3.y > -0.3 && vec3.y < 0.3)
            {
               // FIXME: when tank is rotated and on a very high angle slope, dont apply the force but if he is straight on the slope apply
               this.setupCollisionPrimitives(0.8);
               // _loc6_ = (bodyBaseMatrix.c * tiltCoiefficient - worldGravity.x) * this.tankData.mass / 1.2;
               // _loc7_ = (bodyBaseMatrix.g * tiltCoiefficient - worldGravity.y) * this.tankData.mass / 1.2;
               // _loc8_ = (bodyBaseMatrix.k * tiltCoiefficient - worldGravity.z) * this.tankData.mass / 1.2;
               // hack.body.addForceXYZ(_loc6_, _loc7_, _loc8_);
            }
         }
         else
         {
            if (tiltCoiefficient > -maxRotation)
            {
               this.setupCollisionPrimitives(0.8);
            }
            else
            {
               this.setupCollisionPrimitives(1);
            }
         }
      }

      private function doApplyMovementForces(maxSpeed:Number, maxTurnSpeed:Number, param3:Number):void
      {
         var currentRot:Vector3 = null;
         var _loc6_:Matrix3 = null;
         var _loc7_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var calcAccel:Number = NaN;
         var totalForce:Number = NaN;
         var totalAmountOfRayContacts:int = 0;
         var totalForceAcrossAllRays:Number = NaN;
         var forcePerRay:Number = NaN;
         var angleTwo:Number = NaN;
         var angleOne:Number = NaN;
         var _loc30_:int = 0;
         var forceMultiplier:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var currentVel:Vector3 = this.state.velocity;
         currentRot = this.state.rotation;
         _loc6_ = this.baseMatrix;
         _xAxis.x = _loc6_.a;
         _xAxis.y = _loc6_.e;
         _xAxis.z = _loc6_.i;
         _yAxis.x = _loc6_.b;
         _yAxis.y = _loc6_.f;
         _yAxis.z = _loc6_.j;
         _zAxis.x = _loc6_.c;
         _zAxis.y = _loc6_.g;
         _zAxis.z = _loc6_.k;
         _loc7_ = 1;
         var _loc8_:Number = Math.PI / 4;
         var _loc9_:Number = TrackedChassisSuspensionParams.MAX_SLOPE_ANGLE;
         if (_zAxis.z < Math.cos(_loc8_))
         {
            if (_zAxis.z < Math.cos(_loc9_))
            {
               _loc7_ = 0;
            }
            else
            {
               _loc7_ = (_loc9_ - Math.acos(_zAxis.z)) / (_loc9_ - _loc8_);
            }
         }
         this.calculateSurfaceVelocities(_surfaceVelocity, _surfaceAngularVelocity);
         _relativeVelocity.x = currentVel.x - _surfaceVelocity.x;
         _relativeVelocity.y = currentVel.y - _surfaceVelocity.y;
         _relativeVelocity.z = currentVel.z - _surfaceVelocity.z;
         _relativeAngularVelocity.x = currentRot.x - _surfaceAngularVelocity.x;
         _relativeAngularVelocity.y = currentRot.y - _surfaceAngularVelocity.y;
         _relativeAngularVelocity.z = currentRot.z - _surfaceAngularVelocity.z;
         var _loc10_:Number = _relativeVelocity.x * _yAxis.x + _relativeVelocity.y * _yAxis.y + _relativeVelocity.z * _yAxis.z;
         var _loc11_:Number = _relativeAngularVelocity.x * _zAxis.x + _relativeAngularVelocity.y * _zAxis.y + _relativeAngularVelocity.z * _zAxis.z;
         var _loc12_:Number = _relativeVelocity.x * _xAxis.x + _relativeVelocity.y * _xAxis.y + _relativeVelocity.z * _xAxis.z;
         var _loc13_:Number = this.speedCharacteristics.sideAcceleration * _loc7_ * param3;
         if (_loc12_ < 0)
         {
            if (_loc13_ > -_loc12_)
            {
               _loc12_ = 0;
            }
            else
            {
               _loc12_ += _loc13_;
            }
         }
         else if (_loc12_ > 0)
         {
            if (_loc13_ > _loc12_)
            {
               _loc12_ = 0;
            }
            else
            {
               _loc12_ -= _loc13_;
            }
         }
         _relativeVelocity.setLengthAlongDirection(_xAxis, _loc12_);
         currentVel.x = _surfaceVelocity.x + _relativeVelocity.x;
         currentVel.y = _surfaceVelocity.y + _relativeVelocity.y;
         currentVel.z = _surfaceVelocity.z + _relativeVelocity.z;
         var lastLeftContacts:int = this.leftTrack.lastContactsNum;
         var lastRightContacts:int = this.rightTrack.lastContactsNum;
         var acceleration:Number = this.speedCharacteristics.acceleration;
         var turnAcceleration:Number = this.speedCharacteristics.turnAcceleration;
         if (lastLeftContacts > 0 || lastRightContacts > 0)
         {
            _loc18_ = 0;
            if (this.movementDirection == 0)
            {
               _loc18_ = -MathUtils.sign(_loc10_) * acceleration * param3;
               if (MathUtils.sign(_loc10_) != MathUtils.sign(_loc10_ + _loc18_))
               {
                  _loc18_ = -_loc10_;
               }
            }
            else
            {
               if (MathUtils.sign(_loc10_) * MathUtils.sign(this.movementDirection) < 0)
               {
                  acceleration = this.speedCharacteristics.reverseAcceleration;
               }
               _loc18_ = this.movementDirection * acceleration * param3;
            }
            _loc19_ = MathUtils.clamp(_loc10_ + _loc18_, -maxSpeed, maxSpeed);
            _loc20_ = _loc19_ - _loc10_;
            _loc21_ = 1;
            _loc22_ = MathUtils.clamp(1 - Math.abs(_loc10_ / maxSpeed), 0, 1);
            if (_loc22_ < _loc21_ && this.movementDirection * MathUtils.sign(_loc10_) > 0)
            {
               _loc20_ *= _loc22_ / _loc21_;
            }
            calcAccel = _loc20_ / param3;
            if (Math.abs(calcAccel) < MIN_ACCELERATION && Math.abs(_loc19_) > 0.5 * this.maxSpeedSmoother.targetValue)
            {
               calcAccel = MathUtils.numberSign(calcAccel, 0.1) * MIN_ACCELERATION;
            }
            totalForce = calcAccel * this.mass;
            totalAmountOfRayContacts = lastLeftContacts + lastRightContacts;
            totalForceAcrossAllRays = totalForce * (totalAmountOfRayContacts + 0.21 * (20 - totalAmountOfRayContacts)) / 10;
            forcePerRay = totalForceAcrossAllRays / totalAmountOfRayContacts;
            angleOne = Math.PI / 4;
            angleTwo = Math.PI / 3;
            _loc30_ = 0;
            while (_loc30_ < TrackedChassisSuspensionParams.NUM_RAYS_PER_TRACK)
            {
               this.applyForceFromRay(this.leftTrack.rays[_loc30_], _yAxis, forcePerRay, angleTwo, angleOne);
               this.applyForceFromRay(this.rightTrack.rays[_loc30_], _yAxis, forcePerRay, angleTwo, angleOne);
               _loc30_++;
            }
            forceMultiplier = 1;
            if (lastLeftContacts == 0 || lastRightContacts == 0)
            {
               forceMultiplier = 0.5;
            }
            _loc32_ = 0;
            if (this.turnDirection == 0)
            {
               _loc32_ = -MathUtils.sign(_loc11_) * this.speedCharacteristics.turnReverseAcceleration * _loc7_ * param3;
               if (MathUtils.sign(_loc11_) != MathUtils.sign(_loc11_ + _loc32_))
               {
                  _loc32_ = -_loc11_;
               }
            }
            else
            {
               if (this.isReversedTurn(this.turnDirection, _loc11_, this.movementDirection, this.inverseBackTurnMovement))
               {
                  turnAcceleration = this.speedCharacteristics.turnReverseAcceleration;
               }
               _loc32_ = this.turnDirection * turnAcceleration * _loc7_ * param3;
               if (this.movementDirection == -1 && this.inverseBackTurnMovement)
               {
                  _loc32_ = -_loc32_;
               }
            }
            _loc33_ = maxTurnSpeed;
            if (this.turnDirection != 0)
            {
               _loc33_ = maxTurnSpeed * this.turnSpeedNumber / TURN_SPEED_COUNT;
            }
            _loc34_ = _loc33_ * forceMultiplier;
            _loc35_ = MathUtils.clamp(_loc11_ + _loc32_, -_loc34_, _loc34_);
            _relativeAngularVelocity.setLengthAlongDirection(_zAxis, _loc35_);
            var tempVec:Vector3 = new Vector3();
            tempVec.x = _surfaceAngularVelocity.x + _relativeAngularVelocity.x;
            tempVec.y = _surfaceAngularVelocity.y + _relativeAngularVelocity.y;
            tempVec.z = _surfaceAngularVelocity.z + _relativeAngularVelocity.z;

            // Add this code to limit the pitch of the tank
            var maxPitch:Number = 2 * Math.PI / 180; // 10 degrees in radians
            var minPitch:Number = -2 * Math.PI / 180; // -10 degrees in radians

            // if (tempVec.x > maxPitch)
            // {
            // tempVec.x = maxPitch;
            // }
            // else if (tempVec.x < minPitch)
            // {
            // tempVec.x = minPitch;
            // }
            // if (tempVec.y > maxPitch)
            // {
            // tempVec.y = maxPitch;
            // }
            // else if (tempVec.y < minPitch)
            // {
            // tempVec.y = minPitch;
            // }
            currentRot.x = tempVec.x;
            currentRot.y = tempVec.y;
            currentRot.z = tempVec.z;
         }
         // (Main.osgi.getService(IConsole) as IConsole).addLine(String(this.tankData.tank._skin.hullMesh.x + " " + this.tankData.tank._skin.hullMesh.y + " " + this.tankData.tank._skin.hullMesh.z));
      }

      private function isReversedTurn(param1:int, param2:Number, param3:int, param4:Boolean):Boolean
      {
         var _loc5_:int = param4 && param3 < 0 ? int(-1) : int(1);
         return param1 * param2 * _loc5_ < 0;
      }

      private function calculateSurfaceVelocities(surfVel:Vector3, surfaceAngVel:Vector3):void
      {
         var suspRay:SuspensionRay = null;
         var index:int = 0;
         var rayHitPos:Vector3 = null;
         var frictionCoef:Number = 1 / (this.leftTrack.lastContactsNum + this.rightTrack.lastContactsNum);
         var rayHitX:Number = 0;
         var rayHitY:Number = 0;
         var rayHitZ:Number = 0;
         index = 0;
         while (index < TrackedChassisSuspensionParams.NUM_RAYS_PER_TRACK)
         {
            suspRay = this.leftTrack.rays[index];
            if (suspRay.hasCollision)
            {
               rayHitPos = suspRay.rayHit.pos;
               rayHitX += rayHitPos.x;
               rayHitY += rayHitPos.y;
               rayHitZ += rayHitPos.z;
            }
            suspRay = this.rightTrack.rays[index];
            if (suspRay.hasCollision)
            {
               rayHitPos = suspRay.rayHit.pos;
               rayHitX += rayHitPos.x;
               rayHitY += rayHitPos.y;
               rayHitZ += rayHitPos.z;
            }
            index++;
         }
         rayHitX *= frictionCoef;
         rayHitY *= frictionCoef;
         rayHitZ *= frictionCoef;
         _midPoint.x = rayHitX;
         _midPoint.y = rayHitY;
         _midPoint.z = rayHitZ;
         surfVel.x = 0;
         surfVel.y = 0;
         surfVel.z = 0;
         surfaceAngVel.x = 0;
         surfaceAngVel.y = 0;
         surfaceAngVel.z = 0;
         index = 0;
         while (index < TrackedChassisSuspensionParams.NUM_RAYS_PER_TRACK)
         {
            this.addVelocitiesFromRay(this.leftTrack.rays[index], _midPoint, surfVel, surfaceAngVel);
            this.addVelocitiesFromRay(this.rightTrack.rays[index], _midPoint, surfVel, surfaceAngVel);
            index++;
         }
         surfVel.x *= frictionCoef;
         surfVel.y *= frictionCoef;
         surfVel.z *= frictionCoef;
         surfaceAngVel.x *= frictionCoef;
         surfaceAngVel.y *= frictionCoef;
         surfaceAngVel.z *= frictionCoef;

      }

      private function addVelocitiesFromRay(param1:SuspensionRay, param2:Vector3, param3:Vector3, param4:Vector3):void
      {
         var _loc5_:Vector3 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Vector3 = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if (param1.hasCollision)
         {
            param3.x += param1.contactVelocity.x;
            param3.y += param1.contactVelocity.y;
            param3.z += param1.contactVelocity.z;
            _loc5_ = param1.rayHit.pos;
            _loc6_ = _loc5_.x - param2.x;
            _loc7_ = _loc5_.y - param2.y;
            _loc8_ = _loc5_.z - param2.z;
            _loc9_ = _loc6_ * _loc6_ + _loc7_ * _loc7_ + _loc8_ * _loc8_;
            if (_loc9_ > 1)
            {
               _loc10_ = 1 / _loc9_;
               _loc11_ = param1.contactVelocity;
               _loc12_ = (_loc7_ * _loc11_.z - _loc8_ * _loc11_.y) * _loc10_;
               _loc13_ = (_loc8_ * _loc11_.x - _loc6_ * _loc11_.z) * _loc10_;
               _loc14_ = (_loc6_ * _loc11_.y - _loc7_ * _loc11_.x) * _loc10_;
               param4.x += _loc12_;
               param4.y += _loc13_;
               param4.z += _loc14_;
            }
         }
      }

      private function applyForceFromRay(ray:SuspensionRay, yAxis:Vector3, forcePerRay:Number, angleOne:Number, angleTwo:Number):void
      {
         var yAxisX:Number = NaN;
         var yAxisY:Number = NaN;
         var yAxisZ:Number = NaN;
         var sqMagCollisionVec:Number = NaN;
         var angleOfCollisionNormal:Number = NaN;
         var forceFactor:Number = NaN;
         if (ray.hasCollision)
         {
            yAxisX = yAxis.x;
            yAxisY = yAxis.y;
            yAxisZ = yAxis.z;
            sqMagCollisionVec = yAxisX * yAxisX + yAxisY * yAxisY + yAxisZ * yAxisZ;
            if (sqMagCollisionVec > 0.00001)
            {
               angleOfCollisionNormal = Math.acos(ray.rayHit.normal.z);
               if (angleOfCollisionNormal < 0)
               {
                  angleOfCollisionNormal = -angleOfCollisionNormal;
               }
               if (angleOfCollisionNormal < angleOne)
               {
                  forceFactor = forcePerRay / Math.sqrt(sqMagCollisionVec);

                  if (angleOfCollisionNormal > angleTwo)
                  {
                     forceFactor *= (angleOne - angleOfCollisionNormal) / (angleOne - angleTwo);
                  }
                  _forceVector.x = yAxisX * forceFactor;
                  _forceVector.y = yAxisY * forceFactor;
                  _forceVector.z = yAxisZ * forceFactor;
                  this.addWorldForceAtLocalPoint(ray.getOrigin(), _forceVector);
               }
            }
         }
      }

      override public function addWorldForceScaled(pos:Vector3, force:Vector3, scale:Number):void
      {
         if (isNaN(pos.x) || isNaN(pos.y) || isNaN(pos.z))
         {
            return;
         }
         if (isNaN(force.x) || isNaN(force.y) || isNaN(force.z))
         {
            return;
         }
         super.addWorldForceScaled(pos, force, scale);
      }

      public function getAllGunParams(param1:AllGlobalGunParams, muzzles:Vector.<Vector3>, param2:int = 0):void
      {
         WeaponUtils.getInstance().calculateMainGunParams(this.skin.turretMesh, muzzles[param2], param1);
      }

      public function getInterpolatedTurretWorldDirection():Number
      {
         MathUtils.fillDirectionVector(_v, this.skin.turretDirection);
         _v.deltaTransform4(m42); // FIXME
         return MathUtils.getDirectionAngle(_v);
      }

      public function setTurretController(controller:TurretController):void
      {
         this.turretController = controller;
      }

      public function getTurretController():TurretController
      {
         return this.turretController;
      }

      public function lockTransformUpdate():void
      {
         this.hullTransformUpdater = this.lockedHullTransformUpdater;
         this.hullTransformUpdater.reset();
      }

      public function unlockTransformUpdate():void
      {
         this.hullTransformUpdater = this.notLockedHullUpdater;
         this.hullTransformUpdater.reset();
      }

      private function calculateSkinCenterOffset(param1:Vector3):void
      {
         var _loc2_:Mesh = this.skin.hullMesh;
         _loc2_.calculateBounds();
         this.skinCenterOffset.x = -0.5 * (_loc2_.boundMinX + _loc2_.boundMaxX);
         this.skinCenterOffset.y = -0.5 * (_loc2_.boundMinY + _loc2_.boundMaxY);
         this.skinCenterOffset.z = -0.5 * param1.z - this.suspensionData.rayOptimalLength;
      }

      public function setAnimationTracks(value:Boolean):void
      {
         this.animatedTracks = value;
      }

      public function getBoundSphereRadius():Number
      {
         return this.shpereRadius;
      }

      private function setBoundSphereRadius(radius:Vector3, p1:Number):void
      {
         var _loc3_:Vector3 = new Vector3(radius.x, radius.y, p1 / 2);
         var _loc4_:Matrix4 = this.mainCollisionBox.transform;
         this.shpereRadius = _loc3_.vLength() + Math.abs(_loc4_.k);
      }

      private function calculateSizeFromMesh(mesh:Mesh):Vector3
      {
         return new Vector3(mesh.boundMaxX - mesh.boundMinX, mesh.boundMaxY - mesh.boundMinY, mesh.boundMaxZ - mesh.boundMinZ);
      }

      public function setMaxTurretTurnSpeed(value:Number, immediate:Boolean):void
      {
         if (immediate)
         {
            this.maxTurretTurnSpeed = value;
            this.maxTurretTurnSpeedSmoother.reset(value);
         }
         else
         {
            this.maxTurretTurnSpeedSmoother.targetValue = value;
            this.turretTurnSpeed = value;
         }
      }

      public function setMaxTurnSpeed(value:Number, immediate:Boolean):void
      {
         if (immediate)
         {
            this.maxTurnSpeed = value;
            this.maxTurnSpeedSmoother.reset(value);
         }
         else
         {
            this.maxTurnSpeedSmoother.targetValue = value;
         }
      }

      public function setMaxSpeed(value:Number, immediate:Boolean):void
      {
         if (immediate)
         {
            this.maxSpeed = value;
            this.maxSpeedSmoother.reset(value);
         }
         else
         {
            this.maxSpeedSmoother.targetValue = value;
         }
      }

      public function get collisionGroup():int
      {
         return collisionPrimitives.head.primitive.collisionGroup;
      }

      public function set collisionGroup(value:int):void
      {
         var item:CollisionPrimitiveListItem = collisionPrimitives.head;
         while (item != null)
         {
            item.primitive.collisionGroup = value;
            item = item.next;
         }
      }

      public function set tracksCollisionGroup(value:int):void
      {
         this.leftTrack.collisionGroup = value;
         this.rightTrack.collisionGroup = value;
      }

      public function setMassAndDimensions(mass:Number, dimensions:Vector3):void
      {
         var xx:Number = NaN;
         var yy:Number = NaN;
         var zz:Number = NaN;
         if (isNaN(mass) || mass <= 0)
         {
            throw new ArgumentError("Wrong mass");
         }
         if (dimensions == null || dimensions.x <= 0 || dimensions.y <= 0 || dimensions.z <= 0)
         {
            throw new ArgumentError("Wrong dimensions");
         }
         this.mass = mass;
         this.dimensions.vCopy(dimensions);
         if (mass == Infinity)
         {
            invMass = 0;
            invInertia.copy(Matrix3.ZERO);
         }
         else
         {
            invMass = 1 / mass;
            xx = dimensions.x * dimensions.x;
            yy = dimensions.y * dimensions.y;
            zz = dimensions.z * dimensions.z;
            invInertia.a = 12 * invMass / (yy + zz);
            invInertia.f = 12 * invMass / (zz + xx);
            invInertia.k = 12 * invMass / (xx + yy);
         }
         this.setupCollisionPrimitives();
      }

      override public function addToContainer(container:Scene3DContainer):void
      {
         if (this.container != null)
         {
            this.removeFromContainer();
         }
         this.container = container;
         this._skin.addToContainer(container);
         if (this._title != null)
         {
            this._title.addToContainer(this.titleContainer);
         }
         if (this._showCollisionGeometry)
         {
            this.addDebugBoxesToContainer(container);
         }
         var raduis:Vector3 = this.calculateSizeFromMesh(this.skin.hullMesh);
         var hall:Vector3 = new Vector3(raduis.x / 2, raduis.y / 2, raduis.z / 2);
         var p1:Number = 2 * raduis.z - (this.suspensionData.rayOptimalLength - 10);
         this.setBoundSphereRadius(raduis, p1);
         this.calculateSkinCenterOffset(raduis);
      }

      override public function removeFromContainer():void
      {
         this._skin.removeFromContainer();
         if (this._title != null)
         {
            this._title.removeFromContainer();
         }
         if (this._showCollisionGeometry)
         {
            this.removeDebugBoxesFromContainer();
         }
         this.container = null;
      }

      public function createTracks(raysNum:int, trackLength:Number, widthBetween:Number):void
      {
         this.leftTrack = new Track(this, raysNum, new Vector3(-0.5 * widthBetween, 0, -0.5 * this.dimensions.z + this.RAY_OFFSET), trackLength, this.suspensionParams);
         this.rightTrack = new Track(this, raysNum, new Vector3(0.5 * widthBetween, 0, -0.5 * this.dimensions.z + this.RAY_OFFSET), trackLength, this.suspensionParams);
      }

      public function setThrottle(throttleLeft:Number, throttleRight:Number):void
      {
         this.leftThrottle = throttleLeft;
         this.rightThrottle = throttleRight;
      }

      public function setBrakes(lb:Boolean, rb:Boolean):void
      {
         this.leftBrake = lb;
         this.rightBrake = rb;
      }

      public function rotateToLocalDirection(dt:Number, dir:Number):void
      {
         var clampedAngle:Number = MathUtils.clampAngleDelta(dir, this.turretDir);
         if (Math.abs(clampedAngle) < ANGLE_EPSILON)
         {
            this.turretDir = dir;
            this.turretTurnSpeed = 0;
            return;
         }
         if (clampedAngle * this.turretTurnSpeed <= 0)
         {
            this.turretTurnSpeed = 0;
         }
         var dtTurretTurnSpeed:Number = this.turretTurnSpeed * dt;
         if (Math.abs(dtTurretTurnSpeed) > Math.abs(clampedAngle))
         {
            this.turretDir = dir;
         }
         else
         {
            this.turretDir = MathUtils.clampAngle(this.turretDir + dtTurretTurnSpeed);
         }
         var _loc5_:Number = MathUtils.sign(clampedAngle);
         this.turretTurnSpeed = this.calculateTurnSpeed(this.turretTurnSpeed, _loc5_, dt);
      }

      public function getLocalDirectionFromWorldDirection(param1:Number, param2:Matrix3):Number
      {
         MathUtils.fillDirectionVector(_vMouse, param1);
         _vMouse.transformTransposed3(param2);
         return MathUtils.getDirectionAngle(_vMouse);
      }

      private function calculateTurnSpeed(param1:Number, param2:Number, param3:Number):Number
      {
         var _loc4_:Number = this.maxTurnSpeed * this.turnSpeedNumber / TURN_SPEED_COUNT;
         return MathUtils.moveValueTowards(param1, param2 * _loc4_, this.turretTurnAcceleration * param3);
      }

      public function rotateTurret(timeFactor:Number, stopAtZero:Boolean):Boolean
      {
         var sign:Boolean = this._skin.turretDirection < 0;
         this.turretTurnSpeed += timeFactor * this.turretTurnAcceleration;
         if (this.turretTurnSpeed < -this.maxTurretTurnSpeed)
         {
            this.turretTurnSpeed = -this.maxTurretTurnSpeed;
         }
         else if (this.turretTurnSpeed > this.maxTurretTurnSpeed)
         {
            this.turretTurnSpeed = this.maxTurretTurnSpeed;
         }
         this.turretDir += this.turretTurnSpeed * (timeFactor < 0 ? -timeFactor : timeFactor);
         if (stopAtZero && sign != this._skin.turretDirection < 0)
         {
            this.turretTurnSpeed = 0;
            this._skin.turretDirection = 0;
            return true;
         }
         return false;
      }

      public function rotateTurretMouse(timeFactor:Number):void
      {
         this.turretTurnSpeed += timeFactor * this.turretTurnAcceleration;
         if (this.turretTurnSpeed < -this.maxTurretTurnSpeed)
         {
            this.turretTurnSpeed = -this.maxTurretTurnSpeed;
         }
         else if (this.turretTurnSpeed > this.maxTurretTurnSpeed)
         {
            this.turretTurnSpeed = this.maxTurretTurnSpeed;
         }
         this.turretDir += this.turretTurnSpeed * (timeFactor < 0 ? -timeFactor : timeFactor);
      }

      public function rotateTurretDo(timeFactor:Number, stopAt:Number):Boolean
      {
         var sign:Boolean = this._skin.turretDirection < stopAt;
         this.turretTurnSpeed += timeFactor * this.turretTurnAcceleration;
         if (this.turretTurnSpeed < -this.maxTurretTurnSpeed)
         {
            this.turretTurnSpeed = -this.maxTurretTurnSpeed;
         }
         else if (this.turretTurnSpeed > this.maxTurretTurnSpeed)
         {
            this.turretTurnSpeed = this.maxTurretTurnSpeed;
         }
         this.turretDir += this.turretTurnSpeed * (timeFactor < 0 ? -timeFactor : timeFactor);
         if (sign != this._skin.turretDirection < stopAt)
         {
            this._skin.turretDirection = this.turretTurnSpeed = stopAt;
            return true;
         }
         return false;
      }

      public function stopTurret():void
      {
         this.turretTurnSpeed = 0;
      }

      public function get turretDirSign():int
      {
         return this._skin.turretDirection < 0 ? int(int(-1)) : (this._skin.turretDirection > 0 ? int(int(1)) : int(int(0)));
      }

      public function get skin():TankSkin
      {
         return this._skin;
      }

      public function interpolatePhysicsState(t:Number):void
      {
         interpolate(t, this.interpolatedPosition, this.interpolatedOrientation);
         this.interpolatedOrientation.normalize();
         if (this.hullTransformUpdater != null)
         {
            this.hullTransformUpdater.update(t);
         }
      }

      override public function updateSkin(t:Number):void
      {
         var avel:Number = NaN;
         var Speed:Number = NaN;
         this.interpolatePhysicsState(t);
         _pos.x += this.skinZCorrection * _m.c;
         _pos.y += this.skinZCorrection * _m.g;
         _pos.z += this.skinZCorrection * _m.k;
         this.skin.updateTransform(_pos, _orient, this.local);
         this.skin.turretMesh.matrix.transformVectors(_vin, _vout);
         _pos.x = _vout[0];
         _pos.y = _vout[1];
         _pos.z = _vout[2];
         _pos.z += !!this.local ? 0 : 200;
         this._title.update(_pos);
         if (this.animatedTracks)
         {
            avel = Math.abs(this.state.rotation.z);
            Speed = this.getVelocity();
            this._skin.updateTracks(this.trackSpeed.calcTrackSpeed(Speed, avel, this.tankData.ctrlBits, this.leftTrack.lastContactsNum, this.contactsNum, this.maxSpeed, -1), this.trackSpeed.calcTrackSpeed(Speed, avel, this.tankData.ctrlBits, this.rightTrack.lastContactsNum, this.contactsNum, this.maxSpeed, 1));
         }
      }

      public function updatePhysicsState():void
      {
         this.interpolatePhysicsState(1);
         this.hullTransformUpdater.update(0);
      }

      public function getBarrelOrigin(param1:Vector3, muzzles:Vector.<Vector3>, param2:int = 0):void
      {
         param1.vCopy(muzzles[param2]);
         param1.y = 0;
      }

      public function jump():void
      {
         this.jumpActivated = true;
      }

      private function adjustSuspensionSpringCoeff():void
      {
         var _loc1_:Number = this.world.gravity.vLength() * this.mass;
         this.suspensionParams.setSpringCoeff(_loc1_ / (2 * TrackedChassisSuspensionParams.NUM_RAYS_PER_TRACK * (TrackedChassisSuspensionParams.MAX_RAY_LENGTH - TrackedChassisSuspensionParams.NOMINAL_RAY_LENGTH)));
         // this.suspensionParams.setSpringCoeff(0);
      }

      private function calculateSuspensionContacts(param1:Number):void
      {
         this.leftTrack.calculateSuspensionContacts(param1);
         this.rightTrack.calculateSuspensionContacts(param1);
      }

      private var graphics:Graphics;

      override public function beforePhysicsStep(dt:Number):void
      {
         // new physics/////
         // trace(this.turnDirection);
         // trace(this.movementDirection);
         var _loc2_:Number = this.maxSpeedSmoother.update(dt);
         var _loc3_:Number = this.maxTurnSpeedSmoother.update(dt);
         this.adjustSuspensionSpringCoeff();
         this.calculateSuspensionContacts(dt);
         var param1:Number = Number(this.maxSpeedSmoother.update(dt));
         var param2:Number = Number(this.maxTurnSpeedSmoother.update(dt));
         if (this.leftTrack.lastContactsNum + this.rightTrack.lastContactsNum > 0)
         {
            this.doApplyMovementForces(param1, param2, dt);
         }
         if (showCollisionGeometry)
         {
            this.debugDraw(graphics, BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.viewport.camera);
         }
         this.applySlopeHack();
         // /////////////////

         // var d:Number = NaN;
         // var limit:Number = NaN;
         if (this.maxSpeed != this.maxSpeedSmoother.targetValue)
         {
            this.maxSpeed = this.maxSpeedSmoother.update(dt);
         }
         if (this.maxTurnSpeed != this.maxTurnSpeedSmoother.targetValue)
         {
            this.maxTurnSpeed = this.maxTurnSpeedSmoother.update(dt);
         }
         if (this.maxTurretTurnSpeed != this.maxTurretTurnSpeedSmoother.targetValue)
         {
            this.maxTurretTurnSpeed = this.maxTurretTurnSpeedSmoother.update(dt);
         }
         // var slipTerm:int = this.leftThrottle > this.rightThrottle ? int(int(-1)) : (this.leftThrottle < this.rightThrottle ? int(int(1)) : int(int(0)));
         // var weight:Number = this.mass * world._gravity.vLength();
         // var k:Number = this.leftThrottle != this.rightThrottle && !(this.leftBrake || this.rightBrake) && state.rotation.vLength() > this.maxTurnSpeed ? Number(Number(0.1)) : Number(Number(1));
         // this.leftTrack.addForces(dt, k * this.leftThrottle, this.maxSpeed, slipTerm, weight, this.suspensionData, this.leftBrake);
         // this.rightTrack.addForces(dt, k * this.rightThrottle, this.maxSpeed, slipTerm, weight, this.suspensionData, this.rightBrake);
         // if (this.rightTrack.lastContactsNum >= this.rightTrack.raysNum >> 1 || this.leftTrack.lastContactsNum >= this.leftTrack.raysNum >> 1)
         // {
         // d = world._gravity.x * baseMatrix.c + world._gravity.y * baseMatrix.g + world._gravity.z * baseMatrix.k;
         // limit = Math.SQRT1_2 * world._gravity.vLength();
         // if (d < -limit || d > limit)
         // {
         // _v.x = (baseMatrix.c * d - world._gravity.x) / invMass;
         // _v.y = (baseMatrix.g * d - world._gravity.y) / invMass;
         // _v.z = (baseMatrix.k * d - world._gravity.z) / invMass;
         // addForce(_v);
         // }
         // }

      }

      public function setOptimalZCorrection():void
      {
         this.skinZCorrection = -0.5 * this.dimensions.z - this.suspensionData.rayOptimalLength + this.RAY_OFFSET;
      }

      public function getPhysicsState(pos:Vector3d, orient:Vector3d, linVel:Vector3d, angVel:Vector3d):void
      {
         this.vector3To3d(state.pos, pos);
         state.orientation.getEulerAngles(_v);
         orient.x = _v.x;
         orient.y = _v.y;
         orient.z = _v.z;
         this.vector3To3d(state.velocity, linVel);
         this.vector3To3d(state.rotation, angVel);
      }

      public function getVelocity():Number
      {
         return state.velocity.vLength();
      }

      public function setPhysicsState(pos:Vector3d, orient:Vector3d, linVel:Vector3d, angVel:Vector3d):void
      {
         this.vector3dTo3(pos, state.pos);
         _orient.setFromAxisAngleComponents(1, 0, 0, orient.x);
         state.orientation.copy(_orient);
         _orient.setFromAxisAngleComponents(0, 1, 0, orient.y);
         state.orientation.append(_orient);
         state.orientation.normalize();
         _orient.setFromAxisAngleComponents(0, 0, 1, orient.z);
         state.orientation.append(_orient);
         state.orientation.normalize();
         this.vector3dTo3(linVel, state.velocity);
         this.vector3dTo3(angVel, state.rotation);
         prevState.copy(state);
      }

      public function get turretDir():Number
      {
         return this._skin.turretDirection;
      }
      public var mouseLookWorldDirection:Number = 0;
      public function set turretDir(value:Number):void
      {
         if (this._skin == null)
         {
            return;
         }
         if (value > PI)
         {
            this._skin.turretDirection = value - PI2;
         }
         else if (value < -PI)
         {
            this._skin.turretDirection = value + PI2;
         }
         else
         {
            this._skin.turretDirection = value;
         }
      }

      public function get title():UserTitle
      {
         return this._title;
      }

      public function debugDraw(g:Graphics, camera:Camera3D):void
      {
         this.leftTrack.debugDraw(g, camera, this.suspensionData);
         this.rightTrack.debugDraw(g, camera, this.suspensionData);
      }

      public function get showCollisionGeometry():Boolean
      {
         return this._showCollisionGeometry;
      }

      public function set showCollisionGeometry(value:Boolean):void
      {
         if (this._showCollisionGeometry == value)
         {
            return;
         }
         this._showCollisionGeometry = value;
         if (this._showCollisionGeometry)
         {
            if (this.container != null)
            {
               this.addDebugBoxesToContainer(this.container);
            }
         }
         else if (this.container != null)
         {
            this.removeDebugBoxesFromContainer();
         }
      }

      public function setHullTransformUpdater(hull_:HullTransformUpdater):void
      {
         this.hullTransformUpdater = hull_;
         this.notLockedHullUpdater = hull_;
         this.hullTransformUpdater.reset();
      }

      private var dynamicSizeYMultiplier:Number = 0;

      private function setupCollisionPrimitives(sizeYMultiplier:Number = 1):void
      {
         if (dynamicSizeYMultiplier == sizeYMultiplier)
         {
            return;
         }
         dynamicSizeYMultiplier = sizeYMultiplier;
         var key:* = undefined;
         var prim:CollisionBox = null;
         var item:CollisionPrimitiveListItem = null;
         var hs:Vector3 = this.dimensions.vClone().vScale(0.5);
         var sizeX:Number = hs.x;
         var sizeY:Number = hs.y;
         var sizeZ:Number = hs.z;
         var m:Matrix4 = new Matrix4();
         var staticSizeYMultiplier = 1;
         if (collisionPrimitives == null)
         {
            hs.y = sizeY * dynamicSizeYMultiplier;
            this.mainCollisionBox = new CollisionBox(hs, CollisionGroup.TANK);
            addCollisionPrimitive(this.mainCollisionBox);
            hs.y = sizeY * staticSizeYMultiplier;
            hs.z = sizeZ / 3;
            m.l = 2 * sizeZ / 3;
            addCollisionPrimitive(new CollisionBox(hs, CollisionGroup.STATIC), m);
            // Add new collision box
            /*hs.y = sizeY * 1.015;
            hs.z = sizeY / 20;
            m = new Matrix4();
            m.l = sizeY * 2 + hs.y;
            addCollisionPrimitive(new CollisionBox(hs, 0));*/
            this.visibilityPoints = Vector.<Vector3>([new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3(), new Vector3()]);
         }
         else
         {
            item = collisionPrimitives.head;
            hs.y = sizeY * dynamicSizeYMultiplier;
            prim = CollisionBox(item.primitive);
            prim.hs.vCopy(hs);
            item = item.next;
            hs.y = sizeY * staticSizeYMultiplier;
            hs.z = sizeZ / 3;
            m.l = 2 * sizeZ / 3;
            prim = CollisionBox(item.primitive);
            prim.hs.vCopy(hs);
            prim.localTransform.copy(m);
            // Update new collision box
            /*item = item.next;
            hs.y = sizeY * 1.015;
            hs.z = sizeY / 20;
            m = new Matrix4();
            m.l = sizeY * 2 + hs.y;
            prim = CollisionBox(item.primitive);
            prim.hs.vCopy(hs);
            prim.localTransform.copy(m);*/
         }
         Vector3(this.visibilityPoints[0]).vReset(-sizeX, sizeY, 0);
         Vector3(this.visibilityPoints[1]).vReset(sizeX, sizeY, 0);
         Vector3(this.visibilityPoints[2]).vReset(-sizeX, 0, 0);
         Vector3(this.visibilityPoints[3]).vReset(sizeX, 0, 0);
         Vector3(this.visibilityPoints[4]).vReset(-sizeX, -sizeY, 0);
         Vector3(this.visibilityPoints[5]).vReset(sizeX, -sizeY, 0);
         this.removeDebugBoxesFromContainer();
         for (key in this.bbs)
         {
            delete this.bbs[key];
         }
      }

      private function vector3To3d(v:Vector3, result:Vector3d):void
      {
         result.x = v.x;
         result.y = v.y;
         result.z = v.z;
      }

      private function vector3dTo3(v:Vector3d, result:Vector3):void
      {
         result.x = v.x;
         result.y = v.y;
         result.z = v.z;
      }

      private function addDebugBoxesToContainer(container:Scene3DContainer):void
      {
      }

      private function removeDebugBoxesFromContainer():void
      {
      }

      public function destroy(fully:Boolean = false):*
      {
         var v:Vector3 = null;
         if (this.mainCollisionBox != null)
         {
            this.mainCollisionBox.destroy();
         }
         this.mainCollisionBox = null;
         if (this._skin != null)
         {
            this._skin.destroy(fully);
         }
         if (!fully)
         {
            return;
         }
         this.skinCenterOffset = null;
         this.interpolatedPosition = null;
         for each (v in this.visibilityPoints)
         {
            v = null;
         }
         this._skin = null;
      }
   }
}

import com.reygazu.anticheat.variables.SecureNumber;

class SecureValueSmoother implements IValueSmoother
{

   public var currentValue:SecureNumber;

   public var targetValue_:SecureNumber;

   public var smoothingSpeedUp:SecureNumber;

   public var smoothingSpeedDown:SecureNumber;

   function SecureValueSmoother(smoothingSpeedUp:Number, smoothingSpeedDown:Number, targetValue:Number, currentValue:Number)
   {
      this.currentValue = new SecureNumber("SecureValueSmoother::currentValue");
      this.targetValue_ = new SecureNumber("SecureValueSmoother::targetValue_");
      this.smoothingSpeedUp = new SecureNumber("SecureValueSmoother::smoothingSpeedUp");
      this.smoothingSpeedDown = new SecureNumber("SecureValueSmoother::smoothingSpeedDown");
      super();
      this.smoothingSpeedUp.value = smoothingSpeedUp;
      this.smoothingSpeedDown.value = smoothingSpeedDown;
      this.targetValue_.value = targetValue;
      this.currentValue.value = currentValue;
   }

   public function reset(value:Number):void
   {
      this.currentValue.value = value;
      this.targetValue_.value = value;
   }

   public function update(dt:Number):Number
   {
      if (this.currentValue.value < this.targetValue_.value)
      {
         this.currentValue.value += this.smoothingSpeedUp.value * dt;
         if (this.currentValue.value > this.targetValue_.value)
         {
            this.currentValue.value = this.targetValue_.value;
         }
      }
      else if (this.currentValue.value > this.targetValue_.value)
      {
         this.currentValue.value -= this.smoothingSpeedDown.value * dt;
         if (this.currentValue.value < this.targetValue_.value)
         {
            this.currentValue.value = this.targetValue_.value;
         }
      }
      return this.currentValue.value;
   }

   public function set targetValue(v:Number):void
   {
      this.targetValue_.value = v;
   }

   public function get targetValue():Number
   {
      return this.targetValue_.value;
   }
}

interface IValueSmoother
{

   function reset(param1:Number):void;

   function update(param1:Number):Number;

   function set targetValue(param1:Number):void;

   function get targetValue():Number;
}

class ValueSmoother implements IValueSmoother
{

   public var currentValue:Number;

   public var targetValue_:Number;

   public var smoothingSpeedUp:Number;

   public var smoothingSpeedDown:Number;

   function ValueSmoother(smoothingSpeedUp:Number, smoothingSpeedDown:Number, targetValue:Number, currentValue:Number)
   {
      super();
      this.smoothingSpeedUp = smoothingSpeedUp;
      this.smoothingSpeedDown = smoothingSpeedDown;
      this.targetValue_ = targetValue;
      this.currentValue = currentValue;
   }

   public function reset(value:Number):void
   {
      this.currentValue = value;
      this.targetValue_ = value;
   }

   public function update(dt:Number):Number
   {
      if (this.currentValue < this.targetValue_)
      {
         this.currentValue += this.smoothingSpeedUp * dt;
         if (this.currentValue > this.targetValue_)
         {
            this.currentValue = this.targetValue_;
         }
      }
      else if (this.currentValue > this.targetValue_)
      {
         this.currentValue -= this.smoothingSpeedDown * dt;
         if (this.currentValue < this.targetValue_)
         {
            this.currentValue = this.targetValue_;
         }
      }
      return this.currentValue;
   }

   public function set targetValue(v:Number):void
   {
      this.targetValue_ = v;
   }

   public function get targetValue():Number
   {
      return this.targetValue_;
   }
}