﻿package alternativa.tanks.models.weapon.healing
{
    import alternativa.math.Vector3;
    import alternativa.math.Matrix3;
    import alternativa.physics.collision.types.RayIntersection;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import alternativa.tanks.models.tank.TankData;
    import projects.tanks.client.battleservice.model.team.BattleTeamType;
    import alternativa.physics.Body;
    import alternativa.tanks.physics.CollisionGroup;
    import alternativa.tanks.physics.TanksCollisionDetector;
    import alternativa.physics.collision.ICollisionDetector;
    import flash.geom.Matrix3D;
    import __AS3__.vec.*;
    import alternativa.physics.altphysics;
    use namespace altphysics;

    public class HealingGunTargetSystem
    {

        private const collisionGroup:int = 16;
        private const LOCKING_RANGE_DELTA:Number = 50;
        private const angleWeight:Number = 0.6;
        private const distanceWeight:Number = 0.4;

        private var _xAxis:Vector3 = new Vector3();
        private var matrix:Matrix3 = new Matrix3();
        private var rotationMatrix:Matrix3 = new Matrix3();
        private var intersection:RayIntersection = new RayIntersection();
        private var staticIntersection:RayIntersection = new RayIntersection();
        private var predicate:GunPredicate = new GunPredicate();
        private var rayDir:Vector3 = new Vector3();
        private var vin:Vector.<Number> = Vector.<Number>([0, 0, 0]);
        private var vout:Vector.<Number> = Vector.<Number>([0, 0, 0]);
        private var stvin:Vector3 = new Vector3(0, 0, 0);
        private var stvout:Vector3 = new Vector3(0, 0, 0);
        private var hitPointsTargets:Array = [];
        private var hitPointsArray:Array = [];
        private var hitPoints:Array = [];
        private var checkedTargets:Dictionary = new Dictionary();
        private var bestTarget:TankData;
        private var maxTargetPriority:Number;
        private var shooterTeamType:BattleTeamType;
        private var muzzlePosGlobal:Vector3 = new Vector3();

        public function getTarget(healerData:TankData, gunData:HealingGunData, barrelLength:Number, barrelOrigin:Vector3, gunDir:Vector3, xAxis:Vector3, numRays:int, numSteps:Number, collisionDetector:TanksCollisionDetector, tankDatas:Dictionary):TankData
        {
            var key:*;
            var targetBody:Body;
            if (collisionDetector.intersectRayWithStatic(barrelOrigin, gunDir, CollisionGroup.STATIC, barrelLength, null, this.intersection))
            {
                return (null);
            }
            this.muzzlePosGlobal.x = (barrelOrigin.x + (barrelLength * gunDir.x));
            this.muzzlePosGlobal.y = (barrelOrigin.y + (barrelLength * gunDir.y));
            this.muzzlePosGlobal.z = (barrelOrigin.z + (barrelLength * gunDir.z));
            this.bestTarget = null;
            this.maxTargetPriority = 0;
            this.shooterTeamType = healerData.teamType;
            var lockingRangeSqr:Number = (gunData.maxRadius.value - this.LOCKING_RANGE_DELTA);
            lockingRangeSqr = (lockingRangeSqr * lockingRangeSqr);
            this._xAxis.x = xAxis.x;
            this._xAxis.y = xAxis.y;
            this._xAxis.z = xAxis.z;
            this.predicate.healer = healerData.tank;
            if (collisionDetector.intersectRay(this.muzzlePosGlobal, gunDir, this.collisionGroup, gunData.maxRadius.value, this.predicate, this.intersection))
            {
                targetBody = this.intersection.primitive.body;
                if (targetBody != null)
                {
                    this.checkTarget(targetBody, tankDatas, gunData, lockingRangeSqr, this.muzzlePosGlobal, gunDir, collisionDetector);
                }
            }
            this.rotationMatrix.fromAxisAngle(gunDir, (Math.PI / numSteps));
            var angleStep:Number = (gunData.lockAngle.value / numRays);
            var i:int;
            while (i < numSteps)
            {
                this.checkSector(gunData, lockingRangeSqr, this.muzzlePosGlobal, gunDir, this._xAxis, numRays, angleStep, collisionDetector, tankDatas, 0);
                this.checkSector(gunData, lockingRangeSqr, this.muzzlePosGlobal, gunDir, this._xAxis, numRays, -(angleStep), collisionDetector, tankDatas, numSteps);
                this._xAxis.vTransformBy3(this.rotationMatrix);
                i++;
            }
            var target:TankData = this.bestTarget;
            this.bestTarget = null;
            this.predicate.healer = null;
            for (key in this.checkedTargets)
            {
                delete this.checkedTargets[key];
            }
            this.hitPoints = [];
            this.hitPointsTargets = [];
            this.hitPointsArray = [];
            return (target);
        }
        public function validateTarget(healerData:TankData, targetData:TankData, gunData:HealingGunData, gunDir:Vector3, barrelOrigin:Vector3, barrelLength:Number, collisionDetector:TanksCollisionDetector):Boolean
        {
            var dx:Number;
            var dy:Number;
            var dz:Number;
            var d:Number;
            var body:Body;
            if (collisionDetector.intersectRayWithStatic(barrelOrigin, gunDir, CollisionGroup.STATIC, barrelLength, null, this.intersection))
            {
                return (false);
            }
            this.muzzlePosGlobal.x = (barrelOrigin.x + (barrelLength * gunDir.x));
            this.muzzlePosGlobal.y = (barrelOrigin.y + (barrelLength * gunDir.y));
            this.muzzlePosGlobal.z = (barrelOrigin.z + (barrelLength * gunDir.z));
            targetData.tank.skin.turretMesh.matrix.transformVectors(this.vin, this.vout);
            dx = (this.vout[0] - this.muzzlePosGlobal.x);
            dy = (this.vout[1] - this.muzzlePosGlobal.y);
            dz = (this.vout[2] - this.muzzlePosGlobal.z);
            d = (((dx * dx) + (dy * dy)) + (dz * dz));
            if (d > (gunData.maxRadius.value * gunData.maxRadius.value))
            {
                return (false);
            }
            this.rayDir.x = dx;
            this.rayDir.y = dy;
            this.rayDir.z = dz;
            d = (1 / Math.sqrt(d));
            dx = (dx * d);
            dy = (dy * d);
            dz = (dz * d);
            var cos:Number = (((dx * gunDir.x) + (dy * gunDir.y)) + (dz * gunDir.z));
            if (cos < gunData.maxAngleCos.value)
            {
                return (false);
            }
            this.predicate.healer = healerData.tank;
            if (collisionDetector.intersectRay(this.muzzlePosGlobal, this.rayDir, CollisionGroup.WEAPON, 1, this.predicate, this.intersection))
            {
                this.predicate.healer = null;
                body = this.intersection.primitive.body;
                if (((body == null) || (!(body == targetData.tank))))
                {
                    return (false);
                }
            }
            return (true);
        }
        private function checkSector(gunData:HealingGunData, lockingRangeSqr:Number, rayOrigin:Vector3, gunDir:Vector3, xAxis:Vector3, raysNum:int, angleStep:Number, collisionDetector:ICollisionDetector, tanks:Dictionary, step:int):void
        {
            var targetBody:Body;
            var angle:Number = 0;
            var i:int = 1;
            while (i <= raysNum)
            {
                angle = (angle + angleStep);
                this.matrix.fromAxisAngle(xAxis, angle);
                this.matrix.transformVector(gunDir, this.rayDir);
                if (collisionDetector.intersectRay(rayOrigin, this.rayDir, this.collisionGroup, gunData.maxRadius.value, this.predicate, this.intersection))
                {
                    targetBody = this.intersection.primitive.body;
                    if (targetBody != null)
                    {
                        this.checkTarget(targetBody, tanks, gunData, lockingRangeSqr, rayOrigin, gunDir, collisionDetector);
                    }
                }
                i++;
            }
        }
        private function checkTarget(targetBody:Body, tanks:Dictionary, gunData:HealingGunData, lockingRangeSqr:Number, rayOrigin:Vector3, gunDir:Vector3, collisionDetector:ICollisionDetector):void
        {
            if (this.checkedTargets[targetBody] != null)
            {
                return;
            }
            this.checkedTargets[targetBody] = true;
            var targetData:TankData = tanks[targetBody];
            if (((targetData == null) || (!(targetData.enabled))))
            {
                return;
            }
            var matrix:Matrix3D = targetData.tank.skin.turretMesh.matrix;
            matrix.transformVectors(this.vin, this.vout);
            var dx:Number = (this.vout[0] - rayOrigin.x);
            var dy:Number = (this.vout[1] - rayOrigin.y);
            var dz:Number = (this.vout[2] - rayOrigin.z);
            var d:Number = (((dx * dx) + (dy * dy)) + (dz * dz));
            if (d > lockingRangeSqr)
            {
                return;
            }
            var distanceSqr:Number = d;
            d = (1 / Math.sqrt(d));
            dx = (dx * d);
            dy = (dy * d);
            dz = (dz * d);
            var angleCos:Number = (((dx * gunDir.x) + (dy * gunDir.y)) + (dz * gunDir.z));
            if (angleCos <= gunData.maxAngleCos.value)
            {
                return;
            }
            this.rayDir.x = dx;
            this.rayDir.y = dy;
            this.rayDir.z = dz;
            if (collisionDetector.intersectRay(rayOrigin, this.rayDir, this.collisionGroup, gunData.maxRadius.value, this.predicate, this.intersection))
            {
                if (this.intersection.primitive.body != targetBody)
                {
                    return;
                }
            }
            var priority:Number = ((this.getBaseTargetPriority(targetData) + ((this.distanceWeight * (lockingRangeSqr - distanceSqr)) / lockingRangeSqr)) + (this.angleWeight * angleCos));
            if (priority > this.maxTargetPriority)
            {
                this.maxTargetPriority = priority;
                this.bestTarget = targetData;
            }
        }
        private function getBaseTargetPriority(targetData:TankData):Number
        {
            if (this.shooterTeamType == BattleTeamType.NONE)
            {
                return (1);
            }
            if (this.shooterTeamType == targetData.teamType)
            {
                return ((targetData.health == 10000) ? 1 : 3);
            }
            return (2);
        }

    }
}

import alternativa.physics.collision.IRayCollisionPredicate;
import alternativa.physics.Body;

class GunPredicate implements IRayCollisionPredicate
{

    public var healer:Body;

    public function considerBody(body:Body):Boolean
    {
        return (!(this.healer == body));
    }

}
