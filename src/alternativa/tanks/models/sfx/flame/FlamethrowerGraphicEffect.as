package alternativa.tanks.models.sfx.flame
{
    import alternativa.tanks.utils.objectpool.PooledObject;
    import alternativa.tanks.sfx.IGraphicEffect;
    import alternativa.console.ConsoleVarFloat;
    import alternativa.math.Matrix3;
    import alternativa.math.Vector3;
    import alternativa.physics.collision.types.RayIntersection;
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
    import __AS3__.vec.Vector;
    import alternativa.tanks.physics.TanksCollisionDetector;
    import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.engine3d.TextureAnimation;
    import alternativa.tanks.utils.objectpool.ObjectPool;
    import flash.utils.getTimer;
    import alternativa.object.ClientObject;
    import alternativa.tanks.camera.GameCamera;
    import alternativa.tanks.physics.CollisionGroup;
    import __AS3__.vec.*;
    import alternativa.tanks.sfx.SFXUtils;
    import alternativa.engine3d.alternativa3d;
    import alternativa.math.Matrix4;
    import flash.geom.ColorTransform;
    import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
    import com.alternativaplatform.projects.tanks.client.warfare.models.colortransform.struct.ColorTransformStruct;

    public class FlamethrowerGraphicEffect extends PooledObject implements IGraphicEffect
    {

        private static const ANIMATION_FPS:Number = 30;
        private static const START_SCALE:Number = 0.5;
        private static const END_SCALE:Number = 4;
        private static var particleBaseSize:ConsoleVarFloat = new ConsoleVarFloat("flame_base_size", 100, 1, 1000);
        private static var matrix:Matrix3 = new Matrix3();
        private static var particlePosition:Vector3 = new Vector3();
        private static var barrelOrigin:Vector3 = new Vector3();
        private static var gunDirection:Vector3 = new Vector3();
        private static var xAxis:Vector3 = new Vector3();
        private static var globalMuzzlePosition:Vector3 = new Vector3();
        private static var intersection:RayIntersection = new RayIntersection();
        private static const PLANE_LENGTH:int = 200;
        private static const PLANE_WIDTH:int = 60;

        private var range:Number;
        private var scalePerDistance:Number;
        private var coneHalfAngleTan:Number;
        private var maxParticles:int;
        private var particleSpeed:Number;
        private var localMuzzlePosition:Vector3 = new Vector3();
        private var turret:Object3D;
        private var sfxData:FlamethrowerSFXData;
        private var container:Scene3DContainer;
        private var particles:Vector.<Particle> = new Vector.<Particle>();
        private var numParticles:int;
        private var numFrames:int;
        private var collisionDetector:TanksCollisionDetector;
        private var dead:Boolean;
        private var emissionDelta:int;
        private var nextEmissionTime:int;
        private var time:int;
        private var collisionGroup:int = 16;
        private var weakeningModel:IWeaponWeakeningModel;
        private var shooterData:TankData;
        private var animatedTexture:TextureAnimation;
        private var plane:AnimatedPlane;

        private static var turretMatrix:Matrix4 = new Matrix4();
        private static var direction:Vector3 = new Vector3();
        private static var turretAxisX:Vector3 = new Vector3();
        private static var tankMuzzlePosition:Vector3 = new Vector3();

        public function FlamethrowerGraphicEffect(objectPool:ObjectPool)
        {
            super(objectPool);
            this.plane = new AnimatedPlane(PLANE_WIDTH, PLANE_LENGTH);
        }
        public function init(shooterData:TankData, range:Number, coneAngle:Number, maxParticles:int, particleSpeed:Number, muzzleLocalPos:Vector3, turret:Object3D, sfxData:FlamethrowerSFXData, collisionDetector:TanksCollisionDetector, weakeningModel:IWeaponWeakeningModel):void
        {
            this.shooterData = shooterData;
            this.range = range;
            this.scalePerDistance = ((2 * (END_SCALE - START_SCALE)) / range);
            this.coneHalfAngleTan = Math.tan((0.5 * coneAngle));
            this.maxParticles = maxParticles;
            this.particleSpeed = particleSpeed;
            this.localMuzzlePosition.vCopy(muzzleLocalPos);
            this.turret = turret;
            this.sfxData = sfxData;
            this.collisionDetector = collisionDetector;
            this.weakeningModel = weakeningModel;
            this.numFrames = sfxData.materials.length;
            this.emissionDelta = ((1000 * range) / (maxParticles * particleSpeed));
            this.time = (this.nextEmissionTime = getTimer());
            if (this.plane == null)
            {
                this.plane = new AnimatedPlane(PLANE_WIDTH, PLANE_LENGTH);
            }
            this.plane.setMaterials(sfxData.planeMaterials);
            this.plane.currFrame = 0;
            this.plane.depthMapAlphaThreshold = 2;
            this.plane.useLight = false;
            this.plane.useShadowMap = false;
            var planeColorTransform:ColorTransform = new ColorTransform(1, 1, 1, 1, 100, 100, 40, 0);
            this.plane.colorTransform = planeColorTransform;
            this.particles.length = maxParticles;
            this.dead = false;
            this.animatedTexture = sfxData.data;
        }
        public function get owner():ClientObject
        {
            return (null);
        }
        public function addToContainer(container:Scene3DContainer):void
        {
            this.container = container;
            container.addChild(this.plane);
        }
        public function play(millis:int, camera:GameCamera):Boolean
        {
            var particle:Particle;
            particle = null;
            var velocity:Vector3;
            var scale:Number = NaN;
            var size:Number = NaN;
            this.calculateParameters();
            if (this.collisionDetector.intersectRayWithStatic(barrelOrigin, direction, CollisionGroup.STATIC, (this.localMuzzlePosition.y + PLANE_WIDTH), null, intersection))
            {
                this.plane.visible = false;
            }
            else
            {
                this.plane.visible = true;
                this.plane.update(dt, 25);
                SFXUtils.alignObjectPlaneToView(this.plane, globalMuzzlePosition, direction, camera.pos);
            }
            if ((((!(this.dead)) && (this.numParticles < this.maxParticles)) && (this.time >= this.nextEmissionTime)))
            {
                this.nextEmissionTime = (this.nextEmissionTime + this.emissionDelta);
                this.tryToAddParticle();
            }
            var dt:Number = (0.001 * millis);
            var i:int;
            while (i < this.numParticles)
            {
                particle = this.particles[i];
                particlePosition.x = particle.x;
                particlePosition.y = particle.y;
                particlePosition.z = particle.z;
                if (((particle.distance > this.range) || (this.collisionDetector.intersectRayWithStatic(particlePosition, particle.velocity, this.collisionGroup, dt, null, intersection))))
                {
                    this.removeParticle(i-- );
                }
                else
                {
                    velocity = particle.velocity;
                    particle.x = (particle.x + (dt * velocity.x));
                    particle.y = (particle.y + (dt * velocity.y));
                    particle.z = (particle.z + (dt * velocity.z));
                    particle.distance = (particle.distance + (this.particleSpeed * dt));
                    particle.update(dt);
                    scale = (START_SCALE + (this.scalePerDistance * particle.distance));
                    if (scale > END_SCALE)
                    {
                        scale = END_SCALE;
                    }
                    size = (scale * particleBaseSize.value);
                    particle.width = size;
                    particle.height = size;
                    particle.updateColorTransofrm(this.range, this.sfxData.colorTransformPoints);
                }
                i++;
            }
            this.time = (this.time + millis);
            return ((!(this.dead)) || (this.numParticles > 0));
        }
        private function calculateParameters():void
        {
            turretMatrix.setMatrix(this.turret.x, this.turret.y, this.turret.z, this.turret.rotationX, this.turret.rotationY, this.turret.rotationZ);
            turretAxisX.x = turretMatrix.a;
            turretAxisX.y = turretMatrix.e;
            turretAxisX.z = turretMatrix.i;
            direction.x = turretMatrix.b;
            direction.y = turretMatrix.f;
            direction.z = turretMatrix.j;
            turretMatrix.transformVector(this.localMuzzlePosition, globalMuzzlePosition);
            var barrleLength:Number = this.localMuzzlePosition.y;
            barrelOrigin.x = (globalMuzzlePosition.x - (barrleLength * direction.x));
            barrelOrigin.y = (globalMuzzlePosition.y - (barrleLength * direction.y));
            barrelOrigin.z = (globalMuzzlePosition.z - (barrleLength * direction.z));
        }
        public function destroy():void
        {
            var _local_1:* = this.plane;
            _local_1.alternativa3d::removeFromParent();
            this.plane.clearMaterials();
            this.plane.destroy();
            this.plane = null;
            while (this.numParticles > 0)
            {
                this.removeParticle(0);
            }
            this.collisionDetector = null;
            this.turret = null;
            this.shooterData = null;
            this.sfxData = null;
        }
        public function kill():void
        {
            var _local_1:* = this.plane;
            (_local_1.alternativa3d::removeFromParent());
            this.dead = true;
        }
        override protected function getClass():Class
        {
            return (FlamethrowerGraphicEffect);
        }
        private function tryToAddParticle():void
        {
            turretMatrix.setMatrix(this.turret.x, this.turret.y, this.turret.z, this.turret.rotationX, this.turret.rotationY, this.turret.rotationZ);
            turretAxisX.x = turretMatrix.a;
            turretAxisX.y = turretMatrix.e;
            turretAxisX.z = turretMatrix.i;
            direction.x = turretMatrix.b;
            direction.y = turretMatrix.f;
            direction.z = turretMatrix.j;
            turretMatrix.transformVector(this.localMuzzlePosition, tankMuzzlePosition);
            var offset:Number;
            var barrelLength:Number = NaN;
            matrix.setRotationMatrix(this.turret.rotationX, this.turret.rotationY, this.turret.rotationZ);
            barrelOrigin.x = 0;
            barrelOrigin.y = 0;
            barrelOrigin.z = this.localMuzzlePosition.z;
            barrelOrigin.vTransformBy3(matrix);
            barrelOrigin.x = (barrelOrigin.x + this.turret.x);
            barrelOrigin.y = (barrelOrigin.y + this.turret.y);
            barrelOrigin.z = (barrelOrigin.z + this.turret.z);
            gunDirection.x = matrix.b;
            gunDirection.y = matrix.f;
            gunDirection.z = matrix.j;
            offset = (Math.random() * 50);
            if ((!(this.collisionDetector.intersectRayWithStatic(barrelOrigin, gunDirection, CollisionGroup.STATIC, (this.localMuzzlePosition.y + offset), null, intersection))))
            {
                barrelLength = this.localMuzzlePosition.y;
                globalMuzzlePosition.x = (barrelOrigin.x + (gunDirection.x * barrelLength));
                globalMuzzlePosition.y = (barrelOrigin.y + (gunDirection.y * barrelLength));
                globalMuzzlePosition.z = ((barrelOrigin.z + 25) + (gunDirection.z * barrelLength));
                xAxis.x = matrix.a;
                xAxis.y = matrix.e;
                xAxis.z = matrix.i;
                this.addParticle(globalMuzzlePosition, gunDirection, xAxis, offset);
            }
        }
        private function copyStructToColorTransform(source:ColorTransformEntry, result:ColorTransform):void
        {
            result.alphaMultiplier = source.alphaMultiplier;
            result.alphaOffset = source.alphaOffset;
            result.redMultiplier = source.redMultiplier;
            result.redOffset = source.redOffset;
            result.greenMultiplier = source.greenMultiplier;
            result.greenOffset = source.greenOffset;
            result.blueMultiplier = source.blueMultiplier;
            result.blueOffset = source.blueOffset;
        }
        private function addParticle(globalMuzzlePosition:Vector3, direction:Vector3, gunAxisX:Vector3, offset:Number):void
        {
            var particle:Particle;
            particle = Particle.getParticle(this.animatedTexture);
            particle.currFrame = (Math.random() * this.numFrames);
            var angle:Number = ((2 * Math.PI) * Math.random());
            matrix.fromAxisAngle(direction, angle);
            gunAxisX.vTransformBy3(matrix);
            var d:Number = ((this.range * this.coneHalfAngleTan) * Math.random());
            direction.x = ((direction.x * this.range) + (gunAxisX.x * d));
            direction.y = ((direction.y * this.range) + (gunAxisX.y * d));
            direction.z = ((direction.z * this.range) + (gunAxisX.z * d));
            direction.vNormalize();
            particle.velocity.x = (this.particleSpeed * direction.x);
            particle.velocity.y = (this.particleSpeed * direction.y);
            particle.velocity.z = (this.particleSpeed * direction.z);
            particle.velocity.vAdd(this.shooterData.tank.state.velocity);
            particle.distance = offset;
            particle.x = (globalMuzzlePosition.x + (offset * direction.x));
            particle.y = (globalMuzzlePosition.y + (offset * direction.y));
            particle.z = (globalMuzzlePosition.z + (offset * direction.z));
            var _loc8_:* = this.numParticles++;
            this.particles[_loc8_] = particle;
            this.container.addChild(particle);
        }
        private function removeParticle(index:int):void
        {
            var particle:Particle = this.particles[index];
            this.particles[index] = this.particles[-- this.numParticles];
            this.particles[this.numParticles] = null;
            particle.dispose();
            // particle.destroy();
            particle = null;
        }

    }
}

import alternativa.tanks.engine3d.AnimatedSprite3D;
import __AS3__.vec.Vector;
import alternativa.math.Vector3;
import flash.geom.ColorTransform;
import alternativa.tanks.engine3d.TextureAnimation;
import alternativa.engine3d.alternativa3d;
import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
import __AS3__.vec.*;
import alternativa.tanks.models.sfx.SimplePlane;
import alternativa.engine3d.materials.Material;

class Particle extends AnimatedSprite3D
{

    private static var INITIAL_POOL_SIZE:int = 20;
    private static var pool:Vector.<Particle> = new Vector.<Particle>(INITIAL_POOL_SIZE);
    private static var poolIndex:int = -1;

    public var velocity:Vector3 = new Vector3();
    public var distance:Number = 0;
    public var currFrame:Number;

    public function Particle(animData:TextureAnimation)
    {
        super(100, 100);
        colorTransform = new ColorTransform();
        this.softAttenuation = 140;
        super.setAnimationData(animData);
        super.setFrameIndex(0);
        super.looped = true;
    }
    public static function getParticle(animData:TextureAnimation):Particle
    {
        return (new Particle(animData));
    }

    public function dispose():void
    {
        (alternativa3d::removeFromParent());
        material = null;
        var _loc1_:* = ++ poolIndex;
        pool[_loc1_] = this;
    }
    public function updateColorTransofrm(maxDistance:Number, points:Vector.<ColorTransformEntry>):void
    {
        var point1:ColorTransformEntry;
        var point2:ColorTransformEntry;
        var i:int;
        if (points == null)
        {
            return;
        }
        var t:Number = (this.distance / maxDistance);
        if (t <= 0)
        {
            point1 = points[0];
            this.copyStructToColorTransform(point1, colorTransform);
        }
        else
        {
            if (t >= 1)
            {
                point1 = points[(points.length - 1)];
                this.copyStructToColorTransform(point1, colorTransform);
            }
            else
            {
                i = 1;
                point1 = points[0];
                point2 = points[1];
                while (point2.t < t)
                {
                    i++;
                    point1 = point2;
                    point2 = points[i];
                }
                t = ((t - point1.t) / (point2.t - point1.t));
                this.interpolateColorTransform(point1, point2, t, colorTransform);
            }
        }
        alpha = colorTransform.alphaMultiplier;
    }
    private function interpolateColorTransform(ct1:ColorTransformEntry, ct2:ColorTransformEntry, t:Number, result:ColorTransform):void
    {
        result.alphaMultiplier = (ct1.alphaMultiplier + (t * (ct2.alphaMultiplier - ct1.alphaMultiplier)));
        result.alphaOffset = (ct1.alphaOffset + (t * (ct2.alphaOffset - ct1.alphaOffset)));
        result.redMultiplier = (ct1.redMultiplier + (t * (ct2.redMultiplier - ct1.redMultiplier)));
        result.redOffset = (ct1.redOffset + (t * (ct2.redOffset - ct1.redOffset)));
        result.greenMultiplier = (ct1.greenMultiplier + (t * (ct2.greenMultiplier - ct1.greenMultiplier)));
        result.greenOffset = (ct1.greenOffset + (t * (ct2.greenOffset - ct1.greenOffset)));
        result.blueMultiplier = (ct1.blueMultiplier + (t * (ct2.blueMultiplier - ct1.blueMultiplier)));
        result.blueOffset = (ct1.blueOffset + (t * (ct2.blueOffset - ct1.blueOffset)));
    }
    private function copyStructToColorTransform(source:ColorTransformEntry, result:ColorTransform):void
    {
        result.alphaMultiplier = source.alphaMultiplier;
        result.alphaOffset = source.alphaOffset;
        result.redMultiplier = source.redMultiplier;
        result.redOffset = source.redOffset;
        result.greenMultiplier = source.greenMultiplier;
        result.greenOffset = source.greenOffset;
        result.blueMultiplier = source.blueMultiplier;
        result.blueOffset = source.blueOffset;
    }

}

class AnimatedPlane extends SimplePlane
{

    public var currFrame:Number;
    private var materials:Vector.<Material>;
    private var numFrames:int;

    public function AnimatedPlane(width:Number, length:Number)
    {
        super(width, length, 0.5, 0);
        setUVs(0, 0, 0, 1, 1, 1, 1, 0);
        setUVsSideways();
    }
    public function setMaterials(materials:Vector.<Material>):void
    {
        this.materials = materials;
        this.numFrames = materials.length;
    }
    public function clearMaterials():void
    {
        this.materials = null;
        material = null;
    }
    public function update(dt:Number, fps:Number):void
    {
        this.currFrame = (this.currFrame + (dt * fps));
        if (this.currFrame >= this.numFrames)
        {
            this.currFrame = 0;
        }
        material = this.materials[int(this.currFrame)];
    }

}