// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.shaft.ShaftModel

package alternativa.tanks.models.weapon.shaft
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.gun.IGunModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.tanks.models.weapon.IWeaponController;
    import alternativa.math.Vector3;
    import alternativa.math.Matrix4;
    import alternativa.tanks.models.weapon.AllGlobalGunParams;
    import alternativa.engine3d.materials.TextureMaterial;
    import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
    import alternativa.tanks.models.weapon.WeaponUtils;
    import alternativa.tanks.vehicles.tanks.Tank;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.models.weapon.shared.shot.ShotData;
    import alternativa.tanks.models.weapon.common.WeaponCommonData;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.tanks.models.tank.TankModel;
    import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
    import alternativa.tanks.physics.TanksCollisionDetector;
    import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
    import flash.display.Bitmap;
    import alternativa.tanks.models.weapon.shaft.modes.TargetingController;
    import flash.utils.Dictionary;
    import alternativa.physics.collision.types.RayIntersection;
    import alternativa.tanks.models.weapon.shaft.quickshot.ShaftTargetSystem;
    import alternativa.tanks.models.weapon.shaft.quickshot.ShaftShotResult;
    import alternativa.physics.Body;
    import __AS3__.vec.Vector;
    import alternativa.tanks.models.weapon.WeaponConst;
    import alternativa.object.ClientObject;
    import alternativa.init.Main;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.tank.ITank;
    import flash.display.BitmapData;
    import alternativa.tanks.camera.GameCamera;
    import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
    import flash.utils.getTimer;
    import alternativa.tanks.models.weapon.shaft.states.ShaftModes;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import logic.tanks.WeaponsManager;
    import alternativa.tanks.models.weapon.shaft.sfx.ShaftSFXModel;
    import logic.server.models.shaft.ServerShaftTargetData;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.RayIntersectionData;
    import alternativa.tanks.models.battlefield.Object3DNames;
    import alternativa.tanks.vehicles.tanks.TankSkin;
    import alternativa.tanks.physics.CollisionGroup;
    import alternativa.tanks.utils.MathUtils;
    import by.blooddy.crypto.serialization.JSONer;

    public class ShaftModel implements IGunModelBase, IObjectLoadListener, IWeaponController
    {

        private static var _barrelOrigin:Vector3 = new Vector3();
        private static const _origin:Vector3 = new Vector3();
        private static const _direction:Vector3 = new Vector3();
        private static const _m:Matrix4 = new Matrix4();
        private static const _p:Vector3 = new Vector3();
        private static const _closestBarrelOrigin:Vector3 = new Vector3();
        private static const thousand:int = 1000;
        private static const allGunParams:AllGlobalGunParams = new AllGlobalGunParams();
        private static const decal:Class = ShaftModel_decal;
        private static var decalMaterial:TextureMaterial = new TextureMaterial(new decal().bitmapData);

        private var _hitPos:Vector3 = new Vector3();
        private var _hitPosLocal:Vector3 = new Vector3();
        private var _hitPosGlobal:Vector3 = new Vector3();
        private var _gunDirGlobal:Vector3 = new Vector3();
        private var _muzzlePosGlobal:Vector3 = new Vector3();
        private var _xAxis:Vector3 = new Vector3();
        private var _hitPos3d:Vector3d = new Vector3d(0, 0, 0);
        private var _tankPos3d:Vector3d = new Vector3d(0, 0, 0);
        private var weaponUtils:WeaponUtils = WeaponUtils.getInstance();
        private var tank:Tank;
        private var localTankData:TankData;
        private var localShotData:ShotData;
        private var localWeaponCommonData:WeaponCommonData;
        private var modelService:IModelService;
        private var battlefieldModel:BattlefieldModel;
        private var tankModel:TankModel;
        private var weaponWeakeningModel:IWeaponWeakeningModel;
        private var collisionDetector:TanksCollisionDetector;
        private var weaponCommonModel:IWeaponCommonModel;
        private var maxTargetingDistance:Number = 100000;
        private var pressed:Boolean = false;
        private var image:Bitmap;
        private var activate:Boolean = false;
        private var activatedTime:Number = 0;
        private var indicator:Indicator;
        private var targetController:TargetingController;
        private var updateController:Boolean = false;
        private var lock:Boolean = false;
        private var indicatorBitmap:Bitmap;
        private var lockCheckIntersection:Boolean;
        private var energyAdditive:Number = 1000;
        private var energySpeed:Number = -250;
        private var energyBaseTime:int;
        private var exitTime:int;
        private var fired:Boolean;
        private var energyMode:ShaftEnergyMode = ShaftEnergyMode.RECHARGE;
        public var shaftData:ShaftData = new ShaftData();
        private var exclusionSet:Dictionary;
        private var exclusionSetController:SetControllerForTemporaryItems;
        private var multybodyPredicate:MultybodyCollisionPredicate = new MultybodyCollisionPredicate();
        private var intersection:RayIntersection = new RayIntersection();
        private var quickShotTargetSystem:ShaftTargetSystem = new ShaftTargetSystem();
        private var shotResult:ShaftShotResult = new ShaftShotResult();
        private var commonModel:IWeaponCommonModel;
        private var quickShot:Boolean;
        private var tempRayResult:RayIntersection = new RayIntersection();

        public static function globalToLocal(param1:Body, param2:Vector3):void
        {
            param2.vSubtract(param1.state.pos);
            param2.vTransformBy3Tr(param1.baseMatrix);
        }

        public static function localToGlobal(param1:Body, param2:Vector3):void
        {
            param2.vTransformBy3(param1.baseMatrix);
            param2.vAdd(param1.state.pos);
        }

        private static function getShotDirection(param1:Vector3, param2:Vector3, param3:Vector3):Vector3
        {
            if (param2 != null)
            {
                return (new Vector3().vDiff(param2, param1).vNormalize());
            }
            if (param3 == null)
            {
                param3 = allGunParams.direction;
            }
            return (new Vector3().vDiff(param3, param1).vNormalize());
        }

        private static function getClosestBarrelOrigin(param1:Vector3, param2:Vector.<Vector3>, param3:Vector3):void
        {
            var _loc6_:Number = NaN;
            _barrelOrigin.vCopy(param2[0]);
            _barrelOrigin.y = 0;
            param3.vCopy(_barrelOrigin);
            var _loc4_:Number = param1.distanceToSquared(_barrelOrigin);
            var _loc5_:int = 1;
            while (_loc5_ < param2.length)
            {
                _barrelOrigin.vCopy(param2[_loc5_]);
                _barrelOrigin.y = 0;
                _loc6_ = param1.distanceToSquared(_barrelOrigin);
                if (_loc6_ < _loc4_)
                {
                    _loc4_ = _loc6_;
                    param3.vCopy(_barrelOrigin);
                }
                _loc5_++;
            }
        }

        public function initObject(clientObject:ClientObject, maxEnegry:Number, chargeRate:Number, dischargeRate:Number, elevationAngleUp:Number, elevationAngleDown:Number, verticalTargetingSpeed:Number, horizontalTargetingSpeed:Number, initialFOV:Number, minimumFOV:Number, shrubsHidingRadiusMin:Number, shrubsHidingRadiusMax:Number, impactQuickShot:Number):void
        {
            var shaftData:ShaftData = new ShaftData();
            shaftData.maxEnergy = maxEnegry;
            shaftData.chargeRate = chargeRate;
            shaftData.dischargeRate = dischargeRate;
            shaftData.elevationAngleUp = elevationAngleUp;
            shaftData.elevationAngleDown = elevationAngleDown;
            shaftData.verticalTargetingSpeed = verticalTargetingSpeed;
            shaftData.horizontalTargetingSpeed = horizontalTargetingSpeed;
            shaftData.initialFOV = initialFOV;
            shaftData.minimumFOV = minimumFOV;
            shaftData.shrubsHidingRadiusMin = shrubsHidingRadiusMin;
            shaftData.shrubsHidingRadiusMax = shrubsHidingRadiusMax;
            shaftData.impactQuickShot = (impactQuickShot * WeaponConst.BASE_IMPACT_FORCE);
            clientObject.putParams(ShaftData, shaftData);
            this.objectLoaded(null);
        }

        public function objectLoaded(object:ClientObject):void
        {
            if (this.modelService == null)
            {
                this.modelService = IModelService(Main.osgi.getService(IModelService));
                this.battlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
                this.tankModel = (Main.osgi.getService(ITank) as TankModel);
                this.weaponCommonModel = (Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel);
                this.weaponWeakeningModel = IWeaponWeakeningModel(this.modelService.getModelsByInterface(IWeaponWeakeningModel)[0]);
                this.commonModel = (Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel);
                (this.battlefieldModel as BattlefieldModel).blacklist.push(decalMaterial.texture);
                this.exclusionSet = this.battlefieldModel.bfData.viewport.shaftRaycastExcludedObjects;
                this.exclusionSetController = new SetControllerForTemporaryItems(this.exclusionSet);
                this.collisionDetector = TanksCollisionDetector(this.battlefieldModel.bfData.physicsScene.collisionDetector);
            }
        }

        public function setEnergyMode(mode:ShaftEnergyMode):void
        {
            var physTime:int;
            var energy:Number = NaN;
            if (((this.battlefieldModel == null) || (this.battlefieldModel.bfData == null)))
            {
                return;
            }
            if (mode != this.energyMode)
            {
                physTime = this.battlefieldModel.bfData.physTime;
                energy = this.getEnergy(physTime);
                this.doSetEnergyMode(mode, energy, physTime);
            }
        }

        public function objectUnloaded(object:ClientObject):void
        {
        }

        private function startTargetMode():void
        {
        }

        private function stopTargetMode():void
        {
        }

        public function update(time:int, deltaTime:int):Number
        {
            var currentEnergy:int;
            var barrelOrg:Vector3;
            var commonData:WeaponCommonData;
            var tank:Tank;
            var indicatorBitmap_:BitmapData;
            var camera:GameCamera;
            if (this.tank == null)
            {
                this.tank = TankData.localTankData.tank;
            }
            if (((this.activate) && (TankData.localTankData.spawnState == TankSpawnState.ACTIVE)))
            {
                this.activatedTime = (this.activatedTime + deltaTime);
            }
            else
            {
                if ((((TankData.localTankData.spawnState == TankSpawnState.ACTIVE) && (this.activatedTime > 0)) && (this.activatedTime < 300)))
                {
                    this.quickShot = true;
                }
                this.activatedTime = 0;
            }
            if (this.activatedTime >= 300)
            {
                currentEnergy = this.getEnergy(time);
                if (((((!(this.lock)) && (currentEnergy == 1000)) && (time >= this.exitTime)) && ((!((this.tank.leftTrack.lastContactsNum == 0) && (this.tank.rightTrack.lastContactsNum == 0))))))
                {
                    this.updateController = true;
                    this.updateCrossPosition();
                    Main.stage.addChild(this.image);
                    this.targetController.camera = this.battlefieldModel.bfData.viewport.camera;
                    this.targetController.skin = TankData.localTankData.tank.skin;
                    this.targetController.cameraController.setAnchorObject(TankData.localTankData.tank.skin.turretMesh);
                    barrelOrg = new Vector3();
                    commonData = this.commonModel.getCommonData(TankData.localTankData.turret);
                    TankData.localTankData.tank.getBarrelOrigin(barrelOrg, commonData.muzzles);
                    this.targetController.cameraController.setLocalPosition(barrelOrg);
                    this.targetController.cameraController.elevation = 0;
                    this.targetController.cameraController.elevationDirection = 0;
                    this.targetController.enter(time);
                    tank = TankData.localTankData.tank;
                    tank.title.hide();
                    indicatorBitmap_ = tank.title.getTexture();
                    this.indicatorBitmap = new Bitmap(indicatorBitmap_);
                    camera = this.battlefieldModel.bfData.viewport.camera;
                    this.indicatorBitmap.x = ((Main.stage.stageWidth - this.indicatorBitmap.width) >> 1);
                    this.indicatorBitmap.y = ((Main.stage.stageHeight / 2) + (this.indicatorBitmap.height * 2));
                    Main.stage.addChild(this.indicatorBitmap);
                    this.lock = true;
                    this.fired = false;
                    this.lockCheckIntersection = true;
                    this.exitTime = -1;
                    this.sendStartAimCommand();
                }
            }
            else
            {
                if (this.quickShot)
                {
                    currentEnergy = this.getEnergy(time);
                    if (currentEnergy == 1000)
                    {
                        this.onQuickShot();
                    }
                    this.quickShot = false;
                }
                else
                {
                    if (this.fired)
                    {
                        this.activatedTime = 0;
                        if (this.exitTime > 0)
                        {
                            if (time >= this.exitTime)
                            {
                                if (Main.stage.contains(this.image))
                                {
                                    Main.stage.removeChild(this.image);
                                    Main.stage.removeChild(this.indicatorBitmap);
                                    tank = TankData.localTankData.tank;
                                    tank.title.show();
                                    this.battlefieldModel.activateFollowCamera();
                                    this.battlefieldModel.resetFollowCamera();
                                    this.targetController.resetCameraAngle();
                                    this.targetController.exit();
                                    this.updateController = false;
                                    this.lock = false;
                                    this.lockCheckIntersection = false;
                                    this.fired = false;
                                }
                            }
                        }
                    }
                    else
                    {
                        if (Main.stage.contains(this.image))
                        {
                            this.setEnergyMode(ShaftEnergyMode.RECHARGE);
                            this.performAimedShot(1000);
                            this.exitTime = (getTimer() + 500);
                            this.fired = true;
                        }
                    }
                }
            }
            if (this.updateController)
            {
                this.updateCrossPosition();
                this.indicatorBitmap.x = ((Main.stage.stageWidth - this.indicatorBitmap.width) >> 1);
                this.indicatorBitmap.y = ((Main.stage.stageHeight / 2) + (this.indicatorBitmap.height * 2));
                this.targetController.update(time, deltaTime);
            }
            return (this.getStatus());
        }

        private function sendQuickShotCommand(result:ShaftShotResult):void
        {
            Network(Main.osgi.getService(INetworker)).send(("battle;quick_shot_shaft;" + result.toJSON()));
        }

        private function sendStartAimCommand():void
        {
            Network(Main.osgi.getService(INetworker)).send("battle;start_fire");
        }

        private function onQuickShot():void
        {
            var i:int;
            var target:TankData;
            var currTank:Tank;
            var tankData:TankData = TankData.localTankData;
            var commonData:WeaponCommonData = this.commonModel.getCommonData(tankData.turret);
            var shaftSFX:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(TankData.localTankData.turret.id), TankData.localTankData.user);
            this.weaponUtils.calculateGunParams(tankData.tank.skin.turretMesh, commonData.muzzles[0], allGunParams.muzzlePosition, _barrelOrigin, this._xAxis, allGunParams.direction);
            this.quickShotTargetSystem.getTargets(tankData, _barrelOrigin, allGunParams.direction, this._xAxis, this.battlefieldModel.getBattlefieldData().tanks, this.shotResult);
            if (this.shotResult.hitPoints.length == 0)
            {
                trace("shot v nikuda");
            }
            else
            {
                if (this.shotResult.targets.length == 0)
                {
                    trace("shot on static");
                    this.createStaticShotEffect(tankData.user, (this.shotResult.hitPoints[0] as Vector3), allGunParams.direction);
                    this.battlefieldModel.addDecal((this.shotResult.hitPoints[0] as Vector3), allGunParams.muzzlePosition, 50, decalMaterial);
                }
                else
                {
                    i = 0;
                    while (i < this.shotResult.targets.length)
                    {
                        target = this.shotResult.targets[i];
                        trace(("quick shot: " + target.userName));
                        currTank = target.tank;
                        this.createTankShotEffect(tankData.user, this.shotResult.hitPoints[i], allGunParams.direction);
                        currTank.addWorldForceScaled(this.shotResult.hitPoints[i], allGunParams.direction, this.shaftData.impactQuickShot);
                        i++;
                    }
                    if (this.shotResult.hitPoints.length > this.shotResult.targets.length)
                    {
                        trace("shot on static");
                        this.createStaticShotEffect(tankData.user, (this.shotResult.hitPoints[this.shotResult.targets.length] as Vector3), allGunParams.direction);
                        this.battlefieldModel.addDecal((this.shotResult.hitPoints[this.shotResult.targets.length] as Vector3), allGunParams.muzzlePosition, 50, decalMaterial);
                    }
                }
            }
            trace(this.shotResult.toJSON());
            shaftSFX.createMuzzleFlashEffect(tankData.turret, tankData.tank.skin.turretDescriptor.shaftMuzzle, tankData.tank.skin.turretMesh);
            shaftSFX.createShotSoundEffect(tankData.turret, tankData.user, allGunParams.muzzlePosition);
            TankData.localTankData.tank.addWorldForceScaled(allGunParams.muzzlePosition, allGunParams.direction, -(commonData.kickback));
            this.doSetEnergyMode(ShaftEnergyMode.RECHARGE, 0, this.battlefieldModel.bfData.physTime);
            this.sendQuickShotCommand(this.shotResult);
        }

        [ServerData]
        public function quickFire(user:ClientObject, targets:Array, hitPoints:Array, direction:Vector3):void
        {
            var hit:Vector3;
            var i:int;
            var globalHit:Vector3;
            var targetTank:TankData;
            var currTank:Tank;
            var firringTank:TankData = this.tankModel.getTankData(user);
            if (firringTank == TankData.localTankData)
            {
                return;
            }
            if (this.commonModel == null)
            {
                this.commonModel = (Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel);
            }
            var commonData:WeaponCommonData = this.commonModel.getCommonData(firringTank.turret);
            var tankShaftData:ShaftData = (firringTank.turret.getParams(ShaftData) as ShaftData);
            this.weaponUtils.calculateGunParamsAux(firringTank.tank.skin.turretMesh, commonData.muzzles[0], allGunParams.muzzlePosition, allGunParams.direction);
            var effects:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(firringTank.turret.id), user);
            effects.createMuzzleFlashEffect(firringTank.turret, firringTank.tank.skin.turretDescriptor.shaftMuzzle, firringTank.tank.skin.turretMesh);
            firringTank.tank.addWorldForceScaled(allGunParams.muzzlePosition, allGunParams.direction, -(commonData.kickback));
            if (hitPoints.length == 0)
            {
                return;
            }
            if (targets.length == 0)
            {
                hit = new Vector3(hitPoints[0].x, hitPoints[0].y, hitPoints[0].z);
                this.createStaticShotEffect(firringTank.user, hit, allGunParams.direction);
                this.battlefieldModel.addDecal(hit, allGunParams.muzzlePosition, 50, decalMaterial);
            }
            else
            {
                i = 0;
                while (i < targets.length)
                {
                    globalHit = new Vector3(hitPoints[i].x, hitPoints[i].y, hitPoints[i].z);
                    targetTank = this.tankModel.getTankData(BattleController.activeTanks[targets[i].target_id]);
                    currTank = targetTank.tank;
                    this.createTankShotEffect(firringTank.user, globalHit, allGunParams.direction);
                    currTank.addWorldForceScaled(globalHit, allGunParams.direction, tankShaftData.impactQuickShot);
                    i++;
                }
                if (hitPoints.length > targets.length)
                {
                    hit = new Vector3(hitPoints[targets.length].x, hitPoints[targets.length].y, hitPoints[targets.length].z);
                    this.createStaticShotEffect(firringTank.user, hit, allGunParams.direction);
                    this.battlefieldModel.addDecal(hit, allGunParams.muzzlePosition, 50, decalMaterial);
                }
            }
        }

        [ServerData]
        public function fire(user:ClientObject, staticHit:Vector3, targets:Array):void
        {
            var target:ServerShaftTargetData;
            var targetTankPos:Vector3;
            var targetTank:TankData;
            var i:int;
            var firringTank:TankData = this.tankModel.getTankData(user);
            if (firringTank == TankData.localTankData)
            {
                return;
            }
            if (this.commonModel == null)
            {
                this.commonModel = (Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel);
            }
            var commonData:WeaponCommonData = this.commonModel.getCommonData(firringTank.turret);
            this.weaponUtils.calculateGunParamsAux(firringTank.tank.skin.turretMesh, commonData.muzzles[0], allGunParams.muzzlePosition, allGunParams.direction);
            var effects:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(firringTank.turret.id), user);
            effects.createMuzzleFlashEffect(firringTank.turret, firringTank.tank.skin.turretDescriptor.shaftMuzzle, firringTank.tank.skin.turretMesh);
            while (i < targets.length)
            {
                target = targets[i];
                targetTank = this.tankModel.getTankData(BattleController.activeTanks[target.targetId]);
                if (targetTank != null)
                {
                    targetTankPos = targetTank.tank.state.pos;
                }
                localToGlobal(targetTank.tank, target.globalHitPoint);
                this.createTankShotEffect(firringTank.user, target.hitPoint, allGunParams.direction);
                targetTank.tank.addWorldForceScaled(target.hitPoint, allGunParams.direction, commonData.impactForce);
                i++;
            }
            if (staticHit != null)
            {
                this.createStaticShotEffect(firringTank.user, staticHit, allGunParams.direction);
                this.battlefieldModel.addDecal(staticHit, allGunParams.muzzlePosition, 50, decalMaterial);
            }
            effects.createShotSoundEffect(firringTank.turret, firringTank.user, allGunParams.muzzlePosition);
        }

        public function performAimedShot(param1:Number):void
        {
            var i:int;
            var target:TankData;
            var currTank:Tank;
            var tankData:TankData = TankData.localTankData;
            var commonData:WeaponCommonData = this.commonModel.getCommonData(tankData.turret);
            var shaftSFX:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(TankData.localTankData.turret.id), TankData.localTankData.user);

            var data:RayIntersectionData;
            var aim:Object3D;
            var hitPoint:Vector3;
            var result:AimedShotResult = new AimedShotResult();
            this.targetController.cameraController.readCameraPosition(_origin);
            this.targetController.cameraController.readCameraDirection(_direction);
            this.addTankSkinToExclusionSet(this.localTankData.tank.skin);
            var tempDir:Vector3 = new Vector3();
            var tempOrig:Vector3 = new Vector3();

            this.weaponUtils.calculateGunParams(tankData.tank.skin.turretMesh, commonData.muzzles[0], allGunParams.muzzlePosition, tempOrig, this._xAxis, tempDir);
            this.quickShotTargetSystem.getAimTargets(tankData, _origin, _direction, this._xAxis, this.battlefieldModel.getBattlefieldData().tanks, this.shotResult);
            if (this.shotResult.hitPoints.length != 0)
            {
                if (this.shotResult.targets.length == 0)
                {
                    this.createStaticShotEffect(tankData.user, (this.shotResult.hitPoints[0] as Vector3), _direction);
                    this.battlefieldModel.addDecal((this.shotResult.hitPoints[0] as Vector3), allGunParams.muzzlePosition, 50, decalMaterial);
                }
                else
                {
                    i = 0;
                    while (i < this.shotResult.targets.length)
                    {
                        target = this.shotResult.targets[i];
                        currTank = target.tank;
                        this.createTankShotEffect(tankData.user, this.shotResult.hitPoints[i], _direction);
                        currTank.addWorldForceScaled(this.shotResult.hitPoints[i], _direction, this.shaftData.impactQuickShot);
                        i++;
                    }
                    if (this.shotResult.hitPoints.length > this.shotResult.targets.length)
                    {
                        this.createStaticShotEffect(tankData.user, (this.shotResult.hitPoints[this.shotResult.targets.length] as Vector3), _direction);
                        this.battlefieldModel.addDecal((this.shotResult.hitPoints[this.shotResult.targets.length] as Vector3), allGunParams.muzzlePosition, 50, decalMaterial);
                    }
                }
            }
            shaftSFX.createMuzzleFlashEffect(tankData.turret, tankData.tank.skin.turretDescriptor.shaftMuzzle, tankData.tank.skin.turretMesh);
            shaftSFX.createShotSoundEffect(tankData.turret, tankData.user, allGunParams.muzzlePosition);
            this.doSetEnergyMode(ShaftEnergyMode.RECHARGE, 0, this.battlefieldModel.bfData.physTime);

            var _loc2_:int = this.battlefieldModel.bfData.physTime;
            this.shotResult.dir = _direction;
            this.sendStopAimCommand(_loc2_, (this.shotResult.hitPoints[this.shotResult.targets.length] as Vector3), this.shotResult.targets);
            this.exclusionSetController.deleteAllTemporaryItems();

            var commonData:WeaponCommonData = this.weaponCommonModel.getCommonData(TankData.localTankData.turret);
            var shaftSFX:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(TankData.localTankData.turret.id), TankData.localTankData.user);
            shaftSFX.stopManualSound(TankData.localTankData.user);
            shaftSFX.createShotSoundEffect(TankData.localTankData.turret, TankData.localTankData.user, allGunParams.muzzlePosition);
            TankData.localTankData.tank.addWorldForceScaled(allGunParams.muzzlePosition, allGunParams.direction, -(commonData.kickback));
            this.doSetEnergyMode(ShaftEnergyMode.RECHARGE, Math.min(this.getEnergy(_loc2_), 0), _loc2_);
            this.targetController.shaftMode = ShaftModes.TARGET_DEACTIVATION;
        }

        private function sendStopAimCommand(physTime:int, staticShot:Vector3, aims:Array):void
        {
            var json:Object = new Object();
            json.phys_time = physTime;
            json.static_shot = staticShot;
            json.targets = [];

            var i:int = 0;
            while (i < this.shotResult.targets.length)
            {
                if (this.shotResult.targets[i] is TankData)
                {
                    var pointPos:* = this.shotResult.dir.vClone();
                    globalToLocal(this.tankModel.getTankData(BattleController.activeTanks[this.shotResult.targets[i].userName]).tank, pointPos);

                    var targetObj:Object = {
                            "id": this.shotResult.targets[i].userName,
                            "pos": this.shotResult.hitPoints[i],
                            "point_pos": pointPos
                        }

                    json.targets.push(targetObj);
                }
                i++;
            }

            var enegry:Number = this.localTankData.tank.title.getWeaponStatus() / 100;
            json.energy = enegry;

            var jsonString:String = JSON.stringify(json);
            Network(Main.osgi.getService(INetworker)).send("battle;fire;" + jsonString);
        }

        private function createTankShotEffect(user:ClientObject, point:Vector3, dir:Vector3):void
        {
            var tankData:TankData = this.tankModel.getTankData(user);
            if (this.commonModel == null)
            {
                this.commonModel = (Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel);
            }
            var commonData:WeaponCommonData = this.commonModel.getCommonData(tankData.turret);
            this.weaponUtils.calculateGunParamsAux(tankData.tank.skin.turretMesh, commonData.muzzles[0], allGunParams.muzzlePosition, allGunParams.direction);
            var effects:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(tankData.turret.id), user);
            effects.createHitPointsGraphicEffects(tankData.turret, tankData.user, null, point, allGunParams.muzzlePosition, allGunParams.direction, dir);
        }

        private function createStaticShotEffect(user:ClientObject, point:Vector3, dir:Vector3):void
        {
            var tankData:TankData = this.tankModel.getTankData(user);
            if (this.commonModel == null)
            {
                this.commonModel = (Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel);
            }
            var commonData:WeaponCommonData = this.commonModel.getCommonData(tankData.turret);
            this.weaponUtils.calculateGunParamsAux(tankData.tank.skin.turretMesh, commonData.muzzles[0], allGunParams.muzzlePosition, allGunParams.direction);
            var effects:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(tankData.turret.id), user);
            effects.createHitPointsGraphicEffects(tankData.turret, tankData.user, point, null, allGunParams.muzzlePosition, allGunParams.direction, dir);
        }

        public function hasIntersection():Boolean
        {
            var object:Object3D;
            var commonData:WeaponCommonData = this.weaponCommonModel.getCommonData(TankData.localTankData.turret);
            this.localTankData.tank.getAllGunParams(allGunParams, commonData.muzzles);
            var tankPos:Vector3 = TankData.localTankData.tank.state.pos;
            _direction.vDiff(allGunParams.barrelOrigin, tankPos);
            this.exclusionSetController.addTemporaryItem(this.localTankData.tank.skin.turretMesh);
            this.exclusionSetController.addTemporaryItem(this.localTankData.tank.skin.hullMesh);
            var rayData:RayIntersectionData = this.battlefieldModel.raycast(tankPos, _direction, this.exclusionSet);
            trace(_direction);
            trace(allGunParams.barrelOrigin);
            trace(commonData.muzzles);
            if (((!(rayData == null)) && (rayData.time <= 1)))
            {
                object = rayData.object;
                trace(("hasIntersection " + object.name));
                this.exclusionSetController.deleteAllTemporaryItems();
                return (object.name == Object3DNames.STATIC);
            }
            this.exclusionSetController.deleteAllTemporaryItems();
            trace(("hasIntersection " + false));
            return (false);
        }

        private function isValidHit(param1:Tank, param2:Object3D, param3:Vector3):Boolean
        {
            var commonData:WeaponCommonData;
            var _loc4_:TankSkin = param1.skin;
            if (_loc4_.turretMesh == param2)
            {
                _m.setMatrix(param2.x, param2.y, param2.z, param2.rotationX, param2.rotationY, param2.rotationZ);
                _m.transformVectorInverse(param3, _p);
                commonData = this.weaponCommonModel.getCommonData(param1.tankData.turret);
                getClosestBarrelOrigin(_p, commonData.muzzles, _closestBarrelOrigin);
                _m.transformVector(_closestBarrelOrigin, _p);
                _p.vSubtract(param3);
                if (this.battlefieldModel.bfData.collisionDetector.hasStaticHit(param3, _p, CollisionGroup.STATIC, 1))
                {
                    return (false);
                }
            }
            return (_loc4_.hullMesh.alpha == 1);
        }

        private function addTankSkinToExclusionSet(param1:TankSkin):void
        {
            this.exclusionSetController.addTemporaryItem(param1.hullMesh);
            this.exclusionSetController.addTemporaryItem(param1.turretMesh);
        }

        public function targetModeOn():void
        {
            this.tankModel.lockControls(true);
            this.tankModel.applyControlState(TankData.localTankData, 0, true);
            this.tankModel.setControlState(TankData.localTankData, 0, true);
            var shaftSFX:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(TankData.localTankData.turret.id), TankData.localTankData.user);
            shaftSFX.createManualModeEffects(TankData.localTankData.turret, TankData.localTankData.user, TankData.localTankData.tank.skin.turretMesh);
        }

        public function getStatus():Number
        {
            return (this.getEnergy(getTimer()) / this.shaftData.maxEnergy);
        }

        public function doSetEnergyMode(mode:ShaftEnergyMode, energy:Number, physTime:int):void
        {
            this.energyMode = mode;
            switch (mode)
            {
                case ShaftEnergyMode.RECHARGE:
                    this.energyAdditive = 0;
                    this.energySpeed = this.shaftData.chargeRate;
                    this.energyBaseTime = (physTime - ((energy / this.energySpeed) * thousand));
                    break;
                case ShaftEnergyMode.DRAIN:
                    this.energyAdditive = this.shaftData.maxEnergy;
                    this.energySpeed = -(this.shaftData.dischargeRate);
                    this.energyBaseTime = (physTime + (((this.shaftData.maxEnergy - energy) / this.energySpeed) * thousand));
                    this.sendBeginEnergyDrain(physTime);
            }
        }

        private function sendBeginEnergyDrain(time:int):void
        {
            Network(Main.osgi.getService(INetworker)).send(("battle;begin_enegry_drain;" + time));
        }

        public function getEnergy(energyTime:Number):Number
        {
            var enegry:Number = (this.energyAdditive + (((energyTime - this.energyBaseTime) * this.energySpeed) / thousand));
            return (MathUtils.clamp(enegry, 0, this.shaftData.maxEnergy));
        }

        private function updateCrossPosition():void
        {
            this.image.x = ((Main.stage.stageWidth - this.image.width) >> 1);
            this.image.y = ((Main.stage.stageHeight - this.image.height) >> 1);
        }

        public function stopEffects(ownerTankData:TankData):void
        {
            var tank:Tank;
            if (TankData.localTankData == ownerTankData)
            {
                if (Main.stage.contains(this.image))
                {
                    Main.stage.removeChild(this.image);
                    Main.stage.removeChild(this.indicatorBitmap);
                    tank = TankData.localTankData.tank;
                    tank.title.show();
                    this.battlefieldModel.activateFollowCamera();
                    this.battlefieldModel.resetFollowCamera();
                    this.targetController.exit();
                    this.setEnergyMode(ShaftEnergyMode.RECHARGE);
                    this.targetController.deactivationTask.stop();
                }
                this.updateController = false;
                this.lock = false;
                this.lockCheckIntersection = false;
                this.fired = false;
                this.battlefieldModel.onResize(null);
            }
        }

        public function reset():void
        {
            this.doSetEnergyMode(ShaftEnergyMode.RECHARGE, this.shaftData.maxEnergy, this.battlefieldModel.bfData.physTime);
            if (TankData.localTankData == null)
            {
                return;
            }
            var shaftSFX:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(TankData.localTankData.turret.id), TankData.localTankData.user);
            shaftSFX.stopManualSound(TankData.localTankData.user);
            this.lockCheckIntersection = false;
        }

        public function setLocalUser(localUserData:TankData):void
        {
            this.objectLoaded(null);
            this.localTankData = localUserData;
            this.localShotData = WeaponsManager.shotDatas[localUserData.turret.id];
            this.localWeaponCommonData = this.weaponCommonModel.getCommonData(localUserData.turret);
            trace(this.localShotData.autoAimingAngleUp.value, this.localShotData.numRaysUp.value, this.localShotData.autoAimingAngleDown.value, this.localShotData.numRaysDown.value);
            this.quickShotTargetSystem.setParams(this.battlefieldModel.getBattlefieldData().physicsScene.collisionDetector, this.localShotData.autoAimingAngleUp.value, this.localShotData.numRaysUp.value, this.localShotData.autoAimingAngleDown.value, this.localShotData.numRaysDown.value, 1, null);
            this.shaftData = (localUserData.turret.getParams(ShaftData) as ShaftData);
            this.image = new Bitmap(Indicator.getIndicator(localUserData.turret));
            this.targetController = new TargetingController(this);
            this.reset();
        }

        public function clearLocalUser():void
        {
        }

        public function activateWeapon(time:int):void
        {
            this.activate = true;
        }

        public function deactivateWeapon(time:int, sendServerCommand:Boolean):void
        {
            this.activate = false;
        }

        public function get targetingController():TargetingController
        {
            return (this.targetController);
        }

    }
} // package alternativa.tanks.models.weapon.shaft

import alternativa.physics.collision.IRayCollisionPredicate;
import flash.utils.Dictionary;
import alternativa.physics.Body;

class MultybodyCollisionPredicate implements IRayCollisionPredicate
{

    public var bodies:Dictionary = new Dictionary();

    public function considerBody(body:Body):Boolean
    {
        return (this.bodies[body] == null);
    }

}
