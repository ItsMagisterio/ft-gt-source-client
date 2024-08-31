package alternativa.tanks.models.sfx.shoot.ricochet
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.ricochet.RicochetSFXModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.ricochet.IRicochetSFXModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import alternativa.tanks.engine3d.IMaterialSequenceRegistry;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import flash.display.BitmapData;
    import alternativa.tanks.engine3d.MaterialType;
    import alternativa.tanks.engine3d.ITextureMaterialRegistry;
    import alternativa.tanks.utils.GraphicsUtils;
    import alternativa.object.ClientObject;
    import __AS3__.vec.Vector;
    import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.sfx.colortransform.IColorTransformModel;
    import flash.geom.ColorTransform;

    public class RicochetSFXModel extends RicochetSFXModelBase implements IRicochetSFXModelBase, IObjectLoadListener, IRicochetSFXModel
    {

        private static var materialRegistry:IMaterialRegistry;

        public function RicochetSFXModel()
        {
            _interfaces.push(IModel, IObjectLoadListener, IRicochetSFXModel);
            materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
        }
        public function initObject(clientObject:ClientObject, bumpFlashTextureId:String, explosionSoundId:String, explosionTextureId:String, ricochetSoundId:String, shotFlashTextureId:String, shotSoundId:String, shotTextureId:String, tailTrailTextureId:String, ownerTank:ClientObject):void
        {
            var sfxData:RicochetSFXData = new RicochetSFXData();
            var materialSequenceRegistry:IMaterialSequenceRegistry = materialRegistry.materialSequenceRegistry;
            var shotTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, shotTextureId).bitmapData;
            sfxData.shotMaterials = materialSequenceRegistry.getSquareSequence(MaterialType.EFFECT, shotTexture, 2).materials;
            var explosionTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, explosionTextureId).bitmapData;
            sfxData.explosionMaterials = materialSequenceRegistry.getSquareSequence(MaterialType.EFFECT, explosionTexture, 1.33).materials;
            var bumpFlashTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, bumpFlashTextureId).bitmapData;
            sfxData.ricochetFlashMaterials = materialSequenceRegistry.getSquareSequence(MaterialType.EFFECT, bumpFlashTexture, 0.4).materials;
            var textureMaterialRegistry:ITextureMaterialRegistry = materialRegistry.textureMaterialRegistry;
            var shotFlashTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, shotFlashTextureId).bitmapData;
            sfxData.shotFlashMaterial = textureMaterialRegistry.getMaterial(MaterialType.EFFECT, shotFlashTexture, 1);
            var tailTrailTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, tailTrailTextureId).bitmapData;
            sfxData.tailTrailMaterial = textureMaterialRegistry.getMaterial(MaterialType.EFFECT, tailTrailTexture, 2);
            sfxData.shotSound = ResourceUtil.getResource(ResourceType.SOUND, shotSoundId).sound;
            sfxData.ricochetSound = ResourceUtil.getResource(ResourceType.SOUND, ricochetSoundId).sound;
            sfxData.explosionSound = ResourceUtil.getResource(ResourceType.SOUND, explosionSoundId).sound;
            sfxData.dataExplosion = GraphicsUtils.getTextureAnimation(null, explosionTexture, 200, 200);
            sfxData.dataExplosion.fps = 30;
            sfxData.dataFlash = GraphicsUtils.getTextureAnimation(null, explosionTexture, 200, 200);
            sfxData.dataFlash.fps = 45;
            sfxData.dataShot = GraphicsUtils.getTextureAnimation(null, shotTexture, 150, 150);
            sfxData.dataShot.fps = 13;
            clientObject.putParams(RicochetSFXData, sfxData);
            clientObject.putSessionParams(ownerTank.sessionId, sfxData);
        }
        public function objectLoaded(object:ClientObject):void
        {
            var sfxData:RicochetSFXData;
            var colorTransforms:Vector.<ColorTransformEntry>;
            var ctStruct:ColorTransformEntry;
            var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
            var colorTransformModel:IColorTransformModel = IColorTransformModel(modelService.getModelForObject(object, IColorTransformModel));
            if (colorTransformModel != null)
            {
                sfxData = this.getSfxData(object, null);
                colorTransforms = colorTransformModel.getModelData(object);
                if (colorTransforms.length > 0)
                {
                    ctStruct = colorTransforms[0];
                    sfxData.colorTransform = new ColorTransform(ctStruct.redMultiplier, ctStruct.greenMultiplier, ctStruct.blueMultiplier, ctStruct.alphaMultiplier, ctStruct.redOffset, ctStruct.greenOffset, ctStruct.blueOffset, ctStruct.alphaOffset);
                }
            }
        }
        public function objectUnloaded(object:ClientObject):void
        {
        }
        public function getSfxData(clientObject:ClientObject, ownerTank:ClientObject):RicochetSFXData
        {
            return (RicochetSFXData(clientObject.getSessionParams(ownerTank.sessionId)));
        }

    }
}
