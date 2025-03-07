﻿package alternativa.tanks.models.weapon.railgun
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.railgun.RailgunModelBase;
    import alternativa.model.IModel;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.railgun.IRailgunModelBase;
    import alternativa.tanks.models.weapon.IWeaponController;
    import alternativa.model.IObjectLoadListener;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.models.weapon.shared.shot.ShotData;
    import alternativa.tanks.models.weapon.common.WeaponCommonData;
    import alternativa.tanks.models.weapon.WeaponUtils;
    import com.reygazu.anticheat.variables.SecureInt;
    import alternativa.math.Vector3;
    import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
    import alternativa.init.Main;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.object.ClientObject;
    import logic.tanks.WeaponsManager;
    import alternativa.tanks.models.sfx.shoot.railgun.IRailgunSFXModel;
    import alternativa.tanks.sfx.IGraphicEffect;
    import alternativa.tanks.sfx.ISound3DEffect;
    import alternativa.tanks.models.weapon.WeaponConst;
    import alternativa.tanks.models.ctf.ICTFModel;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import alternativa.tanks.models.battlefield.BattlefieldData;

    public class RailgunModel extends RailgunModelBase implements IModel, IRailgunModelBase, IWeaponController, IObjectLoadListener
    {

        private static const DECAL_RADIUS:Number = 50;
        private static const DECAL:Class = RailgunModel_DECAL;
        private static var decalMaterial:TextureMaterial;

        private const INFINITY:Number = 20000;

        private var modelService:IModelService;
        private var battlefieldModel:BattlefieldModel;
        private var tankModel:ITank;
        private var commonModel:IWeaponCommonModel;
        private var localTankData:TankData;
        private var localShotData:ShotData;
        private var localRailgunData:RailgunData;
        private var localWeaponCommonData:WeaponCommonData;
        private var weaponUtils:WeaponUtils = WeaponUtils.getInstance();
        private var _triggerPressed:Boolean;
        private var chargeTimeLeft:SecureInt = new SecureInt("chargeTimeLeft.value railgun");
        private var nextReadyTime:SecureInt = new SecureInt("chargeTimeLeft.value railgun");
        private var targetSystem:RailgunTargetSystem = new RailgunTargetSystem();
        private var shotResult:RailgunShotResult = new RailgunShotResult();
        private var _globalHitPosition:Vector3 = new Vector3();
        private var _xAxis:Vector3 = new Vector3();
        private var _globalMuzzlePosition:Vector3 = new Vector3();
        private var _globalGunDirection:Vector3 = new Vector3();
        private var _barrelOrigin:Vector3 = new Vector3();
        private var _hitPos3d:Vector3d = new Vector3d(0, 0, 0);
        private var targetPositions:Array = [];
        private var targetIncarnations:Array = [];
        private var firstshot:* = true;

        public function RailgunModel()
        {
            _interfaces.push(IModel, IRailgunModelBase, IWeaponController, IObjectLoadListener);
            this.objectLoaded(null);
            if (decalMaterial == null)
            {
                decalMaterial = new TextureMaterial(new DECAL().bitmapData);
            }
        }
        public function objectLoaded(clientObject:ClientObject):void
        {
            if (this.commonModel == null)
            {
                this.modelService = (Main.osgi.getService(IModelService) as IModelService);
                this.battlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
                this.tankModel = (Main.osgi.getService(ITank) as ITank);
                this.commonModel = (Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel);
            }
        }
        public function objectUnloaded(clientObject:ClientObject):void
        {
        }
        public function initObject(clientObject:ClientObject, chargingTimeMsec:int, weakeningCoeff:Number):void
        {
            var railgunData:RailgunData = new RailgunData();
            railgunData.chargingTime = chargingTimeMsec;
            railgunData.weakeningCoeff = weakeningCoeff;
            clientObject.putParams(RailgunModel, railgunData);
            // this.battlefieldModel.blacklist.push(decalMaterial.getTextureResource());
            this.objectLoaded(clientObject);
        }
        public function startFire(clientObject:ClientObject, firingTankId:String):void
        {
            var firingTank:ClientObject = clientObject;
            if (firingTank == null)
            {
                return;
            }
            if (this.tankModel == null)
            {
                this.tankModel = (Main.osgi.getService(ITank) as ITank);
            }
            var firingTankData:TankData = this.tankModel.getTankData(firingTank);
            if ((((firingTankData.tank == null) || (!(firingTankData.enabled))) || (firingTankData.local)))
            {
                return;
            }
            if (this.commonModel == null)
            {
                this.commonModel = (Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel);
            }
            var commonData:WeaponCommonData = this.commonModel.getCommonData(firingTankData.turret);
            this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh, commonData.muzzles[0], this._globalMuzzlePosition, this._globalGunDirection);
            var railgunSfxModel:IRailgunSFXModel = WeaponsManager.getRailgunSFX(firingTankData.turret, firingTankData.user);
            var railgunData:RailgunData = this.getRailgunData(firingTankData.turret);
            var graphicEffect:IGraphicEffect = railgunSfxModel.createChargeEffect(firingTankData.turret, firingTankData.user, commonData.muzzles[commonData.currBarrel], firingTankData.tank.skin.turretMesh, railgunData.chargingTime);
            if (this.battlefieldModel == null)
            {
                this.battlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            }
            if (this.firstshot)
            {
                this.firstshot = false;
                this.battlefieldModel.addGraphicEffect(graphicEffect);
                graphicEffect = railgunSfxModel.createChargeEffect(firingTankData.turret, firingTankData.user, commonData.muzzles[commonData.currBarrel], firingTankData.tank.skin.turretMesh, railgunData.chargingTime);
            }
            this.battlefieldModel.addGraphicEffect(graphicEffect);
            var soundEffect:ISound3DEffect = railgunSfxModel.createSoundShotEffect(firingTankData.turret, firingTankData.user, this._globalMuzzlePosition);
            if (soundEffect != null)
            {
                this.battlefieldModel.addSound3DEffect(soundEffect);
            }
        }
        public function fire(clientObject:ClientObject, firingTankId:String, affectedPoints:Array, affectedTankIds:Array):void
        {
            var firingTankData:TankData;
            var commonData:WeaponCommonData;
            var railGunData:RailgunData;
            var v:Vector3d;
            var graphicEffect:IGraphicEffect;
            var i:int;
            var affectedTankObject:ClientObject;
            var affectedTankData:TankData;
            var firingTank:ClientObject = clientObject;
            if (firingTank == null)
            {
                return;
            }
            firingTankData = this.tankModel.getTankData(firingTank);
            if (((((firingTankData == null) || (firingTankData.tank == null)) || (!(firingTankData.enabled))) || (firingTankData.local)))
            {
                return;
            }
            if (this.commonModel == null)
            {
                this.commonModel = (Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel);
            }
            if (this.battlefieldModel == null)
            {
                this.battlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            }
            commonData = this.commonModel.getCommonData(firingTankData.turret);
            railGunData = this.getRailgunData(firingTankData.turret);
            this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh, commonData.muzzles[0], this._globalMuzzlePosition, this._globalGunDirection);
            var numPoints:int = affectedPoints.length;
            var impactForce:Number = commonData.impactForce;
            if (affectedTankIds != null)
            {
                i = 0;
                while (i < (numPoints - 1))
                {
                    affectedTankObject = BattleController.activeTanks[affectedTankIds[i]];
                    if (affectedTankObject != null)
                    {
                        affectedTankData = this.tankModel.getTankData(affectedTankObject);
                        if (!((affectedTankData == null) || (affectedTankData.tank == null)))
                        {
                            v = affectedPoints[i];
                            this._globalHitPosition.x = v.x;
                            this._globalHitPosition.y = v.y;
                            this._globalHitPosition.z = v.z;
                            this._globalHitPosition.vTransformBy3(affectedTankData.tank.baseMatrix);
                            this._globalHitPosition.vAdd(affectedTankData.tank.state.pos);
                            affectedTankData.tank.addWorldForceScaled(this._globalHitPosition, this._globalGunDirection, impactForce);
                            this.battlefieldModel.tankHit(affectedTankData, this._globalGunDirection, (impactForce / WeaponConst.BASE_IMPACT_FORCE));
                            impactForce = (impactForce * railGunData.weakeningCoeff);
                        }
                    }
                    i++;
                }
            }
            v = affectedPoints[(numPoints - 1)];
            this._globalHitPosition.x = v.x;
            this._globalHitPosition.y = v.y;
            this._globalHitPosition.z = v.z;
            this.battlefieldModel.addDecal(this._globalHitPosition, this._globalMuzzlePosition, DECAL_RADIUS, decalMaterial);
            firingTankData.tank.addWorldForceScaled(this._globalMuzzlePosition, this._globalGunDirection, -(commonData.kickback));
            var railgunSfxModel:IRailgunSFXModel = WeaponsManager.getRailgunSFX(firingTankData.turret, firingTankData.user);
            var angle:Number = this._globalHitPosition.vClone().vRemove(this._globalMuzzlePosition).vNormalize().vCosAngle(this._globalGunDirection);
            if (angle < 0)
            {
                trace("Adding inversed ray");
                graphicEffect = railgunSfxModel.createGraphicShotEffect(firingTankData.turret, this._globalMuzzlePosition, this._globalMuzzlePosition.vClone().vScale(2).vRemove(this._globalHitPosition));
            }
            else
            {
                graphicEffect = railgunSfxModel.createGraphicShotEffect(firingTankData.turret, this._globalMuzzlePosition, this._globalHitPosition);
            }
            if (graphicEffect != null)
            {
                this.battlefieldModel.addGraphicEffect(graphicEffect);
            }
        }
        public function activateWeapon(time:int):void
        {
            this._triggerPressed = true;
        }
        public function deactivateWeapon(time:int, sendServerCommand:Boolean):void
        {
            this._triggerPressed = false;
        }
        public function setLocalUser(localUserData:TankData):void
        {
            this.localTankData = localUserData;
            this.localShotData = WeaponsManager.shotDatas[localUserData.turret.id];
            this.localRailgunData = this.getRailgunData(localUserData.turret);
            this.localWeaponCommonData = this.commonModel.getCommonData(localUserData.turret);
            var ctfModel:ICTFModel;
            this.battlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            this.targetSystem.setParams(this.battlefieldModel.getBattlefieldData().physicsScene.collisionDetector, this.localShotData.autoAimingAngleUp.value, this.localShotData.numRaysUp.value, this.localShotData.autoAimingAngleDown.value, this.localShotData.numRaysDown.value, this.localRailgunData.weakeningCoeff, ctfModel);
            this.reset();
            var muzzleLocalPos:Vector3 = this.localWeaponCommonData.muzzles[0];
            var railgunSfxModel:IRailgunSFXModel = WeaponsManager.getRailgunSFX(this.localTankData.turret, this.localTankData.user);
            var graphicEffect:IGraphicEffect = railgunSfxModel.createChargeEffect(this.localTankData.turret, this.localTankData.user, muzzleLocalPos, this.localTankData.tank.skin.turretMesh, this.localRailgunData.chargingTime);
            if (graphicEffect != null)
            {
                this.battlefieldModel.addGraphicEffect(graphicEffect);
            }
        }
        public function clearLocalUser():void
        {
            this.localTankData = null;
            this.localShotData = null;
            this.localRailgunData = null;
            this.localWeaponCommonData = null;
        }
        public function update(time:int, deltaTime:int):Number
        {
            var muzzleLocalPos:Vector3;
            var railgunSfxModel:IRailgunSFXModel;
            var graphicEffect:IGraphicEffect;
            var soundEffect:ISound3DEffect;
            if (this.chargeTimeLeft.value > 0)
            {
                this.chargeTimeLeft.value = (this.chargeTimeLeft.value - deltaTime);
                if (this.chargeTimeLeft.value <= 0)
                {
                    this.chargeTimeLeft.value = 0;
                    this.doFire(this.localWeaponCommonData, this.localTankData, time);
                }
                return (this.chargeTimeLeft.value / this.localRailgunData.chargingTime);
            }
            if (time < this.nextReadyTime.value)
            {
                return (1 - ((this.nextReadyTime.value - time) / this.localShotData.reloadMsec.value));
            }
            if (this._triggerPressed)
            {
                this.chargeTimeLeft.value = this.localRailgunData.chargingTime;
                muzzleLocalPos = this.localWeaponCommonData.muzzles[0];
                this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh, muzzleLocalPos, this._globalMuzzlePosition, this._barrelOrigin, this._xAxis, this._globalGunDirection);
                railgunSfxModel = WeaponsManager.getRailgunSFX(this.localTankData.turret, this.localTankData.user);
                graphicEffect = railgunSfxModel.createChargeEffect(this.localTankData.turret, this.localTankData.user, muzzleLocalPos, this.localTankData.tank.skin.turretMesh, this.localRailgunData.chargingTime);
                if (graphicEffect != null)
                {
                    this.battlefieldModel.addGraphicEffect(graphicEffect);
                }
                soundEffect = railgunSfxModel.createSoundShotEffect(this.localTankData.turret, this.localTankData.user, this._globalMuzzlePosition);
                if (soundEffect != null)
                {
                    this.battlefieldModel.addSound3DEffect(soundEffect);
                }
                this.startFireCommand(this.localTankData.turret);
            }
            return (1);
        }
        private function startFireCommand(turr:ClientObject):void
        {
            Network(Main.osgi.getService(INetworker)).send("battle;start_fire");
        }
        public function reset():void
        {
            this.nextReadyTime.value = (this.chargeTimeLeft.value = 0);
            this._triggerPressed = false;
        }
        public function stopEffects(ownerTankData:TankData):void
        {
        }
        private function getRailgunData(clientObject:ClientObject):RailgunData
        {
            return (clientObject.getParams(RailgunModel) as RailgunData);
        }
        private function doFire(commonData:WeaponCommonData, tankData:TankData, time:int):void
        {
            var graphicEffect:IGraphicEffect;
            var len:int;
            var i:int;
            var currHitPoint:Vector3;
            var currTankData:TankData;
            var v:Vector3;
            this.nextReadyTime.value = (time + this.localShotData.reloadMsec.value);
            this.weaponUtils.calculateGunParams(tankData.tank.skin.turretMesh, commonData.muzzles[commonData.currBarrel], this._globalMuzzlePosition, this._barrelOrigin, this._xAxis, this._globalGunDirection);
            var bfData:BattlefieldData = this.battlefieldModel.getBattlefieldData();
            this.targetSystem.getTargets(tankData, this._barrelOrigin, this._globalGunDirection, this._xAxis, bfData.tanks, this.shotResult);
            if (this.shotResult.hitPoints.length == 0)
            {
                this._globalHitPosition.x = (this._hitPos3d.x = (this._globalMuzzlePosition.x + (this.INFINITY * this._globalGunDirection.x)));
                this._globalHitPosition.y = (this._hitPos3d.y = (this._globalMuzzlePosition.y + (this.INFINITY * this._globalGunDirection.y)));
                this._globalHitPosition.z = (this._hitPos3d.z = (this._globalMuzzlePosition.z + (this.INFINITY * this._globalGunDirection.z)));
                this.fireCommand(tankData.turret, null, [this._hitPos3d], null, null);
            }
            else
            {
                this._globalHitPosition.vCopy(this.shotResult.hitPoints[(this.shotResult.hitPoints.length - 1)]);
                if (this.shotResult.hitPoints.length == this.shotResult.targets.length)
                {
                    this._globalHitPosition.vSubtract(this._globalMuzzlePosition).vNormalize().vScale(this.INFINITY).vAdd(this._globalMuzzlePosition);
                    this.shotResult.hitPoints.push(this._globalHitPosition);
                }
                this.shotResult.hitPoints[(this.shotResult.hitPoints.length - 1)] = new Vector3d(this._globalHitPosition.x, this._globalHitPosition.y, this._globalHitPosition.z);
                this.targetPositions.length = 0;
                this.targetIncarnations.length = 0;
                len = this.shotResult.targets.length;
                i = 0;
                while (i < len)
                {
                    currHitPoint = this.shotResult.hitPoints[i];
                    currTankData = this.shotResult.targets[i];
                    currTankData.tank.addWorldForceScaled(currHitPoint, this.shotResult.dir, commonData.impactForce);
                    this.shotResult.targets[i] = currTankData.user.id;
                    currHitPoint.vSubtract(currTankData.tank.state.pos).vTransformBy3Tr(currTankData.tank.baseMatrix);
                    this.shotResult.hitPoints[i] = new Vector3d(currHitPoint.x, currHitPoint.y, currHitPoint.z);
                    v = currTankData.tank.state.pos;
                    this.targetPositions[i] = new Vector3d(v.x, v.y, v.z);
                    this.targetIncarnations[i] = currTankData.incarnation;
                    i++;
                }
                if (len == 0)
                {
                    this.battlefieldModel.addDecal(Vector3d(this.shotResult.hitPoints[0]).toVector3(), this._barrelOrigin, DECAL_RADIUS, decalMaterial);
                }
                else
                {
                    this.battlefieldModel.addDecal(this._globalHitPosition, this._barrelOrigin, DECAL_RADIUS, decalMaterial);
                }
                this.fireCommand(tankData.turret, this.targetIncarnations, this.shotResult.hitPoints, this.shotResult.targets, this.targetPositions);
            }
            tankData.tank.addWorldForceScaled(this._globalMuzzlePosition, this._globalGunDirection, -(commonData.kickback));
            var railgunSfxModel:IRailgunSFXModel = WeaponsManager.getRailgunSFX(tankData.turret, tankData.user);
            var angle:Number = this._globalHitPosition.vClone().vRemove(this._globalMuzzlePosition).vNormalize().vCosAngle(this._globalGunDirection);
            if (angle < 0)
            {
                graphicEffect = railgunSfxModel.createGraphicShotEffect(tankData.turret, this._globalMuzzlePosition, this._globalMuzzlePosition.vClone().vScale(2).vRemove(this._globalHitPosition));
            }
            else
            {
                graphicEffect = railgunSfxModel.createGraphicShotEffect(tankData.turret, this._globalMuzzlePosition, this._globalHitPosition);
            }
            if (graphicEffect != null)
            {
                this.battlefieldModel.addGraphicEffect(graphicEffect);
            }
        }
        public function fireCommand(turret:ClientObject, targetInc:Array, hitPoints:Array, targets:Array, targetPostitions:Array):void
        {
            var firstHitPoints:Vector3d = (hitPoints[0] as Vector3d);
            var jsobject:Object = new Object();
            jsobject.hitPoints = hitPoints;
            jsobject.targetInc = targetInc;
            jsobject.targets = targets;
            jsobject.targetPostitions = targetPostitions;
            jsobject.reloadTime = this.localShotData.reloadMsec.value;
            trace(JSON.stringify(jsobject));
            Network(Main.osgi.getService(INetworker)).send(("battle;fire;" + JSON.stringify(jsobject)));
        }

    }
}
