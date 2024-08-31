// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.machinegun.sfx._SafeStr_1088

package alternativa.tanks.models.weapon.machinegun.sfx
{
    import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
    import alternativa.tanks.utils.objectpool.ObjectPool;
    import alternativa.math.Vector3;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.objects.Sprite3D;

    public class _SafeStr_1088 extends ParticleSystem
    {

        private static const _SafeStr_9245:Number = 130;
        private static const _SafeStr_1826:Number = 6;
        private static const _SafeStr_9246:Number = 0.2;
        private static const _SafeStr_9247:Number = 20;
        private static const _SafeStr_7889:int = 0;
        private static const _SafeStr_9240:int = 5;
        private static const _SafeStr_7886:Number = 0.1;
        private static const _SafeStr_5027:Vector3 = new Vector3();

        private var _SafeStr_9241:Vector3 = new Vector3();
        private var material:TextureMaterial;
        private var container:Scene3DContainer;

        public function _SafeStr_1088(_arg_1:ObjectPool)
        {
            super(_SafeStr_1382, 0, 5, _arg_1);
        }

        public function setMaterial(_arg_1:TextureMaterial):void
        {
            this.material = _arg_1;
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
            var _local_2:_SafeStr_1382 = _SafeStr_1382(_arg_1);
            var _local_3:Number = (130 + ((Math.random() * 130) / 2));
            var _local_4:Sprite3D = _local_2.sprite;
            _SafeStr_5027.x = ((Math.random() * 2) - 1);
            _SafeStr_5027.y = -(Math.random());
            _SafeStr_5027.z = ((Math.random() * 2) - 1);
            _SafeStr_5027.normalize();
            _SafeStr_5027.scale(6);
            _local_2.init(_local_3, this._SafeStr_9241, _SafeStr_5027, this.material);
            this.container.addChild(_local_4);
        }

        override protected function _SafeStr_9243(_arg_1:Particle, _arg_2:Number):void
        {
            var _local_3:_SafeStr_1382 = _SafeStr_1382(_arg_1);
            var _local_4:Sprite3D = _local_3.sprite;
            var _local_5:Vector3 = _local_3.direction;
            _local_5.z = (_local_5.z - (20 * _arg_2));
            _local_4.x = (_local_4.x + _local_5.x);
            _local_4.y = (_local_4.y + _local_5.y);
            _local_4.z = (_local_4.z + _local_5.z);
            _local_3.time = (_local_3.time + _arg_2);
            if (_local_3.time > 0.2)
            {
                _local_3.time = 0.2;
            }
            _local_4.alpha = (1 - (_local_3.time / 0.2));
            var _local_6:Number = (1 - _local_4.alpha);
            if (_local_6 < 0.1)
            {
                _local_6 = 0.1;
            }
            _local_4.scaleX = _local_6;
            _local_4.scaleY = _local_6;
            _local_4.scaleZ = _local_6;
            if (_local_4.alpha <= 0)
            {
                _local_3.alive = false;
            }
        }

        override protected function _SafeStr_9244(_arg_1:Particle):void
        {
            this.container.removeChild(_SafeStr_1382(_arg_1).sprite);
        }

        override public function clear():void
        {
            super.clear();
            this.material = null;
            this.container = null;
        }

    }
} // package alternativa.tanks.models.weapon.machinegun.sfx

// Vector3 = "#!B" (String#10, DoABC#1960)
// _SafeStr_1088 = "4k" (String#17, DoABC#1960)
// _SafeStr_1382 = "`\"R" (String#8, DoABC#1960)
// _SafeStr_1826 = "!#i" (String#67, DoABC#1960)
// _SafeStr_3303 = "\"!n" (String#70, DoABC#1960)
// ResourceType41 = "[!C" (String#47, DoABC#1960)
// Scene3DContainer = ";!>" (String#27, DoABC#1960)
// _SafeStr_5027 = ";\"j" (String#7, DoABC#1960)
// _SafeStr_7886 = "6$<" (String#78, DoABC#1960)
// _SafeStr_7889 = "9;" (String#63, DoABC#1960)
// _SafeStr_9240 = "4!i" (String#62, DoABC#1960)
// _SafeStr_9241 = "8\"[" (String#19, DoABC#1960)
// _SafeStr_9242 = "8#Q" (String#75, DoABC#1960)
// _SafeStr_9243 = "0\"d" (String#89, DoABC#1960)
// _SafeStr_9244 = "7$ " (String#38, DoABC#1960)
// _SafeStr_9245 = ",#s" (String#48, DoABC#1960)
// _SafeStr_9246 = ",U" (String#85, DoABC#1960)
// _SafeStr_9247 = "4\"m" (String#77, DoABC#1960)