package alternativa.tanks.services.battleinput
{
   import alternativa.tanks.service.settings.keybinding.GameActionEnum;
   import alternativa.tanks.service.settings.keybinding.KeysBindingService;
   import alternativa.tanks.utils.BitMask;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FullScreenEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import projects.tanks.clients.fp10.libraries.tanksservices.service.fullscreen.FullscreenService;
   import alternativa.init.Main;
   import alternativa.tanks.service.settings.keybinding.KeysBindingServiceImpl;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.engine3d.core.View;
   import projects.tanks.clients.flash.commons.services.fullscreen.FullscreenServiceImpl;

   public class BattleInputServiceImpl extends EventDispatcher implements BattleInputService
   {

      private var fullScreenService:FullscreenService;

      private var stage:Stage;

      private var keysBindingService:KeysBindingService;

      private const inputLocks:BitMask = new BitMask(0);

      private const mouseLockLocks:BitMask = new BitMask(0);

      private const pressedKeys:Dictionary = new Dictionary();

      private var activeActions:Dictionary;

      private const actionListeners:Vector.<GameActionListener> = new Vector.<GameActionListener>();

      private const mouseLockListeners:Vector.<MouseLockListener> = new Vector.<MouseLockListener>();

      private const mouseMoveListeners:Vector.<MouseMovementListener> = new Vector.<MouseMovementListener>();

      private const mouseWheelListeners:Vector.<MouseWheelListener> = new Vector.<MouseWheelListener>();

      private var isFullScreen:Boolean = false;

      private const leftMouseAction:MouseButtonAction = new MouseButtonAction(GameActionEnum.SHOT);

      private const rightMouseAction:MouseButtonAction = new MouseButtonAction(GameActionEnum.LOOK_AROUND);

      private var mouseJustLocked:Boolean = false;

      private var isMouseLockAllowed:Boolean = true;

      public function BattleInputServiceImpl()
      {
         this.keysBindingService = KeysBindingServiceImpl(Main.osgi.getService(KeysBindingService));
         this.fullScreenService = FullscreenServiceImpl(Main.osgi.getService(FullscreenService));
         this.activeActions = new Dictionary();
         Main.stage.addEventListener("keyDown", this.onKeyDown);
         Main.stage.addEventListener("keyUp", this.onKeyUp);
         Main.stage.addEventListener("mouseDown", this.onLeftMouseDown);
         Main.stage.addEventListener("mouseUp", this.onLeftMouseUp);
         Main.stage.addEventListener("rightMouseDown", this.onRightMouseDown);
         Main.stage.addEventListener("rightMouseUp", this.onRightMouseUp);
         Main.stage.addEventListener("mouseMove", this.onMouseMove);
         Main.stage.addEventListener("mouseWheel", this.onMouseWheel);
         Main.stage.addEventListener("mouseLeave", this.onMouseLeave);
         Main.stage.addEventListener("fullScreen", this.onFullScreen);
         Main.stage.addEventListener("fullScreenInteractiveAccepted", this.onFullScreen);
      }

      public function forbidMouseLock():void
      {
         this.isMouseLockAllowed = false;
      }

      public function allowMouseLock():void
      {
         this.isMouseLockAllowed = true;
      }

      private function onKeyDown(param1:KeyboardEvent):void
      {
         var _loc3_:GameActionEnum = this.keysBindingService.getBindingAction(param1.keyCode);
         var _loc2_:* = this.pressedKeys[param1.keyCode] != true;
         if (_loc2_ || _loc3_ != GameActionEnum.SHOT && _loc3_ != GameActionEnum.FOLLOW_CAMERA_DOWN && _loc3_ != GameActionEnum.FOLLOW_CAMERA_UP && _loc3_ != GameActionEnum.ROTATE_TURRET_LEFT && _loc3_ != GameActionEnum.ROTATE_TURRET_RIGHT && _loc3_ != GameActionEnum.CENTER_TURRET && _loc3_ != GameActionEnum.CHASSIS_BACKWARD_MOVEMENT && _loc3_ != GameActionEnum.CHASSIS_FORWARD_MOVEMENT && _loc3_ != GameActionEnum.CHASSIS_LEFT_MOVEMENT && _loc3_ != GameActionEnum.CHASSIS_RIGHT_MOVEMENT)
         {
            this.pressedKeys[param1.keyCode] = true;
            if (this.isNotLocked())
            {
               if (_loc3_ != null)
               {
                  this.handleActionActivation(_loc3_, param1.shiftKey);
               }
            }
         }
      }

      public function dispatchActionEventForcibly(param1:GameActionEnum, onDown:Boolean, param3:Boolean):void
      {
         var _loc4_:int = 0;
         while (_loc4_ < this.actionListeners.length)
         {
            this.actionListeners[_loc4_].onGameAction(param1, onDown, param3);
            _loc4_++;
         }
      }
      private function handleActionActivation(param1:GameActionEnum, param2:Boolean):void
      {
         var _loc3_:int = int(this.activeActions[param1]) + 1;
         this.activeActions[param1] = _loc3_;
         if (_loc3_ == 1 || param1 != GameActionEnum.SHOT && param1 != GameActionEnum.FOLLOW_CAMERA_DOWN && param1 != GameActionEnum.FOLLOW_CAMERA_UP && param1 != GameActionEnum.ROTATE_TURRET_LEFT && param1 != GameActionEnum.ROTATE_TURRET_RIGHT && param1 != GameActionEnum.CENTER_TURRET && param1 != GameActionEnum.CHASSIS_BACKWARD_MOVEMENT && param1 != GameActionEnum.CHASSIS_FORWARD_MOVEMENT && param1 != GameActionEnum.CHASSIS_LEFT_MOVEMENT && param1 != GameActionEnum.CHASSIS_RIGHT_MOVEMENT)
         {
            this.dispatchActionEvent(param1, true, param2);
         }
      }

      private function onKeyUp(param1:KeyboardEvent):void
      {
         var _loc3_:GameActionEnum = null;
         var _loc2_:* = this.pressedKeys[param1.keyCode] == true;
         if (_loc2_)
         {
            delete this.pressedKeys[param1.keyCode];
            if (this.isNotLocked())
            {
               _loc3_ = this.keysBindingService.getBindingAction(param1.keyCode);
               if (_loc3_ != null)
               {
                  this.handleActionDeactivation(_loc3_);
               }
            }
         }
      }

      private function handleActionDeactivation(param1:GameActionEnum):void
      {
         var _loc2_:int = int(this.activeActions[param1]);
         if (_loc2_ > 0)
         {
            if (_loc2_ == 1)
            {
               delete this.activeActions[param1];
               this.dispatchActionEvent(param1, false, false);
            }
            else
            {
               this.activeActions[param1] = _loc2_ - 1;
            }
         }
      }

      public function onPlayerDeactivate():void
      {
         var _loc1_:* = undefined;
         var _loc3_:Dictionary = null;
         var _loc2_:* = undefined;
         this.leftMouseAction.isActive = false;
         this.rightMouseAction.isActive = false;
         for (_loc1_ in this.pressedKeys)
         {
            delete this.pressedKeys[_loc1_];
         }
         _loc3_ = this.activeActions;
         this.activeActions = new Dictionary();
         if (this.isNotLocked())
         {
            for (_loc2_ in _loc3_)
            {
               this.dispatchActionEvent(GameActionEnum(_loc2_), false, false);
            }
         }
      }

      private function onLeftMouseDown(param1:MouseEvent):void
      {
         if (this.isLocked())
         {
            return;
         }
         if (this.isFullScreen)
         {
            if (Main.stage.mouseLock)
            {
               this.activateMouseAction(this.leftMouseAction);
            }
            else if (param1.target == Main.stage && this.canLockMouse())
            {
               this.setMouseLock(true);
            }
         }
         else if (param1.target is View && this.canLockMouse())
         {
            fullScreenService.switchFullscreen();
         }
      }

      private function onLeftMouseUp(param1:MouseEvent):void
      {
         this.deactivateMouseAction(this.leftMouseAction);
      }

      private function onRightMouseDown(param1:MouseEvent):void
      {
         if (Main.stage.mouseLock)
         {
            this.activateMouseAction(this.rightMouseAction);
         }
      }

      private function onRightMouseUp(param1:MouseEvent):void
      {
         this.deactivateMouseAction(this.rightMouseAction);
      }

      private function onMouseMove(param1:MouseEvent):void
      {
         var _loc2_:int = 0;
         if (Main.stage.mouseLock)
         {
            if (this.mouseJustLocked)
            {
               this.mouseJustLocked = false;
            }
            else
            {
               _loc2_ = 0;
               while (_loc2_ < this.mouseMoveListeners.length)
               {
                  this.mouseMoveListeners[_loc2_].onMouseRelativeMovement(param1.movementX, param1.movementY);
                  _loc2_++;
               }
            }
         }
      }

      private function onMouseWheel(param1:MouseEvent):void
      {
         var _loc2_:int = 0;
         if (Main.stage.mouseLock)
         {
            _loc2_ = 0;
            while (_loc2_ < this.mouseWheelListeners.length)
            {
               this.mouseWheelListeners[_loc2_].onMouseWheel(param1.delta);
               _loc2_++;
            }
         }
      }

      private function onMouseLeave(param1:Event):void
      {
      }

      private function onFullScreen(param1:FullScreenEvent):void
      {
         this.isFullScreen = param1.fullScreen;
         if (this.isLocked())
         {
            return;
         }
         if (this.isFullScreen)
         {
            if (this.canLockMouse())
            {
               this.setMouseLock(true);
            }
         }
         else
         {
            this.deactivateMouseAction(this.leftMouseAction);
            this.deactivateMouseAction(this.rightMouseAction);
            this.setMouseLock(false);
         }
      }

      private function dispatchActionEvent(param1:GameActionEnum, param2:Boolean, param3:Boolean):void
      {
         var _loc4_:int = 0;
         while (_loc4_ < this.actionListeners.length)
         {
            this.actionListeners[_loc4_].onGameAction(param1, param2, param3);
            _loc4_++;
         }
      }
      public function lock(param1:BattleInputLockType):void
      {
         var _loc3_:* = undefined;
         var _loc2_:Boolean = this.isChatLocked();
         var _loc4_:Boolean = this.isInputLocked();
         this.inputLocks.setBits(param1.getMask());
         if (!_loc2_ && this.isChatLocked())
         {
            dispatchEvent(new BattleInputLockEvent("BattleInputLockEvent.CHAT_LOCKED"));
         }
         if (!_loc4_ && this.isInputLocked())
         {
            if (Main.stage.mouseLock)
            {
               this.setMouseLock(false);
            }
            for (_loc3_ in this.activeActions)
            {
               this.dispatchActionEvent(GameActionEnum(_loc3_), false, false);
            }
            this.activeActions = new Dictionary();
            dispatchEvent(new BattleInputLockEvent("BattleInputLockEvent.INPUT_LOCKED"));
         }
      }

      public function unlock(param1:BattleInputLockType):void
      {
         var _loc4_:* = undefined;
         var _loc2_:GameActionEnum = null;
         var _loc3_:Boolean = this.isChatLocked();
         var _loc5_:Boolean = this.isLocked();
         this.inputLocks.clearBits(param1.getMask());
         if (_loc3_ && !this.isChatLocked())
         {
            dispatchEvent(new BattleInputLockEvent("BattleInputLockEvent.CHAT_UNLOCKED"));
         }
         if (_loc5_ && this.isNotLocked())
         {
            for (_loc4_ in this.pressedKeys)
            {
               _loc2_ = this.keysBindingService.getBindingAction(_loc4_);
               if (_loc2_ != null)
               {
                  this.handleActionActivation(_loc2_, false);
               }
            }
            if (this.isFullScreen && !Main.stage.mouseLock && this.canLockMouse())
            {
               this.setMouseLock(true);
            }
            dispatchEvent(new BattleInputLockEvent("BattleInputLockEvent.INPUT_UNLOCKED"));
         }
      }

      public function lockMouseLocking(param1:MouseLockLockType):void
      {
         var _loc2_:Boolean = this.mouseLockLocks.isEmpty();
         this.mouseLockLocks.setBits(param1.bit);
         if (_loc2_ && this.mouseLockLocks.isNotEmpty())
         {
            if (Main.stage.mouseLock)
            {
               this.setMouseLock(false);
            }
         }
      }

      public function unlockMouseLocking(param1:MouseLockLockType):void
      {
         var _loc2_:Boolean = this.mouseLockLocks.isNotEmpty();
         this.mouseLockLocks.clearBits(param1.bit);
         if (_loc2_ && this.canLockMouse())
         {
            if (this.isNotLocked() && this.isFullScreen && !Main.stage.mouseLock)
            {
               this.setMouseLock(true);
            }
         }
      }

      public function isInputLocked():Boolean
      {
         return this.isLocked();
      }

      private function isChatLocked():Boolean
      {
         return this.inputLocks.hasAnyBit(BattleInputLockType.MODAL_DIALOG.getMask());
      }

      public function addGameActionListener(param1:GameActionListener):void
      {
         var _loc2_:* = undefined;
         if (this.actionListeners.indexOf(param1) < 0)
         {
            this.actionListeners.push(param1);
            if (this.inputLocks.isEmpty())
            {
               for (_loc2_ in this.activeActions)
               {
                  param1.onGameAction(GameActionEnum(_loc2_), true, false);
               }
            }
         }
      }

      public function removeGameActionListener(param1:GameActionListener):void
      {
         var _loc2_:int = this.actionListeners.indexOf(param1);
         if (_loc2_ >= 0)
         {
            this.actionListeners.splice(_loc2_, 1);
         }
      }

      public function addMouseLockListener(param1:MouseLockListener):void
      {
         var _loc2_:int = this.mouseLockListeners.indexOf(param1);
         if (_loc2_ < 0)
         {
            this.mouseLockListeners.push(param1);
            if (Main.stage.mouseLock)
            {
               param1.onMouseLock(true);
            }
         }
      }

      public function removeMouseLockListener(param1:MouseLockListener):void
      {
         var _loc2_:int = this.mouseLockListeners.indexOf(param1);
         if (_loc2_ >= 0)
         {
            this.mouseLockListeners.splice(_loc2_, 1);
         }
      }

      public function addMouseMoveListener(param1:MouseMovementListener):void
      {
         var _loc2_:int = this.mouseMoveListeners.indexOf(param1);
         if (_loc2_ < 0)
         {
            this.mouseMoveListeners.push(param1);
         }
      }

      public function removeMouseMoveListener(param1:MouseMovementListener):void
      {
         var _loc2_:int = this.mouseMoveListeners.indexOf(param1);
         if (_loc2_ >= 0)
         {
            this.mouseMoveListeners.splice(_loc2_, 1);
         }
      }

      public function addMouseWheelListener(param1:MouseWheelListener):void
      {
         var _loc2_:int = this.mouseWheelListeners.indexOf(param1);
         if (_loc2_ < 0)
         {
            this.mouseWheelListeners.push(param1);
         }
      }

      public function removeMouseWheelListener(param1:MouseWheelListener):void
      {
         var _loc2_:int = this.mouseWheelListeners.indexOf(param1);
         if (_loc2_ >= 0)
         {
            this.mouseWheelListeners.splice(_loc2_, 1);
         }
      }

      private function activateMouseAction(param1:MouseButtonAction):void
      {
         if (!param1.isActive)
         {
            param1.isActive = true;
            this.handleActionActivation(param1.gameAction, false);
         }
      }

      private function deactivateMouseAction(param1:MouseButtonAction):void
      {
         if (param1.isActive)
         {
            param1.isActive = false;
            this.handleActionDeactivation(param1.gameAction);
         }
      }

      private function setMouseLock(param1:Boolean):void
      {
         if (param1)
         {
            this.mouseJustLocked = true;
         }
         if (this.isFullScreen)
         {
            Main.stage.mouseLock = param1;
         }
         var _loc2_:int = 0;
         while (_loc2_ < this.mouseLockListeners.length)
         {
            this.mouseLockListeners[_loc2_].onMouseLock(param1);
            _loc2_++;
         }
      }

      private function isLocked():Boolean
      {
         return this.inputLocks.isNotEmpty();
      }

      private function isNotLocked():Boolean
      {
         return this.inputLocks.isEmpty();
      }

      private function canLockMouse():Boolean
      {
         // return false; // HACK untill mouse controls implemented
         return PanelModel(Main.osgi.getService(IPanel)).isInBattle && (IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["mouseEnabled"] == "true" ? true : false); // FIXME
      }

      public function releaseMouse():void
      {
         if (Main.stage.mouseLock)
         {
            this.setMouseLock(false);
         }
      }
   }
}
