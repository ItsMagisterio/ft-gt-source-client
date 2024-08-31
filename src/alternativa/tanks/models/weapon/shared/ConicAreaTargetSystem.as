package alternativa.tanks.models.weapon.shared
{
    import alternativa.tanks.physics.CollisionGroup;
    import alternativa.math.Vector3;
    import alternativa.physics.collision.ICollisionDetector;
    import alternativa.math.Matrix3;
    import alternativa.physics.collision.types.RayIntersection;
    import flash.utils.Dictionary;
    import alternativa.physics.Body;

    public class ConicAreaTargetSystem
    {

        private static const collisionGroup:int = CollisionGroup.WEAPON;
        private static const origin:Vector3 = new Vector3();

        private var range:Number;
        private var halfConeAngle:Number;
        private var numRays:int;
        private var numSteps:int;
        private var collisionDetector:ICollisionDetector;
        private var targetValidator:ITargetValidator;
        private var _xAxis:Vector3 = new Vector3();
        private var matrix:Matrix3 = new Matrix3();
        private var rotationMatrix:Matrix3 = new Matrix3();
        private var intersection:RayIntersection = new RayIntersection();
        private var predicate:GunPredicate = new GunPredicate();
        private var rayDir:Vector3 = new Vector3();
        private var muzzlePos:Vector3 = new Vector3();
        private var distanceByTarget:Dictionary;
        private var hitPointByTarget:Dictionary;

        public function ConicAreaTargetSystem(range:Number, coneAngle:Number, numRays:int, numSteps:int, collisionDetector:ICollisionDetector, targetValidator:ITargetValidator)
        {
            this.range = range;
            this.halfConeAngle = (0.5 * coneAngle);
            this.numRays = numRays;
            this.numSteps = numSteps;
            this.collisionDetector = collisionDetector;
            this.targetValidator = targetValidator;
        }
        public function getTargets(shooter:Body, barrelLength:Number, fireOriginOffsetCoeff:Number, barrelOrigin:Vector3, gunDir:Vector3, gunRotationAxis:Vector3, targetBodies:Array, targetDistances:Array, hitPointsTargets:Array):void
        {
            var key:*;
            var distance:Number;
            this.predicate.shooter = shooter;
            this.distanceByTarget = new Dictionary();
            this.hitPointByTarget = new Dictionary();
            var fireOriginOffset:Number = (fireOriginOffsetCoeff * barrelLength);
            var extraDamageAreaRange:Number = (barrelLength - fireOriginOffset);
            if (this.collisionDetector.intersectRay(barrelOrigin, gunDir, collisionGroup, barrelLength, this.predicate, this.intersection))
            {
                if (this.intersection.primitive.body == null)
                {
                    return;
                }
            }
            this._xAxis.vCopy(gunRotationAxis);
            this.muzzlePos.vCopy(barrelOrigin).vAddScaled(fireOriginOffset, gunDir);
            this.range = (this.range + extraDamageAreaRange);
            this.processRay(this.muzzlePos, gunDir, this.range);
            this.rotationMatrix.fromAxisAngle(gunDir, (Math.PI / this.numSteps));
            var angleStep:Number = (this.halfConeAngle / this.numRays);
            var i:int;
            while (i < this.numSteps)
            {
                this.processSector(this.muzzlePos, gunDir, this._xAxis, this.numRays, angleStep);
                this.processSector(this.muzzlePos, gunDir, this._xAxis, this.numRays, -(angleStep));
                this._xAxis.vTransformBy3(this.rotationMatrix);
                i++;
            }
            var numTargets:int;
            for (key in this.distanceByTarget)
            {
                targetBodies[numTargets] = key;
                distance = (this.distanceByTarget[key] - extraDamageAreaRange);
                if (distance < 0)
                {
                    distance = 0;
                }
                targetDistances[numTargets] = distance;
                hitPointsTargets[numTargets] = this.hitPointByTarget[key];
                numTargets++;
            }
            targetBodies.length = numTargets;
            targetDistances.length = numTargets;
            hitPointsTargets.length = numTargets;
            this.predicate.shooter = null;
            this.predicate.clearInvalidTargets();
            this.distanceByTarget = null;
            this.hitPointByTarget = null;
        }
        private function processSector(rayOrigin:Vector3, gunDir:Vector3, rotationAxis:Vector3, numRays:int, angleStep:Number):void
        {
            var rayAngle:Number = 0;
            var i:int;
            while (i < numRays)
            {
                rayAngle = (rayAngle + angleStep);
                this.matrix.fromAxisAngle(rotationAxis, rayAngle);
                this.matrix.transformVector(gunDir, this.rayDir);
                this.processRay(rayOrigin, this.rayDir, this.range);
                i++;
            }
        }
        private function processRay(rayOrigin:Vector3, rayDirection:Vector3, rayLength:Number):void
        {
            var body:Body;
            var d:Number;
            origin.vCopy(rayOrigin);
            var distance:Number = 0;
            while (rayLength > 0.1)
            {
                if (this.collisionDetector.intersectRay(origin, rayDirection, collisionGroup, rayLength, this.predicate, this.intersection))
                {
                    body = this.intersection.primitive.body;
                    if (body == null)
                    {
                        break;
                    }
                    origin.vAddScaled(this.intersection.t, rayDirection);
                    distance = (distance + this.intersection.t);
                    if (this.targetValidator.isValidTarget(body))
                    {
                        this.predicate.addTarget(body);
                        d = this.distanceByTarget[body];
                        if (((isNaN(d)) || (d > distance)))
                        {
                            this.distanceByTarget[body] = distance;
                        }
                        this.hitPointByTarget[body] = (this.hitPointByTarget[body] + this.intersection.pos.clone());
                    }
                    else
                    {
                        this.predicate.addInvalidTarget(body);
                    }
                    rayLength = (rayLength - this.intersection.t);
                }
                else
                {
                    break;
                }
            }
            this.predicate.clearTargets();
        }

    }
}

import alternativa.physics.collision.IRayCollisionPredicate;
import alternativa.physics.Body;
import flash.utils.Dictionary;

class GunPredicate implements IRayCollisionPredicate
{

    public var shooter:Body;
    private var targets:Dictionary = new Dictionary();
    private var invalidTargets:Dictionary = new Dictionary();

    public function considerBody(body:Body):Boolean
    {
        return (((!(this.shooter == body)) && (this.targets[body] == null)) && (this.invalidTargets[body] == null));
    }
    public function addTarget(body:Body):void
    {
        this.targets[body] = true;
    }
    public function addInvalidTarget(body:Body):void
    {
        this.invalidTargets[body] = true;
    }
    public function clearTargets():void
    {
        var key:*;
        for (key in this.targets)
        {
            delete this.targets[key];
        }
    }
    public function clearInvalidTargets():void
    {
        var key:*;
        for (key in this.invalidTargets)
        {
            delete this.invalidTargets[key];
        }
    }

}
