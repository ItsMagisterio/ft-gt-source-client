// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//alternativa.tanks.models.weapon.machinegun.sfx._SafeStr_770

package alternativa.tanks.models.weapon.machinegun.sfx
{
    import &$!._SafeStr_396;
    import alternativa.tanks.sfx._SafeStr_136;
    import %"?.Vector3;
    import alternativa.tanks.sfx.AnimatedPlane;
    import alternativa.tanks.engine3d.AnimatedSprite3D;
    import [C.Scene3DContainer;
    import alternativa.tanks.models.weapon.machinegun.MachineGunSFXData;
    import alternativa.engine3d.core.Object3D;
    import alternativa.tanks.sfx._SafeStr_515;
    import alternativa.tanks.sfx._SafeStr_856;
    import &$!.ObjectPool;
    import 5h._SafeStr_408;
    import "!7.ClientObject;
    import alternativa.tanks.engine3d.TextureAnimation;
    import flash.display.BlendMode;

    public class _SafeStr_770 extends _SafeStr_396 implements _SafeStr_136 
    {

        private static const _SafeStr_9253:int = 150;
        private static const _SafeStr_9254:int = 200;
        private static const _SafeStr_9255:int = 50;
        private static const _SafeStr_9256:Number = 150;
        private static const _SafeStr_9257:Number = 210;
        private static const _SafeStr_9258:Number = -10;
        private static const _SafeStr_9259:Number = 130;
        private static const _SafeStr_9260:Number = 35;
        private static const _SafeStr_9261:Number = 60;
        private static const _SafeStr_5347:Number = 170;
        private static const _SafeStr_9262:Number = 300;
        private static const _SafeStr_9263:Number = 170;
        private static const _SafeStr_9264:Number = 0.3;
        private static const _SafeStr_9265:Number = 50;
        private static const _SafeStr_9266:Number = 22222;
        private static const origin:Vector3 = new Vector3();

        private const _SafeStr_9251:AnimatedPlane = new AnimatedPlane(150, 210, 0, (210 * 0.5), 0);
        private const _SafeStr_9252:AnimatedPlane = new AnimatedPlane(130, 130, 0, 0, 0);
        private const _SafeStr_7738:AnimatedSprite3D = new AnimatedSprite3D(150, 150);
        private const _SafeStr_9267:AnimatedSprite3D = new AnimatedSprite3D(200, 200);
        private const _SafeStr_9268:_SafeStr_1087 = new _SafeStr_1087();

        private var _SafeStr_9269:Vector3 = new Vector3();
        private var smoke:_SafeStr_1086;
        private var _SafeStr_7681:Vector3 = new Vector3(1, 4, 6);
        private var time:Number = 0;
        private var container:Scene3DContainer;
        private var _SafeStr_9270:MachineGunSFXData;
        private var turret:Object3D;
        private var _SafeStr_9271:_SafeStr_515;
        private var _SafeStr_3910:Boolean;
        private var _SafeStr_9272:Boolean;
        private var _SafeStr_9273:Boolean;
        private var _SafeStr_9274:Boolean;
        private var _SafeStr_9275:Boolean;
        private var _SafeStr_2727:Vector3;
        private var direction:Vector3;
        private var _SafeStr_3551:Vector3;
        private var _SafeStr_2464:Boolean;

        public function _SafeStr_770(_arg_1:ObjectPool)
        {
            super(_arg_1);
            this.smoke = new _SafeStr_1086(170, 300, 170, 0.3, objectPool);
            _SafeStr_856.ResourceType32(this._SafeStr_9251);
            _SafeStr_856.ResourceType32(this._SafeStr_9252);
        }

        public function init(_arg_1:Object3D, _arg_2:MachineGunSFXData, _arg_3:Vector3, _arg_4:Vector3):void
        {
            this._SafeStr_3551 = _arg_4;
            this._SafeStr_9270 = _arg_2;
            this.turret = _arg_1;
            this._SafeStr_2727 = _arg_3;
            this._SafeStr_9276();
            this._SafeStr_9277(_arg_2);
            this.smoke.ResourceType33(_arg_2.smokeTexture);
            this._SafeStr_9268.init(_arg_2.ResourceType34);
            this._SafeStr_9271 = _SafeStr_515(objectPool.getObject(_SafeStr_515));
            this._SafeStr_9271.init(this._SafeStr_7681, 50);
            this._SafeStr_7738._SafeStr_3712(_arg_2.ResourceType35);
            this._SafeStr_7738.looped = true;
            this._SafeStr_9267._SafeStr_3712(_arg_2.ResourceType36);
            this._SafeStr_9267.looped = true;
            this.time = 0;
            this._SafeStr_9273 = false;
            this._SafeStr_9275 = false;
        }

        public function _SafeStr_3540(_arg_1:Vector3, _arg_2:Vector3):void
        {
            this._SafeStr_2727 = _arg_1;
            this._SafeStr_3551 = _arg_2;
        }

        private function _SafeStr_9276():void
        {
            this.direction = this._SafeStr_2727.vClone();
            this.direction._SafeStr_2664(this._SafeStr_3551);
            this.direction._SafeStr_2484();
        }

        public function _SafeStr_1984(_arg_1:Scene3DContainer):void
        {
            this.container = _arg_1;
            _arg_1.addChild(this._SafeStr_9251);
            _arg_1.addChild(this._SafeStr_9252);
            _arg_1.addChild(this._SafeStr_9268);
            _arg_1.addChild(this._SafeStr_7738);
            _arg_1.addChild(this._SafeStr_9267);
            this.smoke._SafeStr_3303(_arg_1);
            this.smoke.start();
            this._SafeStr_9268.visible = true;
            this._SafeStr_9251.visible = true;
            this._SafeStr_9252.visible = true;
            this._SafeStr_9272 = true;
        }

        public function play(_arg_1:int, _arg_2:_SafeStr_408):Boolean
        {
            this._SafeStr_9276();
            var _local_3:Number = (_arg_1 / 1000);
            this._SafeStr_9279(_arg_2);
            this._SafeStr_9280(_local_3, _arg_2, _arg_1);
            this._SafeStr_9283(_local_3);
            this.time = (this.time + _local_3);
            return ((this._SafeStr_3910) || (this._SafeStr_9272));
        }

        public function _SafeStr_2213(_arg_1:Vector3, _arg_2:Boolean):void
        {
            this._SafeStr_7681.vCopy(_arg_1);
            this._SafeStr_9273 = true;
            this._SafeStr_9274 = _arg_2;
        }

        public function _SafeStr_2207(_arg_1:Boolean):void
        {
            this._SafeStr_9273 = false;
            this._SafeStr_9275 = _arg_1;
        }

        public function destroy():void
        {
            this.kill();
            this._SafeStr_9252.clear();
            this._SafeStr_9251.clear();
            this.smoke.clear();
            this._SafeStr_7738.clear();
            this._SafeStr_9267.clear();
            this.container = null;
            this._SafeStr_9270 = null;
            this.turret = null;
            this._SafeStr_9271.destroy();
            this._SafeStr_9271 = null;
        }

        public function kill():void
        {
            this.container.removeChild(this._SafeStr_9251);
            this.container.removeChild(this._SafeStr_9252);
            this.container.removeChild(this._SafeStr_9268);
            this.container.removeChild(this._SafeStr_7738);
            this.container.removeChild(this._SafeStr_9267);
            this.stop();
        }

        public function get owner():ClientObject
        {
            return (null);
        }

        public function stop():void
        {
            this.smoke.stop();
            this._SafeStr_9268.visible = false;
            this._SafeStr_9251.visible = false;
            this._SafeStr_9252.visible = false;
            this._SafeStr_7738.visible = false;
            this._SafeStr_9267.visible = false;
            this._SafeStr_9272 = false;
        }

        private function _SafeStr_9277(_arg_1:MachineGunSFXData):void
        {
            var _local_2:TextureAnimation = _arg_1.ResourceType37;
            this._SafeStr_9251.init(_local_2, _local_2.fps);
            this._SafeStr_9251.blendMode = BlendMode.ADD;
            var _local_3:TextureAnimation = _arg_1.ResourceType38;
            this._SafeStr_9252.init(_local_3, _local_3.fps);
            this._SafeStr_9252.blendMode = BlendMode.ADD;
            this._SafeStr_9278();
        }

        private function _SafeStr_9278():void
        {
            var _local_1:Number = this.direction.x;
            var _local_2:Number = this.direction.y;
            this._SafeStr_9252.rotationX = (Math.atan2(this.direction.z, Math.sqrt(((_local_1 * _local_1) + (_local_2 * _local_2)))) - (Math.PI / 2));
            this._SafeStr_9252.rotationY = 0;
            this._SafeStr_9252.rotationZ = -(Math.atan2(_local_1, _local_2));
        }

        private function _SafeStr_9279(_arg_1:_SafeStr_408):void
        {
            _SafeStr_856.ResourceType39(this._SafeStr_9251, _arg_1.pos, this.direction, false, 8, 0.9);
            _SafeStr_856.ResourceType39(this._SafeStr_9252, _arg_1.pos, this.direction, true, 4, 0.3);
            this._SafeStr_9284(this._SafeStr_2727, this.direction, -10, origin);
            _SafeStr_856._SafeStr_3911(this._SafeStr_9251, origin, this.direction, _arg_1.pos);
            this._SafeStr_9251.setTime((this.time % this._SafeStr_9251._SafeStr_3716()));
            this._SafeStr_9278();
            this._SafeStr_9285(this._SafeStr_9252, this._SafeStr_2727, this.direction, 35);
            this._SafeStr_9252.setTime((this.time % this._SafeStr_9252._SafeStr_3716()));
        }

        private function _SafeStr_9280(_arg_1:Number, _arg_2:_SafeStr_408, _arg_3:int):void
        {
            var _local_4:Number = NaN;
            if (this._SafeStr_9273){
                this._SafeStr_9269 = this._SafeStr_7681.vClone();
                this._SafeStr_9269._SafeStr_2664(this._SafeStr_2727);
                _local_4 = this._SafeStr_9269._SafeStr_2330();
                this._SafeStr_9269.normalize();
                this._SafeStr_9281(_arg_1, _arg_2, _arg_3);
            }
            else {
                _local_4 = ((!(!(this._SafeStr_9275))) ? Number(0) : Number(22222));
                this._SafeStr_9269.vCopy(this.direction);
                this._SafeStr_9282();
            }
            this._SafeStr_9284(this._SafeStr_2727, this.direction, 50, origin);
            _SafeStr_856._SafeStr_3911(this._SafeStr_9268, origin, this._SafeStr_9269, _arg_2.pos);
            this._SafeStr_9268.update(_arg_3, (_local_4 - 50));
        }

        private function _SafeStr_9281(_arg_1:Number, _arg_2:_SafeStr_408, _arg_3:int):void
        {
            this._SafeStr_9282();
            var _local_4:AnimatedSprite3D = ((!(!(this._SafeStr_9274))) ? this._SafeStr_9267 : this._SafeStr_7738);
            _local_4.visible = this._SafeStr_9272;
            _local_4.update(_arg_1);
            this._SafeStr_9271.init(this._SafeStr_7681, 50);
            this._SafeStr_9271.ResourceType40(_local_4, _arg_2, _arg_3);
        }

        private function _SafeStr_9282():void
        {
            this._SafeStr_7738.visible = false;
            this._SafeStr_9267.visible = false;
        }

        private function _SafeStr_9283(_arg_1:Number):void
        {
            this._SafeStr_9284(this._SafeStr_2727, this.direction, 60, origin);
            this.smoke.ResourceType41(origin);
            this._SafeStr_3910 = this.smoke.update(_arg_1);
        }

        private function _SafeStr_9284(_arg_1:Vector3, _arg_2:Vector3, _arg_3:Number, _arg_4:Vector3):void
        {
            _arg_4.vCopy(_arg_1).vAddScaled(_arg_3, _arg_2);
        }

        private function _SafeStr_9285(_arg_1:Object3D, _arg_2:Vector3, _arg_3:Vector3, _arg_4:Number):void
        {
            _arg_1.x = (_arg_2.x + (_arg_4 * _arg_3.x));
            _arg_1.y = (_arg_2.y + (_arg_4 * _arg_3.y));
            _arg_1.z = (_arg_2.z + (_arg_4 * _arg_3.z));
        }


    }
}//package alternativa.tanks.models.weapon.machinegun.sfx

// Vector3 = "#!B" (String#17, DoABC#1291)
// _SafeStr_1086 = "2!0" (String#40, DoABC#1291)
// _SafeStr_1087 = "6\"^" (String#55, DoABC#1291)
// _SafeStr_136 = "%\"u" (String#22, DoABC#1291)
// _SafeStr_1984 = "![" (String#147, DoABC#1291)
// _SafeStr_2207 = "`5" (String#96, DoABC#1291)
// _SafeStr_2213 = "?n" (String#209, DoABC#1291)
// _SafeStr_2330 = "?!E" (String#208, DoABC#1291)
// _SafeStr_2464 = "'N" (String#152, DoABC#1291)
// _SafeStr_2484 = "&#?" (String#151, DoABC#1291)
// _SafeStr_2664 = "?#7" (String#69, DoABC#1291)
// _SafeStr_2727 = "3\"y" (String#46, DoABC#1291)
// _SafeStr_3303 = "\"!n" (String#148, DoABC#1291)
// _SafeStr_3540 = "0#-" (String#154, DoABC#1291)
// _SafeStr_3551 = "?#a" (String#70, DoABC#1291)
// _SafeStr_3712 = "]!4" (String#88, DoABC#1291)
// _SafeStr_3716 = "7\"t" (String#57, DoABC#1291)
// _SafeStr_3910 = "2!o" (String#41, DoABC#1291)
// _SafeStr_3911 = ",#E" (String#31, DoABC#1291)
// _SafeStr_396 = "#!b" (String#18, DoABC#1291)
// _SafeStr_408 = "3$5" (String#48, DoABC#1291)
// ResourceType32 = "%#Z" (String#23, DoABC#1291)
// ResourceType33 = "4\"N" (String#189, DoABC#1291)
// ResourceType34 = "?6" (String#71, DoABC#1291)
// ResourceType35 = ",#S" (String#153, DoABC#1291)
// ResourceType36 = ";#`" (String#206, DoABC#1291)
// ResourceType37 = "^!6" (String#216, DoABC#1291)
// ResourceType38 = "%!0" (String#149, DoABC#1291)
// ResourceType39 = "##$" (String#19, DoABC#1291)
// ResourceType40 = "]2" (String#90, DoABC#1291)
// ResourceType41 = "[!C" (String#85, DoABC#1291)
// Scene3DContainer = ";!>" (String#63, DoABC#1291)
// TextureAnimation = "6#E" (String#56, DoABC#1291)
// _SafeStr_515 = "&!v" (String#24, DoABC#1291)
// _SafeStr_5347 = "@X" (String#211, DoABC#1291)
// _SafeStr_7681 = "^#z" (String#93, DoABC#1291)
// _SafeStr_770 = "5!;" (String#52, DoABC#1291)
// _SafeStr_7738 = "=!c" (String#67, DoABC#1291)
// _SafeStr_856 = "@\"@" (String#72, DoABC#1291)
// _SafeStr_9251 = "8\"m" (String#59, DoABC#1291)
// _SafeStr_9252 = "&\"6" (String#25, DoABC#1291)
// _SafeStr_9253 = "1\"^" (String#155, DoABC#1291)
// _SafeStr_9254 = "8#;" (String#201, DoABC#1291)
// _SafeStr_9255 = "9\"%" (String#203, DoABC#1291)
// _SafeStr_9256 = " #a" (String#145, DoABC#1291)
// _SafeStr_9257 = "[#U" (String#214, DoABC#1291)
// _SafeStr_9258 = "`$7" (String#217, DoABC#1291)
// _SafeStr_9259 = "-!`" (String#32, DoABC#1291)
// _SafeStr_9260 = "[n" (String#87, DoABC#1291)
// _SafeStr_9261 = "?!#" (String#207, DoABC#1291)
// _SafeStr_9262 = "8\"?" (String#200, DoABC#1291)
// _SafeStr_9263 = "]\"x" (String#215, DoABC#1291)
// _SafeStr_9264 = "%#k" (String#150, DoABC#1291)
// _SafeStr_9265 = "@#b" (String#210, DoABC#1291)
// _SafeStr_9266 = "!!N" (String#146, DoABC#1291)
// _SafeStr_9267 = "1D" (String#39, DoABC#1291)
// _SafeStr_9268 = "&#o" (String#26, DoABC#1291)
// _SafeStr_9269 = ">#Z" (String#68, DoABC#1291)
// _SafeStr_9270 = ";\"I" (String#65, DoABC#1291)
// _SafeStr_9271 = "9!a" (String#61, DoABC#1291)
// _SafeStr_9272 = "]#O" (String#89, DoABC#1291)
// _SafeStr_9273 = "2#V" (String#42, DoABC#1291)
// _SafeStr_9274 = "-B" (String#33, DoABC#1291)
// _SafeStr_9275 = "9\"S" (String#62, DoABC#1291)
// _SafeStr_9276 = " F" (String#15, DoABC#1291)
// _SafeStr_9277 = "<k" (String#66, DoABC#1291)
// _SafeStr_9278 = "5x" (String#54, DoABC#1291)
// _SafeStr_9279 = "3#G" (String#47, DoABC#1291)
// _SafeStr_9280 = ",!" (String#30, DoABC#1291)
// _SafeStr_9281 = "%\"Q" (String#21, DoABC#1291)
// _SafeStr_9282 = "+\"1" (String#29, DoABC#1291)
// _SafeStr_9283 = ";!c" (String#64, DoABC#1291)
// _SafeStr_9284 = "^!'" (String#92, DoABC#1291)
// _SafeStr_9285 = "]G" (String#91, DoABC#1291)


