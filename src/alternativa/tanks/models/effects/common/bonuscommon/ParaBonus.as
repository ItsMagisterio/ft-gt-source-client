package alternativa.tanks.models.effects.common.bonuscommon
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.BodyState;
   import alternativa.physics.PhysicsScene;
   import alternativa.physics.PhysicsUtils;
   import alternativa.physics.altphysics;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.ICollisionPredicate;
   import alternativa.physics.collision.primitives.CollisionBox;
   import alternativa.physics.constraints.MaxDistanceConstraint;
   import alternativa.physics.rigid.SkinnedBody3D;
   import alternativa.tanks.bonuses.*;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.hidableobjects.HidableObject3DWrapper;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.vehicles.tanks.Tank;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;

   use namespace altphysics;

   public class ParaBonus extends SkinnedBody3D implements IBonus, ICollisionPredicate
   {

      private static const BOX_MASS:Number = 20;

      private static const BOX_HALF_SIZE:Number = 75;

      private static const PARACHUTE_MASS:Number = 10;

      private static const PARACHUTE_RADIUS:Number = 180;

      private static const CORDS_LENGTH:Number = 400;

      private static const TAKEN_ANIMATION_TIME:int = 2000;

      private static const FLASH_DURATION:int = 300;

      private static const ALPHA_DURATION:int = TAKEN_ANIMATION_TIME - FLASH_DURATION;

      private static const MAX_ADDITIVE_VALUE:int = 204;

      private static const ADDITIVE_SPEED_UP:Number = Number(MAX_ADDITIVE_VALUE) / FLASH_DURATION;

      private static const ADDITIVE_SPEED_DOWN:Number = Number(MAX_ADDITIVE_VALUE) / (TAKEN_ANIMATION_TIME - FLASH_DURATION);

      private static const UP_SPEED:Number = 300;

      private static const ANGLE_SPEED:Number = 2;

      private static const PHYSICS_STATE_FULL:int = 1;

      private static const PHYSICS_STATE_PARABOX:int = 2;

      private static const PHYSICS_STATE_BOX:int = 3;

      private static const WARNING_TIME:int = 8000;

      private static const PARACHUTE_REMOVAL_TIME:int = 2000;

      private static const BLINK_INTERVAL:int = 500;

      private static const DELTA_ALPHA:Number = 0.5;

      private static const MIN_ALPHA:Number = 1 - DELTA_ALPHA;

      private static const COEFF:Number = 10;

      private static const defaultState:BodyState = new BodyState();

      private static var pools:Dictionary = new Dictionary();

      private var _bonusId:String;

      private var bonusState:int;

      private var bonusListener:IBonusListener;

      private var parachute:Parachute;

      private var cordsMesh:Cords;

      private var skinMesh:Mesh;

      private var box:BonusMesh;

      private var cordsConstaints:Vector.<MaxDistanceConstraint>;

      private var timeToLive:int;

      private var currBlinkInterval:int;

      private var visibilitySwitchTime:int;

      private var takenAnimationTime:int;

      private var parachuteTimeLeft:int;

      private var additiveValue:int;

      private var alphaSpeed:Number;

      private var physicsState:int;

      private var pool:Pool;

      private var light:OmniLight;

      private var hidabbleWrapper:HidableObject3DWrapper;

      private var instantDrop:Boolean = false;

      public function ParaBonus(pool:Pool, boxMesh:Mesh, parachuteMesh:Mesh, parachuteInnerMesh:Mesh, cordMaterial:Material)
      {
         this.light = new OmniLight(16745512, 150, 500);
         super(1 / BOX_MASS, Matrix3.IDENTITY);
         this.pool = pool;
         var hs:Vector3 = new Vector3(BOX_HALF_SIZE, BOX_HALF_SIZE, BOX_HALF_SIZE);
         PhysicsUtils.getBoxInvInertia(BOX_MASS, hs, invInertia);
         var collisionBox:CollisionBox = new CollisionBox(hs, CollisionGroup.BONUS_WITH_STATIC);
         collisionBox.postCollisionPredicate = this;
         addCollisionPrimitive(collisionBox);
         canFreeze = true;
         skin = boxMesh.clone();
         this.skinMesh = boxMesh;
         this.hidabbleWrapper = new HidableObject3DWrapper(skin);
         this.createParachuteAndCords(parachuteMesh, parachuteInnerMesh, cordMaterial);
      }

      public static function create(bonusData:BonusCommonData):ParaBonus
      {
         var pool:Pool = pools[bonusData];
         if (pool == null)
         {
            pool = new Pool();
            pools[bonusData] = pool;
         }
         if (pool.numObjects == 0)
         {
            return new ParaBonus(pool, bonusData.boxMesh, bonusData.parachuteMesh, bonusData.parachuteInnerMesh, bonusData.cordMaterial);
         }
         var bonus:ParaBonus = pool.objects[-- pool.numObjects];
         pool.objects[pool.numObjects] = null;
         return bonus;
      }

      public static function deletePool(bonusData:BonusCommonData):void
      {
         delete pools[bonusData];
      }

      public function init(bonusId:String, timeToLive:int, isFalling:Boolean, instant:Boolean):void
      {
         if (BonusCache.isBonusMeshCacheEmpty(bonusId))
         {
            this.box = new BonusMesh(_bonusId, this.skinMesh);
         }
         else
         {
            this.box = BonusCache.getBonusMesh(_bonusId);
         }
         this.instantDrop = instant;
         this._bonusId = bonusId;
         this.timeToLive = timeToLive < 0 ? int.MAX_VALUE : timeToLive;
         this.bonusState = isFalling ? BonusState.FALLING : BonusState.RESTING;
         collisionPrimitives.head.primitive.collisionGroup |= CollisionGroup.BONUS_WITH_TANK;
         skin.alpha = 0;
         var colorTransform:ColorTransform = skin.colorTransform;
         if (colorTransform != null)
         {
            colorTransform.redOffset = 0;
            colorTransform.greenOffset = 0;
            colorTransform.blueOffset = 0;
         }
         this.additiveValue = 0;
         this.parachute.outerMesh.alpha = 1;
         this.parachute.outerMesh.useShadowMap = false;
         this.cordsMesh.alpha = 1;
         this.visibilitySwitchTime = 0;
         this.takenAnimationTime = TAKEN_ANIMATION_TIME;
         this.parachuteTimeLeft = PARACHUTE_REMOVAL_TIME;
         this.currBlinkInterval = BLINK_INTERVAL;
         frozen = false;
         freezeCounter = 0;
         state.copy(defaultState);
         prevState.copy(defaultState);
         this.parachute.state.copy(defaultState);
         this.parachute.prevState.copy(defaultState);

         var colorLight:uint = 16745512;
         if (bonusId.indexOf("health") >= 0)
         {
            colorLight = 0xFF00;
         }
         if (bonusId.indexOf("armor") >= 0)
         {
            colorLight = 0xFFFFFF;
         }
         if (bonusId.indexOf("damage") >= 0)
         {
            colorLight = 0xFFFF;
         }
         if (bonusId.indexOf("nitro") >= 0)
         {
            colorLight = 0xFF0000;
         }
         if (bonusId.indexOf("crystall") >= 0)
         {
            colorLight = 8454143;
         }
         if (bonusId.indexOf("gold") >= 0)
         {
            colorLight = 16777088;
         }
         this.light = new OmniLight(colorLight, 150, 500);
      }

      public function get bonusId():String
      {
         return this._bonusId;
      }

      public function isFalling():Boolean
      {
         return this.bonusState == BonusState.FALLING;
      }

      public function readBonusPosition(result:Vector3):void
      {
         result.x = state.pos.x;
         result.y = state.pos.y;
         result.z = state.pos.z;
      }

      public function setBonusPosition(x:Number, y:Number, z:Number):void
      {
         state.pos.vReset(x, y, z);
         prevState.copy(state);
      }

      public function setRestingState(x:Number, y:Number, z:Number):void
      {
         setPositionXYZ(x, y, z);
         frozen = false;
         freezeCounter = 0;
         if (this.bonusState != BonusState.RESTING)
         {
            this.bonusState = BonusState.RESTING;
            this.detachParachute();
         }
      }

      public function setTakenState():void
      {
         this.takenAnimationTime = TAKEN_ANIMATION_TIME;
         _skin.alpha = 1;
         if (this.bonusState == BonusState.FALLING)
         {
            this.detachParachute();
         }
         this.bonusState = BonusState.TAKEN;
      }

      public function setRemovedState():void
      {
         this.bonusState = BonusState.REMOVING;
      }

      public function attach(pos:Vector3, rigidWorld:PhysicsScene, container:Scene3DContainer, listener:IBonusListener):void
      {
         this.light.x = pos.x;
         this.light.y = pos.y;
         this.light.z = pos.z - 400;
         var c:MaxDistanceConstraint = null;
         rigidWorld.addBody(this);
         TanksCollisionDetector(rigidWorld.collisionDetector).addBody(this);
         if (container != null)
         {
            container.addChild(this.box);
            BattlefieldModel(Main.osgi.getService(IBattleField)).hidableObjects.add(this.hidabbleWrapper);
         }
         state.pos.x = pos.x + 50;
         state.pos.y = pos.y + 50;
         state.pos.z = pos.z;
         state.rotation.z = 0.15;
         prevState.copy(state);
         if (this.bonusState == BonusState.FALLING)
         {
            rigidWorld.addBody(this.parachute);
            this.parachute.addToContainer(container);
            for each (c in this.cordsConstaints)
            {
               rigidWorld.addConstraint(c);
            }
            this.parachute.state.pos.vCopy(pos);
            this.parachute.state.pos.z += 0.5 * CORDS_LENGTH;
            this.parachute.state.rotation.z = 0.3;
            this.parachute.prevState.copy(this.parachute.state);
            if (container != null)
            {
               container.addChild(this.cordsMesh);
            }
            this.physicsState = PHYSICS_STATE_FULL;
         }
         else
         {
            this.physicsState = PHYSICS_STATE_BOX;
         }
         this.updateSkin(1);
         _skin.name = "bonus";
         _skin.useLight = false;
         _skin.useShadowMap = false;
         this.bonusListener = listener;
         this.box.x = pos.x;
         this.box.y = pos.y;
         this.box.z = pos.z;
         this.box.rotationX = state.rotation.x;
         this.box.rotationY = state.rotation.y;
         this.box.rotationZ = state.rotation.z;
      }

      public function update(time:int, millis:int, interpolationTime:Number):Boolean
      {
         this.updateSkin(interpolationTime);
         this.timeToLive -= millis;
         if (this.bonusState == BonusState.FALLING)
         {
            return true;
         }
         if (this.bonusState == BonusState.TAKEN)
         {
            if (this.takenAnimationTime < 0)
            {
               return false;
            }
            this.playTakenAnimation(millis);
         }
         if (this.parachuteTimeLeft > 0)
         {
            this.parachuteTimeLeft -= millis;
            if (this.parachuteTimeLeft <= 0)
            {
               this.removeParachuteGraphics();
               this.removeParachutePhysics();
            }
            else
            {
               var _loc4_:* = this.parachuteTimeLeft / PARACHUTE_REMOVAL_TIME;
               this.parachute.outerMesh.alpha = this.parachuteTimeLeft / PARACHUTE_REMOVAL_TIME;
               this.cordsMesh.alpha = _loc4_;
            }
         }
         if ((this.bonusState == BonusState.RESTING || this.bonusState == BonusState.REMOVING) && this.timeToLive < WARNING_TIME)
         {
            this.playWarningAnimation(time, millis);
         }
         if (this.bonusState == BonusState.REMOVING && this.timeToLive > WARNING_TIME)
         {
            return false;
         }
         return this.bonusState != BonusState.REMOVED;
      }

      public function destroy():void
      {
         _skin.alternativa3d::removeFromParent();
         BattlefieldModel(Main.osgi.getService(IBattleField)).hidableObjects.remove(this.hidabbleWrapper);
         if (skin != null)
         {
            skin = null;
         }
         if (_skin != null)
         {
            _skin = null;
         }
         try
         {
            BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.viewport.getMapContainer().removeChild(this.box);
         }
         catch (e)
         {
            trace("exiting battle");
         }
         this.removeParachuteGraphics();
         this.removeCordConstraints();
         this.removeParachutePhysics();
         TanksCollisionDetector(world.collisionDetector).removeBody(this);
         world.removeBody(this);
         var _loc1_:* = this.pool.numObjects++;
         this.pool.objects[_loc1_] = this;
      }

      public function considerCollision(primitive:CollisionPrimitive):Boolean
      {
         if (primitive.body == null)
         {
            if (this.bonusState == BonusState.FALLING)
            {
               this.onStaticCollision();
            }
            return true;
         }
         if (primitive.body is Tank)
         {
            this.onTankCollision();
         }
         return false;
      }

      private function onStaticCollision():void
      {
         this.bonusState = BonusState.RESTING;
         this.detachParachute();
         if (this.bonusListener != null)
         {
            this.bonusListener.onBonusDropped(this);
         }
      }

      private function detachParachute():void
      {
         this.removeCordConstraints();
         this.startParachuteDissolving();
      }

      private function startParachuteDissolving():void
      {
         this.parachuteTimeLeft = PARACHUTE_REMOVAL_TIME;
      }

      private function onTankCollision():void
      {
         collisionPrimitives.head.primitive.collisionGroup &= ~CollisionGroup.BONUS_WITH_TANK;
         this.bonusListener.onTankCollision(this);
      }

      override public function updateSkin(t:Number):void
      {
         super.updateSkin(t);
         if (this.parachute != null)
         {
            this.parachute.updateSkin(t);
            this.cordsMesh.updateVertices();
         }
         this.box.x = _skin.x;
         this.box.y = _skin.y;
         this.box.z = _skin.z;
         this.box.rotationX = _skin.rotationX;
         this.box.rotationY = _skin.rotationY;
         this.box.rotationZ = _skin.rotationZ;
      }

      private function createParachuteAndCords(parachuteMesh:Mesh, parachuteInnerMesh:Mesh, cordsMaterial:Material):void
      {
         var angle:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         this.parachute = new Parachute(PARACHUTE_MASS, PARACHUTE_RADIUS, 10, 0.8, 0, parachuteMesh, parachuteInnerMesh);
         this.cordsMesh = new Cords(266, BOX_HALF_SIZE, 12, skin, this.parachute.outerMesh);
         this.cordsMesh.setMaterialToAllFaces(cordsMaterial);
         this.cordsConstaints = new Vector.<MaxDistanceConstraint>();
         var numStraps:int = 4;
         var angleStep:Number = 2 * Math.PI / numStraps;
         for (var i:int = 0; i < numStraps; i++)
         {
            angle = i * angleStep;
            x = PARACHUTE_RADIUS * Math.cos(angle);
            y = PARACHUTE_RADIUS * Math.sin(angle);
            this.cordsConstaints.push(new MaxDistanceConstraint(this.parachute, this, new Vector3(x, y, 0), new Vector3(0, 0, 50), CORDS_LENGTH));
         }
      }

      private function removeParachuteGraphics():void
      {
         if (this.parachute != null)
         {
            this.parachute.removeFromContainer();
            // this.parachute.outerMesh.destroy(); FIXME
            this.parachute.outerMesh = null;
         }
         if (this.cordsMesh != null)
         {
            this.cordsMesh.alternativa3d::removeFromParent();
            this.cordsMesh.destroy(); // FIXME
            this.cordsMesh = null;
         }
      }

      private function removeCordConstraints():void
      {
         var c:MaxDistanceConstraint = null;
         if (this.physicsState == PHYSICS_STATE_FULL)
         {
            for each (c in this.cordsConstaints)
            {
               c.altphysics::world.removeConstraint(c);
            }
            this.parachute.state.rotation.vScale(0.05);
            this.parachute.altphysics::saveState();
            this.physicsState = PHYSICS_STATE_PARABOX;
         }
      }

      private function removeParachutePhysics():void
      {
         if (this.physicsState == PHYSICS_STATE_PARABOX)
         {
            if (this.parachute != null)
            {
               this.parachute.world.removeBody(this.parachute);
               this.parachute = null;
            }
            this.physicsState = PHYSICS_STATE_BOX;
         }
      }

      private function playWarningAnimation(time:int, deltaMsec:Number):void
      {
         if (box == null)
         {
            return;
         }
         if (this.visibilitySwitchTime == 0)
         {
            this.alphaSpeed = -COEFF * DELTA_ALPHA / this.currBlinkInterval;
            this.visibilitySwitchTime = time + this.currBlinkInterval;
         }
         else
         {
            box.alpha += this.alphaSpeed * deltaMsec;
            if (this.bonusState == BonusState.REMOVING && this.alphaSpeed < 0)
            {
               if (box.alpha <= 0)
               {
                  this.bonusState = BonusState.REMOVED;
               }
            }
            else
            {
               if (box.alpha < MIN_ALPHA)
               {
                  box.alpha = MIN_ALPHA;
               }
               if (time >= this.visibilitySwitchTime)
               {
                  if (this.currBlinkInterval > 22)
                  {
                     this.currBlinkInterval -= 12;
                  }
                  this.visibilitySwitchTime += this.currBlinkInterval;
                  if (this.alphaSpeed < 0)
                  {
                     this.alphaSpeed = COEFF * DELTA_ALPHA / this.currBlinkInterval;
                     box.alpha = MIN_ALPHA;
                  }
                  else
                  {
                     this.alphaSpeed = -COEFF * DELTA_ALPHA / this.currBlinkInterval;
                     box.alpha = 1;
                  }
               }
            }
         }
         if (this.currBlinkInterval < 22)
         {
            box.alpha = 0;
         }
      }

      private function playTakenAnimation(millis:int):void
      {
         addForce(new Vector3(0, 0, world._gravity.vLength() / invMass));
         state.velocity.vReset(0, 0, UP_SPEED * this.takenAnimationTime / TAKEN_ANIMATION_TIME + UP_SPEED * 0.1);
         state.rotation.vReset(0, 0, ANGLE_SPEED * this.takenAnimationTime / TAKEN_ANIMATION_TIME + ANGLE_SPEED * 0.1);
         if (this.takenAnimationTime > TAKEN_ANIMATION_TIME - FLASH_DURATION)
         {
            this.additiveValue += ADDITIVE_SPEED_UP * millis;
            if (this.additiveValue > MAX_ADDITIVE_VALUE)
            {
               this.additiveValue = MAX_ADDITIVE_VALUE;
            }
         }
         else
         {
            this.additiveValue -= ADDITIVE_SPEED_DOWN * millis;
            if (this.additiveValue < 0)
            {
               this.additiveValue = 0;
            }
         }
         var colorTransform:ColorTransform = box.colorTransform;
         if (colorTransform == null)
         {
            colorTransform = new ColorTransform();
            box.colorTransform = colorTransform;
         }
         colorTransform.redOffset = this.additiveValue;
         colorTransform.blueOffset = this.additiveValue;
         colorTransform.greenOffset = this.additiveValue;
         if (this.takenAnimationTime < ALPHA_DURATION)
         {
            box.alpha = this.takenAnimationTime / ALPHA_DURATION;
         }
         this.takenAnimationTime -= millis;
      }
   }
}

import alternativa.tanks.models.effects.common.bonuscommon.ParaBonus;

class Pool
{

   public var objects:Vector.<ParaBonus>;

   public var numObjects:int;

   public function Pool()
   {
      this.objects = new Vector.<ParaBonus>();
      super();
   }
}
