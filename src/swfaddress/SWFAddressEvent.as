// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// swfaddress.SWFAddressEvent

package swfaddress
{
    import flash.events.Event;

    public class SWFAddressEvent extends Event
    {

        public static const INIT:String = "init";
        public static const CHANGE:String = "change";

        private var _value:String;
        private var _path:String;
        private var _pathNames:Array;
        private var _parameters:Object;
        private var _parametersNames:Array;

        public function SWFAddressEvent(_arg_1:String)
        {
            super(_arg_1, false, false);
        }
        override public function get currentTarget():Object
        {
            return (SWFAddress);
        }
        override public function get type():String
        {
            return (super.type);
        }
        override public function get target():Object
        {
            return (SWFAddress);
        }
        public function get value():String
        {
            if (this._value == null)
            {
                this._value = SWFAddress.getValue();
            }
            return (this._value);
        }
        public function get path():String
        {
            if (this._path == null)
            {
                this._path = SWFAddress.getPath();
            }
            return (this._path);
        }
        public function get pathNames():Array
        {
            if (this._pathNames == null)
            {
                this._pathNames = SWFAddress.getPathNames();
            }
            return (this._pathNames);
        }
        public function get parameters():Object
        {
            var i:int;
            if (this._parameters == null)
            {
                this._parameters = new Object();
                i = 0;
                while (i < this.parametersNames.length)
                {
                    this._parameters[this.parametersNames[i]] = SWFAddress.getParameter(this.parametersNames[i]);
                    i++;
                }
            }
            return (this._parameters);
        }
        public function get parametersNames():Array
        {
            if (this._parametersNames == null)
            {
                this._parametersNames = SWFAddress.getParameterNames();
            }
            return (this._parametersNames);
        }
        override public function clone():Event
        {
            return (new SWFAddressEvent(this.type));
        }
        override public function toString():String
        {
            return (formatToString("SWFAddressEvent", "type", "bubbles", "cancelable", "eventPhase", "value", "path", "pathNames", "parameters", "parametersNames"));
        }

    }
} // package swfaddress