﻿package alternativa.tanks.models.dom
{
    import alternativa.model.IObjectLoadListener;
    import alternativa.tanks.models.battlefield.IBattlefieldPlugin;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.tanks.models.tank.TankData;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.tanks.models.dom.sfx.BeamEffects;
    import alternativa.tanks.models.dom.sfx.AllBeamProperties;
    import alternativa.tanks.models.dom.hud.KeyPointMarkers;
    import alternativa.tanks.models.battlefield.BattlefieldData;
    import flash.media.Sound;
    import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
    import alternativa.tanks.models.dom.cp.ControlPointMarkers;
    import alternativa.tanks.models.dom.hud.panel.KeyPointsHUDPanel;
    import alternativa.init.Main;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.battlefield.IBattleField;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import alternativa.tanks.models.dom.server.DOMPointData;
    import alternativa.engine3d.core.Object3D;
    import alternativa.math.Vector3;
    import alternativa.tanks.models.dom.hud.KeyPointMarker;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.engine3d.objects.BSP;
    import flash.display.BitmapData;
    import alternativa.resource.StubBitmapData;
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import alternativa.tanks.engine3d.MaterialType;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.tanks.models.dom.sfx.DominationBeamEffect;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import alternativa.tanks.sfx.ISound3DEffect;
    import alternativa.tanks.sfx.Sound3D;
    import alternativa.tanks.sfx.SoundOptions;
    import alternativa.tanks.sfx.Sound3DEffect;
    import alternativa.object.ClientObject;
    import __AS3__.vec.*;
    import utils.TextUtils;

    public class DOMModel implements IDOMModel, IObjectLoadListener, IBattlefieldPlugin
    {

        private static var objectPoolService:IObjectPoolService;
        public static var userTankData:TankData;

        private var points:Vector.<Point>;
        private var pointsById:Dictionary = new Dictionary();
        private var tanksInBattle:Dictionary = new Dictionary();
        private var tankModel:ITank;
        private var battlefieldModel:BattlefieldModel;
        private var beamEffects:BeamEffects;
        private var allBeamProperties:AllBeamProperties = new AllBeamProperties(null);
        private var pointHuds:KeyPointMarkers;
        private var bfData:BattlefieldData;
        private var startCapturingSound:Sound;
        private var stopCapturingSound:Sound;
        private var pointCapturedSound:Sound;
        private var enemyPointCapturedSound:Sound;
        private var enemyLostPointSound:Sound;
        private var lostPointSound:Sound;
        private var guiModel:IBattlefieldGUI;
        private var pointMarkers:Vector.<ControlPointMarkers> = new Vector.<ControlPointMarkers>();
        private var pointHUD:Vector.<KeyPointsHUDPanel> = new Vector.<KeyPointsHUDPanel>();

        public function DOMModel()
        {
            this.points = new Vector.<Point>();
            objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
            var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
            this.battlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            this.guiModel = (Main.osgi.getService(IBattlefieldGUI) as IBattlefieldGUI);
            this.battlefieldModel.addPlugin(this);
            this.bfData = this.battlefieldModel.getBattlefieldData();
            this.tankModel = ITank(modelService.getModelsByInterface(ITank)[0]);
            this.beamEffects = new BeamEffects(this.battlefieldModel);
            this.pointHuds = new KeyPointMarkers(this.battlefieldModel.bfData.viewport.camera, this.battlefieldModel);
            this.startCapturingSound = (ResourceUtil.getResource(ResourceType.SOUND, "startCapturingSound").sound as Sound);
            this.stopCapturingSound = (ResourceUtil.getResource(ResourceType.SOUND, "stopCapturingSound").sound as Sound);
            this.pointCapturedSound = (ResourceUtil.getResource(ResourceType.SOUND, "pointCapturedSound").sound as Sound);
            this.enemyPointCapturedSound = (ResourceUtil.getResource(ResourceType.SOUND, "enemy_PointCapturedSound").sound as Sound);
            this.enemyLostPointSound = (ResourceUtil.getResource(ResourceType.SOUND, "enemy_LostPointSound").sound as Sound);
            this.lostPointSound = (ResourceUtil.getResource(ResourceType.SOUND, "lostPointSound").sound as Sound);
        }
        public function initObject(points:Vector.<DOMPointData>):void
        {
            var data:DOMPointData;
            var point:Point;
            var userId:String;
            var progress:int;
            var pedestal:Object3D;
            var pos:Vector3;
            var pointMark:ControlPointMarkers;
            var _loc1_:Vector.<Point> = new Vector.<Point>();
            for each (data in points)
            {
                var pointPosition = new Vector3(data.pos.x, data.pos.y, data.pos.z + 300);
                point = new Point(data.id, pointPosition, data.radius, this);
                this.points.push(point);
                this.pointHuds.addMarker(new KeyPointMarker(point));
                this.pointsById[point.id] = point;
                _loc1_.push(point);
                this.serverSetPointScore(point.id, data.score);
                for each (userId in data.occupatedUsers)
                {
                    this.serverTankCapturingPoint(point.id, BattleController.activeTanks[userId]);
                }
                progress = point.clientProgress;
                pedestal = this.createPedestal("dom_pedestal", ((progress <= -100) ? "pedestalRC" : ((progress >= 100) ? "pedestalBC" : "pedestalNC")));
                pos = data.pos.vClone();
                pedestal.x = pos.x;
                pedestal.y = pos.y;
                pedestal.z = pos.z;
                point.pedestal = pedestal;
                this.bfData.viewport.getMapContainer().addChild(pedestal);
                pointMark = new ControlPointMarkers(this.battlefieldModel, pos, point);
                this.pointMarkers.push(pointMark);
            }
            this.guiModel.createPointsHUD(new KeyPointsHUDPanel(_loc1_));
        }
        private function createPedestalBlue():Object3D
        {
            return (this.createPedestal("dom_pedestal", "pedestalBC"));
        }
        private function createPedestalRed():Object3D
        {
            return (this.createPedestal("dom_pedestal", "pedestalRC"));
        }
        private function createPedestalNone():Object3D
        {
            return (this.createPedestal("dom_pedestal", "pedestalNC"));
        }
        private function createPedestal(resourceId:String, resourceImageId:String):Object3D
        {
            var object:Mesh = ResourceUtil.getResource(ResourceType.MODEL, resourceId).mesh;
            var pedestal:BSP = new BSP();
            pedestal.createTree(object);
            var texture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, resourceImageId).bitmapData;
            if (texture == null)
            {
                texture = new StubBitmapData(0xFFFF00);
            }
            var resolution:Number = pedestal.calculateResolution(texture.width, texture.height);
            var material:TextureMaterial = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry)).textureMaterialRegistry.getMaterial(MaterialType.EFFECT, texture, resolution, false);
            pedestal.setMaterialToAllFaces(material);
            return (pedestal);
        }
        public function tankCapturingPoint(point:Point, tankData:TankData):void
        {
            var effect:DominationBeamEffect = DominationBeamEffect(objectPoolService.objectPool.getObject(DominationBeamEffect));
            var pointPos:Vector3 = new Vector3();
            point.readPos(pointPos);
            effect.init(tankData.tank.skin.turretMesh, pointPos, this.allBeamProperties.getBeamProperties(tankData.teamType), new Dictionary());
            this.beamEffects.addEffect(tankData.user, effect);
            this.playSoundEffect(this.startCapturingSound, point);
            Network(Main.osgi.getService(INetworker)).send(((("battle;tank_capturing_point;" + TextUtils.getAlphabetByInt(point.id)) + ";") + this.getPositionString(tankData.tank.state.pos)));
            trace("battle;tank_capturing_point;" + TextUtils.getAlphabetByInt(point.id) + ";");
        }
        public function playSoundEffect(effectSound:Sound, point:Point):void
        {
            var soundEffect:ISound3DEffect = this.createSoundEffect(effectSound, point);
            if (soundEffect != null)
            {
                this.battlefieldModel.addSound3DEffect(soundEffect);
            }
        }
        private function createSoundEffect(effectSound:Sound, point:Point):ISound3DEffect
        {
            var sound:Sound3D = Sound3D.create(effectSound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, 1.5);
            return (Sound3DEffect.create(objectPoolService.objectPool, null, point.pos, sound));
        }
        public function tankLeaveCapturingPoint(point:Point, tank:TankData):void
        {
            this.beamEffects.removeEffect(tank.user);
            this.playSoundEffect(this.stopCapturingSound, point);
            Network(Main.osgi.getService(INetworker)).send(("battle;tank_leave_capturing_point;" + TextUtils.getAlphabetByInt(point.id)));
            trace("battle;tank_leave_capturing_point;" + TextUtils.getAlphabetByInt(point.id));
        }
        public function serverSetPointScore(pointId:int, score:int):void
        {
            var point:Point = this.pointsById[pointId];
            point.clientProgress = score;
            if (score == 0)
            {
                this.updatePedestal(pointId, "none");
            }
        }
        public function serverPointCapturedBy(team:String, pointId:int):void
        {
            this.guiModel.logUserAction(null, ((((team == "blue") ? "Blue" : "Red") + " captured the point ") + ((pointId == 0) ? "A" : ((pointId == 1) ? "B" : ((pointId == 2) ? "C" : ((pointId == 3) ? "D" : ((pointId == 4) ? "E" : ((pointId == 5) ? "F" : "G"))))))), null);
            this.battlefieldModel.messages.addMessage(((team == "blue") ? 4691967 : 15741974), ((((team == "blue") ? "Blue" : "Red") + " captured the point ") + ((pointId == 0) ? "A" : ((pointId == 1) ? "B" : ((pointId == 2) ? "C" : ((pointId == 3) ? "D" : ((pointId == 4) ? "E" : ((pointId == 5) ? "F" : "G"))))))));
            this.updatePedestal(pointId, team);
            if (userTankData == null)
            {
                return;
            }
            var point:Point = this.pointsById[pointId];
            if (userTankData.teamType.getValue() == team.toUpperCase())
            {
                this.playSoundEffect(this.pointCapturedSound, point);
            }
            else
            {
                this.playSoundEffect(this.enemyPointCapturedSound, point);
            }
        }
        public function serverPointLostBy(team:String, pointId:int):void
        {
            this.guiModel.logUserAction(null, ((((team == "blue") ? "Blue" : "Red") + " lost control of the point ") + ((pointId == 0) ? "A" : ((pointId == 1) ? "B" : ((pointId == 2) ? "C" : ((pointId == 3) ? "D" : ((pointId == 4) ? "E" : ((pointId == 5) ? "F" : "G"))))))), null);
            this.battlefieldModel.messages.addMessage(((team == "blue") ? 15741974 : 4691967), ((((team == "blue") ? "Blue" : "Red") + " lost control of the point ") + ((pointId == 0) ? "A" : ((pointId == 1) ? "B" : ((pointId == 2) ? "C" : ((pointId == 3) ? "D" : ((pointId == 4) ? "E" : ((pointId == 5) ? "F" : "G"))))))));
            this.updatePedestal(pointId, "none");
            if (userTankData == null)
            {
                return;
            }
            var point:Point = this.pointsById[pointId];
            if (userTankData.teamType.getValue() == team.toUpperCase())
            {
                this.playSoundEffect(this.lostPointSound, point);
            }
            else
            {
                this.playSoundEffect(this.enemyLostPointSound, point);
            }
        }
        public function updatePedestal(pointId:int, team:String):void
        {
            var pos:Vector3;
            var point:Point = this.pointsById[pointId];
            var pedestal:Object3D = ((team == "blue") ? this.createPedestalBlue() : ((team == "red") ? this.createPedestalRed() : this.createPedestalNone()));
            if (((!(point.pedestal == null)) && (!(point.pedestal == pedestal))))
            {
                this.bfData.viewport.getMapContainer().removeChild(point.pedestal);
                pos = point.pos;
                pedestal.x = pos.x;
                pedestal.y = pos.y;
                pedestal.z = pos.z - 300;
                point.pedestal = pedestal;
                this.bfData.viewport.getMapContainer().addChild(pedestal);
            }
        }
        public function serverTankCapturingPoint(pointId:int, tank:ClientObject):void
        {
            var point:Point = this.pointsById[pointId];
            var tankData:TankData = this.tankModel.getTankData(tank);
            if (tankData == null)
            {
                return;
            }
            var effect:DominationBeamEffect = DominationBeamEffect(objectPoolService.objectPool.getObject(DominationBeamEffect));
            var pointPos:Vector3 = new Vector3();
            point.readPos(pointPos);
            effect.init(tankData.tank.skin.turretMesh, pointPos, this.allBeamProperties.getBeamProperties(tankData.teamType), new Dictionary());
            this.beamEffects.addEffect(tankData.user, effect);
            this.playSoundEffect(this.startCapturingSound, point);
        }
        public function serverTankLeaveCapturingPoint(tank:ClientObject, pointId:int):void
        {
            var point:Point = this.pointsById[pointId];
            this.playSoundEffect(this.stopCapturingSound, point);
            this.beamEffects.removeEffect(tank);
        }
        public function serverRemoveAllCapturingPoints():void
        {
            this.beamEffects.removeAllEffects();
        }
        private function getPositionString(vector:Vector3):String
        {
            return ((((vector.x + ";") + vector.y) + ";") + vector.z);
        }
        public function isPositionInPointProximity(position:Vector3, distanceSquared:Number):Boolean
        {
            var point:Point;
            var minDist:Number;
            var distance:Number;
            var distances:Array = new Array();
            for each (point in this.points)
            {
                distance = point.pos.distanceToSquared(position);
                distances[point.id] = distance;
            }
            minDist = Math.min.apply(null, distances);
            return (minDist < distanceSquared);
        }
        public function tick(time:int, deltaMsec:int, deltaSec:Number, interpolationCoeff:Number):void
        {
            var point:Point;
            var marker:ControlPointMarkers;
            for each (point in this.points)
            {
                point.tick(time, deltaMsec, deltaSec, interpolationCoeff);
            }
            this.pointHuds.render(time, deltaMsec);
            marker = null;
            for each (marker in this.pointMarkers)
            {
                marker.tick();
            }
            this.guiModel.updatePointsHUD();
        }
        public function objectLoaded(object:ClientObject):void
        {
            var point:Point;
            for each (point in this.points)
            {
                point.drawDebug(this.battlefieldModel.getBattlefieldData().viewport.getMapContainer());
            }
            this.pointHuds.show();
        }
        public function objectUnloaded(object:ClientObject):void
        {
            this.battlefieldModel.removePlugin(this);
            DOMModel.userTankData = null;
            var marker:ControlPointMarkers;
            for each (marker in this.pointMarkers)
            {
                marker.destroy();
            }
        }
        public function get battlefieldPluginName():String
        {
            return ("DOM");
        }
        public function startBattle():void
        {
        }
        public function restartBattle():void
        {
        }
        public function finishBattle():void
        {
        }
        public function addUser(clientObject:ClientObject):void
        {
        }
        public function removeUser(clientObject:ClientObject):void
        {
        }
        public function addUserToField(clientObject:ClientObject):void
        {
            var tankData:TankData = this.tankModel.getTankData(clientObject);
            if (this.bfData.localUser == clientObject)
            {
                userTankData = tankData;
            }
            this.tanksInBattle[tankData] = tankData.tank;
        }
        public function removeUserFromField(clientObject:ClientObject):void
        {
            var tankData:TankData = this.tankModel.getTankData(clientObject);
            delete this.tanksInBattle[tankData];
        }

    }
}
