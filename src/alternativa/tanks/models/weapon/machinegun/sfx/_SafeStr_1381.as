// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// alternativa.tanks.models.weapon.machinegun.sfx._SafeStr_1381

package alternativa.tanks.models.weapon.machinegun.sfx
{
    import alternativa.tanks.utils.objectpool.ObjectPool;
    import alternativa.math.Vector3;
    import alternativa.tanks.engine3d.AnimatedSprite3D;
    import alternativa.tanks.sfx._SafeStr_856;
    import alternativa.tanks.engine3d.TextureAnimation;

    public class _SafeStr_1381 extends Particle
    {

        private var _SafeStr_9249:Number;
        private var _SafeStr_9250:Number;
        private var _SafeStr_9248:AnimatedSprite3D = new AnimatedSprite3D(1, 1);

        public function _SafeStr_1381(_arg_1:ObjectPool)
        {
            super(_arg_1);
            _SafeStr_856.ResourceType32(this._SafeStr_9248);
        }

        public function init(_arg_1:Number, _arg_2:Vector3, _arg_3:Number, _arg_4:TextureAnimation):void
        {
            this._SafeStr_9248.width = _arg_1;
            this._SafeStr_9248.height = _arg_1;
            this._SafeStr_9248._SafeStr_3712(_arg_4);
            this._SafeStr_9248.x = _arg_2.x;
            this._SafeStr_9248.y = _arg_2.y;
            this._SafeStr_9248.z = _arg_2.z;
            this._SafeStr_9248.rotation = _arg_3;
            this._SafeStr_9249 = _arg_3;
            this._SafeStr_9250 = _arg_2.z;
        }

        public function get sprite():AnimatedSprite3D
        {
            return (this._SafeStr_9248);
        }

        public function get rotation():Number
        {
            return (this._SafeStr_9249);
        }

        public function get _SafeStr_5026():Number
        {
            return (this._SafeStr_9250);
        }

    }
} // package alternativa.tanks.models.weapon.machinegun.sfx

// Vector3 = "#!B" (String#40, DoABC#2521)
// _SafeStr_1381 = "3\"T" (String#11, DoABC#2521)
// _SafeStr_3712 = "]!4" (String#43, DoABC#2521)
// ResourceType32 = "%#Z" (String#34, DoABC#2521)
// _SafeStr_5026 = "6$%" (String#41, DoABC#2521)
// TextureAnimation = "6#E" (String#36, DoABC#2521)
// _SafeStr_856 = "@\"@" (String#21, DoABC#2521)
// _SafeStr_9248 = "5\"K" (String#3, DoABC#2521)
// _SafeStr_9249 = "9\"g" (String#15, DoABC#2521)
// _SafeStr_9250 = "-\">" (String#13, DoABC#2521)