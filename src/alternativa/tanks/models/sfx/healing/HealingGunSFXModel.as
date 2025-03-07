﻿package alternativa.tanks.models.sfx.healing
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.healing.HealingSFXModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.healing.IHealingSFXModelBase;
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
    import alternativa.math.Vector3;
    import flash.utils.Dictionary;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import alternativa.service.IModelService;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import alternativa.object.ClientObject;
    import alternativa.tanks.utils.GraphicsUtils;
    import alternativa.tanks.engine3d.TextureAnimation;
    import flash.display.BitmapData;
    import alternativa.tanks.models.weapon.common.WeaponCommonData;
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.models.tank.TankData;
    import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.healing.IsisActionType;
    import alternativa.tanks.engine3d.MaterialType;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.materials.Material;

    public class HealingGunSFXModel extends HealingSFXModelBase implements IHealingSFXModelBase, IHealingSFXModel
    {

        private static const MIPMAP_RESOLUTION:Number = 1;
        private static var materialRegistry:IMaterialRegistry;
        private static var objectPoolService:IObjectPoolService;

        private var battlefield:IBattleField;
        private var weaponCommonModel:IWeaponCommonModel;
        private var targetPosLocal:Vector3 = new Vector3();
        private var activeEffects:Dictionary = new Dictionary();

        public function HealingGunSFXModel()
        {
            _interfaces.push(IModel, IHealingSFXModelBase, IHealingSFXModel);
            HealingGunCameraEffect.initVars();
            materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
            objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
        }
        public function initObject(clientObject:ClientObject, damagingRayId:String, damagingSoundId:String, damagingTargetBallId:String, damagingWeaponBallId:String, healingRayId:String, healingSoundId:String, healingTargetBallId:String, healingWeaponBallId:String, idleSoundId:String, idleWeaponBallId:String):void
        {
            var modelService:IModelService;
            if (this.battlefield == null)
            {
                modelService = IModelService(Main.osgi.getService(IModelService));
                this.battlefield = IBattleField(modelService.getModelsByInterface(IBattleField)[0]);
                this.weaponCommonModel = IWeaponCommonModel(modelService.getModelsByInterface(IWeaponCommonModel)[0]);
            }
            var data:HealingGunSFXData = new HealingGunSFXData();
            data.idleSparkMaterials = this.createSpriteMaterials(ResourceUtil.getResource(ResourceType.IMAGE, idleWeaponBallId).bitmapData);
            data.idleSound = ResourceUtil.getResource(ResourceType.SOUND, idleSoundId).sound;
            data.healShaftMaterials = this.createShaftMaterials(ResourceUtil.getResource(ResourceType.IMAGE, healingRayId).bitmapData);
            data.healSparkMaterials = this.createSpriteMaterials(ResourceUtil.getResource(ResourceType.IMAGE, healingWeaponBallId).bitmapData);
            data.healShaftEndMaterials = this.createSpriteMaterials(ResourceUtil.getResource(ResourceType.IMAGE, healingTargetBallId).bitmapData);
            data.healSound = ResourceUtil.getResource(ResourceType.SOUND, damagingSoundId).sound;
            data.damageShaftMaterials = this.createShaftMaterials(ResourceUtil.getResource(ResourceType.IMAGE, damagingRayId).bitmapData);
            data.damageSparkMaterials = this.createSpriteMaterials(ResourceUtil.getResource(ResourceType.IMAGE, damagingWeaponBallId).bitmapData);
            data.damageShaftEndMaterials = this.createSpriteMaterials(ResourceUtil.getResource(ResourceType.IMAGE, damagingTargetBallId).bitmapData);
            data.damageSound = ResourceUtil.getResource(ResourceType.SOUND, damagingSoundId).sound;
            data.idleSparkData = this.getTextureAnimation(ResourceUtil.getResource(ResourceType.IMAGE, idleWeaponBallId).bitmapData, 150, 30);
            data.healSparkData = this.getTextureAnimation(ResourceUtil.getResource(ResourceType.IMAGE, healingWeaponBallId).bitmapData, 150);
            data.healShaftData = this.getTextureAnimation(ResourceUtil.getResource(ResourceType.IMAGE, healingRayId).bitmapData, 100, 20);
            data.healShaftEndData = this.getTextureAnimation(ResourceUtil.getResource(ResourceType.IMAGE, healingTargetBallId).bitmapData, 100);
            data.damageShaftData = this.getTextureAnimation(ResourceUtil.getResource(ResourceType.IMAGE, damagingRayId).bitmapData, 100, 10);
            data.damageSparkData = this.getTextureAnimation(ResourceUtil.getResource(ResourceType.IMAGE, damagingWeaponBallId).bitmapData, 150);
            data.damageShaftEndData = this.getTextureAnimation(ResourceUtil.getResource(ResourceType.IMAGE, damagingTargetBallId).bitmapData, 100);
            clientObject.putParams(HealingGunSFXModel, data);
        }
        private function getTextureAnimation(data:BitmapData, size:int, fps:int = 30):TextureAnimation
        {
            var data_:TextureAnimation = GraphicsUtils.getTextureAnimation(null, data, size, size);
            data_.fps = fps;
            return (data_);
        }
        public function createOrUpdateEffects(ownerData:TankData, mode:IsisActionType, targetData:TankData):void
        {
            var effects:HealingGunSFX;
            if (((!(targetData == null)) && (!(targetData.enabled))))
            {
                return;
            }
            var ownerTurret:ClientObject = ownerData.turret;
            var sfxData:HealingGunSFXData = HealingGunSFXData(ownerTurret.getParams(HealingGunSFXModel));
            var weaponCommonData:WeaponCommonData = this.weaponCommonModel.getCommonData(ownerTurret);
            var turret:Object3D = ownerData.tank.skin.turretMesh;
            var srcPosLocal:Vector3 = weaponCommonData.muzzles[0];
            var target:Object3D = ((targetData == null) ? null : targetData.tank.skin.turretMesh);
            var turretId:String = ownerTurret.id;
            var turretEffects:Dictionary = this.activeEffects[turretId];
            if (turretEffects == null)
            {
                turretEffects = new Dictionary();
                this.activeEffects[turretId] = turretEffects;
            }
            else
            {
                effects = turretEffects[ownerData.user.id];
            }
            if (effects == null)
            {
                effects = HealingGunSFX(objectPoolService.objectPool.getObject(HealingGunSFX));
                effects.init(mode, sfxData, turret, srcPosLocal, ownerData);
                if (targetData != null)
                {
                    effects.setTargetParams(targetData, ownerData, target, this.targetPosLocal, mode);
                }
                turretEffects[ownerData.user.id] = effects;
                effects.addToBattlefield(this.battlefield);
            }
            else
            {
                effects.mode = mode;
                effects.setTargetParams(targetData, ownerData, target, this.targetPosLocal, mode);
            }
        }
        public function destroyEffectsByOwner(ownerData:TankData):void
        {
            var turretEffects:Dictionary = this.activeEffects[ownerData.turret.id];
            if (turretEffects == null)
            {
                return;
            }
            var userId:String = ownerData.user.id;
            var effects:HealingGunSFX = turretEffects[userId];
            if (effects != null)
            {
                if (effects)
                {
                    effects.destroy();
                }
                delete turretEffects[userId];
            }
        }
        public function destroyEffectsByTarget(targetData:TankData):void
        {
            var turretEffects:Dictionary;
            var userId:* = undefined;
            var effects:HealingGunSFX;
            for each (turretEffects in this.activeEffects)
            {
                for (userId in turretEffects)
                {
                    effects = turretEffects[userId];
                    if (effects.targetData == targetData)
                    {
                        effects.destroy();
                        delete turretEffects[userId];
                    }
                }
            }
        }
        private function createShaftMaterials(source:BitmapData):Vector.<Material>
        {
            var frameWidth:int = 100;
            return (materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT, source, frameWidth, MIPMAP_RESOLUTION, false, true).materials);
        }
        private function createSpriteMaterials(source:BitmapData):Vector.<Material>
        {
            return (materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT, source, source.height, MIPMAP_RESOLUTION).materials);
        }

    }
}
