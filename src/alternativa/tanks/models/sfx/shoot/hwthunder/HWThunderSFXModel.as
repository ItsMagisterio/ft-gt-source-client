﻿package alternativa.tanks.models.sfx.shoot.hwthunder
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.thunder.ThunderShootSFXModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.thunder.IThunderShootSFXModelBase;
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.math.Matrix4;
    import alternativa.math.Vector3;
    import alternativa.console.ConsoleVarFloat;
    import alternativa.model.IModel;
    import alternativa.init.Main;
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
    import alternativa.tanks.sfx.AnimatedSpriteEffect;

    public class HWThunderSFXModel extends ThunderShootSFXModelBase implements IThunderShootSFXModelBase, IHWThunderSFXModel
    {

        private static const MIPMAP_RESOLUTION:Number = 2;
        private static var materialRegistry:IMaterialRegistry;
        private static var objectPoolService:IObjectPoolService;
        private static var turretMatrix:Matrix4 = new Matrix4();
        private static var muzzlePosition:Vector3 = new Vector3();
        private static var explosionSize:ConsoleVarFloat = new ConsoleVarFloat("thunder_explosion_size", 750, 1, 2000);

        public function HWThunderSFXModel()
        {
            _interfaces.push(IModel, IHWThunderSFXModel);
            materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
            objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
        }
        public function initObject(clientObject:ClientObject, explosionResourceId:String, explosionSoundResourceId:String, shotResourceId:String, shotSoundResourceId:String):void
        {
            var data:HWThunderSFXData = new HWThunderSFXData();
            if (ResourceUtil.getResource(ResourceType.IMAGE, shotResourceId) == null)
            {
                return;
            }
            data.shotMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT, ResourceUtil.getResource(ResourceType.IMAGE, shotResourceId).bitmapData, MIPMAP_RESOLUTION, false);
            var explosionTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, explosionResourceId).bitmapData;
            data.explosionMaterials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT, explosionTexture, explosionTexture.height, 3).materials;
            data.shotSound = ResourceUtil.getResource(ResourceType.SOUND, shotSoundResourceId).sound;
            data.explosionSound = ResourceUtil.getResource(ResourceType.SOUND, explosionSoundResourceId).sound;
            clientObject.putParams(HWThunderSFXModel, data);
        }
        public function createShotEffects(clientObject:ClientObject, muzzleLocalPos:Vector3, turret:Object3D):EffectsPair
        {
            var data:HWThunderSFXData = this.getSfxData(clientObject);
            var graphicEffect:HWThunderShotEffect = HWThunderShotEffect(objectPoolService.objectPool.getObject(HWThunderShotEffect));
            graphicEffect.init(turret, muzzleLocalPos, data.shotMaterial);
            var sound:Sound3D = Sound3D.create(data.shotSound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, 0.7);
            turretMatrix.setMatrix(turret.x, turret.y, turret.z, turret.rotationX, turret.rotationY, turret.rotationZ);
            turretMatrix.transformVector(muzzleLocalPos, muzzlePosition);
            var soundEffect:Sound3DEffect = Sound3DEffect.create(objectPoolService.objectPool, null, muzzlePosition, sound);
            return (new EffectsPair(graphicEffect, soundEffect));
        }
        public function createExplosionEffects(clientObject:ClientObject, position:Vector3):EffectsPair
        {
            var data:HWThunderSFXData = this.getSfxData(clientObject);
            var graphicEffect:AnimatedSpriteEffect = AnimatedSpriteEffect(objectPoolService.objectPool.getObject(AnimatedSpriteEffect));
            graphicEffect = ((graphicEffect == null) ? new AnimatedSpriteEffect(objectPoolService.objectPool) : graphicEffect);
            graphicEffect.init(explosionSize.value, explosionSize.value, data.explosionMaterials, position, ((Math.random() * 2) * Math.PI), 150, 29, false);
            var sound:Sound3D = Sound3D.create(data.explosionSound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, 0.7);
            var soundEffect:Sound3DEffect = Sound3DEffect.create(objectPoolService.objectPool, null, position, sound);
            return (new EffectsPair(graphicEffect, soundEffect));
        }
        private function getSfxData(clientObject:ClientObject):HWThunderSFXData
        {
            return (HWThunderSFXData(clientObject.getParams(HWThunderSFXModel)));
        }

    }
}
