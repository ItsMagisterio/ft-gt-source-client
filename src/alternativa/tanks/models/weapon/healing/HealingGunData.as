package alternativa.tanks.models.weapon.healing
{
    import com.reygazu.anticheat.variables.SecureInt;
    import com.reygazu.anticheat.variables.SecureNumber;

    public class HealingGunData
    {

        public var capacity:SecureInt = new SecureInt("capacity isida", 0);
        public var chargeRate:SecureInt = new SecureInt("chargeRate isida", 0);
        public var dischargeRate:SecureInt = new SecureInt("dischargeRate isida", 0);
        public var tickPeriod:SecureInt = new SecureInt("capacity isida", 0);
        public var lockAngle:SecureNumber = new SecureNumber("lockAngle isida", 0);
        public var lockAngleCos:SecureNumber = new SecureNumber("lockAngleCos isida", 0);
        public var maxAngle:SecureNumber = new SecureNumber("maxAngle isida", 0);
        public var maxAngleCos:SecureNumber = new SecureNumber("maxAngleCos isida", 0);
        public var maxRadius:SecureNumber = new SecureNumber("maxRadius isida", 0);

    }
}
