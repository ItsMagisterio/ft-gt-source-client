﻿package alternativa.tanks.models.weapon.flamethrower
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.flamethrower.FlameThrowerModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.flamethrower.IFlameThrowerModelBase;
    import alternativa.tanks.models.weapon.IWeaponController;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.tank.TankModel;
    import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
    import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
    import com.reygazu.anticheat.variables.SecureInt;
    import alternativa.math.Vector3;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.models.weapon.common.WeaponCommonData;
    import flash.utils.Dictionary;
    import alternativa.tanks.models.weapon.WeaponUtils;
    import alternativa.tanks.models.weapon.shared.ConicAreaTargetSystem;
    import alternativa.tanks.models.weapon.shared.ITargetValidator;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.object.ClientObject;
    import logic.tanks.WeaponsManager;
    import alternativa.tanks.vehicles.tanks.Tank;
    import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import flash.utils.getTimer;
    import alternativa.tanks.models.sfx.flame.IFlamethrowerSFXModel;
    import alternativa.tanks.sfx.EffectsPair;

    public class FlamethrowerModel extends FlameThrowerModelBase implements IFlameThrowerModelBase, IFlamethrower, IWeaponController
    {

        private var modelService:IModelService;
        private var battlefield:IBattleField;
        private var tankInterface:TankModel;
        private var commonModel:IWeaponCommonModel;
        private var weakeningModel:IWeaponWeakeningModel;
        private var active:Boolean;
        private var lastUpdateTime:SecureInt = new SecureInt("lastUpdateTime flame");
        private var nextTargetCheckTime:SecureInt = new SecureInt("nextTargetCheckTime flame");
        private var targetIds:Array = [];
        private var targetPositions:Array = [];
        private var targetIncarnations:Array = [];
        private var targetDistances:Array = [];
        private var hitPointsTargets:Array = [];
        private var _firingOrigin:Vector3 = new Vector3();
        private var _gunGlobalDir:Vector3 = new Vector3();
        private var _xAxis:Vector3 = new Vector3();
        private var _tmpVector:Vector3 = new Vector3();
        private var localTankData:TankData;
        private var localFlameData:FlamethrowerData;
        private var localWeaponCommonData:WeaponCommonData;
        private var currentHeat:Number = 0;
        private var activeEffects:Dictionary = new Dictionary();
        private var weaponUtils:WeaponUtils = WeaponUtils.getInstance();
        private var targetSystem:ConicAreaTargetSystem;
        private var targetValidator:ITargetValidator = new FlamethrowerTargetValidator();

        public function FlamethrowerModel()
        {
            _interfaces.push(IModel, IFlameThrowerModelBase, IFlamethrower, IWeaponController);
        }
        public function initObject(clientObject:ClientObject, coneAngle:Number, coolingSpeed:int, heatingLimit:int, heatingSpeed:int, range:Number, targetDetectionIntervalMsec:int):void
        {
            if (this.modelService == null)
            {
                this.modelService = (Main.osgi.getService(IModelService) as IModelService);
                this.battlefield = (this.modelService.getModelsByInterface(IBattleField)[0] as IBattleField);
                this.tankInterface = (this.modelService.getModelsByInterface(ITank)[0] as TankModel);
                this.commonModel = (this.modelService.getModelsByInterface(IWeaponCommonModel)[0] as IWeaponCommonModel);
                this.weakeningModel = (this.modelService.getModelsByInterface(IWeaponWeakeningModel)[0] as IWeaponWeakeningModel);
            }
            var data:FlamethrowerData = new FlamethrowerData();
            data.coneAngle.value = coneAngle;
            data.coolingSpeed.value = coolingSpeed;
            data.heatingSpeed.value = heatingSpeed;
            data.heatLimit.value = heatingLimit;
            data.range.value = (range * 100);
            data.targetDetectionInterval.value = targetDetectionIntervalMsec;
            clientObject.putParams(FlamethrowerModel, data);
        }
        public function startFire(clientObject:ClientObject, firingTankId:String):void
        {
            var firingTankObject:ClientObject = clientObject;
            if (firingTankObject == null)
            {
                return;
            }
            var firingTankData:TankData = this.tankInterface.getTankData(firingTankObject);
            if ((((firingTankData == null) || (firingTankData.tank == null)) || (!(firingTankData.enabled))))
            {
                return;
            }
            if (this.tankInterface.localUserData != null)
            {
                if (firingTankId == this.tankInterface.localUserData.user.id)
                {
                    return;
                }
            }
            this.addFlameEffects(this.commonModel.getCommonData(firingTankData.turret), firingTankData);
        }
        public function stopFire(clientObject:ClientObject, firingTankId:String):void
        {
            this.removeFlameEffects(firingTankId);
        }
        public function getFlameData(clientObject:ClientObject):FlamethrowerData
        {
            return (clientObject.getParams(FlamethrowerModel) as FlamethrowerData);
        }
        public function setLocalUser(localUserData:TankData):void
        {
            this.localTankData = localUserData;
            this.localFlameData = this.getFlameData(WeaponsManager.getObjectFor(localUserData.turret.id));
            this.localWeaponCommonData = this.commonModel.getCommonData(localUserData.turret);
            this.lastUpdateTime.value = 0;
            this.currentHeat = 0;
            this.targetSystem = new ConicAreaTargetSystem(this.localFlameData.range.value, this.localFlameData.coneAngle.value, 5, 6, this.battlefield.getBattlefieldData().collisionDetector, this.targetValidator);
        }
        public function clearLocalUser():void
        {
            this.localTankData = null;
            this.localFlameData = null;
            this.localWeaponCommonData = null;
            this.targetSystem = null;
        }
        public function update(time:int, deltaTime:int):Number
        {
            var muzzleLocalPos:Vector3;
            var barrelLength:Number;
            var len:int;
            var i:int;
            var target:Tank;
            var targetData:TankData;
            var targetPosition:Vector3;
            var pos3d:Vector3d;
            if ((!(this.active)))
            {
                if (this.currentHeat > 0)
                {
                    this.currentHeat = (this.currentHeat - ((0.001 * (time - this.lastUpdateTime.value)) * this.localFlameData.coolingSpeed.value));
                    if (this.currentHeat < 0)
                    {
                        this.currentHeat = 0;
                    }
                }
                this.lastUpdateTime.value = time;
                return (1 - (this.currentHeat / this.localFlameData.heatLimit.value));
            }
            if (this.currentHeat >= this.localFlameData.heatLimit.value)
            {
                this.deactivateWeapon(time, true);
                return (0);
            }
            if (time >= this.nextTargetCheckTime.value)
            {
                muzzleLocalPos = this.localWeaponCommonData.muzzles[0];
                this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh, muzzleLocalPos, this._tmpVector, this._firingOrigin, this._xAxis, this._gunGlobalDir);
                this.targetIds.length = 0;
                barrelLength = muzzleLocalPos.y;
                this.targetSystem.getTargets(this.localTankData.tank, barrelLength, 0.3, this._firingOrigin, this._gunGlobalDir, this._xAxis, this.targetIds, this.targetDistances, this.hitPointsTargets);
                len = this.targetIds.length;
                if (len > 0)
                {
                    i = 0;
                    while (i < len)
                    {
                        target = this.targetIds[i];
                        targetData = target.tankData;
                        this.targetIds[i] = targetData.user.id;
                        this.targetDistances[i] = (0.01 * this.targetDistances[i]);
                        this.targetIncarnations[i] = targetData.incarnation;
                        targetPosition = target.state.pos;
                        pos3d = this.targetPositions[i];
                        if (pos3d == null)
                        {
                            pos3d = new Vector3d(targetPosition.x, targetPosition.y, targetPosition.z);
                            this.targetPositions[i] = pos3d;
                        }
                        else
                        {
                            pos3d.x = targetPosition.x;
                            pos3d.y = targetPosition.y;
                            pos3d.z = targetPosition.z;
                        }
                        i++;
                    }
                    this.targetIncarnations.length = len;
                    this.targetPositions.length = len;
                    this.hitCommand(this.localTankData.turret, this.targetIds, this.targetIncarnations, this.targetPositions, this.targetDistances);
                }
                this.nextTargetCheckTime.value = (this.nextTargetCheckTime.value + this.localFlameData.targetDetectionInterval.value);
            }
            this.currentHeat = (this.currentHeat + ((0.001 * (time - this.lastUpdateTime.value)) * this.localFlameData.heatingSpeed.value));
            this.lastUpdateTime.value = time;
            if (this.currentHeat > this.localFlameData.heatLimit.value)
            {
                return (0);
            }
            return (1 - (this.currentHeat / this.localFlameData.heatLimit.value));
        }
        private function hitCommand(turret:ClientObject, targetsIds:Array, targetsIncration:Array, targetPositions:Array, targetDistances:Array):void
        {
            var js:Object = new Object();
            js.targetsIds = targetsIds;
            js.targetPositions = targetPositions;
            js.targetDistances = targetDistances;
            js.tickPeriod = this.localFlameData.targetDetectionInterval.value;
            trace(JSON.stringify(js));
            Network(Main.osgi.getService(INetworker)).send(("battle;fire;" + JSON.stringify(js)));
        }
        private function startFireCommand(turret:ClientObject):void
        {
            Network(Main.osgi.getService(INetworker)).send("battle;start_fire");
        }
        private function stopFireCommand(turret:ClientObject):void
        {
            Network(Main.osgi.getService(INetworker)).send("battle;stop_fire");
        }
        public function activateWeapon(time:int):void
        {
            this.active = true;
            this.nextTargetCheckTime.value = (time + this.localFlameData.targetDetectionInterval.value);
            this.lastUpdateTime.value = time;
            this.addFlameEffects(this.localWeaponCommonData, this.localTankData);
            this.startFireCommand(this.localTankData.turret);
        }
        public function reset():void
        {
            this.currentHeat = 0;
            this.nextTargetCheckTime.value = 0;
            this.lastUpdateTime.value = getTimer();
        }
        public function stopEffects(ownerTankData:TankData):void
        {
            this.removeFlameEffects(ownerTankData.user.id);
        }
        public function deactivateWeapon(time:int, sendServerCommand:Boolean):void
        {
            this.active = false;
            this.nextTargetCheckTime.value = 0;
            this.lastUpdateTime.value = time;
            this.removeFlameEffects(this.localTankData.user.id);
            if (sendServerCommand)
            {
                this.stopFireCommand(this.localTankData.turret);
            }
        }
        private function addFlameEffects(commonData:WeaponCommonData, tankData:TankData):void
        {
            var sfxModel:IFlamethrowerSFXModel = WeaponsManager.getFlamethrowerSFX(tankData.turret, tankData.user);
            var effects:EffectsPair = sfxModel.getSpecialEffects(tankData, commonData.muzzles[commonData.currBarrel], tankData.tank.skin.turretMesh, this.weakeningModel);
            this.activeEffects[tankData.user.id] = effects;
            this.battlefield.addGraphicEffect(effects.graphicEffect);
            this.battlefield.addSound3DEffect(effects.soundEffect);
        }
        private function removeFlameEffects(userId:String):void
        {
            var effectsPair:EffectsPair = this.activeEffects[userId];
            if (effectsPair != null)
            {
                delete this.activeEffects[userId];
                if (effectsPair.graphicEffect != null)
                {
                    effectsPair.graphicEffect.kill();
                }
                if (effectsPair.soundEffect != null)
                {
                    effectsPair.soundEffect.kill();
                }
                if (((!(effectsPair.lightEffect == null)) && (!(effectsPair.muzzleLightEffect == null))))
                {
                    effectsPair.lightEffect.stop();
                    effectsPair.lightEffect = null;
                    effectsPair.muzzleLightEffect.stop();
                    effectsPair.muzzleLightEffect = null;
                }
            }
        }

    }
}
