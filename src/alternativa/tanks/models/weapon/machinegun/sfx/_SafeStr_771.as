// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//alternativa.tanks.models.weapon.machinegun.sfx._SafeStr_771

package alternativa.tanks.models.weapon.machinegun.sfx
{
    import &$!._SafeStr_396;
    import alternativa.tanks.sfx._SafeStr_136;
    import alternativa.engine3d.core.Object3D;
    import %"?.Vector3;
    import alternativa.tanks.sfx._SafeStr_515;
    import &$!.ObjectPool;
    import [C.Scene3DContainer;
    import alternativa.tanks.models.weapon.machinegun.MachineGunSFXData;
    import "!7.ClientObject;
    import 5h._SafeStr_408;

    public class _SafeStr_771 extends _SafeStr_396 implements _SafeStr_136 
    {

        private static const _SafeStr_9286:Number = 90;
        private static const _SafeStr_9287:Number = 200;
        private static const _SafeStr_9288:Number = 60;
        private static const _SafeStr_9289:Number = 0.15;
        private static const IModelService33:Number = 0.25;
        private static const ResourceType42:Object3D = new Object3D();
        private static const ResourceType45:Vector3 = new Vector3();

        private var dust:_SafeStr_1086;
        private var _SafeStr_9290:_SafeStr_1088;
        private var _SafeStr_7890:_SafeStr_515;
        private var time:Number;

        public function _SafeStr_771(_arg_1:ObjectPool)
        {
            super(_arg_1);
            this.dust = new _SafeStr_1086(90, 200, 60, 0.15, objectPool);
            this._SafeStr_9290 = new _SafeStr_1088(objectPool);
        }

        public function _SafeStr_1984(_arg_1:Scene3DContainer):void
        {
            this._SafeStr_9290._SafeStr_3303(_arg_1);
            this._SafeStr_9290.start();
            this.dust._SafeStr_3303(_arg_1);
            this.dust.start();
        }

        public function init(_arg_1:_SafeStr_515, _arg_2:MachineGunSFXData):void
        {
            this._SafeStr_7890 = _arg_1;
            _arg_1._SafeStr_3908(ResourceType42);
            this.dust.ResourceType33(_arg_2.ResourceType43);
            this._SafeStr_9290.setMaterial(_arg_2.ResourceType44);
            this.time = 0;
        }

        public function get owner():ClientObject
        {
            return (null);
        }

        public function play(_arg_1:int, _arg_2:_SafeStr_408):Boolean
        {
            this._SafeStr_7890.ResourceType40(ResourceType42, _arg_2, _arg_1);
            this._SafeStr_9291();
            var _local_3:Number = (_arg_1 / 1000);
            this.time = (this.time + _local_3);
            if (this.time >= 0.25){
                this.dust.stop();
                this._SafeStr_9290.stop();
            }
            var _local_4:Boolean = this.dust.update(_local_3);
            return (Boolean(((this._SafeStr_9290.update(_local_3)) || (_local_4))));
        }

        private function _SafeStr_9291():void
        {
            ResourceType45.x = ResourceType42.x;
            ResourceType45.y = ResourceType42.y;
            ResourceType45.z = ResourceType42.z;
            this.dust.ResourceType41(ResourceType45);
            this._SafeStr_9290.ResourceType41(ResourceType45);
        }

        public function destroy():void
        {
            this.dust.clear();
            this._SafeStr_9290.clear();
            this._SafeStr_7890.destroy();
            this._SafeStr_7890 = null;
        }

        public function kill():void
        {
            this.dust.stop();
            this._SafeStr_9290.stop();
        }


    }
}//package alternativa.tanks.models.weapon.machinegun.sfx

// Vector3 = "#!B" (String#23, DoABC#1292)
// _SafeStr_1086 = "2!0" (String#27, DoABC#1292)
// _SafeStr_1088 = "4k" (String#24, DoABC#1292)
// _SafeStr_136 = "%\"u" (String#51, DoABC#1292)
// _SafeStr_1984 = "![" (String#40, DoABC#1292)
// _SafeStr_3303 = "\"!n" (String#34, DoABC#1292)
// _SafeStr_3908 = "!#Z" (String#57, DoABC#1292)
// _SafeStr_396 = "#!b" (String#13, DoABC#1292)
// _SafeStr_408 = "3$5" (String#71, DoABC#1292)
// ResourceType33 = "4\"N" (String#91, DoABC#1292)
// ResourceType40 = "]2" (String#46, DoABC#1292)
// ResourceType41 = "[!C" (String#32, DoABC#1292)
// ResourceType42 = "`Y" (String#5, DoABC#1292)
// ResourceType43 = "2\"+" (String#54, DoABC#1292)
// ResourceType44 = "%!b" (String#79, DoABC#1292)
// ResourceType45 = "@\"%" (String#6, DoABC#1292)
// Scene3DContainer = ";!>" (String#82, DoABC#1292)
// _SafeStr_515 = "&!v" (String#35, DoABC#1292)
// IModelService33 = "-\"l" (String#44, DoABC#1292)
// _SafeStr_771 = "4!T" (String#16, DoABC#1292)
// _SafeStr_7890 = "[\"m" (String#14, DoABC#1292)
// _SafeStr_9286 = "=\"n" (String#74, DoABC#1292)
// _SafeStr_9287 = "3#C" (String#42, DoABC#1292)
// _SafeStr_9288 = ">#A" (String#81, DoABC#1292)
// _SafeStr_9289 = ";\"x" (String#64, DoABC#1292)
// _SafeStr_9290 = "<#H" (String#8, DoABC#1292)
// _SafeStr_9291 = "<!4" (String#37, DoABC#1292)


