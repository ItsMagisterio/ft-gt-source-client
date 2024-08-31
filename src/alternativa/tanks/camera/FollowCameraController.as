package alternativa.tanks.camera
{
   import alternativa.engine3d.core.EllipsoidCollider;
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.osgi.service.console.variables.ConsoleVarFloat;
   import alternativa.osgi.service.display.IDisplay;
   import alternativa.tanks.service.settings.keybinding.GameActionEnum;
   import alternativa.tanks.services.battleinput.BattleInputService;
   import alternativa.tanks.services.battleinput.GameActionListener;
   import alternativa.tanks.services.battleinput.MouseMovementListener;
   import alternativa.tanks.services.battleinput.MouseWheelListener;
   import alternativa.tanks.utils.MathUtils;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.net.SharedObject;
   import alternativa.init.Main;
   import alternativa.tanks.vehicles.tanks.Tank;
   import alternativa.tanks.services.battleinput.BattleInputServiceImpl;

   public class FollowCameraController implements CameraController, IFollowCameraController, MouseWheelListener, MouseMovementListener, GameActionListener
   {

      public static var effectsEnabled:Boolean = true;

      public static const CAMERA_FOLLOWS_TURRET:int = 0;

      public static const CAMERA_FOLLOWS_MOUSE:int = 1;

      private static var followCameraMode:int = 0;

      private static var followCameraDirection:Number = 0;

      private static var mouseSensitivity = 5;

      private static const VERTICAL_CAMERA_SPEED:Number = 0.7;

      public static var display:Class = Main;

      private var battleInputService:BattleInputServiceImpl;

      private static const ROTATE_SENS:Number = 0.001;

      private static const MIN_CAMERA_ANGLE:Number = 5 * Math.PI / 180;

      private static const COLLIDER_RADIUS:Number = 50;

      private static const MAX_CAMERA_MOVE_SPEED:Number = 5;

      private static const MIN_CAMERA_ROTATE_SPEED:Number = 3;

      private static const MAX_CAMERA_ROTATE_SPEED:Number = 9;

      private static const collisionPoint:Vector3 = new Vector3();

      private static const _v:Vector3 = new Vector3();

      private static const rayOrigin3D:Vector3D = new Vector3D();

      private static const displacement:Vector3D = new Vector3D();

      private static const collisionPoint3D:Vector3D = new Vector3D();

      private static const collisionNormal3D:Vector3D = new Vector3D();

      private static const rotationMatrix:Matrix3 = new Matrix3();

      private static const axis:Vector3 = new Vector3();

      private static const rayDirection:Vector3 = new Vector3();

      private static var maxCameraMoveSpeed:ConsoleVarFloat = new ConsoleVarFloat("cam_maxmove", 5, 0, 5);

      public static var maxPositionError:Number = 10;

      public static var maxAngleError:Number = Math.PI / 180;

      public static var camSpeedThreshold:Number = 10;

      private static const FIXED_PITCH:Number = 10 * Math.PI / 180;

      private static const PITCH_CORRECTION_COEFF:Number = 1;

      private static const MIN_DISTANCE:Number = 300;

      private static const currentPosition:Vector3 = new Vector3();

      private static const currentRotation:Vector3 = new Vector3();

      private static const rayOrigin:Vector3 = new Vector3();

      private static const flatDirection:Vector3 = new Vector3();

      private static const positionDelta:Vector3 = new Vector3();

      private static var vin:Vector.<Number> = Vector.<Number>([0, 0, 0, 0, 1, 0]);

      private static var vout:Vector.<Number> = Vector.<Number>([0, 0, 0, 0, 1, 0]);

      private static const MOUSE_SENS_MUL:Number = 0.0001;

      private var pitchCorrectionEnabled:Boolean;

      public var inputLocked:Boolean;

      private var distanceFromPivotToCamera:Number = 0;

      private var locked:Boolean;

      private var keyUpPressed:Boolean;

      private var keyDownPressed:Boolean;

      private var active:Boolean;

      private var target:CameraTarget;

      private var position:Vector3;

      private var rotation:Vector3;

      private var targetPosition:Vector3;

      private var targetDirection:Vector3;

      private var linearSpeed:Number = 0;

      private var pitchSpeed:Number = 0;

      private var yawSpeed:Number = 0;

      private var cameraPositionData:CameraPositionData;

      private var baseElevation:Number;

      private var cameraRelativeHeight:Number = 0;

      private var cameraPosition:Point;

      private var point0:Point;

      private var point1:Point;

      private var point2:Point;

      private var point3:Point;

      private var collider:EllipsoidCollider;

      private var collisionObject:Object3D;

      private var _mouseWheel:int;

      private var mouseLookShift:Number = 0;

      private var _tank:Tank;

      public var isFirstUpdate:Boolean = true;

      public function FollowCameraController()
      {
         this.battleInputService = BattleInputServiceImpl(Main.osgi.getService(BattleInputService));
         position = new Vector3();
         rotation = new Vector3();
         targetPosition = new Vector3();
         targetDirection = new Vector3();
         cameraPositionData = new CameraPositionData();
         cameraPosition = new Point();
         super();
         this.point0 = new Point(145, 545);
         this.point1 = new Point(930, 1395);
         this.point2 = new Point(2245, 1565);
         this.point3 = new Point(3105, 760);
         this.collider = new EllipsoidCollider(50, 50, 50);
         var _local_1:Number = Number(SharedObject.getLocal("localStorage").data["cameraT"]);
         if (isNaN(_local_1))
         {
            _local_1 = 0.2;
         }
         this.setCameraRelativeHeight(_local_1);
      }

      public static function setMouseSensitivity(value:int)
      {
         mouseSensitivity = value;
      }

      public static function getFollowCameraMode():int
      {
         return followCameraMode;
      }

      public static function setFollowCameraMode(_arg_1:int):void
      {
         followCameraMode = _arg_1;
      }

      public static function getFollowCameraDirection():Number
      {
         return followCameraDirection;
      }

      public static function setFollowCameraDirection(_arg_1:Number):void
      {
         followCameraDirection = _arg_1;
      }

      private static function vector3To3D(_arg_1:Vector3, _arg_2:Vector3D):void
      {
         _arg_2.x = _arg_1.x;
         _arg_2.y = _arg_1.y;
         _arg_2.z = _arg_1.z;
      }

      private static function getLinearSpeed(_arg_1:Number):Number
      {
         return maxCameraMoveSpeed.value * _arg_1;
      }

      private static function bezier(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):Number
      {
         var _local_6:Number = 3 * (_arg_3 - _arg_2);
         var _local_7:Number = 3 * _arg_2 - 6 * _arg_3 + 3 * _arg_4;
         var _local_8:Number = -_arg_2 + 3 * _arg_3 - 3 * _arg_4 + _arg_5;
         return _arg_2 + _arg_1 * _local_6 + _arg_1 * _arg_1 * _local_7 + _arg_1 * _arg_1 * _arg_1 * _local_8;
      }

      public function setCollisionObject(_arg_1:Object3D):void
      {
         this.collisionObject = _arg_1;
      }

      public function setTarget(_arg_1:CameraTarget):void
      {
         this.target = _arg_1;
         isFirstUpdate = true;
         // this.updateTargetState(true);
      }

      public function setCurrentState(targetPos:Vector3, targetDir:Vector3):void
      {
         this.targetPosition.copy(targetPos);
         this.targetDirection.copy(targetDir);
         this.getCameraPositionData(targetPos, targetDir, this.cameraPositionData);
         this.position.copy(this.cameraPositionData.position);
         this.rotation.x = this.getPitchAngle(this.cameraPositionData) - 0.5 * Math.PI;
         this.rotation.y = 0;
         this.rotation.z = Math.atan2(-targetDir.x, targetDir.y);
      }

      public function activate(cam:GameCamera):void
      {
         if (!this.active)
         {
            this.active = true;
            cam.readPosition(this.position);
            cam.readRotation(this.rotation);
            battleInputService.addGameActionListener(this);
            battleInputService.addMouseMoveListener(this);
            battleInputService.addMouseWheelListener(this);
         }
      }

      public function deactivate():void
      {
         if (this.active)
         {
            this.active = false;
            battleInputService.removeGameActionListener(this);
            battleInputService.removeMouseMoveListener(this);
            battleInputService.removeMouseWheelListener(this);
            SharedObject.getLocal("localStorage").data["cameraT"] = this.cameraRelativeHeight;
            this.keyUpPressed = false;
            this.keyDownPressed = false;
         }
      }

      public function get tank():Tank
      {
         return (this._tank);
      }

      public function set tank(value:Tank):void
      {
         this._tank = value;
      }

      public function update(_arg_1:GameCamera, time:int, timeDelta:int):void
      {
         if (target == null)
         {
            return;
         }

         var dt:Number = (timeDelta * 0.001);
         if (dt > 0.1)
         {
            dt = 0.1;
         }
         this.updateCameraHeight(dt);
         if (!this.locked)
         {
            this.target.getCameraParams(this.targetPosition, this.targetDirection);
            this.updateTargetState(false);

            // FIXME: huge kostil
            if (isFirstUpdate)
            {
               isFirstUpdate = false;
               this.updateTargetState(true);
               followCameraDirection = _tank.getInterpolatedTurretWorldDirection();
            }
         }
         this.getCameraPositionData(this.targetPosition, this.targetDirection, this.cameraPositionData);
         positionDelta.vDiff(this.cameraPositionData.position, this.position);
         var positionError:Number = positionDelta.vLength();
         if (positionError > maxPositionError)
         {
            this.linearSpeed = getLinearSpeed(positionError - maxPositionError);
         }
         var distance:Number = this.linearSpeed * dt;
         if (distance > positionError)
         {
            distance = positionError;
         }
         positionDelta.vNormalize().vScale(distance);
         var targetPitchAngle:Number = this.getPitchAngle(this.cameraPositionData);
         var targetYawAngle:Number = Math.atan2(-(this.targetDirection.x), this.targetDirection.y);
         var currentPitchAngle:Number = MathUtils.clampAngle(this.rotation.x + 0.5 * Math.PI);
         var currentYawAngle:Number = MathUtils.clampAngle(this.rotation.z);
         var pitchError:Number = MathUtils.clampAngleFast(targetPitchAngle - currentPitchAngle);
         this.pitchSpeed = this.getAngularSpeed(pitchError, this.pitchSpeed);
         var deltaPitch:Number = (this.pitchSpeed * dt);
         if (pitchError > 0 && deltaPitch > pitchError || pitchError < 0 && deltaPitch < pitchError)
         {
            deltaPitch = pitchError;
         }
         var yawError:Number = MathUtils.clampAngleFast((targetYawAngle - currentYawAngle));
         this.yawSpeed = this.getAngularSpeed(yawError, this.yawSpeed);
         var deltaYaw:Number = (this.yawSpeed * dt);
         if (yawError > 0 && deltaYaw > yawError || yawError < 0 && deltaYaw < yawError)
         {
            deltaYaw = yawError;
         }
         this.linearSpeed = MathUtils.snap(this.linearSpeed, 0, camSpeedThreshold);
         this.pitchSpeed = MathUtils.snap(this.pitchSpeed, 0, camSpeedThreshold);
         this.yawSpeed = MathUtils.snap(this.yawSpeed, 0, camSpeedThreshold);
         this.position.vAdd(positionDelta);
         this.rotation.x = (this.rotation.x + deltaPitch);
         this.rotation.z = (this.rotation.z + deltaYaw);
         currentPosition.vCopy(this.position);
         currentRotation.vCopy(this.rotation);
         _arg_1.setPosition(currentPosition);
         _arg_1.setRotation(currentRotation);
         // var currTurrDir:Number = tank.skin.turretDirection;

      }

      private function updateTargetState(forced:Boolean):void
      {
         this._tank.skin.turretMesh.matrix.transformVectors(vin, vout);
         this.targetPosition.vReset(vout[0], vout[1], vout[2]);

         if (followCameraMode == FollowCameraController.CAMERA_FOLLOWS_TURRET || forced)
         {
            this.targetDirection.vReset((vout[3] - this.targetPosition.x), (vout[4] - this.targetPosition.y), (vout[5] - this.targetPosition.z));
         }
         else
         {
            MathUtils.fillDirectionVector(this.targetDirection, FollowCameraController.getFollowCameraDirection());
         }
      }

      public function setLocked(_arg_1:Boolean):void
      {
         this.locked = _arg_1;
         if (_arg_1)
         {
            this._mouseWheel = 0;
         }
      }

      private function setCameraRelativeHeight(_arg_1:Number):void
      {
         this.cameraRelativeHeight = MathUtils.clamp(_arg_1, 0, 1);
         var _local_2:Number = MathUtils.clamp(this.cameraRelativeHeight + this.mouseLookShift * 0.1, 0, 1);
         this.cameraPosition.x = bezier(_local_2, this.point0.x, this.point1.x, this.point2.x, this.point3.x);
         this.cameraPosition.y = bezier(_local_2, this.point0.y, this.point1.y, this.point2.y, this.point3.y);
         this.baseElevation = Math.atan2(this.cameraPosition.x, this.cameraPosition.y);
         this.distanceFromPivotToCamera = this.cameraPosition.length;
      }

      public function getCameraState(_arg_1:Vector3, _arg_2:Vector3, _arg_3:Vector3, _arg_4:Vector3):void
      {
         this.getCameraPositionData(_arg_1, _arg_2, this.cameraPositionData);
         _arg_4.x = this.getPitchAngle(this.cameraPositionData) - 0.5 * 3.141592653589793;
         _arg_4.z = Math.atan2(-_arg_2.x, _arg_2.y);
         _arg_3.copy(this.cameraPositionData.position);
      }

      private function getCameraPositionData(_arg_1:Vector3, _arg_2:Vector3, _arg_3:CameraPositionData):void
      {
         var _local_4:Number = NaN;
         var _local_7:Number = NaN;
         _local_4 = this.baseElevation;
         var _local_5:Number;
         if ((_local_5 = Math.sqrt(_arg_2.x * _arg_2.x + _arg_2.y * _arg_2.y)) < 0.00001)
         {
            flatDirection.x = 1;
            flatDirection.y = 0;
         }
         else
         {
            flatDirection.x = _arg_2.x / _local_5;
            flatDirection.y = _arg_2.y / _local_5;
         }
         _arg_3.extraPitch = 0;
         _arg_3.t = 1;
         rayOrigin.copy(_arg_1);
         axis.x = flatDirection.y;
         axis.y = -flatDirection.x;
         flatDirection.vReverse();
         rotationMatrix.fromAxisAngle(axis, -_local_4);
         rotationMatrix.transformVector(flatDirection, rayDirection);
         this.getCollisionPoint(rayOrigin, rayDirection, this.distanceFromPivotToCamera, collisionPoint);
         var _local_6:Number = _v.vCopy(rayOrigin).vSubtract(collisionPoint).vLength();
         _arg_3.t = _local_6 / this.distanceFromPivotToCamera;
         if (_local_6 < 300)
         {
            rayOrigin.copy(collisionPoint);
            _local_7 = 300 - _local_6;
            this.getCollisionPoint(rayOrigin, Vector3.Z_AXIS, _local_7, collisionPoint);
         }
         _arg_3.position.copy(collisionPoint);
      }

      private function getCollisionPoint(_arg_1:Vector3, _arg_2:Vector3, _arg_3:Number, _arg_4:Vector3):void
      {
         var _local_5:Number = NaN;
         vector3To3D(_arg_1, rayOrigin3D);
         displacement.x = _arg_3 * _arg_2.x;
         displacement.y = _arg_3 * _arg_2.y;
         displacement.z = _arg_3 * _arg_2.z;
         if (this.collider.getCollision(rayOrigin3D, displacement, collisionPoint3D, collisionNormal3D, this.collisionObject))
         {
            _local_5 = 50 + 0.1;
            _arg_4.x = collisionPoint3D.x + _local_5 * collisionNormal3D.x;
            _arg_4.y = collisionPoint3D.y + _local_5 * collisionNormal3D.y;
            _arg_4.z = collisionPoint3D.z + _local_5 * collisionNormal3D.z;
         }
         else
         {
            _arg_4.copy(_arg_1).vAddScaled(_arg_3, _arg_2);
         }
      }

      private function updateCameraHeight(_arg_1:Number):void
      {
         var _local_2:int = 0;
         if (this._mouseWheel < 0)
         {
            this.keyUpPressed = true;
            this.keyDownPressed = false;
            this._mouseWheel++;
            if (this._mouseWheel == 0)
            {
               this.keyUpPressed = false;
            }
         }
         else if (this._mouseWheel > 0)
         {
            this.keyUpPressed = false;
            this.keyDownPressed = true;
            this._mouseWheel--;
            if (this._mouseWheel == 0)
            {
               this.keyDownPressed = false;
            }
         }
         if (!this.inputLocked && this.keyUpPressed != this.keyDownPressed)
         {
            _local_2 = this.keyUpPressed ? 1 : -1;
            this.setCameraRelativeHeight(this.cameraRelativeHeight + _local_2 * 0.7 * _arg_1);
         }
         else
         {
            this.setCameraRelativeHeight(this.cameraRelativeHeight);
         }
      }

      private function getAngularSpeed(_arg_1:Number, _arg_2:Number):Number
      {
         var _local_3:Number = followCameraMode == 0 ? 3 : 9;
         if (_arg_1 < -maxAngleError)
         {
            return _local_3 * (_arg_1 + maxAngleError);
         }
         if (_arg_1 > maxAngleError)
         {
            return _local_3 * (_arg_1 - maxAngleError);
         }
         return _arg_2;
      }

      private function getPitchAngle(_arg_1:CameraPositionData):Number
      {
         var _local_2:Number = this.baseElevation - 0.17453292519943295;
         if (_local_2 < 0)
         {
            _local_2 = 0;
         }
         var _local_3:Number;
         if ((_local_3 = _arg_1.t) >= 1 || _local_2 < 0.08726646259971647 || !this.pitchCorrectionEnabled)
         {
            return _arg_1.extraPitch - _local_2;
         }
         var _local_4:Number = this.cameraPosition.x;
         return _arg_1.extraPitch - Math.atan2(_local_3 * _local_4, 1 * _local_4 * (1 / Math.tan(_local_2) - (1 - _local_3) / Math.tan(this.baseElevation)));
      }

      public function onMouseRelativeMovement(_arg_1:Number, _arg_2:Number):void
      {
         if (!this.locked)
         {
            if (followCameraMode != FollowCameraController.CAMERA_FOLLOWS_MOUSE)
            {
               followCameraMode = FollowCameraController.CAMERA_FOLLOWS_MOUSE;
            }
            followCameraDirection = MathUtils.clampAngle(followCameraDirection - _arg_1 * mouseSensitivity * MOUSE_SENS_MUL);
            this.mouseLookShift += _arg_2 * 0.001 * this.getMouseMoveMultiplier();
            this.mouseLookShift = MathUtils.clamp(this.mouseLookShift, -1, 1);
         }
      }

      public function initCameraComponents():void
      {
         this.rotation.y = 0;
         // this.position.vCopy(this.cameraPositionData.position);
         // this.rotation.vReset(this.rotation.x, this.rotation.y, this.rotation.z);
      }

      public function onMouseWheel(_arg_1:int):void
      {
         var _local_2:Boolean = false;
         _arg_1 *= this.getMouseMoveMultiplier();
         if (!this.locked)
         {
            _local_2 = false;
            if (_arg_1 > 1)
            {
               if (this._mouseWheel < 0)
               {
                  this._mouseWheel = 0;
               }
               _local_2 = true;
            }
            if (_arg_1 < 1)
            {
               if (this._mouseWheel > 0)
               {
                  this._mouseWheel = 0;
               }
               _local_2 = true;
            }
            if (_local_2)
            {
               this._mouseWheel = _arg_1 * 2;
            }
         }
      }

      public function onGameAction(_arg_1:GameActionEnum, _arg_2:Boolean, _arg_3:Boolean):void
      {
         switch (_arg_1)
         {
            case GameActionEnum.FOLLOW_CAMERA_UP:
               this.keyUpPressed = _arg_2;
               return;
            case GameActionEnum.FOLLOW_CAMERA_DOWN:
               this.keyDownPressed = _arg_2;
               return;
            default:
               return;
         }
      }

      private function getMouseMoveMultiplier():int
      {
         return 1;
      }

   }
}
