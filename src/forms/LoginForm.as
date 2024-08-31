package forms
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.events.TextEvent;
    import flash.events.Event;
    import logic.utils.CaptchaParser;
    import logic.networking.Network;
    import alternativa.init.Main;
    import logic.networking.INetworker;
    import forms.events.LoginFormEvent;
    import controls.DefaultButton;
    import flash.ui.Keyboard;

    public class LoginForm extends Sprite
    {

        private var _state:Boolean = false;
        public var checkPassword:CheckPassword = new CheckPassword();
        public var registerForm:RegisterForm;
        public var _restoreEmailForm:RestoreEmail = new RestoreEmail();
        public var _restoreEmailCodeForm:RestoreEmailCode = new RestoreEmailCode();
        public var _resetPasswordForm:ResetPasswordForm = new ResetPasswordForm();
        private var antiAddictionEnabled:Boolean = false;

        public function LoginForm(antiAddictionEnabled:Boolean):void
        {
            this.antiAddictionEnabled = antiAddictionEnabled;
            this.registerForm = new RegisterForm(antiAddictionEnabled);
            if (antiAddictionEnabled)
            {
                this.registerForm.y = -110;
            }
            addChild(this.registerForm);
            addChild(this.checkPassword);
            addChild(this._restoreEmailForm);
            addChild(this._restoreEmailCodeForm);
            addChild(this._resetPasswordForm);
            this.checkPassword.visible = false;
            this.registerForm.visible = true;
            this._restoreEmailForm.visible = false;
            this._restoreEmailCodeForm.visible = false;
            this._resetPasswordForm.visible = false;
            this.checkPassword.playButton.addEventListener(MouseEvent.CLICK, this.playClick);
            this.registerForm.playButton.addEventListener(MouseEvent.CLICK, this.playClick);
            this.checkPassword.password.addEventListener(KeyboardEvent.KEY_DOWN, this.playClickKey);
            this.registerForm.rulesButton.addEventListener(TextEvent.LINK, this.onRules);
            this.checkPassword.registerButton.addEventListener(MouseEvent.CLICK, this.switchState);
            this.registerForm.loginButton.addEventListener(MouseEvent.CLICK, this.switchState);
            addEventListener(Event.ADDED_TO_STAGE, this.Init);
        }
        public function get loginState():Boolean
        {
            return (this._state);
        }
        public function set loginState(value:Boolean):void
        {
            this._state = (!(value));
            this.switchState(null);
        }
        public function get callSign():String
        {
            return ((this._state) ? this.checkPassword.callSign.value : this.registerForm.callSign.value);
        }
        public function set callSign(value:String):void
        {
            this.checkPassword.callSign.value = value;
            if (stage != null)
            {
            }
        }
        public function get mainPassword():String
        {
            return (this.checkPassword.password.value);
        }
        public function get pass1():String
        {
            return (this.registerForm.pass1.value);
        }
        public function get pass2():String
        {
            return (this.registerForm.pass2.value);
        }

        public function get remember():Boolean
        {
            return ((this._state) ? this.checkPassword.checkRemember.checked : this.registerForm.chekRemember.checked);
        }
        public function set remember(value:Boolean):void
        {
            this.checkPassword.checkRemember.checked = value;
        }

        public function get restoreEmail():String
        {
            return (this._restoreEmailForm.email.value);
        }

        public function get restoreEmailCode():String
        {
            return (this._restoreEmailCodeForm.codeInput.value);
        }

        public function get resetPasswordNewValue():String
        {
            return (this._resetPasswordForm.passwordInput.value);
        }
        public function clearPassword():void
        {
            this.checkPassword.password.clear();
        }
        private function Init(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.Init);
            stage.addEventListener(Event.RESIZE, this.doLayout);
            this.doLayout(null);
            this.loginState = (!(this._state));
        }
        public function setCaptchaEnable(_arg_1:String, packet:String):void
        {
            if (_arg_1 == "AUTH")
            {
                this.checkPassword.captcha(true);
                this.checkPassword.captchaView.refreshBtn.addEventListener(MouseEvent.CLICK, this.onRefreshCaptchaAuth);
                CaptchaParser.parse(packet, this.checkPassword.captchaView.captcha);
            }
            else
            {
                if (_arg_1 == "REGISTER")
                {
                    this.registerForm.captcha(true);
                    this.registerForm.captchaView.refreshBtn.addEventListener(MouseEvent.CLICK, this.onRefreshCaptchaAuth);
                    CaptchaParser.parse(packet, this.registerForm.captchaView.captcha);
                }
                else
                {
                    if (_arg_1 == "RESTORE")
                    {
                        this._restoreEmailForm.captcha(true);
                        this._restoreEmailForm.captchaView.refreshBtn.addEventListener(MouseEvent.CLICK, this.onRefreshCaptchaAuth);
                        CaptchaParser.parse(packet, this._restoreEmailForm.captchaView.captcha);
                    }
                }
            }
        }
        private function onRefreshCaptchaAuth(e:Event):void
        {
            Network(Main.osgi.getService(INetworker)).send("auth;refresh_captcha");
        }
        public function updateCaptcha(_arg_1:String, packet:String):void
        {
            if (((_arg_1 == "AUTH") && (!(this.checkPassword.captchaView == null))))
            {
                CaptchaParser.parse(packet, this.checkPassword.captchaView.captcha);
            }
            if (((_arg_1 == "REGISTER") && (!(this.registerForm.captchaView == null))))
            {
                CaptchaParser.parse(packet, this.registerForm.captchaView.captcha);
            }
            if (((_arg_1 == "RESTORE") && (!(this._restoreEmailForm.captchaView == null))))
            {
                CaptchaParser.parse(packet, this._restoreEmailForm.captchaView.captcha);
            }
        }
        private function switchState(e:MouseEvent):void
        {
            this._state = (!(this._state));
            this.checkPassword.visible = this._state;
            this.registerForm.setVisibility(!this._state);
            if (stage != null)
            {
                if (this._state)
                {
                    stage.focus = ((this.checkPassword.callSign.textField.length == 0) ? this.checkPassword.callSign.textField : this.checkPassword.password.textField);
                }
                else
                {
                    stage.focus = this.registerForm.callSign.textField;
                }
            }
            dispatchEvent(new LoginFormEvent(LoginFormEvent.CHANGE_STATE));
        }
        private function onRules(e:TextEvent):void
        {
            if (e.text == "rules")
            {
                dispatchEvent(new LoginFormEvent(LoginFormEvent.SHOW_RULES));
            }
            else
            {
                dispatchEvent(new LoginFormEvent(LoginFormEvent.SHOW_TERMS));
            }
        }
        private function doLayout(e:Event):void
        {
            this.checkPassword.x = int(stage.stageWidth / 2 - this.checkPassword.width / 2);
            this.checkPassword.y = int(stage.stageHeight / 2 - this.checkPassword.height / 2) - 50;
            this.registerForm.onResize(e);
            this._restoreEmailForm.x = int(stage.stageWidth / 2 - this._restoreEmailForm.width / 2);
            this._restoreEmailForm.y = int(stage.stageHeight / 2 - this._restoreEmailForm.height / 2) - 50;
            this._restoreEmailCodeForm.x = int(stage.stageWidth / 2 - this._restoreEmailCodeForm.width / 2);
            this._restoreEmailCodeForm.y = int(stage.stageHeight / 2 - this._restoreEmailCodeForm.height / 2) - 50;
            this._resetPasswordForm.x = int(stage.stageWidth / 2 - this._resetPasswordForm.width / 2);
            this._resetPasswordForm.y = int(stage.stageHeight / 2 - this._resetPasswordForm.height / 2) - 50;
        }
        private function playClick(event:MouseEvent):void
        {
            var trgt:DefaultButton = (event.currentTarget as DefaultButton);
            trgt.enable = false;
            dispatchEvent(new LoginFormEvent(LoginFormEvent.PLAY_PRESSED));
        }
        private function playClickKey(e:KeyboardEvent):void
        {
            if (e.keyCode == Keyboard.ENTER)
            {
                this.checkPassword.playButton.enable = false;
                dispatchEvent(new LoginFormEvent(LoginFormEvent.PLAY_PRESSED));
            }
        }
        public function showRestoreForm():void
        {
            this.checkPassword.visible = false;
            this._restoreEmailForm.visible = true;
            this._restoreEmailForm.email.validValue = true;
            this._restoreEmailForm.cancelButton.addEventListener(MouseEvent.CLICK, this.clickRestoreForm);
            this._restoreEmailForm.recoverButton.addEventListener(MouseEvent.CLICK, this.clickRestoreForm);
            this._restoreEmailCodeForm.confirmButton.addEventListener(MouseEvent.CLICK, this.clickRestoreCodeForm);
            this._resetPasswordForm.confirmButton.addEventListener(MouseEvent.CLICK, this.clickResetPasswordButton);
        }
        public function invalidRestoreForm():void
        {
            this._restoreEmailForm.email.validValue = false;
        }
        public function clickRestoreForm(e:MouseEvent):void
        {
            if (e.currentTarget == this._restoreEmailForm.recoverButton)
            {
                dispatchEvent(new LoginFormEvent(LoginFormEvent.RESTORE_PRESSED));
            }
            else
            {
                this.goBackToLogin();
            }
        }
        public function clickRestoreCodeForm(e:MouseEvent):void
        {
            dispatchEvent(new LoginFormEvent(LoginFormEvent.RESTORE_PRESSED_CODE));
        }
        public function clickResetPasswordButton(e:MouseEvent):void
        {
            dispatchEvent(new LoginFormEvent(LoginFormEvent.RESET_PASSWORD));
        }
        public function hideRestoreForm():void
        {
            this._restoreEmailForm.visible = false;
            this._restoreEmailForm.cancelButton.removeEventListener(MouseEvent.CLICK, this.clickRestoreForm);
            this._restoreEmailForm.recoverButton.removeEventListener(MouseEvent.CLICK, this.clickRestoreForm);
            this._restoreEmailCodeForm.visible = true;
        }
        public function goBackToLogin():void
        {
            this._restoreEmailForm.cancelButton.removeEventListener(MouseEvent.CLICK, this.clickRestoreForm);
            this._restoreEmailForm.recoverButton.removeEventListener(MouseEvent.CLICK, this.clickRestoreForm);
            this.checkPassword.visible = true;
            this._restoreEmailForm.visible = false;
            this.loginState = true;
        }
        public function hideRestoreFormCode():void
        {
            this._restoreEmailCodeForm.visible = false;
            this._restoreEmailCodeForm.confirmButton.removeEventListener(MouseEvent.CLICK, this.clickRestoreCodeForm);
            this._resetPasswordForm.visible = true;
        }
        public function hideResetFormPassword():void
        {
            this.checkPassword.visible = true;
            this._resetPasswordForm.visible = false;
            this.loginState = true;
            this._resetPasswordForm.confirmButton.removeEventListener(MouseEvent.CLICK, this.clickResetPasswordButton);
        }
        public function hide():void
        {
            stage.removeEventListener(Event.RESIZE, this.doLayout);
            this.checkPassword.playButton.removeEventListener(MouseEvent.CLICK, this.playClick);
            this.registerForm.playButton.removeEventListener(MouseEvent.CLICK, this.playClick);
            this.checkPassword.registerButton.removeEventListener(MouseEvent.CLICK, this.switchState);
            this.registerForm.loginButton.removeEventListener(MouseEvent.CLICK, this.switchState);
            this.checkPassword.password.removeEventListener(KeyboardEvent.KEY_DOWN, this.playClickKey);
            this.registerForm.hide();
            if (this.checkPassword.captchaView != null)
            {
                this.checkPassword.captchaView.refreshBtn.removeEventListener(MouseEvent.CLICK, this.onRefreshCaptchaAuth);
            }
            if (this.registerForm.captchaView != null)
            {
                this.registerForm.captchaView.refreshBtn.removeEventListener(MouseEvent.CLICK, this.onRefreshCaptchaAuth);
            }
            if (this._restoreEmailForm.captchaView != null)
            {
                this._restoreEmailForm.captchaView.refreshBtn.removeEventListener(MouseEvent.CLICK, this.onRefreshCaptchaAuth);
            }
        }

    }
}
