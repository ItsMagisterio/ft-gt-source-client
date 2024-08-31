package alternativa.tanks.models.weapon.terminator
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.terminator.TerminatorModelBase;
    import alternativa.model.IModel;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.terminator.ITerminatorModelBase;
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
    import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import alternativa.tanks.models.battlefield.BattlefieldData;

    public class TerminatorModel extends TerminatorModelBase implements IModel, ITerminatorModelBase, IWeaponController, IObjectLoadListener
    {

        private static const DECAL_RADIUS:Number = 50;
        private static const DECAL:Class = TerminatorModel_DECAL;
        private static var decalMaterial:TextureMaterial;

        private const INFINITY:Number = 20000;

        private var modelService:IModelService;
        private var battlefieldModel:BattlefieldModel;
        private var tankModel:ITank;
        private var commonModel:IWeaponCommonModel;
        private var localTankData:TankData;
        private var localShotData:ShotData;
        private var localTerminatorData:TerminatorData;
        private var localWeaponCommonData:WeaponCommonData;
        private var weaponUtils:WeaponUtils = WeaponUtils.getInstance();
        private var _triggerPressed:Boolean;
        private var chargeTimeLeft:SecureInt = new SecureInt("chargeTimeLeft.value terminator");
        private var nextReadyTime:SecureInt = new SecureInt("chargeTimeLeft.value terminator");
        private var targetSystem:TerminatorTargetSystem = new TerminatorTargetSystem();
        private var shotResult:TerminatorShotResult = new TerminatorShotResult();
        private var _globalHitPosition:Vector3 = new Vector3();
        private var _xAxis:Vector3 = new Vector3();
        private var _globalMuzzlePosition:Vector3 = new Vector3();
        private var _globalGunDirection:Vector3 = new Vector3();
        private var _barrelOrigin:Vector3 = new Vector3();
        private var _hitPos3d:Vector3d = new Vector3d(0, 0, 0);
        private var targetPositions:Array = [];
        private var targetIncarnations:Array = [];
        private var firstshot:* = true;
        private var shotBarrel:int = 0;
        private var activatedTime:Number = 0;
        private var quickShot:Boolean;
        private var lock:Boolean = false;
        private var double:Boolean = false;
        private var defaultReloadMsec:int = 1;

        public function TerminatorModel()
        {
            _interfaces.push(IModel, ITerminatorModelBase, IWeaponController, IObjectLoadListener);
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
            var terminatorData:TerminatorData = new TerminatorData();
            terminatorData.chargingTime = chargingTimeMsec;
            terminatorData.weakeningCoeff = weakeningCoeff;
            clientObject.putParams(TerminatorModel, terminatorData);
            // this.battlefieldModel.blacklist.push(decalMaterial.getTextureResource());
            this.objectLoaded(clientObject);
        }
        public function startFire(clientObject:ClientObject, firingTankId:String, barrel:int):void
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
            this.shotBarrel = barrel;
            this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh, commonData.muzzles[barrel], this._globalMuzzlePosition, this._globalGunDirection);
            var terminatorSfxModel:IRailgunSFXModel = WeaponsManager.getTerminatorSFX(firingTankData.turret);
            var terminatorData:TerminatorData = this.getTerminatorData(firingTankData.turret);
            var graphicEffect:IGraphicEffect = terminatorSfxModel.createChargeEffect(firingTankData.turret, firingTankData.user, commonData.muzzles[barrel], firingTankData.tank.skin.turretMesh, terminatorData.chargingTime);
            if (this.battlefieldModel == null)
            {
                this.battlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            }
            if (this.firstshot)
            {
                this.firstshot = false;
                this.battlefieldModel.addGraphicEffect(graphicEffect);
                graphicEffect = terminatorSfxModel.createChargeEffect(firingTankData.turret, firingTankData.user, commonData.muzzles[barrel], firingTankData.tank.skin.turretMesh, terminatorData.chargingTime);
            }
            this.battlefieldModel.addGraphicEffect(graphicEffect);
            var soundEffect:ISound3DEffect = terminatorSfxModel.createSoundShotEffect(firingTankData.turret, firingTankData.user, this._globalMuzzlePosition);
            if (soundEffect != null)
            {
                this.battlefieldModel.addSound3DEffect(soundEffect);
            }
        }
        public function fire(clientObject:ClientObject, firingTankId:String, affectedPoints:Array, affectedTankIds:Array, doubleShot:Boolean):void
        {
            var firingTankData:TankData;
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
            var commonData:WeaponCommonData = this.commonModel.getCommonData(firingTankData.turret);
            var terminatorData:TerminatorData = this.getTerminatorData(firingTankData.turret);
            this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh, commonData.muzzles[this.shotBarrel], this._globalMuzzlePosition, this._globalGunDirection);
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
                            affectedTankData.tank.addWorldForceScaled(this._globalHitPosition, this._globalGunDirection, ((doubleShot) ? (impactForce / 1.5) : impactForce));
                            this.battlefieldModel.tankHit(affectedTankData, this._globalGunDirection, (impactForce / WeaponConst.BASE_IMPACT_FORCE));
                            impactForce = (impactForce * terminatorData.weakeningCoeff);
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
            firingTankData.tank.addWorldForceScaled(this._globalMuzzlePosition, this._globalGunDirection, ((doubleShot) ? (-(commonData.kickback) / 1.5) : -(commonData.kickback)));
            var terminatorSfxModel:IRailgunSFXModel = WeaponsManager.getTerminatorSFX(firingTankData.turret);
            var angle:Number = this._globalHitPosition.vClone().vRemove(this._globalMuzzlePosition).vNormalize().vCosAngle(this._globalGunDirection);
            if (angle < 0)
            {
                trace("Adding inversed ray");
                graphicEffect = terminatorSfxModel.createGraphicShotEffect(firingTankData.turret, this._globalMuzzlePosition, this._globalMuzzlePosition.vClone().vScale(2).vRemove(this._globalHitPosition));
            }
            else
            {
                graphicEffect = terminatorSfxModel.createGraphicShotEffect(firingTankData.turret, this._globalMuzzlePosition, this._globalHitPosition);
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
            this.defaultReloadMsec = this.localShotData.reloadMsec.value;
            this.localTerminatorData = this.getTerminatorData(localUserData.turret);
            this.localWeaponCommonData = this.commonModel.getCommonData(localUserData.turret);
            var ctfModel:ICTFModel;
            this.battlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            this.targetSystem.setParams(this.battlefieldModel.getBattlefieldData().physicsScene.collisionDetector, this.localShotData.autoAimingAngleUp.value, this.localShotData.numRaysUp.value, this.localShotData.autoAimingAngleDown.value, this.localShotData.numRaysDown.value, this.localTerminatorData.weakeningCoeff, ctfModel);
            this.reset();
            var muzzleLocalPos:Vector3 = this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel];
            var terminatorSfxModel:IRailgunSFXModel = WeaponsManager.getTerminatorSFX(this.localTankData.turret);
            var graphicEffect:IGraphicEffect = terminatorSfxModel.createChargeEffect(this.localTankData.turret, this.localTankData.user, muzzleLocalPos, this.localTankData.tank.skin.turretMesh, this.localTerminatorData.chargingTime);
            if (graphicEffect != null)
            {
                this.battlefieldModel.addGraphicEffect(graphicEffect);
            }
        }
        public function clearLocalUser():void
        {
            this.localTankData = null;
            this.localShotData = null;
            this.localTerminatorData = null;
            this.localWeaponCommonData = null;
        }
        public function update(time:int, deltaTime:int):Number
        {
            var muzzleLocalPos:Vector3;
            var terminatorSfxModel:IRailgunSFXModel;
            var graphicEffect:IGraphicEffect;
            var soundEffect:ISound3DEffect;
            var secondMuzzleLocalPos:Vector3;
            var secondGraphicEffect:IGraphicEffect;
            if (this.chargeTimeLeft.value > 0)
            {
                this.chargeTimeLeft.value = (this.chargeTimeLeft.value - deltaTime);
                if (this.chargeTimeLeft.value <= 0)
                {
                    this.chargeTimeLeft.value = 0;
                    if (this.double)
                    {
                        this.doFire(this.localWeaponCommonData, this.localTankData, time, true);
                        this.doFire(this.localWeaponCommonData, this.localTankData, time, true);
                        this.double = false;
                    }
                    else
                    {
                        this.doFire(this.localWeaponCommonData, this.localTankData, time, false);
                    }
                }
                return (this.chargeTimeLeft.value / this.localTerminatorData.chargingTime);
            }
            if (time < this.nextReadyTime.value)
            {
                return (1 - ((this.nextReadyTime.value - time) / this.localShotData.reloadMsec.value));
            }
            if ((((this._triggerPressed) && (TankData.localTankData.spawnState == TankSpawnState.ACTIVE)) && (time > this.nextReadyTime.value)))
            {
                this.activatedTime = (this.activatedTime + deltaTime);
            }
            else
            {
                if ((((TankData.localTankData.spawnState == TankSpawnState.ACTIVE) && (this.activatedTime > 0)) && (this.activatedTime < 1000)))
                {
                    this.quickShot = true;
                }
                this.activatedTime = 0;
            }
            if (this.activatedTime >= 1000)
            {
                if ((!(this.lock)))
                {
                    this.double = true;
                    this.chargeTimeLeft.value = this.localTerminatorData.chargingTime;
                    muzzleLocalPos = this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel];
                    this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh, muzzleLocalPos, this._globalMuzzlePosition, this._barrelOrigin, this._xAxis, this._globalGunDirection);
                    terminatorSfxModel = WeaponsManager.getTerminatorSFX(this.localTankData.turret);
                    graphicEffect = terminatorSfxModel.createChargeEffect(this.localTankData.turret, this.localTankData.user, muzzleLocalPos, this.localTankData.tank.skin.turretMesh, this.localTerminatorData.chargingTime);
                    if (graphicEffect != null)
                    {
                        this.battlefieldModel.addGraphicEffect(graphicEffect);
                    }
                    soundEffect = terminatorSfxModel.createSoundShotEffect(this.localTankData.turret, this.localTankData.user, this._globalMuzzlePosition);
                    if (soundEffect != null)
                    {
                        this.battlefieldModel.addSound3DEffect(soundEffect);
                    }
                    this.startFireCommand(this.localTankData.turret, this.localWeaponCommonData.currBarrel);
                    this.localWeaponCommonData.currBarrel = ((this.localWeaponCommonData.currBarrel + 1) % this.localWeaponCommonData.muzzles.length);
                    secondMuzzleLocalPos = this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel];
                    this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh, secondMuzzleLocalPos, this._globalMuzzlePosition, this._barrelOrigin, this._xAxis, this._globalGunDirection);
                    secondGraphicEffect = terminatorSfxModel.createChargeEffect(this.localTankData.turret, this.localTankData.user, secondMuzzleLocalPos, this.localTankData.tank.skin.turretMesh, this.localTerminatorData.chargingTime);
                    if (secondGraphicEffect != null)
                    {
                        this.battlefieldModel.addGraphicEffect(secondGraphicEffect);
                    }
                    this.startFireCommand(this.localTankData.turret, this.localWeaponCommonData.currBarrel);
                    this.localShotData.reloadMsec.value = (this.defaultReloadMsec * 1.75);
                    this.activatedTime = 0;
                }
            }
            else
            {
                if (this.quickShot)
                {
                    this.chargeTimeLeft.value = this.localTerminatorData.chargingTime;
                    muzzleLocalPos = this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel];
                    this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh, muzzleLocalPos, this._globalMuzzlePosition, this._barrelOrigin, this._xAxis, this._globalGunDirection);
                    terminatorSfxModel = WeaponsManager.getTerminatorSFX(this.localTankData.turret);
                    graphicEffect = terminatorSfxModel.createChargeEffect(this.localTankData.turret, this.localTankData.user, muzzleLocalPos, this.localTankData.tank.skin.turretMesh, this.localTerminatorData.chargingTime);
                    if (graphicEffect != null)
                    {
                        this.battlefieldModel.addGraphicEffect(graphicEffect);
                    }
                    soundEffect = terminatorSfxModel.createSoundShotEffect(this.localTankData.turret, this.localTankData.user, this._globalMuzzlePosition);
                    if (soundEffect != null)
                    {
                        this.battlefieldModel.addSound3DEffect(soundEffect);
                    }
                    this.startFireCommand(this.localTankData.turret, this.localWeaponCommonData.currBarrel);
                    if (this.localShotData.reloadMsec.value > this.defaultReloadMsec)
                    {
                        this.localShotData.reloadMsec.value = (this.localShotData.reloadMsec.value / 1.75);
                    }
                    this.quickShot = false;
                    this.activatedTime = 0;
                }
            }
            return (1);
        }
        private function startFireCommand(turr:ClientObject, currBarrel:int):void
        {
            var jsobject:Object = new Object();
            jsobject.currBarrel = currBarrel;
            Network(Main.osgi.getService(INetworker)).send(("battle;start_fire;" + JSON.stringify(jsobject)));
        }
        public function reset():void
        {
            this.activatedTime = 0;
            this.nextReadyTime.value = (this.chargeTimeLeft.value = 0);
            this._triggerPressed = false;
        }
        public function stopEffects(ownerTankData:TankData):void
        {
        }
        private function getTerminatorData(clientObject:ClientObject):TerminatorData
        {
            return (clientObject.getParams(TerminatorModel) as TerminatorData);
        }
        private function doFire(commonData:WeaponCommonData, tankData:TankData, time:int, _arg_4:Boolean):void
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
                this.fireCommand(tankData.turret, null, [this._hitPos3d], null, null, this.localWeaponCommonData.currBarrel, _arg_4);
                this.localWeaponCommonData.currBarrel = ((this.localWeaponCommonData.currBarrel + 1) % this.localWeaponCommonData.muzzles.length);
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
                    currTankData.tank.addWorldForceScaled(currHitPoint, this.shotResult.dir, ((_arg_4) ? (commonData.impactForce / 1.5) : commonData.impactForce));
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
                this.fireCommand(tankData.turret, this.targetIncarnations, this.shotResult.hitPoints, this.shotResult.targets, this.targetPositions, this.localWeaponCommonData.currBarrel, _arg_4);
                this.localWeaponCommonData.currBarrel = ((this.localWeaponCommonData.currBarrel + 1) % this.localWeaponCommonData.muzzles.length);
            }
            tankData.tank.addWorldForceScaled(this._globalMuzzlePosition, this._globalGunDirection, ((_arg_4) ? (-(commonData.kickback) / 1.5) : -(commonData.kickback)));
            var terminatorSfxModel:IRailgunSFXModel = WeaponsManager.getTerminatorSFX(tankData.turret);
            var angle:Number = this._globalHitPosition.vClone().vRemove(this._globalMuzzlePosition).vNormalize().vCosAngle(this._globalGunDirection);
            if (angle < 0)
            {
                graphicEffect = terminatorSfxModel.createGraphicShotEffect(tankData.turret, this._globalMuzzlePosition, this._globalMuzzlePosition.vClone().vScale(2).vRemove(this._globalHitPosition));
            }
            else
            {
                graphicEffect = terminatorSfxModel.createGraphicShotEffect(tankData.turret, this._globalMuzzlePosition, this._globalHitPosition);
            }
            if (graphicEffect != null)
            {
                this.battlefieldModel.addGraphicEffect(graphicEffect);
            }
        }
        public function fireCommand(turret:ClientObject, targetInc:Array, hitPoints:Array, targets:Array, targetPostitions:Array, currBarrel:int, _arg_7:Boolean):void
        {
            var firstHitPoints:Vector3d = (hitPoints[0] as Vector3d);
            var jsobject:Object = new Object();
            jsobject.hitPoints = hitPoints;
            jsobject.targetInc = targetInc;
            jsobject.targets = targets;
            jsobject.currBarrel = currBarrel;
            jsobject.double = _arg_7;
            jsobject.targetPostitions = targetPostitions;
            jsobject.reloadTime = this.localShotData.reloadMsec.value;
            Network(Main.osgi.getService(INetworker)).send(("battle;fire;" + JSON.stringify(jsobject)));
        }

    }
}
