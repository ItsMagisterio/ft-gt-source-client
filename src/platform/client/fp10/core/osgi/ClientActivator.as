package platform.client.fp10.core.osgi
{
   import alternativa.osgi.OSGi;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.osgi.service.display.IDisplay;
   import alternativa.osgi.service.launcherparams.ILauncherParams;
   import alternativa.osgi.service.logging.LogService;
   import alternativa.osgi.service.network.INetworkService;
   import alternativa.protocol.IProtocol;
   import alternativa.types.Long;
   import flash.utils.setTimeout;
   import platform.client.fp10.core.CoreCommands;
   import platform.client.fp10.core.logging.serverlog.ServerLogTarget;
   import platform.client.fp10.core.logging.serverlog.UncaughtErrorServerLog;
   import platform.client.fp10.core.logging.serverlog.UncaughtErrorServerLogImpl;
   import platform.client.fp10.core.network.command.ControlCommand;
   import platform.client.fp10.core.network.command.SpaceCommand;
   import platform.client.fp10.core.network.connection.ConnectionConnectParameters;
   import platform.client.fp10.core.network.connection.ConnectionInitializers;
   import platform.client.fp10.core.network.connection.ControlConnectionSender;
   import platform.client.fp10.core.network.connection.IConnection;
   import platform.client.fp10.core.network.connection.protection.PrimitiveProtectionContext;
   import platform.client.fp10.core.protocol.codec.ControlRootCodec;
   import platform.client.fp10.core.protocol.codec.DateCodec;
   import platform.client.fp10.core.protocol.codec.GameObjectCodec;
   import platform.client.fp10.core.protocol.codec.SpaceRootCodec;
   import platform.client.fp10.core.registry.GameTypeRegistry;
   import platform.client.fp10.core.registry.ModelRegistry;
   import platform.client.fp10.core.registry.ResourceRegistry;
   import platform.client.fp10.core.registry.SpaceRegistry;
   import platform.client.fp10.core.registry.impl.GameTypeRegistryImpl;
   import platform.client.fp10.core.registry.impl.ModelsRegistryImpl;
   import platform.client.fp10.core.registry.impl.ResourceRegistryImpl;
   import platform.client.fp10.core.registry.impl.SpaceRegistryImpl;
   import platform.client.fp10.core.resource.IResourceLoader;
   import platform.client.fp10.core.resource.IResourceLocalStorageInternal;
   import platform.client.fp10.core.resource.ResourceLoader;
   import platform.client.fp10.core.resource.ResourceLocalStorage;
   import platform.client.fp10.core.resource.ResourceTimer;
   import platform.client.fp10.core.resource.ResourceType;
   import platform.client.fp10.core.resource.types.EffectsResource;
   import platform.client.fp10.core.resource.types.ImageResource;
   import platform.client.fp10.core.resource.types.LocalizedImageResource;
   import platform.client.fp10.core.resource.types.MultiframeTextureResource;
   import platform.client.fp10.core.resource.types.SWFLibraryResource;
   import platform.client.fp10.core.resource.types.ScalableImageResource;
   import platform.client.fp10.core.resource.types.SoundResource;
   import platform.client.fp10.core.resource.types.TextureResource;
   import platform.client.fp10.core.service.IResourceTimer;
   import platform.client.fp10.core.service.address.AddressService;
   import platform.client.fp10.core.service.address.impl.AddressServiceFakeImpl;
   import platform.client.fp10.core.service.address.impl.AddressServiceImpl;
   import platform.client.fp10.core.service.errormessage.IErrorMessageService;
   import platform.client.fp10.core.service.errormessage.impl.MessageBoxService;
   import platform.client.fp10.core.service.loadingprogress.ILoadingProgressService;
   import platform.client.fp10.core.service.localstorage.IResourceLocalStorage;
   import platform.client.fp10.core.service.serverlog.impl.ServerLogPanel;
   import platform.client.fp10.core.service.transport.ITransportService;
   import platform.client.fp10.core.service.transport.impl.TransportService;
   import platform.client.fp10.core.type.IGameObject;
   import alternativa.init.Main;

   public class ClientActivator implements IBundleActivator
   {

      private var osgi:Class = Main.osgi;

      private var controlChannelConnection:IConnection;

      public function ClientActivator()
      {
         super();
      }

      public function start(param1:OSGi):void
      {
         this.osgi = param1;
         this.registerCodecs();
         this.registerServices();
         this.registerResources();
         setTimeout(this.completeInitialization, 0);
      }

      public function stop(param1:OSGi):void
      {
      }

      private function registerCodecs():void
      {
         var _loc1_:IProtocol = IProtocol(this.osgi.getService(IProtocol));
         _loc1_.registerCodecForType(ControlCommand, new ControlRootCodec());
         _loc1_.registerCodecForType(SpaceCommand, new SpaceRootCodec());
         _loc1_.registerCodecForType(IGameObject, new GameObjectCodec());
         _loc1_.registerCodecForType(Date, new DateCodec());
      }

      private function registerServices():void
      {
         this.osgi.registerService(GameTypeRegistry, new GameTypeRegistryImpl());
         this.osgi.registerService(SpaceRegistry, new SpaceRegistryImpl());
         this.osgi.registerService(ModelRegistry, new ModelsRegistryImpl(this.osgi));
         this.osgi.registerServiceMulti([IResourceLocalStorage, IResourceLocalStorageInternal], new ResourceLocalStorage(this.osgi));
         this.osgi.registerService(IResourceLoader, new ResourceLoader(this.osgi));
         this.osgi.registerServiceMulti([ResourceRegistry, ILoadingProgressService], new ResourceRegistryImpl(this.osgi));
         this.osgi.registerService(IErrorMessageService, new MessageBoxService(this.osgi));
         var _loc1_:ILauncherParams = ILauncherParams(this.osgi.getService(ILauncherParams));
         this.osgi.registerService(AddressService, Boolean(_loc1_.getParameter("noswfaddress")) ? new AddressServiceFakeImpl() : new AddressServiceImpl());
         this.osgi.registerService(IResourceTimer, new ResourceTimer(this.osgi));
         this.osgi.registerService(ITransportService, new TransportService());
      }

      private function registerResources():void
      {
         var _loc1_:ResourceRegistry = ResourceRegistry(this.osgi.getService(ResourceRegistry));
         _loc1_.registerTypeClasses(ResourceType.SWF_LIBRARY, SWFLibraryResource);
         _loc1_.registerTypeClasses(ResourceType.IMAGE, ImageResource);
         _loc1_.registerTypeClasses(ResourceType.SCALABLE_IMAGE, ScalableImageResource);
         _loc1_.registerTypeClasses(ResourceType.LOCALIZED_IMAGE, LocalizedImageResource);
         _loc1_.registerTypeClasses(ResourceType.MULTIFRAME_IMAGE, MultiframeTextureResource);
         _loc1_.registerTypeClasses(ResourceType.SOUND, SoundResource);
         _loc1_.registerTypeClasses(ResourceType.TEXTURE, TextureResource);
         _loc1_.registerTypeClasses(ResourceType.EFFECTS, EffectsResource);
      }

      private function createConnection():void
      {
         var _loc1_:IProtocol = IProtocol(this.osgi.getService(IProtocol));
         var _loc2_:ITransportService = ITransportService(this.osgi.getService(ITransportService));
         var _loc3_:INetworkService = INetworkService(this.osgi.getService(INetworkService));
         var _loc4_:ConnectionInitializers = new ConnectionInitializers(_loc1_, new ControlRootCodec(), _loc2_.controlCommandHandler, _loc3_.secure, Long.ZERO, PrimitiveProtectionContext.INSTANCE);
         this.controlChannelConnection = _loc2_.createConnection(_loc4_);
      }

      private function setupServerLog():void
      {
         var _loc4_:ServerLogTarget = null;
         var _loc5_:IDisplay = null;
         var _loc1_:LogService = LogService(this.osgi.getService(LogService));
         var _loc2_:ILauncherParams = ILauncherParams(this.osgi.getService(ILauncherParams));
         var _loc3_:String = String(_loc2_.getParameter("log_to_server"));
         if (Boolean(_loc3_))
         {
            _loc4_ = new ServerLogTarget(new ControlConnectionSender(), _loc3_);
            _loc1_.addLogTarget(_loc4_);
            if (Boolean(_loc2_.getParameter("show_server_logs")))
            {
               _loc5_ = IDisplay(this.osgi.getService(IDisplay));
               _loc4_.setLogPanel(new ServerLogPanel(_loc5_.stage));
            }
         }
      }

      private function completeInitialization():void
      {
         this.registerCommmands();
         this.createConnection();
         this.setupServerLog();
         this.connectToServer();
         this.setupUncaughtErrorLogSender();
      }

      private function setupTraceLogger():void
      {
         var _loc1_:LogService = LogService(this.osgi.getService(LogService));
         _loc1_.getLogger(new TraceLogger());
      }

      private function registerCommmands():void
      {
         new CoreCommands();
      }

      private function connectToServer():void
      {
         var _loc1_:INetworkService = INetworkService(this.osgi.getService(INetworkService));
         this.controlChannelConnection.connect(new ConnectionConnectParameters(_loc1_.controlServerAddress, _loc1_.controlServerPorts));
      }

      private function setupUncaughtErrorLogSender():void
      {
         this.osgi.registerService(UncaughtErrorServerLog, new UncaughtErrorServerLogImpl(new ControlConnectionSender()));
      }
   }
}
