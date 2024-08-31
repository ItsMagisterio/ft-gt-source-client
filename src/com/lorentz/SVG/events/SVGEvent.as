package com.lorentz.SVG.events
{
    import flash.events.Event;
    import com.lorentz.SVG.display.base.SVGElement;

    public class SVGEvent extends Event
    {

        public static const INVALIDATE:String = "invalidate";
        public static const SYNC_VALIDATED:String = "syncValidated";
        public static const ASYNC_VALIDATED:String = "asyncValidated";
        public static const VALIDATED:String = "validated";
        public static const RENDERED:String = "rendered";
        public static const PARSE_START:String = "parseStart";
        public static const PARSE_COMPLETE:String = "parseComplete";
        public static const ELEMENT_ADDED:String = "elementAdded";
        public static const ELEMENT_REMOVED:String = "elementRemoved";

        private var _element:SVGElement;

        public function SVGEvent(_arg_1:String, element:SVGElement = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(_arg_1, bubbles, cancelable);
            this._element = element;
        }
        public function get element():SVGElement
        {
            return (this._element);
        }
        override public function clone():Event
        {
            return (new SVGEvent(type, this.element, bubbles, cancelable));
        }

    }
}
