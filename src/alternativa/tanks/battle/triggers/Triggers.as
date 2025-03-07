﻿package alternativa.tanks.battle.triggers
{
    import __AS3__.vec.Vector;
    import alternativa.tanks.battle.Trigger;
    import alternativa.tanks.battle.DeferredAction;
    import alternativa.physics.Body;
    import __AS3__.vec.*;

    public class Triggers
    {

        private const _triggers:Vector.<Trigger> = new Vector.<Trigger>();
        private const deferredActions:Vector.<DeferredAction> = new Vector.<DeferredAction>();

        private var running:Boolean;

        public function add(param1:Trigger):void
        {
            if (this.running)
            {
                this.deferredActions.push(new DeferredTriggerAddition(this, param1));
            }
            else
            {
                if (this._triggers.indexOf(param1) < 0)
                {
                    this._triggers.push(param1);
                }
            }
        }
        public function remove(param1:Trigger):void
        {
            var _loc2_:int;
            var _loc3_:int;
            if (this.running)
            {
                this.deferredActions.push(new DeferredTriggerDeletion(this, param1));
            }
            else
            {
                _loc2_ = this._triggers.length;
                if (_loc2_ > 0)
                {
                    _loc3_ = this._triggers.indexOf(param1);
                    if (_loc3_ >= 0)
                    {
                        this._triggers[_loc3_] = this._triggers[-- _loc2_];
                        this._triggers.length = _loc2_;
                    }
                }
            }
        }
        public function check(param1:Body):void
        {
            var _loc2_:int;
            var _loc3_:int;
            var _loc4_:Trigger;
            if (param1 != null)
            {
                this.running = true;
                _loc2_ = this._triggers.length;
                _loc3_ = 0;
                while (_loc3_ < _loc2_)
                {
                    _loc4_ = this._triggers[_loc3_];
                    _loc4_.checkTrigger(param1);
                    _loc3_++;
                }
                this.running = false;
                this.executeDeferredActions();
            }
        }
        private function executeDeferredActions():void
        {
            var _loc1_:DeferredAction;
            while ((_loc1_ = this.deferredActions.pop()) != null)
            {
                _loc1_.execute();
            }
        }

    }
}
