// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//alternativa.tanks.models.weapon.machinegun._SafeStr_495

package alternativa.tanks.models.weapon.machinegun
{
    import [#B._SafeStr_492;
    import [#B._SafeStr_493;
    import alternativa.model._SafeStr_16;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.model._SafeStr_12;
    import 5";.Main;
    import "!7.ClientObject;

    public class _SafeStr_495 extends _SafeStr_492 implements _SafeStr_494 
    {

        private static var _SafeStr_2543:IObjectPoolService;

        public function _SafeStr_495()
        {
            _SafeStr_1589.push(_SafeStr_12, _SafeStr_16, _SafeStr_494);
            _SafeStr_2543 = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
        }

        public function initObject(_arg_1:ClientObject, _arg_2:Number, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:String, _arg_7:String, _arg_8:String, _arg_9:String, _arg_10:String):void
        {
            var _local_11:MachineGunSFXData = new MachineGunSFXData(_arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10);
            _arg_1._SafeStr_1603(MachineGunEffects, _local_11);
        }

        public function objectLoaded(_arg_1:ClientObject):void
        {
        }

        public function objectUnloaded(_arg_1:ClientObject):void
        {
        }

        public function _SafeStr_2732(_arg_1:ClientObject):MachineGunSFXData
        {
            return (MachineGunSFXData(_arg_1._SafeStr_1612(MachineGunEffects)));
        }


    }
}//package alternativa.tanks.models.weapon.machinegun

// _SafeStr_12 = "\"#5" (String#26, DoABC#752)
// getService = "\"#1" (String#33, DoABC#752)
// _SafeStr_1589 = " \"$" (String#21, DoABC#752)
// _SafeStr_16 = "2[" (String#20, DoABC#752)
// _SafeStr_1603 = ">!j" (String#41, DoABC#752)
// _SafeStr_1612 = "&!R" (String#34, DoABC#752)
// _SafeStr_2543 = "8\"D" (String#19, DoABC#752)
// _SafeStr_2732 = "\"\"Z" (String#51, DoABC#752)
// IObjectPoolService = "1\"g" (String#11, DoABC#752)
// _SafeStr_492 = "2\"w" (String#10, DoABC#752)
// _SafeStr_493 = "2!U" (String#39, DoABC#752)
// _SafeStr_494 = "@#3" (String#17, DoABC#752)
// _SafeStr_495 = "6#J" (String#14, DoABC#752)


