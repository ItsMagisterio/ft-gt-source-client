// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.machinegun.sfx._SafeStr_1086

package alternativa.tanks.models.weapon.machinegun.sfx
{
    import alternativa.math.Vector3;
    import alternativa.tanks.utils.objectpool.ObjectPool;
    ;
    import alternativa.tanks.engine3d.TextureAnimation;

    import alternativa.tanks.engine3d.AnimatedSprite3D;
    import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;

    public class _SafeStr_1086 extends ParticleSystem
    {

        private static const _SafeStr_9240:int = 5;

        private var size:Number;
        private var speed:Number;
        private var top:Number;
        private var _SafeStr_9241:Vector3 = new Vector3();
        private var animation:TextureAnimation;
        private var container:Scene3DContainer;

        public function _SafeStr_1086(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:ObjectPool)
        {
            super(_SafeStr_1381, _arg_4, 5, _arg_5);
            this.size = _arg_1;
            this.speed = _arg_2;
            this.top = _arg_3;
        }

        public function ResourceType33(_arg_1:TextureAnimation):void
        {
            this.animation = _arg_1;
        }

        public function _SafeStr_3303(_arg_1:Scene3DContainer):void
        {
            this.container = _arg_1;
        }

        public function ResourceType41(_arg_1:Vector3):void
        {
            this._SafeStr_9241.vCopy(_arg_1);
        }

        override protected function _SafeStr_9242(_arg_1:Particle):void
        {
            var _local_2:_SafeStr_1381 = _SafeStr_1381(_arg_1);
            _local_2.init(this.size, this._SafeStr_9241, ((Math.random() * Math.PI) * 2), this.animation);
            this.container.addChild(_local_2.sprite);
        }

        override protected function _SafeStr_9243(_arg_1:Particle, _arg_2:Number):void
        {
            var _local_4:AnimatedSprite3D;
            var _local_3:_SafeStr_1381;
            _local_3 = _SafeStr_1381(_arg_1);
            _local_4 = _local_3.sprite;
            _local_4.update(_arg_2);
            _local_4.z = (_local_4.z + (this.speed * _arg_2));
            var _local_5:Number = (1 - ((Math.abs(((this.top / 2) - (_local_4.z - _local_3._SafeStr_5026))) * 2) / this.top));
            _local_4.alpha = _local_5;
            _local_4.rotation = (_local_3.rotation + (_local_5 * 0.3));
            if ((_local_4.z - _local_3._SafeStr_5026) >= this.top)
            {
                _local_3.alive = false;
            }
        }

        override protected function _SafeStr_9244(_arg_1:Particle):void
        {
            this.container.removeChild(_SafeStr_1381(_arg_1).sprite);
        }

        override public function clear():void
        {
            super.clear();
            this.animation = null;
            this.container = null;
        }

    }
} // package alternativa.tanks.models.weapon.machinegun.sfx

// Vector3 = "#!B" (String#13, DoABC#1958)
// _SafeStr_1086 = "2!0" (String#18, DoABC#1958)
// _SafeStr_1381 = "3\"T" (String#7, DoABC#1958)
// _SafeStr_3303 = "\"!n" (String#64, DoABC#1958)
// ResourceType33 = "4\"N" (String#53, DoABC#1958)
// ResourceType41 = "[!C" (String#35, DoABC#1958)
// Scene3DContainer = ";!>" (String#28, DoABC#1958)
// _SafeStr_5026 = "6$%" (String#25, DoABC#1958)
// TextureAnimation = "6#E" (String#27, DoABC#1958)
// _SafeStr_9240 = "4!i" (String#54, DoABC#1958)
// _SafeStr_9241 = "8\"[" (String#15, DoABC#1958)
// _SafeStr_9242 = "8#Q" (String#75, DoABC#1958)
// _SafeStr_9243 = "0\"d" (String#72, DoABC#1958)
// _SafeStr_9244 = "7$ " (String#41, DoABC#1958)