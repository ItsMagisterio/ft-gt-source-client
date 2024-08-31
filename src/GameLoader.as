package
{
   import flash.desktop.NativeApplication;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowInitOptions;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageDisplayState;
   import flash.display.StageQuality;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.ByteArray;
   import projects.tanks.clients.fp10.TanksLauncher.SmartErrorHandler;
   import projects.tanks.clients.fp10.TanksLauncher.background.Background;
   import projects.tanks.clients.tankslauncershared.dishonestprogressbar.DishonestProgressBar;
   import flash.geom.Point;

   public class GameLoader extends Sprite
   {

      private static var GAME_URL:String = "http://cdn.primetanki.com:32286/";

      private static const ENTRANCE_MODEL_OBJECT_LOADED_EVENT:String = "EntranceModel.objectLoaded";

      private var loader:Loader;

      private var locale:String;

      public var log:TextField;

      private var fullScreen:Boolean;

      private var _dishonestProgressBar:DishonestProgressBar;

      private var _background:Background;

      public function GameLoader()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE, this.init);
      }

      public static function findClass(param1:String):Class
      {
         return Class(ApplicationDomain.currentDomain.getDefinition(param1));
      }

      private function init(e:Event = null):void
      {
         removeEventListener(Event.ADDED_TO_STAGE, this.init);
         this.configureStage();
         this.createBackground();
         stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKey);
         this.createDishonestProgressBar();
         try
         {
            this.loadLibrary();
         }
         catch (e:Error)
         {
            this.handleLoadingError(e.getStackTrace(), "0");
         }
      }

      private function configureStage():void
      {
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.quality = StageQuality.LOW;
         stage.stageFocusRect = false;
         mouseEnabled = false;
         tabEnabled = false;
         stage.addEventListener(ENTRANCE_MODEL_OBJECT_LOADED_EVENT, this.onEntranceModelObjectLoaded);
      }

      private function createBackground():void
      {
         this._background = new Background();
         stage.addChild(this._background);
      }

      private function createDishonestProgressBar():void
      {
         this._dishonestProgressBar = new DishonestProgressBar("EN", this.progressBarFinished);
         stage.addChild(this._dishonestProgressBar);
         this._dishonestProgressBar.start();
      }

      private function progressBarFinished():void
      {
         this.removeFromStageBackground();
         this.removeFromStageDishonestProgressBar();
      }

      private function removeFromStageBackground():void
      {
         if (stage.contains(this._background))
         {
            stage.removeChild(this._background);
         }
      }

      private function removeFromStageDishonestProgressBar():void
      {
         if (stage.contains(this._dishonestProgressBar))
         {
            stage.removeChild(this._dishonestProgressBar);
         }
      }

      private function onEntranceModelObjectLoaded(event:Event):void
      {
         stage.removeEventListener(ENTRANCE_MODEL_OBJECT_LOADED_EVENT, this.onEntranceModelObjectLoaded);
         this.removeFromStageBackground();
         this._dishonestProgressBar.forciblyFinish();
      }

      private function loadLibrary():void
      {
         var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
         var flashvars:URLVariables = new URLVariables();
         flashvars["locale"] = "en";
         flashvars["rnd"] = Math.random();
         var urlReq:URLRequest = new URLRequest(GAME_URL + "battles.swf?rand=" + Math.random());
         var urlLoader:URLLoader = new URLLoader();
         urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         urlLoader.addEventListener(Event.COMPLETE, this.byteArrayLoadComplete);
         urlLoader.load(urlReq);
      }

      private function byteArrayLoadComplete(event:Event):void
      {
         var bytes:ByteArray = URLLoader(event.target).data as ByteArray;
         this.loader = new Loader();
         var loaderContext:LoaderContext = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));
         var loaderInfo:LoaderInfo = this.loader.contentLoaderInfo;
         loaderInfo.addEventListener(Event.COMPLETE, this.onComplete, false, 0, true);
         loaderContext.allowCodeImport = true;
         this.loader.loadBytes(bytes, loaderContext);
         this.progressBarFinished();
         // var _loc2_:NativeWindowInitOptions = new NativeWindowInitOptions();
         // _loc2_.renderMode = "direct";
         // _loc2_.maximizable = true;
         // var window = new NativeWindow(_loc2_);
         // window.minSize = new Point(1024,768);
         // window.maxSize = new Point(4095,2880);
         // window.stage.stageWidth = 1024;
         // window.stage.stageHeight = 768;
      }

      public function logEvent(entry:String):void
      {
         this.log.appendText(entry + "\n");
      }

      private function onComplete(e:Event):void
      {
         this.loader.removeEventListener(Event.COMPLETE, this.onComplete);
         var mainClass:Class = Class(this.loader.contentLoaderInfo.applicationDomain.getDefinition("Game"));
         var obj:* = new mainClass();
         obj.SUPER(stage);
         addChild(obj);
      }

      private function handleLoadingError(errorMessage:String, errorCode:String):void
      {
         var seh:SmartErrorHandler = new SmartErrorHandler(errorMessage, errorCode);
         stage.addChild(seh);
         seh.handleLoadingError();
      }

      private function onKey(e:KeyboardEvent):void
      {
         switch (e.keyCode)
         {
            case Keyboard.F11:
               this.fullScreen = !this.fullScreen;
               if (this.fullScreen)
               {
                  stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
                  break;
               }
               stage.displayState = StageDisplayState.NORMAL;
               break;
         }
      }
   }
}
