// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//alternativa.tanks.models.weapon.machinegun.MachineGunEffects

package alternativa.tanks.models.weapon.machinegun
{
	import alternativa.init.Main;
	import alternativa.math.Vector3;
	import alternativa.object.ClientObject;
	import alternativa.osgi.service.log.LogLevel;
	import alternativa.service.Logger;
	import alternativa.tanks.models.weapon.common.WeaponCommonData;
    import alternativa.tanks.services.objectpool.IObjectPoolService;
    import alternativa.tanks.models.battlefield.IBattleField;
	import alternativa.tanks.sound.ISoundManager;
    import flash.utils.Dictionary;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.tanks.models.sfx.OmniStreamLightEffect;
    import !#r._SafeStr_774;
    import alternativa.tanks.models.weapon.machinegun.sfx._SafeStr_770;
    import alternativa.tanks.models.tank.TankData;
    import alternativa.tanks.vehicles.tanks.TankSkin;
    import alternativa.tanks.sfx._SafeStr_136;
    import alternativa.tanks.sfx._SafeStr_515;
    import alternativa.tanks.models.weapon.machinegun.sfx._SafeStr_771;
    import alternativa.tanks.models.sfx.MuzzlePositionProvider;
    import alternativa.tanks.models.sfx.CollisionObject3DPositionProvider;
    import alternativa.tanks.models.sfx.LightDataManager;
    import alternativa.engine3d.core.Object3D;
    import 3#x.IModelService;

    public class MachineGunEffects 
    {

        private static const _SafeStr_9299:Number = 0.1;
        private static const _SafeStr_9300:Number = 50;
        private static const _SafeStr_9301:Number = 0.001;
        private static const _SafeStr_9302:Number = 15;
        private static const _SafeStr_9303:Number = 0.59;
        private static const _SafeStr_9304:Number = 0.1;
        private static const POW:Number = 3;
        private static var _SafeStr_2543:IObjectPoolService;

        private var battlefield:IBattleField;
        private var _SafeStr_2429:_SafeStr_114;
        private var _SafeStr_1955:Dictionary;
        private var bfModel:BattlefieldModel;
        private var _SafeStr_2678:OmniStreamLightEffect;
        private var _SafeStr_2677:OmniStreamLightEffect;
        private var _SafeStr_9305:Number;
        private var _SafeStr_3543:_SafeStr_774;
        private var _SafeStr_3544:_SafeStr_774;
        private var _SafeStr_3541:_SafeStr_774;
        private var _SafeStr_3542:_SafeStr_774;
        private var _SafeStr_9306:Number = 0;
        private var _SafeStr_9307:_SafeStr_770;
        private var tankData:TankData;
        private var _SafeStr_9308:WeaponCommonData;
        private var _SafeStr_9309:Vector3;
        private var _SafeStr_3551:Vector3;
        private var sfxData:MachineGunSFXData;
        private var _SafeStr_9274:Boolean;
        private var _SafeStr_9273:Boolean;
        private var _SafeStr_7681:Vector3 = new Vector3();
        private var soundManager:ISoundManager;
        private var _SafeStr_9310:Boolean;
        private var state:Number;
        private var _SafeStr_5481:_SafeStr_494;

        public function MachineGunEffects(_arg_1:_SafeStr_494)
        {
            this._SafeStr_5481 = _arg_1;
            this._SafeStr_1955 = new Dictionary();
            this.bfModel = (Main.osgi.getService(IBattleField) as BattlefieldModel);
            super();
            this._SafeStr_9305 = 0;
            _SafeStr_2543 = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
            this._SafeStr_5935();
        }

        public function _SafeStr_2213(_arg_1:Vector3, _arg_2:Boolean):void
        {
            this._SafeStr_9273 = true;
            this._SafeStr_9274 = _arg_2;
            this._SafeStr_7681.vCopy(_arg_1);
            if (this.soundManager != null){
                this.soundManager._SafeStr_3538(_arg_1, _arg_2);
            }
            if (this._SafeStr_9307 != null){
                this._SafeStr_9307._SafeStr_2213(_arg_1, _arg_2);
            }
        }

        public function _SafeStr_2207(_arg_1:Boolean):void
        {
            this._SafeStr_9273 = false;
            if (this.soundManager != null){
                this.soundManager._SafeStr_3539();
            }
            if (this._SafeStr_9307 != null){
                this._SafeStr_9307._SafeStr_2207(_arg_1);
            }
        }

        public function update(_arg_1:int, _arg_2:Number, _arg_3:Boolean, _arg_4:TankData, _arg_5:WeaponCommonData, _arg_6:TankSkin, _arg_7:Vector3, _arg_8:Vector3, _arg_9:Number, _arg_10:Number):void
        {
            var _local_13:String;
            if (this._SafeStr_9307 != null){
                this._SafeStr_9307._SafeStr_3540(_arg_7, _arg_8);
            }
            this.state = _arg_2;
            this.sfxData = this._SafeStr_5481._SafeStr_2732(_arg_4.turret);
            if (this.soundManager == null){
                this.soundManager = new ISoundManager(_arg_6._SafeStr_1614, this.sfxData, _arg_9);
            }
            this.playSound(_arg_2, _arg_3, _arg_9, _arg_10);
            this._SafeStr_3541 = _arg_6._SafeStr_2397._SafeStr_3541;
            this._SafeStr_3542 = _arg_6._SafeStr_2397._SafeStr_3542;
            this._SafeStr_3543 = _arg_6._SafeStr_2397._SafeStr_3543;
            this._SafeStr_3544 = _arg_6._SafeStr_2397._SafeStr_3544;
            this.tankData = _arg_4;
            this._SafeStr_9308 = _arg_5;
            this._SafeStr_9309 = _arg_7;
            this._SafeStr_3551 = _arg_8;
            var _local_11:Boolean = (_arg_2 == 1);
            var _local_12:Number = (_arg_1 / 1000);
            this._SafeStr_9305 = (this._SafeStr_9305 + _local_12);
            if (_local_11){
                this._SafeStr_9312(_local_12);
            }
            else {
                this._SafeStr_2197(this.tankData);
            }
            this._SafeStr_9315(_local_12, _arg_2);
        }

        private function playSound(_arg_1:Number, _arg_2:Boolean, _arg_3:Number, _arg_4:Number):void
        {
            if (_arg_2){
                if (_arg_1 == 1){
                    this.soundManager._SafeStr_3545();
                    this._SafeStr_9310 = true;
                }
                else {
                    this.soundManager._SafeStr_3546((_arg_3 * _arg_1));
                }
            }
            else {
                if (_arg_1 == 0){
                    this._SafeStr_9310 = false;
                    this.soundManager._SafeStr_3355();
                }
                else {
                    if (this._SafeStr_9310){
                        this.soundManager._SafeStr_3547();
                    }
                    else {
                        this.soundManager._SafeStr_3548((_arg_1 * _arg_4));
                    }
                }
            }
        }

        public function _SafeStr_2197(_arg_1:TankData):void
        {
            this._SafeStr_2207(false);
            this._SafeStr_9311();
            this._SafeStr_9306 = 0;
            if (((!(this.soundManager == null)) && (this.state >= 1))){
                this.soundManager._SafeStr_3355();
            }
            var _local_2:_SafeStr_136 = this._SafeStr_1955[_arg_1];
            if (_local_2 != null){
                delete this._SafeStr_1955[_arg_1];
                _local_2.kill();
                if (this._SafeStr_2678 != null){
                    this._SafeStr_2678.stop();
                    this._SafeStr_2678 = null;
                }
                if (this._SafeStr_2677 != null){
                    this._SafeStr_2677.stop();
                    this._SafeStr_2677 = null;
                }
            }
        }

        private function _SafeStr_9311():void
        {
            if (this._SafeStr_9307 != null){
                this._SafeStr_9307.stop();
                this._SafeStr_9307 = null;
            }
        }

        private function _SafeStr_9312(_arg_1:Number):void
        {
            this._SafeStr_9314();
            if (((this._SafeStr_9273) && (this._SafeStr_9305 >= 0.1))){
                this._SafeStr_9305 = 0;
                this._SafeStr_9313();
            }
            this._SafeStr_9306 = (this._SafeStr_9306 + _arg_1);
            var _local_2:Number = (this._SafeStr_9306 % 0.1);
            var _local_3:int = int((this._SafeStr_9306 / 0.1));
            var _local_4:Number = ((_local_3 * 0.59) + (0.59 * this.ease((_local_2 / 0.1), 3)));
            this._SafeStr_3543.reset();
            this._SafeStr_3544.reset();
            this._SafeStr_3543.rotate((_local_4 % 0.59));
            this._SafeStr_3544.rotate((-(_local_4) * 0.7));
        }

        private function ease(_arg_1:Number, _arg_2:Number):Number
        {
            if (_arg_1 < 0.5){
                _arg_1 = (_arg_1 * 2);
                _arg_1 = Math.pow(_arg_1, _arg_2);
                return (_arg_1 / 2);
            }
            _arg_1 = (1 - ((_arg_1 - 0.5) * 2));
            _arg_1 = Math.pow(_arg_1, _arg_2);
            return (((1 - _arg_1) / 2) + 0.5);
        }

        private function _SafeStr_9313():void
        {
            var _local_1:_SafeStr_515;
            var _local_2:_SafeStr_771;
            if ((!(this._SafeStr_9274))){
                _local_1 = _SafeStr_515(_SafeStr_2543.objectPool.getObject(_SafeStr_515));
                _local_1.init(this._SafeStr_7681, 50);
                _local_2 = _SafeStr_771(_SafeStr_2543.objectPool.getObject(_SafeStr_771));
                _local_2.init(_local_1, this.sfxData);
                this.battlefield._SafeStr_1643(_local_2);
            }
        }

        private function _SafeStr_9314():void
        {
            if (this._SafeStr_9307 == null){
                this._SafeStr_9307 = _SafeStr_770(_SafeStr_2543.objectPool.getObject(_SafeStr_770));
                this._SafeStr_9307.init(this.tankData.tank.skin._SafeStr_1614, this.sfxData, this._SafeStr_9309, this._SafeStr_3551);
                this.battlefield._SafeStr_1643(this._SafeStr_9307);
                this._SafeStr_1955[this.tankData] = this._SafeStr_9307;
                this._SafeStr_2641(this._SafeStr_9308.muzzles[0], this.tankData.tank.skin._SafeStr_1614, this.tankData.turret);
            }
        }

        private function _SafeStr_9315(_arg_1:Number, _arg_2:Number):void
        {
            var _local_3:Number = (15 * _arg_2);
            if (_local_3 > 0.001){
                this._SafeStr_3541.rotate((_local_3 * _arg_1));
                this._SafeStr_3542.rotate((_local_3 * _arg_1));
            }
        }

        public function _SafeStr_2641(_arg_1:Vector3, _arg_2:Object3D, _arg_3:ClientObject):void
        {
            var _local_4:MuzzlePositionProvider;
            var _local_5:CollisionObject3DPositionProvider;
            if (this._SafeStr_2678 == null){
                this._SafeStr_2678 = OmniStreamLightEffect(_SafeStr_2543.objectPool.getObject(OmniStreamLightEffect));
                _local_4 = MuzzlePositionProvider(_SafeStr_2543.objectPool.getObject(MuzzlePositionProvider));
                _local_4.init(_arg_2, _arg_1);
                this._SafeStr_2678.init(_local_4, LightDataManager._SafeStr_2642(_arg_3.id), LightDataManager._SafeStr_2643(_arg_3.id));
                this.bfModel._SafeStr_1643(this._SafeStr_2678);
            }
            if (this._SafeStr_2677 == null){
                this._SafeStr_2677 = OmniStreamLightEffect(_SafeStr_2543.objectPool.getObject(OmniStreamLightEffect));
                _local_5 = CollisionObject3DPositionProvider(_SafeStr_2543.objectPool.getObject(CollisionObject3DPositionProvider));
                _local_5.init(_arg_2, _arg_1, this.bfModel.bfData._SafeStr_1669, 1500);
                this._SafeStr_2677.init(_local_5, LightDataManager._SafeStr_2642(_arg_3.id), LightDataManager._SafeStr_2643(_arg_3.id));
                this.bfModel._SafeStr_1643(this._SafeStr_2677);
            }
        }

        private function _SafeStr_5935():void
        {
            var _local_1:IModelService;
            if (this.battlefield == null){
                _local_1 = IModelService(Main.osgi.getService(IModelService));
                this.battlefield = IBattleField(_local_1.getModelsByInterface(IBattleField)[0]);
                this._SafeStr_2429 = _SafeStr_114(_local_1.getModelsByInterface(_SafeStr_114)[0]);
            }
        }


    }
}//package alternativa.tanks.models.weapon.machinegun

// Vector3 = "#!B" (String#24, DoABC#704)
// _SafeStr_114 = "5#n" (String#60, DoABC#704)
// _SafeStr_136 = "%\"u" (String#146, DoABC#704)
// getService = "\"#1" (String#23, DoABC#704)
// _SafeStr_1580 = "[\"p" (String#199, DoABC#704)
// _SafeStr_1614 = "4$%" (String#56, DoABC#704)
// _SafeStr_1643 = "5!R" (String#58, DoABC#704)
// _SafeStr_1669 = "0\"!" (String#150, DoABC#704)
// _SafeStr_1955 = "&O" (String#32, DoABC#704)
// _SafeStr_2197 = "[i" (String#96, DoABC#704)
// Logger = "?\"6" (String#77, DoABC#704)
// _SafeStr_2207 = "`5" (String#101, DoABC#704)
// _SafeStr_2213 = "?n" (String#79, DoABC#704)
// _SafeStr_2397 = "1!1" (String#42, DoABC#704)
// _SafeStr_2429 = "9$ " (String#71, DoABC#704)
// _SafeStr_2543 = "8\"D" (String#66, DoABC#704)
// _SafeStr_2641 = "0\"F" (String#39, DoABC#704)
// _SafeStr_2642 = "@v" (String#81, DoABC#704)
// _SafeStr_2643 = "`#j" (String#100, DoABC#704)
// _SafeStr_2677 = "=#_" (String#75, DoABC#704)
// _SafeStr_2678 = "0#g" (String#41, DoABC#704)
// _SafeStr_2732 = "\"\"Z" (String#128, DoABC#704)
// _SafeStr_3355 = "=!G" (String#74, DoABC#704)
// _SafeStr_3538 = ",B" (String#147, DoABC#704)
// _SafeStr_3539 = "5\"r" (String#188, DoABC#704)
// _SafeStr_3540 = "0#-" (String#151, DoABC#704)
// _SafeStr_3541 = "6!P" (String#62, DoABC#704)
// _SafeStr_3542 = "#!T" (String#26, DoABC#704)
// _SafeStr_3543 = "8\"M" (String#67, DoABC#704)
// _SafeStr_3544 = "[$-" (String#95, DoABC#704)
// _SafeStr_3545 = "-\"B" (String#149, DoABC#704)
// _SafeStr_3546 = "^\"1" (String#202, DoABC#704)
// _SafeStr_3547 = "\"\"X" (String#22, DoABC#704)
// _SafeStr_3548 = "]!#" (String#200, DoABC#704)
// _SafeStr_3551 = "?#a" (String#78, DoABC#704)
// IBattleField = "9#R" (String#69, DoABC#704)
// IObjectPoolService = "1\"g" (String#43, DoABC#704)
// WeaponCommonData = "5#w" (String#61, DoABC#704)
// _SafeStr_494 = "@#3" (String#80, DoABC#704)
// _SafeStr_515 = "&!v" (String#31, DoABC#704)
// _SafeStr_5481 = "0#[" (String#40, DoABC#704)
// IModelService = ",!'" (String#34, DoABC#704)
// _SafeStr_5935 = "9\"?" (String#68, DoABC#704)
// OmniStreamLightEffect = "1#;" (String#44, DoABC#704)
// MuzzlePositionProvider = ",\"Y" (String#35, DoABC#704)
// CollisionObject3DPositionProvider = "<!X" (String#73, DoABC#704)
// _SafeStr_7681 = "^#z" (String#98, DoABC#704)
// _SafeStr_770 = "5!;" (String#57, DoABC#704)
// _SafeStr_771 = "4!T" (String#55, DoABC#704)
// ISoundManager = "6'" (String#64, DoABC#704)
// _SafeStr_774 = "9#h" (String#70, DoABC#704)
// _SafeStr_9273 = "2#V" (String#47, DoABC#704)
// _SafeStr_9274 = "-B" (String#37, DoABC#704)
// _SafeStr_9299 = "-!A" (String#148, DoABC#704)
// _SafeStr_9300 = "`1" (String#204, DoABC#704)
// _SafeStr_9301 = ";O" (String#195, DoABC#704)
// _SafeStr_9302 = "4#W" (String#185, DoABC#704)
// _SafeStr_9303 = "]>" (String#201, DoABC#704)
// _SafeStr_9304 = "35" (String#183, DoABC#704)
// _SafeStr_9305 = "%\"&" (String#27, DoABC#704)
// _SafeStr_9306 = "-\"g" (String#36, DoABC#704)
// _SafeStr_9307 = "%#v" (String#29, DoABC#704)
// _SafeStr_9308 = "#!E" (String#25, DoABC#704)
// _SafeStr_9309 = "0!," (String#38, DoABC#704)
// _SafeStr_9310 = ">\"L" (String#76, DoABC#704)
// _SafeStr_9311 = "]!M" (String#97, DoABC#704)
// _SafeStr_9312 = "%z" (String#30, DoABC#704)
// _SafeStr_9313 = "7!h" (String#65, DoABC#704)
// _SafeStr_9314 = "!\"o" (String#20, DoABC#704)
// _SafeStr_9315 = "6!Z" (String#63, DoABC#704)


