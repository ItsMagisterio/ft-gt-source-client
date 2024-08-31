package alternativa.tanks.models.weapon.railgun
{
    import alternativa.physics.collision.ICollisionDetector;
    import alternativa.physics.collision.types.RayIntersection;
    import alternativa.math.Vector3;
    import alternativa.math.Matrix3;
    import alternativa.tanks.models.ctf.ICTFModel;
    import alternativa.tanks.models.tank.TankData;
    import flash.utils.Dictionary;
    import alternativa.physics.Body;
    import projects.tanks.client.battleservice.model.team.BattleTeamType;

    public class RailgunTargetSystem
    {

        private static const FLAG_CARRIER_BONUS:Number = 10;
        private static const DISTANCE_WEIGHT:Number = 0.65;
        private static const BASE_DISTANCE:Number = 20000;
        private static const MAX_PRIORITY:Number = 1000;

        private const COLLISION_GROUP:int = 16;
        private const MAX_RAY_LENGTH:Number = 10000000000;

        private var collisionDetector:ICollisionDetector;
        private var upAngleStep:Number;
        private var upRaysNum:int;
        private var downAngleStep:Number;
        private var downRaysNum:int;
        private var weakeningCoeff:Number;
        private var multybodyPredicate:MultybodyCollisionPredicate = new MultybodyCollisionPredicate();
        private var intersection:RayIntersection = new RayIntersection();
        private var dir:Vector3 = new Vector3();
        private var rotationMatrix:Matrix3 = new Matrix3();
        private var origin:Vector3 = new Vector3();
        private var _v:Vector3 = new Vector3();
        private var bestDirectionIndex:int;
        private var maxDirectionPriority:Number;
        private var bestEffectivity:Number;
        private var currTargets:Array = [];
        private var currHitPoints:Array = [];
        private var ctfModel:ICTFModel;
        private var maxAngle:Number;

        public function setParams(collisionDetector:ICollisionDetector, upAngle:Number, upRaysNum:int, downAngle:Number, downRaysNum:int, weakeningCoeff:Number, ctfModel:ICTFModel):void
        {
            this.collisionDetector = collisionDetector;
            this.upAngleStep = (upAngle / upRaysNum);
            this.upRaysNum = upRaysNum;
            this.downAngleStep = (downAngle / downRaysNum);
            this.downRaysNum = downRaysNum;
            this.weakeningCoeff = weakeningCoeff;
            this.ctfModel = ctfModel;
            this.maxAngle = ((upAngle > downAngle) ? upAngle : downAngle);
        }
        public function getTargets(shooterData:TankData, barrelOrigin:Vector3, baseDir:Vector3, rotationAxis:Vector3, tanks:Dictionary, shotResult:RailgunShotResult):void
        {
            shotResult.targets.length = 0;
            shotResult.hitPoints.length = 0;
            this.bestEffectivity = 0;
            this.bestDirectionIndex = 10000;
            this.maxDirectionPriority = 0;
            this.checkAllDirections(shooterData, barrelOrigin, baseDir, rotationAxis, tanks, shotResult);
            if (this.bestEffectivity == 0)
            {
                this.collectTargetsAlongRay(shooterData, barrelOrigin, baseDir, tanks, shotResult);
            }
            this.multybodyPredicate.bodies = null;
            this.currHitPoints.length = 0;
            this.currTargets.length = 0;
        }
        private function checkAllDirections(shooterData:TankData, barrelOrigin:Vector3, baseDir:Vector3, rotationAxis:Vector3, tanks:Dictionary, shotResult:RailgunShotResult):void
        {
            var i:int;
            this.checkDirection(barrelOrigin, baseDir, 0, 0, shooterData, tanks, shotResult);
            this.rotationMatrix.fromAxisAngle(rotationAxis, this.upAngleStep);
            this.dir.vCopy(baseDir);
            var angle:Number = 0;
            i = 1;
            while (i <= this.upRaysNum)
            {
                angle = (angle + this.upAngleStep);
                this.dir.vTransformBy3(this.rotationMatrix);
                this.checkDirection(barrelOrigin, this.dir, angle, i, shooterData, tanks, shotResult);
                i++;
            }
            this.rotationMatrix.fromAxisAngle(rotationAxis, -(this.downAngleStep));
            this.dir.vCopy(baseDir);
            angle = 0;
            i = 1;
            while (i <= this.downRaysNum)
            {
                angle = (angle + this.downAngleStep);
                this.dir.vTransformBy3(this.rotationMatrix);
                this.checkDirection(barrelOrigin, this.dir, angle, i, shooterData, tanks, shotResult);
                i++;
            }
        }
        // private function checkAllDirections(param1:TankData, param2:Vector3, param3:Vector3, param4:Vector3, param5:Dictionary, param6:RailgunShotResult) : void
        // {
        // var sideSteps:int = 200;
        // sideSteps++;
        // sideSteps--;
        // var _loc7_:int = 0;
        // var _loc8_:Number = NaN;
        // var sideRotationOffsetMatrix:Matrix3 = new Matrix3();
        // sideRotationOffsetMatrix.fromAxisAngle(new Vector3(0,0,1),360 - 0.174533 * sideSteps);
        // var sideDir:Vector3 = new Vector3();
        // sideDir.vCopy(param3);
        // sideDir.vTransformBy3(sideRotationOffsetMatrix);
        // var sideRotationMatrix:Matrix3 = new Matrix3();
        // sideRotationMatrix.fromAxisAngle(new Vector3(0,0,1),0.174533);
        // var i2:int = 0;
        // i2 = 1;
        // while(i2 <= sideSteps)
        // {
        // _loc7_ = 0;
        // sideDir.vTransformBy3(sideRotationMatrix);
        // this.rotationMatrix.fromAxisAngle(param4,this.upAngleStep);
        // this.dir.vCopy(sideDir);
        // _loc8_ = 0;
        // _loc7_ = 1;
        // while(_loc7_ <= this.upRaysNum + 50)
        // {
        // _loc8_ += this.upAngleStep;
        // this.dir.vTransformBy3(this.rotationMatrix);
        // this.checkDirection(param2,this.dir,_loc8_,_loc7_,param1,param5,param6);
        // _loc7_++;
        // }
        // this.rotationMatrix.fromAxisAngle(param4,-(this.downAngleStep));
        // this.dir.vCopy(sideDir);
        // _loc8_ = 0;
        // _loc7_ = 1;
        // while(_loc7_ <= this.downRaysNum + 100)
        // {
        // _loc8_ += this.downAngleStep;
        // this.dir.vTransformBy3(this.rotationMatrix);
        // this.checkDirection(param2,this.dir,_loc8_,_loc7_,param1,param5,param6);
        // _loc7_++;
        // }
        // i2++;
        // }
        // }
        private function checkDirection(barrelOrigin:Vector3, barrelDir:Vector3, angle:Number, dirIndex:int, shooterData:TankData, tanks:Dictionary, shotResult:RailgunShotResult):void
        {
            var distance:Number;
            var directionPriority:Number;
            var len:int;
            var i:int;
            this.currTargets.length = 0;
            this.currHitPoints.length = 0;
            var effectivity:Number = this.evaluateDirection(barrelOrigin, barrelDir, shooterData, tanks, this.currTargets, this.currHitPoints);
            if (effectivity > 0)
            {
                distance = this._v.vDiff(this.currHitPoints[0], barrelOrigin).vLength();
                directionPriority = this.getDirectionPriority(angle, distance);
                if (((effectivity > this.bestEffectivity) || ((effectivity == this.bestEffectivity) && (directionPriority > this.maxDirectionPriority))))
                {
                    this.bestEffectivity = effectivity;
                    this.bestDirectionIndex = dirIndex;
                    this.maxDirectionPriority = directionPriority;
                    shotResult.dir.vCopy(barrelDir);
                    len = this.currTargets.length;
                    i = 0;
                    while (i < len)
                    {
                        shotResult.targets[i] = this.currTargets[i];
                        shotResult.hitPoints[i] = this.currHitPoints[i];
                        i++;
                    }
                    shotResult.targets.length = len;
                    if (this.currHitPoints.length > len)
                    {
                        shotResult.hitPoints[len] = this.currHitPoints[len];
                        shotResult.hitPoints.length = (len + 1);
                    }
                    else
                    {
                        shotResult.hitPoints.length = len;
                    }
                }
            }
        }
        private function evaluateDirection(barrelOrigin:Vector3, barrelDir:Vector3, shooterData:TankData, tanks:Dictionary, targets:Array, hitPoints:Array):Number
        {
            var body:Body;
            var targetData:TankData;
            var targetIsEnemy:Boolean;
            this.multybodyPredicate.bodies = new Dictionary();
            this.multybodyPredicate.bodies[shooterData.tank] = true;
            this.origin.vCopy(barrelOrigin);
            var effectivity:Number = 0;
            var effectivityCoeff:Number = 1;
            var firstTarget:Boolean = true;
            while (this.collisionDetector.intersectRay(this.origin, barrelDir, this.COLLISION_GROUP, this.MAX_RAY_LENGTH, this.multybodyPredicate, this.intersection))
            {
                body = this.intersection.primitive.body;
                if (body == null)
                {
                    hitPoints.push(this.intersection.pos.vClone());
                    break;
                }
                targetData = tanks[body];
                if (targetData != null)
                {
                    targetIsEnemy = ((shooterData.teamType == BattleTeamType.NONE) || (!(shooterData.teamType == targetData.teamType)));
                    if (firstTarget)
                    {
                        if (((targetData.health > 0) && (!(targetIsEnemy))))
                        {
                            return (0);
                        }
                        firstTarget = false;
                    }
                    if (targetData.health > 0)
                    {
                        if (targetIsEnemy)
                        {
                            if (((!(this.ctfModel == null)) && (this.ctfModel.isFlagCarrier(targetData))))
                            {
                                effectivity = (effectivity + (FLAG_CARRIER_BONUS * effectivityCoeff));
                            }
                            else
                            {
                                effectivity = (effectivity + effectivityCoeff);
                            }
                        }
                        else
                        {
                            effectivity = (effectivity - effectivityCoeff);
                        }
                    }
                    effectivityCoeff = (effectivityCoeff * this.weakeningCoeff);
                    targets.push(targetData);
                    hitPoints.push(this.intersection.pos.vClone());
                }
                this.multybodyPredicate.bodies[body] = true;
                this.origin.vCopy(this.intersection.pos);
            }
            return (effectivity);
        }
        private function collectTargetsAlongRay(shooterData:TankData, barrelOrigin:Vector3, barrelDir:Vector3, tanks:Dictionary, shotResult:RailgunShotResult):void
        {
            var body:Body;
            var targetData:TankData;
            shotResult.hitPoints.length = 0;
            shotResult.targets.length = 0;
            shotResult.dir.vCopy(barrelDir);
            this.multybodyPredicate.bodies = new Dictionary();
            this.multybodyPredicate.bodies[shooterData.tank] = true;
            this.origin.vCopy(barrelOrigin);
            while (this.collisionDetector.intersectRay(this.origin, barrelDir, this.COLLISION_GROUP, this.MAX_RAY_LENGTH, this.multybodyPredicate, this.intersection))
            {
                body = this.intersection.primitive.body;
                if (body == null)
                {
                    shotResult.hitPoints.push(this.intersection.pos.vClone());
                    break;
                }
                targetData = tanks[body];
                if (targetData != null)
                {
                    shotResult.targets.push(targetData);
                    shotResult.hitPoints.push(this.intersection.pos.vClone());
                }
                this.multybodyPredicate.bodies[body] = true;
                this.origin.vCopy(this.intersection.pos);
            }
        }
        private function getDirectionPriority(angle:Number, distance:Number):Number
        {
            return (MAX_PRIORITY - (((DISTANCE_WEIGHT * distance) / BASE_DISTANCE) + (((1 - DISTANCE_WEIGHT) * angle) / this.maxAngle)));
        }

    }
}

import alternativa.physics.collision.IRayCollisionPredicate;
import flash.utils.Dictionary;
import alternativa.physics.Body;

class MultybodyCollisionPredicate implements IRayCollisionPredicate
{

    public var bodies:Dictionary = new Dictionary();

    public function considerBody(body:Body):Boolean
    {
        return (this.bodies[body] == null);
    }

}
