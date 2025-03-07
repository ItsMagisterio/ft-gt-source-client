﻿package alternativa.tanks.models.battlefield.mine
{
    import com.alternativaplatform.projects.tanks.client.models.battlefield.mine.BattleMinesModelBase;
    import com.alternativaplatform.projects.tanks.client.models.battlefield.mine.IBattleMinesModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.tanks.models.battlefield.IBattlefieldPlugin;
    import alternativa.osgi.service.dump.dumper.IDumper;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.init.Main;
    import alternativa.console.ConsoleVarFloat;
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import alternativa.math.Vector3;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.ctf.CTFModel;
    import alternativa.tanks.models.dom.DOMModel;
    import alternativa.tanks.models.inventory.IInventory;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.tanks.models.battlefield.BattlefieldData;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import com.alternativaplatform.projects.tanks.client.models.battlefield.mine.BattleMine;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.tanks.engine3d.MaterialSequence;
    import flash.media.Sound;
    import alternativa.physics.collision.types.RayIntersection;
    import alternativa.physics.Contact;
    import alternativa.model.IModel;
    import alternativa.osgi.service.dump.IDumpService;
    import alternativa.service.IResourceService;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import alternativa.object.ClientObject;
    import alternativa.service.IModelService;
    import com.alternativaplatform.projects.tanks.client.models.ctf.ICaptureTheFlagModelBase;
    import alternativa.tanks.models.dom.IDOMModel;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.models.weapon.WeaponConst;
    import projects.tanks.client.battleservice.model.team.BattleTeamType;
    import alternativa.tanks.models.inventory.InventoryItemType;
    import alternativa.tanks.models.inventory.InventoryLock;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import alternativa.tanks.sfx.AnimatedSpriteEffect;
    import alternativa.engine3d.materials.Material;
    import alternativa.tanks.physics.CollisionGroup;
    import alternativa.engine3d.core.Sorting;
    import alternativa.physics.collision.primitives.CollisionBox;
    import alternativa.physics.collision.primitives.CollisionSphere;
    import alternativa.physics.collision.ICollisionDetector;
    import logic.resource.SoundResource;
    import alternativa.tanks.sfx.Sound3D;
    import alternativa.tanks.sfx.SoundOptions;
    import alternativa.tanks.sfx.Sound3DEffect;
    import flash.display.BitmapData;
    import logic.resource.images.ImageResource;
    import alternativa.resource.StubBitmapData;
    import alternativa.tanks.engine3d.MaterialType;
    import __AS3__.vec.*;

    public class BattleMinesModel extends BattleMinesModelBase implements IBattleMinesModelBase, IObjectLoadListener, IBattlefieldPlugin, IDumper
    {

        private static var objectPoolService:IObjectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
        private static const MAIN_EXPLOSION_FRAME_WIDTH:int = 300;
        private static const IDLE_EXPLOSION_FRAME_WIDTH:int = 100;
        private static const DECAL_RADIUS:Number = 200;
        private static var mainExplosionScale:ConsoleVarFloat = new ConsoleVarFloat("mine_main_scale", 3, 0.1, 10);
        private static var idleExplosionScale:ConsoleVarFloat = new ConsoleVarFloat("mine_idle_scale", 3, 0.1, 10);
        private static var mainExplosionFPS:ConsoleVarFloat = new ConsoleVarFloat("mine_main_fps", 30, 1, 50);
        private static var idleExplosionFPS:ConsoleVarFloat = new ConsoleVarFloat("mine_idle_fps", 30, 1, 50);
        private static var materialRegistry:IMaterialRegistry;
        private static const DECAL:Class = BattleMinesModel_DECAL;

        private const projectionOrigin:Vector3 = new Vector3();

        private var battlefieldModel:IBattleField;
        private var ctfModel:CTFModel;
        private var domModel:DOMModel;
        private var inventoryModel:IInventory;
        private var tankModel:ITank;
        private var bfData:BattlefieldData;
        private var mineModelData:MineModelData = new MineModelData();
        private var minesByUser:Dictionary = new Dictionary();
        private var minesOnFieldById:Dictionary = new Dictionary();
        private var mineProximityRadius:Number;
        private var deferredMines:Vector.<BattleMine>;
        private var redMineMaterial:TextureMaterial;
        private var blueMineMaterial:TextureMaterial;
        private var friendlyMineMaterial:TextureMaterial;
        private var enemyMineMaterial:TextureMaterial;
        private var referenceMesh:Mesh;
        private var mainExplosionSequence:MaterialSequence;
        private var mainExplosionFrameSize:FrameSize = new FrameSize();
        private var idleExplosionSequence:MaterialSequence;
        private var idleExplosionFrameSize:FrameSize = new FrameSize();
        private var mineArmedSound:Sound;
        private var explosionSound:Sound;
        private var deactivationSound:Sound;
        private var impactForce:Number;
        private var minDistanceFromBaseSquared:Number;
        private var rayDirection:Vector3 = new Vector3(0, 0, -1);
        private var intersection:RayIntersection = new RayIntersection();
        private var contact:Contact = new Contact(0);
        private var explosionMarkMaterial:TextureMaterial;

        public function BattleMinesModel()
        {
            _interfaces.push(IModel, IBattleMinesModelBase, IObjectLoadListener);
            MineExplosionCameraEffect.initVars();
            IDumpService(Main.osgi.getService(IDumpService)).registerDumper(this);
            this.explosionMarkMaterial = new TextureMaterial(new DECAL().bitmapData);
        }
        public function initObject(clientObject:ClientObject, activationSoundId:String, activationTimeMsec:int, blueMineTextureId:String, deactivationSoundId:String, enemyMineTextureId:String, explosionSoundId:String, farVisibilityRadius:Number, friendlyMineTextureId:String, idleExplosionTextureId:String, impactForce:Number, mainExplosionTextureId:String, minDistanceFromBase:Number, modelId:String, nearVisibilityRadius:Number, radius:Number, redMineTextureId:String):void
        {
            materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
            this.mineModelData.armingDuration = activationTimeMsec;
            this.mineModelData.armedFlashDuration = 100;
            this.mineModelData.armedFlashFadeDuration = 300;
            this.mineModelData.flashChannelOffset = 204;
            this.mineModelData.farRadius = (farVisibilityRadius * 100);
            this.mineModelData.nearRadius = (nearVisibilityRadius * 100);
            this.mineProximityRadius = (radius * 100);
            this.impactForce = impactForce;
            this.minDistanceFromBaseSquared = ((minDistanceFromBase * minDistanceFromBase) * 10000);
            var resourceService:IResourceService = IResourceService(Main.osgi.getService(IResourceService));
            this.mineArmedSound = this.getSound(activationSoundId, resourceService);
            this.explosionSound = this.getSound(explosionSoundId, resourceService);
            this.deactivationSound = this.getSound(deactivationSoundId, resourceService);
            this.initReferenceMesh(Mesh(ResourceUtil.getResource(ResourceType.MODEL, modelId).mesh));
            var initParams:InitParams = new InitParams(blueMineTextureId, redMineTextureId, enemyMineTextureId, friendlyMineTextureId, idleExplosionTextureId, mainExplosionTextureId);
            clientObject.putParams(BattleMinesModel, initParams);
        }
        public function initMines(clientObject:ClientObject, mines:Array):void
        {
            if (mines != null)
            {
                this.deferredMines = Vector.<BattleMine>(mines);
            }
        }
        public function objectLoaded(clientObject:ClientObject):void
        {
            var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
            this.battlefieldModel = IBattleField(modelService.getModelsByInterface(IBattleField)[0]);
            this.ctfModel = CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase));
            this.domModel = DOMModel(Main.osgi.getService(IDOMModel));
            this.inventoryModel = IInventory(modelService.getModelsByInterface(IInventory)[0]);
            this.tankModel = ITank(modelService.getModelsByInterface(ITank)[0]);
            this.bfData = this.battlefieldModel.getBattlefieldData();
            this.battlefieldModel.addPlugin(this);
            var resourceService:IResourceService = IResourceService(Main.osgi.getService(IResourceService));
            var initParams:InitParams = InitParams(clientObject.getParams(BattleMinesModel));
            var mipMapResolution:Number = 1;
            this.mainExplosionSequence = this.getExplosionMaterialSequence(initParams.mainExplosionTextureId, MAIN_EXPLOSION_FRAME_WIDTH, mipMapResolution, resourceService, this.mainExplosionFrameSize);
            this.idleExplosionSequence = this.getExplosionMaterialSequence(initParams.idleExplosionTextureId, IDLE_EXPLOSION_FRAME_WIDTH, mipMapResolution, resourceService, this.idleExplosionFrameSize);
            this.redMineMaterial = this.getTextureMaterial(initParams.redMineTextureId, mipMapResolution, resourceService);
            this.blueMineMaterial = this.getTextureMaterial(initParams.blueMineTextureId, mipMapResolution, resourceService);
            this.friendlyMineMaterial = this.getTextureMaterial(initParams.friendlyMineTextureId, mipMapResolution, resourceService);
            this.enemyMineMaterial = this.getTextureMaterial(initParams.enemyMineTextureId, mipMapResolution, resourceService);
            var bfModel:BattlefieldModel = BattlefieldModel(Main.osgi.getService(IBattleField));
            /* if (bfModel.blacklist.indexOf(this.redMineMaterial.getTextureResource()) == -1){
                bfModel.blacklist.push(this.redMineMaterial.getTextureResource());
            }
            if (bfModel.blacklist.indexOf(this.blueMineMaterial.getTextureResource()) == -1){
                bfModel.blacklist.push(this.blueMineMaterial.getTextureResource());
            }
            if (bfModel.blacklist.indexOf(this.friendlyMineMaterial.getTextureResource()) == -1){
                bfModel.blacklist.push(this.friendlyMineMaterial.getTextureResource());
            }
            if (bfModel.blacklist.indexOf(this.enemyMineMaterial.getTextureResource()) == -1){
                bfModel.blacklist.push(this.enemyMineMaterial.getTextureResource());
            }*/
        }
        public function objectUnloaded(clientObject:ClientObject):void
        {
            this.removeAllMines();
            this.battlefieldModel.removePlugin(this);
            this.battlefieldModel = null;
            this.ctfModel = null;
            this.domModel = null;
            this.tankModel = null;
            this.inventoryModel = null;
            this.bfData = null;
            this.mineArmedSound = null;
            this.mainExplosionSequence = null;
            this.idleExplosionSequence = null;
            this.redMineMaterial = null;
            this.blueMineMaterial = null;
            this.friendlyMineMaterial = null;
            this.enemyMineMaterial = null;
        }
        public function putMine(clientObject:ClientObject, id:String, x:Number, y:Number, z:Number, userId:String):void
        {
            var ownerData:TankData;
            var pos:Vector3;
            var ownerObject:ClientObject = clientObject;
            if (ownerObject != null)
            {
                ownerData = this.tankModel.getTankData(ownerObject);
            }
            if (((ownerData == null) || (ownerData.tank == null)))
            {
                if (this.deferredMines == null)
                {
                    this.deferredMines = new Vector.<BattleMine>();
                }
                this.deferredMines.push(new BattleMine(false, id, userId, x, y, z));
            }
            else
            {
                pos = new Vector3(x, y, z);
                this.addMine(id, this.mineProximityRadius, pos, userId, ownerData.teamType, this.getMineMaterial(ownerData), false);
            }
        }
        public function activateMine(clientObject:ClientObject, id:String):void
        {
            var battleMine:BattleMine;
            var mine:ProximityMine = this.minesOnFieldById[id];
            if (mine != null)
            {
                mine.arm();
                this.addSound3DEffect(this.mineArmedSound, mine.position, 0.3);
            }
            else
            {
                for each (battleMine in this.deferredMines)
                {
                    if (battleMine.mineId == id)
                    {
                        battleMine.activated = true;
                        return;
                    }
                }
            }
        }
        public function removeMines(clientObject:ClientObject, ownerId:String):void
        {
            var currMine:ProximityMine;
            var userMines:UserMinesList = this.minesByUser[ownerId];
            if (userMines == null)
            {
                return;
            }
            var mine:ProximityMine = userMines.head;
            while (mine != null)
            {
                currMine = mine;
                mine = mine.next;
                this.addExplosionEffect(currMine.position, this.idleExplosionSequence.materials, this.idleExplosionFrameSize, idleExplosionScale.value, idleExplosionFPS.value, 0.5, 0.9);
                this.addSound3DEffect(this.deactivationSound, currMine.position, 0.1);
                this.removeMine(currMine, userMines);
            }
        }
        public function explodeMine(clientObject:ClientObject, id:String, userId:String):void
        {
            var tankData:TankData;
            var mine:ProximityMine = this.minesOnFieldById[id];
            if (mine == null)
            {
                return;
            }
            var userMines:UserMinesList = this.minesByUser[mine.ownerId];
            if (userMines == null)
            {
                return;
            }
            this.addExplosionEffect(mine.position, this.mainExplosionSequence.materials, this.mainExplosionFrameSize, mainExplosionScale.value, mainExplosionFPS.value, 0.5, 0.772);
            this.addSound3DEffect(this.explosionSound, mine.position, 0.5);
            this.addExplosionDecal(mine);
            var userObject:ClientObject = clientObject;
            if (userObject != null)
            {
                tankData = this.tankModel.getTankData(userObject);
                if (((!(tankData == null)) && (!(tankData.tank == null))))
                {
                    tankData.tank.addWorldForceScaled(mine.position, mine.normal, (WeaponConst.BASE_IMPACT_FORCE * this.impactForce));
                }
            }
            this.removeMine(mine, userMines);
        }
        private function addExplosionDecal(mine:ProximityMine):void
        {
            this.projectionOrigin.vCopy(mine.position);
            this.projectionOrigin.vAddScaled(100, mine.normal);
            this.battlefieldModel.addDecal(mine.position, this.projectionOrigin, DECAL_RADIUS, this.explosionMarkMaterial);
        }
        public function get battlefieldPluginName():String
        {
            return ("mines");
        }
        public function startBattle():void
        {
        }
        public function restartBattle():void
        {
        }
        public function finishBattle():void
        {
            this.removeAllMines();
        }
        public function tick(param1:int, param2:int, param3:Number, param4:Number):void
        {
            var _loc6_:* = undefined;
            var _loc7_:UserMinesList;
            var _loc8_:ProximityMine;
            var _loc9_:ProximityMine;
            var _loc10_:Vector3;
            var _loc11_:Vector3;
            var _loc12_:Boolean;
            var _loc5_:TankData = TankData.localTankData;
            for (_loc6_ in this.minesByUser)
            {
                _loc7_ = this.minesByUser[_loc6_];
                _loc8_ = _loc7_.head;
                while (_loc8_ != null)
                {
                    _loc9_ = _loc8_;
                    _loc8_ = _loc8_.next;
                    if (_loc5_ != null)
                    {
                        if ((((_loc9_.canExplode(_loc5_)) && (!(_loc9_.hitCommandSent))) && (this.mineIntersects(_loc9_, _loc5_, this.bfData.collisionDetector, this.contact))))
                        {
                            _loc9_.hitCommandSent = true;
                            _loc10_ = _loc5_.tank.state.pos;
                            this.hitCommand(this.bfData.bfObject, _loc9_.id, _loc10_.x, _loc10_.y, _loc10_.z);
                        }
                    }
                    _loc9_.update(param1, param2, _loc5_);
                }
            }
            if ((((!(this.ctfModel == null)) && (!(_loc5_ == null))) && (_loc5_.enabled)))
            {
                _loc11_ = _loc5_.tank.state.pos;
                _loc12_ = ((this.ctfModel.isPositionInFlagProximity(_loc11_, this.minDistanceFromBaseSquared, BattleTeamType.BLUE)) || (this.ctfModel.isPositionInFlagProximity(_loc11_, this.minDistanceFromBaseSquared, BattleTeamType.RED)));
                this.inventoryModel.lockItem(InventoryItemType.MINE, InventoryLock.FORCED, _loc12_);
            }
            if ((((!(this.domModel == null)) && (!(_loc5_ == null))) && (_loc5_.enabled)))
            {
                _loc11_ = _loc5_.tank.state.pos;
                _loc12_ = this.domModel.isPositionInPointProximity(_loc11_, this.minDistanceFromBaseSquared);
                this.inventoryModel.lockItem(InventoryItemType.MINE, InventoryLock.FORCED, _loc12_);
            }
        }
        private function hitCommand(bfObject:ClientObject, mineId:String, x:Number, y:Number, z:Number):void
        {
            Network(Main.osgi.getService(INetworker)).send(("battle;mine_hit;" + mineId));
        }
        public function addUser(clientObject:ClientObject):void
        {
        }
        public function removeUser(clientObject:ClientObject):void
        {
        }
        public function addUserToField(clientObject:ClientObject):void
        {
            var battleMine:BattleMine;
            var i:int;
            var pos:Vector3;
            var ownerObject:ClientObject;
            var ownerTankData:TankData;
            var tankData:TankData = this.tankModel.getTankData(clientObject);
            if (tankData.local)
            {
                if (this.deferredMines != null)
                {
                    i = 0;
                    while (i < this.deferredMines.length)
                    {
                        battleMine = this.deferredMines[i];
                        ownerObject = clientObject;
                        if (ownerObject != null)
                        {
                            ownerTankData = this.tankModel.getTankData(ownerObject);
                            if (((!(ownerTankData == null)) && (!(ownerTankData.tank == null))))
                            {
                                this.deferredMines.splice(i, 1);
                                i--;
                                pos = new Vector3(battleMine.x, battleMine.y, battleMine.z);
                                this.addMine(battleMine.mineId, this.mineProximityRadius, pos, battleMine.ownerId, ownerTankData.teamType, this.getMineMaterial(ownerTankData), battleMine.activated);
                            }
                        }
                        i++;
                    }
                }
            }
            else
            {
                if (this.deferredMines != null)
                {
                    i = 0;
                    while (i < this.deferredMines.length)
                    {
                        battleMine = this.deferredMines[i];
                        if (battleMine.ownerId == clientObject.id)
                        {
                            this.deferredMines.splice(i, 1);
                            i--;
                            pos = new Vector3(battleMine.x, battleMine.y, battleMine.z);
                            this.addMine(battleMine.mineId, this.mineProximityRadius, pos, battleMine.ownerId, tankData.teamType, this.getMineMaterial(tankData), battleMine.activated);
                        }
                        i++;
                    }
                }
            }
        }
        public function removeUserFromField(clientObject:ClientObject):void
        {
        }
        public function get dumperName():String
        {
            return ("mines");
        }
        public function dump(params:Vector.<String>):String
        {
            var mine:ProximityMine;
            var result:String = "=== Mines ===\n";
            if (this.deferredMines != null)
            {
                result = (result + (("Deferred:\n" + this.deferredMines.join("\n")) + "\n"));
            }
            result = (result + "On field:\n");
            for each (mine in this.minesOnFieldById)
            {
                result = (result + (mine + "\n"));
            }
            return (result);
        }
        private function addExplosionEffect(position:Vector3, materials:Vector.<Material>, frameSize:FrameSize, scale:Number, fps:Number, originX:Number, originY:Number):void
        {
            var explosion:AnimatedSpriteEffect = AnimatedSpriteEffect(objectPoolService.objectPool.getObject(AnimatedSpriteEffect));
            explosion.init((scale * frameSize.width), (scale * frameSize.height), materials, position, 0, 50, fps, false, originX, originY);
            this.battlefieldModel.addGraphicEffect(explosion);
        }
        private function addMine(mineId:String, proximityRadius:Number, position:Vector3, ownerId:String, teamType:BattleTeamType, material:Material, armed:Boolean):void
        {
            if ((!(this.bfData.collisionDetector.intersectRayWithStatic(position, this.rayDirection, CollisionGroup.STATIC, 10000000000, null, this.intersection))))
            {
                return;
            }
            var userMines:UserMinesList = this.minesByUser[ownerId];
            if (userMines == null)
            {
                userMines = new UserMinesList();
                this.minesByUser[ownerId] = userMines;
            }
            var mine:ProximityMine = ProximityMine.create(mineId, ownerId, proximityRadius, this.referenceMesh, material, teamType, this.mineModelData);
            userMines.addMine(mine);
            this.minesOnFieldById[mineId] = mine;
            mine.setPosition(this.intersection.pos, this.intersection.normal);
            mine.addToContainer(this.bfData.viewport.getMapContainer());
            if (armed)
            {
                mine.arm();
            }
        }
        private function removeAllMines():void
        {
            var key:* = undefined;
            var userMines:UserMinesList;
            for (key in this.minesByUser)
            {
                userMines = this.minesByUser[key];
                userMines.clearMines();
                delete this.minesByUser[key];
            }
            for (key in this.minesOnFieldById)
            {
                delete this.minesOnFieldById[key];
            }
            this.deferredMines = null;
        }
        private function initReferenceMesh(resourse:Mesh):void
        {
            this.referenceMesh = resourse;
            if (this.referenceMesh.sorting != Sorting.DYNAMIC_BSP)
            {
                this.referenceMesh.sorting = Sorting.DYNAMIC_BSP;
                this.referenceMesh.calculateFacesNormals(true);
                this.referenceMesh.optimizeForDynamicBSP();
            }
        }
        private function mineIntersects(mine:ProximityMine, tankData:TankData, collisionDetector:ICollisionDetector, contact:Contact):Boolean
        {
            if (tankData.tank == null)
            {
                return (false);
            }
            var cb:CollisionBox = tankData.tank.mainCollisionBox;
            var mcp:CollisionSphere = CollisionSphere(mine.collisionPrimitive);
            return (collisionDetector.getContact(cb, mcp, contact));
        }
        private function removeMine(mine:ProximityMine, userMines:UserMinesList):void
        {
            delete this.minesOnFieldById[mine.id];
            userMines.removeMine(mine);
        }
        private function getSound(soundResourceId:String, resourceService:IResourceService):Sound
        {
            if (soundResourceId == null)
            {
                return (null);
            }
            var soundResource:SoundResource = (ResourceUtil.getResource(ResourceType.SOUND, soundResourceId) as SoundResource);
            if (soundResource == null)
            {
                return (null);
            }
            return (soundResource.sound);
        }
        private function addSound3DEffect(sound:Sound, position:Vector3, volume:Number):void
        {
            if (sound == null)
            {
                return;
            }
            var sound3d:Sound3D = Sound3D.create(sound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, volume);
            this.battlefieldModel.addSound3DEffect(Sound3DEffect.create(objectPoolService.objectPool, null, position, sound3d, 0));
        }
        private function getExplosionMaterialSequence(resourceId:String, frameWidth:int, mipMapResolution:Number, resourceService:IResourceService, frameSize:FrameSize):MaterialSequence
        {
            var texture:BitmapData;
            var imageResource:ImageResource;
            if (resourceId != null)
            {
                imageResource = (ResourceUtil.getResource(ResourceType.IMAGE, resourceId) as ImageResource);
                if (imageResource != null)
                {
                    texture = (imageResource.bitmapData as BitmapData);
                }
            }
            if (texture == null)
            {
                texture = new StubBitmapData(0xFF0000);
                frameWidth = texture.width;
            }
            frameSize.width = frameWidth;
            frameSize.height = texture.height;
            return (materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT, texture, frameWidth, mipMapResolution));
        }
        private function getTextureMaterial(resourceId:String, mipMapResolution:Number, resourceRegister:IResourceService):TextureMaterial
        {
            var texture:BitmapData;
            var imageResource:ImageResource;
            if (resourceId != null)
            {
                imageResource = (ResourceUtil.getResource(ResourceType.IMAGE, resourceId) as ImageResource);
                if (imageResource != null)
                {
                    texture = (imageResource.bitmapData as BitmapData);
                }
            }
            if (texture == null)
            {
                texture = new StubBitmapData(0xFF0000);
            }
            return (materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT, texture, mipMapResolution, false));
        }
        private function getMineMaterial(ownerData:TankData):Material
        {
            switch (ownerData.teamType)
            {
                case BattleTeamType.NONE:
                    return ((ownerData == TankData.localTankData) ? this.friendlyMineMaterial : this.enemyMineMaterial);
                case BattleTeamType.BLUE:
                    return (this.blueMineMaterial);
                case BattleTeamType.RED:
                    return (this.redMineMaterial);
                default:
                    return (this.enemyMineMaterial);
            }
        }

    }
}

class InitParams
{

    public var blueMineTextureId:String;
    public var redMineTextureId:String;
    public var enemyMineTextureId:String;
    public var friendlyMineTextureId:String;
    public var idleExplosionTextureId:String;
    public var mainExplosionTextureId:String;

    public function InitParams(blueMineTextureId:String, redMineTextureId:String, enemyMineTextureId:String, friendlyMineTextureId:String, idleExplosionTextureId:String, mainExplosionTextureId:String)
    {
        this.blueMineTextureId = blueMineTextureId;
        this.redMineTextureId = redMineTextureId;
        this.enemyMineTextureId = enemyMineTextureId;
        this.friendlyMineTextureId = friendlyMineTextureId;
        this.idleExplosionTextureId = idleExplosionTextureId;
        this.mainExplosionTextureId = mainExplosionTextureId;
    }
}

class FrameSize
{

    public var width:int;
    public var height:int;

}
