package alternativa.resource.loaders
{
    import flash.events.EventDispatcher;
    import flash.display.BitmapData;
    import flash.system.LoaderContext;
    import __AS3__.vec.Vector;
    import flash.events.Event;
    import alternativa.engine3d.loaders.events.LoaderProgressEvent;
    import flash.events.IOErrorEvent;
    import alternativa.engine3d.loaders.events.LoaderEvent;
    import alternativa.resource.loaders.events.BatchTextureLoaderErrorEvent;
    import flash.events.ErrorEvent;
    import __AS3__.vec.*;

    [Event(name="loaderProgress", type="alternativa.engine3d.loaders.events.LoaderProgressEvent")]
    [Event(name="partComplete", type="alternativa.engine3d.loaders.events.LoaderEvent")]
    [Event(name="partOpen", type="alternativa.engine3d.loaders.events.LoaderEvent")]
    [Event(name="loaderError", type="alternativa.resource.loaders.events.BatchTextureLoaderErrorEvent")]
    [Event(name="complete", type="flash.events.Event")]
    [Event(name="open", type="flash.events.Event")]
    public class BatchTextureLoader extends EventDispatcher
    {

        private static var stubBitmapData:BitmapData;
        private static const IDLE:int = 0;
        private static const LOADING:int = 1;

        private var state:int = 0;
        private var textureLoader:TextureLoader;
        private var loaderContext:LoaderContext;
        private var baseURL:String;
        private var batch:Object;
        private var textureNames:Vector.<String>;
        private var textureIndex:int;
        private var numTextures:int;
        private var _textures:Object;

        public function get textures():Object
        {
            return (this._textures);
        }
        public function close():void
        {
            if (this.state == LOADING)
            {
                this.textureLoader.close();
                this.cleanup();
                this._textures = null;
                this.state = IDLE;
            }
        }
        public function unload():void
        {
            this._textures = null;
        }
        public function load(baseURL:String, batch:Object, loaderContext:LoaderContext = null):void
        {
            var textureName:* = null;
            if (baseURL == null)
            {
                throw (ArgumentError("Parameter baseURL cannot be null"));
            }
            if (batch == null)
            {
                throw (ArgumentError("Parameter batch cannot be null"));
            }
            this.baseURL = baseURL;
            this.batch = batch;
            this.loaderContext = loaderContext;
            if (this.textureLoader == null)
            {
                this.textureLoader = new TextureLoader();
            }
            else
            {
                this.close();
            }
            this.textureLoader.addEventListener(Event.OPEN, this.onTextureLoadingStart);
            this.textureLoader.addEventListener(LoaderProgressEvent.LOADER_PROGRESS, this.onProgress);
            this.textureLoader.addEventListener(Event.COMPLETE, this.onTextureLoadingComplete);
            this.textureLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadingError);
            this.textureNames = new Vector.<String>();
            for (textureName in batch)
            {
                this.textureNames.push(textureName);
            }
            this.numTextures = this.textureNames.length;
            this.textureIndex = 0;
            this._textures = {}
            if (hasEventListener(Event.OPEN))
            {
                dispatchEvent(new Event(Event.OPEN));
            }
            this.state = LOADING;
            this.loadNextTexture();
        }
        private function loadNextTexture():void
        {
            var info:TextureInfo = this.batch[this.textureNames[this.textureIndex]];
            var opacityMapFileUrl:String = (((info.opacityMapFileName == null) || (info.opacityMapFileName == "")) ? null : (this.baseURL + info.opacityMapFileName));
            this.textureLoader.load((this.baseURL + info.diffuseMapFileName), opacityMapFileUrl, this.loaderContext);
        }
        private function onTextureLoadingStart(e:Event):void
        {
            if (hasEventListener(LoaderEvent.PART_OPEN))
            {
                dispatchEvent(new LoaderEvent(LoaderEvent.PART_OPEN, this.numTextures, this.textureIndex));
            }
        }
        private function onProgress(e:LoaderProgressEvent):void
        {
            var totalProgress:Number = NaN;
            if (hasEventListener(LoaderProgressEvent.LOADER_PROGRESS))
            {
                totalProgress = ((this.textureIndex + e.totalProgress) / this.numTextures);
                dispatchEvent(new LoaderProgressEvent(LoaderProgressEvent.LOADER_PROGRESS, this.numTextures, this.textureIndex, totalProgress, e.bytesLoaded, e.bytesTotal));
            }
        }
        private function onTextureLoadingComplete(e:Event):void
        {
            this._textures[this.textureNames[this.textureIndex]] = this.textureLoader.bitmapData;
            this.tryNextTexure();
        }
        private function onLoadingError(e:ErrorEvent):void
        {
            var textureName:String = this.textureNames[this.textureIndex];
            this._textures[textureName] = this.getStubBitmapData();
            dispatchEvent(new BatchTextureLoaderErrorEvent(BatchTextureLoaderErrorEvent.LOADER_ERROR, textureName, e.text));
            this.tryNextTexure();
        }
        private function tryNextTexure():void
        {
            if (this.state == IDLE)
            {
                return;
            }
            if (hasEventListener(LoaderEvent.PART_COMPLETE))
            {
                dispatchEvent(new LoaderEvent(LoaderEvent.PART_COMPLETE, this.numTextures, this.textureIndex));
            }
            if (++this.textureIndex == this.numTextures)
            {
                this.cleanup();
                this.removeEventListeners();
                this.state = IDLE;
                if (hasEventListener(Event.COMPLETE))
                {
                    dispatchEvent(new Event(Event.COMPLETE));
                }
            }
            else
            {
                this.loadNextTexture();
            }
        }
        private function removeEventListeners():void
        {
            this.textureLoader.removeEventListener(Event.OPEN, this.onTextureLoadingStart);
            this.textureLoader.removeEventListener(LoaderProgressEvent.LOADER_PROGRESS, this.onProgress);
            this.textureLoader.removeEventListener(Event.COMPLETE, this.onTextureLoadingComplete);
            this.textureLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadingError);
        }
        private function cleanup():void
        {
            this.loaderContext = null;
            this.textureNames = null;
        }
        private function getStubBitmapData():BitmapData
        {
            var size:uint;
            var i:uint;
            var j:uint;
            if (stubBitmapData == null)
            {
                size = 20;
                stubBitmapData = new BitmapData(size, size, false, 0);
                i = 0;
                while (i < size)
                {
                    j = 0;
                    while (j < size)
                    {
                        stubBitmapData.setPixel(((Boolean((i % 2))) ? int(j) : int((j + 1))), i, 0xFF00FF);
                        j = (j + 2);
                    }
                    i++;
                }
            }
            return (stubBitmapData);
        }

    }
}
