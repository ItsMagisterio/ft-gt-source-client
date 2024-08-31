package alternativa.network.handler
{
    import alternativa.network.ICommandHandler;
    import alternativa.osgi.service.network.INetworkService;
    import alternativa.network.ICommandSender;
    import flash.utils.ByteArray;
    import alternativa.service.IModelService;
    import alternativa.service.IResourceService;
    import alternativa.service.ISpaceService;
    import alternativa.network.AlternativaNetworkClient;
    import alternativa.resource.BatchLoaderManager;
    import __AS3__.vec.Vector;
    import alternativa.osgi.service.network.INetworkListener;
    import flash.utils.Timer;
    import alternativa.init.Main;
    import alternativa.protocol.Protocol;
    import alternativa.network.command.SpaceCommand;
    import alternativa.osgi.service.console.IConsoleService;
    import alternativa.osgi.service.loader.ILoaderService;
    import alternativa.osgi.service.storage.IStorageService;
    import flash.net.SharedObject;
    import alternativa.network.command.ControlCommand;
    import flash.events.TimerEvent;
    import alternativa.osgi.service.log.LogLevel;
    import alternativa.osgi.service.alert.IAlertService;
    import alternativa.osgi.service.log.ILogService;
    import alternativa.service.DummyLogService;
    import alternativa.register.SpaceInfo;
    import alternativa.resource.BatchResourceLoader;
    import alternativa.debug.IDebugCommandProvider;
    import alternativa.service.IClassService;
    import alternativa.resource.IResource;
    import alternativa.resource.ResourceInfo;
    import alternativa.register.ClassInfo;
    import alternativa.register.ClientClass;
    import alternativa.model.IModel;
    import alternativa.protocol.codec.ICodec;
    import alternativa.protocol.codec.NullMap;
    import flash.utils.IDataInput;
    import alternativa.service.IProtocolService;
    import __AS3__.vec.*;

    public class ControlCommandHandler implements ICommandHandler, INetworkService
    {

        private const pingDelay:int = 60000;

        private var sender:ICommandSender;
        private var hashCode:ByteArray;
        private var _modelRegister:IModelService;
        private var _resourceRegister:IResourceService;
        private var _spaceRegister:ISpaceService;
        private var spaceClient:AlternativaNetworkClient;
        private var batchLoaderManager:BatchLoaderManager;
        private var _server:String;
        private var _port:int;
        private var _proxyHost:String;
        private var _proxyPort:int;
        private var connected:Boolean = false;
        private var _ports:Array;
        private var _resourcesPath:String;
        private var listeners:Vector.<INetworkListener>;
        private var closed:Boolean = false;
        private var pingTimer:Timer;

        public function ControlCommandHandler(_server:String)
        {
            this.listeners = new Vector.<INetworkListener>();
            this._server = _server;
            this._resourceRegister = IResourceService(Main.osgi.getService(IResourceService));
            this._modelRegister = IModelService(Main.osgi.getService(IModelService));
            this._spaceRegister = ISpaceService(Main.osgi.getService(ISpaceService));
            var spaceProtocol:Protocol = new Protocol(Main.codecFactory, SpaceCommand);
            this.spaceClient = new AlternativaNetworkClient(_server, spaceProtocol);
            var networkService:INetworkService = (Main.osgi.getService(INetworkService) as INetworkService);
            _server = networkService.server;
            this._ports = networkService.ports;
            this._proxyHost = networkService.proxyHost;
            this._proxyPort = networkService.proxyPort;
            this._resourcesPath = networkService.resourcesPath;
            Main.osgi.unregisterService(INetworkService);
            Main.osgi.registerService(INetworkService, this);
        }
        public function open():void
        {
            IConsoleService(Main.osgi.getService(IConsoleService)).writeToConsoleChannel("CONTROLCMD", "socket open");
            this.connected = true;
            var loadingProgressId:int;
            var loaderService:ILoaderService = (Main.osgi.getService(ILoaderService) as ILoaderService);
            loaderService.loadingProgress.setProgress(loadingProgressId, 1);
            loaderService.loadingProgress.stopProgress(loadingProgressId);
            var ports:Array = INetworkService(Main.osgi.getService(INetworkService)).ports;
            this.port = ports[Main.currentPortIndex];
            var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
            storage.data.port = this._port;
            IConsoleService(Main.osgi.getService(IConsoleService)).writeToConsole("ControlCommandHandler socket opened");
            var i:int;
            while (i < this.listeners.length)
            {
                INetworkListener(this.listeners[i]).connect();
                i++;
            }
            this.sender.sendCommand(new ControlCommand(ControlCommand.HASH_REQUEST, "hashRequest", new Array()), false);
            this.pingTimer = new Timer(this.pingDelay, int.MAX_VALUE);
            this.pingTimer.addEventListener(TimerEvent.TIMER, this.ping);
            this.pingTimer.start();
        }
        private function ping(e:TimerEvent):void
        {
            this.sender.sendCommand(new ControlCommand(ControlCommand.LOG, "log", [LogLevel.LOG_INFO, "ping"]));
        }
        public function close():void
        {
            IConsoleService(Main.osgi.getService(IConsoleService)).writeToConsoleChannel("CONTROLCMD", "socket closed");
            this.pingTimer.stop();
            this.pingTimer.removeEventListener(TimerEvent.TIMER, this.ping);
            this.pingTimer = null;
            this.registerDummyLogService();
            var i:int;
            while (i < this.listeners.length)
            {
                INetworkListener(this.listeners[i]).disconnect();
                i++;
            }
            var alertService:IAlertService = (Main.osgi.getService(IAlertService) as IAlertService);
            alertService.showAlert((("Connection to server " + this._server) + " closed"));
            this.closed = true;
        }
        public function disconnect(errorMessage:String):void
        {
            var alertService:IAlertService;
            IConsoleService(Main.osgi.getService(IConsoleService)).writeToConsoleChannel("CONTROLCMD", "socket disconnect");
            this.registerDummyLogService();
            if ((!(this.connected)))
            {
                Main.tryNextPort();
            }
            else
            {
                if ((!(this.closed)))
                {
                    alertService = (Main.osgi.getService(IAlertService) as IAlertService);
                    alertService.showAlert(((("Connection to server " + this._server) + " failed. ERROR: ") + errorMessage));
                }
            }
        }
        private function registerDummyLogService():void
        {
            Main.osgi.unregisterService(ILogService);
            Main.osgi.registerService(ILogService, new DummyLogService());
        }
        public function executeCommand(commandsList:Object):void
        {
            var command:Object;
            var controlCommand:ControlCommand;
            var handler:ICommandHandler;
            var spaceSocket:ICommandSender;
            var info:SpaceInfo;
            var batchId:int;
            var resources:Array;
            var request:String;
            var _local_10:int;
            Main.writeToConsole("ControlCommandHandler executeCommand");
            var commands:Array = (commandsList as Array);
            var len:int = commands.length;
            var i:int;
            while (i < len)
            {
                command = commands[i];
                if ((command is ByteArray))
                {
                    if (this.hashCode == null)
                    {
                        this.hashCode = (command as ByteArray);
                        this.hashCode.position = 0;
                        Main.writeToConsole((("Hash принят (" + this.hashCode.bytesAvailable) + " bytes)"), 204);
                        this.sender.sendCommand(new ControlCommand(ControlCommand.HASH_ACCEPT, "hashAccepted", new Array()), false);
                    }
                }
                else
                {
                    if ((command is ControlCommand))
                    {
                        controlCommand = ControlCommand(command);
                        Main.writeToConsole(("     id: " + controlCommand.id));
                        Main.writeToConsole(("   name: " + controlCommand.name));
                        Main.writeToConsole((" params: " + controlCommand.params));
                        switch (controlCommand.id)
                        {
                            case ControlCommand.OPEN_SPACE:
                                handler = new SpaceCommandHandler(this.hashCode);
                                spaceSocket = ICommandSender(this.spaceClient.newConnection(this._port, handler));
                                info = new SpaceInfo(handler, spaceSocket, SpaceCommandHandler(handler).objectRegister);
                                ISpaceService(Main.osgi.getService(ISpaceService)).addSpace(info);
                                break;
                            case ControlCommand.LOAD_RESOURCES:
                                batchId = int(controlCommand.params[0]);
                                resources = (controlCommand.params[1] as Array);
                                this.dumpResourcesToConsole(batchId, resources);
                                this.batchLoaderManager.addLoader(new BatchResourceLoader(batchId, resources));
                                break;
                            case ControlCommand.UNLOAD_CLASSES_AND_RESOURCES:
                                this.unloadClasses((controlCommand.params[0] as Array));
                                this.unloadResources((controlCommand.params[1] as Array));
                                break;
                            case ControlCommand.COMMAND_REQUEST:
                                request = String(controlCommand.params[0]);
                                this.sender.sendCommand(new ControlCommand(ControlCommand.COMMAND_RESPONCE, "commandResponce", [IDebugCommandProvider(Main.debug).executeCommand(request)]));
                                break;
                            case ControlCommand.SERVER_MESSAGE:
                                _local_10 = int(controlCommand.params[0]);
                                Main.debug.showServerMessageWindow(String(controlCommand.params[1]));
                                break;
                            case ControlCommand.LOAD_CLASSES:
                                this.loadClasses(controlCommand);
                        }
                    }
                }
                i++;
            }
        }
        public function set port(value:int):void
        {
            this._port = value;
        }
        public function get commandSender():ICommandSender
        {
            return (this.sender);
        }
        public function set commandSender(sender:ICommandSender):void
        {
            Main.writeToConsole(("ControlCommandHandler set sender: " + sender));
            this.sender = sender;
            this.batchLoaderManager = new BatchLoaderManager(2, sender);
        }
        public function addEventListener(listener:INetworkListener):void
        {
            var index:int = this.listeners.indexOf(listener);
            if (index == -1)
            {
                this.listeners.push(listener);
            }
        }
        public function removeEventListener(listener:INetworkListener):void
        {
            var index:int = this.listeners.indexOf(listener);
            if (index != -1)
            {
                this.listeners.splice(index, 1);
            }
        }
        public function get server():String
        {
            return (this._server);
        }
        public function get ports():Array
        {
            return (this._ports);
        }
        public function get resourcesPath():String
        {
            return (this._resourcesPath);
        }
        public function get proxyHost():String
        {
            return (this._proxyHost);
        }
        public function get proxyPort():int
        {
            return (this._proxyPort);
        }
        private function unloadClasses(id:Array):void
        {
            var classRegister:IClassService;
            var length:uint = id.length;
            var i:uint;
            while (i < length)
            {
                classRegister = IClassService(Main.osgi.getService(IClassService));
                classRegister.destroyClass(id[i]);
                i++;
            }
        }
        private function unloadResources(resources:Array):void
        {
            var resource:IResource;
            var resourceRegister:IResourceService;
            var length:uint = resources.length;
            var i:uint;
            while (i < length)
            {
                resourceRegister = IResourceService(Main.osgi.getService(IResourceService));
                resource = resourceRegister.getResource(ResourceInfo(resources[i]).id);
                resource.unload();
                resourceRegister.unregisterResource(ResourceInfo(resources[i]).id);
                i++;
            }
        }
        private function dumpResourcesToConsole(batchId:int, resources:Array):void
        {
            var len:int;
            var j:int;
            Main.writeVarsToConsole("\n[ControlCommandHandler.executeCommand] LOAD [%1]", batchId);
            var i:int;
            while (i < resources.length)
            {
                len = (resources[i] as Array).length;
                j = 0;
                while (j < len)
                {
                    Main.writeToConsole(("[ControlCommandHandler.executeCommand] load resource id: " + ResourceInfo(resources[i][j]).id));
                    j++;
                }
                i++;
            }
        }
        private function loadClasses(controlCommand:ControlCommand):void
        {
            var logger:ILogService;
            var classInfo:ClassInfo;
            logger = null;
            classInfo = null;
            var classRegister:IClassService;
            var clientClass:ClientClass;
            var models:Vector.<String>;
            var numModels:int;
            var m:int;
            var modelId:String;
            var model:IModel;
            var paramsCodec:ICodec;
            var map:NullMap;
            var mapString:String;
            var modelParams:Object;
            var processId:int = int(controlCommand.params[0]);
            var classInfoArray:Array = (controlCommand.params[1] as Array);
            Main.writeVarsToConsoleChannel("LOAD CLASSES", "ControlCommandHandler LOAD_CLASSES");
            var reader:IDataInput = IDataInput(controlCommand.params[2]);
            var nullMap:NullMap = NullMap(controlCommand.params[3]);
            logger = (Main.osgi.getService(ILogService) as ILogService);
            var c:int;
            while (c < classInfoArray.length)
            {
                classInfo = ClassInfo(classInfoArray[c]);
                Main.writeVarsToConsoleChannel("LOAD CLASSES", ("   class id: " + classInfo.id));
                classRegister = IClassService(Main.osgi.getService(IClassService));
                if (classInfo.modelsToAdd != null)
                {
                    Main.writeVarsToConsoleChannel("LOAD CLASSES", ("   modelsToAdd: " + classInfo.modelsToAdd));
                }
                if (classInfo.modelsToRemove != null)
                {
                    Main.writeVarsToConsoleChannel("LOAD CLASSES", ("   modelsToRemove: " + classInfo.modelsToRemove));
                }
                models = clientClass.models;
                Main.writeVarsToConsoleChannel("LOAD CLASSES", ("   models: " + models));
                numModels = models.length;
                m = 0;
                while (m < numModels)
                {
                    modelId = models[m];
                    model = this._modelRegister.getModel(modelId);
                    paramsCodec = IProtocolService(Main.osgi.getService(IProtocolService)).codecFactory.getCodec(this._modelRegister.getModelsParamsStruct(modelId));
                    if (paramsCodec != null)
                    {
                        try
                        {
                            Main.writeVarsToConsoleChannel("LOAD CLASSES", "decode modelParams");
                            map = nullMap.clone();
                            mapString = "";
                            while (map.hasNextBit())
                            {
                                mapString = (mapString + ((!(!(map.getNextBit()))) ? "1" : "0"));
                            }
                            Main.writeVarsToConsoleChannel("LOAD CLASSES", ("   nullMap: " + mapString));
                            Main.writeVarsToConsoleChannel("LOAD CLASSES", " ");
                            modelParams = paramsCodec.decode(reader, nullMap, false);
                        }
                        catch (e:Error)
                        {
                            logger.log(LogLevel.LOG_ERROR, ((("[ControlCommandHandler.executeCommand] Error on model params decoding: " + e.toString()) + " ") + e.getStackTrace()));
                            Main.writeVarsToConsoleChannel("LOAD CLASSES", ((("Error on model params decoding. classInfo.name: " + classInfo.name) + "\n") + e.toString()));
                        }
                        if (modelParams != null)
                        {
                            Main.writeVarsToConsoleChannel("LOAD CLASSES", ((("   model " + modelId) + " params: ") + modelParams));
                            clientClass.setModelParams(modelId, modelParams);
                        }
                    }
                    m = (m + 1);
                }
                Main.writeToConsole(clientClass.toString());
                c = (c + 1);
            }
            this.sender.sendCommand(new ControlCommand(ControlCommand.CLASSES_LOADED, "classesLoaded", [processId]));
        }

    }
}
