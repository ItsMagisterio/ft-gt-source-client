package alternativa.tanks.models.weapon.common
{
    import alternativa.tanks.service.settings.keybinding.KeysBindingService;
    import alternativa.tanks.service.settings.keybinding.KeysBindingServiceImpl;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.common.WeaponCommonModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.common.IWeaponCommonModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.tanks.models.weapon.IWeapon;
    import alternativa.osgi.service.dump.dumper.IDumper;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.models.weapon.IWeaponController;
    import alternativa.math.Vector3;
    import alternativa.model.IModel;

    import alternativa.init.Main;
    import alternativa.tanks.models.weapon.WeaponConst;
    import alternativa.object.ClientObject;
    import alternativa.osgi.service.dump.IDumpService;
    import logic.tanks.WeaponsManager;
    import alternativa.tanks.models.sfx.shoot.ICommonShootSFX;
    import alternativa.tanks.sfx.EffectsPair;
    import alternativa.tanks.vehicles.tanks.Tank;
    import alternativa.engine3d.core.Camera3D;
    import flash.utils.getTimer;
    import __AS3__.vec.Vector;
    import flash.geom.Vector3D;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import flash.events.KeyboardEvent;
    import __AS3__.vec.*;
    import alternativa.physics.altphysics;
    import flash.events.MouseEvent;
    import alternativa.tanks.services.battleinput.GameActionListener;
    import alternativa.tanks.service.settings.keybinding.GameActionEnum;
    import alternativa.tanks.camera.FollowCameraController;
    import alternativa.tanks.services.battleinput.BattleInputServiceImpl;
    import alternativa.tanks.services.battleinput.BattleInputService;

    use namespace altphysics;

    public class WeaponCommonModel extends WeaponCommonModelBase implements GameActionListener, IWeaponCommonModelBase, IObjectLoadListener, IWeaponCommonModel, IWeapon, IDumper
    {

        private var triggerKeyCode:uint;
        private var modelService:IModelService;
        private var battlefield:IBattleField;
        private var tankModel:ITank;
        private var localUserData:TankData;
        private var localCommonData:WeaponCommonData;
        public var localWeaponController:IWeaponController;
        private var triggerPressed:Boolean;
        private var enabled:Boolean;
        private var indicatorValue:Number = 0;
        private var triggerKeyDown:Boolean;
        private var triggerKeyUp:Boolean;
        private var _hitPosition:Vector3 = new Vector3();
        private var numObjects:int;
        private var battleInputService:BattleInputServiceImpl = BattleInputServiceImpl(Main.osgi.getService(BattleInputService));

        public function WeaponCommonModel()
        {
            _interfaces.push(IModel, IWeaponCommonModelBase, IObjectLoadListener, IWeaponCommonModel, IWeapon);
        }
        public function getWeaponController():IWeaponController
        {
            return (this.localWeaponController);
        }
        public function initObject(clientObject:ClientObject, impactForce:Number, kickback:Number, turretRotationAcceleration:Number, turretRotationSpeed:Number, shotEffectId:String, ownerTank:ClientObject):void
        {
            if (this.modelService == null)
            {
                this.modelService = (Main.osgi.getService(IModelService) as IModelService);
                this.battlefield = (Main.osgi.getService(IBattleField) as IBattleField);
                this.tankModel = (Main.osgi.getService(ITank) as ITank);
            }
            var weaponData:WeaponCommonData = new WeaponCommonData();
            var correctionCoeff:Number = WeaponConst.BASE_IMPACT_FORCE;
            weaponData.kickback = (kickback * correctionCoeff);
            weaponData.impactCoeff = impactForce;
            weaponData.impactForce = (impactForce * correctionCoeff);
            weaponData.turretRotationAccel = turretRotationAcceleration;
            weaponData.turretRotationSpeed = turretRotationSpeed;
            weaponData.muzzles = this.parseMuzzles(clientObject);
            clientObject.putParams(WeaponCommonModel, weaponData);
            ownerTank.sessionId = String(Math.round(Math.random() * 10000) + "ses");
            ownerTank.putParams(ShotEffect, (shotEffectId == "" || shotEffectId == "null" || shotEffectId == null) ? clientObject.id : shotEffectId);
            this.numObjects++;
        }
        public function objectLoaded(clientObject:ClientObject):void
        {
            var weaponData:WeaponCommonData = this.getCommonData(clientObject);
        }
        public function initWeaponController(clientObject:ClientObject, owner:ClientObject):void
        {
            var weaponData:WeaponCommonData = this.getCommonData(clientObject);
            weaponData.weaponController = BattleController.getWeaponController(clientObject, owner);
        }
        public function objectUnloaded(clientObject:ClientObject):void
        {
            var dumpService:IDumpService;
            if (((!(this.localUserData == null)) && (this.localUserData.turret == clientObject)))
            {
                this.battleInputService.removeGameActionListener(this);
            }
            this.numObjects--;
            if (this.numObjects == 0)
            {
                dumpService = IDumpService(Main.osgi.getService(IDumpService));
                if (dumpService != null)
                {
                    dumpService.unregisterDumper(this.dumperName);
                }
            }
        }

        public function getCommonData(clientObject:ClientObject):WeaponCommonData
        {
            return (WeaponCommonData(clientObject.getParams(WeaponCommonModel)));
        }
        public function createShotEffects(turretObject:ClientObject, firingTank:Tank, barrelIndex:int, globalMuzzlePosition:Vector3, globalGunDirection:Vector3, byWho:ClientObject):void
        {
            var commonData:WeaponCommonData = this.getCommonData(turretObject);
            firingTank.addWorldForceScaled(globalMuzzlePosition, globalGunDirection, -(commonData.kickback));
            var sfxModel:ICommonShootSFX = WeaponsManager.getCommonShotSFX(WeaponsManager.getObjectFor(turretObject.id), firingTank.tankData.user);
            if (sfxModel == null)
            {
                return;
            }
            if (this.battlefield == null)
            {
                this.battlefield = (Main.osgi.getService(IBattleField) as IBattleField);
            }
            var effectsPair:EffectsPair = sfxModel.createShotEffects(turretObject, commonData.muzzles[barrelIndex], firingTank.skin.turretMesh, this.battlefield.getBattlefieldData().viewport.camera, byWho);
            this.battlefield.addGraphicEffect(effectsPair.graphicEffect);
            this.battlefield.addSound3DEffect(effectsPair.soundEffect);
        }
        public function createExplosionEffects(turretObject:ClientObject, camera:Camera3D, isLocalHitPosition:Boolean, hitPosition:Vector3, globalHitDirection:Vector3, victimData:TankData, impactCoeff:Number, byWho:ClientObject):void
        {
            var sfxModel:ICommonShootSFX = WeaponsManager.getCommonShotSFX(turretObject, byWho);
            if (sfxModel == null)
            {
                return;
            }
            if (victimData != null)
            {
                if (isLocalHitPosition)
                {
                    victimData.tank.baseMatrix.transformVector(hitPosition, this._hitPosition);
                    this._hitPosition.vAdd(victimData.tank.state.pos);
                }
                else
                {
                    this._hitPosition.vCopy(hitPosition);
                }
                victimData.tank.addWorldForceScaled(this._hitPosition, globalHitDirection, (this.getCommonData(turretObject).impactForce * impactCoeff));
            }
            else
            {
                this._hitPosition.vCopy(hitPosition);
            }
            var effectsPair:EffectsPair = sfxModel.createExplosionEffects(turretObject, this._hitPosition, camera, impactCoeff, byWho);
            if (this.battlefield == null)
            {
                this.battlefield = (Main.osgi.getService(IBattleField) as IBattleField);
            }
            this.battlefield.addGraphicEffect(effectsPair.graphicEffect);
            this.battlefield.addSound3DEffect(effectsPair.soundEffect);
        }
        public function ownerLoaded(ownerObject:ClientObject):void
        {
            var ownerTankData:TankData = this.tankModel.getTankData(ownerObject);
            if (ownerTankData.local)
            {
                this.indicatorValue = 0;
                this.localUserData = ownerTankData;
                this.localCommonData = this.getCommonData(this.localUserData.turret);
                this.localWeaponController = this.localCommonData.weaponController;
                battleInputService.addGameActionListener(this);
                if (this.localWeaponController == null)
                {
                    this.localWeaponController = BattleController.getWeaponController(ownerObject, ownerObject);
                }
                if (this.localWeaponController != null)
                {
                    this.localWeaponController.setLocalUser(ownerTankData);
                }
                this.triggerKeyDown = (this.triggerKeyUp = false);
                this.enabled = false;
            }
        }
        public function ownerUnloaded(ownerObject:ClientObject):void
        {
            var ownerTankData:TankData = this.tankModel.getTankData(ownerObject);
            var commonData:WeaponCommonData = this.getCommonData(ownerTankData.turret);
            if (commonData.weaponController != null)
            {
                commonData.weaponController.stopEffects(ownerTankData);
            }
            if (ownerTankData.local)
            {
                battleInputService.removeGameActionListener(this);
                if (this.localWeaponController != null)
                {
                    this.localWeaponController.deactivateWeapon(getTimer(), false);
                    this.localWeaponController.clearLocalUser();
                }
                this.enabled = false;
                this.localUserData = null;
                this.localCommonData = null;
                this.localWeaponController = null;
                this.battleInputService.removeGameActionListener(this);
            }
        }
        public function ownerDisabled(ownerObject:ClientObject):void
        {
            var ownerTankData:TankData = this.tankModel.getTankData(ownerObject);
            var commonData:WeaponCommonData = this.getCommonData(ownerTankData.turret);
            if (commonData.weaponController != null)
            {
                commonData.weaponController.stopEffects(ownerTankData);
            }
            if (ownerTankData.local)
            {
                if (this.localWeaponController != null)
                {
                    this.localWeaponController.deactivateWeapon(getTimer(), false);
                    this.localWeaponController.reset();
                }
                if (((this.triggerKeyDown) && (this.triggerKeyUp)))
                {
                    this.triggerKeyDown = (this.triggerKeyUp = false);
                }
                this.enabled = false;
                this.triggerPressed = false;
                this.indicatorValue = 0;
            }
        }
        public function reset():void
        {
            if (this.localWeaponController != null)
            {
                this.localWeaponController.reset();
            }
        }
        public function enable():void
        {
            if (((!(this.enabled)) && (!(this.localWeaponController == null))))
            {
                this.enabled = true;
            }
        }
        public function disable():void
        {
            if (((!(this.enabled)) || (this.localWeaponController == null)))
            {
                return;
            }
            this.enabled = false;
            this.triggerKeyDown = false;
            this.triggerKeyUp = false;
            this.triggerPressed = false;
            this.localWeaponController.deactivateWeapon(getTimer(), true);
        }
        public function stop():void
        {
            if (((!(this.enabled)) || (this.localWeaponController == null)))
            {
                return;
            }
            this.triggerKeyUp = true;
        }
        public function update(time:int, deltaTime:int):Number
        {
            if (this.localWeaponController == null)
            {
                return (0);
            }
            var activatedThisUpdate:Boolean;
            var doUpdate:Boolean = true;
            if (this.enabled)
            {
                if (this.triggerKeyDown)
                {
                    if ((!(this.triggerPressed)))
                    {
                        this.triggerPressed = true;
                        activatedThisUpdate = true;
                        this.localWeaponController.activateWeapon(time);
                    }
                }
                if (this.triggerKeyUp)
                {
                    if (this.triggerPressed)
                    {
                        if (activatedThisUpdate)
                        {
                            this.indicatorValue = this.localWeaponController.update(time, deltaTime);
                            doUpdate = false;
                        }
                        this.localWeaponController.deactivateWeapon(time, true);
                        this.triggerPressed = false;
                    }
                    this.triggerKeyDown = (this.triggerKeyUp = false);
                }
            }
            if (doUpdate)
            {
                this.indicatorValue = this.localWeaponController.update(time, deltaTime);
            }
            return (this.indicatorValue);
        }
        public function getTurretRotationAccel(clientObject:ClientObject):Number
        {
            return (this.getCommonData(clientObject).turretRotationAccel);
        }
        public function getTurretRotationSpeed(clientObject:ClientObject):Number
        {
            return (this.getCommonData(clientObject).turretRotationSpeed);
        }
        public function get dumperName():String
        {
            return ("weaponcommon");
        }
        public function dump(params:Vector.<String>):String
        {
            return (((((((((((((((("=== WeaponCommonModel dump ===\n" + "enabled=") + this.enabled) + "\n") + "triggerPressed=") + this.triggerPressed) + "\n") + "triggerKeyDown=") + this.triggerKeyDown) + "\n") + "triggerKeyUp=") + this.triggerKeyUp) + "\n") + "indicatorValue=") + this.indicatorValue) + "\n") + "=== end of WeaponCommonModel dump ===");
        }
        private function v3dto3(src:Vector.<Vector3D>):Vector.<Vector3>
        {
            var v:Vector3D;
            var f:Vector.<Vector3> = new Vector.<Vector3>();
            for each (v in src)
            {
                f.push(new Vector3(v.x, v.y, v.z));
            }
            return (f);
        }
        private function parseMuzzles(clientObject:ClientObject):Vector.<Vector3>
        {
            var muzzles:Vector.<Vector3> = this.v3dto3(ResourceUtil.getResource(ResourceType.MODEL, clientObject.id).muzzles);
            return (muzzles);
        }

        public function onGameAction(param1:GameActionEnum, down:Boolean, param3:Boolean):void
        {
            switch (param1)
            {
                case GameActionEnum.SHOT:
                    if (down)
                    {
                        this.triggerKeyDown = true;
                        this.triggerKeyUp = false;
                    }
                    else
                    {
                        if ((!(this.enabled)))
                        {
                            this.triggerKeyDown = (this.triggerKeyUp = false);
                        }
                        else
                        {
                            this.triggerKeyUp = true;
                        }
                    }
                    break;
                default:
                    return;
            }
        }
    }
}
