package alternativa.startup
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;

   public class CacheLoader extends Loader
   {

      private var encodedUrl:String;

      private var cacheDirectory:Object;

      private var context:LoaderContext;

      private var cached:Boolean;

      private var FileClass:Class;

      private var FileStreamClass:Class;

      private var FileModeClass:Class;

      public function CacheLoader()
      {
         super();
         if (StartupSettings.isDesktop)
         {
            this.FileClass = getDefinitionByName("flash.filesystem.File") as Class;
            this.FileStreamClass = getDefinitionByName("flash.filesystem.FileStream") as Class;
            this.FileModeClass = getDefinitionByName("flash.filesystem.FileMode") as Class;
            this.cacheDirectory = this.FileClass.applicationStorageDirectory.resolvePath("cache");
            if (!this.cacheDirectory.exists)
            {
               this.cacheDirectory.createDirectory();
            }
            else if (!this.cacheDirectory.isDirectory)
            {
               throw new Error("Cannot create directory." + this.cacheDirectory.nativePath + " is already exists.");
            }
         }
      }

      override public function load(param1:URLRequest, param2:LoaderContext = null):void
      {
         if (!StartupSettings.isDesktop)
         {
            super.load(param1, param2);
            return;
         }
         var _loc3_:URLRequest = param1;
         this.context = param2;
         this.encodedUrl = URLEncoder.encode(param1.url);
         var _loc4_:Object;
         if ((_loc4_ = this.cacheDirectory.resolvePath(this.encodedUrl)).exists)
         {
            _loc3_ = new URLRequest(_loc4_.url);
            this.cached = true;
         }
         var _loc5_:URLLoader;
         (_loc5_ = new URLLoader()).dataFormat = URLLoaderDataFormat.BINARY;
         _loc5_.addEventListener(Event.COMPLETE, this.onBytesLoaded, false, 0, true);
         _loc5_.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError, false, 0, true);
         _loc5_.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError, false, 0, true);
         _loc5_.load(_loc3_);
      }

      private function onIOError(param1:Event):void
      {
         dispatchEvent(new IOErrorEvent("CacheLoader: IOError!"));
      }

      private function onSecurityError(param1:Event):void
      {
         dispatchEvent(new SecurityErrorEvent("CacheLoader: Security error!"));
      }

      private function onBytesLoaded(param1:Event):void
      {
         var file:Object = null;
         var fileStream:Object = null;
         var e:Event = param1;
         var bytes:ByteArray = URLLoader(e.target).data as ByteArray;
         if (!this.cached)
         {
            file = new this.FileClass(this.cacheDirectory.resolvePath(this.encodedUrl).nativePath);
            fileStream = new this.FileStreamClass();
            try
            {
               fileStream.open(file, this.FileModeClass.WRITE);
               fileStream.writeBytes(URLLoader(e.target).data as ByteArray);
               fileStream.close();
            }
            catch (e:Error)
            {
               dispatchEvent(new IOErrorEvent("CacheLoader error! " + e.message + "url: " + encodedUrl));
            }
         }
         super.loadBytes(bytes, this.context);
      }
   }
}
