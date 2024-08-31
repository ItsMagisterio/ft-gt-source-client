package alternativa.tanks.models.sfx.flame
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.flame.FlameThrowingSFXModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.flame.IFlameThrowingSFXModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import __AS3__.vec.Vector;
    import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
    import com.alternativaplatform.projects.tanks.client.warfare.models.colortransform.struct.ColorTransformStruct;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.sfx.OmniStreamLightEffect;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import flash.display.BitmapData;
    import alternativa.tanks.engine3d.MaterialType;
    import flash.media.Sound;
    import alternativa.tanks.utils.GraphicsUtils;
    import alternativa.object.ClientObject;
    import alternativa.tanks.models.weapon.flamethrower.IFlamethrower;
    import alternativa.tanks.models.weapon.flamethrower.FlamethrowerData;
    import alternativa.tanks.sfx.Sound3D;
    import alternativa.tanks.sfx.SoundOptions;
    import alternativa.tanks.sfx.MobileSound3DEffect;
    import alternativa.tanks.sfx.EffectsPair;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.math.Vector3;
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
    import alternativa.tanks.models.sfx.MuzzlePositionProvider;
    import alternativa.tanks.models.sfx.CollisionObject3DPositionProvider;
    import alternativa.tanks.models.sfx.LightDataManager;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.sfx.*;
    import __AS3__.vec.*;
    import alternativa.physics.altphysics;
    import flash.geom.ColorTransform;
    import alternativa.tanks.models.weapon.common.ShotEffect;
    import alternativa.engine3d.materials.Material;
    use namespace altphysics;

    public class FlamethrowerSFXModel extends FlameThrowingSFXModelBase implements IFlameThrowingSFXModelBase, IFlamethrowerSFXModel, IObjectLoadListener
    {

        private static const MIPMAP_RESOLUTION:int = 3;
        private static const SOUND_VOLUME:Number = 1;
        private static var objectPoolService:IObjectPoolService;
        private static var materialRegistry:IMaterialRegistry;
        private static const colorTarnsforms:Vector.<ColorTransformEntry> = Vector.<ColorTransformEntry>([new ColorTransformEntry(new ColorTransformStruct(0, 1, 1, 1, 1, 100, 150, 100, 0)), new ColorTransformEntry(new ColorTransformStruct(0.05, 1, 1, 1, 1, 50, 100, 60, 0)), new ColorTransformEntry(new ColorTransformStruct(0.1, 1, 1, 1, 1, 100, 100, 40, 0)), new ColorTransformEntry(new ColorTransformStruct(0.65, 0.5, 0.3, 0.3, 1, 50, 80, 50, 0)), new ColorTransformEntry(new ColorTransformStruct(0.75, 0, 0, 0, 1, 50, 50, 50, 0)), new ColorTransformEntry(new ColorTransformStruct(1, 0, 0, 0, 0, 20, 20, 20, 0))]);

        private var battlefield:IBattleField;
        private var muzzleLightEffect:OmniStreamLightEffect;
        private var lightEffect:OmniStreamLightEffect;

        public var shotEffectId:String = "";
        private var session:String = "0000ses";

        public function FlamethrowerSFXModel()
        {
            _interfaces.push(IModel, IFlameThrowingSFXModelBase, IFlamethrowerSFXModel, IObjectLoadListener);
            objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
            materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
        }
        public function initObject(clientObject:ClientObject, fireTextureId:String, flameSoundId:String, owner:ClientObject):void
        {
            if (this.battlefield == null)
            {
                this.battlefield = IBattleField(Main.osgi.getService(IBattleField));
            }
            var data:FlamethrowerSFXData = new FlamethrowerSFXData();
            var fireTexture:BitmapData = (ResourceUtil.getResource(ResourceType.IMAGE, fireTextureId).bitmapData as BitmapData);
            var planeTexture:BitmapData = (ResourceUtil.getResource(ResourceType.IMAGE, "flamethrower_shot").bitmapData as BitmapData);
            data.materials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT, fireTexture, fireTexture.height, MIPMAP_RESOLUTION).materials;
            data.planeMaterials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT, planeTexture, 50, MIPMAP_RESOLUTION).materials;
            data.flameSound = (ResourceUtil.getResource(ResourceType.SOUND, flameSoundId).sound as Sound);
            data.data = GraphicsUtils.getTextureAnimation(null, fireTexture, 100, 100);
            data.data.fps = 30;
            clientObject.putParams(FlamethrowerSFXModel, data);
            clientObject.putSessionParams(owner.sessionId, data);
        }
        public function getSpecialEffects(shooterData:TankData, localMuzzlePosition:Vector3, turret:Object3D, weakeningModel:IWeaponWeakeningModel):EffectsPair
        {
            var flameModel:IFlamethrower = IFlamethrower(Main.osgi.getService(IFlamethrower));
            var data:FlamethrowerData = flameModel.getFlameData(shooterData.turret);
            var sfxData:FlamethrowerSFXData = this.getData(shooterData.turret, shooterData.user);
            var graphicEffect:FlamethrowerGraphicEffect = FlamethrowerGraphicEffect(objectPoolService.objectPool.getObject(FlamethrowerGraphicEffect));
            graphicEffect.init(shooterData, data.range.value, data.coneAngle.value, 20, 2000, localMuzzlePosition, turret, sfxData, this.battlefield.getBattlefieldData().collisionDetector, weakeningModel);
            this.createLightEffect(localMuzzlePosition, turret, shooterData.turret);
            var sound3D:Sound3D = Sound3D.create(sfxData.flameSound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, SOUND_VOLUME);
            var soundEffect:MobileSound3DEffect = MobileSound3DEffect(objectPoolService.objectPool.getObject(MobileSound3DEffect));
            soundEffect.init(null, sound3D, turret, 0, 4);
            return (new EffectsPair(graphicEffect, soundEffect, this.muzzleLightEffect, this.lightEffect));
        }
        public function createLightEffect(param1:Vector3, param2:Object3D, turretObject:ClientObject):void
        {
            var _loc3_:MuzzlePositionProvider;
            var _loc4_:CollisionObject3DPositionProvider;
            this.muzzleLightEffect = OmniStreamLightEffect(objectPoolService.objectPool.getObject(OmniStreamLightEffect));
            _loc3_ = MuzzlePositionProvider(objectPoolService.objectPool.getObject(MuzzlePositionProvider));
            _loc3_.init(param2, param1);
            this.muzzleLightEffect.init(_loc3_, LightDataManager.getLightDataMuzzle(turretObject.id), LightDataManager.getLightDataShot(turretObject.id));
            this.battlefield.addGraphicEffect(this.muzzleLightEffect);
            this.lightEffect = OmniStreamLightEffect(objectPoolService.objectPool.getObject(OmniStreamLightEffect));
            _loc4_ = CollisionObject3DPositionProvider(objectPoolService.objectPool.getObject(CollisionObject3DPositionProvider));
            _loc4_.init(param2, param1, this.battlefield.getBattlefieldData().collisionDetector, 1500);
            this.lightEffect.init(_loc4_, LightDataManager.getLightDataMuzzle(turretObject.id), LightDataManager.getLightDataShot(turretObject.id));
            this.battlefield.addGraphicEffect(this.lightEffect);
        }
        public function objectLoaded(clientObject:ClientObject):void
        {
            var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
        }
        public function initFlameThrower(clientObject:ClientObject, owner:ClientObject):void
        {
            var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
            var sfxData:FlamethrowerSFXData = this.getData(clientObject, owner);
            shotEffectId = String(owner.getParams(ShotEffect));
            if (shotEffectId == "flamethrower_black" || shotEffectId == "flamethrower_magma")
            {
                var noColors:Vector.<ColorTransformEntry> = Vector.<ColorTransformEntry>([
                            new ColorTransformEntry(new ColorTransformStruct(0, 1, 1, 1, 1, 0, 0, 0, 0)),
                            new ColorTransformEntry(new ColorTransformStruct(0.05, 1, 1, 1, 1, 0, 0, 0, 0)),
                            new ColorTransformEntry(new ColorTransformStruct(0.1, 1, 1, 1, 1, 0, 0, 0, 0)),
                            new ColorTransformEntry(new ColorTransformStruct(0.65, 1, 1, 1, 1, 0, 0, 0, 0)),
                            new ColorTransformEntry(new ColorTransformStruct(0.75, 1, 1, 1, 1, 0, 0, 0, 0)),
                            new ColorTransformEntry(new ColorTransformStruct(1, 1, 1, 1, 1, 0, 0, 0, 0))
                        ]);
                sfxData.colorTransformPoints = noColors;
            }
            else
            {
                sfxData.colorTransformPoints = colorTarnsforms;
            }
        }
        public function objectUnloaded(clientObject:ClientObject):void
        {
        }
        private function getData(clientObject:ClientObject, owner:ClientObject):FlamethrowerSFXData
        {
            return (clientObject.getSessionParams(owner.sessionId) as FlamethrowerSFXData);
        }

    }
}
