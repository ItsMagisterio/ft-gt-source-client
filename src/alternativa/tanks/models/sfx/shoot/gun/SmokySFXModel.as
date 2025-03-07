﻿package alternativa.tanks.models.sfx.shoot.gun
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.gun.GunShootSFXModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.gun.IGunShootSFXModelBase;
    import alternativa.tanks.models.sfx.shoot.ICommonShootSFX;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import alternativa.math.Vector3;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import flash.display.BitmapData;
    import alternativa.tanks.engine3d.MaterialType;
    import alternativa.tanks.engine3d.MaterialSequence;
    import flash.media.Sound;
    import alternativa.tanks.utils.GraphicsUtils;
    import alternativa.tanks.engine3d.TextureAnimation;
    import alternativa.object.ClientObject;
    import alternativa.tanks.sfx.Sound3D;
    import alternativa.tanks.sfx.SoundOptions;
    import alternativa.tanks.sfx.Sound3DEffect;
    import alternativa.tanks.sfx.PlaneMuzzleFlashEffect;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.objects.Mesh;
    import alternativa.tanks.sfx.EffectsPair;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.tanks.sfx.AnimatedSpriteEffectNew;
    import alternativa.tanks.sfx.StaticObject3DPositionProvider;
    import alternativa.tanks.models.sfx.AnimatedLightEffect;
    import alternativa.tanks.models.sfx.MuzzlePositionProvider;
    import alternativa.tanks.models.sfx.LightDataManager;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.weapon.common.ShotEffect;

    public class SmokySFXModel extends GunShootSFXModelBase implements IGunShootSFXModelBase, ICommonShootSFX
    {

        private static const SHOT_SOUND_VOLUME:Number = 1;
        private static const EXPLOSION_BASE_SIZE:Number = 350;
        private static const EXPLOSION_OFFSET_TO_CAMERA:Number = 135;
        private static var objectPoolService:IObjectPoolService;
        private static var materialRegistry:IMaterialRegistry;
        private static var MIPMAP_RESOLUTION:Number = 2;
        private static var position:Vector3 = new Vector3();
        private static var bfModel:BattlefieldModel;
        private static var shotEffectId:String = "";
        private static var session:String = "0000ses";

        public function SmokySFXModel()
        {
            _interfaces.push(IModel, IGunShootSFXModelBase, ICommonShootSFX);
        }
        public function initObject(clientObject:ClientObject, explosionResourceId:String, explosionSoundResourceId:String, shotResourceId:String, shotSoundResourceId:String, ownerTank:ClientObject):void
        {
            shotEffectId = String(ownerTank.getParams(ShotEffect));
            session = String(ownerTank.sessionId);
            objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
            materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
            var data:GunShootSFXData = new GunShootSFXData();
            var shotTexture:BitmapData = (ResourceUtil.getResource(ResourceType.IMAGE, shotEffectId == "smoky_fire" ? "smoky_fire_shot" : shotResourceId).bitmapData as BitmapData);
            data.shotMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT, shotTexture, (EXPLOSION_BASE_SIZE / shotTexture.width), false);
            var explosionTexture:BitmapData = (ResourceUtil.getResource(ResourceType.IMAGE, explosionResourceId).bitmapData as BitmapData);
            var fireExplosionTexture:BitmapData = (ResourceUtil.getResource(ResourceType.IMAGE, "smoky_fire_explosion").bitmapData as BitmapData);
            var sequence:MaterialSequence = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT, explosionTexture, explosionTexture.height, MIPMAP_RESOLUTION);
            data.explosionMaterials = sequence.materials;
            data.shotSound = (ResourceUtil.getResource(ResourceType.SOUND, "smoky_shot").sound as Sound);
            data.explosionSound = (ResourceUtil.getResource(ResourceType.SOUND, "smoky_exp").sound as Sound);
            var animExpl:TextureAnimation;
            var animShot:TextureAnimation;
            if (shotEffectId == "smoky_fire")
            {
                animExpl = GraphicsUtils.getTextureAnimation(null, fireExplosionTexture, 256, 256); // SMOKY FIRE EXPL smokyfire smokefire firesmoky fire smoky
                animExpl.fps = 60;
                animShot = GraphicsUtils.getTextureAnimation(null, shotTexture, 30, 105);
            }
            else
            {
                animExpl = GraphicsUtils.getTextureAnimation(null, explosionTexture, 102, 102);
                animExpl.fps = 30;
                animShot = GraphicsUtils.getTextureAnimation(null, shotTexture, 30, 105);
            }
            animShot.fps = 1;
            data.explosionData = animExpl;
            data.shotData = animShot;
            clientObject.putParams(SmokySFXModel, data);
            clientObject.putSessionParams(session, data);
        }
        public function createShotEffects(clientObject:ClientObject, localMuzzlePosition:Vector3, turret:Object3D, camera:Camera3D, owner:ClientObject):EffectsPair
        {
            session = owner.sessionId;
            shotEffectId = String(owner.getParams(ShotEffect));
            var data:GunShootSFXData;
            data = null;
            data = this.getSfxData(clientObject);
            var sound:Sound3D = Sound3D.create(data.shotSound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, SHOT_SOUND_VOLUME);
            position.x = turret.x;
            position.y = turret.y;
            position.z = turret.z;
            var soundEffect:Sound3DEffect = Sound3DEffect.create(objectPoolService.objectPool, null, position, sound);
            var graphicEffect:PlaneMuzzleFlashEffect = PlaneMuzzleFlashEffect(objectPoolService.objectPool.getObject(PlaneMuzzleFlashEffect));
            graphicEffect.init(localMuzzlePosition, turret, (data.shotMaterial as TextureMaterial), 100, 60, 210);
            this.createMuzzleFlashLightEffect(localMuzzlePosition, (turret as Mesh), clientObject);
            return (new EffectsPair(graphicEffect, soundEffect));
        }
        public function createExplosionEffects(clientObject:ClientObject, position:Vector3, camera:Camera3D, weakeningCoeff:Number, owner:ClientObject):EffectsPair
        {
            session = owner.sessionId;
            shotEffectId = String(owner.getParams(ShotEffect));
            var data:GunShootSFXData = this.getSfxData(clientObject);
            var sound:Sound3D = Sound3D.create(data.explosionSound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, 1);
            var soundEffect:Sound3DEffect = Sound3DEffect.create(objectPoolService.objectPool, null, position, sound, 100);
            var graphicEffect:AnimatedSpriteEffectNew = AnimatedSpriteEffectNew(objectPoolService.objectPool.getObject(AnimatedSpriteEffectNew));
            var posProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
            posProvider.init(position, EXPLOSION_OFFSET_TO_CAMERA);
            var size:Number = (EXPLOSION_BASE_SIZE * weakeningCoeff);
            if (shotEffectId == "smoky_fire")
            {
                size *= 1.5;
            }
            this.createExplosionLightEffect(position, clientObject);
            graphicEffect.init(size, size, data.explosionData, 0, posProvider);
            return (new EffectsPair(graphicEffect, soundEffect));
        }
        private function getSfxData(clientObject:ClientObject):GunShootSFXData
        {
            return (GunShootSFXData(clientObject.getSessionParams(session)));
        }
        private function createMuzzleFlashLightEffect(param1:Vector3, param2:Mesh, turretObj:ClientObject):void
        {
            var _loc3_:AnimatedLightEffect = AnimatedLightEffect(objectPoolService.objectPool.getObject(AnimatedLightEffect));
            var _loc4_:MuzzlePositionProvider = MuzzlePositionProvider(objectPoolService.objectPool.getObject(MuzzlePositionProvider));
            _loc4_.init(param2, param1, 0);
            _loc3_.init(_loc4_, LightDataManager.getLightDataMuzzle(turretObj.id));
            bfModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            bfModel.addGraphicEffect(_loc3_);
        }
        private function createExplosionLightEffect(param1:Vector3, turretObj:ClientObject):void
        {
            var _loc2_:AnimatedLightEffect = AnimatedLightEffect(objectPoolService.objectPool.getObject(AnimatedLightEffect));
            var _loc3_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
            _loc3_.init(param1, 30);
            if (_loc3_ == null)
            {
                throw (new ArgumentError("pos can not be null"));
            }
            _loc2_.init(_loc3_, LightDataManager.getLightDataExplosion(turretObj.id));
            bfModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            bfModel.addGraphicEffect(_loc2_);
        }

    }
}
