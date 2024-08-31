// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.test.spectator.SpectatorCameraController

package logic.test.spectator
{
    import alternativa.tanks.camera.CameraControllerBase;
    import alternativa.tanks.camera.ICameraController;
    import flash.display.Stage;
    import alternativa.console.ConsoleVarFloat;
    import alternativa.math.Vector3;
    import __AS3__.vec.Vector;
    import alternativa.init.Main;
    import alternativa.tanks.camera.GameCamera;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import __AS3__.vec.*;
    import alternativa.tanks.models.battlefield.effects.graffiti.GraffitiManager;
    import alternativa.tanks.models.tank.TankModel;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.engine3d.objects.Mesh;

    public class SpectatorCameraController extends CameraControllerBase implements ICameraController
    {

        public static var display:Stage;
        private static const conSmooth:ConsoleVarFloat = new ConsoleVarFloat("cam_smooth", 0.1, 0.001, 1);
        private static const conMousePitchSensitivity:ConsoleVarFloat = new ConsoleVarFloat("m_pitch", -0.006, -100, 100);
        private static const conMouseYawSensitivity:ConsoleVarFloat = new ConsoleVarFloat("m_yaw", -0.006, -100, 100);
        private static const conSpeed:ConsoleVarFloat = new ConsoleVarFloat("cam_spd", 1300, 0, 10000);
        private static const conAcceleration:ConsoleVarFloat = new ConsoleVarFloat("cam_acc", 4, 0, 1000000);
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
        private var keyboardHandlers:Vector.<KeyboardHandler>;
        private var userInput:UserInput;
        public var playerCamera:PlayerCamera;
        private var addedEvents:Boolean = false;

        public function SpectatorCameraController(camera:GameCamera)
        {
            super(camera);
            display = Main.stage;
            this.position = new Vector3();
            this.rotation = new Vector3();
            this.rotationDelta = new Vector3();
            this.userInput = new UserInputImpl();
            this.playerCamera = new PlayerCamera(this);
            this.keyboardHandlers = Vector.<KeyboardHandler>([new BookmarksHandler(this), this.userInput, this.playerCamera, new SpectatorBonusRegionController()]);
            this.setPositionFromCamera();
            this.moveMethods = new MovementMethods(Vector.<MovementMethod>([new FlightMovement(conSpeed, conAcceleration), new WalkMovement(conSpeed, conAcceleration)]));
            // Main.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onDown);
        }

        // private function onDown(e:KeyboardEvent)
        // {
        // switch (e.keyCode)
        // {
        // case Keyboard.J:
        // {
        // var tankmesh:Mesh = TankModel(Main.osgi.getService(ITank)).localUserData.tank._skin.hullMesh;
        // GraffitiManager.createGraffiti(new Vector3(tankmesh.x, tankmesh.y, tankmesh.z), "droppzone_medkit", "999999");
        // break;
        // }
        // }
        // }
        private static function calculateAngleDelta(param1:Number, param2:Number):Number
        {
            var _loc3_:Number = ((param2 - param1) % (2 * Math.PI));
            if (_loc3_ > Math.PI)
            {
                return (_loc3_ - (2 * Math.PI));
            }
            if (_loc3_ < -(Math.PI))
            {
                return ((2 * Math.PI) + _loc3_);
            }
            return (_loc3_);
        }

        public function setCameraState(param1:Vector3, param2:Vector3):void
        {
            var _loc3_:GameCamera;
            _loc3_ = null;
            this.playerCamera.unfocus();
            this.position.copyFrom(param1);
            this.rotation.copyFrom(param2);
            _loc3_ = getCamera();
            this.rotationDelta.x = calculateAngleDelta(_loc3_.rotationX, param2.x);
            this.rotationDelta.y = calculateAngleDelta(_loc3_.rotationY, param2.y);
            this.rotationDelta.z = calculateAngleDelta(_loc3_.rotationZ, param2.z);
        }
        public function update(param1:GameCamera, param1:int, param2:int):void
        {
            if (getCamera() != null)
            {
                this.calculatePosition(param2);
                this.calculateRotation((param2 / 1000));
                this.applyTransformation();
            }
        }
        private function calculatePosition(param1:int):void
        {
            var _loc2_:Vector3;
            _loc2_ = this.moveMethods.getMethod().getDisplacement(this.userInput, getCamera(), (param1 / 1000));
            this.position.x = (this.position.x + _loc2_.x);
            this.position.y = (this.position.y + _loc2_.y);
            this.position.z = (this.position.z + _loc2_.z);
        }
        private function calculateRotation(param1:Number):void
        {
            var _loc2_:GameCamera;
            _loc2_ = getCamera();
            if (this.mouseDown)
            {
                this.rotation.x = (this.startCameraRotationX + ((display.mouseY - this.mouseDownY) * conMousePitchSensitivity.value));
                this.rotationDelta.x = (this.rotation.x - _loc2_.rotationX);
                this.rotation.z = (this.startCameraRotationZ + ((display.mouseX - this.mouseDownX) * conMouseYawSensitivity.value));
                this.rotationDelta.z = (this.rotation.z - _loc2_.rotationZ);
            }
            else
            {
                if (this.userInput.isRotating())
                {
                    this.rotation.x = (this.rotation.x + ((this.userInput.getPitchDirection() * conPitchSpeed.value) * param1));
                    this.rotationDelta.x = (this.rotation.x - _loc2_.rotationX);
                    this.rotationDelta.z = (this.rotationDelta.z + ((this.userInput.getYawDirection() * conYawSpeed.value) * param1));
                }
            }
        }
        private function applyTransformation():void
        {
            this.applyDisplacement();
            this.applyRotation();
        }
        private function applyDisplacement():void
        {
            var _loc1_:GameCamera = getCamera();
            _loc1_.x = (_loc1_.x + ((this.position.x - _loc1_.x) * conSmooth.value));
            _loc1_.y = (_loc1_.y + ((this.position.y - _loc1_.y) * conSmooth.value));
            _loc1_.z = (_loc1_.z + ((this.position.z - _loc1_.z) * conSmooth.value));
        }
        private function applyRotation():void
        {
            var _loc1_:GameCamera;
            _loc1_ = getCamera();
            var _loc2_:Number = (this.rotationDelta.x * conSmooth.value);
            _loc1_.rotationX = (_loc1_.rotationX + _loc2_);
            this.rotationDelta.x = (this.rotationDelta.x - _loc2_);
            var _loc3_:Number = (this.rotationDelta.y * conSmooth.value);
            _loc1_.rotationY = (_loc1_.rotationY + _loc3_);
            this.rotationDelta.y = (this.rotationDelta.y - _loc3_);
            var _loc4_:Number = (this.rotationDelta.z * conSmooth.value);
            _loc1_.rotationZ = (_loc1_.rotationZ + _loc4_);
            this.rotationDelta.z = (this.rotationDelta.z - _loc4_);
        }
        public function activate():void
        {
            this.rotationDelta.reset();
            this.activateInput();
        }
        public function setPositionFromCamera():void
        {
            var _loc1_:GameCamera;
            _loc1_ = getCamera();
            this.position.x = _loc1_.x;
            this.position.y = _loc1_.y;
            this.position.z = _loc1_.z;
            this.rotation.x = _loc1_.rotationX;
            this.rotation.y = _loc1_.rotationY;
            this.rotation.z = _loc1_.rotationZ;
        }
        public function deactivate():void
        {
            this.userInput.reset();
            this.rotationDelta.reset();
            this.deactivateInput();
        }
        private function onMouseDown(param1:MouseEvent):void
        {
            this.mouseDown = true;
            this.mouseDownX = param1.stageX;
            this.mouseDownY = param1.stageY;
            var _loc2_:GameCamera = getCamera();
            this.startCameraRotationX = _loc2_.rotationX;
            this.startCameraRotationZ = _loc2_.rotationZ;
            display.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
        }
        private function onKeyUp(param1:KeyboardEvent):void
        {
            var _loc2_:KeyboardHandler;
            for each (_loc2_ in this.keyboardHandlers)
            {
                _loc2_.handleKeyUp(param1);
            }
        }
        private function onKeyDown(param1:KeyboardEvent):void
        {
            var _loc2_:KeyboardHandler;
            if (param1.keyCode == Keyboard.SPACE)
            {
                this.moveMethods.selectNextMethod();
            }
            if (param1.keyCode == Keyboard.H)
            {
                Main.contentUILayer.visible = (!(Main.contentUILayer.visible));
            }
            for each (_loc2_ in this.keyboardHandlers)
            {
                _loc2_.handleKeyDown(param1);
            }
        }
        private function releaseMouse():void
        {
            if (this.mouseDown)
            {
                display.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
                this.mouseDown = false;
            }
        }
        private function onMouseUp(param1:MouseEvent):void
        {
            this.releaseMouse();
        }
        [Obfuscation(rename="false")]
        public function close():void
        {
            this.playerCamera.close();
        }
        public function deactivateInput():void
        {
            var k:KeyboardHandler;
            var _loc1_:Stage;
            this.releaseMouse();
            if (this.addedEvents)
            {
                _loc1_ = display;
                _loc1_.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
                _loc1_.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
                _loc1_.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
                for each (k in this.keyboardHandlers)
                {
                    k = null;
                }
                this.keyboardHandlers = null;
                this.addedEvents = false;
            }
        }
        public function activateInput():void
        {
            var _loc1_:Stage;
            if ((!(this.addedEvents)))
            {
                _loc1_ = display;
                _loc1_.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
                _loc1_.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
                _loc1_.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
                this.addedEvents = true;
            }
        }

    }
} // package scpacker.test.spectator