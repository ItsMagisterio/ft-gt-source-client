// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.resource.cache.CacheURLLoader

package logic.resource.cache
{
    import flash.net.URLLoader;
    import flash.utils.getDefinitionByName;
    import flash.system.Capabilities;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;
    import alternativa.init.Main;
    import alternativa.console.IConsole;
    import flash.events.Event;
    import flash.utils.ByteArray;

    public class CacheURLLoader extends URLLoader
    {

        private var url:String;
        private var encodedUrl:String;
        private var cacheDirectory:Object;
        private var FileClass:Class;
        private var FileStreamClass:Class;
        private var FileModeClass:Class;

        public function CacheURLLoader()
        {
            if (isDesktop)
            {
                this.FileClass = (getDefinitionByName("flash.filesystem.File") as Class);
                this.FileStreamClass = (getDefinitionByName("flash.filesystem.FileStream") as Class);
                this.FileModeClass = (getDefinitionByName("flash.filesystem.FileMode") as Class);
                this.cacheDirectory = this.FileClass.applicationStorageDirectory.resolvePath("cache");
                if ((!(this.cacheDirectory.exists)))
                {
                    this.cacheDirectory.createDirectory();
                }
                else
                {
                    if ((!(this.cacheDirectory.isDirectory)))
                    {
                        throw (new Error((("Cannot create directory." + this.cacheDirectory.nativePath) + " is already exists.")));
                    }
                }
            }
        }
        public static function get isDesktop():Boolean
        {
            return ((Capabilities.playerType == "Desktop") || (Capabilities.playerType == "External"));
        }

        override public function load(param1:URLRequest):void
        {
            if ((!(isDesktop)))
            {
                super.load(param1);
                return;
            }
            this.url = param1.url;
            if (this.url.indexOf("?") >= 0)
            {
                this.url = this.url.split("?")[0];
            }
            var _loc2_:Object = this.cacheDirectory.resolvePath(this.url);
            super.addEventListener(IOErrorEvent.IO_ERROR, this.onError, false, 0, true);
            super.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError, false, 0, true);
            super.load(new URLRequest(_loc2_.url));
        }
        private function loadFromServer(param1:URLRequest):void
        {
        }
        private function onError(param1:IOErrorEvent):void
        {
            (Main.osgi.getService(IConsole) as IConsole).addLine(("Error load resource: " + this.url));
        }
        private function onComplete(param1:Event):void
        {
            var e:Event = param1;
            var file:Object = new this.FileClass(this.cacheDirectory.resolvePath(this.encodedUrl).nativePath);
            var fileStream:Object = new this.FileStreamClass();
            try
            {
                fileStream.open(file, this.FileModeClass.WRITE);
                fileStream.writeBytes((URLLoader(e.target).data as ByteArray));
                fileStream.close();
                return;
            }
            catch (e:Error)
            {
                throw (new IOErrorEvent(("CacheURLLoader error! " + e.message)));
            }
        }

    }
} // package scpacker.resource.cache