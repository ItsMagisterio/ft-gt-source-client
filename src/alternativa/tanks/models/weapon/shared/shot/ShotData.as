package alternativa.tanks.models.weapon.shared.shot
{
    import com.reygazu.anticheat.variables.SecureNumber;
    import com.reygazu.anticheat.variables.SecureInt;

    public class ShotData
    {

        public var autoAimingAngleDown:SecureNumber = new SecureNumber("autoAimingAngleDown ", 0);
        public var autoAimingAngleUp:SecureNumber = new SecureNumber("autoAimingAngleUp ", 0);
        public var numRaysUp:SecureInt = new SecureInt("numRaysUp ", 0);
        public var numRaysDown:SecureInt = new SecureInt("numRaysDown ", 0);
        public var reloadMsec:SecureInt = new SecureInt("reloadMsec");

        public function ShotData(reloadMsec:int)
        {
            this.reloadMsec.value = reloadMsec;
        }
    }
}
