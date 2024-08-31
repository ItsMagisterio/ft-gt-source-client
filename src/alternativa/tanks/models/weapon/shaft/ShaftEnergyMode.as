// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.shaft.ShaftEnergyMode

package alternativa.tanks.models.weapon.shaft
{
    public class ShaftEnergyMode
    {

        public static const RECHARGE:ShaftEnergyMode = new ShaftEnergyMode("RECHARGE");
        public static const DRAIN:ShaftEnergyMode = new ShaftEnergyMode("DRAIN");

        private var value:String;

        public function ShaftEnergyMode(param1:String)
        {
            this.value = param1;
        }

        [Obfuscation(rename="false")]
        public function toString():String
        {
            return (this.value);
        }

    }
} // package alternativa.tanks.models.weapon.shaft