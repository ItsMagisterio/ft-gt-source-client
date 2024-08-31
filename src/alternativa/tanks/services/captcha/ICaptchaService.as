package alternativa.tanks.services.captcha
{
   import flash.display.Bitmap;

   public interface ICaptchaService
   {
      function registerCallbackAndCreateSession(cback:Function):void;
      function parseSessionCreated(sessionId:String, rawBytes:String):void;
      function getSessionId():String;
      function getImage():Bitmap;
   }
}