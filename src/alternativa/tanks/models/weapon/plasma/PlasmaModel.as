﻿package alternativa.tanks.models.weapon.plasma
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.plasma.PlasmaModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.plasma.IPlasmaModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.tanks.models.weapon.IWeaponController;
    import alternativa.engine3d.materials.TextureMaterial;
    import flash.utils.Dictionary;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.models.weapon.shared.shot.ShotData;
    import alternativa.tanks.models.weapon.common.WeaponCommonData;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.tank.TankModel;
    import alternativa.tanks.models.weapon.common.WeaponCommonModel;
    import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
    import alternativa.tanks.models.weapon.shared.CommonTargetSystem;
    import alternativa.tanks.models.weapon.common.HitInfo;
    import alternativa.tanks.models.weapon.WeaponUtils;
    import com.reygazu.anticheat.variables.SecureInt;
    import alternativa.math.Vector3;
    import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
    import alternativa.physics.collision.types.RayIntersection;
    import alternativa.tanks.models.weapon.shared.CommonTargetEvaluator;
    import alternativa.model.IModel;
    import alternativa.object.ClientObject;
    import logic.tanks.WeaponsManager;
    import alternativa.tanks.models.battlefield.BattlefieldData;
    import alternativa.tanks.physics.TanksCollisionDetector;
    import alternativa.tanks.physics.CollisionGroup;
    import logic.networking.Network;
    import alternativa.init.Main;
    import logic.networking.INetworker;
    import alternativa.physics.Body;
    import alternativa.tanks.models.sfx.shoot.plasma.PlasmaSFXModel;
    import alternativa.tanks.models.sfx.shoot.plasma.PlasmaSFXData;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.tanks.models.weapon.common.IWeaponCommonModel;

    public class PlasmaModel extends PlasmaModelBase implements IPlasmaModelBase, IObjectLoadListener, IPlasmaShotListener, IWeaponController
    {

        private static const decal:Class = PlasmaModel_decal;
        private static var decalMaterial:TextureMaterial = new TextureMaterial(new decal().bitmapData);

        private var _triggerPressed:Boolean;
        private var shotId:int;
        private var activeShots:Dictionary = new Dictionary();
        private var localTankData:TankData;
        private var localShotData:ShotData;
        private var localWeaponCommonData:WeaponCommonData;
        private var modelService:IModelService;
        private var battlefieldModel:IBattleField;
        private var tankModel:TankModel;
        private var weaponCommonModel:WeaponCommonModel;
        private var weaponWeakeningModel:IWeaponWeakeningModel;
        private var targetSystem:CommonTargetSystem;
        private var hitInfo:HitInfo = new HitInfo();
        private var weaponUtils:WeaponUtils = WeaponUtils.getInstance();
        private var nextReadyTime:SecureInt = new SecureInt("twins nextReadyTime");
        private var currentTime:SecureInt = new SecureInt("twins currentTime");
        private var _dirToTarget:Vector3 = new Vector3();
        private var _barrelOrigin:Vector3 = new Vector3();
        private var _gunDirGlobal:Vector3 = new Vector3();
        private var _xAxis:Vector3 = new Vector3();
        private var _hitPosGlobal:Vector3 = new Vector3();
        private var _hitPosLocal:Vector3 = new Vector3();
        private var _muzzlePosGlobal:Vector3 = new Vector3();
        private var _hitPos:Vector3 = new Vector3();
        private var _hitPos3d:Vector3d = new Vector3d(0, 0, 0);
        private var _tankPos3d:Vector3d = new Vector3d(0, 0, 0);
        private var _dirToTarget3d:Vector3d = new Vector3d(0, 0, 0);
        private var intersection:RayIntersection = new RayIntersection();
        private var targetEvaluator:CommonTargetEvaluator;
        private var maxTargetingDistance:Number = 100000;

        public function PlasmaModel()
        {
            _interfaces.push(IModel, IPlasmaModelBase, IObjectLoadListener, IWeaponController);
        }
        public function objectLoaded(clientObject:ClientObject):void
        {
            this.cacheInterfaces();
        }
        public function objectUnloaded(clientObject:ClientObject):void
        {
            var playerShots:Dictionary;
            var shot:PlasmaShot;
            for each (playerShots in this.activeShots)
            {
                for each (shot in playerShots)
                {
                    shot.kill();
                }
            }
            this.activeShots = new Dictionary();
        }
        public function initObject(clientObject:ClientObject, chargeRadius:Number, distance:Number, speed:Number):void
        {
            var data:PlasmaGunData = new PlasmaGunData();
            data.shotSpeed = (speed * 100);
            data.shotRange = (distance * 100);
            data.shotRadius = (chargeRadius * 100);
            clientObject.putParams(PlasmaModel, data);
        }
        public function fire(clientObject:ClientObject, firingTankId:String, barrel:int, shotId:int, dirToTarget:Vector3d):void
        {
            var firingTankObject:ClientObject;
            var firingTankData:TankData;
            var commonData:WeaponCommonData;
            this.objectLoaded(null);
            try
            {
                firingTankObject = BattleController.activeTanks[firingTankId];
                if (firingTankObject == null)
                {
                    return;
                }
                if (this.tankModel.localUserData != null)
                {
                    if (firingTankId == this.tankModel.localUserData.user.id)
                    {
                        return;
                    }
                }
                firingTankData = this.tankModel.getTankData(firingTankObject);
                if (firingTankData.tank == null)
                {
                    return;
                }
                commonData = this.weaponCommonModel.getCommonData(firingTankData.turret);
                this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh, commonData.muzzles[barrel], this._muzzlePosGlobal, this._gunDirGlobal);
                this.weaponCommonModel.createShotEffects(firingTankData.turret, firingTankData.tank, barrel, this._muzzlePosGlobal, this._gunDirGlobal, firingTankObject);
                if (shotId > -1)
                {
                    this._dirToTarget.x = dirToTarget.x;
                    this._dirToTarget.y = dirToTarget.y;
                    this._dirToTarget.z = dirToTarget.z;
                    this.createShot(false, shotId, firingTankData, this._muzzlePosGlobal, this._dirToTarget);
                }
            }
            catch (e:Error)
            {
            }
        }
        public function hit(clientObject:ClientObject, firingTankId:String, shotId:int, affectedPoint:Vector3d, affectedTankId:String, weakeningCoeff:Number):void
        {
            var firingTankData:TankData;
            var shot:PlasmaShot;
            var affectedTankObject:ClientObject;
            var affectedTankData:TankData;
            var commonData:WeaponCommonData;
            var firingTankObject:ClientObject = BattleController.activeTanks[firingTankId];
            if (((firingTankObject == null) || (this.tankModel == null)))
            {
                return;
            }
            try
            {
                firingTankData = this.tankModel.getTankData(firingTankObject);
            }
            catch (e:Error)
            {
                return;
            }
            if (firingTankData.tank == null)
            {
                return;
            }
            var tankShots:Dictionary = this.activeShots[firingTankId];
            if (tankShots != null)
            {
                shot = tankShots[shotId];
                if (shot != null)
                {
                    this.removeShot(shot);
                    shot.kill();
                }
            }
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
                if (affectedTankData.tank == null)
                {
                    return;
                }
                this.weaponCommonModel.createExplosionEffects(firingTankData.turret, this.battlefieldModel.getBattlefieldData().viewport.camera, true, this._hitPos, this._gunDirGlobal, affectedTankData, weakeningCoeff, firingTankObject);
                commonData = this.weaponCommonModel.getCommonData(firingTankData.turret);
                this.battlefieldModel.tankHit(affectedTankData, this._gunDirGlobal, (weakeningCoeff * commonData.impactCoeff));
            }
            else
            {
                this.weaponCommonModel.createExplosionEffects(firingTankData.turret, this.battlefieldModel.getBattlefieldData().viewport.camera, false, this._hitPos, null, null, weakeningCoeff, firingTankObject);
                this.battlefieldModel.addDecal(affectedPoint.toVector3(), this._barrelOrigin, 100, decalMaterial);
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
            this.currentTime.value = time;
            if (((!(this._triggerPressed)) || (this.currentTime.value < this.nextReadyTime.value)))
            {
                if (this.currentTime.value < this.nextReadyTime.value)
                {
                    return (1 + ((this.currentTime.value - this.nextReadyTime.value) / this.localShotData.reloadMsec.value));
                }
                return (1);
            }
            this.nextReadyTime.value = (this.currentTime.value + this.localShotData.reloadMsec.value);
            var bfData:BattlefieldData = this.battlefieldModel.getBattlefieldData();
            var collisionDetector:TanksCollisionDetector = TanksCollisionDetector(bfData.physicsScene.collisionDetector);
            var muzzlePosLocal:Vector3 = this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel];
            this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh, muzzlePosLocal, this._muzzlePosGlobal, this._barrelOrigin, this._xAxis, this._gunDirGlobal);
            var canFire:Boolean = (!(collisionDetector.intersectRay(this._barrelOrigin, this._gunDirGlobal, CollisionGroup.STATIC, muzzlePosLocal.y, null, this.intersection)));
            this.weaponCommonModel.createShotEffects(this.localTankData.turret, this.localTankData.tank, this.localWeaponCommonData.currBarrel, this._muzzlePosGlobal, this._gunDirGlobal, this.localTankData.user);
            var realShotId:int = -1;
            if (canFire)
            {
                if (this.targetSystem.getTarget(this._muzzlePosGlobal, this._gunDirGlobal, this._xAxis, this.localTankData.tank, this.hitInfo))
                {
                    this._dirToTarget.vCopy(this.hitInfo.direction);
                }
                else
                {
                    this._dirToTarget.vCopy(this._gunDirGlobal);
                }
                this._dirToTarget3d.x = this._dirToTarget.x;
                this._dirToTarget3d.y = this._dirToTarget.y;
                this._dirToTarget3d.z = this._dirToTarget.z;
                realShotId = this.shotId;
                this.createShot(true, this.shotId, this.localTankData, this._muzzlePosGlobal, this._dirToTarget);
                this.shotId++;
            }
            this.fireCommand(this.localTankData.turret, this.localWeaponCommonData.currBarrel, realShotId, this._dirToTarget3d);
            this.localWeaponCommonData.currBarrel = ((this.localWeaponCommonData.currBarrel + 1) % this.localWeaponCommonData.muzzles.length);
            return (0);
        }
        private function fireCommand(turr:ClientObject, currBarrel:int, realShotId:int, _dirToTarget3d:Vector3d):void
        {
            var js:Object = new Object();
            js.currBarrel = currBarrel;
            js.realShotId = realShotId;
            js.dirToTarget = _dirToTarget3d;
            js.reloadTime = this.localShotData.reloadMsec.value;
            Network(Main.osgi.getService(INetworker)).send(("battle;start_fire;" + JSON.stringify(js)));
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
        public function stopEffects(tankData:TankData):void
        {
        }
        public function plasmaShotDissolved(shot:PlasmaShot):void
        {
            this.removeShot(shot);
        }
        public function plasmaShotHit(shot:PlasmaShot, hitPoint:Vector3, hitDir:Vector3, body:Body):void
        {
            var key:*;
            var td:TankData;
            var v:Vector3;
            this.removeShot(shot);
            var affectedTankData:TankData;
            if (body != null)
            {
                for (key in this.battlefieldModel.getBattlefieldData().activeTanks)
                {
                    td = key;
                    if (body == td.tank)
                    {
                        this._hitPosGlobal.vDiff(hitPoint, body.state.pos);
                        body.baseMatrix.transformVectorInverse(this._hitPosGlobal, this._hitPosLocal);
                        this._hitPos3d.x = this._hitPosLocal.x;
                        this._hitPos3d.y = this._hitPosLocal.y;
                        this._hitPos3d.z = this._hitPosLocal.z;
                        affectedTankData = td;
                        break;
                    }
                }
            }
            else
            {
                this._hitPos3d.x = hitPoint.x;
                this._hitPos3d.y = hitPoint.y;
                this._hitPos3d.z = hitPoint.z;
            }
            var distance:Number = (0.01 * shot.totalDistance);
            var weakeingCoeff:Number = this.weaponWeakeningModel.getImpactCoeff(shot.shooterData.turret, distance);
            this.weaponCommonModel.createExplosionEffects(shot.shooterData.turret, this.battlefieldModel.getBattlefieldData().viewport.camera, false, hitPoint, hitDir, affectedTankData, weakeingCoeff, shot.shooterData.user);
            if (affectedTankData != null)
            {
                v = affectedTankData.tank.state.pos;
                this._tankPos3d.x = v.x;
                this._tankPos3d.y = v.y;
                this._tankPos3d.z = v.z;
                this.hitCommand(shot.shooterData.turret, shot.shotId, this._hitPos3d, affectedTankData.user.id, affectedTankData.incarnation, this._tankPos3d, distance);
            }
            else
            {
                this.hitCommand(shot.shooterData.turret, shot.shotId, this._hitPos3d, null, -1, null, distance);
                if (this._hitPos3d != null)
                {
                    this.battlefieldModel.addDecal(this._hitPos3d.toVector3(), this._barrelOrigin, 100, decalMaterial);
                }
            }
        }
        private function hitCommand(turrObj:ClientObject, shotId:int, hitPos:Vector3d, affectedTankId:String, incr:int, tankPos:Vector3d, distance:int):void
        {
            var js:Object = new Object();
            js.shotId = shotId;
            js.hitPos = hitPos;
            js.victimId = affectedTankId;
            js.incr = incr;
            js.tankPos = tankPos;
            js.distance = distance;
            js.reloadTime = this.localShotData.reloadMsec.value;
            Network(Main.osgi.getService(INetworker)).send(("battle;fire;" + JSON.stringify(js)));
        }
        private function getWeaponData(clientObject:ClientObject):PlasmaGunData
        {
            return (clientObject.getParams(PlasmaModel) as PlasmaGunData);
        }
        private function removeShot(shot:PlasmaShot):void
        {
            var tankShots:Dictionary = this.activeShots[shot.shooterData.user.id];
            if (tankShots != null)
            {
                delete tankShots[shot.shotId];
            }
        }
        private function createShot(active:Boolean, shotId:int, tankData:TankData, muzzleGlobalPos:Vector3, dirToTarget:Vector3):void
        {
            var data:PlasmaGunData = this.getWeaponData(tankData.turret);
            var tankShots:Dictionary = this.activeShots[tankData.user.id];
            if (tankShots == null)
            {
                this.activeShots[tankData.user.id] = (tankShots = new Dictionary());
            }
            var bfData:BattlefieldData = this.battlefieldModel.getBattlefieldData();
            var plasmaShootSfx:PlasmaSFXModel = WeaponsManager.getTwinsSFX(WeaponsManager.getObjectFor(tankData.turret.id), tankData.user);
            var plasmaData:PlasmaSFXData = plasmaShootSfx.getPlasmaSFXData(tankData.turret, tankData.user);
            var shot:PlasmaShot = PlasmaShot.getShot();
            shot.init(shotId, active, data, muzzleGlobalPos, dirToTarget, tankData, this, plasmaData, bfData.physicsScene.collisionDetector, this.weaponWeakeningModel);
            tankShots[shotId] = shot;
            this.battlefieldModel.addGraphicEffect(shot);
        }
        private function cacheInterfaces():void
        {
            if (this.modelService == null)
            {
                this.modelService = IModelService(Main.osgi.getService(IModelService));
                this.battlefieldModel = IBattleField(this.modelService.getModelsByInterface(IBattleField)[0]);
                this.tankModel = (Main.osgi.getService(ITank) as TankModel);
                this.weaponCommonModel = (Main.osgi.getService(IWeaponCommonModel) as WeaponCommonModel);
                this.weaponWeakeningModel = IWeaponWeakeningModel(this.modelService.getModelsByInterface(IWeaponWeakeningModel)[0]);
            }
        }

    }
}
