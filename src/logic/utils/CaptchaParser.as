// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.utils.CaptchaParser

package logic.utils
{
    import flash.display.Loader;
    import flash.utils.ByteArray;
    import flash.events.Event;
    import flash.display.Bitmap;
    import flash.events.EventDispatcher;

    public class CaptchaParser
    {

        public static function parse(packet:String, onBitmapParsedHandler:Function):void
        {
            var loader:Loader;
            var byte:String;
            loader = null;
            var byteArray:ByteArray = new ByteArray();
            var i:int;
            var bytes:Array = packet.split(",");
            for each (byte in bytes)
            {
                byteArray.writeByte(parseInt(byte));
                i = (i + 1);
            }
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(param1:Event):void
                {
                    onBitmapParsedHandler.apply(null, [(loader.content as Bitmap)]);
                    (param1.target as EventDispatcher).removeEventListener(param1.type, arguments.callee);
                });
            loader.loadBytes(byteArray);
        }

    }
} // package scpacker.utils