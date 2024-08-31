package alternativa.tanks.models.weapon.pumpkingun
{
    import alternativa.physics.collision.IRayCollisionPredicate;
    import alternativa.physics.collision.ICollisionDetector;
    import alternativa.tanks.models.weapon.shared.ICommonTargetEvaluator;
    import alternativa.physics.collision.types.RayIntersection;
    import alternativa.math.Vector3;
    import alternativa.math.Matrix3;
    import alternativa.physics.Body;
    import alternativa.tanks.physics.CollisionGroup;

    public class PumpkinTargetSystem implements IRayCollisionPredicate
    {

        public var angleUp:Number;
        public var numRaysUp:int;
        public var angleDown:Number;
        public var numRaysDown:int;
        public var range:Number;
        public var collisionDetector:ICollisionDetector;
        public var targetEvaluator:ICommonTargetEvaluator;
        private var rayHit:RayIntersection = new RayIntersection();
        private var targetDistance:Number;
        private var maxPriority:Number;
        private var currOrigin:Vector3 = new Vector3();
        private var currDirection:Vector3 = new Vector3();
        private var dir:Vector3 = new Vector3();
        private var matrix:Matrix3 = new Matrix3();
        private var ricochetCount:int;
        private var shooterBody:Body;

        public function PumpkinTargetSystem(angleUp:Number, numRaysUp:int, angleDown:Number, numRaysDown:int, range:Number, collisionDetector:ICollisionDetector, targetEvaluator:ICommonTargetEvaluator)
        {
            this.init(angleUp, numRaysUp, angleDown, numRaysDown, range, collisionDetector, targetEvaluator);
        }
        public function init(angleUp:Number, numRaysUp:int, angleDown:Number, numRaysDown:int, range:Number, collisionDetector:ICollisionDetector, targetEvaluator:ICommonTargetEvaluator):void
        {
            this.angleUp = angleUp;
            this.numRaysUp = numRaysUp;
            this.angleDown = angleDown;
            this.numRaysDown = numRaysDown;
            this.range = range;
            this.collisionDetector = collisionDetector;
            this.targetEvaluator = targetEvaluator;
        }
        public function getShotDirection(origin:Vector3, gunDir:Vector3, gunRotationAxis:Vector3, shooterBody:Body, result:Vector3):Boolean
        {
            this.shooterBody = shooterBody;
            this.maxPriority = 0;
            this.targetDistance = (this.range + 1);
            this.checkDirection(origin, gunDir, 0, result);
            this.checkSector(origin, gunDir, gunRotationAxis, (this.angleUp / this.numRaysUp), this.numRaysUp, result);
            this.checkSector(origin, gunDir, gunRotationAxis, (-(this.angleDown) / this.numRaysDown), this.numRaysDown, result);
            this.shooterBody = null;
            return (this.targetDistance < (this.range + 1));
        }
        public function considerBody(body:Body):Boolean
        {
            return (!((this.shooterBody == body) && (this.ricochetCount == 0)));
        }
        private function checkDirection(origin:Vector3, direction:Vector3, angle:Number, result:Vector3):void
        {
            var body:Body;
            var distance:Number = NaN;
            var targetPriority:Number = NaN;
            var normal:Vector3;
            this.ricochetCount = 0;
            var remainingDistance:Number = this.range;
            var collisionGroup:int = CollisionGroup.WEAPON;
            this.currOrigin.vCopy(origin);
            this.currDirection.vCopy(direction);
            while (remainingDistance > 0)
            {
                if (this.collisionDetector.intersectRay(this.currOrigin, this.currDirection, collisionGroup, remainingDistance, this, this.rayHit))
                {
                    remainingDistance = (remainingDistance - this.rayHit.t);
                    if (remainingDistance < 0)
                    {
                        remainingDistance = 0;
                    }
                    body = this.rayHit.primitive.body;
                    if (((!(body == null)) && (!(body == this.shooterBody))))
                    {
                        distance = (this.range - remainingDistance);
                        targetPriority = this.targetEvaluator.getTargetPriority(body, distance, angle);
                        if (targetPriority > this.maxPriority)
                        {
                            this.maxPriority = targetPriority;
                            this.targetDistance = distance;
                            result.vCopy(direction);
                        }
                        return;
                    }
                    this.ricochetCount++;
                    normal = this.rayHit.normal;
                    this.currDirection.vAddScaled((-2 * this.currDirection.vDot(normal)), normal);
                    this.currOrigin.vCopy(this.rayHit.pos).vAddScaled(0.1, normal);
                }
                else
                {
                    return;
                }
            }
        }
        private function checkSector(origin:Vector3, gunDir:Vector3, gunRotationAxis:Vector3, angleStep:Number, numRays:int, result:Vector3):void
        {
            this.dir.vCopy(gunDir);
            this.matrix.fromAxisAngle(gunRotationAxis, angleStep);
            if (angleStep < 0)
            {
                angleStep = -(angleStep);
            }
            var angle:Number = angleStep;
            var i:int;
            while (i < numRays)
            {
                this.dir.vTransformBy3(this.matrix);
                this.checkDirection(origin, this.dir, angle, result);
                i++;
                angle = (angle + angleStep);
            }
        }

    }
}
