package alternativa.tanks.models.tank.criticalhit
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.service.IModelService;
   import alternativa.tanks.engine3d.MaterialSequence;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.AnimatedPlaneEffect;
   import alternativa.tanks.sfx.AnimatedSpriteEffectNew;
   import alternativa.tanks.sfx.MovingObject3DPositionProvider;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.utils.GraphicsUtils;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import com.alternativaplatform.projects.tanks.client.models.tank.criticalhit.ITankCriticalHitModelBase;
   import com.alternativaplatform.projects.tanks.client.models.tank.criticalhit.TankCriticalHitModelBase;
   import flash.display.BitmapData;
   import logic.resource.ResourceType;
   import logic.resource.ResourceUtil;

   public class TankCriticalHitModel extends TankCriticalHitModelBase implements ITankCriticalHitModelBase, IObjectLoadListener, ITankCriticalHitModel
   {

      private const EXPLOSION_SIZE:Number = 800;

      private const SMOKE_SIZE:Number = 400;

      private const SHOCKWAVE_SIZE:Number = 1000;

      private const BASE_DIAGONAL:Number = 600;

      private const MIN_SMOKE_SPEED:Number = 800;

      private const SMOKE_SPEED_DELTA:Number = 200;

      private const SMOKE_ACCELERATION:Number = -2000;

      private const EXPLOSION_FPS:Number = 25;

      private const SMOKE_FPS:Number = 15;

      private var objectPoolService:IObjectPoolService;

      private var materialRegistry:IMaterialRegistry;

      private var explosionSize:ConsoleVarFloat;

      private var smokeSize:ConsoleVarFloat;

      private var scaleModifier:ConsoleVarFloat;

      private var shockWaveScaleSpeed:ConsoleVarFloat;

      private var battlefieldModel:IBattleField;

      private var rayHit:RayIntersection;

      private var position:Vector3;

      private var eulerAngles:Vector3;

      private var velocity:Vector3;

      private var matrix:Matrix3;

      public function TankCriticalHitModel()
      {
         this.objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
         this.materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
         this.explosionSize = new ConsoleVarFloat("tankexpl_size", this.EXPLOSION_SIZE, 1, 500);
         this.scaleModifier = new ConsoleVarFloat("tankexpl_scale", 1, 0, 10);
         this.rayHit = new RayIntersection();
         this.position = new Vector3();
         this.eulerAngles = new Vector3();
         this.velocity = new Vector3();
         this.matrix = new Matrix3();
         super();
         _interfaces.push(IModel, IObjectLoadListener, ITankCriticalHitModel);
      }

      public function initObject(clientObject:ClientObject, explosionTextureId:String, shockWaveTextureId:String, smokeTextureId:String):void
      {
         var modelService:IModelService = null;
         if (this.battlefieldModel == null)
         {
            modelService = IModelService(Main.osgi.getService(IModelService));
            this.battlefieldModel = Main.osgi.getService(IBattleField) as IBattleField;
         }
         var explosionSequence:MaterialSequence = this.getMaterialSequence(explosionTextureId, this.EXPLOSION_SIZE);
         var explData:TextureAnimation = GraphicsUtils.getTextureAnimation(null, ResourceUtil.getResource(ResourceType.IMAGE, "criticalHitTexture").bitmapData, 200, 200);
         explData.fps = 25;
         var explosionSFXData:ExplosionData = new ExplosionData(explosionSequence, null, null);
         explosionSFXData.explosionData = explData;
         clientObject.putParams(TankCriticalHitModel, explosionSFXData);
      }

      public function objectLoaded(object:ClientObject):void
      {
      }

      public function objectUnloaded(object:ClientObject):void
      {
         this.getData(object).release();
      }

      public function createExplosionEffects(clientObject:ClientObject, tankData:TankData):void
      {
         var explosionData:ExplosionData = null;
         explosionData = null;
         var effectScale:Number = NaN;
         var size:Number = NaN;
         var minTime:Number = NaN;
         var angle:Number = NaN;
         var speed:Number = NaN;
         var smokeSize:Number = NaN;
         explosionData = this.getData(clientObject);
         var objectPool:ObjectPool = this.objectPoolService.objectPool;
         var hullMesh:Mesh = tankData.tank.skin.hullMesh;
         var dx:Number = hullMesh.boundMaxX - hullMesh.boundMinX;
         var dy:Number = hullMesh.boundMaxY - hullMesh.boundMinY;
         var dz:Number = hullMesh.boundMaxZ - hullMesh.boundMinZ;
         var diagonal:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
         effectScale = this.scaleModifier.value * diagonal / this.BASE_DIAGONAL;
         var dir:Vector3 = new Vector3(0, 0, -1);
         this.position.vCopy(tankData.tank.state.pos);
         this.position.z += 50;
         var explosion:AnimatedSpriteEffectNew = AnimatedSpriteEffectNew(objectPool.getObject(AnimatedSpriteEffectNew));
         var animaton:TextureAnimation = explosionData.explosionData;
         var pos:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPool.getObject(StaticObject3DPositionProvider));
         pos.init(this.position, 200);
         var explosionSize:Number = this.explosionSize.value * effectScale;
         var explosionSequence:MaterialSequence = explosionData.explosionSequence;
         explosionSequence.mipMapResolution = explosionSize / explosionSequence.frameWidth;
         explosion.init(400, 400, animaton, Math.random() * 2 * Math.PI, pos);
         this.battlefieldModel.addGraphicEffect(explosion);
      }

      private function getData(clientObject:ClientObject):ExplosionData
      {
         return ExplosionData(clientObject.getParams(TankCriticalHitModel));
      }

      private function getMaterialSequence(textureId:String, size:Number):MaterialSequence
      {
         var texture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE, textureId).bitmapData;
         var frameSize:int = texture.height;
         return this.materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT, texture, frameSize, size / frameSize);
      }
   }
}

import alternativa.tanks.engine3d.MaterialSequence;
import alternativa.tanks.engine3d.TextureAnimation;

class ExplosionData
{

   public var explosionSequence:MaterialSequence;

   public var shockWaveSequence:MaterialSequence;

   public var smokeSequence:MaterialSequence;

   public var explosionData:TextureAnimation;

   public var shockData:TextureAnimation;

   public var smokeData:TextureAnimation;

   function ExplosionData(explosionSequence:MaterialSequence, shockWaveSequence:MaterialSequence, smokeSequence:MaterialSequence)
   {
      super();
      this.explosionSequence = explosionSequence;
      this.shockWaveSequence = shockWaveSequence;
      this.smokeSequence = smokeSequence;
   }

   public function release():void
   {
      this.explosionSequence.release();
      this.shockWaveSequence.release();
      this.smokeSequence.release();
   }
}
