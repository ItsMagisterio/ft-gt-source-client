﻿package alternativa.tanks.models.weapon.plasma
{
    import alternativa.tanks.sfx.IGraphicEffect;
    import alternativa.physics.collision.IRayCollisionPredicate;
    import __AS3__.vec.Vector;
    import alternativa.math.Matrix3;
    import alternativa.math.Vector3;
    import alternativa.physics.collision.types.RayIntersection;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.physics.collision.ICollisionDetector;
    import alternativa.tanks.engine3d.AnimatedSprite3D;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.init.Main;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
    import alternativa.tanks.models.sfx.shoot.plasma.PlasmaSFXData;
    import alternativa.engine3d.lights.OmniLight;
    import alternativa.tanks.engine3d.TextureAnimation;
    import alternativa.tanks.models.battlefield.gamemode.GameModes;
    import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
    import alternativa.object.ClientObject;
    import alternativa.tanks.physics.CollisionGroup;
    import alternativa.tanks.camera.GameCamera;
    import alternativa.physics.Body;
    import __AS3__.vec.*;

    public class PlasmaShot implements IGraphicEffect, IRayCollisionPredicate
    {

        public static const SIZE:Number = 250;
        private static const INITIAL_POOL_SIZE:int = 20;
        private static var pool:Vector.<PlasmaShot> = new Vector.<PlasmaShot>(INITIAL_POOL_SIZE);
        private static var poolIndex:int = -1;
        private static const ANIMATION_FPS:Number = 30;
        private static const NUM_RADIAL_RAYS:int = 8;
        private static const RADIAL_ANGLE_STEP:Number = ((2 * Math.PI) / NUM_RADIAL_RAYS);
        private static var _rotationMatrix:Matrix3 = new Matrix3();
        private static var _rayOrigin:Vector3 = new Vector3();
        private static var _rayDirection:Vector3 = new Vector3();
        private static var _rayHit:RayIntersection = new RayIntersection();

        public var shotId:int;
        public var active:Boolean;
        public var shooterData:TankData;
        public var totalDistance:Number = 0;
        private var radialPoints:Vector.<Vector3>;
        private var currPosition:Vector3 = new Vector3();
        private var direction:Vector3 = new Vector3();
        private var listener:IPlasmaShotListener;
        private var plasmaData:PlasmaGunData;
        private var collisionDetector:ICollisionDetector;
        private var sprite:AnimatedSprite3D;
        private var numFrames:int;
        private var currentFrame:Number;
        private var battleField:BattlefieldModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
        private var weakeningModel:IWeaponWeakeningModel;
        private var sfxData:PlasmaSFXData;
        private var omni:OmniLight = new OmniLight((Math.random() * 0xFFFFFF), ((SIZE / 2) - 50) * 2, SIZE * 2);

        public function PlasmaShot()
        {
            this.radialPoints = new Vector.<Vector3>(NUM_RADIAL_RAYS);
            var i:int;
            while (i < NUM_RADIAL_RAYS)
            {
                this.radialPoints[i] = new Vector3();
                i++;
            }
            this.sprite = new AnimatedSprite3D(SIZE, SIZE);
            this.omni.intensity = 0.4;
        }
        public static function getShot():PlasmaShot
        {
            if (poolIndex == -1)
            {
                return (new (PlasmaShot)());
            }
            var shot:PlasmaShot = pool[poolIndex];
            var _local_2:* = poolIndex--;
            pool[_local_2] = null;
            return (shot);
        }

        public function init(shotId:int, active:Boolean, plasmaData:PlasmaGunData, startPosition:Vector3, direction:Vector3, shooterData:TankData, listener:IPlasmaShotListener, sfxData:PlasmaSFXData, collisionDetector:ICollisionDetector, weakeningModel:IWeaponWeakeningModel):void
        {
            this.shotId = shotId;
            this.active = active;
            this.plasmaData = plasmaData;
            this.currPosition.vCopy(startPosition);
            this.direction.vCopy(direction);
            this.shooterData = shooterData;
            this.listener = listener;
            this.collisionDetector = collisionDetector;
            this.weakeningModel = weakeningModel;
            this.sfxData = sfxData;
            var animationData:TextureAnimation = sfxData.shotData;
            this.sprite.setAnimationData(animationData);
            this.sprite.setFrameIndex((this.sprite.getNumFrames() * Math.random()));
            this.sprite.rotation = (6.28 * Math.random());
            this.sprite.colorTransform = sfxData.colorTransform;
            this.sprite.looped = true;
            this.totalDistance = 0;
            this.initRadialPoints(startPosition, direction, plasmaData.shotRadius);
        }
        public function addToContainer(container:Scene3DContainer):void
        {
            container.addChild(this.sprite);
            container.addChild(this.omni);
            this.omni.color = 0xFFFFFF;
        }
        public function get owner():ClientObject
        {
            return (null);
        }
        public function play(millis:int, camera:GameCamera):Boolean
        {
            var i:int;
            var p:Vector3;
            if (this.totalDistance > this.plasmaData.shotRange)
            {
                this.listener.plasmaShotDissolved(this);
                return (false);
            }
            var dt:Number = (0.001 * millis);
            var distance:Number = (this.plasmaData.shotSpeed * dt);
            this.totalDistance = (this.totalDistance + distance);
            this.sprite.update(dt);
            if (this.active)
            {
                if (this.collisionDetector.intersectRay(this.currPosition, this.direction, CollisionGroup.WEAPON, distance, this, _rayHit))
                {
                    if (_rayHit.primitive != null)
                    {
                        this.listener.plasmaShotHit(this, _rayHit.pos, this.direction, _rayHit.primitive.body);
                    }
                    return (false);
                }
                i = 0;
                while (i < NUM_RADIAL_RAYS)
                {
                    p = this.radialPoints[i];
                    if (this.collisionDetector.intersectRay(p, this.direction, CollisionGroup.WEAPON, distance, this, _rayHit))
                    {
                        if (_rayHit.primitive.body != null)
                        {
                            this.listener.plasmaShotHit(this, _rayHit.pos, this.direction, _rayHit.primitive.body);
                            return (false);
                        }
                    }
                    i++;
                }
                _rayOrigin.x = this.currPosition.x;
                _rayOrigin.y = this.currPosition.y;
                _rayOrigin.z = (this.currPosition.z + this.plasmaData.shotRadius);
                _rayDirection.z = -1;
                if (this.collisionDetector.intersectRayWithStatic(_rayOrigin, _rayDirection, CollisionGroup.STATIC, this.plasmaData.shotRadius, null, _rayHit))
                {
                    this.listener.plasmaShotHit(this, this.currPosition, this.direction, null);
                    return (false);
                }
            }
            var dx:Number = (distance * this.direction.x);
            var dy:Number = (distance * this.direction.y);
            var dz:Number = (distance * this.direction.z);
            this.currPosition.x = (this.currPosition.x + dx);
            this.currPosition.y = (this.currPosition.y + dy);
            this.currPosition.z = (this.currPosition.z + dz);
            i = 0;
            while (i < NUM_RADIAL_RAYS)
            {
                p = this.radialPoints[i];
                p.x = (p.x + dx);
                p.y = (p.y + dy);
                p.z = (p.z + dz);
                i++;
            }
            var size:Number = (SIZE * this.weakeningModel.getImpactCoeff(this.shooterData.turret, (0.01 * this.totalDistance)));
            this.sprite.width = size;
            this.sprite.height = size;
            this.sprite.x = this.currPosition.x;
            this.sprite.y = this.currPosition.y;
            this.sprite.z = this.currPosition.z;
            this.omni.x = this.currPosition.x;
            this.omni.y = this.currPosition.y;
            this.omni.z = this.currPosition.z;
            this.sprite.rotation = (this.sprite.rotation - (0.003 * millis));
            return (true);
        }
        public function destroy():void
        {
            this.sprite.parent.removeChild(this.sprite);
            this.omni.parent.removeChild(this.omni);
            this.plasmaData = null;
            this.listener = null;
            this.collisionDetector = null;
            this.shooterData = null;
            this.weakeningModel = null;
            this.sfxData = null;
            this.sprite.material = null;
            this.sprite.colorTransform = null;
            var _local_1:* = ++ poolIndex;
            pool[_local_1] = this;
        }
        public function kill():void
        {
            this.totalDistance = (this.plasmaData.shotRange + 1);
        }
        public function considerBody(body:Body):Boolean
        {
            return (!(this.shooterData.tank == body));
        }
        public function toString():String
        {
            return (((("[PlasmaCharge tankId=" + this.shooterData.user.id) + ", chargeId=") + this.shotId) + "]");
        }
        private function initRadialPoints(centerPoint:Vector3, shotDirection:Vector3, shotRadius:Number):void
        {
            var v:Vector3;
            var axis:int;
            var min:Number = 1E308;
            var d:Number = ((shotDirection.x < 0) ? -(shotDirection.x) : shotDirection.x);
            if (d < min)
            {
                min = d;
                axis = 0;
            }
            d = ((shotDirection.y < 0) ? -(shotDirection.y) : shotDirection.y);
            if (d < min)
            {
                min = d;
                axis = 1;
            }
            d = ((shotDirection.z < 0) ? -(shotDirection.z) : shotDirection.z);
            if (d < min)
            {
                axis = 2;
            }
            v = new Vector3();
            switch (axis)
            {
                case 0:
                    v.x = 0;
                    v.y = shotDirection.z;
                    v.z = -(shotDirection.y);
                    break;
                case 1:
                    v.x = -(shotDirection.z);
                    v.y = 0;
                    v.z = shotDirection.x;
                    break;
                case 2:
                    v.x = shotDirection.y;
                    v.y = -(shotDirection.x);
                    v.z = 0;
                    break;
            }
            v.vNormalize().vScale(shotRadius);
            _rotationMatrix.fromAxisAngle(shotDirection, RADIAL_ANGLE_STEP);
            Vector3(this.radialPoints[0]).vCopy(centerPoint).vAdd(v);
            var i:int = 1;
            while (i < NUM_RADIAL_RAYS)
            {
                v.vTransformBy3(_rotationMatrix);
                Vector3(this.radialPoints[i]).vCopy(centerPoint).vAdd(v);
                i++;
            }
        }

    }
}
