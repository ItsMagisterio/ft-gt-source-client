package alternativa.tanks.models.weapon.ricochet
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.physics.Body;
   import alternativa.physics.collision.ICollisionDetector;
   import alternativa.physics.collision.IRayCollisionPredicate;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.engine3d.AnimatedSprite3D;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.gamemode.GameModes;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.sfx.shoot.ricochet.RicochetSFXData;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.sfx.AnimatedSpriteEffectNew;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.SFXUtils;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.media.Sound;
   import flash.geom.ColorTransform;

   public class RicochetShot extends PooledObject implements IGraphicEffect, IRayCollisionPredicate
   {

      private static const SHOT_SIZE:Number = 300;

      private static const BUMP_FLASH_SIZE:Number = 80;

      private static const ANIMATION_FPS:Number = 30;

      private static const NUM_RADIAL_RAYS:int = 8;

      private static const RADIAL_ANGLE_STEP:Number = (2 * Math.PI) / NUM_RADIAL_RAYS;

      private static var rotationMatrix:Matrix3 = new Matrix3();

      private static var _normal:Vector3 = new Vector3();

      private static var _rayHit:RayIntersection = new RayIntersection();

      private static var _rayOrigin:Vector3 = new Vector3();

      private static var _rayDirection:Vector3 = new Vector3();

      private static var counter:int;

      public var id:int;

      public var shooterData:TankData;

      public var totalDistance:Number = 0;

      public var sfxData:RicochetSFXData;

      private var battlefield:IBattleField;

      private var radialPoints:Vector.<Vector3>;

      private var currPos:Vector3;

      private var direction:Vector3;

      private var listener:IRicochetShotListener;

      private var ricochetData:RicochetData;

      private var collisionDetector:ICollisionDetector;

      private var sprite:AnimatedSprite3D;

      private var numFrames:int;

      private var currFrame:Number;

      private var battleField:BattlefieldModel;

      private var omni:OmniLight;

      private var weakeningModel:IWeaponWeakeningModel;

      private var ricochetCount:int;

      private var tailTrail:TailTrail;

      private var isFirstFrame:Boolean;

      public function RicochetShot(objectPool:ObjectPool)
      {
         this.currPos = new Vector3();
         this.direction = new Vector3();
         this.battleField = Main.osgi.getService(IBattleField) as BattlefieldModel;
         this.omni = new OmniLight(1, (SHOT_SIZE / 2 - 50) * 2.2, SHOT_SIZE * 2.2);
         this.omni.intensity = 0.25;
         super(objectPool);
         this.radialPoints = new Vector.<Vector3>(NUM_RADIAL_RAYS, true);
         for (var i:int = 0; i < NUM_RADIAL_RAYS; i++)
         {
            this.radialPoints[i] = new Vector3();
         }
         this.sprite = new AnimatedSprite3D(300, 300);
         this.sprite.softAttenuation = 80;
         this.sprite.looped = true;
         this.tailTrail = new TailTrail(100, 300);
      }
      private static function lerpColor(param1:uint, param2:uint, param3:Number):uint
      {
         var _loc4_:Number = (((param1 >> 16) & 0xFF) / 0xFF);
         var _loc5_:Number = (((param1 >> 8) & 0xFF) / 0xFF);
         var _loc6_:Number = ((param1 & 0xFF) / 0xFF);
         var _loc7_:Number = (((param2 >> 16) & 0xFF) / 0xFF);
         var _loc8_:Number = (((param2 >> 8) & 0xFF) / 0xFF);
         var _loc9_:Number = ((param2 & 0xFF) / 0xFF);
         var _loc10_:int = (lerpNumber(_loc4_, _loc7_, param3) * 0xFF);
         var _loc11_:int = (lerpNumber(_loc5_, _loc8_, param3) * 0xFF);
         var _loc12_:int = (lerpNumber(_loc6_, _loc9_, param3) * 0xFF);
         return (((_loc10_ << 16) | (_loc11_ << 8)) | _loc12_);
      }
      private static function lerpNumber(param1:Number, param2:Number, param3:Number):Number
      {
         return (param1 + ((param2 - param1) * param3));
      }
      public function init(startPos:Vector3, direction:Vector3, shooterData:TankData, ricochetData:RicochetData, sfxData:RicochetSFXData, collisionDetector:ICollisionDetector, weakeningModel:IWeaponWeakeningModel, listener:IRicochetShotListener, battlefield:IBattleField):void
      {
         this.currPos.vCopy(startPos);
         this.direction.vCopy(direction);
         this.shooterData = shooterData;
         this.ricochetData = ricochetData;
         this.sfxData = sfxData;
         this.collisionDetector = collisionDetector;
         this.weakeningModel = weakeningModel;
         this.listener = listener;
         this.battlefield = battlefield;
         this.id = counter++;
         this.numFrames = sfxData.shotMaterials.length;
         this.currFrame = this.numFrames * Math.random();
         this.sprite.rotation = 6.28 * Math.random();
         this.sprite.colorTransform = null;
         var animaton:TextureAnimation = sfxData.dataShot;
         this.sprite.setAnimationData(animaton);
         this.sprite.setFrameIndex(this.sprite.getNumFrames() * Math.random());
         this.tailTrail.material = sfxData.tailTrailMaterial;
         this.tailTrail.colorTransform = null;
         this.initRadialPoints(startPos, direction, ricochetData.shotRadius);
         this.totalDistance = 0;
         this.ricochetCount = 0;
         this.isFirstFrame = true;
      }

      public function addToContainer(container:Scene3DContainer):void
      {
         container.addChild(this.sprite);
         container.addChild(this.tailTrail);
         container.addChild(this.omni);
         this.omni.color = 0xfca500;
      }

      public function get owner():ClientObject
      {
         return null;
      }

      public function play(millis:int, camera:GameCamera):Boolean
      {
         var currDistance:Number = NaN;
         var body:Body = null;
         var hitTime:Number = NaN;
         var i:int = 0;
         var origin:Vector3 = null;
         var bumpFlashEffect:AnimatedSpriteEffectNew = null;
         var posProvider:StaticObject3DPositionProvider = null;
         var animaton:TextureAnimation = null;

         if (this.totalDistance > this.ricochetData.shotDistance)
         {
            return false;
         }

         if (this.isFirstFrame)
         {
            this.isFirstFrame = false;
            _rayOrigin.x = this.currPos.x;
            _rayOrigin.y = this.currPos.y;
            _rayOrigin.z = this.currPos.z + this.ricochetData.shotRadius;
            _rayDirection.z = -1;
            if (this.collisionDetector.intersectRayWithStatic(_rayOrigin, _rayDirection, CollisionGroup.STATIC, this.ricochetData.shotRadius, null, _rayHit))
            {
               return false;
            }
         }

         var dt:Number = millis / 1000;
         var frameDistance:Number = this.ricochetData.shotSpeed * dt;

         while (frameDistance > 0)
         {
            hitTime = -1;

            // Use collision detection logic from Twins
            if (this.collisionDetector.intersectRay(this.currPos, this.direction, CollisionGroup.WEAPON, frameDistance, this, _rayHit))
            {
               hitTime = _rayHit.t;
               body = _rayHit.primitive.body;

               if (body != null)
               {
                  this.currPos.vAddScaled(hitTime, this.direction);
                  this.listener.shotHit(this, this.currPos, this.direction, body);
                  return false;
               }

               currDistance = hitTime;
               _normal.vCopy(_rayHit.normal);
            }
            else
            {
               currDistance = frameDistance;
            }

            for (i = 0; i < NUM_RADIAL_RAYS; i++)
            {
               origin = this.radialPoints[i];

               if (this.collisionDetector.intersectRay(origin, this.direction, CollisionGroup.WEAPON, currDistance, null, _rayHit))
               {
                  body = _rayHit.primitive.body;

                  if (body != null && !(this.shooterData.tank == body && this.ricochetCount == 0))
                  {
                     this.currPos.vAddScaled(_rayHit.t, this.direction);
                     this.listener.shotHit(this, this.currPos, this.direction, body);
                     return false;
                  }
               }

               origin.vAddScaled(currDistance, this.direction);
            }

            if (hitTime > -1)
            {
               ++ this.ricochetCount;
               this.totalDistance += hitTime;
               frameDistance -= hitTime;
               this.currPos.vAddScaled(hitTime, this.direction).vAddScaled(0.1, _normal);
               this.direction.vAddScaled(-2 * this.direction.vDot(_normal), _normal);
               this.initRadialPoints(this.currPos, this.direction, this.ricochetData.shotRadius);

               bumpFlashEffect = AnimatedSpriteEffectNew(objectPool.getObject(AnimatedSpriteEffectNew));
               posProvider = StaticObject3DPositionProvider(objectPool.getObject(StaticObject3DPositionProvider));
               posProvider.init(this.currPos, 50);
               animaton = this.sfxData.dataFlash;
               bumpFlashEffect.init(BUMP_FLASH_SIZE, BUMP_FLASH_SIZE, animaton, Math.random() * Math.PI * 2, posProvider, 0.5, 0.5, null, 0);
               this.battlefield.addGraphicEffect(bumpFlashEffect);
               this.addSoundEffect(this.sfxData.ricochetSound, this.currPos, SoundOptions.nearRadius, SoundOptions.farRadius, SoundOptions.farDelimiter, 0.8);
            }
            else
            {
               this.totalDistance += frameDistance;
               this.currPos.vAddScaled(frameDistance, this.direction);
               frameDistance = 0;
            }
         }

         this.sprite.x = this.currPos.x;
         this.sprite.y = this.currPos.y;
         this.sprite.z = this.currPos.z;
         this.omni.x = this.currPos.x;
         this.omni.y = this.currPos.y;
         this.omni.z = this.currPos.z;
         this.sprite.update(dt);
         var impactCoeff:Number = this.weakeningModel.getImpactCoeff(this.shooterData.turret, 0.01 * this.totalDistance);
         var size:Number = SHOT_SIZE * impactCoeff;
         this.sprite.width = size;
         this.sprite.height = size;
         this.sprite.rotation -= 0.003 * millis;
         var cameraPosition:Vector3 = camera.pos;
         SFXUtils.alignObjectPlaneToView(this.tailTrail, this.currPos, this.direction, camera.pos);
         var dx:Number = this.currPos.x - cameraPosition.x;
         var dy:Number = this.currPos.y - cameraPosition.y;
         var dz:Number = this.currPos.z - cameraPosition.z;
         var len:Number = dx * dx + dy * dy + dz * dz;

         if (len > 0.00001)
         {
            len = 1 / Math.sqrt(len);
            dx *= len;
            dy *= len;
            dz *= len;
         }

         var dot:Number = dx * this.direction.x + dy * this.direction.y + dz * this.direction.z;

         if (dot < 0)
         {
            dot = -dot;
         }

         if (dot > 0.5)
         {
            this.tailTrail.alpha = 2 * (1 - dot) * impactCoeff;
         }
         else
         {
            this.tailTrail.alpha = impactCoeff;
         }

         if (this.totalDistance > (this.ricochetData.shotDistance - 1000))
         {
            var remainingDistance:Number = this.ricochetData.shotDistance - this.totalDistance;
            if (remainingDistance >= 0)
            {
               var alpha:Number = Math.round((remainingDistance / 1000) * 100) / 100;
               trace("remaining distance:", remainingDistance, "alpha:", alpha);
               this.sprite.alpha = alpha;
            }
            else
            {
               this.sprite.alpha = 0;
            }
         }
         else
         {
            this.sprite.alpha = 1;
         }

         return true;
      }

      public function destroy():void
      {
         this.sprite.alternativa3d::removeFromParent();
         this.omni.parent.removeChild(this.omni);
         this.sprite.material = null;
         this.sprite.colorTransform = null;
         this.tailTrail.alternativa3d::removeFromParent();
         this.tailTrail.material = null;
         this.tailTrail.colorTransform = null;
         this.shooterData = null;
         this.ricochetData = null;
         this.sfxData = null;
         this.collisionDetector = null;
         this.weakeningModel = null;
         this.listener = null;
         this.battlefield = null;
         storeInPool();
      }

      public function kill():void
      {
         this.totalDistance = this.ricochetData.shotDistance + 1;
      }

      public function considerBody(body:Body):Boolean
      {
         return !(body == this.shooterData.tank && this.ricochetCount == 0);
      }

      override protected function getClass():Class
      {
         return RicochetShot;
      }

      private function initRadialPoints(centerPoint:Vector3, dir:Vector3, radius:Number):void
      {
         var i:int = 0;
         var axis:int = 0;
         var min:Number = 1e+308;
         var d:Number = dir.x < 0 ? Number(-dir.x) : Number(dir.x);
         if (d < min)
         {
            min = d;
            axis = 0;
         }
         d = dir.y < 0 ? Number(-dir.y) : Number(dir.y);
         if (d < min)
         {
            min = d;
            axis = 1;
         }
         d = dir.z < 0 ? Number(-dir.z) : Number(dir.z);
         if (d < min)
         {
            axis = 2;
         }
         var v:Vector3 = new Vector3();
         switch (axis)
         {
            case 0:
               v.x = 0;
               v.y = dir.z;
               v.z = -dir.y;
               break;
            case 1:
               v.x = -dir.z;
               v.y = 0;
               v.z = dir.x;
               break;
            case 2:
               v.x = dir.y;
               v.y = -dir.x;
               v.z = 0;
         }
         v.vNormalize().vScale(radius);
         rotationMatrix.fromAxisAngle(dir, RADIAL_ANGLE_STEP);
         Vector3(this.radialPoints[0]).vCopy(centerPoint).vAdd(v);
         for (i = 1; i < NUM_RADIAL_RAYS; i++)
         {
            v.vTransformBy3(rotationMatrix);
            Vector3(this.radialPoints[i]).vCopy(centerPoint).vAdd(v);
         }
      }

      private function addSoundEffect(sound:Sound, position:Vector3, nearRadius:Number, farRadius:Number, farDelimiter:Number, soundVolume:Number):void
      {
         var sound3d:Sound3D = null;
         var soundEffect:Sound3DEffect = null;
         if (sound != null)
         {
            sound3d = Sound3D.create(sound, nearRadius, farRadius, farDelimiter, soundVolume);
            soundEffect = Sound3DEffect.create(objectPool, null, position, sound3d);
            this.battlefield.addSound3DEffect(soundEffect);
         }
      }
   }
}

import alternativa.tanks.models.sfx.SimplePlane;

class TailTrail extends SimplePlane
{

   function TailTrail(width:Number, length:Number)
   {
      super(width, length, 0.5, 1);
      setUVs(1, 1, 1, 0, 0, 0, 0, 1);
      shadowMapAlphaThreshold = 2;
      depthMapAlphaThreshold = 2;
      useShadowMap = false;
      useLight = false;
   }
}
