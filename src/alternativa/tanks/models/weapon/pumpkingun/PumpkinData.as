﻿package alternativa.tanks.models.weapon.pumpkingun
{
    public class PumpkinData
    {

        public var shotRadius:Number;
        public var shotSpeed:Number;
        public var energyCapacity:int;
        public var energyPerShot:int;
        public var energyRechargeSpeed:Number;
        public var shotDistance:Number;

        public function PumpkinData(shotRadius:Number, shotSpeed:Number, energyCapacity:int, energyPerShot:int, energyRechargeSpeed:int, shotDistance:Number)
        {
            this.shotRadius = shotRadius;
            this.shotSpeed = shotSpeed;
            this.energyCapacity = energyCapacity;
            this.energyPerShot = energyPerShot;
            this.energyRechargeSpeed = energyRechargeSpeed;
            this.shotDistance = shotDistance;
        }
    }
}
