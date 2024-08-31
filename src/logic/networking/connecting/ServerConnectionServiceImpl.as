// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// scpacker.networking.connecting.ServerConnectionServiceImpl

package logic.networking.connecting
{
    import flash.net.URLLoader;
    import logic.networking.Network;
    import specter.utils.Logger;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;
    import flash.net.URLRequest;
    import alternativa.init.Main;
    import logic.networking.INetworker;

    public class ServerConnectionServiceImpl implements ServerConnectionService
    {

        private var loader:URLLoader;
        private var networker:Network;
        private var connectionListener:Function;

        public function connect(urlConfig:String, connectionListener:Function):void
        {
            this.networker = new Network();
            this.connectionListener = connectionListener;
            this.networker.connectionListener = connectionListener;
            Logger.log("Created listener for connection");
            this.loader = new URLLoader();
            this.loader.dataFormat = URLLoaderDataFormat.TEXT;
            this.loader.addEventListener(Event.COMPLETE, this.onComplete);
            this.loader.load(new URLRequest(urlConfig));
        }
        private function onComplete(e:Event):void
        {
            this.loader.removeEventListener(Event.COMPLETE, this.onComplete);
            var json:Object = JSON.parse(this.loader.data);
            var ip:String = "127.0.0.1";
            var port:int = json.port;
            this.networker.connect(ip, port);
            Logger.log(((("Connected to: " + ip) + ":") + port));
            Main.osgi.registerService(INetworker, this.networker);
        }

    }
} // package scpacker.networking.connecting