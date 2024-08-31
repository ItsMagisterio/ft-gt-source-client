package forms
{
    import flash.display.Sprite;
    import controls.DefaultButton;
    import controls.TankInput;
    import alternativa.tanks.model.captcha.CaptchaForm;
    import controls.Label;
    import controls.TankWindow;
    import alternativa.init.Main;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.tanks.locale.constants.TextConst;
    import controls.TankWindowHeader;
    import flash.text.TextFormatAlign;
    import flash.events.FocusEvent;
    import flash.events.Event;

    public class RestoreEmail extends Sprite
    {

        public var cancelButton:DefaultButton;
        public var recoverButton:DefaultButton;
        public var email:TankInput;
        public var captchaView:CaptchaForm;
        private var label:Label;
        private var bg:TankWindowWithHeader;

        public function RestoreEmail()
        {
            var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            this.bg = new TankWindowWithHeader("PASSWORD RESTORE");
            this.bg.width = 320;
            this.bg.height = 170;

            this.label = new Label();
            addChild(this.bg);
            addChild(this.label);
            this.label.multiline = true;
            this.label.size = 12;
            this.label.align = TextFormatAlign.CENTER;
            this.label.text = "Enter your valid e-mail adress:";
            this.label.x = int((165 - (this.label.width / 2)));
            this.label.y = 20;
            this.cancelButton = new DefaultButton();
            this.recoverButton = new DefaultButton();
            this.email = new TankInput();
            addChild(this.cancelButton);
            addChild(this.recoverButton);
            addChild(this.email);
            this.cancelButton.x = 190;
            this.cancelButton.y = 115;
            this.recoverButton.x = 30;
            this.recoverButton.y = 115;
            this.email.width = 260;
            this.email.x = 30;
            this.email.y = 60;
            this.cancelButton.label = "Cancel";
            this.recoverButton.label = localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_BUTTON_RECOVER_TEXT);
            this.x = 61;
            this.email.addEventListener(FocusEvent.FOCUS_IN, this.restoreInput);
        }
        private function restoreInput(e:Event):void
        {
            this.email.validValue = true;
        }
        public function captcha(value:Boolean):void
        {
            if (((value) && (this.captchaView == null)))
            {
                this.label.size = 12;
                this.captchaView = new CaptchaForm();
                addChild(this.captchaView);
                this.captchaView.width = (this.captchaView.width - 40);
                this.bg.height = (this.bg.height + (this.captchaView.height + 40));
                this.bg.width = (this.bg.width + 18);
                this.email.width = (this.captchaView.width - 15);
                this.captchaView.x = this.email.x;
                this.captchaView.y = ((this.email.y + this.email.height) + 20);
                this.cancelButton.x = 175;
                this.cancelButton.y = 295;
                this.recoverButton.x = 30;
                this.recoverButton.y = 295;
            }
        }

    }
}
