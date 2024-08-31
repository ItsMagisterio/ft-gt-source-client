// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.machinegun.sfx.ParticleSystem

package alternativa.tanks.models.weapon.machinegun.sfx
{
    import alternativa.tanks.utils.objectpool.ObjectPool;
    import flash.utils.Dictionary;
    public class ParticleSystem
    {

        private var _SafeStr_5913:Dictionary = new Dictionary();
        private var _SafeStr_9293:Class;
        private var _SafeStr_9294:Boolean;
        private var _SafeStr_9295:Number = 0;
        private var time:Number = 0;
        private var count:int;
        private var _SafeStr_9296:int;
        private var objectPool:ObjectPool;

        public function ParticleSystem(_arg_1:Class, _arg_2:Number, _arg_3:int, _arg_4:ObjectPool)
        {
            this._SafeStr_9293 = _arg_1;
            this._SafeStr_9295 = _arg_2;
            this._SafeStr_9296 = _arg_3;
            this.objectPool = _arg_4;
        }

        public function start():void
        {
            this._SafeStr_9294 = true;
        }

        public function stop():void
        {
            this._SafeStr_9294 = false;
        }

        public function update(_arg_1:Number):Boolean
        {
            var _local_2:* = undefined;
            var _local_3:* = null;
            if (this._SafeStr_9294)
            {
                this.time = (this.time + _arg_1);
                if (this.time >= this._SafeStr_9295)
                {
                    this.time = 0;
                    if (this.count < this._SafeStr_9296)
                    {
                        this._SafeStr_9297();
                    }
                }
            }
            for (_local_3 in this._SafeStr_5913)
            {
                this._SafeStr_9243(_local_3, _arg_1);
                if ((!(_local_3.alive)))
                {
                    this._SafeStr_9298(_local_3);
                }
            }
            return ((this._SafeStr_9294) || (this.count > 0));
        }

        public function clear():void
        {
            var _local_1:* = undefined;
            var _local_2:* = null;
            for (_local_2 in this._SafeStr_5913)
            {
                this._SafeStr_9298(_local_2);
            }
            this.stop();
        }

        protected function _SafeStr_9242(_arg_1:Particle):void
        {
        }

        protected function _SafeStr_9243(_arg_1:Particle, _arg_2:Number):void
        {
        }

        protected function _SafeStr_9244(_arg_1:Particle):void
        {
        }

        private function _SafeStr_9297():void
        {
            var _local_1:Particle = Particle(this.objectPool.getObject(this._SafeStr_9293));
            _local_1.alive = true;
            this._SafeStr_9242(_local_1);
            this._SafeStr_5913[_local_1] = true;
            this.count++;
        }

        private function _SafeStr_9298(_arg_1:Particle):void
        {
            this._SafeStr_9244(_arg_1);
            delete this._SafeStr_5913[_arg_1];
            this.count--;
        }

    }
} // package alternativa.tanks.models.weapon.machinegun.sfx

// _SafeStr_5913 = "`\";" (String#9, DoABC#1957)
// _SafeStr_9242 = "8#Q" (String#30, DoABC#1957)
// _SafeStr_9243 = "0\"d" (String#32, DoABC#1957)
// _SafeStr_9244 = "7$ " (String#27, DoABC#1957)
// _SafeStr_9293 = "`#X" (String#25, DoABC#1957)
// _SafeStr_9294 = "&#'" (String#10, DoABC#1957)
// _SafeStr_9295 = "=\"^" (String#17, DoABC#1957)
// _SafeStr_9296 = "%l" (String#22, DoABC#1957)
// _SafeStr_9297 = "?!h" (String#28, DoABC#1957)
// _SafeStr_9298 = "^\"l" (String#24, DoABC#1957)