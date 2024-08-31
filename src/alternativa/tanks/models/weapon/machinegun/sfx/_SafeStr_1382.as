// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//alternativa.tanks.models.weapon.machinegun.sfx._SafeStr_1382

package alternativa.tanks.models.weapon.machinegun.sfx
{
    import alternativa.engine3d.objects.Sprite3D;
    import %"?.Vector3;
    import alternativa.tanks.sfx._SafeStr_856;
    import &$!.ObjectPool;
    import alternativa.engine3d.materials.TextureMaterial;

    public class _SafeStr_1382 extends Particle 
    {

        private var _SafeStr_9248:Sprite3D = new Sprite3D(1, 1);
        private var _direction:Vector3 = new Vector3();
        private var _SafeStr_7820:Number = 0;

        public function _SafeStr_1382(_arg_1:ObjectPool)
        {
            super(_arg_1);
            _SafeStr_856.ResourceType32(this._SafeStr_9248);
        }

        public function init(_arg_1:Number, _arg_2:Vector3, _arg_3:Vector3, _arg_4:TextureMaterial):void
        {
            this._SafeStr_7820 = 0;
            this._direction.vCopy(_arg_3);
            this._SafeStr_9248.width = _arg_1;
            this._SafeStr_9248.height = _arg_1;
            this._SafeStr_9248.x = _arg_2.x;
            this._SafeStr_9248.y = _arg_2.y;
            this._SafeStr_9248.z = _arg_2.z;
            this._SafeStr_9248.material = _arg_4;
        }

        public function get sprite():Sprite3D
        {
            return (this._SafeStr_9248);
        }

        public function get direction():Vector3
        {
            return (this._direction);
        }

        public function get time():Number
        {
            return (this._SafeStr_7820);
        }

        public function set time(_arg_1:Number):void
        {
            this._SafeStr_7820 = _arg_1;
        }


    }
}//package alternativa.tanks.models.weapon.machinegun.sfx

// Vector3 = "#!B" (String#8, DoABC#2522)
// _SafeStr_1382 = "`\"R" (String#12, DoABC#2522)
// ResourceType32 = "%#Z" (String#26, DoABC#2522)
// _SafeStr_7820 = " !X" (String#13, DoABC#2522)
// _SafeStr_856 = "@\"@" (String#22, DoABC#2522)
// _SafeStr_9248 = "5\"K" (String#4, DoABC#2522)


