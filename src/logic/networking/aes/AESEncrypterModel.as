// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.networking.aes.AESEncrypterModel

package logic.networking.aes
{
    import logic.networking.INetworkListener;
    import logic.networking.Network;
    import flash.display.Loader;
    import flash.utils.ByteArray;
    import flash.system.LoaderContext;
    import logic.networking.commands.Type;
    import specter.utils.Logger;
    import flash.system.ApplicationDomain;
    import logic.resource.cache.CacheURLLoader;
    import flash.events.Event;
    import logic.networking.commands.Command;
    import alternativa.init.Main;
    import logic.gui.IGTanksLoader;
    import logic.gui.GTanksLoaderWindow;

    public class AESEncrypterModel implements INetworkListener
    {

        private var netwoker:Network;
        private var loader:Loader;

        public function onData(data:Command):void
        {
            var aesBytes:ByteArray;
            var array:Array;
            var byte:String;
            var loaderContext:LoaderContext;
            if (data.type == Type.SYSTEM)
            {
                if (data.args[0] == "set_aes_data")
                {
                    Logger.log("set_aes_data comming");
                    try
                    {
                        aesBytes = new ByteArray();
                        array = data.args[1].split(",");
                        for each (byte in array)
                        {
                            aesBytes.writeByte(parseInt(byte));
                        }
                        loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
                        if (CacheURLLoader.isDesktop)
                        {
                            loaderContext.allowLoadBytesCodeExecution = true;
                        }
                        this.loader = new Loader();
                        this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onAesLoadComplete);
                        this.loader.loadBytes(aesBytes, loaderContext);
                    }
                    catch (e:Error)
                    {
                        Logger.warn(("set_aes_data error: " + e.getStackTrace()));
                    }
                    Logger.log("set_aes_data end");
                }
            }
        }
        private function onAesLoadComplete(e:Event = null):void
        {
            this.netwoker.AESDecrypter = new (Class(this.loader.contentLoaderInfo.applicationDomain.getDefinition("Main")))();
            Authorization(Main.osgi.getService(IAuthorization)).init();
        }
        public function resourceLoaded(netwoker:Network):void
        {
            this.netwoker = netwoker;
            netwoker.send("system;get_aes_data");
            // (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).hideLoaderWindow();
            // (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).lockLoaderWindow();
        }

    }
} // package scpacker.networking.aes