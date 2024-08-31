package alternativa.tanks.gui
{
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import alternativa.osgi.service.locale.ILocaleService;

    import flash.net.URLLoader;

    import forms.TankWindowWithHeader;
    import forms.stat.ReferralWindowBigButton;
    import controls.DefaultButton;
    import controls.TankWindow;
    import controls.TankWindowInner;
    import flash.display.Bitmap;
    import forms.stat.ReferralStatList;
    import flash.display.DisplayObject;
    import assets.icons.CheckIcons;
    import controls.Label;
    import controls.TankInput;
    import controls.TextArea;
    import flash.display.Loader;
    import alternativa.tanks.model.panel.IPanel;
    import assets.Diamond;
    import alternativa.init.Main;
    import alternativa.service.IModelService;
    import alternativa.tanks.model.panel.PanelModel;
    import alternativa.tanks.locale.constants.TextConst;
    import controls.TankWindowHeader;
    import flash.events.MouseEvent;
    import alternativa.tanks.locale.constants.ImageConst;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    import flash.system.LoaderContext;
    import flash.system.ApplicationDomain;
    import flash.net.URLRequest;
    import flash.events.Event;
    import forms.RegisterForm;
    import projects.tanks.client.panel.model.referals.RefererIncomeData;
    import flash.system.System;
    import alternativa.tanks.gui.containers.Container;
    import alternativa.tanks.gui.icons.GiftRollerListBg;
    import alternativa.tanks.model.profile.GiftRollerRenderer;
    import alternativa.tanks.gui.icons.GiftRollerListRoller;
    import flash.display.DisplayObjectContainer;
    import alternativa.tanks.gui.containers.ContainerInfoList;

    import mx.utils.Delegate;
    import mx.utils.StringUtil;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import forms.events.ContainerWindowEvent;
    import alternativa.tanks.gui.containers.Item;
    import alternativa.tanks.model.GarageModel;
    import controls.TankCheckBox;

    public class NewContainerWindow extends Sprite
    {

        private const windowMargin:int = 12;
        private const margin:int = 9;
        private const listmargin:int = 4;
        private const buttonSize:Point = new Point(104, 33);
        private const bannerSize:Point = new Point(468, 120);
        private const space:int = 0;
        private const STATE_INTRO:int = 0;
        private const STATE_LINK:int = 1;
        private const STATE_BANNER:int = 2;
        private const STATE_MAIL:int = 3;
        private const STATE_STAT:int = 4;
        private const bottomMargin:int = 104;

        private var localeService:ILocaleService;
        private var getLinkButton:ReferralWindowBigButton;
        private var getBannerButton:ReferralWindowBigButton;
        private var inviteByMailButton:ReferralWindowBigButton;
        public var closeButton:DefaultButton;
        private var spinButton:DefaultButton;
        private var skipAnimationCheckBox:TankCheckBox;

        public var statButton:ReferalStatButton;
        private var copyLinkButton:DefaultButton;
        private var copyBannerButton:DefaultButton;
        private var sendButton:DefaultButton;
        private var window:TankWindowWithHeader;
        private var windowInner:TankWindowInner;
        private var introInner:TankWindowInner;
        private var statInner:TankWindowInner;
        private var countInner:TankWindowInner;
        private var crystalsInner:TankWindowInner;
        private var descrInner:TankWindowInner;
        private var introHeader:Bitmap;
        private var introPic:Bitmap;
        public var referalList:ReferralStatList;
        private var introContainer:Sprite;
        private var linkContainer:Sprite;
        private var bannerContainer:Sprite;
        private var mailContainer:Sprite;
        private var statContainer:Sprite;
        private var banner:DisplayObject;
        private var bannerLoadEffect:CheckIcons;
        private var infoLabel:Label;
        private var descrLabel:Label;
        private var linkURL:TankInput;
        private var bannerCode:TextArea;
        private var nameInputLabel:Label;
        public var nameInput:TankInput;
        private var enterMailLabel:Label;
        private var mailTextLabel:Label;
        private var addressInput:TankInput;
        private var mailText:TextArea;
        private var countLabel:Label;
        private var countLabelHeader:Label;
        private var crystalLabel:Label;
        private var crystalLabelHeader:Label;
        private var loader:Loader;
        public var windowSize:Point;
        private var state:int;
        private var messageTemplate:String;
        private var panelModel:IPanel;
        public var crystalIcon:Diamond;
        private var inner:TankWindowInner;

        private var containerRemaining:int = 0;
        private var containerId:String;
        private var container:Container;
        private var maskSprite:Sprite;
        private var containerItemsList:ContainerInfoList;
        public function NewContainerWindow(containerId:String, baseCount:int)
        {
            super();
            this.containerId = containerId;
            this.containerRemaining = baseCount;
            this.windowSize = new Point(800, 600);
            // this.panelModel = (Main.osgi.getService(IPanel) as PanelModel);
            this.window = new TankWindowWithHeader("CASES");
            this.window.width = this.windowSize.x;
            this.window.height = this.windowSize.y;
            addChild(this.window);

            this.inner = new TankWindowInner(this.window.width - (this.windowMargin * 2), this.window.height - this.windowMargin - 50, TankWindowInner.GREEN);
            this.inner.showBlink = true;
            this.inner.x = this.windowMargin;
            this.inner.y = this.windowMargin;
            addChild(this.inner);

            this.closeButton = new DefaultButton();
            this.closeButton.label = "Close";
            this.closeButton.x = (((this.windowSize.x - this.windowMargin) - this.buttonSize.x) + 8);
            this.closeButton.y = ((this.windowSize.y - this.windowMargin) - this.buttonSize.y);
            addChild(this.closeButton);

            this.spinButton = new DefaultButton();
            this.spinButton.label = StringUtil.substitute("Open ({0})", this.containerRemaining);
            this.spinButton.x = this.inner.width / 2 - this.buttonSize.x / 2;
            this.spinButton.y = (this.inner.height / 2 - this.buttonSize.y / 2) - 50;
            this.spinButton.enable = this.containerRemaining > 0;
            this.inner.addChild(this.spinButton);
            this.spinButton.addEventListener(MouseEvent.CLICK, this.onSpinClick);

            this.skipAnimationCheckBox = new TankCheckBox();
            this.skipAnimationCheckBox.label = "Speed Open";
            this.skipAnimationCheckBox.x = this.spinButton.x;
            this.skipAnimationCheckBox.y = this.spinButton.y + this.buttonSize.y + 10;
            this.inner.addChild(this.skipAnimationCheckBox);

            this.container = new Container();
            addChild(this.container.itemContainer);

            var rollerCaret:Bitmap = new GiftRollerListRoller().image;
            // position rollerBg in the center of the x axis
            var rollerCaretx:int = (this.windowSize.x - rollerCaret.width) / 2;
            rollerCaret.x = rollerCaretx;
            rollerCaret.y = 50;
            addChild(rollerCaret);

            // Create a new Sprite to act as the mask
            this.maskSprite = new Sprite();

            // Draw a rectangle on the Sprite to define the visible area
            // Replace x, y, width, and height with the desired values
            maskSprite.graphics.beginFill(0xFFFFFF);
            maskSprite.graphics.drawRect(rollerCaretx + 5, 50, rollerCaret.width - 10, rollerCaret.height);
            maskSprite.graphics.endFill();

            this.container.itemContainer.mask = this.maskSprite;
            addChild(this.maskSprite);

            this.containerItemsList = new ContainerInfoList(this.containerId, this.inner.width - this.windowMargin * 2, 250);
            this.containerItemsList.x = this.inner.x + this.windowMargin;
            this.containerItemsList.y = rollerCaret.y + maskSprite.height + 100;

            addChild(this.containerItemsList);

        }
        private function onSpinClick(e:MouseEvent):void
        {
            this.spinButton.label = StringUtil.substitute("Open ({0})", this.containerRemaining -= 1);
            this.spinButton.enable = false;
            this.closeButton.enable = false;

            var lobby:Lobby = Main.osgi.getService(ILobby) as Lobby;
            lobby.addEventListener(ContainerWindowEvent.ON_OPEN_CONTAINER_DATA, this.handleOpening);
            Network(Main.osgi.getService(INetworker)).send("garage;open_container;" + containerId);

        }

        private function handleOpening(event:ContainerWindowEvent):void
        {
            var lobby:Lobby = Main.osgi.getService(ILobby) as Lobby;
            lobby.removeEventListener(ContainerWindowEvent.ON_OPEN_CONTAINER_DATA, this.handleOpening);
            var jsonData:Array = JSON.parse(event.data) as Array;
            container.setButtonReleaseCallbak(delegate(this, activateButton));
            container.clear();
            container.open(jsonData, this.skipAnimationCheckBox.checked);
        }
        public function delegate(scope:Object, func:Function):Function
        {
            return function(...args):*
            {
                return func.apply(scope, args);
            }
        }
        private function activateButton()
        {
            if (this.containerRemaining > 0)
            {
                spinButton.enable = true;
            }
            closeButton.enable = true;

        }

    }
} // package alternativa.tanks.gui