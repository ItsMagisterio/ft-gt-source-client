// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//alternativa.tanks.models.weapon.machinegun.sfx.Particle

package alternativa.tanks.models.weapon.machinegun.sfx
{
    import &$!._SafeStr_396;
    import &$!.ObjectPool;

    public class Particle extends _SafeStr_396 
    {

        private var _SafeStr_9292:Boolean;

        public function Particle(_arg_1:ObjectPool)
        {
            super(_arg_1);
        }

        public function get alive():Boolean
        {
            return (this._SafeStr_9292);
        }

        public function set alive(_arg_1:Boolean):void
        {
            this._SafeStr_9292 = _arg_1;
        }


    }
}//package alternativa.tanks.models.weapon.machinegun.sfx

// _SafeStr_396 = "#!b" (String#3, DoABC#2520)
// _SafeStr_9292 = "'\"f" (String#10, DoABC#2520)


