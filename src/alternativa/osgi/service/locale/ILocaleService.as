package alternativa.osgi.service.locale
{
    import flash.display.BitmapData;

    public interface ILocaleService
    {

        function registerText(_arg_1:String, _arg_2:String):void;
        function registerTextArray(_arg_1:String, _arg_2:Array):void;
        function registerTextMulty(_arg_1:Array):void;
        function registerImage(_arg_1:String, _arg_2:BitmapData):void;
        function getText(_arg_1:String, ..._args):String;
        function getTextArray(_arg_1:String):Array;
        function getImage(_arg_1:String):BitmapData;
        function get language():String;

    }
}
