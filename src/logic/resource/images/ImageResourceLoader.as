// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.resource.images.ImageResourceLoader

package logic.resource.images
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.net.URLRequest;
    import alternativa.osgi.service.storage.IStorageService;
    import alternativa.init.Main;
    import com.lorentz.SVG.display.SVGImage;
    import logic.resource.ResourceUtil;
    import flash.display.BitmapData;
    import specter.resource.ImageType;
    import flash.net.URLLoaderDataFormat;
    import sineysoft.WebpSwc;
    import flash.utils.ByteArray;
    import logic.resource.failed.FailedResource;
    import flash.events.IOErrorEvent;
    import alternativa.resource.StubBitmapData;
    import logic.resource.cache.CacheURLLoader;
    import flash.display.Loader;
    import flash.display.Bitmap;
    import specter.utils.Logger;
    import __AS3__.vec.*;
    import alternativa.utils.ByteArrayMap;
    import alternativa.utils.TARAParser;
    import alternativa.startup.CacheURLPTLoader;

    public class ImageResourceLoader
    {

        public var path:String;
        public var list:ImageResourceList;
        public var inbattleList:ImageResourceList;
        public var queue:Vector.<String>;
        public var status:int = 0;
        private var length:int = 0;
        private var config:Dictionary;
        private var loader:CacheURLPTLoader;
        private var resourceMap:ByteArrayMap;
        private var multiframeResources:Object;
        private var multiFramesLoader:URLLoader = new URLLoader();

        public function ImageResourceLoader(path:String)
        {
            this.path = path;
            this.list = new ImageResourceList();
            this.inbattleList = new ImageResourceList();
            this.queue = new Vector.<String>();
            this.config = new Dictionary();

            var request:URLRequest = new URLRequest("http://185.249.198.242:8000/resourceMultiframes.json");
            multiFramesLoader.addEventListener(Event.COMPLETE, multiframeDataLoaded);
            multiFramesLoader.load(request);
        }
        function multiframeDataLoaded(event:Event):void
        {
            var jsonData:String = multiFramesLoader.data as String;
            try
            {
                this.multiframeResources = JSON.parse(jsonData);
            }
            catch (error:Error)
            {
                trace("Error parsing JSON:", error.message);
            }
            this.loader = new CacheURLPTLoader();
            this.loader.addEventListener(this.parse);
            this.loader.load(path);
        }
        public function reload():void
        {
            // this.list.clear();
            // this.list = new ImageResourceList();
            // this.list.images = this.inbattleList.images;
            // this.inbattleList = new ImageResourceList();
            // this.queue = new Vector.<String>();
            // var loader:URLLoader = new URLLoader();
            // loader.addEventListener(Event.COMPLETE, this.parse);
            // loader.load(new URLRequest(this.path));
        }
        private function parse():void
        {
            this.resourceMap = TARAParser.parse(this.loader.data as ByteArray);

            for (var key:String in resourceMap.data)
            {
                this.queue.push(key);
            }
            this.loadQueue();
        }
        private function loadQueue():void
        {
            for each (var key:String in this.queue)
            {
                this.loadImage(key);
                this.length++;
            }
        }
        private function loadImage(resourceId:String, isFirst:* = true):void
        {
            var nativeLoader:Loader = new Loader();
            nativeLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
                {
                    var bitmapData:BitmapData = Bitmap(e.target.content).bitmapData;
                    var multiframeData:MultiframeResourceData = null;
                    for each (var item:Object in multiframeResources.items)
                    {
                        if (item.name == resourceId.split(".")[0])
                        {
                            multiframeData = new MultiframeResourceData();
                            multiframeData.fps = item.fps;
                            multiframeData.widthFrame = item.frame_width;
                            multiframeData.heigthFrame = item.frame_heigth;
                            multiframeData.numFrames = item.num_frames;
                        }
                    }

                    var res:ImageResource = new ImageResource(bitmapData, resourceId.split(".")[0], false, multiframeData);
                    list.add(res);
                    inbattleList.add(res);
                    config[resourceId.split(".")[0]] = res;

                    length--;
                    trace("Resources remaining: ", length);
                    if (length == 0)
                    {
                        status = 1;
                        ResourceUtil.onCompleteLoading();
                    }
                });
            nativeLoader.loadBytes(resourceMap.getValue(resourceId));
            // TODO: separate lists

        }
        public function loadForBattle(id:String):void
        {
            ResourceUtil.onCompleteLoading();
        }
        public function loadFor(id:String):void
        {
            ResourceUtil.onCompleteLoading();
        }

    }
} // package scpacker.resource.images