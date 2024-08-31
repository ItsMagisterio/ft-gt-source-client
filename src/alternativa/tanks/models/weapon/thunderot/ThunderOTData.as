package alternativa.tanks.models.weapon.thunderot
{
    public class ThunderOTData
    {

        public var maxSplashDamageRadius:Number = 0;
        public var minSplashDamageRadius:Number = 0;
        public var minSplashDamagePercent:Number = 0;
        public var impactForce:Number = 0;

        public function ThunderOTData(maxSplashDamageRadius:Number, minSplashDamageRadius:Number, minSplashDamagePercent:Number, impactForce:Number)
        {
            this.maxSplashDamageRadius = maxSplashDamageRadius;
            this.minSplashDamageRadius = minSplashDamageRadius;
            this.minSplashDamagePercent = minSplashDamagePercent;
            this.impactForce = impactForce;
        }
    }
}
