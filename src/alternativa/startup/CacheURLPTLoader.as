package alternativa.startup {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import by.blooddy.crypto.MD5;
import by.blooddy.crypto.events.ProcessEvent;
import flash.net.SharedObject;

public class CacheURLPTLoader {
    private var onCompleteFunction:Function;

    public var data:ByteArray;

    private var encodedFileName:String;

    private var url:String;

    private var cacheDirectory:File;

    private var filename:String;
    private var skipCheck:Boolean = false;

    public function CacheURLPTLoader() {
        if (StartupSettings.isDesktop) {
            this.cacheDirectory = File.applicationStorageDirectory.resolvePath("cache");
            if (!this.cacheDirectory.exists) {
                this.cacheDirectory.createDirectory();
            } else if (!this.cacheDirectory.isDirectory) {
                throw new Error("Cannot create directory." + this.cacheDirectory.nativePath + " is already exists.");
            }
        }
    }

    public function load(filename:String):void {
        this.filename = filename;
        this.url = Game.httpServerURL + filename;
        this.encodedFileName = URLEncoder.encode(filename);
        loadHashes();
    }

    private function onIOError(param1:Event):void {
        throw new Error("IO error for load file " + filename)
    }

    private function onSecurityError(param1:Event):void {
        throw new Error("Security error for load file " + filename)
    }


    public function onBytesLoaded(e:Event):void {
        this.data = e.target.data;
        var file:File = this.cacheDirectory.resolvePath(this.encodedFileName);
        var fileStream:FileStream = new FileStream();
        fileStream.open(file, FileMode.UPDATE);
        fileStream.writeBytes(e.target.data);
        fileStream.close();

        this.onCompleteFunction();
    }

    private var so:SharedObject;
    private var hashesObj:Object;

    private function loadHashes():void {
        so = SharedObject.getLocal("fileHashes");
        var loader:URLLoader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.TEXT;
        loader.addEventListener(Event.COMPLETE, this.onLoadedHashes);
        loader.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError);
        loader.load(new URLRequest(Game.httpServerURL + "hashes.json?" + Math.random()));
    }

    public function onLoadedHashes(e:Event):void {
        hashesObj = JSON.parse(e.target.data);
        var newHash:String = hashesObj[this.filename];
        var oldHash:String = so.data[this.filename];
        
        if (oldHash != newHash) {
            // Hash has changed, delete cached files and reload from server
            deleteCachedFiles();
            loadFileFromServer();
            
            // Update the stored hash
            so.data[this.filename] = newHash;
            so.flush();
        } else {
            // Hash hasn't changed, load from cache if it exists
            var cacheFile:File = this.cacheDirectory.resolvePath(this.encodedFileName);
            if (cacheFile.exists) {
                loadFromCache(cacheFile);
            } else {
                loadFileFromServer();
            }
        }
    }

    private function deleteCachedFiles():void {
        var cacheFile:File = this.cacheDirectory.resolvePath(this.encodedFileName);
        if (cacheFile.exists) {
            cacheFile.deleteFile();
        }
    }

    private function loadFromCache(cacheFile:File):void {
        var stream:FileStream = new FileStream();
        stream.open(cacheFile, FileMode.READ);
        var bytes:ByteArray = new ByteArray();
        stream.readBytes(bytes);
        stream.close();
        
        this.data = bytes;
        this.onCompleteFunction();
    }

    // public function onLoadedHashes(e:Event):void {
    //     var obj:Object = JSON.parse(e.target.data);
    //     var actualHash:String = obj[this.filename];

    //     var cacheFile:File = this.cacheDirectory.resolvePath(this.encodedFileName);
    //     if (cacheFile.exists) {
    //         var stream:FileStream = new FileStream();
    //         stream.open(cacheFile, FileMode.READ);
    //         var bytes:ByteArray = new ByteArray();
    //         stream.readBytes(bytes);
    //         stream.close();

    //         if (!this.skipCheck)
    //         {
    //             var md5:MD5 = new MD5();
    //             md5.hashBytes(bytes);
    //             md5.addEventListener(ProcessEvent.COMPLETE, function(event:ProcessEvent):void {
    //                 var localHash:String = event.data;
    //                 if (localHash != actualHash) {
    //                     cacheFile.deleteFile();
    //                     loadFileFromServer();
    //                 } else {
    //                     data = bytes;
    //                     onCompleteFunction();
    //                 }
    //             });
    //             md5.addEventListener(ProcessEvent.ERROR, function(event:ProcessEvent):void {
    //                 var error:Error = event.data;
    //                 trace(error);
    //             });
    //         } else {
    //             this.data = bytes;
    //             this.onCompleteFunction();
    //         }


    //     } else {
    //         loadFileFromServer();
    //     }
    // }

    private function loadFileFromServer():void {
        var loader:URLLoader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.BINARY;
        loader.addEventListener(Event.COMPLETE, this.onBytesLoaded, false, 0, true);
        loader.addEventListener(IOErrorEvent.IO_ERROR, this.onIOError, false, 0, true);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecurityError, false, 0, true);
        loader.load(new URLRequest(Game.httpServerURL + this.filename));
    }

    public function addEventListener(func:Function):void {
        this.onCompleteFunction = func;
    }
}
}
