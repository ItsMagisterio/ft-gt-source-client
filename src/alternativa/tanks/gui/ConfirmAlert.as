﻿package alternativa.tanks.gui
{
    import flash.display.Sprite;
    import flash.geom.Point;
    import alternativa.osgi.service.locale.ILocaleService;
    import controls.TankWindow;
    import assets.icons.IconGarageMod;
    import flash.display.Bitmap;
    import controls.TankWindowInner;
    import controls.Label;
    import assets.Diamond;
    import controls.DefaultButton;
    import assets.icons.InputCheckIcon;
    import alternativa.init.Main;
    import forms.RegisterForm;
    import flash.display.BitmapData;
    import alternativa.tanks.locale.constants.TextConst;
    import logic.resource.images.ImageResource;

    public class ConfirmAlert extends Sprite
    {

        private const windowMargin:int = 11;
        private const spaceModule:int = 7;
        private const previewSize:Point = new Point(164, 106);
        private const buttonSize:Point = new Point(104, 33);

        private var localeService:ILocaleService;
        private var window:TankWindow;
        private var upgradeIndicator:IconGarageMod;
        private var preview:Bitmap;
        private var previewInner:TankWindowInner;
        private var questionLabel:Label;
        private var costLabel:Label;
        private var nameLabel:Label;
        private var crystalIcon:Diamond;
        public var confirmButton:DefaultButton;
        public var cancelButton:DefaultButton;
        private var windowWidth:int;
        private var windowHeight:int;
        private var loadChecker:InputCheckIcon = new InputCheckIcon();

        public function ConfirmAlert(name:String, cost:int, previewBd:ImageResource, buyAlert:Boolean, modIndex:int, text:String, inventoryNum:int = -1)
        {
            this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
            this.windowWidth = Math.max((((this.buttonSize.x * 2) + (this.windowMargin * 2)) + this.spaceModule), (this.previewSize.x + (this.windowMargin * 4)));
            this.window = new TankWindow(this.windowWidth, 0);
            addChild(this.window);
            this.previewInner = new TankWindowInner(0, 0, TankWindowInner.GREEN);
            this.previewInner.x = this.windowMargin;
            this.previewInner.y = this.windowMargin;
            this.previewInner.width = (this.windowWidth - (this.windowMargin * 2));
            this.previewInner.height = (this.previewSize.y + (this.windowMargin * 2));
            addChild(this.previewInner);
            if (previewBd == null)
            {
                this.loadChecker.gotoAndStop(RegisterForm.CALLSIGN_STATE_INVALID);
                this.loadChecker.x = (this.previewInner.width / 2);
                this.loadChecker.y = (this.previewInner.height / 2);
                addChild(this.loadChecker);
            }
            else
            {
                if (previewBd.loaded())
                {
                    this.preview = new Bitmap((previewBd.bitmapData as BitmapData));
                    addChild(this.preview);
                    this.preview.x = (this.previewInner.x + int((((this.windowWidth - (this.windowMargin * 2)) - this.previewSize.x) * 0.5)));
                    this.preview.y = (this.windowMargin * 2);
                }
                else
                {
                    this.loadChecker.gotoAndStop(RegisterForm.CALLSIGN_STATE_PROGRESS);
                    this.loadChecker.x = (this.previewInner.width / 2);
                    this.loadChecker.y = (this.previewInner.height / 2);
                    addChild(this.loadChecker);
                }
            }
            if (modIndex != -1)
            {
                this.upgradeIndicator = new IconGarageMod();
                addChild(this.upgradeIndicator);
                this.upgradeIndicator.x = ((((this.windowWidth - this.windowMargin) - this.spaceModule) - this.upgradeIndicator.width) + 2);
                this.upgradeIndicator.y = ((this.windowMargin + this.spaceModule) - 1);
                this.upgradeIndicator.mod = modIndex;
            }
            this.questionLabel = new Label();
            addChild(this.questionLabel);
            this.questionLabel.text = text;
            this.questionLabel.x = ((this.windowWidth - this.questionLabel.width) >> 1);
            this.questionLabel.width = (this.windowWidth - (this.windowMargin * 2));
            this.questionLabel.y = (((this.previewInner.y + this.previewSize.y) + (this.windowMargin * 2)) + this.spaceModule);
            this.nameLabel = new Label();
            addChild(this.nameLabel);
            if (modIndex > 0)
            {
                this.nameLabel.text = ((((('"' + name) + '" M') + modIndex) + " ") + this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_COST_PREFIX));
            }
            else
            {
                this.nameLabel.text = (((('"' + name) + '" ') + ((inventoryNum > 1) ? (("(" + inventoryNum) + ") ") : "")) + this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_COST_PREFIX));
            }
            this.crystalIcon = new Diamond();
            addChild(this.crystalIcon);
            this.costLabel = new Label();
            addChild(this.costLabel);
            this.costLabel.text = cost.toString();
            var costBlockWidth:int = (((this.nameLabel.width + this.costLabel.width) + this.crystalIcon.width) + 2);
            var costBlockX:int = ((this.windowWidth - costBlockWidth) >> 1);
            this.nameLabel.x = costBlockX;
            this.nameLabel.y = ((this.questionLabel.y + this.questionLabel.height) + this.windowMargin);
            this.crystalIcon.x = ((this.nameLabel.x + this.nameLabel.width) + 2);
            this.crystalIcon.y = (this.nameLabel.y + 5);
            this.costLabel.x = (this.crystalIcon.x + this.crystalIcon.width);
            this.costLabel.y = this.nameLabel.y;
            this.windowHeight = (((this.nameLabel.y + this.nameLabel.height) + (this.windowMargin * 2)) + this.buttonSize.y);
            this.cancelButton = new DefaultButton();
            addChild(this.cancelButton);
            this.cancelButton.label = this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_CANCEL_BUTTON_TEXT);
            this.cancelButton.x = ((this.windowWidth - this.buttonSize.x) - 3);
            this.cancelButton.y = (((this.windowHeight - this.windowMargin) - this.buttonSize.y) + 2);
            this.confirmButton = new DefaultButton();
            addChild(this.confirmButton);
            this.confirmButton.label = this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_CONFIRM_BUTTON_TEXT);
            this.confirmButton.x = this.windowMargin;
            this.confirmButton.y = (((this.windowHeight - this.windowMargin) - this.buttonSize.y) + 2);
            this.window.height = this.windowHeight;
        }
        public function setPreview(bitmapData:BitmapData):void
        {
            if (contains(this.loadChecker))
            {
                removeChild(this.loadChecker);
            }
            this.preview = new Bitmap(bitmapData);
            addChild(this.preview);
            this.preview.x = (this.previewInner.x + int((((this.windowWidth - (this.windowMargin * 2)) - this.previewSize.x) * 0.5)));
            this.preview.y = (this.windowMargin * 2);
        }

    }
}
