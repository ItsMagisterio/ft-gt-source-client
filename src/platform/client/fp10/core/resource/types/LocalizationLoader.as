package platform.client.fp10.core.resource.types
{
   import alternativa.osgi.OSGi;
   import alternativa.osgi.service.launcherparams.ILauncherParams;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.locale.LocaleService;
   import alternativa.osgi.service.logging.LogService;
   import alternativa.osgi.service.logging.Logger;
   import alternativa.protocol.IProtocol;
   import alternativa.startup.CacheURLLoader;
   import alternativa.types.URL;
   import flash.display.BitmapData;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import platform.client.core.general.resourcelocale.format.ImagePair;
   import platform.client.core.general.resourcelocale.format.LocalizedFileFormat;
   import platform.client.core.general.resourcelocale.format.StringPair;
   import platform.client.fp10.core.resource.BatchImageConstructor;

   public class LocalizationLoader
   {

      private var localeService:ILocaleService;

      private var localeStruct:LocalizedFileFormat;

      private var batchImageConstructor:BatchImageConstructor;

      private var localizationLogger:Logger;

      protected var loadCompleteHandler:Function;

      private var urlParams:ILauncherParams;

      public function LocalizationLoader(param1:ILauncherParams)
      {
         super();
         var _loc2_:OSGi = OSGi.getInstance();
         this.urlParams = param1;
         var _loc3_:String = String(param1.getParameter("lang", "en"));
         this.localeService = new LocaleService(_loc3_, "en");
         _loc2_.registerService(ILocaleService, this.localeService);
         this.localizationLogger = _loc2_.getService(LogService).getLogger("localization");
      }

      public function load(param1:Function):void
      {
         this.loadCompleteHandler = param1;
         this.loadMeta();
      }

      private function loadMeta():void
      {
         var _loc1_:String = this.getLocalizationRootUrl() + "meta.json?rand=" + Math.random();
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.dataFormat = URLLoaderDataFormat.BINARY;
         _loc2_.addEventListener(Event.COMPLETE, this.onLoadMetaComplete);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadingError);
         _loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onLoadingError);
         _loc2_.load(new URLRequest(_loc1_));
      }

      private function getLocalizationRootUrl():String
      {
         var _loc4_:String = null;
         var _loc1_:String = String(this.urlParams.getParameter("resources"));
         var _loc2_:int = _loc1_.indexOf("resources/");
         var _loc3_:String = _loc2_ == -1 ? _loc1_ : _loc1_.substr(0, _loc2_);
         if (_loc3_.indexOf("://") == -1)
         {
            _loc4_ = String(new URL(this.urlParams.urlLoader, this.urlParams.isStrictUseHttp()).scheme);
            _loc3_ = _loc4_ + "://" + _loc3_;
         }
         if (_loc3_.lastIndexOf("/") != _loc3_.length - 1)
         {
            _loc3_ += "/";
         }
         return _loc3_ + "localization/";
      }

      private function onLoadMetaComplete(param1:Event):void
      {
         var _loc2_:Object = JSON.parse(unescape(param1.target.data));
         var _loc3_:String = String(_loc2_[this.localeService.language.toUpperCase() + ".l18n"]);
         this.loadData(this.getLocalizationRootUrl() + _loc3_);
      }

      private function loadData(param1:String):void
      {
         var _loc2_:CacheURLLoader = new CacheURLLoader();
         _loc2_.dataFormat = URLLoaderDataFormat.BINARY;
         _loc2_.addEventListener(Event.COMPLETE, this.onLoadingComplete);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadingError);
         _loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onLoadingError);
         _loc2_.load(new URLRequest(param1));
      }

      protected function onLoadingComplete(param1:Event):void
      {
         var _loc2_:IProtocol = IProtocol(OSGi.getInstance().getService(IProtocol));
         this.localeStruct = _loc2_.decode(LocalizedFileFormat, URLLoader(param1.target).data);
         this.registerValues();
      }

      private function onLoadingError(param1:ErrorEvent):void
      {
         this.localizationLogger.error("Localization not loaded: " + param1.errorID + ", " + param1.text);
      }

      private function registerValues():void
      {
         var _loc1_:StringPair = null;
         if (this.localeStruct.strings != null)
         {
            for each (_loc1_ in this.localeStruct.strings)
            {
               this.localeService.setText(_loc1_.key, _loc1_.value);
            }
         }
         if (this.localeStruct.images != null && this.localeStruct.images.length > 0)
         {
            this.createImages();
         }
         this.loadCompleteHandler();
      }

      private function createImages():void
      {
         var _loc2_:ImagePair = null;
         var _loc1_:Vector.<ByteArray> = new Vector.<ByteArray>();
         for each (_loc2_ in this.localeStruct.images)
         {
            _loc1_.push(_loc2_.value);
         }
         this.batchImageConstructor = new BatchImageConstructor();
         this.batchImageConstructor.addEventListener(Event.COMPLETE, this.onImagesComplete);
         this.batchImageConstructor.buildImages(_loc1_, 5);
      }

      private function onImagesComplete(param1:Event):void
      {
         var _loc2_:Vector.<BitmapData> = this.batchImageConstructor.images;
         this.batchImageConstructor = null;
         var _loc3_:Vector.<ImagePair> = this.localeStruct.images;
         var _loc4_:int = 0;
         while (_loc4_ < _loc2_.length)
         {
            this.localeService.setImage(_loc3_[_loc4_].key, _loc2_[_loc4_]);
            _loc4_++;
         }
      }
   }
}
