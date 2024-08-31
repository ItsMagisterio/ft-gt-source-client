package com.lorentz.SVG.data.style
{
    import flash.events.EventDispatcher;
    import com.lorentz.SVG.utils.ICloneable;
    import com.lorentz.SVG.events.StyleDeclarationEvent;
    import com.lorentz.SVG.utils.StringUtil;

    [Event(name="propertyChange", type="com.lorentz.SVG.events.StyleDeclarationEvent")]
    public class StyleDeclaration extends EventDispatcher implements ICloneable
    {

        private static const nonInheritableProperties:Array = ["display", "opacity", "clip", "filter", "overflow", "clip-path"];

        private var _propertiesValues:Object = {}
        private var _indexedProperties:Array = [];

        public static function createFromString(styleString:String):StyleDeclaration
        {
            var styleDeclaration:StyleDeclaration = new (StyleDeclaration)();
            styleDeclaration.fromString(styleString);
            return (styleDeclaration);
        }

        public function getPropertyValue(propertyName:String):String
        {
            return (this._propertiesValues[propertyName]);
        }
        public function setProperty(propertyName:String, value:String):void
        {
            var oldValue:String;
            if (this._propertiesValues[propertyName] != value)
            {
                oldValue = this._propertiesValues[propertyName];
                this._propertiesValues[propertyName] = value;
                this.indexProperty(propertyName);
                dispatchEvent(new StyleDeclarationEvent(StyleDeclarationEvent.PROPERTY_CHANGE, propertyName, oldValue, value));
            }
        }
        public function removeProperty(propertyName:String):String
        {
            var oldValue:String = this._propertiesValues[propertyName];
            delete this._propertiesValues[propertyName];
            this.unindexProperty(propertyName);
            dispatchEvent(new StyleDeclarationEvent(StyleDeclarationEvent.PROPERTY_CHANGE, propertyName, oldValue, null));
            return (oldValue);
        }
        public function hasProperty(propertyName:String):Boolean
        {
            var index:int = this._indexedProperties.indexOf(propertyName);
            return (!(index == -1));
        }
        public function get length():int
        {
            return (this._indexedProperties.length);
        }
        public function item(index:int):String
        {
            return (this._indexedProperties[index]);
        }
        public function fromString(styleString:String):void
        {
            var prop:String;
            var split:Array;
            styleString = StringUtil.trim(styleString);
            styleString = StringUtil.rtrim(styleString, ";");
            for each (prop in styleString.split(";"))
            {
                split = prop.split(":");
                if (split.length == 2)
                {
                    this.setProperty(StringUtil.trim(split[0]), StringUtil.trim(split[1]));
                }
            }
        }
        override public function toString():String
        {
            var propertyName:String;
            var styleString:String = "";
            for each (propertyName in this._indexedProperties)
            {
                styleString = (styleString + (((propertyName + ":") + this._propertiesValues[propertyName]) + "; "));
            }
            return (styleString);
        }
        public function clear():void
        {
            while (this.length > 0)
            {
                this.removeProperty(this.item(0));
            }
        }
        public function copyStyles(target:StyleDeclaration, onlyInheritable:Boolean = false):void
        {
            var propertyName:String;
            for each (propertyName in this._indexedProperties)
            {
                if (((!(onlyInheritable)) || (nonInheritableProperties.indexOf(propertyName) == -1)))
                {
                    target.setProperty(propertyName, this.getPropertyValue(propertyName));
                }
            }
        }
        public function cloneOn(target:StyleDeclaration):void
        {
            var propertyName:String;
            var i:int;
            for each (propertyName in this._indexedProperties)
            {
                target.setProperty(propertyName, this.getPropertyValue(propertyName));
            }
            i = 0;
            while (i < target.length)
            {
                propertyName = target.item(i);
                if ((!(this.hasProperty(propertyName))))
                {
                    target.removeProperty(propertyName);
                }
                i++;
            }
        }
        private function indexProperty(propertyName:String):void
        {
            if (this._indexedProperties.indexOf(propertyName) == -1)
            {
                this._indexedProperties.push(propertyName);
            }
        }
        private function unindexProperty(propertyName:String):void
        {
            var index:int = this._indexedProperties.indexOf(propertyName);
            if (index != -1)
            {
                this._indexedProperties.splice(index, 1);
            }
        }
        public function clone():Object
        {
            var c:StyleDeclaration = new StyleDeclaration();
            this.cloneOn(c);
            return (c);
        }

    }
}
