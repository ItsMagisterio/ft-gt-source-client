﻿package alternativa.tanks.models.sfx.shoot.railgun
{
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.railgun.RailgunShootSFXModelBase;
    import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.railgun.IRailgunShootSFXModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.tanks.services.materialregistry.IMaterialRegistry;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.tanks.engine3d.TanksTextureMaterial;
    import flash.media.Sound;
    import __AS3__.vec.Vector;
    import alternativa.engine3d.materials.Material;
    import alternativa.tanks.engine3d.TextureAnimation;
    import alternativa.tanks.models.sfx.AnimatedLightEffect;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import alternativa.object.ClientObject;
    import alternativa.math.Vector3;
    import alternativa.tanks.sfx.IGraphicEffect;
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.models.sfx.MuzzlePositionProvider;
    import alternativa.tanks.models.sfx.LightDataManager;
    import alternativa.tanks.sfx.StaticObject3DPositionProvider;
    import alternativa.tanks.models.sfx.TubeLightEffect;
    import alternativa.tanks.sfx.Sound3D;
    import alternativa.tanks.sfx.SoundOptions;
    import alternativa.tanks.sfx.Sound3DEffect;
    import alternativa.tanks.sfx.ISound3DEffect;
    import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.sfx.colortransform.IColorTransformModel;
    import flash.display.BitmapData;
    import alternativa.tanks.utils.GraphicsUtils;
    import alternativa.tanks.engine3d.MaterialType;
    import alternativa.gfx.core.BitmapTextureResource;

    public class RailgunSFXModel extends RailgunShootSFXModelBase implements IRailgunShootSFXModelBase, IRailgunSFXModel, IObjectLoadListener
    {

        private static const MIPMAP_RESOLUTION:Number = 3;
        private static const CHARGE_FRAME_SIZE:int = 210;
        private static const SOUND_VOLUME:Number = 1;
        private static var objectPoolService:IObjectPoolService;
        private static var materialRegistry:IMaterialRegistry;

        private var colorTransform:ColorTransform = new ColorTransform();
        private var matrix:Matrix = new Matrix();
        private var battlefield:IBattleField;
        private var bfModel:BattlefieldModel;
        private var numLoadedObjects:int;
        private var trailMaterial:TanksTextureMaterial;
        private var trailMaterial1:TanksTextureMaterial;
        private var shotSound:Sound;
        private var chargeMaterials:Vector.<Material>;
        private var charingData:TextureAnimation;
        private var chargeLightEffect:AnimatedLightEffect;

        public var shotEffectId:String = "";

        public function RailgunSFXModel()
        {
            _interfaces.push(IModel, IRailgunShootSFXModelBase, IRailgunSFXModel, IObjectLoadListener);
        }
        public function initObject(clientObject:ClientObject, chargingPart1:String, chargingPart2:String, chargingPart3:String, railImageId:String, shotId:String):void
        {
            this.numLoadedObjects++;
            materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
            if (materialRegistry == null)
            {
                throw (new Error("пизда тебе"));
            }
            objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
            if (this.numLoadedObjects == 1)
            {
                this.battlefield = (Main.osgi.getService(IBattleField) as IBattleField);
                trace(railImageId);
                this.trailMaterial = new TanksTextureMaterial(ResourceUtil.getResource(ResourceType.IMAGE, railImageId).bitmapData, true, true, MIPMAP_RESOLUTION, MIPMAP_RESOLUTION);
                this.trailMaterial1 = new TanksTextureMaterial(ResourceUtil.getResource(ResourceType.IMAGE, shotId).bitmapData, true, true, MIPMAP_RESOLUTION, MIPMAP_RESOLUTION);
                this.trailMaterial.repeat = true;
                this.createChargeMaterials(chargingPart1, chargingPart2, chargingPart3);
                this.shotSound = (ResourceUtil.getResource(ResourceType.SOUND, "railgun_shot").sound as Sound);
            }
            this.objectLoaded(clientObject);
        }
        public function getSFXData(clientObject:ClientObject):RailgunShootSFXData
        {
            return (RailgunShootSFXData(clientObject.getParams(RailgunSFXModel)));
        }
        public function createGraphicShotEffect(clientObject:ClientObject, startPosition:Vector3, hitPosition:Vector3):IGraphicEffect
        {
            var sfxData:RailgunShootSFXData = this.getSFXData(clientObject);
            var effect:BeamEffect = BeamEffect(objectPoolService.objectPool.getObject(BeamEffect));
            effect.init(startPosition, hitPosition, this.trailMaterial, 100, 0.5, 1.5, 20, 2000, this.trailMaterial1);
            // effect.init(startPosition,hitPosition,this.trailMaterial,50,0.5,1.5,20,2000,this.trailMaterial1);
            this.createShotLightEffect(startPosition, clientObject);
            this.createRailLightEffect(clientObject, startPosition, hitPosition, clientObject);
            return (effect);
        }
        public function createChargeEffect(clientObject:ClientObject, user:ClientObject, localMuzzlePosition:Vector3, turret:Object3D, chargingTime:int):IGraphicEffect
        {
            var sfxData:RailgunShootSFXData = this.getSFXData(clientObject);
            var effect:ChargeEffect = ChargeEffect(objectPoolService.objectPool.getObject(ChargeEffect));
            var animation:TextureAnimation = this.charingData;
            effect.init(user, 310, 310, this.chargeMaterials, localMuzzlePosition, turret, 0, ((1000 * this.chargeMaterials.length) / chargingTime), sfxData.colorTransform);
            this.createChargeLightEffect(localMuzzlePosition, turret, chargingTime, clientObject);
            return (effect);
        }
        public function createChargeLightEffect(param1:Vector3, param2:Object3D, param3:int, turretObject:ClientObject):void
        {
            if (this.chargeLightEffect != null)
            {
                this.chargeLightEffect.kill();
            }
            this.chargeLightEffect = AnimatedLightEffect(objectPoolService.objectPool.getObject(AnimatedLightEffect));
            var _loc4_:MuzzlePositionProvider = MuzzlePositionProvider(objectPoolService.objectPool.getObject(MuzzlePositionProvider));
            _loc4_.init(param2, param1);
            this.chargeLightEffect.initFromTime(_loc4_, param3, LightDataManager.getLightDataMuzzle(turretObject.id));
            this.bfModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            this.bfModel.addGraphicEffect(this.chargeLightEffect);
        }
        private function createRailLightEffect(clientObject:ClientObject, param1:Vector3, param2:Vector3, turretObject:ClientObject):void
        {
            var sfxData:RailgunShootSFXData = this.getSFXData(clientObject);
            var _loc3_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
            var _loc4_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
            _loc3_.init(param1, 0);
            _loc4_.init(param2, 0);
            var _loc5_:TubeLightEffect = TubeLightEffect(objectPoolService.objectPool.getObject(TubeLightEffect));
            _loc5_.init(_loc3_, _loc4_, LightDataManager.getLightDataShot(turretObject.id));
            this.bfModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            this.bfModel.addGraphicEffect(_loc5_);
        }
        public function createShotLightEffect(param1:Vector3, turretObject:ClientObject):void
        {
            var _loc2_:AnimatedLightEffect = AnimatedLightEffect(objectPoolService.objectPool.getObject(AnimatedLightEffect));
            var _loc3_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
            _loc3_.init(param1, 0);
            _loc2_.init(_loc3_, LightDataManager.getLightDataExplosion(turretObject.id));
            this.bfModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            this.bfModel.addGraphicEffect(_loc2_);
        }
        public function createSoundShotEffect(clientObject:ClientObject, effectOwner:ClientObject, startGlobalPos:Vector3):ISound3DEffect
        {
            if (this.shotSound == null)
            {
                return (null);
            }
            var sound:Sound3D = Sound3D.create(this.shotSound, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, SOUND_VOLUME);
            return (Sound3DEffect.create(objectPoolService.objectPool, effectOwner, startGlobalPos, sound));
        }
        public function objectLoaded(clientObject:ClientObject):void
        {
            var ctVector:Vector.<ColorTransformEntry>;
            var ctData:ColorTransformEntry;
            var sfxData:RailgunShootSFXData = new RailgunShootSFXData();
            var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
            var colorTransformModel:IColorTransformModel = IColorTransformModel(modelService.getModelForObject(clientObject, IColorTransformModel));
            if (colorTransformModel != null)
            {
                ctVector = colorTransformModel.getModelData(clientObject);
                if (((!(ctVector == null)) && (ctVector.length > 0)))
                {
                    ctData = ctVector[0];
                    sfxData.colorTransform = new ColorTransform(ctData.redMultiplier, ctData.greenMultiplier, ctData.blueMultiplier, ctData.alphaMultiplier, ctData.redOffset, ctData.greenOffset, ctData.blueOffset, ctData.alphaOffset);
                }
            }
            clientObject.putParams(RailgunSFXModel, sfxData);
        }
        public function objectUnloaded(clientObject:ClientObject):void
        {
            this.numLoadedObjects--;
            if (this.numLoadedObjects == 0)
            {
                this.trailMaterial = null;
                this.chargeMaterials = null;
                this.shotSound = null;
            }
        }
        private function createChargeMaterials(chargingPart1:String, chargingPart2:String, chargingPart3:String):void
        {
            var chargeTexture:BitmapData;
            var part1:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, chargingPart1).bitmapData;
            if (part1 == null)
            {
                throw (new Error("NULL"));
            }
            var part2:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, chargingPart2).bitmapData;
            if (part2 == null)
            {
                throw (new Error("NULL"));
            }
            var part3:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, chargingPart3).bitmapData;
            if (part3 != null)
            {
                chargeTexture = this.createChargeTexture(part1, part2, part3);
                this.charingData = GraphicsUtils.getTextureAnimation(null, chargeTexture, 210, 210);
                this.charingData.fps = 30;
                this.chargeMaterials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT, chargeTexture, CHARGE_FRAME_SIZE, MIPMAP_RESOLUTION, true).materials;
                return;
            }
            throw (new Error("NULL"));
        }
        private function createChargeTexture(chargingPart1:BitmapData, chargingPart2:BitmapData, chargingPart3:BitmapData):BitmapData
        {
            var numFrames:int = 30;
            var texture:BitmapData = new BitmapData((CHARGE_FRAME_SIZE * numFrames), CHARGE_FRAME_SIZE, true, 0);
            var blendMode:String = "normal";
            var i:int = 1;
            while (i <= numFrames)
            {
                this.drawPart1(chargingPart1, texture, i, CHARGE_FRAME_SIZE, blendMode);
                this.drawPart2(chargingPart2, texture, i, CHARGE_FRAME_SIZE, blendMode);
                this.drawPart3(chargingPart3, texture, i, CHARGE_FRAME_SIZE, blendMode);
                i++;
            }
            return (texture);
        }
        private function drawPart1(sourceBitmapData:BitmapData, destBitmapData:BitmapData, frame:int, frameSize:int, blendMode:String):void
        {
            if (frame < 15)
            {
                this.colorTransform.alphaMultiplier = ((frame - 1) / 14);
            }
            else
            {
                if (frame < 26)
                {
                    this.colorTransform.alphaMultiplier = 1;
                }
                else
                {
                    this.colorTransform.alphaMultiplier = (1 - ((frame - 25) / 5));
                }
            }
            this.matrix.identity();
            this.matrix.tx = (((frame - 1) * frameSize) + (0.5 * (frameSize - sourceBitmapData.width)));
            this.matrix.ty = (0.5 * (frameSize - sourceBitmapData.height));
            destBitmapData.draw(sourceBitmapData, this.matrix, this.colorTransform, blendMode, null, true);
        }
        private function drawPart2(sourceBitmapData:BitmapData, destBitmapData:BitmapData, frame:int, frameSize:int, blendMode:String):void
        {
            if (frame < 6)
            {
                this.colorTransform.alphaMultiplier = ((frame - 1) / 5);
            }
            else
            {
                if (frame < 26)
                {
                    this.colorTransform.alphaMultiplier = 1;
                }
                else
                {
                    this.colorTransform.alphaMultiplier = (1 - ((frame - 25) / 5));
                }
            }
            this.matrix.identity();
            this.matrix.translate((-0.5 * sourceBitmapData.width), (-0.5 * sourceBitmapData.height));
            this.matrix.rotate((((2 * (frame - 1)) * Math.PI) / 180));
            this.matrix.translate((((frame - 1) * frameSize) + (0.5 * frameSize)), (0.5 * frameSize));
            destBitmapData.draw(sourceBitmapData, this.matrix, this.colorTransform, blendMode, null, true);
        }
        private function drawPart3(sourceBitmapData:BitmapData, destBitmapData:BitmapData, frame:int, frameSize:int, blendMode:String):void
        {
            var k:Number = NaN;
            var scale:Number = NaN;
            if (frame < 25)
            {
                k = ((frame - 1) / 24);
                this.colorTransform.alphaMultiplier = k;
                scale = (0.4 + (0.6 * k));
            }
            else
            {
                if (frame < 26)
                {
                    this.colorTransform.alphaMultiplier = 1;
                    scale = 1;
                }
                else
                {
                    k = (1 - ((frame - 25) / 5));
                    this.colorTransform.alphaMultiplier = k;
                    scale = (0.2 + (0.8 * k));
                }
            }
            this.matrix.identity();
            this.matrix.translate((-0.5 * sourceBitmapData.width), (-0.5 * sourceBitmapData.height));
            this.matrix.scale(scale, scale);
            this.matrix.rotate((((2 * (1 - frame)) * Math.PI) / 180));
            this.matrix.translate((((frame - 1) * frameSize) + (0.5 * frameSize)), (0.5 * frameSize));
            destBitmapData.draw(sourceBitmapData, this.matrix, this.colorTransform, blendMode, null, true);
        }

    }
}
