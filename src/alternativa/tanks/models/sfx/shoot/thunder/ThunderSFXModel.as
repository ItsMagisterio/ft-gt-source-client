package alternativa.tanks.models.sfx.shoot.thunder
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.thunder.ThunderShootSFXModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.thunder.IThunderShootSFXModelBase;
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.math.Matrix4;
    import alternativa.math.Vector3;
    import alternativa.console.ConsoleVarFloat;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.init.Main;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.model.IModel;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import alternativa.tanks.engine3d.MaterialType;
    import flash.display.BitmapData;
    import alternativa.object.ClientObject;
    import alternativa.tanks.sfx.Sound3D;
    import alternativa.tanks.sfx.SoundOptions;
    import alternativa.tanks.sfx.Sound3DEffect;
    import alternativa.tanks.sfx.EffectsPair;
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.models.sfx.AnimatedLightEffect;
    import alternativa.tanks.models.sfx.MuzzlePositionProvider;
    import alternativa.tanks.models.sfx.LightDataManager;
    import alternativa.tanks.sfx.AnimatedSpriteEffect;
    import alternativa.tanks.sfx.StaticObject3DPositionProvider;
    import alternativa.tanks.engine3d.TextureAnimation;
    import alternativa.tanks.utils.GraphicsUtils;
    import alternativa.tanks.sfx.AnimatedSpriteEffectNew;

    public class ThunderSFXModel extends ThunderShootSFXModelBase implements IThunderShootSFXModelBase, IThunderSFXModel
    {

        private static const MIPMAP_RESOLUTION:Number = 2;
        private static var materialRegistry:IMaterialRegistry;
        private static var objectPoolService:IObjectPoolService;
        private static var turretMatrix:Matrix4 = new Matrix4();
        private static var muzzlePosition:Vector3 = new Vector3();
        private static var explosionSize:ConsoleVarFloat = new ConsoleVarFloat("thunder_explosion_size", 750, 1, 2000);

        private var bfModel:BattlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);

        public function ThunderSFXModel()
        {
            _interfaces.push(IModel, IThunderSFXModel);
            materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
            objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
        }
        public function initObject(clientObject:ClientObject, explosionResourceId:String, explosionSoundResourceId:String, shotResourceId:String, shotSoundResourceId:String):void
        {
            var data:ThunderSFXData = new ThunderSFXData();
            if (ResourceUtil.getResource(ResourceType.IMAGE, shotResourceId) == null)
            {
                return;
            }
            data.shotMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT, ResourceUtil.getResource(ResourceType.IMAGE, shotResourceId).bitmapData, MIPMAP_RESOLUTION, false);
            var explosionTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, explosionResourceId).bitmapData;
            data.explosionMaterials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT, explosionTexture, 170, 3).materials; // THUNDER EXPLOSION frameWIDTH
            var animExpl:TextureAnimation = GraphicsUtils.getTextureAnimation(null, explosionTexture, 170, 170); // THUNDER FIRE EXPL thunderfire thunderfire firethunder fire thunder
            animExpl.fps = 30;
            data.explosionData = animExpl;
            data.shotSound = ResourceUtil.getResource(ResourceType.SOUND, shotSoundResourceId).sound;
            data.explosionSound = ResourceUtil.getResource(ResourceType.SOUND, explosionSoundResourceId).sound;
            clientObject.putParams(ThunderSFXModel, data);
        }
        public function createShotEffects(clientObject:ClientObject, muzzleLocalPos:Vector3, turret:Object3D):EffectsPair
        {
            var data:ThunderSFXData = this.getSfxData(clientObject);
            var graphicEffect:ThunderShotEffect = ThunderShotEffect(objectPoolService.objectPool.getObject(ThunderShotEffect));
            graphicEffect.init(turret, muzzleLocalPos, data.shotMaterial);
            var sound:Sound3D = Sound3D.create(data.shotSound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, 0.7);
            turretMatrix.setMatrix(turret.x, turret.y, turret.z, turret.rotationX, turret.rotationY, turret.rotationZ);
            turretMatrix.transformVector(muzzleLocalPos, muzzlePosition);
            var soundEffect:Sound3DEffect = Sound3DEffect.create(objectPoolService.objectPool, null, muzzlePosition, sound);
            return (new EffectsPair(graphicEffect, soundEffect));
        }
        public function createShotLightEffects(param1:Vector3, param2:Object3D, turretObj:ClientObject):void
        {
            var _loc3_:AnimatedLightEffect = AnimatedLightEffect(objectPoolService.objectPool.getObject(AnimatedLightEffect));
            var _loc4_:MuzzlePositionProvider = MuzzlePositionProvider(objectPoolService.objectPool.getObject(MuzzlePositionProvider));
            _loc4_.init(param2, param1);
            _loc3_.init(_loc4_, LightDataManager.getLightDataMuzzle(turretObj.id));
            this.bfModel.addGraphicEffect(_loc3_);
        }
        public function createExplosionEffects(clientObject:ClientObject, position:Vector3):EffectsPair
        {
            var data:ThunderSFXData = this.getSfxData(clientObject);
            // var graphicEffect:AnimatedSpriteEffect = AnimatedSpriteEffect(objectPoolService.objectPool.getObject(AnimatedSpriteEffect));
            // graphicEffect = ((graphicEffect == null) ? new AnimatedSpriteEffect(objectPoolService.objectPool) : graphicEffect);
            // graphicEffect.init(explosionSize.value, explosionSize.value, data.explosionMaterials, position, ((Math.random() * 2) * Math.PI), 150, 29, false);
            var graphicEffect:AnimatedSpriteEffectNew = AnimatedSpriteEffectNew(objectPoolService.objectPool.getObject(AnimatedSpriteEffectNew));
            var posProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
            posProvider.init(position, 150);
            graphicEffect.init(750, 750, data.explosionData, 0, posProvider);
            var sound:Sound3D = Sound3D.create(data.explosionSound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, 0.7);
            var soundEffect:Sound3DEffect = Sound3DEffect.create(objectPoolService.objectPool, null, position, sound);
            return (new EffectsPair(graphicEffect, soundEffect));
        }
        private function createExplosionLightEffect(param1:Vector3, turretObj:ClientObject):void
        {
            var _loc2_:AnimatedLightEffect = AnimatedLightEffect(objectPoolService.objectPool.getObject(AnimatedLightEffect));
            var _loc3_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
            _loc3_.init(param1, 110);
            _loc2_.init(_loc3_, LightDataManager.getLightDataExplosion(turretObj.id));
            this.bfModel.addGraphicEffect(_loc2_);
        }
        private function getSfxData(clientObject:ClientObject):ThunderSFXData
        {
            return (ThunderSFXData(clientObject.getParams(ThunderSFXModel)));
        }

    }
}
