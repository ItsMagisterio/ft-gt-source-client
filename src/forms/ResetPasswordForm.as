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

    public class ResetPasswordForm extends Sprite
    {

        public var confirmButton:DefaultButton;
        public var passwordInput:TankInput;
        private var label:Label;
        private var bg:TankWindowWithHeader;

        public function ResetPasswordForm()
        {
            var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            this.bg = new TankWindowWithHeader("PASSWORD RESET FORM");
            this.bg.width = 320;
            this.bg.height = 170;

            this.label = new Label();
            addChild(this.bg);
            addChild(this.label);
            this.label.multiline = true;
            this.label.size = 12;
            this.label.align = TextFormatAlign.CENTER;
            this.label.text = "Enter your new desired password";
            this.label.x = int((165 - (this.label.width / 2)));
            this.label.y = 20;
            this.confirmButton = new DefaultButton();
            this.passwordInput = new TankInput();
            addChild(this.confirmButton);
            addChild(this.passwordInput);
            this.confirmButton.x = 30;
            this.confirmButton.y = 115;
            this.passwordInput.width = 260;
            this.passwordInput.x = 30;
            this.passwordInput.y = 60;
            this.passwordInput.hidden = true;
            this.confirmButton.label = "Submit";
            this.x = 61;
            this.passwordInput.addEventListener(FocusEvent.FOCUS_IN, this.restoreInput);
        }
        private function restoreInput(e:Event):void
        {
            this.passwordInput.validValue = true;
        }

    }
}
