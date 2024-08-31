package com.reygazu.anticheat.events
{
    import flash.events.Event;

    public class CheatManagerEvent extends Event
    {

        public static var FORCE_HOP:String = "forceHop";
        public static var CHEAT_DETECTION:String = "cheatDetection";

        public var data:Object;

        public function CheatManagerEvent(_arg_1:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(_arg_1, bubbles, cancelable);
        }
    }
}
