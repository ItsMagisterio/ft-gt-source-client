﻿package alternativa.tanks.models.weapon.freeze
{
    import com.reygazu.anticheat.variables.SecureInt;

    public class FreezeData
    {

        private static var i:int = 0;

        public var damageAreaConeAngle:Number;
        public var damageAreaRange:Number;
        public var energyCapacity:int;
        public var energyDischargeSpeed:int;
        public var energyRechargeSpeed:int;
        public var weaponTickMsec:SecureInt = new SecureInt(("WeaponTickMsec" + i), 0);

        public function FreezeData(damageAreaConeAngle:Number, damageAreaRange:Number, energyCapacity:int, energyDischargeSpeed:int, energyRechargeSpeed:int, weaponTickMsec:int)
        {
            this.damageAreaConeAngle = damageAreaConeAngle;
            this.damageAreaRange = damageAreaRange;
            this.energyCapacity = energyCapacity;
            this.energyDischargeSpeed = energyDischargeSpeed;
            this.energyRechargeSpeed = energyRechargeSpeed;
            this.weaponTickMsec.value = weaponTickMsec;
            i++;
        }
    }
}
