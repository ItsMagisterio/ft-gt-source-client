package
{
    import flash.display.Sprite;
    import flash.display.Stage;
    import alternativa.init.OSGi;
    import alternativa.init.Main;
    import alternativa.init.BattlefieldModelActivator;
    import alternativa.init.BattlefieldSharedActivator;
    import alternativa.init.PanelModelActivator;
    import alternativa.init.TanksLocaleActivator;
    import alternativa.init.TanksServicesActivator;
    import alternativa.init.TanksWarfareActivator;
    import alternativa.init.BattlefieldGUIActivator;
    import alternativa.init.TanksLocaleRuActivator;
    import alternativa.init.TanksLocaleEnActivator;
    import alternativa.init.TanksFonts;
    import alternativa.object.ClientObject;
    import flash.display.BitmapData;
    import controls.Label;
    import alternativa.tanks.models.battlefield.BattlefieldModel;
    import alternativa.tanks.models.tank.TankModel;
    import logic.networking.Network;
    import flash.text.TextField;
    import logic.networking.INetworker;
    import com.reygazu.anticheat.events.CheatManagerEvent;
    import flash.display.StageScaleMode;
    import flash.display.StageAlign;
    import alternativa.service.Logger;
    import flash.net.SharedObject;
    import sineysoft.WebpSwc;
    import specter.utils.Logger;
    import alternativa.tanks.loader.ILoaderWindowService;
    import alternativa.tanks.loader.LoaderWindow;
    import logic.SocketListener;
    import alternativa.register.ObjectRegister;
    import logic.gui.IGTanksLoader;
    import logic.gui.GTanksLoaderWindow;
    import alternativa.osgi.service.storage.IStorageService;
    import logic.networking.connecting.ServerConnectionServiceImpl;
    import logic.networking.connecting.ServerConnectionService;
    import logic.resource.ResourceUtil;
    import alternativa.tanks.model.panel.PanelModel;
    import alternativa.tanks.model.panel.IPanel;
    import logic.networking.aes.AESEncrypterModel;
    import logic.networking.aes.IAESModel;
    import flash.display.StageQuality;
    import flash.display.Screen;
    //import flash.events.VsyncStateChangeAvailabilityEvent;
    import com.demonsters.debugger.MonsterDebugger;
    import flash.display.StageAspectRatio;
    import alternativa.tanks.services.battleinput.BattleInputService;
    import alternativa.tanks.service.settings.keybinding.KeysBindingService;
    import alternativa.tanks.service.settings.keybinding.KeysBindingServiceImpl;
    import alternativa.tanks.services.captcha.ICaptchaService;
    import alternativa.tanks.services.captcha.CaptchaService;
    import projects.tanks.clients.fp10.libraries.tanksservices.service.fullscreen.FullscreenService;
    import projects.tanks.clients.flash.commons.services.fullscreen.FullscreenServiceImpl;

    public class Game extends Sprite
    {

        public static var getInstance:Game;
        public static var currLocale:String;
        public static var local:Boolean = false;
        public static var _stage:Stage;
        private static var classInited:Boolean;
        //public static var httpServerURL:String = "http://cdn.primetanki.com:32286/";
        public static var httpServerURL:String = "http://185.249.198.242:8000/";
        public var osgi:OSGi;
        public var main:Main;
        public var battlefieldModel:BattlefieldModelActivator;
        public var battlefieldShared:BattlefieldSharedActivator;
        public var panel:PanelModelActivator;
        public var locale:TanksLocaleActivator;
        public var services:TanksServicesActivator;
        public var warfare:TanksWarfareActivator;
        public var battleGui:BattlefieldGUIActivator;
        public var localeRu:TanksLocaleRuActivator = new TanksLocaleRuActivator();
        public var localeEn:TanksLocaleEnActivator = new TanksLocaleEnActivator();
        public var fonts:TanksFonts = new TanksFonts();
        public var classObject:ClientObject;
        public var tankModel:TankModel;
        public var loaderObject:Object;

        public function Game()
        {
            if (numChildren > 1)
            {
                removeChildAt(0);
                removeChildAt(0);
            }
            super();
            start(stage); // remove when using the loader
        }
        public static function onUserEntered(e:CheatManagerEvent):void
        {
            var network:Network;
            var cheaterTextField:TextField;
            var osgi:OSGi = Main.osgi;
            if (osgi != null)
            {
                network = (osgi.getService(INetworker) as Network);
            }
            if (network != null)
            {
                network.send(("system;c01;" + e.data.variableName));
            }
            else
            {
                while (_stage.numChildren > 0)
                {
                    _stage.removeChildAt(0);
                }
                cheaterTextField = new TextField();
                cheaterTextField.textColor = 0xFF0000;
                cheaterTextField.text = "CHEATER!";
                _stage.addChild(cheaterTextField);
            }
        }

        public function activateAllModels():void
        {
            var localize:String;
            localize = null;
            this.main.start(this.osgi);
            this.fonts.start(this.osgi);
            try
            {
                localize = root.loaderInfo.url.split("locale=")[1];
                localize = localize.toLocaleLowerCase();
                localize = localize.substring(0, 2);
            }
            catch (e:Error)
            {
                try
                {
                    localize = _stage.loaderInfo.url.split("locale=")[1];
                    localize = localize.toLocaleLowerCase();
                    localize = localize.substring(0, 2);
                }
                catch (e:Error)
                {
                    localize = null;
                }
            }
            if (((localize == null) || (localize == "en")))
            {
                this.localeEn.start(this.osgi);
                currLocale = "EN";
            }
            else
            {
                this.localeRu.start(this.osgi);
                currLocale = "RU";
            }
            this.panel.start(this.osgi);
            this.locale.start(this.osgi);
            this.services.start(this.osgi);
        }
        //public function SUPER(stage:Stage):void
        public function start(stage:Stage):void
        {
            if (classInited)
            {
                return;
            }
            _stage = stage;
            classInited = true;
            focusRect = false;
            stage.focus = this;
            stage.quality = StageQuality.LOW;
            // stage.frameRate = 60;
            if (Screen)
            {
                stage.frameRate = (Screen.mainScreen.mode.refreshRate > 0) ? Screen.mainScreen.mode.refreshRate : 60;
            }
            stage.setAspectRatio(StageAspectRatio.LANDSCAPE);
            stage.autoOrients = false;

            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            //stage.addEventListener(VsyncStateChangeAvailabilityEvent.VSYNC_STATE_CHANGE_AVAILABILITY, handleVsync);
            _stage = stage;
            this.osgi = OSGi.init(false, stage, this, "127.0.0.1", [12345], "127.0.0.1", 12345, "res/", new alternativa.service.Logger(), SharedObject.getLocal("tanki"), "RU", Object);
            this.main = new Main();
            this.battlefieldModel = new BattlefieldModelActivator();
            this.panel = new PanelModelActivator();
            this.locale = new TanksLocaleActivator();
            this.services = new TanksServicesActivator();
            getInstance = this;
            this.activateAllModels();
            // WebpSwc.start();
            specter.utils.Logger.init();
            var loaderService:LoaderWindow = (Main.osgi.getService(ILoaderWindowService) as LoaderWindow);
            this.loaderObject = new Object();
            var listener:SocketListener = new SocketListener();
            var objectRegister:ObjectRegister = new ObjectRegister(listener);
            this.classObject = new ClientObject("sdf", null, "GTanks", listener);
            this.classObject.register = objectRegister;
            objectRegister.createObject("sdfsd", null, "GTanks");
            Main.osgi.registerService(IGTanksLoader, new GTanksLoaderWindow(IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["use_new_loader"]));
            var serverConnectionServie:ServerConnectionService = new ServerConnectionServiceImpl();
            serverConnectionServie.connect("socket.cfg", this.onConnected);
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            Main.osgi.registerService(KeysBindingService, new KeysBindingServiceImpl());
            Main.osgi.registerService(FullscreenService, new FullscreenServiceImpl(Main.stage, null));
            Main.osgi.registerService(ICaptchaService, new CaptchaService());
        }

        // private function handleVsync(e:VsyncStateChangeAvailabilityEvent):void
        // {
        //     e.target.removeEventListener(VsyncStateChangeAvailabilityEvent, handleVsync);
        //     if (e.available)
        //     {
        //         stage.vsyncEnabled = true;
        //     }
        // }

        private function onConnected():void
        {
            ResourceUtil.addEventListener(function():void
                {
                    onResourceLoaded();
                });
            ResourceUtil.loadResource();
        }
        // private function onResourceLoaded():void{
        // var netwoker:Network = (Main.osgi.getService(INetworker) as Network);
        // var lobbyServices:Lobby = new Lobby();
        // var panel:PanelModel = new PanelModel();
        // Main.osgi.registerService(IPanel, panel);
        // Main.osgi.registerService(ILobby, lobbyServices);
        // var auth:Authorization = new Authorization();
        // Main.osgi.registerService(IAuthorization, auth);
        // var aes:AESEncrypterModel = new AESEncrypterModel();
        // Main.osgi.registerService(IAESModel, aes);
        // netwoker.addListener(aes);
        // aes.resourceLoaded(netwoker);
        // }
        private function onResourceLoaded():void
        {
            var serverConnectionServie:ServerConnectionService = new ServerConnectionServiceImpl();
            // serverConnectionServie.connect("socket.cfg?rand=" + Math.random());
            var lobbyServices:Lobby = new Lobby();
            var panel:PanelModel = new PanelModel();
            Main.osgi.registerService(IPanel, panel);
            Main.osgi.registerService(ILobby, lobbyServices);
            var auth:Authorization = new Authorization();
            Main.osgi.registerService(IAuthorization, auth);
            Authorization(Main.osgi.getService(IAuthorization)).init();
            (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).setFullAndClose(null);
            (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).hideLoaderWindow();
            (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).lockLoaderWindow();
            PanelModel(Main.osgi.getService(IPanel)).unlock();
        }

    }
} // package