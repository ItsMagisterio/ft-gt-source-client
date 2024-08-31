// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.resource.images.ImageResource

package logic.resource.images
{
    import flash.display.Loader;
    import __AS3__.vec.Vector;
    import alternativa.model.IResourceLoadListener;
    import specter.resource.ImageType;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import logic.resource.cache.CacheURLLoader;
    import sineysoft.WebpSwc;
    import flash.utils.ByteArray;
    import flash.display.Bitmap;
    import alternativa.resource.StubBitmapData;
    import flash.events.ErrorEvent;
    import __AS3__.vec.*;

    public class ImageResource
    {

        public var bitmapData:Object;
        public var id:String;
        public var animatedMaterial:Boolean;
        public var multiframeData:MultiframeResourceData;
        public var url:String;
        private var imageLoader:Object;
        private var nativeLoader:Loader;
        private var completeLoadListeners:Vector.<IResourceLoadListener>;
        private var loading:Boolean = false;
        public var isWebP:Boolean = false;
        public var isSVG:Boolean = false;
        public var type:uint;

        public function ImageResource(bitmapData:Object, id:String, animatedMaterial:Boolean, multiframeData:MultiframeResourceData)
        {
            this.bitmapData = bitmapData;
            this.id = id;
            this.animatedMaterial = animatedMaterial;
            this.multiframeData = multiframeData;
            this.type = ImageType.COMMON;
            this.completeLoadListeners = new Vector.<IResourceLoadListener>();
        }
        public function set completeLoadListener(object:IResourceLoadListener):void
        {
            this.completeLoadListeners.push(object);
        }
        public function load():void
        {
            if (((this.loaded()) || (this.loading)))
            {
                return;
            }

        }
        private function onPictureLoadingComplete(e:Event):void
        {
            var listener:IResourceLoadListener;
            if (this.type == ImageType.WEBP)
            {
                this.bitmapData = WebpSwc.decode(ByteArray(e.currentTarget.data));
                this.destroyImageLoader();
                if (this.completeLoadListeners != null)
                {
                    for each (listener in this.completeLoadListeners)
                    {
                        listener.resourceLoaded(this);
                    }
                }
            }
            else
            {
                this.nativeLoader = new Loader();
                this.nativeLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onNativeLoaderComplete);
                this.nativeLoader.loadBytes(e.target.data);
            }
        }
        private function onNativeLoaderComplete(e:Event):void
        {
            var listener:IResourceLoadListener;
            this.bitmapData = Bitmap(e.target.content).bitmapData;
            this.destroyImageLoader();
            if (this.completeLoadListeners != null)
            {
                for each (listener in this.completeLoadListeners)
                {
                    listener.resourceLoaded(this);
                }
            }
        }
        private function destroyImageLoader():void
        {
            if (this.imageLoader == null)
            {
                return;
            }
            if (this.type == ImageType.WEBP)
            {
                this.imageLoader.removeEventListener(Event.COMPLETE, this.onPictureLoadingComplete);
                this.imageLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onPictureLoadingError);
            }
            else
            {
                if (this.type == ImageType.COMMON)
                {
                    this.imageLoader.removeEventListener(Event.COMPLETE, this.onPictureLoadingComplete);
                    this.imageLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onPictureLoadingError);
                    if (this.nativeLoader != null)
                    {
                        this.nativeLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onNativeLoaderComplete);
                    }
                }
            }
            this.imageLoader = null;
            this.loading = false;
        }
        private function onPictureLoadingError(e:ErrorEvent):void
        {
            var listener:IResourceLoadListener;
            this.bitmapData = new StubBitmapData(0xFF0000);
            this.destroyImageLoader();
            if (this.completeLoadListeners != null)
            {
                for each (listener in this.completeLoadListeners)
                {
                    listener.resourceLoaded(this);
                }
            }
        }
        public function loaded():Boolean
        {
            // return ((!(this.bitmapData == null)) && (!(this.bitmapData is String)));
            return true;
        }
        public function toString():String
        {
            return (((((((((('ImageResource:[ID: "' + this.id) + '"; animated: ') + this.animatedMaterial) + '; URL:"') + this.url) + '"; loading: ') + this.loading) + "; data: ") + this.bitmapData) + "]");
        }
        public function clone():ImageResource
        {
            return (new ImageResource(this.bitmapData, this.id, this.animatedMaterial, this.multiframeData));
        }

    }
} // package scpacker.resource.images