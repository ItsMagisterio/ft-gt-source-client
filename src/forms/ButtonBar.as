package forms
{
    import alternativa.tanks.gui.panel.buttons.MainPanelFullscreenButton;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import forms.buttons.MainPanelSocialNetsButton;
    import controls.panel.BaseButton;
    import forms.buttons.MainPanelDonateButton;
    import forms.buttons.MainPanelRatingButton;
    import forms.buttons.MainPanelChallengeButton;
    import forms.buttons.MainPanelFriendsButton;
    import forms.buttons.MainPanelSpinsButton;
    import flash.display.MovieClip;
    import alternativa.init.Main;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.tanks.locale.constants.TextConst;
    import flash.events.MouseEvent;
    import forms.events.MainButtonBarEvents;
    import forms.buttons.GPButton;
    import forms.starscount.StarsCounter;
    import forms.buttons.MainPanelClanButton;

    public class ButtonBar extends Sprite
    {

        private static var questsChangesIconClass:Class = ButtonBar_icon;
        private static var questsChangesIconBitmapData:BitmapData = Bitmap(new questsChangesIconClass()).bitmapData;
        public var icon:Bitmap = new Bitmap(questsChangesIconBitmapData);

        private static var shopSalesIcon:Class = ButtonBar_Sale;
        private static var shopSalesIconBMP:BitmapData = Bitmap(new shopSalesIcon()).bitmapData;
        public var saleIcon:Bitmap = new Bitmap(shopSalesIconBMP);

        public var battlesButton:MainPanelBattlesButton = new MainPanelBattlesButton();
        public var garageButton:MainPanelGarageButton = new MainPanelGarageButton();
        public var clansButton:MainPanelClanButton = new MainPanelClanButton();
        public var statButton:MainPaneHallButton = new MainPaneHallButton();
        public var bugsButton:MainPanelBugButton = new MainPanelBugButton();
        public var settingsButton:MainPanelConfigButton = new MainPanelConfigButton();
        public var soundButton:MainPanelSoundButton = new MainPanelSoundButton();
        public var helpButton:MainPanelHelpButton = new MainPanelHelpButton();
        public var closeButton:MainPanelCloseButton = new MainPanelCloseButton();
        public var closeButton1:GPButton = new GPButton();
        public var addButton:BaseButton;
        public var referalsButton:MainPanelReferalButton = new MainPanelReferalButton();
        public var donateButton:MainPanelDonateButton = new MainPanelDonateButton();
        public var ratingButton:MainPanelRatingButton = new MainPanelRatingButton();
        public var challengeButton:MainPanelChallengeButton = new MainPanelChallengeButton();
        public var friendsButton:MainPanelFriendsButton = new MainPanelFriendsButton();
        public var starCountBut:StarsCounter = new StarsCounter();
        public var fullScreenButton:MainPanelFullscreenButton = new MainPanelFullscreenButton();
        private var _soundOn:Boolean = true;
        private var soundIcon:MovieClip;
        public var isTester:Boolean = false;

        public function ButtonBar()
        {
            var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            starCountBut.starsCount = 0;
            starCountBut.type = 3;
            starCountBut.addEventListener(MouseEvent.CLICK, this.listClick);
            //addChild(starCountBut);
            addChild(this.battlesButton);
            this.battlesButton.type = 4;
            this.battlesButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_BATTLES);
            this.battlesButton.addEventListener(MouseEvent.CLICK, this.listClick);
            addChild(this.garageButton);
            this.garageButton.type = 5;
            this.garageButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_GARAGE);
            this.garageButton.addEventListener(MouseEvent.CLICK, this.listClick);
            addChild(this.clansButton);
            this.clansButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_RATING);
            addChild(this.friendsButton);
            this.friendsButton.type = 15;
            this.friendsButton.addEventListener(MouseEvent.CLICK, this.listClick);

            this.bugsButton.type = 11;
            this.bugsButton.addEventListener(MouseEvent.CLICK, this.listClick);
            addChild(this.settingsButton);
            this.settingsButton.type = 7;
            this.settingsButton.addEventListener(MouseEvent.CLICK, this.listClick);
            addChild(this.soundButton);
            this.soundButton.type = 8;
            this.soundButton.addEventListener(MouseEvent.CLICK, this.listClick);
            this.soundIcon = (this.soundButton.getChildByName("icon") as MovieClip);
            addChild(this.helpButton);
            this.helpButton.type = 9;
            this.helpButton.addEventListener(MouseEvent.CLICK, this.listClick);
            addChild(this.closeButton);
            this.closeButton.type = 10;
            this.closeButton.addEventListener(MouseEvent.CLICK, this.listClick);

            addChild(this.closeButton1);
            this.closeButton1.visible = false;
            this.closeButton1.type = 10;
            this.closeButton1.addEventListener(MouseEvent.CLICK, this.listClick);

            addChild(this.donateButton);
            this.donateButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_SHOP);
            this.donateButton.addEventListener(MouseEvent.CLICK, this.listClick);

            addChild(this.challengeButton);
            this.challengeButton.type = 3;
            this.challengeButton.addEventListener(MouseEvent.CLICK, this.listClick);
            this.fullScreenButton.type = 16;
            this.fullScreenButton.addEventListener(MouseEvent.CLICK, this.listClick);
            //addChild(this.referalsButton);
            this.referalsButton.type = 14;
            this.referalsButton.addEventListener(MouseEvent.CLICK, this.listClick);
            addChild(this.fullScreenButton);
            addChild(this.icon);
            this.icon.visible = false;
            addChild(this.saleIcon);
            this.saleIcon.visible = false;
            this.draw();
        }
        public function draw():void
        {
            this.donateButton.x = 2;//(starCountBut.x + starCountBut.width) - 15;
            this.battlesButton.x = (donateButton.x + donateButton.width) + 8;
            this.garageButton.x = (this.battlesButton.x + this.battlesButton.width);
            this.clansButton.x = (this.garageButton.x + this.garageButton.width);
            this.challengeButton.x = ((this.clansButton.x + this.clansButton.width) + 5);
            this.friendsButton.x = ((this.challengeButton.x + this.challengeButton.width)) - 1;
            // this.referalsButton.x = ((this.friendsButton.x + this.friendsButton.width)) - 1;
            // this.settingsButton.x = ((this.referalsButton.x + this.referalsButton.width));
            this.settingsButton.x = ((this.friendsButton.x + this.friendsButton.width)) - 1;
            this.soundButton.x = (this.settingsButton.x + this.settingsButton.width);
            this.fullScreenButton.x = this.soundButton.x + this.soundButton.width;
            this.helpButton.x = this.fullScreenButton.x + this.fullScreenButton.width;
            this.closeButton.x = this.helpButton.x + this.helpButton.width + 11;
            this.closeButton1.x = this.helpButton.x + this.helpButton.width + 11;
            this.soundIcon.gotoAndStop(((this.soundOn) ? 1 : 2));

            this.icon.x = this.friendsButton.x + this.friendsButton.width - 16;
            this.icon.y = -3;

            this.saleIcon.x = this.donateButton.x + this.donateButton.width - 16;
            this.saleIcon.y = -3;
        }
        public function set soundOn(value:Boolean):void
        {
            this._soundOn = value;
            this.draw();
        }
        public function get soundOn():Boolean
        {
            return (this._soundOn);
        }
        public function listClick(e:MouseEvent):void
        {
            var target:BaseButton;
            var trget:BaseButton;
            var i:int;
            if ((e.currentTarget as BaseButton) != null)
            {
                target = (e.currentTarget as BaseButton);
                if (target.enable)
                {
                    dispatchEvent(new MainButtonBarEvents(target.type));
                }
                if (target == this.soundButton)
                {
                    this.soundOn = (!(this.soundOn));
                }
                if ((((target == this.battlesButton) || (target == this.garageButton)) || (target == this.statButton)))
                {
                    i = 0;
                    while (i < 3)
                    {
                        trget = (getChildAt(i) as BaseButton);
                        if (trget != null)
                        {
                            trget.enable = (!(target == trget));
                        }
                        i++;
                    }
                }
            }
        }

    }
}
