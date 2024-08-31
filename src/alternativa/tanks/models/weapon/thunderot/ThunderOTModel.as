package alternativa.tanks.models.weapon.thunderot
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.thunder.ThunderModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.thunder.IThunderModelBase;
    import alternativa.tanks.models.weapon.IWeaponController;
    import alternativa.model.IObjectLoadListener;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.tanks.models.weapon.WeaponUtils;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.tank.TankModel;
    import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
    import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
    import alternativa.tanks.models.sfx.shoot.thunder.IThunderSFXModel;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.models.weapon.shared.shot.ShotData;
    import alternativa.tanks.models.weapon.common.WeaponCommonData;
    import com.reygazu.anticheat.variables.SecureInt;
    import alternativa.tanks.models.weapon.shared.CommonTargetSystem;
    import alternativa.tanks.models.weapon.common.HitInfo;
    import alternativa.math.Vector3;
    import alternativa.physics.collision.types.RayIntersection;
    import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
    import __AS3__.vec.Vector;
    import alternativa.tanks.models.weapon.shared.CommonTargetEvaluator;
    import alternativa.model.IModel;
    import alternativa.tanks.models.weapon.WeaponConst;
    import logic.tanks.WeaponsManager;
    import alternativa.object.ClientObject;
    import alternativa.register.ObjectRegister;
    import alternativa.tanks.vehicles.tanks.Tank;
    import alternativa.tanks.models.battlefield.BattlefieldData;
    import alternativa.physics.collision.ICollisionDetector;
    import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
    import logic.networking.Network;
    import alternativa.init.Main;
    import logic.networking.INetworker;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.tanks.sfx.EffectsPair;
    import alternativa.tanks.physics.CollisionGroup;
    import __AS3__.vec.*;

    public class ThunderOTModel extends ThunderModelBase implements IThunderModelBase, IWeaponController, IObjectLoadListener
    {

        private static const DECAL_RADIUS:Number = 250;
        private static const DECAL:Class = ThunderModel_DECAL;
        private static var decalMaterial:TextureMaterial;

        private var weaponUtils:WeaponUtils = WeaponUtils.getInstance();
        private var modelService:IModelService;
        private var battlefieldModel:IBattleField;
        private var tankInterface:TankModel;
        private var commonModel:IWeaponCommonModel;
        private var weakeningModel:IWeaponWeakeningModel;
        private var sfxModel:IThunderSFXModel;
        private var localTankData:TankData;
        private var localShotData:ShotData;
        private var localThunderData:ThunderData;
        private var localWeaponCommonData:WeaponCommonData;
        private var _triggerPressed:Boolean;
        private var nextReadyTime:SecureInt = new SecureInt("nextReadyTime.value thunder");
        private var targetSystem:CommonTargetSystem;
        private var hitInfo:HitInfo = new HitInfo();
        private var _hitPos:Vector3 = new Vector3();
        private var _hitPosLocal:Vector3 = new Vector3();
        private var _hitPosGlobal:Vector3 = new Vector3();
        private var _gunDirGlobal:Vector3 = new Vector3();
        private var _muzzlePosGlobal:Vector3 = new Vector3();
        private var _barrelOrigin:Vector3 = new Vector3();
        private var _xAxis:Vector3 = new Vector3();
        private var _vector:Vector3 = new Vector3();
        private var _rayOrigin:Vector3 = new Vector3();
        private var _rayInteresction:RayIntersection = new RayIntersection();
        private var _hitPos3d:Vector3d = new Vector3d(0, 0, 0);
        private var _targetPos3d:Vector3d = new Vector3d(0, 0, 0);
        private var _splashTargetIds:Array = [];
        private var _splashTargetIncarnations:Array = [];
        private var _splashTargetDistances:Array = [];
        private var _splashTargetPositions:Array = [];
        private var testPointsAux:Vector.<Vector3> = Vector.<Vector3>([new Vector3(), new Vector3(), new Vector3()]);
        private var testPoints:Vector.<Vector3> = Vector.<Vector3>([new Vector3(), new Vector3(), new Vector3()]);
        private var targetEvaluator:CommonTargetEvaluator;
        private var maxTargetingDistance:Number = 100000;

        public function ThunderOTModel()
        {
            _interfaces.push(IModel, IWeaponController, IObjectLoadListener);
            if (decalMaterial == null)
            {
                decalMaterial = new TextureMaterial(new DECAL().bitmapData);
            }
        }
        public function initObject(clientObject:ClientObject, impactForce:Number, maxSplashDamageRadius:Number, minSplashDamagePercent:Number, minSplashDamageRadius:Number):void
        {
            var data:ThunderData = new ThunderData(maxSplashDamageRadius, minSplashDamageRadius, minSplashDamagePercent, (impactForce * WeaponConst.BASE_IMPACT_FORCE));
            clientObject.putParams(ThunderOTModel, data);
            WeaponsManager.getThunderSFX(WeaponsManager.getObjectFor(clientObject.id));
            this.objectLoaded(clientObject);
        }
        public function fire(clientObject:ClientObject, shooterId:String, hitPoint:Vector3d, mainTargetId:String, weakeningCoeff:Number, splashTargetIds:Array, splashWeakeningCoeffs:Array):void
        {
            var shooterData:TankData;
            var mainTargetData:TankData;
            var len:int;
            var i:int;
            var targetData:TankData;
            var splashWeakeningCoeff:Number;
            var objectRegister:ObjectRegister = clientObject.register;
            shooterData = this.getTankData(shooterId, objectRegister);
            if ((((shooterData == null) || (shooterData.tank == null)) || (shooterData.tank.skin == null)))
            {
                return;
            }
            if (this.tankInterface.localUserData != null)
            {
                if (shooterData.userName == this.tankInterface.localUserData.userName)
                {
                    return;
                }
            }
            var commonData:WeaponCommonData = this.commonModel.getCommonData(shooterData.turret);
            var barrel:int;
            this.weaponUtils.calculateGunParamsAux(shooterData.tank.skin.turretMesh, commonData.muzzles[barrel], this._muzzlePosGlobal, this._gunDirGlobal);
            this.createShotEffects(shooterData, commonData.muzzles[barrel]);
            this._vector.vCopy(this._gunDirGlobal).vScale(-(commonData.kickback));
            shooterData.tank.addWorldForce(this._muzzlePosGlobal, this._vector);
            if (hitPoint == null)
            {
                return;
            }
            this._hitPos.x = hitPoint.x;
            this._hitPos.y = hitPoint.y;
            this._hitPos.z = hitPoint.z;
            var thunderData:ThunderData = this.getData(shooterData.turret);
            if (mainTargetId != null)
            {
                mainTargetData = this.getTankData(mainTargetId, objectRegister);
                if (((mainTargetData == null) || (mainTargetData.tank == null)))
                {
                    return;
                }
                mainTargetData.tank.baseMatrix.transformVector(this._hitPos, this._vector);
                this._hitPos.vSum(this._vector, mainTargetData.tank.state.pos);
                this.applyMainImpactForce(mainTargetData.tank, this._hitPos, this._gunDirGlobal, commonData.impactForce, thunderData.impactForce, weakeningCoeff);
                this.battlefieldModel.tankHit(mainTargetData, this._gunDirGlobal, (commonData.impactCoeff * weakeningCoeff));
            }
            else
            {
                this.battlefieldModel.addDecal(this._hitPos, this._barrelOrigin, DECAL_RADIUS, decalMaterial);
            }
            this.createExplosionEffects(shooterData, this._hitPos);
            var impactCoeff:Number = (thunderData.impactForce / WeaponConst.BASE_IMPACT_FORCE);
            if (splashTargetIds != null)
            {
                len = splashTargetIds.length;
                i = 0;
                while (i < len)
                {
                    targetData = this.getTankData(splashTargetIds[i], objectRegister);
                    if (!((targetData == null) || (targetData.tank == null)))
                    {
                        this._vector.vDiff(targetData.tank.state.pos, this._hitPos).vNormalize();
                        splashWeakeningCoeff = 1;
                        this.battlefieldModel.tankHit(targetData, this._vector, (splashWeakeningCoeff * impactCoeff));
                        this._vector.vScale((thunderData.impactForce * splashWeakeningCoeff));
                        targetData.tank.addForce(this._vector);
                    }
                    i++;
                }
            }
        }
        public function stopEffects(ownerTankData:TankData):void
        {
        }
        public function reset():void
        {
            this._triggerPressed = false;
            this.nextReadyTime.value = 0;
        }
        public function setLocalUser(localUserData:TankData):void
        {
            this.localTankData = localUserData;
            this.localShotData = WeaponsManager.shotDatas[localUserData.turret.id];
            this.localThunderData = ThunderData(localUserData.turret.getParams(ThunderOTModel));
            this.localWeaponCommonData = this.commonModel.getCommonData(localUserData.turret);
            this.targetEvaluator = CommonTargetEvaluator.create(this.localTankData, this.localShotData, this.battlefieldModel, this.weakeningModel, this.modelService);
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
        public function activateWeapon(time:int):void
        {
            this._triggerPressed = true;
        }
        public function deactivateWeapon(time:int, sendServerCommand:Boolean):void
        {
            this._triggerPressed = false;
        }
        public function update(time:int, deltaTime:int):Number
        {
            var distance:Number;
            var directImpactCoeff:Number;
            var hitX:Number;
            var hitY:Number;
            var hitZ:Number;
            var mainTarget:TankData;
            var numSplashTargets:int;
            var splashRadiusSqr:Number;
            var key:*;
            var hitPos3d:Vector3d;
            var mainTargetId:String;
            var mainTargetIncarnation:int;
            var mainTargetPosition:Vector3d;
            var splashTargetIds:Array;
            var splashTargetIncarnations:Array;
            var splashTargetDistances:Array;
            var splashTargetPositions:Array;
            var td:TankData;
            var tank:Tank;
            var targetPos:Vector3;
            var dx:Number;
            var dy:Number;
            var dz:Number;
            var d:Number;
            var targetPos3d:Vector3d;
            var v:Vector3;
            if (((!(this._triggerPressed)) || (time < this.nextReadyTime.value)))
            {
                if (time < this.nextReadyTime.value)
                {
                    return (1 + ((time - this.nextReadyTime.value) / this.localShotData.reloadMsec.value));
                }
                return (1);
            }
            this.nextReadyTime.value = (time + this.localShotData.reloadMsec.value);
            this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh, this.localWeaponCommonData.muzzles[0], this._muzzlePosGlobal, this._barrelOrigin, this._xAxis, this._gunDirGlobal);
            this._vector.vCopy(this._gunDirGlobal).vScale(-(this.localWeaponCommonData.kickback));
            this.localTankData.tank.addWorldForce(this._muzzlePosGlobal, this._vector);
            this.createShotEffects(this.localTankData, this.localWeaponCommonData.muzzles[0]);
            var bfData:BattlefieldData = this.battlefieldModel.getBattlefieldData();
            var collisionDetector:ICollisionDetector = bfData.collisionDetector;
            if (this.targetSystem.getTarget(this._barrelOrigin, this._gunDirGlobal, this._xAxis, this.localTankData.tank, this.hitInfo))
            {
                distance = (this.hitInfo.distance * 0.01);
                directImpactCoeff = this.weakeningModel.getImpactCoeff(this.localTankData.turret, distance);
                hitX = this.hitInfo.position.x;
                hitY = this.hitInfo.position.y;
                hitZ = this.hitInfo.position.z;
                splashRadiusSqr = ((10000 * this.localThunderData.minSplashDamageRadius) * this.localThunderData.minSplashDamageRadius);
                for (key in bfData.activeTanks)
                {
                    td = key;
                    tank = td.tank;
                    if (td.spawnState == TankSpawnState.NEWCOME)
                    {
                    }
                    else
                    {
                        if (tank == this.hitInfo.body)
                        {
                            mainTarget = td;
                        }
                        else
                        {
                            targetPos = tank.state.pos;
                            dx = (targetPos.x - hitX);
                            dy = (targetPos.y - hitY);
                            dz = (targetPos.z - hitZ);
                            d = (((dx * dx) + (dy * dy)) + (dz * dz));
                            if (d <= splashRadiusSqr)
                            {
                                if (this.testForSplashHit(tank, this.hitInfo, collisionDetector))
                                {
                                    d = (Math.sqrt(d) * 0.01);
                                    this._splashTargetIds[numSplashTargets] = td.user.id;
                                    this._splashTargetIncarnations[numSplashTargets] = td.incarnation;
                                    this._splashTargetDistances[numSplashTargets] = d;
                                    targetPos3d = this._splashTargetPositions[numSplashTargets];
                                    if (targetPos3d == null)
                                    {
                                        targetPos3d = new Vector3d(0, 0, 0);
                                        this._splashTargetPositions[numSplashTargets] = targetPos3d;
                                    }
                                    targetPos3d.x = targetPos.x;
                                    targetPos3d.y = targetPos.y;
                                    targetPos3d.z = targetPos.z;
                                    numSplashTargets++;
                                    this._vector.vNormalize();
                                    this._vector.vScale(((this.localThunderData.impactForce * directImpactCoeff) * this.getSplashImpactCoeff(d)));
                                    tank.addForce(this._vector);
                                }
                            }
                        }
                    }
                }
                hitPos3d = this._hitPos3d;
                if (mainTarget != null)
                {
                    mainTargetId = mainTarget.user.id;
                    mainTargetIncarnation = mainTarget.incarnation;
                    mainTargetPosition = this._targetPos3d;
                    v = mainTarget.tank.state.pos;
                    mainTargetPosition.x = v.x;
                    mainTargetPosition.y = v.y;
                    mainTargetPosition.z = v.z;
                    this.applyMainImpactForce(mainTarget.tank, this.hitInfo.position, this._gunDirGlobal, this.localWeaponCommonData.impactForce, this.localThunderData.impactForce, directImpactCoeff);
                    this._hitPosGlobal.vDiff(this.hitInfo.position, v);
                    mainTarget.tank.baseMatrix.transformVectorInverse(this._hitPosGlobal, this._hitPosLocal);
                    hitPos3d.x = this._hitPosLocal.x;
                    hitPos3d.y = this._hitPosLocal.y;
                    hitPos3d.z = this._hitPosLocal.z;
                }
                else
                {
                    hitPos3d.x = hitX;
                    hitPos3d.y = hitY;
                    hitPos3d.z = hitZ;
                }
                if (numSplashTargets > 0)
                {
                    splashTargetIds = this._splashTargetIds;
                    splashTargetIds.length = numSplashTargets;
                    splashTargetIncarnations = this._splashTargetIncarnations;
                    splashTargetIncarnations.length = numSplashTargets;
                    splashTargetDistances = this._splashTargetDistances;
                    splashTargetDistances.length = numSplashTargets;
                    splashTargetPositions = this._splashTargetPositions;
                    splashTargetPositions.length = numSplashTargets;
                }
                this.fireCommand(this.localTankData.turret, hitPos3d, mainTargetId, mainTargetIncarnation, mainTargetPosition, distance, splashTargetIds, splashTargetIncarnations, splashTargetDistances, splashTargetPositions);
                this.createExplosionEffects(this.localTankData, this.hitInfo.position);
                if (mainTarget == null)
                {
                    this.battlefieldModel.addDecal(this.hitInfo.position, this._barrelOrigin, DECAL_RADIUS, decalMaterial);
                }
            }
            else
            {
                this.fireCommand(this.localTankData.turret, null, null, 0, null, 0, null, null, null, null);
            }
            return (0);
        }
        private function fireCommand(turr:ClientObject, hitPos:Vector3d, mainTargetId:String, mainTargetIncarnation:int, mainTargetPosition:Vector3d, distance:int, splashTargetIds:Array, splashTargetIncarnations:Array, splashTargetDistances:Array, splashTargetPositions:Array):void
        {
            var js:Object = new Object();
            js.hitPos = hitPos;
            js.mainTargetId = mainTargetId;
            js.mainTargetPosition = mainTargetPosition;
            js.distance = distance;
            js.splashTargetIds = splashTargetIds;
            js.splashTargetDistances = splashTargetDistances;
            js.reloadTime = this.localShotData.reloadMsec.value;
            Network(Main.osgi.getService(INetworker)).send(("battle;fire;" + JSON.stringify(js)));
        }
        public function objectLoaded(object:ClientObject):void
        {
            if (this.commonModel == null)
            {
                this.modelService = IModelService(Main.osgi.getService(IModelService));
                this.battlefieldModel = IBattleField(this.modelService.getModelsByInterface(IBattleField)[0]);
                this.tankInterface = (Main.osgi.getService(ITank) as TankModel);
                this.commonModel = IWeaponCommonModel(this.modelService.getModelsByInterface(IWeaponCommonModel)[0]);
                this.weakeningModel = IWeaponWeakeningModel(this.modelService.getModelsByInterface(IWeaponWeakeningModel)[0]);
                this.sfxModel = WeaponsManager.getThunderSFX(WeaponsManager.getObjectFor(object.id));
            }
            this.nextReadyTime.value = 0;
        }
        public function objectUnloaded(object:ClientObject):void
        {
        }
        private function getSplashImpactCoeff(distance:Number):Number
        {
            if (distance < this.localThunderData.maxSplashDamageRadius)
            {
                return (1);
            }
            return (0.01 * (this.localThunderData.minSplashDamagePercent + (((this.localThunderData.minSplashDamageRadius - distance) * (100 - this.localThunderData.minSplashDamagePercent)) / (this.localThunderData.minSplashDamageRadius - this.localThunderData.maxSplashDamageRadius))));
        }
        private function getTankData(objectId:String, objectRegister:ObjectRegister):TankData
        {
            var object:ClientObject = BattleController.activeTanks[objectId];
            if (object == null)
            {
                return (null);
            }
            return (this.tankInterface.getTankData(object));
        }
        private function createShotEffects(tankData:TankData, muzzlePosLocal:Vector3):void
        {
            var effects:EffectsPair = this.sfxModel.createShotEffects(WeaponsManager.getObjectFor(tankData.turret.id), muzzlePosLocal, tankData.tank.skin.turretMesh);
            this.battlefieldModel.addGraphicEffect(effects.graphicEffect);
            this.battlefieldModel.addSound3DEffect(effects.soundEffect);
        }
        private function createExplosionEffects(tankData:TankData, position:Vector3):void
        {
            var effects:EffectsPair = this.sfxModel.createExplosionEffects(tankData.turret, position);
            this.battlefieldModel.addGraphicEffect(effects.graphicEffect);
            this.battlefieldModel.addSound3DEffect(effects.soundEffect);
        }
        private function testForSplashHit(tank:Tank, hitInfo:HitInfo, collisionDetector:ICollisionDetector):Boolean
        {
            var v:Vector3;
            var offset:Number = (0.75 * tank.mainCollisionBox.hs.y);
            Vector3(this.testPointsAux[0]).y = -(offset);
            Vector3(this.testPointsAux[2]).y = offset;
            this._rayOrigin.vCopy(hitInfo.position).vAdd(hitInfo.normal);
            var pos:Vector3 = tank.state.pos;
            var i:int;
            while (i < 3)
            {
                v = this.testPoints[i];
                tank.baseMatrix.transformVector(this.testPointsAux[i], v);
                v.vAdd(pos);
                this._vector.vDiff(v, hitInfo.position);
                if ((!(collisionDetector.intersectRayWithStatic(this._rayOrigin, this._vector, CollisionGroup.STATIC, 1, null, this._rayInteresction))))
                {
                    return (true);
                }
                i++;
            }
            return (false);
        }
        private function getData(clientObject:ClientObject):ThunderData
        {
            return (ThunderData(clientObject.getParams(ThunderOTModel)));
        }
        private function applyMainImpactForce(target:Tank, globalPos:Vector3, gunDir:Vector3, commonImpact:Number, thunderImpact:Number, weakeningCoeff:Number):void
        {
            this._vector.vCopy(gunDir).vScale((commonImpact * weakeningCoeff));
            target.addWorldForce(globalPos, this._vector);
            this._vector.vDiff(target.state.pos, globalPos).vNormalize().vScale((thunderImpact * weakeningCoeff));
            target.addForce(this._vector);
        }

    }
}
