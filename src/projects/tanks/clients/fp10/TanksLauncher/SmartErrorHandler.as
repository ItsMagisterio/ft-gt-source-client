package projects.tanks.clients.fp10.TanksLauncher
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TextEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;

   public class SmartErrorHandler extends Sprite
   {

      public static const OVERLOADED_ERROR:String = "overloaded";

      public static const NOTAVAILABLE_ERROR:String = "notavailable";

      private var errorMessage:String;

      private var errorCode:String;

      private var tanksErrorMessage:*;

      public function SmartErrorHandler(errorMessage:String, errorCode:String)
      {
         super();
         this.errorMessage = errorMessage;
         this.errorCode = errorCode;
      }

      private function showSimpleMessage(message:String):void
      {
         var tf:TextField = new TextField();
         tf.wordWrap = true;
         tf.multiline = true;
         tf.width = 600;
         tf.autoSize = TextFieldAutoSize.LEFT;
         tf.defaultTextFormat = new TextFormat("Tahoma", 16, 16777215);
         tf.text = message;
         stage.addChild(tf);
         tf.x = stage.stageWidth - tf.width >> 1;
         tf.y = stage.stageHeight - tf.height >> 1;
      }

      public function handleLoadingError():void
      {
         var request:URLRequest = null;
         var loader:Loader = null;
         var loaderInfo:LoaderInfo = null;
         if (this.forceShowDetailedError || this.isDebugMode)
         {
            this.showSimpleMessage(this.errorMessage);
         }
         else
         {
            request = new URLRequest("TanksErrorScreen.swf");
            loader = new Loader();
            loaderInfo = loader.contentLoaderInfo;
            loader.load(request);
            loaderInfo.addEventListener(Event.COMPLETE, this.onLoadingErrorMessageComplete);
            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onFailedLoadingTanksErrorMessageClass);
            loaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onFailedLoadingTanksErrorMessageClass);
         }
      }

      private function onFailedLoadingTanksErrorMessageClass(event:Event):void
      {
         this.showSimpleMessage(this.errorMessage);
      }

      private function onLoadingErrorMessageComplete(event:Event):void
      {
      }

      private function onLinkClicked(event:TextEvent):void
      {
         try
         {
            navigateToURL(new URLRequest(event.text), "_top");
         }
         catch (e:Error)
         {
            trace(e.message);
         }
      }

      private function draw(event:Event):void
      {
         this.tanksErrorMessage.redraw(stage.stageWidth, stage.stageHeight);
      }

      private function get isDebugMode():Boolean
      {
         return Boolean(true);
      }

      private function get isTestServer():Boolean
      {
         return Boolean(loaderInfo.parameters["test_server"]);
      }

      private function get forceShowDetailedError():Boolean
      {
         return Boolean(loaderInfo.parameters["show_detailed_error"]);
      }
   }
}
