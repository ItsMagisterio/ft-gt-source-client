package alternativa.tanks.models.weapon.freeze
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.freeze.FreezeModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.freeze.IFreezeModelBase;
    import alternativa.tanks.models.weapon.IWeaponController;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.tank.TankModel;
    import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
    import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.models.weapon.common.WeaponCommonData;
    import com.reygazu.anticheat.variables.SecureNumber;
    import com.reygazu.anticheat.variables.SecureInt;
    import alternativa.tanks.models.weapon.WeaponUtils;
    import alternativa.tanks.models.weapon.shared.ConicAreaTargetSystem;
    import alternativa.math.Vector3;
    import alternativa.model.IModel;
    import alternativa.object.ClientObject;
    import logic.tanks.WeaponsManager;
    import flash.utils.getTimer;
    import alternativa.tanks.models.weapon.flamethrower.FlamethrowerTargetValidator;
    import logic.networking.Network;
    import alternativa.init.Main;
    import logic.networking.INetworker;
    import alternativa.tanks.vehicles.tanks.Tank;
    import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
    import alternativa.register.ObjectRegister;
    import alternativa.tanks.models.tank.ITank;

    public class FreezeModel extends FreezeModelBase implements IFreezeModelBase, IWeaponController, IFreezeModel
    {

        private var modelService:IModelService;
        private var battlefieldModel:IBattleField;
        private var tankModel:TankModel;
        private var weaponCommonModel:IWeaponCommonModel;
        private var weaponWeakeningModel:IWeaponWeakeningModel;
        private var sfxModel:IFreezeSFXModel;
        private var localTankData:TankData;
        private var localFreezeData:FreezeData;
        private var localWeaponCommonData:WeaponCommonData;
        private var currentEnergy:SecureNumber = new SecureNumber("currentEnergy freeze");
        private var nextTargetCheckTime:SecureInt = new SecureInt("nextTargetCheckTime.value freeze");
        private var lastUpdateTime:SecureInt = new SecureInt("lastUpdateTime.value freeze");
        private var active:Boolean;
        private var weaponUtils:WeaponUtils = WeaponUtils.getInstance();
        private var targetSystem:ConicAreaTargetSystem;
        private var targetIds:Array = [];
        private var targetPositions:Array = [];
        private var targetIncarnations:Array = [];
        private var targetDistances:Array = [];
        private var hitPointsTargets:Array = [];
        private var barrelOrigin:Vector3 = new Vector3();
        private var gunGlobalDir:Vector3 = new Vector3();
        private var gunRotationAxis:Vector3 = new Vector3();
        private var muzzlePosGlobal:Vector3 = new Vector3();

        public function FreezeModel()
        {
            _interfaces.push(IModel, IWeaponController, IFreezeModel);
        }
        public function startFire(clientObject:ClientObject, shooterId:String):void
        {
            var tankData:TankData = this.getTankDataSafe(clientObject.register, shooterId);
            if (((!(tankData == null)) && (!(tankData == this.tankModel.localUserData))))
            {
                this.createEffects(tankData, this.weaponCommonModel.getCommonData(tankData.turret));
            }
        }
        public function stopFire(clientObject:ClientObject, shooterId:String):void
        {
            var tankData:TankData = this.getTankDataSafe(clientObject.register, shooterId);
            if ((((!(tankData == null)) && (tankData.enabled)) && (!(tankData == this.tankModel.localUserData))))
            {
                this.stopEffects(tankData);
            }
        }
        public function initObject(clientObject:ClientObject, damageAreaConeAngle:Number, damageAreaRange:Number, energyCapacity:int, energyDischargeSpeed:int, energyRechargeSpeed:int, weaponTickMsec:int, owner:ClientObject):void
        {
            this.cacheInterfaces();
            var freezeData:FreezeData = new FreezeData(damageAreaConeAngle, (100 * damageAreaRange), energyCapacity, energyDischargeSpeed, energyRechargeSpeed, weaponTickMsec);
            clientObject.putParams(FreezeModel, freezeData);
            WeaponsManager.getFrezeeSFXModel(clientObject, owner);
            if (this.sfxModel == null)
            {
                this.sfxModel = WeaponsManager.getFrezeeSFXModel(clientObject, owner);
            }
        }
        public function getFreezeData(clientObject:ClientObject):FreezeData
        {
            return (FreezeData(clientObject.getParams(FreezeModel)));
        }
        public function stopEffects(ownerTankData:TankData):void
        {
            if (this.sfxModel != null)
            {
                this.sfxModel.destroyEffects(ownerTankData);
            }
        }
        public function reset():void
        {
            this.currentEnergy.value = this.localFreezeData.energyCapacity;
            this.lastUpdateTime.value = getTimer();
        }
        public function setLocalUser(localUserData:TankData):void
        {
            this.localTankData = localUserData;
            this.localFreezeData = this.getFreezeData(localUserData.turret);
            this.localWeaponCommonData = this.weaponCommonModel.getCommonData(localUserData.turret);
            this.currentEnergy.value = this.localFreezeData.energyCapacity;
            this.lastUpdateTime.value = 0;
            var numRays:int = 5;
            var numSteps:int = 6;
            this.targetSystem = new ConicAreaTargetSystem(this.localFreezeData.damageAreaRange, this.localFreezeData.damageAreaConeAngle, numRays, numSteps, this.battlefieldModel.getBattlefieldData().collisionDetector, new FlamethrowerTargetValidator());
        }
        public function clearLocalUser():void
        {
            this.localTankData = null;
            this.localFreezeData = null;
            this.localWeaponCommonData = null;
            this.targetSystem = null;
        }
        public function activateWeapon(time:int):void
        {
            this.active = true;
            this.nextTargetCheckTime.value = (time + this.localFreezeData.weaponTickMsec.value);
            this.lastUpdateTime.value = time;
            this.startFireCommand(this.localTankData.turret);
            this.createEffects(this.localTankData, this.localWeaponCommonData);
        }
        private function startFireCommand(cl:ClientObject):void
        {
            Network(Main.osgi.getService(INetworker)).send("battle;start_fire");
        }
        public function deactivateWeapon(time:int, sendServerCommand:Boolean):void
        {
            this.active = false;
            this.lastUpdateTime.value = time;
            if (sendServerCommand)
            {
                this.stopFireCommand(this.localTankData.turret);
            }
            this.stopEffects(this.localTankData);
        }
        private function stopFireCommand(tur:ClientObject):void
        {
            Network(Main.osgi.getService(INetworker)).send("battle;stop_fire");
        }
        public function update(time:int, deltaTime:int):Number
        {
            var energyCapacity:Number;
            if (this.active)
            {
                if (time >= this.nextTargetCheckTime.value)
                {
                    this.nextTargetCheckTime.value = (this.nextTargetCheckTime.value + this.localFreezeData.weaponTickMsec.value);
                    this.checkTargets(this.localWeaponCommonData, this.localTankData);
                }
                this.currentEnergy.value = (this.currentEnergy.value - ((this.localFreezeData.energyDischargeSpeed * (time - this.lastUpdateTime.value)) * 0.001));
                if (this.currentEnergy.value <= 0)
                {
                    this.currentEnergy.value = 0;
                    this.deactivateWeapon(time, true);
                }
            }
            else
            {
                energyCapacity = this.localFreezeData.energyCapacity;
                if (this.currentEnergy.value < energyCapacity)
                {
                    this.currentEnergy.value = (this.currentEnergy.value + ((this.localFreezeData.energyRechargeSpeed * (time - this.lastUpdateTime.value)) * 0.001));
                    if (this.currentEnergy.value > energyCapacity)
                    {
                        this.currentEnergy.value = energyCapacity;
                    }
                }
            }
            this.lastUpdateTime.value = time;
            return (this.currentEnergy.value / this.localFreezeData.energyCapacity);
        }
        private function checkTargets(commonData:WeaponCommonData, tankData:TankData):void
        {
            var i:int;
            var target:Tank;
            var targetData:TankData;
            var targetPosition:Vector3;
            var pos3d:Vector3d;
            var muzzleLocalPos:Vector3 = commonData.muzzles[0];
            this.weaponUtils.calculateGunParams(tankData.tank.skin.turretMesh, muzzleLocalPos, this.muzzlePosGlobal, this.barrelOrigin, this.gunRotationAxis, this.gunGlobalDir);
            this.targetIds.length = 0;
            var barrelLength:Number = muzzleLocalPos.y;
            this.targetSystem.getTargets(this.localTankData.tank, barrelLength, 0.3, this.barrelOrigin, this.gunGlobalDir, this.gunRotationAxis, this.targetIds, this.targetDistances, this.hitPointsTargets);
            var len:int = this.targetIds.length;
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
                this.hitCommand(tankData.turret, this.targetIds, this.targetIncarnations, this.targetPositions, this.targetDistances);
            }
        }
        private function hitCommand(turr:ClientObject, victims:Array, victimsInc:Array, targetPositions:Array, targetDistances:Array):void
        {
            var json:Object = new Object();
            json.victims = victims;
            json.targetDistances = targetDistances;
            json.tickPeriod = this.localFreezeData.weaponTickMsec.value;
            Network(Main.osgi.getService(INetworker)).send(("battle;fire;" + JSON.stringify(json)));
        }
        private function createEffects(tankData:TankData, commonData:WeaponCommonData):void
        {
            if (this.sfxModel != null)
            {
                this.sfxModel.createEffects(tankData, commonData);
            }
        }
        private function getTankDataSafe(register:ObjectRegister, tankId:String):TankData
        {
            var tankObject:ClientObject = BattleController.activeTanks[tankId];
            if (tankObject == null)
            {
                return (null);
            }
            var tankData:TankData = this.tankModel.getTankData(tankObject);
            if (((tankData == null) || (tankData.tank == null)))
            {
                return (null);
            }
            return (tankData);
        }
        private function cacheInterfaces():void
        {
            if (this.modelService == null)
            {
                this.modelService = IModelService(Main.osgi.getService(IModelService));
                this.battlefieldModel = IBattleField(this.modelService.getModelsByInterface(IBattleField)[0]);
                this.tankModel = TankModel(Main.osgi.getService(ITank));
                this.weaponCommonModel = IWeaponCommonModel(this.modelService.getModelsByInterface(IWeaponCommonModel)[0]);
                this.weaponWeakeningModel = IWeaponWeakeningModel(this.modelService.getModelsByInterface(IWeaponWeakeningModel)[0]);
            }
        }

    }
}
