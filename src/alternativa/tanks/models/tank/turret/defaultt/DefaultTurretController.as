package alternativa.tanks.models.tank.turret.defaultt
{
   import alternativa.tanks.models.tank.turret.TurretController;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.init.Main;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.vehicles.tanks.Tank;
   import alternativa.tanks.utils.MathUtils;
   import alternativa.tanks.service.settings.SettingsService;
   import alternativa.tanks.service.settings.ISettingsService;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.camera.FollowCameraController;
   import alternativa.tanks.services.battleinput.BattleInputService;
   import alternativa.tanks.services.battleinput.GameActionListener;
   import alternativa.tanks.service.settings.keybinding.GameActionEnum;
   import alternativa.tanks.services.battleinput.MouseMovementListener;
   import alternativa.tanks.services.battleinput.MouseLockListener;
   import alternativa.tanks.services.battleinput.BattleInputServiceImpl;
   import alternativa.tanks.battle.BattleUtils;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
   import alternativa.console.IConsole;

   public class DefaultTurretController implements TurretController, GameActionListener, MouseLockListener
   {

      private var tankData:TankData;
      private var tankModel:TankModel;
      public var lockTurretDirection:Boolean;
      private static const MOUSE_SENS_MUL:Number = 0.0001;
      // private var mouseLookDirection:Number = 0;
      private static const v:Vector3 = new Vector3();
      private var battleInputService:BattleInputServiceImpl = BattleInputServiceImpl(Main.osgi.getService(BattleInputService));
      private var previosDir:GameActionEnum;
      private var rightMouseLockEnabled:Boolean = false;
      public function DefaultTurretController(tankData:TankData)
      {
         this.tankData = tankData;
         this.tankModel = (Main.osgi.getService(ITank) as TankModel);
         if (this.tankData.local)
         {
            this.battleInputService.addGameActionListener(this);
            this.battleInputService.addMouseLockListener(this);
         }

      }
      public function rotateTurret(deltaSec:Number, time:Number):void
      {

         var tank:Tank = this.tankData.tank;
         if (FollowCameraController.getFollowCameraMode() == FollowCameraController.CAMERA_FOLLOWS_MOUSE && this.tankData.local && (this.tankData.spawnState == TankSpawnState.ACTIVE || this.tankData.spawnState == TankSpawnState.NEWCOME))
         {

            var locOut:Number = tank.getLocalDirectionFromWorldDirection(FollowCameraController.getFollowCameraDirection(), tank.baseMatrix);

            var closestDir:GameActionEnum = getClosestRotationDirection(tankData.tank.turretDir, locOut);
            // (Main.osgi.getService(IConsole) as IConsole).addLine("shortest dir " + closestDir);
            if (!this.rightMouseLockEnabled)
            {
               tank.rotateToLocalDirection(deltaSec, locOut);
            }
            if (closestDir == GameActionEnum.STOP_TURRET && tank.turretTurnSpeed == 0 && this.previosDir != GameActionEnum.STOP_TURRET)
            {
               this.battleInputService.dispatchActionEventForcibly(this.previosDir, false, false);
               this.previosDir = GameActionEnum.STOP_TURRET;
            }
            else
            {
               if (closestDir != previosDir)
               {
                  // (Main.osgi.getService(IConsole) as IConsole).addLine("Direction changed: " + closestDir);
                  this.battleInputService.dispatchActionEventForcibly(previosDir, false, false);
                  this.battleInputService.dispatchActionEventForcibly(closestDir, true, false);
                  this.previosDir = closestDir;
               }
            }
         }
         else
         {
            var turretRotationDir:int = (((this.tankData.ctrlBits & TankModel.TURRET_LEFT) >> 4) - ((this.tankData.ctrlBits & TankModel.TURRET_RIGHT) >> 5));

            if (turretRotationDir != 0)
            {
               if ((this.tankData.ctrlBits & TankModel.CENTER_TURRET) != 0)
               {
                  this.tankData.ctrlBits = (this.tankData.ctrlBits & (~(TankModel.CENTER_TURRET)));
                  if (this.tankData.local)
                  {
                     this.tankModel.controlBits = (this.tankModel.controlBits & (~(TankModel.CENTER_TURRET)));
                  }
                  if (tank.turretDirSign == turretRotationDir)
                  {
                     tank.stopTurret();
                     this.tankData.sounds.playTurretSound(false);
                  }
               }
               this.tankData.tank.rotateTurret((turretRotationDir * deltaSec), false);
            }
            else
            {
               if ((this.tankData.ctrlBits & TankModel.CENTER_TURRET) != 0)
               {
                  if (tank.rotateTurret((-(tank.turretDirSign) * deltaSec), true))
                  {
                     this.tankData.ctrlBits = (this.tankData.ctrlBits & (~(TankModel.CENTER_TURRET)));
                     tank.stopTurret();
                  }
               }
               else
               {
                  tank.stopTurret();
               }
            }
            this.tankData.sounds.playTurretSound((!(this.tankData.tank.turretTurnSpeed == 0)));
         }

      }

      private function getClosestRotationDirection(currentRotation:Number, targetRotation:Number):GameActionEnum
      {
         if (this.rightMouseLockEnabled)
         {
            return GameActionEnum.STOP_TURRET;
         }
         // Normalize rotations to 0-2π scale
         currentRotation = (currentRotation < 0) ? currentRotation + 2 * Math.PI : currentRotation;
         targetRotation = (targetRotation < 0) ? targetRotation + 2 * Math.PI : targetRotation;

         var diff:Number = targetRotation - currentRotation;
         if (diff < -Math.PI)
            diff += 2 * Math.PI;
         if (diff > Math.PI)
            diff -= 2 * Math.PI;

         if (Math.abs(diff) < 0.05)
         {
            return GameActionEnum.STOP_TURRET;
         }
         return diff > 0 ? GameActionEnum.ROTATE_TURRET_LEFT_MOUSE : GameActionEnum.ROTATE_TURRET_RIGHT_MOUSE;
      }

      public function onMouseRelativeMovement(param1:Number, param2:Number):void
      {
         // this.mouseLookDirection = MathUtils.clampAngle(this.mouseLookDirection - param1 * SettingsService(Main.osgi.getService(ISettingsService)).mouseSensitivity * MOUSE_SENS_MUL);
         // var tank:Tank = this.tankData.tank;
         // this.mouseLookDirection = MathUtils.clampAngle(this.mouseLookDirection - param1 * 8 * MOUSE_SENS_MUL);
         // FollowCameraController.setFollowCameraDirection(this.mouseLookDirection);

      }

      public function enableTurretSound(value:Boolean):void
      {
      }

      public function onGameAction(param1:GameActionEnum, param2:Boolean, param3:Boolean):void
      {
         switch (param1)
         {
            case GameActionEnum.LOOK_AROUND:
               this.rightMouseLockEnabled = param2;
               return;
            default:
               return;
         }
      }

      public function onMouseLock(param1:Boolean):void
      {
         if (param1 && FollowCameraController.getFollowCameraMode() != FollowCameraController.CAMERA_FOLLOWS_MOUSE)
         {
            // this.mouseLookDirection = this.tankData.tank._skin.turretDirection;
            FollowCameraController.setFollowCameraMode(FollowCameraController.CAMERA_FOLLOWS_MOUSE);
            // FollowCameraController.setFollowCameraDirection(this.mouseLookDirection);
            // this.turret.setTurretControlState(TurretControlType.TARGET_ANGLE_WORLD,this.mouseLookDirection,Turret.TURN_SPEED_COUNT);
         }
      }

   }
}
