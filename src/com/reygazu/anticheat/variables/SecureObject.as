﻿package com.reygazu.anticheat.variables
{
    import com.reygazu.anticheat.managers.CheatManager;
    import com.reygazu.anticheat.events.CheatManagerEvent;

    public dynamic class SecureObject
    {

        private var id:String;
        private var _name:String;

        public function SecureObject(name:String = "Unnamed SecureObject", value:Object = 0)
        {
            this._name = name;
            this.objectValue = value;
            CheatManager.getInstance().addEventListener(CheatManagerEvent.FORCE_HOP, this.onForceHop);
        }
        public function set objectValue(value:Object):void
        {
            if (this.hasOwnProperty(this.id))
            {
                delete this[this.id];
            }
            this.hop();
            this[this.id] = value;
            this["fake"] = value;
        }
        public function get objectValue():Object
        {
            return (this[this.id]);
        }
        private function hop():void
        {
            var _id:String = this.id;
            while (this.id == _id)
            {
                this.id = String(Math.round((Math.random() * 0xFFFFF)));
            }
        }
        public function get name():String
        {
            return (this._name);
        }
        private function onForceHop(evt:CheatManagerEvent):void
        {
            var temp:Object = this.objectValue;
            this.objectValue = temp;
        }

    }
}
