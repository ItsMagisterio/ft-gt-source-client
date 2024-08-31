// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.machinegun._SafeStr_462

package alternativa.tanks.models.weapon.machinegun
{
    import com.reygazu.anticheat.variables.SecureInt;

    public class _SafeStr_462
    {

        private static var i:int = 0;

        public var energyCapacity:int;
        public var energyDischargeSpeed:int;
        public var energyRechargeSpeed:int;
        public var spinUpTime:Number;
        public var weaponTickMsec:SecureInt = new SecureInt(("WeaponTickMsec" + i), 0);
        public var damageTickMsec:SecureInt = new SecureInt(("DamageTickMsec" + i), 0);
        public var spinDownTime:Number;
        public var weaponTurnDecelerationCoeff:Number;
        public var recoilForce:Number;
        public var impactForce:Number;

        public function _SafeStr_462(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:Number, _arg_7:Number, _arg_8:Number, _arg_9:Number, _arg_10:Number)
        {
            this.energyCapacity = _arg_1;
            this.energyDischargeSpeed = _arg_2;
            this.energyRechargeSpeed = _arg_3;
            this.weaponTickMsec.value = _arg_4;
            this.damageTickMsec.value = _arg_5;
            this.spinUpTime = _arg_6;
            this.spinDownTime = _arg_7;
            this.weaponTurnDecelerationCoeff = _arg_8;
            this.recoilForce = _arg_9;
            this.impactForce = _arg_10;
            i++;
        }

    }
} // package alternativa.tanks.models.weapon.machinegun

// _SafeStr_462 = "+#O" (String#12, DoABC#703)
// SecureInt = SecureInt" (String#8, DoABC#703)