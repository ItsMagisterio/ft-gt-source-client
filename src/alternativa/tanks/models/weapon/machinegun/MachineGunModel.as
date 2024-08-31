// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

//alternativa.tanks.models.weapon.machinegun.MachineGunModel

package alternativa.tanks.models.weapon.machinegun
{
	import alternativa.init.Main;
	import alternativa.object.ClientObject;
	import alternativa.service.IModelService;
	import alternativa.tanks.models.battlefield.IBattleField;
	import alternativa.tanks.models.weapon.IWeaponController;
	import alternativa.tanks.models.weapon.common.HitInfo;
	import alternativa.tanks.models.weapon.common.WeaponCommonData;
	import alternativa.tanks.models.weapon.shared.shot.ShotData;
	import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
	import com.reygazu.anticheat.variables.SecureInt;
	import com.reygazu.anticheat.variables.SecureNumber;
	import logic.Base;
	import logic.tanks.WeaponsManager;
    import [#B._SafeStr_112;
    import [#B._SafeStr_113;
	import alternativa.math.Vector3;
	import alternativa.register.ObjectRegister;
    import alternativa.tanks.models.weapon._SafeStr_115;
    import alternativa.model._SafeStr_16;
    import 3#x.IModelService;
    import alternativa.tanks.models.battlefield.IBattleField;
    import alternativa.tanks.models.tank.TankModel;
    import ;K._SafeStr_241;
    import alternativa.tanks.models.tank.TankData;
    import ;K.WeaponCommonData;
    import alternativa.tanks.models.weapon.shared.CommonTargetSystem;
    import alternativa.tanks.models.weapon.shared.ICommonTargetEvaluator;
    import alternativa.tanks.models.weapon.WeaponUtils;
    import flash.utils.Dictionary;
    import alternativa.physics.Body;
    import alternativa.model._SafeStr_12;
    import alternativa.tanks.models.tank._SafeStr_11;
    import flash.utils.getTimer;
    import alternativa.tanks.models.weapon.shared._SafeStr_465;
    import logic.networking.Network;
    import logic.networking._SafeStr_28;

    public class MachineGunModel extends Base implements _SafeStr_113,  IWeaponController, _SafeStr_114
    {

        private var modelService:IModelService;
        private var _SafeStr_1538:IBattleField;
        private var _SafeStr_1547:TankModel;
        private var _SafeStr_5924:_SafeStr_241;
        private var _SafeStr_5925:IBattleField;
        private var _SafeStr_1596:TankData;
        private var _SafeStr_9316:_SafeStr_462;
        private var _SafeStr_5264:WeaponCommonData;
        private var active:Boolean = false;
        private var _SafeStr_9317:Boolean = false;
        private var _SafeStr_9318:CommonTargetSystem;
        private var _SafeStr_3919:ICommonTargetEvaluator;
        private var _SafeStr_5262:ShotData;
        private var _SafeStr_6040:Number = 0;
        private var _SafeStr_9319:Number;
        private var _SafeStr_9320:Number;
        private var _SafeStr_9321:Number;
        private var _SafeStr_9322:Number;
        private var _SafeStr_9323:MachineGunEffects;

        private var _SafeStr_9325:SecureInt = new SecureInt("nextTargetDamageTime machineGun");
        private var currentEnergy:SecureNumber = new SecureNumber("currentEnergy machineGun");
        private var nextTargetCheckTime:SecureInt = new SecureInt("nextTargetCheckTime.value machineGun");
        private var lastUpdateTime:SecureInt = new SecureInt("lastUpdateTime.value machineGun");
        private var _SafeStr_5265:WeaponUtils = WeaponUtils.getInstance();
        private var shooters:Dictionary = new Dictionary();
        private var _SafeStr_3729:Vector3 = new Vector3();
        private var _SafeStr_3684:Vector3 = new Vector3();
        private var _SafeStr_5269:Vector3 = new Vector3();
        private var _SafeStr_5270:Vector3 = new Vector3();
        private var hitInfo:HitInfo = new HitInfo();
        private var _SafeStr_9324:Body = null;
        private var _SafeStr_5496:Number = 100000;

        public function MachineGunModel()
        {
            _SafeStr_1589.push(_SafeStr_12, _SafeStr_115, _SafeStr_114, _SafeStr_16);
        }

        public function initObject(_arg_1:ClientObject, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:Number, _arg_8:Number, _arg_9:Number, _arg_10:Number, _arg_11:Number):void
        {
            var _local_12:_SafeStr_462 = new _SafeStr_462(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            _arg_1.putParams(MachineGunModel, _local_12);
            this._SafeStr_9319 = (1 / _arg_7);
            this._SafeStr_9320 = (1 / _arg_8);
        }

        public function objectLoaded(_arg_1:ClientObject):void
        {
            if (this.modelService != null){
                return;
            }
            this.modelService = IModelService(Main.osgi.getService(IModelService));
            this._SafeStr_1538 = (Main.osgi.getService(IBattleField) as IBattleField);
            this._SafeStr_1547 = (Main.osgi.getService(_SafeStr_11) as TankModel);
            this._SafeStr_5924 = (Main.osgi.getService(_SafeStr_241) as _SafeStr_241);
            this._SafeStr_5925 = IBattleField(this.modelService.getModelsByInterface(IBattleField)[0]);
        }

        public function objectUnloaded(_arg_1:ClientObject):void
        {
        }

        public function _SafeStr_2199(_arg_1:ClientObject):_SafeStr_462
        {
            return (_SafeStr_462(_arg_1._SafeStr_1612(MachineGunModel)));
        }

        public function _SafeStr_2206(_arg_1:TankData):void
        {
            if (_arg_1 == this._SafeStr_1596){
                this._SafeStr_9323._SafeStr_2197(_arg_1);
                return;
            }
            var _local_2:ShooterData = this.shooters[_arg_1];
            if (_local_2 != null){
                _local_2.active = false;
                _local_2.machineGunEffects._SafeStr_2197(_arg_1);
            }
        }

        public function reset():void
        {
            this.currentEnergy.value = this._SafeStr_9316.energyCapacity;
            this.lastUpdateTime.value = getTimer();
            if (this._SafeStr_1596 != null){
                this._SafeStr_1596.tank._SafeStr_2198(0);
                if (this._SafeStr_6040 > 0){
                    this._SafeStr_1596.tank.maxTurretTurnSpeed = this._SafeStr_9321;
                    this._SafeStr_1596.tank._SafeStr_1607 = this._SafeStr_9322;
                }
                this._SafeStr_9321 = this._SafeStr_1596.tank.maxTurretTurnSpeed;
                this._SafeStr_9322 = this._SafeStr_1596.tank._SafeStr_1607;
            }
            this._SafeStr_6040 = 0;
        }

        public function _SafeStr_1597(_arg_1:TankData):void
        {
            this._SafeStr_1596 = _arg_1;
            this._SafeStr_9316 = this._SafeStr_2199(_arg_1.turret);
            this._SafeStr_5264 = this._SafeStr_5924._SafeStr_2624(_arg_1.turret);
            this.currentEnergy.value = this._SafeStr_9316.energyCapacity;
            this.lastUpdateTime.value = 0;
            this._SafeStr_5262 = WeaponsManager._SafeStr_2200[_arg_1.turret.id];
            if (this._SafeStr_9323 == null){
                this._SafeStr_9323 = new MachineGunEffects(WeaponsManager._SafeStr_2201(_arg_1.turret));
            }
            this._SafeStr_3919 = _SafeStr_465.create(this._SafeStr_1596, this._SafeStr_5262, this._SafeStr_1538, this._SafeStr_5925, this.modelService);
            this._SafeStr_9318 = new CommonTargetSystem(this._SafeStr_5496, this._SafeStr_5262._SafeStr_2202.value, this._SafeStr_5262._SafeStr_2203.value, this._SafeStr_5262._SafeStr_2204.value, this._SafeStr_5262._SafeStr_2205.value, this._SafeStr_1538._SafeStr_1591()._SafeStr_1669, this._SafeStr_3919);
            this.reset();
        }

        public function _SafeStr_5278():void
        {
            this._SafeStr_1596 = null;
            this._SafeStr_9316 = null;
            this._SafeStr_5264 = null;
            this._SafeStr_9318 = null;
            this._SafeStr_3919 = null;
            this._SafeStr_5262 = null;
            this._SafeStr_9323 = null;
        }

        public function _SafeStr_5277(_arg_1:int):void
        {
            this.active = true;
            this.nextTargetCheckTime.value = (_arg_1 + this._SafeStr_9316.weaponTickMsec.value);
            this._SafeStr_9325.value = (_arg_1 + this._SafeStr_9316.damageTickMsec.value);
            this.lastUpdateTime.value = _arg_1;
            this._SafeStr_5279(this._SafeStr_1596.turret);
        }

        public function _SafeStr_2469(_arg_1:ClientObject, _arg_2:String):void
        {
            var _local_3:TankData = this._SafeStr_5934(_arg_1.register, _arg_2);
            if ((((!(_local_3 == null)) && (_local_3.enabled)) && (!(_local_3 == this._SafeStr_1547.localUserData)))){
                this._SafeStr_2206(_local_3);
            }
        }

        public function _SafeStr_2468(_arg_1:ClientObject, _arg_2:String):void
        {
            var _local_4:ShooterData;
            var _local_3:TankData = this._SafeStr_5934(_arg_1.register, _arg_2);
            if (((_local_3 == null) || (_local_3 == this._SafeStr_1547.localUserData))){
                return;
            }
            _local_4 = this.shooters[_local_3];
            if (_local_4 != null){
                _local_4.active = true;
                return;
            }
            var _local_5:MachineGunEffects = new MachineGunEffects(WeaponsManager._SafeStr_2201(_local_3.turret));
            _local_5._SafeStr_2207(false);
            _local_4 = new ShooterData(_local_3, _local_5, true);
            if (this._SafeStr_5262 == null){
                this._SafeStr_5262 = WeaponsManager._SafeStr_2200[_local_3.turret.id];
            }
            var _local_6:ICommonTargetEvaluator = _SafeStr_465.create(_local_3, this._SafeStr_5262, this._SafeStr_1538, this._SafeStr_5925, this.modelService);
            if (_local_4.targetSystem == null){
                _local_4.targetSystem = new CommonTargetSystem(this._SafeStr_5496, this._SafeStr_5262._SafeStr_2202.value, this._SafeStr_5262._SafeStr_2203.value, this._SafeStr_5262._SafeStr_2204.value, this._SafeStr_5262._SafeStr_2205.value, this._SafeStr_1538._SafeStr_1591()._SafeStr_1669, _local_6);
            }
            this.shooters[_local_3] = _local_4;
        }

        private function _SafeStr_5279(_arg_1:ClientObject):void
        {
            var _local_2:Object = new Object();
            _local_2.energy = Math.floor(this.currentEnergy.value);
            Network(Main.osgi.getService(_SafeStr_28)).send(("battle;start_fire;" + JSON.stringify(_local_2)));
        }

        public function _SafeStr_2638(_arg_1:int, _arg_2:Boolean):void
        {
            this.active = false;
            this.lastUpdateTime.value = _arg_1;
            if (_arg_2){
                this._SafeStr_5932(this._SafeStr_1596.turret);
            }
            this._SafeStr_2206(this._SafeStr_1596);
        }

        private function _SafeStr_5932(_arg_1:ClientObject):void
        {
            Network(Main.osgi.getService(_SafeStr_28)).send("battle;stop_fire");
        }

        public function update(_arg_1:int, _arg_2:int):Number
        {
            var _local_4:Object;
            var _local_5:ShooterData;
            var _local_6:TankData;
            var _local_7:MachineGunEffects;
            var _local_8:Boolean;
            this._SafeStr_5265._SafeStr_2208(this._SafeStr_1596.tank.skin._SafeStr_1614, this._SafeStr_5264.muzzles[0], this._SafeStr_5269, this._SafeStr_3729, this._SafeStr_3684, this._SafeStr_5270);
            var _local_3:Number = NaN;
            if (this.active){
                if (((this._SafeStr_6040 >= 1) && (this.currentEnergy.value > 0))){
                    this.currentEnergy.value = (this.currentEnergy.value - ((this._SafeStr_9316.energyDischargeSpeed * (_arg_1 - this.lastUpdateTime.value)) * 0.001));
                    this._SafeStr_9317 = true;
                }
                if (this.currentEnergy.value <= 0){
                    this.currentEnergy.value = 0;
                    if (this._SafeStr_9317){
                        Network(Main.osgi.getService(_SafeStr_28)).send("battle;start_heat_effect");
                        this._SafeStr_9317 = false;
                    }
                }
            }
            else {
                _local_3 = this._SafeStr_9316.energyCapacity;
                if (this.currentEnergy.value < _local_3){
                    this.currentEnergy.value = (this.currentEnergy.value + ((this._SafeStr_9316.energyRechargeSpeed * (_arg_1 - this.lastUpdateTime.value)) * 0.001));
                    if (this.currentEnergy.value > _local_3){
                        this.currentEnergy.value = _local_3;
                    }
                }
            }
            this.lastUpdateTime.value = _arg_1;
            this._SafeStr_2209(_arg_2, _arg_1, this.active, this._SafeStr_1596, this._SafeStr_9323, this._SafeStr_6040, this.hitInfo, this._SafeStr_9318, this._SafeStr_9321, this._SafeStr_9322);
            this._SafeStr_6864(_arg_2, this.active);
            for (_local_4 in this.shooters) {
                _local_5 = this.shooters[_local_4];
                if (((!(_local_5.active)) && (_local_5.state <= 0))){
                    _local_5.machineGunEffects._SafeStr_2197(_local_5.tankData);
                    delete this.shooters[_local_4];
                }
                else {
                    _local_6 = _local_5.tankData;
                    _local_7 = _local_5.machineGunEffects;
                    _local_8 = _local_5.active;
                    this._SafeStr_6864(_arg_2, _local_8, _local_5);
                    this._SafeStr_2209(_arg_2, _arg_1, _local_8, _local_6, _local_7, _local_5.state, _local_5.hitInfo, _local_5.targetSystem, _local_5.maxTurretTurnSpeed, _local_5.maxTurretAcceleration);
                }
            }
            if (_arg_1 >= this.nextTargetCheckTime.value){
                this.nextTargetCheckTime.value = (this.nextTargetCheckTime.value + this._SafeStr_9316.weaponTickMsec.value);
            }
            return (this.currentEnergy.value / this._SafeStr_9316.energyCapacity);
        }

        public function _SafeStr_1638(_arg_1:TankData, _arg_2:int, _arg_3:int):void
        {
            var _local_4:ShooterData = this.shooters[_arg_1];
            if (_local_4 == null){
                return;
            }
            if (((!(_local_4.active)) && (_local_4.state <= 0))){
                _local_4.machineGunEffects._SafeStr_2197(_arg_1);
                delete this.shooters[_arg_1];
                return;
            }
            var _local_5:MachineGunEffects = _local_4.machineGunEffects;
            var _local_6:Boolean = _local_4.active;
            this._SafeStr_6864(_arg_3, _local_6, _local_4);
            this._SafeStr_2209(_arg_3, _arg_2, _local_6, _arg_1, _local_5, _local_4.state, _local_4.hitInfo, _local_4.targetSystem, _local_4.maxTurretTurnSpeed, _local_4.maxTurretAcceleration);
        }

        private function _SafeStr_5401(_arg_1:String, _arg_2:Number):void
        {
            var _local_3:Object = new Object();
            _local_3.victimId = _arg_1;
            _local_3.distance = _arg_2;
            _local_3.tickPeriod = this._SafeStr_9316.damageTickMsec.value;
            Network(Main.osgi.getService(_SafeStr_28)).send(("battle;fire;" + JSON.stringify(_local_3)));
        }

        private function _SafeStr_9326(_arg_1:Vector3, _arg_2:Number, _arg_3:TankData, _arg_4:Vector3, _arg_5:Number):void
        {
            this._SafeStr_9328(_arg_3.tank, _arg_4, _arg_1, (-(_arg_5) * _arg_2));
        }

        private function _SafeStr_9327(_arg_1:Vector3, _arg_2:Number, _arg_3:Body, _arg_4:Vector3, _arg_5:Number):void
        {
            this._SafeStr_9328(_arg_3, _arg_4, _arg_1, (_arg_5 * _arg_2));
        }

        private function _SafeStr_9328(_arg_1:Body, _arg_2:Vector3, _arg_3:Vector3, _arg_4:Number):void
        {
            _arg_1._SafeStr_2210(_arg_2, _arg_3, _arg_4);
        }

        public function _SafeStr_2209(_arg_1:int, _arg_2:int, _arg_3:Boolean, _arg_4:TankData, _arg_5:MachineGunEffects, _arg_6:Number, _arg_7:HitInfo, _arg_8:CommonTargetSystem, _arg_9:Number, _arg_10:Number):void
        {
            var _local_18:_SafeStr_124;
            var _local_19:TankData;
            var _local_20:Vector3d;
            var _local_21:Number;
            var _local_22:*;
            if ((((_arg_4 == null) || (_arg_4.tank == null)) || (_arg_4.tank.skin == null))){
                return;
            }
            var _local_11:WeaponCommonData = this._SafeStr_5924._SafeStr_2624(_arg_4.turret);
            var _local_12:Vector3 = new Vector3();
            var _local_13:Vector3 = new Vector3();
            var _local_14:Vector3 = new Vector3();
            var _local_15:Vector3 = new Vector3();
            var _local_16:_SafeStr_462 = this._SafeStr_2199(_arg_4.turret);
            this._SafeStr_5265._SafeStr_2208(_arg_4.tank.skin._SafeStr_1614, _local_11.muzzles[0], _local_12, _local_13, _local_14, _local_15);
            var _local_17:Boolean;
            if (_arg_2 >= this.nextTargetCheckTime.value){
                _local_17 = _arg_8._SafeStr_2211(_local_13, _local_15, _local_14, _arg_4.tank, _arg_7);
                if (((_arg_6 >= 1) && (_local_17))){
                    _arg_5._SafeStr_2213(_arg_7.position, (!(_arg_7._SafeStr_2212 == null)));
                    if (_arg_4 == this._SafeStr_1596){
                        _local_18 = this._SafeStr_1538._SafeStr_1591();
                        _local_19 = null;
                        _local_20 = null;
                        _local_21 = 0;
                        if (_arg_2 >= this._SafeStr_9325.value){
                            _local_21 = (_arg_7.distance * 0.01);
                            _local_20 = new Vector3d(0, 0, 0);
                            _local_20.x = _arg_7.position.x;
                            _local_20.y = _arg_7.position.y;
                            _local_20.z = _arg_7.position.z;
                            _local_22 = null;
                            if (this.hitInfo._SafeStr_2212 != null){
                                for (_local_22 in _local_18.activeTanks) {
                                    if (this.hitInfo._SafeStr_2212 == _local_22.tank){
                                        _local_19 = _local_22;
                                        break;
                                    }
                                }
                            }
                            if (_local_19 != null){
                                this._SafeStr_5401(_local_19.user.id, _local_21);
                            }
                            this._SafeStr_9325.value = (this._SafeStr_9325.value + this._SafeStr_9316.damageTickMsec.value);
                        }
                    }
                }
                else {
                    _arg_5._SafeStr_2207(false);
                }
            }
            if (_arg_6 >= 1){
                this._SafeStr_9326(_local_15, 1, _arg_4, _local_12, _local_16.recoilForce);
                if (_arg_7._SafeStr_2212 != null){
                    this._SafeStr_9327(_local_15, 1, _arg_7._SafeStr_2212, _arg_7.position, _local_16.impactForce);
                }
            }
            this._SafeStr_9329(_arg_4, _arg_6, _arg_9, _arg_10);
            if (_arg_5 != null){
                _arg_5.update(_arg_1, _arg_6, _arg_3, _arg_4, _local_11, _arg_4.tank.skin, _local_12, _local_13, _local_16.spinUpTime, _local_16.spinDownTime);
            }
        }

        private function _SafeStr_6864(_arg_1:int, _arg_2:Boolean, _arg_3:ShooterData=null):void
        {
            if (_arg_3 == null){
                if (_arg_2){
                    this._SafeStr_6040 = Math.min(1, (this._SafeStr_6040 + (_arg_1 * this._SafeStr_9319)));
                }
                else {
                    this._SafeStr_6040 = Math.max(0, (this._SafeStr_6040 - (_arg_1 * this._SafeStr_9320)));
                }
            }
            else {
                if (_arg_2){
                    _arg_3.state = Math.min(1, (_arg_3.state + (_arg_1 * this._SafeStr_9319)));
                }
                else {
                    _arg_3.state = Math.max(0, (_arg_3.state - (_arg_1 * this._SafeStr_9320)));
                }
            }
        }

        private function _SafeStr_9329(_arg_1:TankData, _arg_2:Number, _arg_3:Number, _arg_4:Number):void
        {
            var _local_5:_SafeStr_462 = this._SafeStr_2199(_arg_1.turret);
            var _local_6:Number = (_local_5.weaponTurnDecelerationCoeff + ((1 - _arg_2) * (1 - _local_5.weaponTurnDecelerationCoeff)));
            if (_arg_1.tank != null){
                _arg_1.tank._SafeStr_1693((_arg_3 * _local_6), true);
                _arg_1.tank._SafeStr_2214((_arg_4 * _local_6));
                _arg_1.tank._SafeStr_2198((_arg_2 / 2));
            }
        }

        private function _SafeStr_5934(_arg_1:ObjectRegister, _arg_2:String):TankData
        {
            var _local_3:ClientObject = BattleController.activeTanks[_arg_2];
            if (_local_3 == null){
                return (null);
            }
            var _local_4:TankData = this._SafeStr_1547.getTankData(_local_3);
            if (((_local_4 == null) || (_local_4.tank == null))){
                return (null);
            }
            return (_local_4);
        }


    }
}//package alternativa.tanks.models.weapon.machinegun

import alternativa.tanks.models.tank.TankData;
import alternativa.tanks.models.weapon.common.HitInfo;
import alternativa.tanks.models.weapon.machinegun.MachineGunEffects;
import alternativa.tanks.models.weapon.shared.CommonTargetSystem;

class ShooterData 
{

    public var tankData:TankData;
    public var machineGunEffects:MachineGunEffects;
    public var active:Boolean;
    public var state:Number;
    public var hitInfo:HitInfo;
    public var targetSystem:CommonTargetSystem;
    public var maxTurretTurnSpeed:Number;
    public var maxTurretAcceleration:Number;

    public function ShooterData(_arg_1:TankData, _arg_2:MachineGunEffects, _arg_3:Boolean)
    {
        this.tankData = _arg_1;
        this.machineGunEffects = _arg_2;
        this.active = _arg_3;
        this.state = 0;
        this.hitInfo = new HitInfo();
        this.targetSystem = null;
        this.maxTurretTurnSpeed = _arg_1.tank.maxTurretTurnSpeed;
        this.maxTurretAcceleration = _arg_1.tank._SafeStr_1607;
    }

}


// Vector3 = "#!B" (String#23, DoABC#173)
// _SafeStr_11 = ",#" (String#174, DoABC#173)
// _SafeStr_112 = "<#@" (String#60, DoABC#173)
// _SafeStr_113 = "'V" (String#172, DoABC#173)
// _SafeStr_114 = "5#n" (String#49, DoABC#173)
// _SafeStr_115 = "]#x" (String#92, DoABC#173)
// _SafeStr_12 = "\"#5" (String#168, DoABC#173)
// _SafeStr_124 = "7!0" (String#251, DoABC#173)
// Vector3d = "@\"V" (String#67, DoABC#173)
// _SafeStr_1538 = "\"\"z" (String#20, DoABC#173)
// _SafeStr_1547 = "[!W" (String#87, DoABC#173)
// getService = "\"#1" (String#21, DoABC#173)
// _SafeStr_1589 = " \"$" (String#163, DoABC#173)
// _SafeStr_1591 = "%x" (String#26, DoABC#173)
// _SafeStr_1596 = "9W" (String#57, DoABC#173)
// _SafeStr_1597 = "-!Q" (String#175, DoABC#173)
// _SafeStr_16 = "2[" (String#43, DoABC#173)
// _SafeStr_1603 = ">!j" (String#262, DoABC#173)
// _SafeStr_1607 = "\"$," (String#22, DoABC#173)
// _SafeStr_1612 = "&!R" (String#170, DoABC#173)
// _SafeStr_1614 = "4$%" (String#237, DoABC#173)
// _SafeStr_1638 = "<#^" (String#261, DoABC#173)
// _SafeStr_1669 = "0\"!" (String#177, DoABC#173)
// _SafeStr_1693 = "5#W" (String#243, DoABC#173)
// _SafeStr_2197 = "[i" (String#91, DoABC#173)
// _SafeStr_2198 = "8$-" (String#257, DoABC#173)
// _SafeStr_2199 = ",#-" (String#32, DoABC#173)
// _SafeStr_2200 = " \"J" (String#164, DoABC#173)
// _SafeStr_2201 = "@!i" (String#265, DoABC#173)
// _SafeStr_2202 = "]a" (String#270, DoABC#173)
// _SafeStr_2203 = "<O" (String#128, DoABC#173)
// _SafeStr_2204 = "5I" (String#246, DoABC#173)
// _SafeStr_2205 = ">#1" (String#263, DoABC#173)
// _SafeStr_2206 = "`-" (String#97, DoABC#173)
// _SafeStr_2207 = "`5" (String#272, DoABC#173)
// _SafeStr_2208 = "6a" (String#51, DoABC#173)
// _SafeStr_2209 = " \"q" (String#14, DoABC#173)
// _SafeStr_2210 = "!3" (String#166, DoABC#173)
// _SafeStr_2211 = " !n" (String#162, DoABC#173)
// _SafeStr_2212 = "0#R" (String#37, DoABC#173)
// _SafeStr_2213 = "?n" (String#264, DoABC#173)
// _SafeStr_2214 = "1\"j" (String#178, DoABC#173)
// _SafeStr_241 = ">!g" (String#61, DoABC#173)
// _SafeStr_2468 = "6#Z" (String#247, DoABC#173)
// _SafeStr_2469 = "7\"B" (String#253, DoABC#173)
// _SafeStr_2624 = "<#F" (String#260, DoABC#173)
// _SafeStr_2638 = "%u" (String#169, DoABC#173)
// IBattleField = "@#X" (String#69, DoABC#173)
// _SafeStr_28 = "`#c" (String#96, DoABC#173)
// _SafeStr_3684 = "!l" (String#18, DoABC#173)
// _SafeStr_3729 = "7$-" (String#52, DoABC#173)
// IBattleField = "9#R" (String#55, DoABC#173)
// _SafeStr_3919 = "8#3" (String#53, DoABC#173)
// _SafeStr_462 = "+#O" (String#29, DoABC#173)
// SecureNumber = "9$8" (String#56, DoABC#173)
// ICommonTargetEvaluator = " =" (String#165, DoABC#173)
// _SafeStr_465 = "-#N" (String#35, DoABC#173)
// SecureInt = SecureInt" (String#25, DoABC#173)
// HitInfo = "1$;" (String#42, DoABC#173)
// WeaponUtils = ">\" " (String#63, DoABC#173)
// ShotData = "+#P" (String#173, DoABC#173)
// WeaponCommonData = "5#w" (String#244, DoABC#173)
// _SafeStr_5262 = "8N" (String#54, DoABC#173)
// _SafeStr_5264 = " #e" (String#15, DoABC#173)
// _SafeStr_5265 = ",#W" (String#33, DoABC#173)
// _SafeStr_5269 = "?x" (String#66, DoABC#173)
// _SafeStr_5270 = "1#6" (String#41, DoABC#173)
// _SafeStr_5277 = "&#q" (String#171, DoABC#173)
// _SafeStr_5278 = "-!h" (String#176, DoABC#173)
// _SafeStr_5279 = "[$=" (String#269, DoABC#173)
// _SafeStr_5401 = " G" (String#17, DoABC#173)
// _SafeStr_5496 = "3k" (String#46, DoABC#173)
// IModelService = ",!'" (String#30, DoABC#173)
// _SafeStr_5924 = "3\"a" (String#44, DoABC#173)
// _SafeStr_5925 = ">\"b" (String#64, DoABC#173)
// _SafeStr_5932 = "5\"?" (String#242, DoABC#173)
// _SafeStr_5934 = ",\"T" (String#31, DoABC#173)
// _SafeStr_6040 = "0#I" (String#36, DoABC#173)
// _SafeStr_6864 = "`\"1" (String#94, DoABC#173)
// _SafeStr_9316 = "1#&" (String#40, DoABC#173)
// _SafeStr_9317 = "&!P" (String#27, DoABC#173)
// _SafeStr_9318 = "'4" (String#28, DoABC#173)
// _SafeStr_9319 = "-\"`" (String#34, DoABC#173)
// _SafeStr_9320 = "?$'" (String#65, DoABC#173)
// _SafeStr_9321 = "0$#" (String#38, DoABC#173)
// _SafeStr_9322 = "5$'" (String#50, DoABC#173)
// _SafeStr_9323 = " <" (String#16, DoABC#173)
// _SafeStr_9324 = "7#]" (String#254, DoABC#173)
// _SafeStr_9325 = "1!R" (String#39, DoABC#173)
// _SafeStr_9326 = "`\"f" (String#95, DoABC#173)
// _SafeStr_9327 = "4L" (String#241, DoABC#173)
// _SafeStr_9328 = ">!q" (String#62, DoABC#173)
// _SafeStr_9329 = "\"!&" (String#167, DoABC#173)


