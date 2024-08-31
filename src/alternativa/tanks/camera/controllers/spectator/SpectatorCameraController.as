package alternativa.tanks.camera.controllers.spectator
{
   import alternativa.math.Vector3;
   import alternativa.osgi.service.console.variables.ConsoleVarFloat;
   import alternativa.osgi.service.display.IDisplay;
   import alternativa.tanks.battle.BattleService;
   import alternativa.tanks.camera.CameraController;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.utils.MathUtils;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import alternativa.init.Main;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import flash.ui.Keyboard;
   import alternativa.tanks.models.battlefield.effects.graffiti.GraffitiManager;

   public class SpectatorCameraController implements CameraController
   {

      public static var display:Class = Main;

      private static const conSmooth:ConsoleVarFloat = new ConsoleVarFloat("cam_smooth", 0.1, 0.001, 1);

      private static const conSmoothDeceleration:ConsoleVarFloat = new ConsoleVarFloat("cam_smooth_dec", 0.025, 0.001, 1);

      private static const conMousePitchSensitivity:ConsoleVarFloat = new ConsoleVarFloat("m_pitch", -0.006, -100, 100);

      private static const conMouseYawSensitivity:ConsoleVarFloat = new ConsoleVarFloat("m_yaw", -0.006, -100, 100);

      private static const conSpeed:ConsoleVarFloat = new ConsoleVarFloat("cam_spd", 1300, 0, 10000);

      private static const conAcceleration:ConsoleVarFloat = new ConsoleVarFloat("cam_acc", 4, 0, 1000000);

      private static const conDeceleration:ConsoleVarFloat = new ConsoleVarFloat("cam_dec", 0.33, 0.05, 2);

      private static const conYawSpeed:ConsoleVarFloat = new ConsoleVarFloat("yaw_speed", 1, -10, 10);

      private static const conPitchSpeed:ConsoleVarFloat = new ConsoleVarFloat("pitch_speed", 1, -10, 10);

      private var mouseDown:Boolean;

      private var mouseDownX:Number;

      private var mouseDownY:Number;

      private var startCameraRotationX:Number;

      private var startCameraRotationZ:Number;

      private var position:Vector3;

      private var rotation:Vector3;

      private var rotationDelta:Vector3;

      private var moveMethods:MovementMethods;

      private var userInput:UserInputImpl;

      private var addedEvents:Boolean = false;

      private var camera:GameCamera;

      public function SpectatorCameraController()
      {

         position = new Vector3();
         rotation = new Vector3();
         rotationDelta = new Vector3();
         userInput = new UserInputImpl();
         super();
         this.moveMethods = new MovementMethods(Vector.<MovementMethod>([new FlightMovement(conSpeed, conAcceleration, conDeceleration), new WalkMovement(conSpeed, conAcceleration, conDeceleration)]));

      }

      private static function calculateAngleDelta(_arg_1:Number, _arg_2:Number):Number
      {
         var _local_3:Number = (_arg_2 - _arg_1) % (2 * 3.141592653589793);
         if (_local_3 > 3.141592653589793)
         {
            return _local_3 - 2 * 3.141592653589793;
         }
         if (_local_3 < -3.141592653589793)
         {
            return 2 * 3.141592653589793 + _local_3;
         }
         return _local_3;
      }

      public function setCameraState(_arg_1:Vector3, _arg_2:Vector3):void
      {
         var _local_3:GameCamera = null;
         this.position.copy(_arg_1);
         this.rotation.copy(_arg_2);
         _local_3 = BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.viewport.camera;
         this.rotationDelta.x = calculateAngleDelta(_local_3.rotationX, _arg_2.x);
         this.rotationDelta.y = calculateAngleDelta(_local_3.rotationY, _arg_2.y);
         this.rotationDelta.z = calculateAngleDelta(_local_3.rotationZ, _arg_2.z);
      }

      public function update(_arg_1:GameCamera, _arg_2:int, _arg_3:int):void
      {
         var _local_4:Number = _arg_3 / 1000;
         this.calculatePosition(_arg_1, _local_4);
         this.calculateRotation(_arg_1, _local_4);
         this.applyTransformation(_arg_1);
      }

      private function calculatePosition(_arg_1:GameCamera, _arg_2:Number):void
      {
         var _local_3:Vector3 = this.moveMethods.getMethod().getDisplacement(this.userInput, _arg_1, _arg_2);
         this.position.add(_local_3);
      }

      private function calculateRotation(_arg_1:GameCamera, _arg_2:Number):void
      {
         if (this.mouseDown)
         {
            this.rotation.x = this.startCameraRotationX + (display.stage.mouseY - this.mouseDownY) * conMousePitchSensitivity.value;
            this.rotation.x = MathUtils.clamp(this.rotation.x, -3.141592653589793, 0);
            this.rotationDelta.x = this.rotation.x - _arg_1.rotationX;
            this.rotation.z = this.startCameraRotationZ + (display.stage.mouseX - this.mouseDownX) * conMouseYawSensitivity.value;
            this.rotationDelta.z = this.rotation.z - _arg_1.rotationZ;
         }
         else if (this.userInput.isRotating())
         {
            this.rotation.x += this.userInput.getPitchDirection() * conPitchSpeed.value * _arg_2;
            this.rotation.x = MathUtils.clamp(this.rotation.x, -3.141592653589793, 0);
            this.rotationDelta.x = this.rotation.x - _arg_1.rotationX;
            this.rotationDelta.z += this.userInput.getYawDirection() * conYawSpeed.value * _arg_2;
         }
      }

      private function applyTransformation(_arg_1:GameCamera):void
      {
         this.applyDisplacement(_arg_1);
         this.applyRotation(_arg_1);
      }

      private function applyDisplacement(_arg_1:GameCamera):void
      {
         var _local_2:ConsoleVarFloat = null;
         _local_2 = this.moveMethods.getMethod().accelerationInverted() ? conSmoothDeceleration : conSmooth;
         _arg_1.x += (this.position.x - _arg_1.x) * _local_2.value;
         _arg_1.y += (this.position.y - _arg_1.y) * _local_2.value;
         _arg_1.z += (this.position.z - _arg_1.z) * _local_2.value;
      }

      private function applyRotation(_arg_1:GameCamera):void
      {
         var _local_2:ConsoleVarFloat = null;
         _local_2 = this.moveMethods.getMethod().accelerationInverted() ? conSmoothDeceleration : conSmooth;
         var _local_3:Number = this.rotationDelta.x * _local_2.value;
         _arg_1.rotationX += _local_3;
         this.rotationDelta.x -= _local_3;
         var _local_4:Number = this.rotationDelta.y * _local_2.value;
         _arg_1.rotationY += _local_4;
         this.rotationDelta.y -= _local_4;
         var _local_5:Number = this.rotationDelta.z * _local_2.value;
         _arg_1.rotationZ += _local_5;
         this.rotationDelta.z -= _local_5;
      }

      public function activate(_arg_1:GameCamera):void
      {
         this.camera = _arg_1;
         this.rotationDelta.reset();
         this.activateInputListeners();
         _arg_1.readPosition(this.position);
         _arg_1.readRotation(this.rotation);
      }

      public function deactivate():void
      {
         this.userInput.reset();
         this.rotationDelta.reset();
         this.deactivateInputListeners();
      }

      private function onMouseDown(_arg_1:MouseEvent):void
      {
         this.mouseDown = true;
         this.mouseDownX = _arg_1.stageX;
         this.mouseDownY = _arg_1.stageY;
         this.startCameraRotationX = this.camera.rotationX;
         this.startCameraRotationZ = this.camera.rotationZ;
         display.stage.addEventListener("mouseUp", this.onMouseUp);
      }

      private function onKeyUp(_arg_1:KeyboardEvent):void
      {
         this.userInput.handleKeyUp(_arg_1);
      }

      private function onKeyDown(_arg_1:KeyboardEvent):void
      {
         var _local_2:Boolean = false;
         if (_arg_1.keyCode == 32)
         {
            _local_2 = this.moveMethods.getMethod().accelerationInverted();
            this.moveMethods.selectNextMethod();
            this.moveMethods.getMethod().setAccelerationInverted(_local_2);
         }
         if (_arg_1.keyCode == 73 && _arg_1.shiftKey)
         {
            this.moveMethods.getMethod().invertAcceleration();
         }
         this.userInput.handleKeyDown(_arg_1);
      }

      private function releaseMouse():void
      {
         if (this.mouseDown)
         {
            display.stage.removeEventListener("mouseUp", this.onMouseUp);
            this.mouseDown = false;
         }
      }

      private function onMouseUp(_arg_1:MouseEvent):void
      {
         this.releaseMouse();
      }

      public function deactivateInputListeners():void
      {
         var _local_1:Stage = null;
         this.releaseMouse();
         if (this.addedEvents)
         {
            this.addedEvents = false;
            userInput.reset();
            _local_1 = display.stage;
            _local_1.removeEventListener("mouseDown", this.onMouseDown);
            _local_1.removeEventListener("keyDown", this.onKeyDown);
            _local_1.removeEventListener("keyUp", this.onKeyUp);
         }
      }

      public function activateInputListeners():void
      {
         var _local_1:Stage = null;
         if (!this.addedEvents)
         {
            this.addedEvents = true;
            _local_1 = display.stage;
            _local_1.addEventListener("mouseDown", this.onMouseDown);
            _local_1.addEventListener("keyDown", this.onKeyDown);
            _local_1.addEventListener("keyUp", this.onKeyUp);
         }
      }
   }
}
