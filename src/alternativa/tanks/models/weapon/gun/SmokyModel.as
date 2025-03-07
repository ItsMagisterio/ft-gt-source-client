﻿package alternativa.tanks.models.weapon.gun
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.gun.GunModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.gun.IGunModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.tanks.models.weapon.IWeaponController;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.tank.TankModel;
    import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
    import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.models.weapon.shared.shot.ShotData;
    import alternativa.tanks.models.weapon.common.WeaponCommonData;
    import alternativa.tanks.models.weapon.shared.CommonTargetSystem;
    import alternativa.tanks.models.weapon.common.HitInfo;
    import alternativa.tanks.models.weapon.WeaponUtils;
    import com.reygazu.anticheat.variables.SecureInt;
    import alternativa.math.Vector3;
    import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
    import alternativa.tanks.models.weapon.shared.ICommonTargetEvaluator;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.object.ClientObject;
    import logic.tanks.WeaponsManager;
    import alternativa.tanks.models.weapon.shared.CommonTargetEvaluator;
    import alternativa.tanks.models.battlefield.BattlefieldData;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import alternativa.engine3d.alternativa3d;
    use namespace alternativa3d;

    public class SmokyModel extends GunModelBase implements IGunModelBase, IObjectLoadListener, IWeaponController
    {

        public static var DISTANCE_WEIGHT:Number = 0.5;
        private static const DECAL:Class = SmokyModel_DECAL;
        private static var decalMaterial:TextureMaterial;

        private var modelService:IModelService;
        private var battlefieldModel:IBattleField;
        private var tankModel:TankModel;
        private var weaponCommonModel:IWeaponCommonModel;
        private var weaponWeakeningModel:IWeaponWeakeningModel;
        private var localTankData:TankData;
        private var localShotData:ShotData;
        private var localWeaponCommonData:WeaponCommonData;
        private var targetSystem:CommonTargetSystem;
        private var hitInfo:HitInfo = new HitInfo();
        private var weaponUtils:WeaponUtils = WeaponUtils.getInstance();
        private var _triggerPressed:Boolean;
        private var nextReadyTime:SecureInt = new SecureInt("smoky_next_ready_time");
        private var _hitPos:Vector3 = new Vector3();
        private var _hitPosLocal:Vector3 = new Vector3();
        private var _hitPosGlobal:Vector3 = new Vector3();
        private var _gunDirGlobal:Vector3 = new Vector3();
        private var _muzzlePosGlobal:Vector3 = new Vector3();
        private var _barrelOrigin:Vector3 = new Vector3();
        private var _xAxis:Vector3 = new Vector3();
        private var _hitPos3d:Vector3d = new Vector3d(0, 0, 0);
        private var _tankPos3d:Vector3d = new Vector3d(0, 0, 0);
        private var targetEvaluator:ICommonTargetEvaluator;
        private var maxTargetingDistance:Number = 100000;
        private var currTime:SecureInt = new SecureInt("smoky_curr_time");

        public function SmokyModel()
        {
            _interfaces.push(IModel, IGunModelBase, IObjectLoadListener, IWeaponController);
            decalMaterial = new TextureMaterial(new DECAL().bitmapData);
        }
        public function objectLoaded(clientObject:ClientObject):void
        {
            if (this.modelService != null)
            {
                return;
            }
            this.modelService = IModelService(Main.osgi.getService(IModelService));
            this.battlefieldModel = (Main.osgi.getService(IBattleField) as IBattleField);
            this.tankModel = (Main.osgi.getService(ITank) as TankModel);
            this.weaponCommonModel = (Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel);
            this.weaponWeakeningModel = IWeaponWeakeningModel(this.modelService.getModelsByInterface(IWeaponWeakeningModel)[0]);
            // (this.battlefieldModel as BattlefieldModel).blacklist.push(decalMaterial.getTextureResource());
        }
        public function objectUnloaded(clientObject:ClientObject):void
        {
        }
        public function fire(clientObject:ClientObject, firingTankId:String, affectedPoint:Vector3d, affectedTankId:String, weakeningCoeff:Number):void
        {
            var affectedTankObject:ClientObject;
            var affectedTankData:TankData;
            var firingTank:ClientObject = BattleController.activeTanks[firingTankId];
            if (firingTank == null)
            {
                return;
            }
            if (this.tankModel.localUserData != null)
            {
                if (firingTank.id == this.tankModel.localUserData.user.id)
                {
                    return;
                }
            }
            var firingTankData:TankData = this.tankModel.getTankData(firingTank);
            var commonData:WeaponCommonData = this.weaponCommonModel.getCommonData(firingTankData.turret);
            var barrelIndex:int;
            this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh, commonData.muzzles[barrelIndex], this._muzzlePosGlobal, this._gunDirGlobal);
            this.weaponCommonModel.createShotEffects(firingTankData.turret, firingTankData.tank, barrelIndex, this._muzzlePosGlobal, this._gunDirGlobal, firingTank);
            if ((((affectedPoint == null) || (isNaN(affectedPoint.x))) || (isNaN(affectedPoint.y))))
            {
                return;
            }
            this._hitPos.x = affectedPoint.x;
            this._hitPos.y = affectedPoint.y;
            this._hitPos.z = affectedPoint.z;
            if (affectedTankId != null)
            {
                affectedTankObject = BattleController.activeTanks[affectedTankId];
                if (affectedTankObject == null)
                {
                    return;
                }
                affectedTankData = this.tankModel.getTankData(affectedTankObject);
                if (((affectedTankData == null) || (affectedTankData.tank == null)))
                {
                    return;
                }
                this.weaponCommonModel.createExplosionEffects(firingTankData.turret, this.battlefieldModel.getBattlefieldData().viewport.camera, true, this._hitPos, this._gunDirGlobal, affectedTankData, weakeningCoeff, firingTank);
                this.battlefieldModel.tankHit(affectedTankData, this._gunDirGlobal, (weakeningCoeff * commonData.impactCoeff));
            }
            else
            {
                this.weaponCommonModel.createExplosionEffects(firingTankData.turret, this.battlefieldModel.getBattlefieldData().viewport.camera, false, affectedPoint.toVector3(), this._gunDirGlobal, null, (weakeningCoeff * commonData.impactCoeff), firingTank);
                this.battlefieldModel.addDecal(affectedPoint.toVector3(), this._barrelOrigin, 250, decalMaterial);
            }
        }
        public function setLocalUser(localUserData:TankData):void
        {
            this.objectLoaded(null);
            this.localTankData = localUserData;
            this.localShotData = WeaponsManager.shotDatas[localUserData.turret.id];
            this.localWeaponCommonData = this.weaponCommonModel.getCommonData(localUserData.turret);
            this.targetEvaluator = CommonTargetEvaluator.create(this.localTankData, this.localShotData, this.battlefieldModel, this.weaponWeakeningModel, this.modelService);
            this.targetSystem = new CommonTargetSystem(this.maxTargetingDistance, this.localShotData.autoAimingAngleUp.value, this.localShotData.numRaysUp.value, this.localShotData.autoAimingAngleDown.value, this.localShotData.numRaysDown.value, this.battlefieldModel.getBattlefieldData().collisionDetector, this.targetEvaluator);
            this.reset();
        }
        public function clearLocalUser():void
        {
            this.localTankData = null;
            this.localShotData = null;
            this.localWeaponCommonData = null;
            this.targetSystem = null;
            this.targetEvaluator = null;
        }
        public function update(time:int, deltaTime:int):Number
        {
            var impactCoeff:Number;
            var key:*;
            var td:TankData;
            var v:Vector3;
            this.currTime.value = time;
            if (((!(this._triggerPressed)) || (this.currTime.value < this.nextReadyTime.value)))
            {
                if (this.currTime.value < this.nextReadyTime.value)
                {
                    return (1 + ((this.currTime.value - this.nextReadyTime.value) / this.localShotData.reloadMsec.value));
                }
                return (1);
            }
            this.nextReadyTime.value = (this.currTime.value + this.localShotData.reloadMsec.value);
            this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh, this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel], this._muzzlePosGlobal, this._barrelOrigin, this._xAxis, this._gunDirGlobal);
            this.weaponCommonModel.createShotEffects(this.localTankData.turret, this.localTankData.tank, this.localWeaponCommonData.currBarrel, this._muzzlePosGlobal, this._gunDirGlobal, this.localTankData.user);
            var bfData:BattlefieldData = this.battlefieldModel.getBattlefieldData();
            var victimData:TankData;
            var hitPos:Vector3d;
            var distance:Number = 0;
            if (this.targetSystem.getTarget(this._barrelOrigin, this._gunDirGlobal, this._xAxis, this.localTankData.tank, this.hitInfo))
            {
                distance = (this.hitInfo.distance * 0.01);
                hitPos = this._hitPos3d;
                hitPos.x = this.hitInfo.position.x;
                hitPos.y = this.hitInfo.position.y;
                hitPos.z = this.hitInfo.position.z;
                if (this.hitInfo.body != null)
                {
                    for (key in bfData.activeTanks)
                    {
                        td = key;
                        if (this.hitInfo.body == td.tank)
                        {
                            victimData = td;
                            break;
                        }
                    }
                }
                impactCoeff = this.weaponWeakeningModel.getImpactCoeff(this.localTankData.turret, distance);
                this.weaponCommonModel.createExplosionEffects(this.localTankData.turret, bfData.viewport.camera, false, this.hitInfo.position, this._gunDirGlobal, victimData, impactCoeff, this.localTankData.user);
                if (victimData != null)
                {
                    this._hitPosGlobal.vDiff(this.hitInfo.position, victimData.tank.state.pos);
                    victimData.tank.baseMatrix.transformVectorInverse(this._hitPosGlobal, this._hitPosLocal);
                    hitPos.x = this._hitPosLocal.x;
                    hitPos.y = this._hitPosLocal.y;
                    hitPos.z = this._hitPosLocal.z;
                }
            }
            if (victimData != null)
            {
                v = victimData.tank.state.pos;
                this._tankPos3d.x = v.x;
                this._tankPos3d.y = v.y;
                this._tankPos3d.z = v.z;
                this.fireCommand(this.localTankData.turret, distance, hitPos, victimData.user.id, victimData.incarnation, this._tankPos3d);
            }
            else
            {
                this.fireCommand(this.localTankData.turret, distance, hitPos, null, -1, null);
                if (hitPos != null)
                {
                    this.battlefieldModel.addDecal(hitPos.toVector3(), this._barrelOrigin, 250, decalMaterial);
                }
            }
            return (0);
        }
        private function fireCommand(turret:ClientObject, distance:Number, hitPos:Vector3d, victimId:String, victimInc:int, tankPos:Vector3d):void
        {
            var js:Object = new Object();
            js.distance = int.MAX_VALUE;
            js.hitPos = hitPos;
            js.victimId = victimId;
            js.victimInc = victimInc;
            js.tankPos = tankPos;
            js.reloadTime = this.localShotData.reloadMsec.value;
            Network(Main.osgi.getService(INetworker)).send(("battle;fire;" + JSON.stringify(js)));
        }
        public function activateWeapon(time:int):void
        {
            this._triggerPressed = true;
        }
        public function deactivateWeapon(time:int, sendServerCommand:Boolean):void
        {
            this._triggerPressed = false;
        }
        public function reset():void
        {
            this._triggerPressed = false;
            this.nextReadyTime.value = 0;
        }
        public function stopEffects(ownerTankData:TankData):void
        {
        }

    }
}
