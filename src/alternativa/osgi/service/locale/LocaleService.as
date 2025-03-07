﻿package alternativa.osgi.service.locale
{
    import flash.utils.Dictionary;
    import flash.display.BitmapData;

    public class LocaleService implements ILocaleService
    {

        private var _language:String;
        private var texts:Dictionary;
        private var images:Dictionary;

        public function LocaleService(language:String)
        {
            this._language = language;
            this.texts = new Dictionary();
            this.images = new Dictionary();
        }
        public function registerText(id:String, text:String):void
        {
            this.texts[id] = text;
        }
        public function registerTextArray(id:String, textArray:Array):void
        {
            this.texts[id] = textArray;
        }
        public function registerTextMulty(localeData:Array):void
        {
            var len:int = localeData.length;
            var i:int;
            while (i < len)
            {
                this.registerText(localeData[i], localeData[(i + 1)]);
                i = (i + 2);
            }
        }
        public function registerImage(id:String, image:BitmapData):void
        {
            this.images[id] = image;
        }
        public function getText(id:String, ...vars):String
        {
            var text:String = ((!(this.texts[id] == null)) ? this.texts[id] : id);
            var i:int;
            while (i < vars.length)
            {
                text = text.replace(("%" + (i + 1)), vars[i]);
                i++;
            }
            return (text);
        }
        public function getTextArray(id:String):Array
        {
            return ((!(this.texts[id] == null)) ? this.texts[id] : new Array());
        }
        public function getImage(id:String):BitmapData
        {
            return (this.images[id]);
        }
        public function get language():String
        {
            return (this._language);
        }

    }
}
