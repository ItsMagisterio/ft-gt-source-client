﻿package com.reygazu.anticheat.managers
{
    import flash.events.EventDispatcher;
    import flash.display.Stage;
    import alternativa.init.Main;
    import flash.events.Event;
    import com.reygazu.anticheat.events.CheatManagerEvent;

    [Event(name="forceHop", type="com.reygazu.anticheat.events.CheatManagerEvent")]
    [Event(name="cheatDetection", type="com.reygazu.anticheat.events.CheatManagerEvent")]
    public class CheatManager extends EventDispatcher
    {

        protected static var _instance:CheatManager;

        private var _focusHop:Boolean;
        private var _secureVars:Array;
        private var stage:Stage;

        public function CheatManager(caller:Function = null)
        {
            if (caller != CheatManager.getInstance)
            {
                throw (new Error("CheatManager is a singleton class, use getInstance() instead"));
            }
            if (CheatManager._instance != null)
            {
                throw (new Error("Only one CheatManager instance should be instantiated"));
            }
        }
        public static function getInstance():CheatManager
        {
            if (_instance == null)
            {
                _instance = new CheatManager(arguments.callee);
                _instance.init();
            }
            return (_instance);
        }

        private function init():void
        {
            this._secureVars = new Array();
            this._focusHop = false;
            this.stage = Main.stage;
            this.stage.addEventListener(Event.DEACTIVATE, this.onLostFocusHandler);
        }
        public function set enableFocusHop(value:Boolean):void
        {
            this._focusHop = value;
        }
        private function onLostFocusHandler(evt:Event):void
        {
            if (this._focusHop)
            {
                this.doHop();
            }
        }
        public function doHop():void
        {
            trace("* CheatManager : Force Hop Event Dispatched *");
            this.dispatchEvent(new CheatManagerEvent(CheatManagerEvent.FORCE_HOP));
        }
        public function detectCheat(name:String, fakeValue:Object, realValue:Object):void
        {
            trace((((((("* CheatManager : cheat detection in " + name) + " fake value : ") + fakeValue) + " != real value ") + realValue) + " *"));
            var event:CheatManagerEvent = new CheatManagerEvent(CheatManagerEvent.CHEAT_DETECTION);
            event.data = {
                    "variableName": name,
                    "fakeValue": fakeValue,
                    "realValue": realValue
                }
            CheatManager.getInstance().dispatchEvent(event);
        }

    }
}
