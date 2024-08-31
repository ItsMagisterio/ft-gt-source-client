package forms
{
    import flash.display.Sprite;
    import controls.TankWindow;
    import controls.Label;
    import controls.DefaultButton;
    import flash.display.Bitmap;
    import flash.utils.Timer;
    import alternativa.init.Main;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.tanks.locale.constants.TextConst;
    import flash.events.Event;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import __AS3__.vec.Vector;
    import flash.display.BitmapData;
    import flash.filters.BlurFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BitmapFilter;
    import flash.display.DisplayObject;
    import forms.events.AlertEvent;
    import __AS3__.vec.*;

    public class Alert extends Sprite
    {

        public static const ALERT_QUIT:int = 0;
        public static const ALERT_CONFIRM_EMAIL:int = 1;
        public static const ERROR_CALLSIGN_FIRST_SYMBOL:int = 2;
        public static const ERROR_CALLSIGN_DEVIDE:int = 3;
        public static const ERROR_CALLSIGN_LAST_SYMBOL:int = 4;
        public static const ERROR_CALLSIGN_LENGTH:int = 5;
        public static const ERROR_CALLSIGN_UNIQUE:int = 6;
        public static const ERROR_PASSWORD_LENGTH:int = 7;
        public static const ERROR_PASSWORD_INCORRECT:int = 8;
        public static const ERROR_PASSWORD_CHANGE:int = 9;
        public static const ERROR_EMAIL_UNIQUE:int = 10;
        public static const ERROR_EMAIL_INVALID:int = 11;
        public static const ERROR_EMAIL_NOTFOUND:int = 12;
        public static const ERROR_EMAIL_NOTSENDED:int = 13;
        public static const ERROR_FATAL:int = 14;
        public static const ERROR_FATAL_DEBUG:int = 15;
        public static const ERROR_BAN:int = 19;
        public static const GARAGE_AVAILABLE:int = 16;
        public static const ALERT_RECOVERY_LINK_SENDED:int = 17;
        public static const ALERT_CHAT_PROCEED:int = 18;
        public static const WRONG_CAPTCHA:int = 20;
        public static const ALERT_CONFIRM_BATTLE_EXIT:int = 21;
        public static const ALERT_CONFIRM_REMOVE_FRIEND:int = 22;
        public static const ALERT_OPBAT:int = 23;
        public static const ALERT_PBAT:int = 24;
        public static const PASSWORD_CHANGED:int = 25;

        protected var bgWindow:TankWindow = new TankWindow();
        private var output:Label = new Label();
        public var _msg:String;
        private var labeledButton:DefaultButton;
        private var _labels:Array;
        private var bmp:Bitmap = new Bitmap();
        protected var alertWindow:Sprite = new Sprite();
        public var closeButton:MainPanelCloseButton = new MainPanelCloseButton();
        private var _closable:Boolean = false;
        private var alerts:Array = new Array();

        public function Alert(id:int = -1, closable:Boolean = false)
        {
            var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            this._closable = closable;
            this.bgWindow.headerLang = localeService.getText(TextConst.GUI_LANG);
            if (AlertAnswer.YES == null)
            {
                this.fillAlerts();
            }
            this.alerts[ALERT_QUIT] = [localeService.getText(TextConst.ALERT_QUIT_TEXT), [AlertAnswer.YES, AlertAnswer.NO]];
            this.alerts[ALERT_CONFIRM_EMAIL] = [localeService.getText(TextConst.ALERT_EMAIL_CONFIRMED), [AlertAnswer.YES]];
            this.alerts[ERROR_FATAL] = [localeService.getText(TextConst.ERROR_FATAL), [AlertAnswer.RETURN]];
            this.alerts[ERROR_FATAL_DEBUG] = [localeService.getText(TextConst.ERROR_FATAL_DEBUG), [AlertAnswer.SEND]];
            this.alerts[ERROR_CALLSIGN_FIRST_SYMBOL] = [localeService.getText(TextConst.ERROR_CALLSIGN_WRONG_FIRST_SYMBOL), [AlertAnswer.OK]];
            this.alerts[ERROR_CALLSIGN_DEVIDE] = [localeService.getText(TextConst.ERROR_CALLSIGN_NOT_SINGLE_DEVIDERS), [AlertAnswer.OK]];
            this.alerts[ERROR_CALLSIGN_LAST_SYMBOL] = [localeService.getText(TextConst.ERROR_CALLSIGN_WRONG_LAST_SYMBOL), [AlertAnswer.OK]];
            this.alerts[ERROR_CALLSIGN_LENGTH] = [localeService.getText(TextConst.ERROR_CALLSIGN_LENGTH), [AlertAnswer.OK]];
            this.alerts[ERROR_CALLSIGN_UNIQUE] = [localeService.getText(TextConst.ERROR_CALLSIGN_NOT_UNIQUE), [AlertAnswer.OK]];
            this.alerts[ERROR_EMAIL_UNIQUE] = [localeService.getText(TextConst.ERROR_EMAIL_NOT_UNIQUE), [AlertAnswer.OK]];
            this.alerts[ERROR_EMAIL_INVALID] = [localeService.getText(TextConst.ERROR_EMAIL_INVALID), [AlertAnswer.OK]];
            this.alerts[ERROR_EMAIL_NOTFOUND] = [localeService.getText(TextConst.ERROR_EMAIL_NOT_FOUND), [AlertAnswer.OK]];
            this.alerts[ERROR_EMAIL_NOTSENDED] = [localeService.getText(TextConst.ERROR_EMAIL_NOT_SENDED), [AlertAnswer.OK]];
            this.alerts[ERROR_PASSWORD_INCORRECT] = [localeService.getText(TextConst.ERROR_PASSWORD_INCORRECT), [AlertAnswer.OK]];
            this.alerts[ERROR_PASSWORD_LENGTH] = [localeService.getText(TextConst.ERROR_PASSWORD_LENGTH), [AlertAnswer.OK]];
            this.alerts[ERROR_PASSWORD_CHANGE] = [localeService.getText(TextConst.ERROR_PASSWORD_CHANGE), [AlertAnswer.OK]];
            this.alerts[GARAGE_AVAILABLE] = [localeService.getText(TextConst.ALERT_GARAGE_AVAILABLE), [AlertAnswer.GARAGE, AlertAnswer.CANCEL]];
            this.alerts[ALERT_RECOVERY_LINK_SENDED] = [localeService.getText(TextConst.ALERT_RECOVERY_LINK_SENDED), [AlertAnswer.OK]];
            this.alerts[ALERT_CHAT_PROCEED] = [localeService.getText(TextConst.ALERT_CHAT_PROCEED_EXTERNAL_LINK), [AlertAnswer.CANCEL]];
            this.alerts[ERROR_BAN] = [localeService.getText(TextConst.ERROR_ACCOUNT_BAN), [AlertAnswer.OK]];
            this.alerts[WRONG_CAPTCHA] = [localeService.getText(TextConst.ERROR_WRONG_CAPTCHA), [AlertAnswer.OK]];
            this.alerts[ALERT_CONFIRM_BATTLE_EXIT] = [localeService.getText(TextConst.ALERT_CONFIRM_BATTLE_EXIT), [AlertAnswer.YES, AlertAnswer.NO]];
            this.alerts[ALERT_CONFIRM_REMOVE_FRIEND] = [localeService.getText(TextConst.ALERT_CONFIRM_REMOVE_FRIEND), [AlertAnswer.YES, AlertAnswer.NO]];
            this.alerts[ALERT_OPBAT] = ["Return to battle?", [AlertAnswer.YES, AlertAnswer.NO]];
            this.alerts[ALERT_PBAT] = ["Exit from battle?", [AlertAnswer.YES, AlertAnswer.NO]];
            this.alerts[PASSWORD_CHANGED] = [localeService.getText(TextConst.ALERT_PASSWORD_CHANGED), [AlertAnswer.OK]];
            if (id > -1)
            {
                this.showAlert(this.alerts[id][0], this.alerts[id][1]);
            }
        }
        private function fillAlerts():void
        {
            var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            AlertAnswer.YES = localeService.getText(TextConst.ALERT_ANSWER_YES);
            AlertAnswer.NO = localeService.getText(TextConst.ALERT_ANSWER_NO);
            AlertAnswer.OK = localeService.getText(TextConst.ALERT_ANSWER_OK);
            AlertAnswer.CANCEL = localeService.getText(TextConst.ALERT_ANSWER_CANCEL);
            AlertAnswer.SEND = localeService.getText(TextConst.ALERT_ANSWER_SEND_BUG_REPORT);
            AlertAnswer.RETURN = localeService.getText(TextConst.ALERT_ANSWER_RETURN_TO_BATTLE);
            AlertAnswer.GARAGE = localeService.getText(TextConst.ALERT_ANSWER_GO_TO_GARAGE);
            AlertAnswer.PROCEED = localeService.getText(TextConst.ALERT_ANSWER_PROCEED);
        }
        public function showAlert(message:String, labels:Array):void
        {
            this._msg = message;
            this._labels = labels;
            addEventListener(Event.ADDED_TO_STAGE, this.doLayout);
        }
        protected function doLayout(e:Event):void
        {
            var i:int;
            var oneButtonWidth:int = this.calculateButtonsWidth();
            var bwidth:int = int(((oneButtonWidth * this._labels.length) / 2));
            removeEventListener(Event.ADDED_TO_STAGE, this.doLayout);
            addChild(this.alertWindow);
            this.alertWindow.addChild(this.bgWindow);
            this.alertWindow.addChild(this.output);
            this.output.autoSize = TextFieldAutoSize.CENTER;
            this.output.align = TextFormatAlign.CENTER;
            this.output.size = 14;
            this.output.width = 10;
            this.output.height = 10;
            this.output.x = -5;
            this.output.y = 30;
            this.output.multiline = true;
            this.output.htmlText = this._msg;
            if (this._labels.length != 0)
            {
                i = 0;
                while (i < this._labels.length)
                {
                    this.labeledButton = new DefaultButton();
                    this.labeledButton.label = this._labels[i];
                    this.labeledButton.x = ((oneButtonWidth * i) - bwidth);
                    this.labeledButton.y = ((this.output.y + this.output.height) + 15);
                    this.labeledButton.width = (oneButtonWidth - 6);
                    this.labeledButton.addEventListener(MouseEvent.CLICK, this.close);
                    this.alertWindow.addChild(this.labeledButton);
                    i++;
                }
                this.bgWindow.height = (this.labeledButton.y + 60);
            }
            else
            {
                this.bgWindow.height = ((this.output.y + this.output.height) + 30);
            }
            this.bgWindow.width = Math.max(int((this.output.width + 50)), ((bwidth * 2) + 50));
            this.bgWindow.x = (-(int((this.bgWindow.width / 2))) - 3);
            stage.addEventListener(Event.RESIZE, this.onResize);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false, -3);
            this.onResize(null);
        }
        private function onKeyUp(param1:KeyboardEvent):void
        {
            var label:String;
            var event:MouseEvent;
            switch (this._labels.length)
            {
                case 1:
                    if (((param1.keyCode == Keyboard.ENTER) || (param1.keyCode == Keyboard.ESCAPE)))
                    {
                        label = this._labels[0];
                    }
                    break;
                case 2:
                    if (param1.keyCode == Keyboard.ENTER)
                    {
                        label = this.getFirstExistingLabel(this.getConfirmationButtonNames());
                    }
                    else
                    {
                        if (param1.keyCode == Keyboard.ESCAPE)
                        {
                            if (_closable == true)
                            {
                                _closable = false;
                            }
                            else
                            {
                                label = this.getFirstExistingLabel(this.getCancelButtonNames());
                            }
                        }
                    }
            }
            if (label != null)
            {
                param1.stopImmediatePropagation();
                event = new MouseEvent(MouseEvent.CLICK, true, false, Number(null), Number(null), this.getButtonByLabel(label));
                this.forceClose(this.getButtonByLabel(label));
            }
        }
        private function getConfirmationButtonNames():Vector.<String>
        {
            return (Vector.<String>([AlertAnswer.OK, AlertAnswer.YES, AlertAnswer.GARAGE, AlertAnswer.PROCEED, AlertAnswer.SEND]));
        }
        private function getCancelButtonNames():Vector.<String>
        {
            return (Vector.<String>([AlertAnswer.NO, AlertAnswer.CANCEL, AlertAnswer.RETURN]));
        }
        private function getFirstExistingLabel(param1:Vector.<String>):String
        {
            var _loc3_:int;
            var _loc2_:int;
            while (_loc2_ < this._labels.length)
            {
                _loc3_ = param1.indexOf(this._labels[_loc2_]);
                if (_loc3_ > -1)
                {
                    return (param1[_loc3_]);
                }
                _loc2_++;
            }
            return ("");
        }
        private function calculateButtonsWidth():int
        {
            var buttonWidth:int = 80;
            var tempLabel:Label = new Label();
            var i:int;
            while (i < this._labels.length)
            {
                tempLabel.text = this._labels[i];
                if (tempLabel.width > buttonWidth)
                {
                    buttonWidth = tempLabel.width;
                }
                i++;
            }
            return (buttonWidth + 18);
        }
        private function drawBg():void
        {
            var myFilters:Array;
            var data:BitmapData;
            var filter:BitmapFilter = new BlurFilter(5, 5, BitmapFilterQuality.LOW);
            myFilters = new Array();
            myFilters.push(filter);
            data = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0);
            this.bmp.visible = false;
            data.draw(stage);
            this.bmp.visible = true;
            this.bmp.filters = myFilters;
            this.bmp.bitmapData = data;
        }
        private function onResize(e:Event):void
        {
            this.alertWindow.x = int((stage.stageWidth / 2));
            this.alertWindow.y = int(((stage.stageHeight / 2) - (this.alertWindow.height / 2)));
        }
        private function getButtonByLabel(label:String):DefaultButton
        {
            var trgt:DisplayObject;
            var i:int;
            while (i < this.alertWindow.numChildren)
            {
                trgt = this.alertWindow.getChildAt(i);
                if (((trgt is DefaultButton) || (trgt == this.closeButton)))
                {
                    if ((trgt as DefaultButton).label == label)
                    {
                        return (trgt as DefaultButton);
                    }
                }
                i++;
            }
            return (null);
        }
        private function forceClose(e:DefaultButton):void
        {
            var trgt:DisplayObject;
            var etarg:DefaultButton = e;
            stage.removeEventListener(Event.RESIZE, this.onResize);
            stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            var i:int;
            while (i < this.alertWindow.numChildren)
            {
                trgt = this.alertWindow.getChildAt(i);
                if (((trgt is DefaultButton) || (trgt == this.closeButton)))
                {
                    trgt.removeEventListener(MouseEvent.CLICK, this.close);
                }
                i++;
            }
            if (etarg != null)
            {
                dispatchEvent(new AlertEvent(etarg.label));
            }
            parent.removeChild(this);
        }
        private function close(e:MouseEvent):void
        {
            var trgt:DisplayObject;
            var etarg:DefaultButton = (e.currentTarget as DefaultButton);
            stage.removeEventListener(Event.RESIZE, this.onResize);
            stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            var i:int;
            while (i < this.alertWindow.numChildren)
            {
                trgt = this.alertWindow.getChildAt(i);
                if (((trgt is DefaultButton) || (trgt == this.closeButton)))
                {
                    trgt.removeEventListener(MouseEvent.CLICK, this.close);
                }
                i++;
            }
            if (etarg != null)
            {
                dispatchEvent(new AlertEvent(etarg.label));
            }
            parent.removeChild(this);
        }

    }
}
