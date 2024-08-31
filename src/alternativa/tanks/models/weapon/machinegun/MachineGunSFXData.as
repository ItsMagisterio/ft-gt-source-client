// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//alternativa.tanks.models.weapon.machinegun.MachineGunSFXData

package alternativa.tanks.models.weapon.machinegun
{
    import flash.media.Sound;
    import alternativa.tanks.engine3d.TextureAnimation;
    import alternativa.engine3d.materials.TextureMaterial;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import ^!s._SafeStr_1090;
    import flash.filters.BitmapFilter;
    import alternativa.tanks.utils.GraphicsUtils;
    import flash.display.BitmapData;
    import alternativa.engine3d.core.MipMapping;

    public class MachineGunSFXData 
    {

        private var _SafeStr_6991:Sound;
        private var _SafeStr_6992:Sound;
        private var _SafeStr_6994:Sound;
        private var _SafeStr_6993:Sound;
        private var _SafeStr_6995:Sound;
        private var _SafeStr_9330:Sound;
        private var _SafeStr_9331:Sound;
        private var _SafeStr_9332:TextureAnimation;
        private var _SafeStr_9333:TextureAnimation;
        private var _SafeStr_9334:TextureAnimation;
        private var _SafeStr_9335:TextureAnimation;
        private var _SafeStr_9336:TextureAnimation;
        private var _SafeStr_9337:TextureAnimation;
        private var _SafeStr_9338:TextureMaterial;
        private var _SafeStr_9339:TextureMaterial;

        public function MachineGunSFXData(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:String, _arg_7:String, _arg_8:String)
        {
            this._SafeStr_6991 = (ResourceUtil.getResource(ResourceType.SOUND, "vulcan_start_1").sound as Sound);
            this._SafeStr_6992 = (ResourceUtil.getResource(ResourceType.SOUND, "vulcan_start_2").sound as Sound);
            this._SafeStr_6994 = (ResourceUtil.getResource(ResourceType.SOUND, "vulcan_end_1").sound as Sound);
            this._SafeStr_6993 = (ResourceUtil.getResource(ResourceType.SOUND, "vulcan_fire_loop").sound as Sound);
            this._SafeStr_6995 = (ResourceUtil.getResource(ResourceType.SOUND, "vulcan_end_2").sound as Sound);
            this._SafeStr_9330 = (ResourceUtil.getResource(ResourceType.SOUND, "vulcan_hit_loop_2").sound as Sound);
            this._SafeStr_9331 = (ResourceUtil.getResource(ResourceType.SOUND, "vulcan_hit_loop").sound as Sound);
            var _local_9:BitmapFilter = _SafeStr_1090.ResourceType54(10, 3, 34, 2.4);
            var _local_10:BitmapFilter = _SafeStr_1090.ResourceType54(10, 3, 34, 2.4);
            var _local_11:BitmapFilter = _SafeStr_1090.ResourceType54(10, 3, 34, 2.4);
            this._SafeStr_9333 = this.ResourceType55(ResourceUtil.getResource(ResourceType._SafeStr_1558, _arg_1).bitmapData, 128, _local_9, 30);
            this._SafeStr_9334 = this.ResourceType55(ResourceUtil.getResource(ResourceType._SafeStr_1558, _arg_2).bitmapData, 128, _local_9, 30);
            this._SafeStr_9332 = this._SafeStr_2401(ResourceUtil.getResource(ResourceType._SafeStr_1558, _arg_3).bitmapData, 64, 30);
            this._SafeStr_9335 = this._SafeStr_2401(ResourceUtil.getResource(ResourceType._SafeStr_1558, _arg_4).bitmapData, 128, 30);
            this._SafeStr_9336 = this._SafeStr_2401(ResourceUtil.getResource(ResourceType._SafeStr_1558, _arg_5).bitmapData, (0x0200 / 4), 30);
            this._SafeStr_9337 = this._SafeStr_2401(ResourceUtil.getResource(ResourceType._SafeStr_1558, _arg_6).bitmapData, (0x0200 / 4), 30);
            this._SafeStr_9338 = ResourceType53(ResourceUtil.getResource(ResourceType._SafeStr_1558, _arg_7).bitmapData, _local_11);
            this._SafeStr_9339 = new TextureMaterial(ResourceUtil.getResource(ResourceType._SafeStr_1558, _arg_8).bitmapData);
        }

        private static function ResourceType53(_arg_1:BitmapData, _arg_2:BitmapFilter):TextureMaterial
        {
            var _local_3:BitmapData = GraphicsUtils._SafeStr_3719(_arg_1, _arg_2);
            var _local_4:TextureMaterial = new TextureMaterial(_local_3);
            _local_4.mipMapping = MipMapping.NONE;
            _local_4.repeat = true;
            return (_local_4);
        }


        private function _SafeStr_2401(_arg_1:BitmapData, _arg_2:int, _arg_3:int=30):TextureAnimation
        {
            var _local_4:TextureAnimation = GraphicsUtils._SafeStr_2401(null, _arg_1, _arg_2, _arg_2);
            _local_4.fps = _arg_3;
            return (_local_4);
        }

        private function ResourceType55(_arg_1:BitmapData, _arg_2:int, _arg_3:BitmapFilter, _arg_4:int=30):TextureAnimation
        {
            var _local_5:TextureAnimation = GraphicsUtils.ResourceType55(null, _arg_1, _arg_3, _arg_2, _arg_2);
            _local_5.fps = _arg_4;
            return (_local_5);
        }

        public function get ResourceType46():Sound
        {
            return (this._SafeStr_6991);
        }

        public function get ResourceType47():Sound
        {
            return (this._SafeStr_6992);
        }

        public function get ResourceType49():Sound
        {
            return (this._SafeStr_6994);
        }

        public function get ResourceType48():Sound
        {
            return (this._SafeStr_6993);
        }

        public function get ResourceType50():Sound
        {
            return (this._SafeStr_6995);
        }

        public function get ResourceType51():Sound
        {
            return (this._SafeStr_9330);
        }

        public function get ResourceType52():Sound
        {
            return (this._SafeStr_9331);
        }

        public function get ResourceType43():TextureAnimation
        {
            return (this._SafeStr_9332);
        }

        public function get ResourceType38():TextureAnimation
        {
            return (this._SafeStr_9333);
        }

        public function get ResourceType37():TextureAnimation
        {
            return (this._SafeStr_9334);
        }

        public function get smokeTexture():TextureAnimation
        {
            return (this._SafeStr_9335);
        }

        public function get ResourceType35():TextureAnimation
        {
            return (this._SafeStr_9336);
        }

        public function get ResourceType36():TextureAnimation
        {
            return (this._SafeStr_9337);
        }

        public function get ResourceType34():TextureMaterial
        {
            return (this._SafeStr_9338);
        }

        public function get ResourceType44():TextureMaterial
        {
            return (this._SafeStr_9339);
        }

        public function close():void
        {
            this._SafeStr_6991 = null;
            this._SafeStr_6992 = null;
            this._SafeStr_6994 = null;
            this._SafeStr_6993 = null;
            this._SafeStr_6995 = null;
            this._SafeStr_9330 = null;
            this._SafeStr_9331 = null;
        }


    }
}//package alternativa.tanks.models.weapon.machinegun

// _SafeStr_1090 = "&!z" (String#32, DoABC#1296)
// _SafeStr_1558 = ">#v" (String#86, DoABC#1296)
// getResource = "<\"1" (String#83, DoABC#1296)
// _SafeStr_2401 = "9#s" (String#78, DoABC#1296)
// _SafeStr_3719 = ";\"J" (String#81, DoABC#1296)
// ResourceType = "\"5" (String#27, DoABC#1296)
// ResourceType34 = "?6" (String#89, DoABC#1296)
// ResourceType35 = ",#S" (String#37, DoABC#1296)
// ResourceType36 = ";#`" (String#82, DoABC#1296)
// ResourceType37 = "^!6" (String#103, DoABC#1296)
// ResourceType38 = "%!0" (String#29, DoABC#1296)
// ResourceType43 = "2\"+" (String#48, DoABC#1296)
// ResourceType44 = "%!b" (String#30, DoABC#1296)
// ResourceType46 = "5!F" (String#55, DoABC#1296)
// ResourceType47 = "'\"t" (String#36, DoABC#1296)
// ResourceType48 = "&\"," (String#33, DoABC#1296)
// ResourceType49 = "4Z" (String#54, DoABC#1296)
// ResourceType50 = "2\"q" (String#49, DoABC#1296)
// ResourceType51 = "2!8" (String#47, DoABC#1296)
// ResourceType52 = "`\"L" (String#108, DoABC#1296)
// ResourceType53 = "9\"!" (String#77, DoABC#1296)
// ResourceType54 = "#\"Y" (String#28, DoABC#1296)
// ResourceType55 = "1$>" (String#40, DoABC#1296)
// TextureAnimation = "6#E" (String#65, DoABC#1296)
// _SafeStr_6991 = ">!G" (String#85, DoABC#1296)
// _SafeStr_6992 = "[\"b" (String#101, DoABC#1296)
// _SafeStr_6993 = "&#a" (String#34, DoABC#1296)
// _SafeStr_6994 = "<#s" (String#84, DoABC#1296)
// _SafeStr_6995 = "%#=" (String#31, DoABC#1296)
// _SafeStr_9330 = "?\"c" (String#87, DoABC#1296)
// _SafeStr_9331 = "]<" (String#102, DoABC#1296)
// _SafeStr_9332 = "4\"T" (String#50, DoABC#1296)
// _SafeStr_9333 = "0!2" (String#38, DoABC#1296)
// _SafeStr_9334 = "0\"f" (String#39, DoABC#1296)
// _SafeStr_9335 = "7!y" (String#74, DoABC#1296)
// _SafeStr_9336 = "&#s" (String#35, DoABC#1296)
// _SafeStr_9337 = "?#+" (String#88, DoABC#1296)
// _SafeStr_9338 = "`!y" (String#107, DoABC#1296)
// _SafeStr_9339 = "4>" (String#53, DoABC#1296)


