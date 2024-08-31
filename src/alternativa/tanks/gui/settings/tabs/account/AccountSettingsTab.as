package alternativa.tanks.gui.settings.tabs.account
{
    import alternativa.init.Main;
    import alternativa.tanks.gui.settings.SettingsWindow;
    import alternativa.tanks.gui.settings.tabs.*;
    import alternativa.tanks.model.user.IUserData;
    import alternativa.tanks.model.user.IUserDataListener;
    import alternativa.tanks.model.user.UserData;

    import assets.icons.InputCheckIcon;

    import controls.TankWindowInner;
    import controls.base.DefaultButtonBase;
    import controls.base.LabelBase;
    import controls.base.TankInputBase;
    import controls.containers.VerticalStackPanel;

    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;

    import forms.registration.CallsignIconStates;

    import logic.networking.INetworker;
    import logic.networking.Network;
    import flash.display.Sprite;

    public class AccountSettingsTab extends SettingsTabView implements IUserDataListener
    {

        private static const CHECK_ICON_OFFSET:int = 7;

        private static const INPUT_HEIGHT:int = 30;

        private static const forbiddenPasswords:Array = [];

        private var oldPasswordInput:TankInputBase;
        private var newPassInput:TankInputBase;
        private var repeatPassInput:TankInputBase;

        private var oldPasswordCheckIcon:InputCheckIcon;
        private var newPassCheckIcon:InputCheckIcon;
        private var repeatPassCheckIcon:InputCheckIcon;

        private var changePasswordButton:DefaultButtonBase;

        private var emailInput:TankInputBase;
        private var emailCheckIcon:InputCheckIcon;
        private var setEmailButton:DefaultButtonBase;
        private var unbindEmailButton:DefaultButtonBase;
        private var confirmEmailButton:DefaultButtonBase;

        private var codeInput:TankInputBase;
        private var codeConfirmButton:DefaultButtonBase;

        private var codePanel:TankWindowInner;
        private var mailPanel:TankWindowInner;
        private var passPanel:TankWindowInner;

        private var mainPanel:VerticalStackPanel;
        private var userData:UserData;
        private var codeConfirmFunction:Function;

        public function AccountSettingsTab()
        {
            super();
            this.userData = Main.osgi.getService(IUserData) as UserData;
            userData.addListener(this);
            this.mainPanel = new VerticalStackPanel();
            mainPanel.setMargin(MARGIN);
            mainPanel.y = 0;
            draw();
            initGuiEvents();
            initLogicEvents();
            initUserData(userData);
            addChildAt(mainPanel, 0);
        }

        private function draw():void
        {
            this.mailPanel = this.createSetEmailPanel();
            this.passPanel = this.createPasswordPanel();
            this.codePanel = this.createConfirmCodePanel();

            // mailPanel.y = passPanel.y + passPanel.height + MARGIN - mainPanel.height - 10;
            // codePanel.y = mailPanel.y + mailPanel.height + MARGIN;

            mainPanel.addItem(passPanel);
            mainPanel.addItem(mailPanel);
            mainPanel.addItem(codePanel);
        }

        private function createPasswordPanel():TankWindowInner
        {
            var width:int = SettingsWindow.TAB_VIEW_MAX_WIDTH;
            var height:int = INPUT_HEIGHT * 2 + 3 * MARGIN;
            var tankWindowInner:TankWindowInner = new TankWindowInner(width, height, TankWindowInner.TRANSPARENT);

            var oldPasswordLabel:LabelBase = this.createLabel("Current password");
            var newPassLabel:LabelBase = this.createLabel("New password");
            var repeatPassLabel:LabelBase = this.createLabel("Repeat");

            var widthPasswordInput:int = (width - oldPasswordLabel.width - newPassLabel.width - repeatPassLabel.width - 7 * MARGIN) / 3 + 1 - 6;
            this.oldPasswordInput = new TankInputBase();
            this.oldPasswordInput.hidden = true;
            this.oldPasswordInput.width = widthPasswordInput;
            this.oldPasswordInput.maxChars = 20;
            this.oldPasswordInput.validValue = true;
            this.newPassInput = new TankInputBase();
            this.newPassInput.hidden = true;
            this.newPassInput.width = widthPasswordInput;
            this.newPassInput.maxChars = 20;
            this.newPassInput.validValue = true;
            this.oldPasswordInput.height = this.newPassInput.height;
            this.repeatPassInput = new TankInputBase();
            this.repeatPassInput.hidden = true;
            this.repeatPassInput.width = widthPasswordInput;
            this.repeatPassInput.maxChars = 20;
            this.repeatPassInput.validValue = true;
            oldPasswordLabel.x = MARGIN;
            oldPasswordLabel.y = MARGIN + (INPUT_HEIGHT - oldPasswordLabel.height) / 2;
            this.oldPasswordInput.x = oldPasswordLabel.x + oldPasswordLabel.width + MARGIN;
            this.oldPasswordInput.y = MARGIN;
            newPassLabel.x = this.oldPasswordInput.x + this.oldPasswordInput.width + MARGIN;
            newPassLabel.y = oldPasswordLabel.y;
            this.newPassInput.x = newPassLabel.x + newPassLabel.width + MARGIN;
            this.newPassInput.y = MARGIN;
            repeatPassLabel.x = this.newPassInput.x + this.newPassInput.width + MARGIN;
            repeatPassLabel.y = oldPasswordLabel.y;
            this.repeatPassInput.x = repeatPassLabel.x + repeatPassLabel.width + MARGIN;
            this.repeatPassInput.y = MARGIN;
            this.changePasswordButton = new DefaultButtonBase();
            this.changePasswordButton.label = "Change";
            this.changePasswordButton.x = width - MARGIN - this.changePasswordButton.width;
            this.changePasswordButton.y = this.repeatPassInput.y + this.repeatPassInput.height + MARGIN;
            tankWindowInner.addChild(oldPasswordLabel);
            tankWindowInner.addChild(this.oldPasswordInput);
            tankWindowInner.addChild(newPassLabel);
            tankWindowInner.addChild(this.newPassInput);
            tankWindowInner.addChild(repeatPassLabel);
            tankWindowInner.addChild(this.repeatPassInput);
            tankWindowInner.addChild(this.changePasswordButton);
            this.oldPasswordCheckIcon = new InputCheckIcon();
            this.oldPasswordCheckIcon.x = this.oldPasswordInput.x + this.oldPasswordInput.width - this.oldPasswordCheckIcon.width - CHECK_ICON_OFFSET * 2;
            this.oldPasswordCheckIcon.y = this.oldPasswordInput.y + CHECK_ICON_OFFSET;
            this.oldPasswordCheckIcon.visible = false;
            this.oldPasswordCheckIcon.gotoAndStop(CallsignIconStates.CALLSIGN_ICON_STATE_INVALID);
            this.newPassCheckIcon = new InputCheckIcon();
            this.repeatPassCheckIcon = new InputCheckIcon();
            this.newPassCheckIcon.x = this.newPassInput.x + this.newPassInput.width - this.newPassCheckIcon.width - CHECK_ICON_OFFSET * 2;
            this.repeatPassCheckIcon.x = this.repeatPassInput.x + this.repeatPassInput.width - this.repeatPassCheckIcon.width - CHECK_ICON_OFFSET * 2;

            this.newPassCheckIcon.y = this.newPassInput.y + MARGIN;
            this.repeatPassCheckIcon.y = this.repeatPassInput.y + MARGIN;
            this.pass1State = CallsignIconStates.CALLSIGN_ICON_STATE_OFF;
            this.pass2State = CallsignIconStates.CALLSIGN_ICON_STATE_OFF;
            tankWindowInner.addChild(this.oldPasswordCheckIcon);
            tankWindowInner.addChild(this.newPassCheckIcon);
            tankWindowInner.addChild(this.repeatPassCheckIcon);

            return tankWindowInner;
        }

        private function createSetEmailPanel():TankWindowInner
        {
            var width:int = SettingsWindow.TAB_VIEW_MAX_WIDTH;
            var height:int = INPUT_HEIGHT + 2 * MARGIN;
            var panel:TankWindowInner = new TankWindowInner(width, height, TankWindowInner.TRANSPARENT);

            var emailLabel:LabelBase = this.createLabel("E-mail:");
            emailLabel.x = MARGIN;
            this.setEmailButton = new DefaultButtonBase();
            this.unbindEmailButton = new DefaultButtonBase();
            this.confirmEmailButton = new DefaultButtonBase();

            this.setEmailButton.label = "Link";
            this.unbindEmailButton.label = "Unbind";
            this.confirmEmailButton.label = "Confirm";

            this.setEmailButton.x = SettingsWindow.TAB_VIEW_MAX_WIDTH - this.setEmailButton.width - MARGIN;
            this.unbindEmailButton.x = SettingsWindow.TAB_VIEW_MAX_WIDTH - this.setEmailButton.width - MARGIN;
            this.confirmEmailButton.x = SettingsWindow.TAB_VIEW_MAX_WIDTH - this.setEmailButton.width - MARGIN;

            this.setEmailButton.y = MARGIN;
            this.unbindEmailButton.y = MARGIN;
            this.confirmEmailButton.y = MARGIN;

            this.emailInput = new TankInputBase();
            this.emailInput.value = "";
            this.emailInput.validValue = true;
            this.emailInput.x = emailLabel.x + emailLabel.width + MARGIN;
            this.emailInput.y = MARGIN;
            this.emailInput.width = SettingsWindow.TAB_VIEW_MAX_WIDTH - this.emailInput.x -
                this.setEmailButton.width - 3 * MARGIN;
            emailLabel.y = this.emailInput.y + (this.emailInput.height - emailLabel.height) / 2 ;

            panel.addChild(emailLabel);
            panel.addChild(this.emailInput);
            panel.addChild(this.setEmailButton);
            panel.addChild(this.unbindEmailButton);
            panel.addChild(this.confirmEmailButton);

            this.emailCheckIcon = new InputCheckIcon();
            this.emailCheckIcon.x = this.emailInput.x + this.emailInput.width
                - this.emailCheckIcon.width - CHECK_ICON_OFFSET * 2;
            this.emailCheckIcon.y = this.emailInput.y + CHECK_ICON_OFFSET ;
            this.emailCheckIcon.visible = false;
            panel.addChild(this.emailCheckIcon);
            return panel;
        }

        private function createConfirmCodePanel():TankWindowInner
        {
            var width:int = SettingsWindow.TAB_VIEW_MAX_WIDTH;
            var height:int = INPUT_HEIGHT + 2 * MARGIN;
            var tankWindowInner:TankWindowInner = new TankWindowInner(width, height, TankWindowInner.TRANSPARENT);

            var codeLabel:LabelBase = this.createLabel("Code: ");
            codeLabel.x = MARGIN;

            this.codeConfirmButton = new DefaultButtonBase();
            this.codeConfirmButton.label = "Confirm";
            this.codeConfirmButton.x = width - this.codeConfirmButton.width - MARGIN;
            this.codeConfirmButton.y = MARGIN;

            this.codeInput = new TankInputBase();
            this.codeInput.width = width - codeLabel.width - this.codeConfirmButton.width - 4 * MARGIN;
            this.codeInput.x = codeLabel.x + codeLabel.width + MARGIN;
            this.codeInput.y = MARGIN;

            codeLabel.y = this.codeInput.y + (this.codeInput.height - codeLabel.textHeight) / 2;
            tankWindowInner.addChild(codeLabel);
            tankWindowInner.addChild(this.codeInput);
            tankWindowInner.addChild(this.codeConfirmButton);
            return tankWindowInner;
        }

        private function initGuiEvents():void
        {
            this.oldPasswordInput.addEventListener(FocusEvent.FOCUS_IN, this.onChangeOldPasswordInput);
            this.oldPasswordInput.addEventListener(Event.CHANGE, this.onChangeOldPasswordInput);

            this.newPassInput.addEventListener(FocusEvent.FOCUS_IN, restoreInput);
            this.newPassInput.addEventListener(FocusEvent.FOCUS_IN, this.onChangePasswordBlock);
            this.newPassInput.addEventListener(Event.CHANGE, this.onChangePasswordBlock);

            this.repeatPassInput.addEventListener(FocusEvent.FOCUS_IN, restoreInput);
            this.repeatPassInput.addEventListener(FocusEvent.FOCUS_IN, this.onChangePasswordBlock);
            this.repeatPassInput.addEventListener(Event.CHANGE, this.onChangePasswordBlock);

            this.changePasswordButton.addEventListener(MouseEvent.CLICK, this.onClickChangePassword);

            this.emailInput.addEventListener(FocusEvent.FOCUS_IN, restoreInput);
            this.emailInput.addEventListener(FocusEvent.FOCUS_IN, this.onChangeEmailInput);
            this.emailInput.addEventListener(Event.CHANGE, this.onChangeEmailInput);

            this.setEmailButton.addEventListener(MouseEvent.CLICK, this.onClickSetEmailButton);
            this.unbindEmailButton.addEventListener(MouseEvent.CLICK, this.onCLickUnbindEmailButton);
            this.confirmEmailButton.addEventListener(MouseEvent.CLICK, this.onClickConfirmEmailButton);

            this.codeConfirmButton.addEventListener(MouseEvent.CLICK, onCLickCodeConfirm);
        }

        private function onCLickCodeConfirm(e:Event):void
        {
            this.codeConfirmFunction();
            this.codePanel.visible = false;
            this.codeInput.value = "";
            this.codeConfirmFunction = null;
        }

        private function initLogicEvents():void
        {
            this.addEventListener(AccountSettingsEvent.CHANGE_PASSWORD, this.sendChangePasswordCommand);
            this.addEventListener(AccountSettingsEvent.SET_EMAIL, this.sendSetEmailCommand);
            this.addEventListener(AccountSettingsEvent.UNBIND_EMAIL, this.sendUnbindEmailCommand);
            this.addEventListener(AccountSettingsEvent.CONFIRM_EMAIL, this.sendConfirmEmailCommand);
        }

        private static function restoreInput(param1:Event):void
        {
            var _loc2_:TankInputBase = param1.currentTarget as TankInputBase;
            _loc2_.validValue = true;
        }

        private static function isPasswordValid(param1:String):Boolean
        {
            return param1 == "" ||
                param1.length >= 4 && forbiddenPasswords.indexOf(param1.toLowerCase()) == -1;
        }

        private function initUserData(userData:UserData):void
        {
            this.setEmailButton.enable = false;
            this.unbindEmailButton.enable = false;
            this.confirmEmailButton.enable = false;
            this.setEmailButton.visible = false;
            this.unbindEmailButton.visible = false;
            this.confirmEmailButton.visible = false;

            if (userData.userEmail == null)
            {
                this.emailInput.enable = true;
                this.setEmailButton.visible = true;
                this.setEmailButton.enable = true;
            }
            else if (userData.isMailConfirmed)
            {
                this.emailInput.textField.text = userData.userEmail;
                this.emailInput.enable = false;
                this.unbindEmailButton.visible = true;
                this.unbindEmailButton.enable = true;
            }
            else
            {
                this.emailInput.textField.text = userData.userEmail;
                this.emailInput.enable = true;
                this.confirmEmailButton.visible = true;
                this.confirmEmailButton.enable = true;
            }
            this.codePanel.visible = false;
        }

        private function onClickSetEmailButton(param1:MouseEvent):void
        {
            dispatchEvent(new AccountSettingsEvent(AccountSettingsEvent.SET_EMAIL));
        }

        private function onCLickUnbindEmailButton(param1:MouseEvent):void
        {
            dispatchEvent(new AccountSettingsEvent(AccountSettingsEvent.UNBIND_EMAIL));
        }

        private function onClickConfirmEmailButton(param1:MouseEvent):void
        {
            dispatchEvent(new AccountSettingsEvent(AccountSettingsEvent.CONFIRM_EMAIL));
        }

        private function onClickChangePassword(param1:MouseEvent = null):void
        {
            if (this.oldPassword != "" && this.password != "")
            {
                dispatchEvent(new AccountSettingsEvent(AccountSettingsEvent.CHANGE_PASSWORD));
                this.oldPasswordInput.textField.text = "";
                this.newPassInput.textField.text = "";
                this.repeatPassInput.textField.text = "";
            }
        }

        private function onChangeEmailInput(param1:Event = null):void
        {
            if (this.emailInput.textField.text != this.userData.userEmail)
            {
                this.setEmailButton.enable = true;
                this.setEmailButton.visible = true;
                this.unbindEmailButton.visible = false;
                this.confirmEmailButton.visible = false;
            }
        }

        private function onChangePasswordBlock(param1:Event = null):void
        {
            this.newPassInput.validValue = isPasswordValid(this.newPassInput.value);
            this.pass1State = CallsignIconStates.CALLSIGN_ICON_STATE_INVALID;
            this.repeatPassInput.validValue = this.repeatPassInput.value == "" ||
                this.newPassInput.value == this.repeatPassInput.value;
            this.pass2State = CallsignIconStates.CALLSIGN_ICON_STATE_INVALID;
            if (this.newPassInput.value == "")
            {
                this.pass1State = CallsignIconStates.CALLSIGN_ICON_STATE_OFF;
            }
            else if (this.newPassInput.validValue)
            {
                this.pass1State = CallsignIconStates.CALLSIGN_ICON_STATE_VALID;
            }
            if (this.repeatPassInput.value == "")
            {
                this.pass2State = CallsignIconStates.CALLSIGN_ICON_STATE_OFF;
            }
            else if (this.repeatPassInput.validValue)
            {
                this.pass2State = CallsignIconStates.CALLSIGN_ICON_STATE_VALID;
            }

            this.changePasswordButton.enable = this.newPassInput.value == this.repeatPassInput.value && this.newPassInput.validValue && this.repeatPassInput.validValue;
        }

        private function onChangeOldPasswordInput(param1:Event):void
        {
            this.oldPasswordCheckIcon.visible = false;
            this.oldPasswordInput.validValue = true;
        }

        public function highlightIncorrectOldPassword():void
        {
            this.oldPasswordInput.validValue = false;
            this.oldPasswordCheckIcon.visible = true;
        }

        private function set pass1State(state:int):void
        {
            if (state == CallsignIconStates.CALLSIGN_ICON_STATE_OFF)
            {
                this.newPassCheckIcon.visible = false;
            }
            else
            {
                this.newPassCheckIcon.visible = true;
                this.newPassCheckIcon.gotoAndStop(state);
            }
        }

        private function set pass2State(state:int):void
        {
            if (state == CallsignIconStates.CALLSIGN_ICON_STATE_OFF)
            {
                this.repeatPassCheckIcon.visible = false;
            }
            else
            {
                this.repeatPassCheckIcon.visible = true;
                this.repeatPassCheckIcon.gotoAndStop(state);
            }
        }

        private function set emailState(state:int):void
        {
            if (state == CallsignIconStates.CALLSIGN_ICON_STATE_OFF)
            {
                this.emailCheckIcon.visible = false;
            }
            else
            {
                this.emailCheckIcon.visible = true;
                this.emailCheckIcon.gotoAndStop(state);
            }
        }

        private function get password():String
        {
            var pass:String = "";
            if (Boolean(this.newPassInput.textField.text))
            {
                if (this.newPassInput.textField.text == this.repeatPassInput.textField.text)
                {
                    pass = this.newPassInput.textField.text;
                }
            }
            return pass;
        }

        private function get oldPassword():String
        {
            return this.oldPasswordInput != null ? this.oldPasswordInput.value : "";
        }

        private function get email():String
        {
            return this.emailInput.value;
        }

        override public function destroy():void
        {
            destroyGuiEvents();
            this.userData.removeListener(this);
            super.destroy();
        }

        private function destroyGuiEvents():void
        {

            this.oldPasswordInput.removeEventListener(FocusEvent.FOCUS_IN, this.onChangeOldPasswordInput);
            this.oldPasswordInput.removeEventListener(Event.CHANGE, this.onChangeOldPasswordInput);

            this.newPassInput.removeEventListener(FocusEvent.FOCUS_IN, restoreInput);
            this.newPassInput.removeEventListener(FocusEvent.FOCUS_IN, this.onChangePasswordBlock);
            this.newPassInput.removeEventListener(Event.CHANGE, this.onChangePasswordBlock);

            this.repeatPassInput.removeEventListener(FocusEvent.FOCUS_IN, restoreInput);
            this.repeatPassInput.removeEventListener(FocusEvent.FOCUS_IN, this.onChangePasswordBlock);
            this.repeatPassInput.removeEventListener(Event.CHANGE, this.onChangePasswordBlock);

            this.changePasswordButton.removeEventListener(MouseEvent.CLICK, this.onClickChangePassword);

            this.emailInput.removeEventListener(FocusEvent.FOCUS_IN, restoreInput);
            this.emailInput.removeEventListener(FocusEvent.FOCUS_IN, this.onChangeEmailInput);
            this.emailInput.removeEventListener(Event.CHANGE, this.onChangeEmailInput);

            this.setEmailButton.removeEventListener(MouseEvent.CLICK, this.onClickSetEmailButton);
            this.unbindEmailButton.removeEventListener(MouseEvent.CLICK, this.onCLickUnbindEmailButton);
            this.confirmEmailButton.removeEventListener(MouseEvent.CLICK, this.onClickConfirmEmailButton);

            this.codeConfirmButton.removeEventListener(MouseEvent.CLICK, onCLickCodeConfirm);
        }

        private function sendChangePasswordCommand(param1:Event = null):void
        {
            var network:Network = Main.osgi.getService(INetworker) as Network;
            network.send("lobby;change_password;" + this.oldPassword + ";" + this.password);
        }

        private function sendSetEmailCommand(event:AccountSettingsEvent):void
        {
            this.setEmailButton.enable = false;
            var network:Network = Main.osgi.getService(INetworker) as Network;
            network.send("lobby;change_email;" + this.email);
        }

        private function sendUnbindEmailCommand(event:AccountSettingsEvent):void
        {
            this.unbindEmailButton.enable = false;
            this.codePanel.visible = true;
            this.codeConfirmButton.enable = true;
            this.codeConfirmFunction = function():void
            {
                var network:Network = Main.osgi.getService(INetworker) as Network;
                network.send("lobby;unbind_email;" + codeInput.value);
                this.codeConfirmButton.enable = false;
                this.codePanel.visible = false;
            }
            var network:Network = Main.osgi.getService(INetworker) as Network;
            network.send("lobby;send_code_unbind_email");
        }

        private function sendConfirmEmailCommand(event:AccountSettingsEvent):void
        {
            this.emailInput.enable = false;
            this.confirmEmailButton.enable = false;
            this.codePanel.visible = true;
            this.codeConfirmFunction = function():void
            {
                var network:Network = Main.osgi.getService(INetworker) as Network;
                network.send("lobby;confirm_email;" + codeInput.value);
                this.codeConfirmButton.enable = false;
                this.codePanel.visible = false;
            }

            var network:Network = Main.osgi.getService(INetworker) as Network;
            network.send("lobby;send_confirm_email_code");

        }

        public function userDataChanged(userData:UserData):void
        {
            initUserData(userData);
        }
    }
}
