package alternativa.tanks.services.captcha
{

   import flash.display.Loader;
   import flash.utils.ByteArray;
   import flash.events.Event;
   import logic.networking.Network;
   import logic.networking.INetworker;
   import alternativa.init.Main;
   import flash.display.Bitmap;

   public class CaptchaService implements ICaptchaService
   {

      private var callback:Function;
      private var sessionId:String;
      private var image:Bitmap;

      public function CaptchaService()
      {
      }

      public function getSessionId():String
      {
         return this.sessionId;
      }

      public function getImage():Bitmap
      {
         return this.image;
      }

      private function clear():void
      {
         this.callback = null;
         this.sessionId = null;
         this.image = null;
      }

      public function registerCallbackAndCreateSession(cback:Function):void
      {
         this.clear();
         this.callback = cback;
         Network(Main.osgi.getService(INetworker)).send("system;create_captcha_session");
      }

      public function parseSessionCreated(sessionId:String, rawBytes:String):void
      {
         this.sessionId = sessionId;
         this.parse(rawBytes);
      }

      private function parse(rawImageHex:String):void
      {
         if (this.callback == null)
         {
            throw new Error("Callback is not set");
         }

         var byteArray:ByteArray = new ByteArray();

         for (var i:int = 0; i < rawImageHex.length; i += 2)
         {
            var byteString:String = rawImageHex.substr(i, 2);
            var byteNumber:int = parseInt(byteString, 16);
            byteArray.writeByte(byteNumber);
         }

         var loader:Loader;
         loader = null;
         loader = new Loader();

         // TODO: add loader error handler
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(param1:Event):void
            {
               image = Bitmap(loader.content);
               callback.call();
            });
         loader.loadBytes(byteArray);
      }

   }
}