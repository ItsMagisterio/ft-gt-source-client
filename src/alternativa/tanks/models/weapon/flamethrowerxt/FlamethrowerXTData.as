package alternativa.tanks.models.weapon.flamethrowerxt
{
    import com.reygazu.anticheat.variables.SecureInt;
    import com.reygazu.anticheat.variables.SecureNumber;

    public class FlamethrowerXTData
    {

        public var targetDetectionInterval:SecureInt = new SecureInt("targetDetectionInterval", 0);
        public var range:SecureNumber = new SecureNumber("range", 0);
        public var coneAngle:SecureNumber = new SecureNumber("coneAngle", 0);
        public var heatingSpeed:SecureInt = new SecureInt("heatingSpeed", 0);
        public var coolingSpeed:SecureInt = new SecureInt("coolingSpeed", 0);
        public var heatLimit:SecureInt = new SecureInt("heatLimit", 0);

    }
}
