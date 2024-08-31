// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.resource.SoundResourceLoader

package logic.resource
{
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.media.Sound;
    import logic.resource.cache.SoundCacheLoader;
    import flash.events.IOErrorEvent;
    import alternativa.init.Main;
    import flash.events.SecurityErrorEvent;
    import flash.media.SoundLoaderContext;
    import flash.net.URLLoaderDataFormat;
    import alternativa.utils.ByteArrayMap;
    import alternativa.utils.TARAParser;
    import flash.utils.ByteArray;
    import alternativa.startup.CacheURLPTLoader;

    public class SoundResourceLoader
    {

        private var path:String;
        public var list:SoundResourcesList;
        public var status:int = 0;
        private var loader:CacheURLPTLoader;
        private var resourceMap:ByteArrayMap;
        private var queue:Vector.<String>;
        private var length:int = 0;

        public function SoundResourceLoader(path:String)
        {
            this.path = path;
            this.list = new SoundResourcesList();
            this.queue = new Vector.<String>();
            this.load();
        }
        private function load():void
        {
            this.loader = new CacheURLPTLoader();
            this.loader.addEventListener(this.parse);
            this.loader.load(path);
        }
        private function parse():void
        {
            this.resourceMap = TARAParser.parse(this.loader.data as ByteArray);

            for (var key:String in resourceMap.data)
            {
                this.queue.push(key);
                this.length++;
            }
            this.loadQueue();
        }
        private function loadQueue():void
        {
            var file:String;
            for each (file in this.queue)
            {
                this.loadSound(file);
            }
        }
        private function loadSound(resourceId:String):void
        {
            var soundLoader:Sound = new Sound();
            soundLoader.loadCompressedDataFromByteArray(resourceMap.getValue(resourceId), resourceMap.getValue(resourceId).length);
            this.length--;
            if (this.length == 0)
            {
                status = 1;
                ResourceUtil.onCompleteLoading();
            }
            list.add(new SoundResource(soundLoader, resourceId.split(".")[0]));
        }

    }
} // package scpacker.resource