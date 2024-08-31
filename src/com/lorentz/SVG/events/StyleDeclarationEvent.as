package com.lorentz.SVG.events
{
    import flash.events.Event;

    public class StyleDeclarationEvent extends Event
    {

        public static const PROPERTY_CHANGE:String = "propertyChange";

        private var _propertyName:String;
        private var _oldValue:String;
        private var _newValue:String;

        public function StyleDeclarationEvent(_arg_1:String, propertyName:String, oldValue:String, newValue:String)
        {
            super(_arg_1);
            this._propertyName = propertyName;
            this._oldValue = oldValue;
            this._newValue = newValue;
        }
        public function get propertyName():String
        {
            return (this._propertyName);
        }
        public function get oldValue():String
        {
            return (this._oldValue);
        }
        public function get newValue():String
        {
            return (this._newValue);
        }

    }
}
