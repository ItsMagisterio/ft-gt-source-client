// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

// alternativa.tanks.models.tank.TankModel

package alternativa.tanks.models.tank
{
    import com.alternativaplatform.projects.tanks.client.models.tank.TankModelBase;
    import com.alternativaplatform.projects.tanks.client.models.tank.ITankModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.osgi.service.network.INetworkListener;
    import alternativa.osgi.service.focus.IFocusListener;
    import alternativa.tanks.model.panel.IPanelListener;
    import alternativa.tanks.models.battlefield.IUserStatListener;
    import alternativa.osgi.service.dump.dumper.IDumper;
    import alternativa.tanks.models.battlefield.IChatListener;
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import alternativa.init.Main;
    import alternativa.math.Quaternion;
    import alternativa.math.Vector3;
    import flash.utils.Dictionary;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
    import alternativa.tanks.models.effectsvisualization.IEffectsVisualizationModel;
    import alternativa.tanks.models.inventory.IInventory;
    import alternativa.tanks.models.battlefield.IUserStat;
    import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
    import alternativa.physics.collision.types.RayIntersection;
    import logic.test.usertitles.UserTitlesRender;
    import logic.test.usertitles.DefaultUserTitlesRender;
    import com.alternativaplatform.projects.tanks.client.commons.types.TankParts;
    import alternativa.tanks.model.panel.PanelModel;
    import alternativa.model.IModel;
    import alternativa.tanks.model.panel.IPanel;
    import alternativa.tanks.models.battlefield.BattlefieldData;
    import alternativa.object.ClientObject;
    import alternativa.osgi.service.dump.IDumpService;
    import alternativa.tanks.vehicles.tanks.Tank;
    import flash.events.KeyboardEvent;
    import alternativa.tanks.loader.ILoaderWindowService;
    import alternativa.tanks.models.battlefield.StatisticsModel;
    import alternativa.register.ClientClass;
    import specter.utils.Logger;
    import alternativa.osgi.service.log.LogLevel;
    import logic.resource.ResourceUtil;
    import com.alternativaplatform.projects.tanks.client.models.tank.TankSoundScheme;
    import com.alternativaplatform.projects.tanks.client.models.tank.TankResources;
    import alternativa.register.ObjectRegister;
    import logic.tanks.WeaponsManager;
    import flash.display.BitmapData;
    import alternativa.tanks.models.battlefield.IBattleField;
    import logic.test.usertitles.SpectatorUserTitlesRender;
    import alternativa.tanks.models.tank.explosion.TankExplosionModel;
    import alternativa.tanks.models.tank.explosion.ITankExplosionModel;
    import alternativa.tanks.models.tank.criticalhit.TankCriticalHitModel;
    import alternativa.tanks.models.tank.criticalhit.ITankCriticalHitModel;
    import __AS3__.vec.Vector;
    import alternativa.tanks.models.weapon.IWeapon;
    import alternativa.tanks.models.battlefield.logic.updaters.LocalHullTransformUpdater;
    import alternativa.tanks.models.battlefield.logic.updaters.RemoteHullTransformUpdater;
    import com.alternativaplatform.projects.tanks.client.commons.types.TankSpecification;
    import projects.tanks.client.battleservice.model.team.BattleTeamType;
    import com.alternativaplatform.projects.tanks.client.models.tank.ClientTank;
    import forms.ChangeTeamAlert;
    import flash.utils.getTimer;
    import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
    import alternativa.tanks.physics.CollisionGroup;
    import alternativa.tanks.models.battlefield.logic.BeforeKillTankTask;
    import com.alternativaplatform.projects.tanks.client.commons.types.DeathReason;
    import alternativa.tanks.display.usertitle.UserTitle;
    import alternativa.tanks.models.battlefield.effects.levelup.LevelUpEffect;
    import flash.media.Sound;
    import logic.resource.ResourceType;
    import alternativa.tanks.models.tank.criticalhit.TankCriticalHitGraphicEffect;
    import flash.geom.Vector3D;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.tanks.locale.constants.TextConst;
    import alternativa.osgi.service.network.INetworkService;
    import alternativa.osgi.service.focus.IFocusService;
    import com.alternativaplatform.projects.tanks.client.commons.types.TankState;
    import alternativa.tanks.models.tank.explosion.TankDeathGraphicEffect;
    import alternativa.tanks.physics.TanksCollisionDetector;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import alternativa.physics.collision.IBodyCollisionPredicate;
    import alternativa.resource.StubBitmapData;
    import flash.ui.Keyboard;
    import alternativa.tanks.models.inventory.InventoryItemType;
    import alternativa.tanks.models.inventory.InventoryLock;
    import alternativa.tanks.vehicles.tanks.TankSkinHull;
    import alternativa.tanks.vehicles.tanks.TankSkinTurret;
    import logic.resource.images.ImageResource;
    import alternativa.tanks.vehicles.tanks.TankSkin;
    import alternativa.tanks.models.tank.turret.defaultt.DefaultTurretController;
    import alternativa.tanks.models.tank.turret.shaft.ShaftTurretController;
    import alternativa.tanks.sfx.TankSounds;
    import alternativa.tanks.models.effectsvisualization.ClientBattleEffect;
    import __AS3__.vec.*;
    import alternativa.physics.altphysics;
    import flash.utils.setTimeout;
    import flash.net.SharedObject;
    import alternativa.tanks.services.battleinput.GameActionListener;
    import alternativa.tanks.service.settings.keybinding.GameActionEnum;
    import alternativa.tanks.services.battleinput.BattleInputServiceImpl;
    import alternativa.tanks.services.battleinput.BattleInputService;
    import alternativa.tanks.utils.MathUtils;
    import alternativa.tanks.camera.FollowCameraController;
    import alternativa.tanks.services.battleinput.BattleInputLockType;
    import alternativa.tanks.models.weapon.common.ShotEffect;
    import forms.Alert;
    import forms.AlertAnswer;
    import alternativa.tanks.sfx.Sound3D;
    import alternativa.tanks.sfx.SoundOptions;
    import alternativa.tanks.sfx.Sound3DEffect;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.tanks.sound.DummySoundManager;
    import alternativa.tanks.models.ctf.CTFModel;
    import com.alternativaplatform.projects.tanks.client.models.ctf.ICaptureTheFlagModelBase;
    import alternativa.tanks.models.ctf.CTFFlag;
    import alternativa.tanks.models.ctf.CTFFlagState;

    use namespace altphysics;

    public class TankModel extends TankModelBase implements ITankModelBase, IObjectLoadListener, INetworkListener, IFocusListener, IPanelListener, ITank, IUserStatListener, IDumper, IChatListener, GameActionListener
    {

        private static const CHANGE_TEAM_ALERT_DELAY:int = 5;
        private static const DEFAULT_TANK_MASS:Number = 1250;
        private static const DEFAULT_TANK_POWER:Number = 80000;
        private static const CORRECTION_INTERVAL:int = 2000;
        public static var MIN_ALLOWED_Z:Number = -8000;
        private static const RESPAWN_DELAY:int = 3000;
        private static const SUICIDE_DELAY:int = 3000;
        private static const GARAGE_SUICIDE_DELAY:int = 3000;
        private static const ALT_KEY_CODE:int = 18;
        private static const PAUSE_KEY_CODE_1:int = 80;
        private static const PAUSE_KEY_CODE_2:int = 19;
        private static const SUICIDE_KEY_CODE:int = 220;
        public static const FORWARD:int = 1;
        public static const BACK:int = 2;
        public static const LEFT:int = 4;
        public static const RIGHT:int = 8;
        public static const TURRET_LEFT:int = 16;
        public static const TURRET_RIGHT:int = 32;
        public static const CENTER_TURRET:int = 64;
        public static const REVERSE_TURN_BIT:int = 128;
        public static const MOUSE_CONTROL_BIT:int = 256;

        private static var materialRegistry:IMaterialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
        public var suicideToGarage:Boolean = false;

        private const _orientation:Quaternion = new Quaternion();
        private const _orientation2:Quaternion = new Quaternion();
        private const _eulerAngles:Vector3 = new Vector3();

        private var tankPartsRegistry:TankPartsRegistry = new TankPartsRegistry();
        private var titleShowDistance:Number = 7000;
        private var titleHideDistance:Number = 7050;
        private var correctionEnabled:Boolean;
        private var nextCorrectionTime:int;
        private var _userControlsEnabled:Boolean;
        private var reverseBackTurn:Boolean;
        public var controlBits:int;
        private var keyTableDown:Dictionary;
        private var keyTableUp:Dictionary;
        private var modelService:IModelService;
        private var battlefield:BattlefieldModel;
        private var gui:IBattlefieldGUI;
        private var effectsModel:IEffectsVisualizationModel;
        private var inventoryModel:IInventory;
        private var tankDispatcher:ITankEventDispatcher;
        private var userStat:IUserStat;
        public var localUserData:TankData;
        public var tankDataById:Dictionary = new Dictionary();
        private var numTanks:int;
        private var uiControlLockCount:int;
        private var readyToSpawnCommandSent:Boolean;
        private var suicideTime:int;
        private var awaitingKillCommand:Boolean;
        private var firstSpawn:Boolean;
        private var activationTime:int;
        private var idleTimerEnabled:Boolean;
        private var idleTime:int;
        private var idleKickPeriod:int;
        private var _pos3d:Vector3d = new Vector3d(0, 0, 0);
        private var _orient3d:Vector3d = new Vector3d(0, 0, 0);
        private var _linVel3d:Vector3d = new Vector3d(0, 0, 0);
        private var _angVel3d:Vector3d = new Vector3d(0, 0, 0);
        private var suicideMessage:String;
        private var killMessage:String;
        private var paused:Boolean;
        private var controlsLocked:Boolean;
        private var point:Vector3 = new Vector3();
        private var rayOrigin:Vector3 = new Vector3();
        private var rayVector:Vector3 = new Vector3();
        private var rayIntersection:RayIntersection = new RayIntersection();
        private var userTitlesRender:UserTitlesRender = new DefaultUserTitlesRender();
        private var activateLater:Dictionary = new Dictionary();
        private var laterData:Dictionary = new Dictionary();
        public var tankParts:TankParts;
        private var panelModel:PanelModel;
        public var isRespawned:Boolean = false;
        public var flagEndEffect:Boolean = false;
        private var prepareToSpawnObject:Object;
        private var tte:TankDeathGraphicEffect;
        private var battleInputService:BattleInputServiceImpl;
        public var firstLogged:Boolean = true;

        public function TankModel()
        {
            this.battleInputService = BattleInputServiceImpl(Main.osgi.getService(BattleInputService));
            _interfaces.push(IModel, ITankModelBase, IPanelListener, IObjectLoadListener, ITank, IChatListener);
            Main.osgi.registerService(ITank, this);
            this.panelModel = PanelModel(Main.osgi.getService(IPanel));
        }

        public static function isFiniteVector3d(param1:Vector3d):Boolean
        {
            return ((((!(param1 == null)) && (isFinite(param1.x))) && (isFinite(param1.y))) && (isFinite(param1.z)));
        }

        public function lockControls(lock:Boolean):void
        {
            this.controlsLocked = lock;
            if ((!(this.localUserData)))
            {
                return;
            }
            this.localUserData.controlsLocked = this.controlsLocked;
        }

        public function bugReportOpened():void
        {
            this.updateUILock(1);
        }

        public function bugReportClosed():void
        {
            this.updateUILock(-1);
        }

        public function friendsOpened():void
        {
            this.updateUILock(1);
        }

        public function friendsClosed():void
        {
            this.updateUILock(-1);
        }

        public function settingsOpened():void
        {
            this.updateUILock(1);
        }

        public function onCloseGame():void
        {
            this.updateUILock(1);
        }

        public function settingsCanceled():void
        {
            this.updateUILock(-1);
        }

        public function onCloseGameExit():void
        {
            this.updateUILock(-1);
        }

        public function settingsAccepted():void
        {
            this.updateUILock(-1);
            if (this.localUserData != null)
            {
                this.setBackTurnMode();
            }
        }

        public function connect():void
        {
        }

        public function disconnect():void
        {
            if (this.localUserData != null)
            {
                this._userControlsEnabled = false;
                this.correctionEnabled = false;
                this.localUserData.weapon.ownerDisabled(this.localUserData.user);
            }
        }

        public function activate():void
        {
            var bfData:BattlefieldData;
            if (this.battlefield != null)
            {
                bfData = this.battlefield.getBattlefieldData();
                if (bfData != null)
                {
                    Main.stage.focus = bfData.viewport;
                }
            }
        }

        public function deactivate():void
        {
            if (((!(this.localUserData == null)) && (!(this.localUserData.tank == null))))
            {
                this.localUserData.weapon.stop();
                this.applyControlState(this.localUserData, (this.controlBits = 0));
            }
        }

        public function focusIn(focusedObject:Object):void
        {
        }

        public function focusOut(exfocusedObject:Object):void
        {
        }

        public function objectLoaded(clientObject:ClientObject):void
        {
        }

        public function objectUnloaded(clientObject:ClientObject):void
        {
            var dumpService:IDumpService;
            var tankData:TankData = this.getTankData(clientObject);
            if (tankData == null)
            {
                return;
            }
            if (tankData.tank == null)
            {
                return;
            }
            this.battlefield.removeTank(tankData);
            if (tankData.tank != null)
            {
                if (tankData.weapon != null)
                {
                    tankData.weapon.ownerUnloaded(clientObject);
                }
                if (tankData.tank.skin != null)
                {
                    tankData.tank.skin.dispose();
                }
            }
            var t:Tank = tankData.tank;
            t.destroy();
            t = null;
            if (tankData == this.localUserData)
            {
                TankData.localTankData = null;
                if (this.localUserData.tank != null)
                {
                    this.localUserData.tank.destroy();
                    this.localUserData.tank = null;
                }
                this.userTitlesRender.setLocalData(null);
                this.battlefield.setLocalUser(null);
                this.resume();
                ILoaderWindowService(Main.osgi.getService(ILoaderWindowService)).unlockLoaderWindow();
            }
            this.tankDispatcher.dispatchEvent(TankEvent.UNLOADED, tankData);
            delete this.tankDataById[clientObject.id];
            this.numTanks--;
            if (this.numTanks == 0)
            {
                dumpService = IDumpService(Main.osgi.getService(IDumpService));
                if (dumpService != null)
                {
                    dumpService.unregisterDumper(this.dumperName);
                }
            }
            StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).userDisconnect(null, tankData.userName, !Main.openingToGarage);
        }

        public function objectUnloadedFully(clientObject:ClientObject, fully:Boolean = false):void
        {
            firstLogged = true;
            battleInputService.removeGameActionListener(this);
            var dumpService:IDumpService;
            var tankData:TankData = this.getTankData(clientObject);
            if (tankData == null)
            {
                return;
            }
            this.battlefield.removeTank(tankData);
            if (tankData.tank != null)
            {
                if (tankData.weapon != null)
                {
                    tankData.weapon.ownerUnloaded(clientObject);
                }
                if (tankData.tank.skin != null)
                {
                    tankData.tank.skin.dispose();
                }
            }
            var t:Tank = tankData.tank;
            if (t != null)
            {
                t.destroy(fully);
            }
            t = null;
            if (tankData == this.localUserData)
            {
                TankData.localTankData = null;
                if (this.localUserData.tank != null)
                {
                    this.localUserData.tank.destroy(fully);
                    this.localUserData.tank = null;
                }
                this.userTitlesRender.setLocalData(null);
                this.battlefield.setLocalUser(null);
                this.resume();
                ILoaderWindowService(Main.osgi.getService(ILoaderWindowService)).unlockLoaderWindow();
            }
            this.tankDispatcher.dispatchEvent(TankEvent.UNLOADED, tankData);
            delete this.tankDataById[clientObject.id];
            this.numTanks--;
            if (this.numTanks == 0)
            {
                dumpService = IDumpService(Main.osgi.getService(IDumpService));
                if (dumpService != null)
                {
                    dumpService.unregisterDumper(this.dumperName);
                }
            }
            StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).userDisconnect(null, tankData.userName);
        }

        public function initClientObject(id:String, name:String):ClientObject
        {
            var clientClass:ClientClass = new ClientClass(id, null, name);
            return (new ClientObject(id, clientClass, name, null));
        }

        public function initObject(clientObject:ClientObject, battleId:String, mass:Number, power:Number, soundScheme:TankSoundScheme, tankParts:TankParts, tankResources:TankResources, impactForce:Number, kickback:Number, turretRotationAcceleration:Number, turretRotationSpeed:Number, nickname:String = null, rank:int = 0, turretId:String = null, turretSkin:String = null, shotEffectId:String = "", premium:Boolean = false):void
        {
            var errorMessage:String;
            if (this.modelService == null)
            {
                this.initModel();
            }
            if (Game.getInstance.classObject == null)
            {
                errorMessage = "TankModel::initObject() battle object not found";
                Logger.info(LogLevel.LOG_ERROR, errorMessage);
                throw (new Error(errorMessage));
            }
            if (ResourceUtil.isDataPresent(tankParts))
            {
                this.createData(clientObject, battleId, mass, power, soundScheme, tankParts, tankResources, impactForce, kickback, turretRotationAcceleration, turretRotationSpeed, nickname, rank, turretId, turretSkin, shotEffectId, premium);
                return;
            }
            ResourceUtil.addEventListener(function():void
                {
                    createData(clientObject, battleId, mass, power, soundScheme, internal::tankParts, tankResources, impactForce, kickback, turretRotationAcceleration, turretRotationSpeed, nickname, rank, turretId, turretSkin, shotEffectId, premium);
                });
            ResourceUtil.loadGraphicsFor(tankParts);
        }

        private function createData(clientObject:ClientObject, battleId:String, mass:Number, power:Number, soundScheme:TankSoundScheme, tankParts:TankParts, tankResources:TankResources, impactForce:Number, kickback:Number, turretRotationAcceleration:Number, turretRotationSpeed:Number, nickname:String = null, rank:int = 0, turretId:String = null, turretSkin:String = null, shotEffectId:String = "", isPremium:Boolean = false):void
        {
            var dumpService:IDumpService;
            var objectsRegister:ObjectRegister = clientObject.register;
            var battlefieldObject:ClientObject = Game.getInstance.classObject;
            var tankData:TankData = new TankData();
            tankData.logEvent("Loaded");
            tankData.battlefield = battlefieldObject;
            tankData.user = clientObject;
            tankData.userName = ((nickname == null) ? PanelModel(Main.osgi.getService(IPanel)).userName : nickname);
            tankData.userRank = rank;
            tankData.isPremium = isPremium;
            tankData.mass = ((mass <= 0) ? Number(DEFAULT_TANK_MASS) : Number(mass));
            tankData.power = ((power <= 0) ? Number(DEFAULT_TANK_POWER) : Number(power));
            tankData.hull = this.initClientObject((nickname + "_hull"), (nickname + "_hull"));
            tankData.turret = WeaponsManager.getObjectFor(turretId);
            tankData.weapon = WeaponsManager.getWeapon(clientObject, tankData.turret, impactForce, kickback, turretRotationAcceleration, turretRotationSpeed, shotEffectId);
            this.initTankColoring(objectsRegister, tankData, tankParts);
            tankData.deadColoring = new BitmapData(100, 100);
            tankData.sounds = this.createTankSounds(soundScheme);
            clientObject.putParams(TankModel, tankData);
            this.tankDataById[clientObject.id] = tankData;
            this.numTanks++;
            if (this.numTanks == 1)
            {
                dumpService = IDumpService(Main.osgi.getService(IDumpService));
                if (dumpService != null)
                {
                    dumpService.registerDumper(this);
                }
            }
            this.battlefield = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            this.userTitlesRender = ((!(!((Main.osgi.getService(IBattleField) as BattlefieldModel).spectatorMode))) ? new SpectatorUserTitlesRender() : new DefaultUserTitlesRender());
            this.userTitlesRender.setBattlefield(this.battlefield);
            TankExplosionModel(Main.osgi.getService(ITankExplosionModel)).initObject(tankData.hull, "explosionTexture", "shockWaveTexture", "smokeTexture");
            TankCriticalHitModel(Main.osgi.getService(ITankCriticalHitModel)).initObject(tankData.hull, "explosionTexture", "shockWaveTexture", "smokeTexture");
        }

        public function initTank(clientObject:ClientObject, clientTank:ClientTank, parts:TankParts, notificationOfEnter:Boolean = true, garageEnter:Boolean = false):void
        {
            if (suicideToGarage)
            {
                return;
            }
            var userName:String;
            var v:Vector.<Object>;
            var tankData:TankData = this.getTankData(clientObject);
            var shotEffectId:String = String(clientObject.getParams(ShotEffect));
            if (tankData == null)
            {
                ResourceUtil.addEventListener(function():void
                    {
                        initTank(clientObject, clientTank, parts, notificationOfEnter, garageEnter);
                    });
                return;
            }
            tankData.local = clientTank.self;
            var tank:Tank = this.createTank(tankData, parts);
            if (((tank == null) || (tankData == null)))
            {
                return;
            }
            tankData.tank = tank;
            tankData.sounds.tank = tank;
            tankData.teamType = clientTank.teamType;
            tankData.incarnation = clientTank.incarnationId;
            tankData.user = clientObject;
            this.setNormalTextures(tankData);
            this.setTankSpec(tankData, clientTank.tankSpecification, true);
            var tankWeapon:IWeapon = tankData.weapon;
            tankData.tank.turretTurnAcceleration = 2;
            tankData.tank.maxTurretTurnSpeed = 2;
            tankWeapon.ownerLoaded(clientObject);
            if (clientTank.self)
            {
                this.localUserData = tankData;
                this.userTitlesRender.setLocalData(this.localUserData);
                this.initLocalTank(tankData);
                this.suicideTime = int.MAX_VALUE;
            }
            tankData.logEvent("Initialized");
            if (clientTank.tankState != null)
            {
                this.putTankIntoBattle(tankData, clientTank);
            }
            this.tankDispatcher.dispatchEvent(TankEvent.LOADED, tankData);
            this.battlefield.addTank(tankData);
            if (notificationOfEnter)
            {
                StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).userConnect(clientObject, tankData.userName, tankData.teamType, tankData.userName, tankData.userRank, !garageEnter, tankData.turret.id, tankData.isPremium);
            }
            if ((!(tankData.local)))
            {
                this.configureRemoteTankTitle(tankData);
            }
            if (tankData.local)
            {
                tankData.tank.setHullTransformUpdater(new LocalHullTransformUpdater(tankData.tank));
            }
            else
            {
                tankData.tank.setHullTransformUpdater(new RemoteHullTransformUpdater(tankData.tank));
                if (this.activateLater[clientObject.id] != null)
                {
                    switch (this.activateLater[clientObject.id])
                    {
                        case "activate":
                            this.activateTank(clientObject);
                            break;
                        case "spawn":
                            v = this.laterData[clientObject.id];
                            this.spawn(clientObject, TankSpecification(v[0]), BattleTeamType(v[1]), Vector3d(v[2]), Vector3d(v[3]), int(v[4]), int(v[5]));
                            this.laterData[clientObject.id] = null;
                    }
                    this.activateLater[clientObject.id] = null;
                }
            }
            trace("initTank ended");
            if (this.prepareToSpawnObject != null)
            {
                userName = PanelModel(Main.osgi.getService(IPanel)).userName;
                if (((!(clientObject == null)) && (clientObject.id == userName)))
                {
                    Logger.info(LogLevel.LOG_ERROR, (("prepareToSpawn[" + clientObject.getParams(TankModel)) + "]"));
                    this.prepareToSpawn(clientObject, this.prepareToSpawnObject.pos, this.prepareToSpawnObject.orientation);
                    this.prepareToSpawnObject = null;
                }
            }
            if (clientTank.spawnState == TankSpawnState.NEWCOME)
            {
                this.setSpawningState(tankData);
                setTimeout(function():void{
                    if(tankData != null && tankData.tank != null){
                        tankData.tank.skin.setAlpha(1, true);
                        tankData.tank.title.sprite.visible = true;
                        tankData.tank.skin.hullMesh.visible = true;
                        tankData.tank.skin.turretMesh.visible = true;
                        tankData.tank.skin.hullObjects.visible = true;
                    }
                }, 5000);
            }
        }

        public function activateTank(clientObject:ClientObject):void
        {
            var tankData:TankData = this.getTankData(clientObject);
            if ((((((tankData == null) || (tankData.tank == null)) || (tankData.tank.skin == null)) || (tankData.tank.skin.hullMesh == null)) || (tankData.tank.skin.turretMesh == null)))
            {
                Logger.info(LogLevel.LOG_ERROR, ((("TankModel: Incorrect call of activateTank() clientObject=" + clientObject) + ", tankData=") + tankData));
                this.activateLater[clientObject.id] = "activate";
                return;
            }
            tankData.logEvent("Activated");
            this.setNormalState(tankData);
            if (tankData.local)
            {
                this.updateUILock(0);
            }
            this.tankDispatcher.dispatchEvent(TankEvent.ACTIVATED, tankData);
        }

        public function setTemperature(clientObject:ClientObject, value:Number):void
        {
            var tankData:TankData = this.getTankData(clientObject);
            if (((tankData == null) || (tankData.tank == null)))
            {
                Logger.info(LogLevel.LOG_ERROR, ((("TankModel: Incorrect call of setTemperature() clientObject=" + clientObject) + ", tankData=") + tankData));
                return;
            }
            this.setTankTemperature(tankData.tank, value);
        }

        public function getTankData(clientObject:ClientObject):TankData
        {
            if (clientObject == null)
            {
                return (null);
            }
            return (TankData(clientObject.getParams(TankModel)));
        }

        public function move(clientObject:ClientObject, pos:Vector3d, orientation:Vector3d, linearVelocity:Vector3d, angleVelocity:Vector3d, turretAngle:Number, control:int, isControl:Boolean):void
        {
            var tankData:TankData = this.getTankData(clientObject);
            if ((((tankData == null) || (tankData.tank == null)) || (tankData == this.localUserData)))
            {
                return;
            }
            var tank:Tank = tankData.tank;
            this.interpolateVector3d(0.5, tank.state.pos, pos, pos);
            this.interpolateVector3d(0.5, tank.state.velocity, linearVelocity, linearVelocity);
            this.interpolateVector3d(0.5, tank.state.rotation, angleVelocity, angleVelocity);
            this.interpolateOrientation(0.5, tank.state.orientation, orientation, orientation);
            this.setTankState(tankData, pos, orientation, linearVelocity, angleVelocity, turretAngle, control, isControl);
        }

        private function interpolateVector3d(smooth:Number, param2:Vector3, param3:Vector3d, param4:Vector3d):void
        {
            param4.x = (param2.x + ((param3.x - param2.x) * smooth));
            param4.y = (param2.y + ((param3.y - param2.y) * smooth));
            param4.z = (param2.z + ((param3.z - param2.z) * smooth));
        }

        private function interpolateOrientation(param1:Number, param2:Quaternion, param3:Vector3d, param4:Vector3d):void
        {
            this._orientation.setFromEulerAnglesXYZ(param3.x, param3.y, param3.z);
            this._orientation2.slerp(param2, this._orientation, param1);
            this._orientation2.getEulerAngles(this._eulerAngles);
            param4.x = this._eulerAngles.x;
            param4.y = this._eulerAngles.y;
            param4.z = this._eulerAngles.z;
        }

        public function prepareToSpawn(clientObject:ClientObject, pos:Vector3d, orientation:Vector3d):void
        {
            var userName:String;
            var pivotPosition:Vector3;
            var targetDirection:Vector3;
            var tankData:TankData = this.getTankData(clientObject);
            if (((tankData == null) || (tankData.tank == null)))
            {
                userName = PanelModel(Main.osgi.getService(IPanel)).userName;
                if (clientObject.id == userName)
                {
                    this.prepareToSpawnObject = new Object();
                    this.prepareToSpawnObject.pos = pos;
                    this.prepareToSpawnObject.orientation = orientation;
                }
                Logger.info(LogLevel.LOG_ERROR, ((("TankModel: Incorrect call of prepareToSpawn() clientObject=" + clientObject) + ", tankData=") + tankData));
                return;
            }
            tankData.logEvent("Prepare to spawn");
            tankData.deadTime = 0;
            this.battlefield.removeTankFromField(tankData);
            if ((!(tankData.local)))
            {
                tankData.tank.lockTransformUpdate();
            }
            if (((!(this.localUserData == null)) && (clientObject == this.localUserData.user)))
            {
                if (firstLogged)
                {
                    battleInputService.addGameActionListener(this);

                    this.battleInputService.unlock(BattleInputLockType.MODAL_DIALOG);
                    firstLogged = false;
                }
                pivotPosition = new Vector3(pos.x, pos.y, (pos.z + 200));
                targetDirection = new Vector3(-(Math.sin(orientation.z)), Math.cos(orientation.z), 0);
                if (this.firstSpawn)
                {
                    this.battlefield.initFlyCamera(pivotPosition, targetDirection);
                }
                else
                {
                    this.battlefield.initFlyCamera(pivotPosition, targetDirection);
                }
                this.correctionEnabled = false;
            }
        }

        public function spawn(clientObject:ClientObject, spec:TankSpecification, teamType:BattleTeamType, pos:Vector3d, orientation:Vector3d, health:int, incarnationId:int):void
        {
            var changeTeamAlert:ChangeTeamAlert;
            var tankData:TankData = this.getTankData(clientObject);
            if ((((((tankData == null) || (tankData.tank == null)) || (tankData.tank.skin == null)) || (tankData.tank.skin.hullMesh == null)) || (tankData.tank.skin.turretMesh == null)))
            {
                Logger.info(LogLevel.LOG_ERROR, ((("TankModel: Incorrect call of spawn() clientObject=" + clientObject) + ", tankData=") + tankData));
                if (((clientObject == null) || (clientObject.id == null)))
                {
                    return;
                }
                this.activateLater[clientObject.id] = "spawn";
                this.laterData[clientObject.id] = new Vector.<Object>();
                this.laterData[clientObject.id].push(spec);
                this.laterData[clientObject.id].push(teamType);
                this.laterData[clientObject.id].push(pos);
                this.laterData[clientObject.id].push(orientation);
                this.laterData[clientObject.id].push(health);
                this.laterData[clientObject.id].push(incarnationId);
                return;
            }
            tankData.logEvent("Spawn begin");
            var tank:Tank = tankData.tank;
            if (((((tankData.local) && (!(teamType == BattleTeamType.NONE))) && (!(teamType == tankData.teamType))) || (((tankData.local) && (this.firstSpawn)) && (!(teamType == BattleTeamType.NONE)))))
            {
                changeTeamAlert = new ChangeTeamAlert(CHANGE_TEAM_ALERT_DELAY, ((teamType == BattleTeamType.RED) ? int(ChangeTeamAlert.RED) : int(ChangeTeamAlert.BLUE)));
                changeTeamAlert.x = ((Main.stage.stageWidth - changeTeamAlert.width) >> 1);
                changeTeamAlert.y = ((Main.stage.stageHeight - changeTeamAlert.height) >> 1);
                Main.stage.addChild(changeTeamAlert);
            }
            tankData.deadTime = 0;
            tankData.enabled = true;
            tankData.incarnation = incarnationId;
            this.setTankHealth(tankData, health);
            tankData.teamType = teamType;
            tankData.tank.title.setTeamType(teamType);
            this.setTankSpec(tankData, spec, true);
            tank.skin.resetColorTransform();
            pos.z = (pos.z + 200);
            tankData.tank.clearAccumulators();
            var zeroVector3d:Vector3d = new Vector3d(0, 0, 0);
            this.setTankState(tankData, pos, orientation, zeroVector3d, zeroVector3d, 0, 0, true);
            this.setNormalTextures(tankData);
            tankData.sounds.setIdleMode();
            this.setTransparentState(tankData);
            if (tankData.local)
            {
                tankData = this.localUserData;
                this.idleTimerEnabled = true;
                this.activationTime = (getTimer() + this.battlefield.getRespawnInvulnerabilityPeriod());
                this.suicideTime = int.MAX_VALUE;
                this.awaitingKillCommand = false;
                tankData.tank.title.show();
                tankData.weapon.reset();
                this.updateUILock(0);
                this.configureOtherTankTitles();
                this.firstSpawn = false;
                this.controlsLocked = false;
            }
            else
            {
                tankData.activationTime = (getTimer() + this.battlefield.getRespawnInvulnerabilityPeriod());
                this.configureRemoteTankTitle(tankData);
            }
            tankData.logEvent("Spawned");
            this.tankDispatcher.dispatchEvent(TankEvent.SPAWNED, tankData);
            if ((!(tankData.local)))
            {
                tankData.tank.unlockTransformUpdate();
            }
        }

        public function kill(clientObject:ClientObject, reason:DeathReason, killerTankId:String):void
        {
            var tankData:TankData = this.getTankData(clientObject);
            if (((tankData == null) || (tankData.tank == null)))
            {
                return;
            }
            this.setControlState(tankData, 0, true);
            tankData.logEvent("Killed");
            tankData.enabled = false;
            tankData.health = 0;
            tankData.deadTime = RESPAWN_DELAY;
            tankData.weapon.ownerDisabled(clientObject);
            tankData.tank.title.hideIndicators();
            tankData.spawnState = TankSpawnState.SUICIDE;
            if (tankData.local)
            {
                this._userControlsEnabled = false;
                this.awaitingKillCommand = false;
                this.readyToSpawnCommandSent = false;
                this.battlefield.hideSuicideIndicator();
                this.suicideTime = int.MAX_VALUE;
                tankData.tank.collisionGroup = (tankData.tank.collisionGroup & (~(CollisionGroup.BONUS_WITH_TANK)));
            }
            this.createDeathEffects(tankData);
            this.showUserDeathMessage(clientObject, reason, killerTankId);
            this.tankDispatcher.dispatchEvent(TankEvent.KILLED, tankData);
            this.stop(tankData);
            this.battlefield.logicUnits.addLogicUnit(new BeforeKillTankTask((getTimer() + 3000), tankData.tank));
        }

        public function kill1(clientObject:ClientObject, reason:DeathReason, killerTankId:String):void
        {
            var tankData:TankData = this.getTankData(clientObject);
            if (tankData == null || tankData.tank == null)
            {
                return;
            }
            this.createDeathEffects(tankData);
            this.setControlState(tankData, 0);
            tankData.logEvent("Killed");
            tankData.enabled = false;
            tankData.health = 0;
            tankData.deadTime = RESPAWN_DELAY;
            tankData.weapon.ownerDisabled(clientObject);
            tankData.tank.title.hideIndicators();
            if (tankData.local)
            {
                this._userControlsEnabled = false;
                this.awaitingKillCommand = false;
                this.readyToSpawnCommandSent = false;
                this.battlefield.hideSuicideIndicator();
                this.suicideTime = int.MAX_VALUE;
                tankData.tank.collisionGroup = tankData.tank.collisionGroup & ~CollisionGroup.BONUS_WITH_TANK;
            }
            this.tankDispatcher.dispatchEvent(TankEvent.KILLED, tankData);
            this.stop(tankData);
        }

        public function changeHealth(clientObject:ClientObject, newHealth:int):void
        {
            var tankData:TankData = this.getTankData(clientObject);
            if (((tankData == null) || (tankData.tank == null)))
            {
                Logger.info(LogLevel.LOG_ERROR, ((("TankModel: Incorrect call of changeHealth() clientObject=" + clientObject) + ", tankData=") + tankData));
                return;
            }
            this.setTankHealth(tankData, newHealth);
        }

        public function changeSpecification(clientObject:ClientObject, tankSpecification:TankSpecification, immediate:Boolean):void
        {
            var tankData:TankData = this.getTankData(clientObject);
            if (((tankData == null) || (tankData.tank == null)))
            {
                Logger.info(LogLevel.LOG_ERROR, ((("TankModel: Incorrect call of changeSpecification() clientObject=" + clientObject) + ", tankData=") + tankData));
                return;
            }
            this.setTankSpec(tankData, tankSpecification, immediate);
        }

        public function update(tankData:TankData, time:int, deltaMillis:int, deltaSec:Number, interpolationValue:Number, cameraPos:Vector3):void
        {
            var tank:Tank = tankData.tank;
            this.rotateTurret(tankData, deltaSec, time);
            this.userTitlesRender.updateTitle(tankData, cameraPos);
            tank.skin.updateColorTransform(deltaSec);
            tank.updateSkin(interpolationValue);
            if (tankData.deadTime > 0)
            {
                tankData.deadTime = (tankData.deadTime - deltaMillis);
                if (tankData.deadTime <= 0)
                {
                    tankData.deadTime = 0;
                    this.battlefield.removeTankFromField(tankData);
                }
            }
            if (tankData.local)
            {
                this.updateLocalTank(time, deltaMillis);
            }
        }

        public function disableUserControls(stopNotification:Boolean):void
        {
            if (this.localUserData == null)
            {
                return;
            }
            this._userControlsEnabled = false;
            this.controlBits = 0;
            this.applyControlState(this.localUserData, 0);
            this.localUserData.weapon.disable();
            if (stopNotification)
            {
                this.correctionEnabled = false;
            }
        }

        public function enableUserControls():void
        {
            if (((this.localUserData == null) || (!(this.localUserData.enabled))))
            {
                return;
            }
            this._userControlsEnabled = true;
            this.correctionEnabled = true;
            this.applyControlState(this.localUserData, this.controlBits);
            if (this.localUserData.spawnState == TankSpawnState.ACTIVE)
            {
                this.localUserData.weapon.enable();
            }
        }

        public function stop(tankData:TankData):void
        {
            this.setControlState(tankData, 0);
            tankData.weapon.ownerDisabled(tankData.user);
        }

        public function resetIdleTimer(disable:Boolean):void
        {
            if (disable)
            {
                this.idleTimerEnabled = false;
            }
            this.idleTime = 0;
        }

        public function get userControlsEnabled():Boolean
        {
            return (this._userControlsEnabled);
        }

        public function userStatChanged(userId:String, userName:String, userRank:int):void
        {
            var title:UserTitle;
            var tankData:TankData = this.tankDataById[userId];
            if (tankData != null)
            {
                tankData.userName = userName;
                tankData.userRank = userRank;
                if (tankData.tank != null)
                {
                    title = tankData.tank.title;
                    title.setLabelText(userName);
                    title.setRank(userRank);
                }
            }
        }

        public function createLevelUpEffect(userId:String, rang:int):void
        {
            var effect:LevelUpEffect;
            var levelUpSound:Sound;
            var tankData:TankData = this.tankDataById[userId];
            if (tankData != null)
            {
                effect = new LevelUpEffect();
                effect.createEffect(tankData.tank, rang);
                tankData.tank.title.setRank(rang);
                levelUpSound = ResourceUtil.getResource(ResourceType.SOUND, "levelUpSound").sound;
                var objectPoolService:IObjectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
                var sound:Sound3D = Sound3D.create(levelUpSound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, 1);
                var soundEffect:Sound3DEffect = Sound3DEffect.create(objectPoolService.objectPool, tankData.user, tankData.tank.state.pos, sound);
                (Main.osgi.getService(IBattleField) as IBattleField).addSound3DEffect(soundEffect);
            }
        }

        public function createCriticalHitEffect(userId:String):void
        {
            var tankData:TankData = this.tankDataById[userId];
            if (tankData != null)
            {
                this.battlefield.addGraphicEffect(new TankCriticalHitGraphicEffect(tankData));
            }
        }

        public function readLocalTankPosition(pos:Vector3D):void
        {
            if (this.localUserData == null)
            {
                return;
            }
            var v:Vector3 = this.localUserData.tank.state.pos;
            pos.x = v.x;
            pos.y = v.y;
            pos.z = v.z;
        }

        public function effectStarted(clientObject:ClientObject, effectId:int, duration:int):void
        {
            var tankData:TankData = this.getTankData(clientObject);
            if (((tankData == null) || (tankData.tank == null)))
            {
                Logger.info(LogLevel.LOG_ERROR, ((((("TankModel::effectStarted(): Incorrect call clientObject=" + clientObject) + ", tankData=") + tankData) + ", effectId=") + effectId));
                return;
            }
            tankData.tank.title.showIndicator(effectId, duration);
        }

        public function effectStopped(clientObject:ClientObject, effectId:int):void
        {
            var tankData:TankData = this.getTankData(clientObject);
            if (((tankData == null) || (tankData.tank == null)))
            {
                Logger.info(LogLevel.LOG_ERROR, ((((("TankModel::effectStopped(): Incorrect call clientObject=" + clientObject) + ", tankData=") + tankData) + ", effectId=") + effectId));
                return;
            }
            tankData.tank.title.hideIndicator(effectId);
        }

        public function get dumperName():String
        {
            return ("tank");
        }

        public function dump(params:Vector.<String>):String
        {
            return ((((((((((((((((((((((((((((((((((((("=== TankModel dump ===\n" + "userControlsEnabled=") + this._userControlsEnabled) + "\n") + "correctionEnabled=") + this.correctionEnabled) + "\n") + "nextCorrectionTime=") + this.nextCorrectionTime) + "\n") + "reverseBackTurn=") + this.reverseBackTurn) + "\n") + "ctrlBits=") + this.controlBits) + "\n") + "uiControlLockCount=") + this.uiControlLockCount) + "\n") + "suicideTime=") + this.suicideTime) + "\n") + "awaitingKillCommand=") + this.awaitingKillCommand) + "\n") + "firstSpawn=") + this.firstSpawn) + "\n") + "activationTime=") + this.activationTime) + "\n") + "idleTime=") + this.idleTime) + "\n") + "idleKickPeriod=") + this.idleKickPeriod) + "\n") + "=== Eend of TankModel dump ===");
        }

        public function chatOpened():void
        {
            this.updateUILock(1);
        }

        public function chatClosed():void
        {
            this.updateUILock(-1);
        }

        public function setMuteSound(mute:Boolean):void
        {
        }

        private function showUserDeathMessage(clientObject:ClientObject, reason:DeathReason, killerTankId:String):void
        {
            switch (reason)
            {
                case DeathReason.SUICIDE:
                    this.gui.logUserAction(clientObject.id, this.suicideMessage);
                    break;
                case DeathReason.MINE:
                    this.gui.logUserAction(killerTankId, "mine", clientObject.id);
                    break;
                case DeathReason.KILLED_IN_BATTLE:
                    if (killerTankId == clientObject.id)
                    {
                        this.gui.logUserAction(clientObject.id, this.suicideMessage);
                    }
                    else
                    {
                        this.gui.logUserAction(killerTankId, this.killMessage, clientObject.id);
                    }
            }
        }

        private function initModel():void
        {
            this.modelService = IModelService(Main.osgi.getService(IModelService));
            this.tankDispatcher = ITankEventDispatcher(Main.osgi.getService(ITankEventDispatcher));
            this.battlefield = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            this.userTitlesRender = ((!(!((Main.osgi.getService(IBattleField) as BattlefieldModel).spectatorMode))) ? new SpectatorUserTitlesRender() : new DefaultUserTitlesRender());
            this.userTitlesRender.setBattlefield(this.battlefield);
            this.gui = (Main.osgi.getService(IBattlefieldGUI) as IBattlefieldGUI);
            this.effectsModel = IEffectsVisualizationModel(this.modelService.getModelsByInterface(IEffectsVisualizationModel)[0]);
            this.inventoryModel = IInventory(this.modelService.getModelsByInterface(IInventory)[0]);
            var locale:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            this.suicideMessage = locale.getText(TextConst.BATTLE_PLAYER_SUICIDED);
            this.killMessage = locale.getText(TextConst.BATTLE_PLAYER_KILLED);
            this.initKeyTable();
            var networkService:INetworkService = INetworkService(Main.osgi.getService(INetworkService));
            if (networkService != null)
            {
                networkService.addEventListener(this);
            }
            var focusService:IFocusService = IFocusService(Main.osgi.getService(IFocusService));
            if (focusService != null)
            {
                focusService.addFocusListener(this);
            }
        }

        private function putTankIntoBattle(tankData:TankData, clientTank:ClientTank):void
        {
            var tankState:TankState = clientTank.tankState;
            tankData.enabled = true;
            this.setTankHealth(tankData, clientTank.health);
            if (clientTank.health <= 0)
            {
                this.setDeadTextures(tankData);
                tankData.tank.title.hide();
            }
            else
            {
                if (((!(TankData.localTankData == null)) && (!(clientTank.self))))
                {
                    this.configureRemoteTankTitle(tankData);
                }
            }
            var zeroVector3d:Vector3d = new Vector3d(0, 0, 0);
            this.setTankState(tankData, tankState.position, tankState.orientation, zeroVector3d, zeroVector3d, tankState.turretAngle, tankState.control, true);
            switch (clientTank.spawnState)
            {
                case TankSpawnState.NEWCOME:
                    this.setTransparentState(tankData);
                    break;
                case TankSpawnState.ACTIVE:
                    this.setNormalState(tankData);
            }
        }

        private function initLocalTank(tankData:TankData):void
        {
            TankData.localTankData = tankData;
            this.idleTime = 0;
            this.paused = false;
            Main.stage.focus = null;
            this.localUserData = tankData;
            this.userTitlesRender.setLocalData(this.localUserData);
            this.battlefield.setLocalUser(tankData.user);
            this.firstSpawn = true;
            this.correctionEnabled = false;
            this._userControlsEnabled = false;
            this.idleTimerEnabled = false;
            this.idleKickPeriod = this.battlefield.getBattlefieldData().idleKickPeriod;
            this.setBackTurnMode();
            this.readyToSpawnCommandSent = true;
            var title:UserTitle = this.localUserData.tank.title;
            title.setRank(tankData.userRank);
            title.setLabelText(tankData.userName);
            tankData.health = 10000;
            title.setHealth(tankData.health);
            title.setConfiguration(((UserTitle.BIT_HEALTH | UserTitle.BIT_WEAPON) | UserTitle.BIT_EFFECTS));
            title.setWeaponStatus(100);
            this.setSpawningState(tankData);
        }

        private function isSameTeam(teamType1:BattleTeamType, teamType2:BattleTeamType):Boolean
        {
            return ((!(teamType1 == BattleTeamType.NONE)) && (teamType1 == teamType2));
        }

        private function createDeathEffects(tankData:TankData):void
        {
            var td:TankData = tankData;
            this.battlefield.addGraphicEffect(new TankDeathGraphicEffect(td));
            // this.battlefield.addGraphicEffect(new TankDeathGraphicEffect(tankData));
        }

        private function rotateTurret(tankData:TankData, deltaSec:Number, time:Number):void
        {
            var tank:Tank = tankData.tank;
            tank.getTurretController().rotateTurret(deltaSec, time);
        }

        public function rotateTurretForcibly(tankData:TankData, deltaSec:Number, ctrl:int):void
        {
            var tank:Tank = tankData.tank;
            var turretRotationDir:int = (((ctrl & TURRET_LEFT) >> 4) - ((ctrl & TURRET_RIGHT) >> 5));
            if (turretRotationDir != 0)
            {
                if ((ctrl & CENTER_TURRET) != 0)
                {
                    ctrl = (ctrl & (~(CENTER_TURRET)));
                    if (tankData.local)
                    {
                        this.controlBits = (this.controlBits & (~(CENTER_TURRET)));
                    }
                    if (tank.turretDirSign == turretRotationDir)
                    {
                        tank.stopTurret();
                        tankData.sounds.playTurretSound(false);
                    }
                }
                tank.rotateTurret((turretRotationDir * deltaSec), false);
            }
            else
            {
                if ((ctrl & CENTER_TURRET) != 0)
                {
                    if (tank.rotateTurret((-(tank.turretDirSign) * deltaSec), true))
                    {
                        ctrl = (ctrl & (~(CENTER_TURRET)));
                        tank.stopTurret();
                    }
                }
                else
                {
                    tank.stopTurret();
                }
            }
            tankData.sounds.playTurretSound((!(tankData.tank.turretTurnSpeed == 0)));
        }

        private function updateTitle(tankData:TankData, cameraPos:Vector3D):void
        {
            var pos:Vector3;
            var dx:Number = NaN;
            var dy:Number = NaN;
            var dz:Number = NaN;
            var distance:Number = NaN;
            var tank:Tank = tankData.tank;
            if (tankData.health <= 0)
            {
                tankData.tank.title.hide();
            }
            else
            {
                if (((!(tankData.local)) && (!(this.localUserData == null))))
                {
                    if ((!(this.isSameTeam(this.localUserData.teamType, tankData.teamType))))
                    {
                        pos = tank.state.pos;
                        dx = (pos.x - cameraPos.x);
                        dy = (pos.y - cameraPos.y);
                        dz = (pos.z - cameraPos.z);
                        distance = Math.sqrt((((dx * dx) + (dy * dy)) + (dz * dz)));
                        if (((distance >= this.titleHideDistance) || (this.isTankInvisible(tankData, cameraPos))))
                        {
                            tank.title.hide();
                        }
                        else
                        {
                            if (distance < this.titleShowDistance)
                            {
                                tank.title.show();
                            }
                        }
                    }
                    else
                    {
                        tank.title.show();
                    }
                }
            }
        }

        private function isTankInvisible(tankData:TankData, cameraPos:Vector3D):Boolean
        {
            var i:int;
            var collisionDetector:TanksCollisionDetector = this.battlefield.getBattlefieldData().collisionDetector;
            var points:Vector.<Vector3> = tankData.tank.visibilityPoints;
            var len:int = points.length;
            while (i < len)
            {
                this.point.vCopy(points[i]);
                if (this.isTankPointVisible(this.point, tankData, cameraPos, collisionDetector))
                {
                    return (false);
                }
                i++;
            }
            return (true);
        }

        private function isTankPointVisible(point:Vector3, tankData:TankData, cameraPos:Vector3D, collisionDetector:TanksCollisionDetector):Boolean
        {
            point.vTransformBy3(tankData.tank.baseMatrix);
            point.vAdd(tankData.tank.state.pos);
            this.rayOrigin.copyFromVector3D(cameraPos);
            this.rayVector.vDiff(point, this.rayOrigin);
            return (!(collisionDetector.intersectRayWithStatic(this.rayOrigin, this.rayVector, CollisionGroup.STATIC, 1, null, this.rayIntersection)));
        }

        public function testRespawn():void
        {
            this.isRespawned = true;
        }

        public function activateTankCommand(user:ClientObject):void
        {
            Network(Main.osgi.getService(INetworker)).send("battle;activate_tank");
        }

        private function updateLocalTank(time:int, timeDelta:int):void
        {
            var pos:Vector3;
            var weaponStatus:Number = NaN;
            if (this.localUserData.enabled)
            {
                pos = this.localUserData.tank.state.pos;
                if (time >= this.suicideTime)
                {
                    this.sendSuicideCommand(pos, false);
                }
                if (pos.z < MIN_ALLOWED_Z)
                {
                    this.sendSuicideCommand(pos, true);
                }
                weaponStatus = this.localUserData.weapon.update(time, timeDelta);
                this.localUserData.tank.title.setWeaponStatus((100 * weaponStatus));
                if ((((!(this.localUserData.spawnState == TankSpawnState.ACTIVE)) && (time >= this.activationTime)) && (this.localUserData.tankCollisionCount == 0)))
                {
                    this.activationTime = int.MAX_VALUE;
                    this.activateTankCommand(this.localUserData.user);
                }
            }
            if ((((this.localUserData.deadTime == 0) && (!(this.paused))) && (!(this.readyToSpawnCommandSent))))
            {
                this.readyToSpawnCommandSent = true;
            }
            if (((this.correctionEnabled) && (time >= this.nextCorrectionTime)))
            {
                this.localUserData.tank.getPhysicsState(this._pos3d, this._orient3d, this._linVel3d, this._angVel3d);
                this.moveCommand(this.localUserData.user, time, this._pos3d, this._orient3d, this._linVel3d, this._angVel3d, this.localUserData.tank.turretDir, this.localUserData.ctrlBits);
                this.nextCorrectionTime = (this.nextCorrectionTime + CORRECTION_INTERVAL);
            }
            if (((this.paused) || (this.idleTimerEnabled)))
            {
                this.checkIdleKick(timeDelta);
            }
            if (this.paused)
            {
                this.gui.setPauseTimeout(((this.idleKickPeriod - this.idleTime) / 1000));
            }
        }

        private function moveCommand(obj:ClientObject, time:int, pos:Vector3d, orientation:Vector3d, linVel:Vector3d, angVel:Vector3d, turretDir:Number, controlBits:int):void
        {
            var turretRotationDir:int;
            var turretRotationDirAddition:int;
            if (this.controlsLocked)
            {
                controlBits = 0;
                turretRotationDir = ((((int((this.localUserData.ctrlBits & TankModel.TURRET_LEFT))) || (int((this.localUserData.ctrlBits & TankModel.LEFT)))) >> 4) - (((int((this.localUserData.ctrlBits & TankModel.TURRET_RIGHT))) || (int((this.localUserData.ctrlBits & TankModel.RIGHT)))) >> 5));
                turretRotationDirAddition = (((this.localUserData.ctrlBits & TankModel.LEFT) >> 2) - ((this.localUserData.ctrlBits & TankModel.RIGHT) >> 3));
                if (turretRotationDir == 0)
                {
                    turretRotationDir = turretRotationDirAddition;
                }
                if (turretRotationDir == 1)
                {
                    controlBits = TankModel.TURRET_LEFT;
                }
                else
                {
                    if (turretRotationDir == -1)
                    {
                        controlBits = TankModel.TURRET_RIGHT;
                    }
                    else
                    {
                        if (((turretRotationDir == 0) && (!((this.localUserData.ctrlBits & TankModel.CENTER_TURRET) == 0))))
                        {
                            controlBits = TankModel.CENTER_TURRET;
                        }
                    }
                }
            }
            Network(Main.osgi.getService(INetworker)).send(((((((((((((("battle;move;" + ((((pos.x + "@") + pos.y) + "@") + pos.z)) + "@") + ((((orientation.x + "@") + orientation.y) + "@") + orientation.z)) + "@") + ((((linVel.x + "@") + linVel.y) + "@") + linVel.z)) + "@") + ((((angVel.x + "@") + angVel.y) + "@") + angVel.z)) + ";") + turretDir) + ";") + controlBits) + ";") + 1));
        }

        private function sendSuicideCommand(pos:Vector3, underZ:Boolean = false):void
        {
            if ((!(this.awaitingKillCommand)))
            {
                this.suicideTime = int.MAX_VALUE;
                this.awaitingKillCommand = true;
                this.suicideCommand(this.localUserData.user, DeathReason.SUICIDE, new Vector3d(pos.x, pos.y, pos.z), underZ);
            }
        }

        private function suicideCommand(user:ClientObject, reason:DeathReason, pos:Vector3d, underZ:Boolean):void
        {
            if(underZ){
                var ctfModel:CTFModel = CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase));
                if(ctfModel != null){
                    var flag:CTFFlag;
                    var tankData:TankData = this.getTankData(user);
                    if (ctfModel.flags != null)
                    {
                        for each (flag in ctfModel.flags)
                        {
                            if (((flag.state == CTFFlagState.CARRIED) && (flag.carrierId == user.id)))
                            {
                                Network(Main.osgi.getService(INetworker)).send("battle;suicide_flag");
                                break;
                            }
                        }
                    }
                }
            }
            if (suicideToGarage)
            {
                Network(Main.osgi.getService(INetworker)).send("battle;before_garage_change");
                setTimeout(function():void
                    {
                        Network(Main.osgi.getService(INetworker)).send("battle;suicide1");
                    }, 500);
                ILoaderWindowService(Main.osgi.getService(ILoaderWindowService)).unlockLoaderWindow();
                suicideToGarage = false;
            }
            else
            {
                Network(Main.osgi.getService(INetworker)).send("battle;suicide");
            }
        }

        private function checkIdleKick(deltaMillis:int):void
        {
            if (this.idleTime >= this.idleKickPeriod)
            {
                this.idleTimerEnabled = false;
                PanelModel(Main.osgi.getService(IPanel)).onExitFromBattle();
                var alert:Alert = new Alert();
                alert.showAlert("You have been kicked from the battle due to inactivity", [AlertAnswer.OK]);
                Main.cursorLayer.addChild(alert);
            }
            else
            {
                this.idleTime = (this.idleTime + deltaMillis);
            }
        }

        private function setSpawningState(tankData:TankData):void
        {
            tankData.spawnState = TankSpawnState.NEWCOME;
            tankData.tank.collisionGroup = CollisionGroup.TANK;
            tankData.tank.tracksCollisionGroup = CollisionGroup.INACTIVE_TRACK;
            tankData.tank.skin.hullMesh.visible = false;
            tankData.tank.skin.turretMesh.visible = false;
            tankData.tank.skin.hullObjects.visible = false;
            tankData.tank.skin.setAlpha(0, true);
            tankData.tank.title.sprite.visible = false;
            tankData.tank.postCollisionPredicate = IBodyCollisionPredicate(this.battlefield);
        }

        private function setTransparentState(tankData:TankData):void
        {
            tankData.tank.skin.setAlpha(1, true);
            tankData.tank.title.sprite.visible = true;
            tankData.tank.skin.hullMesh.visible = true;
            tankData.tank.skin.turretMesh.visible = true;
            tankData.tank.skin.hullObjects.visible = true;
            tankData.spawnState = TankSpawnState.NEWCOME;
            tankData.tank.collisionGroup = CollisionGroup.TANK;
            tankData.tank.tracksCollisionGroup = CollisionGroup.INACTIVE_TRACK;
            if (tankData.tank.skin.hullMesh.faces.length > 300)
            {
                tankData.tank.skin.hullMesh.alpha = 1;
            }
            else
            {
                tankData.tank.skin.hullMesh.alpha = 0.5;
            }
            if (tankData.tank.skin.turretMesh.faces.length > 300)
            {
                tankData.tank.skin.turretMesh.alpha = 1;
            }
            else
            {
                tankData.tank.skin.turretMesh.alpha = 0.5;
            }
            if (tankData.local)
            {
                // battlefield.setCameraTarget(null);
                battlefield.setCameraTarget(tankData.tank);
                tankData.tank.title.show();
                battlefield.followCameraController.activate(battlefield.bfData.viewport.camera);
                battlefield.followCameraController.setLocked(false);
                battlefield.followCameraController.initCameraComponents();
                battlefield.activeCameraController = battlefield.followCameraController;
            }
            tankData.tank.postCollisionPredicate = IBodyCollisionPredicate(this.battlefield);
        }

        private function setNormalState(tankData:TankData):void
        {
            tankData.tank.skin.setAlpha(1, true);
            tankData.tank.title.sprite.visible = true;
            tankData.tank.skin.hullMesh.visible = true;
            tankData.tank.skin.turretMesh.visible = true;
            tankData.tank.skin.hullObjects.visible = true;
            tankData.spawnState = TankSpawnState.ACTIVE;
            tankData.tank.collisionGroup = ((CollisionGroup.TANK | CollisionGroup.ACTIVE_TRACK) | CollisionGroup.WEAPON);
            if (tankData == TankData.localTankData)
            {
                tankData.tank.collisionGroup = (tankData.tank.collisionGroup | CollisionGroup.BONUS_WITH_TANK);
            }
            tankData.tank.tracksCollisionGroup = CollisionGroup.ACTIVE_TRACK;
            tankData.tank.skin.hullMesh.alpha = 1;
            tankData.tank.skin.turretMesh.alpha = 1;
            tankData.tank.postCollisionPredicate = null;
        }

        private function initTankColoring(objectsRegister:ObjectRegister, tankData:TankData, tankParts:TankParts):void
        {
            try
            {
                tankData.coloring = ((ResourceUtil.getResource(ResourceType.IMAGE, tankParts.coloringObjectId).bitmapData == null) ? new StubBitmapData(0xFF00FF) : ResourceUtil.getResource(ResourceType.IMAGE, tankParts.coloringObjectId).bitmapData);
            }
            catch (e:Error)
            {
                tankData.coloring = new StubBitmapData(0xFF00FF);
            }
        }

        public function onGameAction(param1:GameActionEnum, onDown:Boolean, param3:Boolean):void
        {
            // pause
            // trace(param1.name);
            if (param1 != GameActionEnum.BATTLE_PAUSE)
            {
                this.resume();
            }

            var k:int = undefined;
            switch (param1)
            {
                case GameActionEnum.ROTATE_TURRET_LEFT:
                case GameActionEnum.ROTATE_TURRET_LEFT_MOUSE:
                    if (param1 != GameActionEnum.ROTATE_TURRET_LEFT_MOUSE)
                    {
                        FollowCameraController.setFollowCameraMode(FollowCameraController.CAMERA_FOLLOWS_TURRET);
                    }
                    k = TankModel.TURRET_LEFT;
                    break;
                case GameActionEnum.ROTATE_TURRET_RIGHT:
                case GameActionEnum.ROTATE_TURRET_RIGHT_MOUSE:
                    if (param1 != GameActionEnum.ROTATE_TURRET_RIGHT_MOUSE)
                    {
                        FollowCameraController.setFollowCameraMode(FollowCameraController.CAMERA_FOLLOWS_TURRET);
                    }
                    k = TankModel.TURRET_RIGHT;
                    break;
                case GameActionEnum.CENTER_TURRET:
                    FollowCameraController.setFollowCameraMode(FollowCameraController.CAMERA_FOLLOWS_TURRET);
                    k = TankModel.CENTER_TURRET;
                    break;
                case GameActionEnum.BATTLE_PAUSE:
                    // if (this.paused)//currently removed the resume because right now when you press the pause button it and u release it it resumes the game by itself
                    // {
                    // this.resume();
                    // }
                    // else
                    // {
                    this.pause();
                    // }
                    break;
                case GameActionEnum.SUICIDE:
                    this.startSuicideCountdown();
                    break;
                case GameActionEnum.CHASSIS_FORWARD_MOVEMENT:
                    k = 1;
                    break;
                case GameActionEnum.CHASSIS_BACKWARD_MOVEMENT:
                    k = 2;
                    break;
                case GameActionEnum.CHASSIS_LEFT_MOVEMENT:
                    k = 4;
                    break;
                case GameActionEnum.CHASSIS_RIGHT_MOVEMENT:
                    k = 8;
            }
            if (k)
            {
                if (onDown)
                {
                    this.controlBits = (this.controlBits | int(k));
                }
                else
                {
                    if (k != CENTER_TURRET)
                    {
                        this.controlBits = (this.controlBits & (~(int(k))));
                    }
                }
            }
            if (this._userControlsEnabled)
            {
                this.applyControlState(this.localUserData, this.controlBits, (!(this.controlsLocked)));
            }
        }

        private function startSuicideCountdown():void
        {
            if ((((this._userControlsEnabled) && (!(this.awaitingKillCommand))) && (this.suicideTime == int.MAX_VALUE)))
            {
                this.suicideTime = (getTimer() + SUICIDE_DELAY);
                this.battlefield.showSuicideIndicator(SUICIDE_DELAY);
            }
        }

        public function startGarageSuicide():void
        {
            if ((((this._userControlsEnabled) && (!(this.awaitingKillCommand))) && (this.suicideTime == int.MAX_VALUE)))
            {
                this.suicideTime = (getTimer() + GARAGE_SUICIDE_DELAY);
                this.battlefield.showSuicideIndicator(GARAGE_SUICIDE_DELAY);
            }
            else
            {
                Network(Main.osgi.getService(INetworker)).send("battle;before_garage_change");
                Network(Main.osgi.getService(INetworker)).send("battle;suicide1");
                ILoaderWindowService(Main.osgi.getService(ILoaderWindowService)).unlockLoaderWindow();
                suicideToGarage = false;
            }
        }

        private function initKeyTable():void
        {
            var keyCode:int;
            var i:int;
            this.keyTableDown = new Dictionary();
            this.keyTableUp = new Dictionary();
            var keyBindings:Vector.<int> = Vector.<int>([Keyboard.UP, FORWARD, 87, FORWARD, Keyboard.DOWN, BACK, 83, BACK, Keyboard.LEFT, LEFT, 65, LEFT, Keyboard.RIGHT, RIGHT, 68, RIGHT, 90, TURRET_LEFT, 188, TURRET_LEFT, 88, TURRET_RIGHT, 190, TURRET_RIGHT]);
            var len:int = keyBindings.length;
            while (i < len)
            {
                keyCode = keyBindings[i];
                this.keyTableDown[keyCode] = (this.keyTableUp[keyCode] = keyBindings[int((i + 1))]);
                i = (i + 2);
            }
            this.keyTableDown[67] = CENTER_TURRET;
            this.keyTableDown[191] = CENTER_TURRET;
        }

        private function setTankHealth(tankData:TankData, health:int):void
        {
            tankData.health = health;
            tankData.tank.title.setHealth(health);
            var maxHealth:int = 10000;
            if (tankData.local)
            {
                this.inventoryModel.lockItem(InventoryItemType.FISRT_AID, InventoryLock.FORCED, (health >= maxHealth));
            }
        }

        private function setTankSpec(tankData:TankData, spec:TankSpecification, immediate:Boolean):void
        {
            tankData.tank.setMaxSpeed((spec.speed * 100), immediate);
            tankData.tank.setMaxTurnSpeed(spec.turnSpeed, true);
            tankData.tank.setMaxTurretTurnSpeed(spec.turretRotationSpeed, true);
        }

        private function setTankState(tankData:TankData, pos:Vector3d, orient:Vector3d, linVel:Vector3d, angVel:Vector3d, turretDir:Number, control:int, isControl:Boolean):void
        {
            if (((((!(pos == null)) && (!(orient == null))) && (!(linVel == null))) && (!(angVel == null))))
            {
                tankData.tank.setPhysicsState(pos, orient, linVel, angVel);
                if (control != -1)
                {
                    this.setControlState(tankData, control, isControl);
                }
                if (turretDir != -1)
                {
                    tankData.tank.turretDir = turretDir;
                    // if ((control & TankModel.MOUSE_CONTROL_BIT) != 0)
                    // {
                    // tankData.tank.mouseLookWorldDirection = turretDir;
                    // }
                    // else if (FollowCameraController.getFollowCameraMode() == FollowCameraController.CAMERA_FOLLOWS_TURRET)
                    // {
                    // tankData.tank.turretDir = turretDir;
                    // }
                }
            }
        }

        private function createTank(tankData:TankData, cl:TankParts):Tank
        {
            var HD_hull:Boolean = (!(cl.hullObjectId.indexOf("HD_") == -1));
            var HD_turret:Boolean = (!(cl.turretObjectId.indexOf("HD_") == -1));
            if (HD_hull)
            {
                cl.hullObjectId = cl.hullObjectId.replace("HD_", "");
            }
            if (HD_turret)
            {
                cl.turretObjectId = cl.turretObjectId.replace("HD_", "");
            }
            var hullDescriptor:TankSkinHull = new TankSkinHull(ResourceUtil.getResource(ResourceType.MODEL, cl.hullObjectId).mesh, this.v3dtov3(ResourceUtil.getResource(ResourceType.MODEL, cl.hullObjectId).turretMount), ResourceUtil.getResource(ResourceType.MODEL, cl.hullObjectId).objects);
            var obj:* = ResourceUtil.getResource(ResourceType.MODEL, cl.turretSkinId);
            var turretDescriptor:TankSkinTurret = new TankSkinTurret(ResourceUtil.getResource(ResourceType.MODEL, cl.turretSkinId).mesh, this.v3dtov3(ResourceUtil.getResource(ResourceType.MODEL, cl.turretSkinId).flagMount), this.v3dtov3(ResourceUtil.getResource(ResourceType.MODEL, cl.turretSkinId).muzzles[0]));
            var colormap:ImageResource = (ResourceUtil.getResource(ResourceType.IMAGE, cl.coloringObjectId) as ImageResource);
            if (colormap == null)
            {
                trace(("colormap null: " + cl.coloringObjectId));
                return (null);
            }
            var skin:TankSkin = new TankSkin(hullDescriptor, turretDescriptor, colormap, new BitmapData(100, 100), ((((!(!(HD_hull))) ? "HD_" : "") + cl.hullObjectId) + "_lightmap"), ((((!(!(HD_hull))) ? "HD_" : "") + cl.hullObjectId) + "_details"), ((((!(!(HD_turret))) ? "HD_" : "") + cl.turretSkinId) + "_lightmap"), ((((!(!(HD_turret))) ? "HD_" : "") + cl.turretSkinId) + "_details"), null);
            if (((((tankData == null) || (this.battlefield == null)) || (this.battlefield.getBattlefieldData() == null)) || (this.battlefield.getBattlefieldData().viewport == null)))
            {
                skin.destroy();
                skin = null;
                return (null);
            }
            var tank:Tank = new Tank(skin, tankData.mass, 1, 1, 1, 1, tankData.local, ((!(!(tankData.local))) ? this.battlefield.getBattlefieldData().viewport.getFrontContainer() : this.battlefield.getBattlefieldData().viewport.getMapContainer()));
            tank.tankData = tankData;
            tank.setTurretController(new DefaultTurretController(tankData));
            return (tank);
        }

        private function v3dtov3(src:Vector3D):Vector3
        {
            return (new Vector3(src.x, src.y, src.z));
        }

        private function setNormalTextures(tankData:TankData):void
        {
            tankData.tank.skin.setNormalState();
        }

        private function setDeadTextures(tankData:TankData):void
        {
            tankData.tank.skin.setDeadState();
        }

        public function applyControlState(tankData:TankData, ctrlBits:int, sendToServer:Boolean = true):void
        {
            var time:int;
            if (tankData.enabled && !(tankData.ctrlBits == ctrlBits) && !BattlefieldModel(Main.osgi.getService(IBattleField)).spectatorMode)
            {
                this.setControlState(tankData, ctrlBits);
                tankData.tank.getPhysicsState(this._pos3d, this._orient3d, this._linVel3d, this._angVel3d);
                time = getTimer();
                if (((sendToServer) || (tankData.tank.getTurretController() is ShaftTurretController)))
                {
                    this.moveCommand(this.localUserData.user, time, this._pos3d, this._orient3d, this._linVel3d, this._angVel3d, tankData.tank.turretDir, ctrlBits);
                    this.nextCorrectionTime = (time + CORRECTION_INTERVAL);
                }
            }
        }

        public function mandatoryUpdate():void
        {
            this.localUserData.tank.getPhysicsState(this._pos3d, this._orient3d, this._linVel3d, this._angVel3d);
            this.moveCommand(this.localUserData.user, this.battlefield.bfData.physTime, this._pos3d, this._orient3d, this._linVel3d, this._angVel3d, this.localUserData.tank.turretDir, this.localUserData.ctrlBits);
        }

        public function mandatoryUpdateCustomTurretDirection(turretDir:Number):void
        {
            this.localUserData.tank.getPhysicsState(this._pos3d, this._orient3d, this._linVel3d, this._angVel3d);
            this.moveCommand(this.localUserData.user, this.battlefield.bfData.physTime, this._pos3d, this._orient3d, this._linVel3d, this._angVel3d, turretDir, this.localUserData.ctrlBits);
        }

        public function setControlState(tankData:TankData, ctrlBits:int, forced:Boolean = false):void
        {
            var k:Number = NaN;
            if (((!(tankData)) || (!(tankData.enabled))))
            {
                return;
            }
            tankData.ctrlBits = ctrlBits;
            if (((this.controlsLocked) && (!(forced))))
            {
                return;
            }
            var moveDir:int = (int((!((ctrlBits & FORWARD) == 0))) - int((!((ctrlBits & BACK) == 0))));
            var turnDir:Number = (int((!((ctrlBits & LEFT) == 0))) - int((!((ctrlBits & RIGHT) == 0))));
            var tank:Tank = tankData.tank;
            if (tankData.tank != null)
            {
                tankData.tank.turnDirection = turnDir;
                tankData.tank.movementDirection = moveDir;
                if (moveDir != 0)
                {
                    tankData.sounds.setAccelerationMode();
                }
                else
                {
                    if (turnDir != 0)
                    {
                        tankData.sounds.setTurningMode();
                    }
                    else
                    {
                        tankData.sounds.setIdleMode();
                    }
                }
            }
            if(tankData != null && tankData.tank != null && tankData.tank.skin != null && tankData.tank.title != null){
                if (tankData.tank.skin.hullMesh.visible == false || tankData.tank.skin.turretMesh.visible == false || tankData.tank.title.sprite.visible == false || tankData.tank.skin.hullObjects.visible == false)
                {
                    tankData.tank.skin.setAlpha(1, true);
                    tankData.tank.title.sprite.visible = true;
                    tankData.tank.skin.hullMesh.visible = true;
                    tankData.tank.skin.turretMesh.visible = true;
                    tankData.tank.skin.hullObjects.visible = true;
                }
            }
        }

        private function updateUILock(lockCountDelta:int):void
        {
            this.uiControlLockCount = (this.uiControlLockCount + lockCountDelta);
            if (this.uiControlLockCount <= 0)
            {
                this.enableUserControls();
            }
            else
            {
                this.disableUserControls(false);
            }
        }

        private function setBackTurnMode():void
        {
            this.reverseBackTurn = this.panelModel.inverseBackDriving;
        }

        private function createTankSounds(soundScheme:TankSoundScheme):TankSounds
        {
            Logger.log("Creating tank sounds");
            var idleSound:Sound = (ResourceUtil.getResource(ResourceType.SOUND, "engineidle_sound").sound as Sound);
            var startMovingSound:Sound = (ResourceUtil.getResource(ResourceType.SOUND, "startmoving_sound").sound as Sound);
            var movingSound:Sound = (ResourceUtil.getResource(ResourceType.SOUND, "move_sound").sound as Sound);
            var turretSound:Sound = (ResourceUtil.getResource(ResourceType.SOUND, "turret_sound").sound as Sound);
            return (new TankSounds(null, null, idleSound, startMovingSound, movingSound, turretSound));
        }

        private function pause():void
        {
            if (!this.paused)
            {
                this.resetIdleTimer(false);
                this.paused = true;
                this.gui.showPauseIndicator(true);
            }
        }

        private function resume():void
        {
            this.resetIdleTimer(true);
            this.paused = false;
            this.gui.showPauseIndicator(false);
        }

        private function configureOtherTankTitles():void
        {
            var effects:Vector.<ClientBattleEffect>;
            var now:int;
            var effect:ClientBattleEffect;
            var delta:int;
            var duration:int;
            var otherTankData:* = null;
            var key:* = undefined;
            var bfData:BattlefieldData = this.battlefield.getBattlefieldData();
            for (otherTankData in bfData.activeTanks)
            {
                if (((!(otherTankData == this.localUserData)) || (!(otherTankData.local))))
                {
                    this.configureRemoteTankTitle(otherTankData);
                    effects = this.effectsModel.getInitialEffects(otherTankData.user.id);
                    if (effects != null)
                    {
                        now = getTimer();
                        for each (effect in effects)
                        {
                            delta = (now - effect.receiveTime);
                            duration = (effect.duration - delta);
                            if (duration > 0)
                            {
                                otherTankData.tank.title.showIndicator(effect.effectId, duration);
                            }
                        }
                    }
                }
            }
        }

        private function configureRemoteTankTitle(tankData:TankData):void
        {
            this.userTitlesRender.configurateTitle(tankData);
        }

        private function setTankTemperature(tank:Tank, temperature:Number):void
        {
            if (((tank == null) || (tank.skin == null)))
            {
                return;
            }
            tank.skin.targetColorTransformOffset = -(temperature);
        }

    }
}

import flash.utils.Dictionary;
import alternativa.tanks.vehicles.tanks.TankSkinHull;
import alternativa.resource.Tanks3DSResource;
import alternativa.tanks.vehicles.tanks.TankSkinTurret;

class HullsRegistry
{

    /*private*/ var hulls:Dictionary = new Dictionary();

    public function getHull(resource:Tanks3DSResource):TankSkinHull
    {
        var hull:TankSkinHull = this.hulls[resource.id];
        return (hull);
    }

}

class TurretsRegistry
{

    /*private*/ var turrets:Dictionary = new Dictionary();

    public function getTurret(resource:Tanks3DSResource):TankSkinTurret
    {
        var turret:TankSkinTurret = this.turrets[resource.id];
        return (turret);
    }

}

class TankPartsRegistry
{

    /*private*/ var hullsRegistry:HullsRegistry = new HullsRegistry();
    /*private*/ var turretsRegistry:TurretsRegistry = new TurretsRegistry();

    public function getHullDescriptor(resource:Tanks3DSResource):TankSkinHull
    {
        return (this.hullsRegistry.getHull(resource));
    }

    public function getTurretDescriptor(resource:Tanks3DSResource):TankSkinTurret
    {
        return (this.turretsRegistry.getTurret(resource));
    }

}
