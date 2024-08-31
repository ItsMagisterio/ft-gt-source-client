package forms.battlelist
{
    import flash.display.Sprite;
    import controls.TankWindow;
    import controls.TankCombo;
    import controls.TankInput;
    import assets.icons.InputCheckIcon;
    import controls.TypeBattleButton;
    import controls.TankCheckBox;
    import controls.NumStepper;
    import controls.slider.SelectRank;
    import flash.utils.Timer;
    import controls.RedButton;
    import flash.utils.Dictionary;
    import flash.events.Event;
    import forms.TankWindowWithHeader;
    import forms.events.LoginFormEvent;
    import flash.events.FocusEvent;
    import alternativa.init.Main;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.tanks.locale.constants.TextConst;
    import controls.TankWindowHeader;
    import flash.events.TimerEvent;
    import flash.events.MouseEvent;
    import assets.icons.BattleInfoIcons;
    import forms.events.SliderEvent;
    import forms.events.BattleListEvent;

    public class CreateBattleForm extends Sprite
    {

        public static const NAMEGAME_STATE_OFF:int = 0;
        public static const NAMEGAME_STATE_PROGRESS:int = 1;
        public static const NAMEGAME_STATE_VALID:int = 2;
        public static const NAMEGAME_STATE_INVALID:int = 3;

        private var mainBackground:TankWindowWithHeader;
        public var mapsCombo:TankCombo = new TankCombo();
        public var nameGame:TankInput;
        public var nameGameCheckIcon:InputCheckIcon;
        public var themeCombo:TankCombo = new TankCombo();
        public var modeCombo:TankCombo = new TankCombo();
        private var dmCheck:TypeBattleButton = new TypeBattleButton();
        private var tdmCheck:TypeBattleButton = new TypeBattleButton();
        private var ctfCheck:TypeBattleButton = new TypeBattleButton();
        private var domCheck:TypeBattleButton = new TypeBattleButton();
        private var autobalance:TankCheckBox = new TankCheckBox();
        private var friendlyfire:TankCheckBox = new TankCheckBox();
        private var privateCheck:TankCheckBox = new TankCheckBox();
        private var hrModeCheck:TankCheckBox = new TankCheckBox();
        private var payCheck:TankCheckBox = new TankCheckBox();
        private var inventoryCheck:TankCheckBox = new TankCheckBox();
        private var equipmentChange:TankCheckBox = new TankCheckBox();
        private var microUpgrades:TankCheckBox = new TankCheckBox();
        private var players:NumStepper = new NumStepper();
        private var minutes:NumStepper = new NumStepper();
        private var kills:NumStepper = new NumStepper();
        private var flags:NumStepper = new NumStepper();
        private var points:NumStepper = new NumStepper(10);
        public var info:BattleInfo = new BattleInfo();
        private var selectRang:SelectRank = new SelectRank();
        private var _currentRang:int = 1;
        private var delayTimer:Timer;
        private var autoname:Boolean = true;
        private var startButton:RedButton = new RedButton();
        private var MAP_NAME_LABEL:String = "";
        private var MAP_TYPE_LABEL:String = "";
        private var MAP_THEME_LABEL:String = "";
        private var BUTTON_DEATHMATCH:String = "";
        private var BUTTON_TEAM_DEATHMATCH:String = "";
        private var BUTTON_CAPTURE_THE_FLAG:String = "";
        private var BUTTON_START:String = "";
        private var STEPPER_MAX_PLAYERS:String = "";
        private var STEPPER_MAX_TEAM_SIZE:String = "";
        private var STEPPER_TIME_LIMIT:String = "";
        private var STEPPER_KILLS_LIMIT:String = "";
        private var STEPPER_FLAG_LIMIT:String = "";
        private var CHECKBOX_AUTOBALANCE:String = "";
        private var CHECKBOX_FRIENDLY_FIRE:String = "";
        private var CHECKBOX_PRIVATE_BATTLE:String = "";
        private var CHECKBOX_PAY_BATTLE:String = "";
        private var CHECKBOX_HR_MODE:String = "";
        private var CHECKBOX_BONUS:String = "";
        private var COST_LABEL:String = "";
        private var costLabel:TankInput = new TankInput();
        private var _haveSubscribe:Boolean;
        private var noSubscribeAlert:NoSubScribeAlert = new NoSubScribeAlert();
        private var searchTimer:Timer = new Timer(1200);
        private var mapsarr:Array = new Array();
        private var mapsThemes:Dictionary = new Dictionary();
        private var _nameGameState:int = 0;
        private var maxP:int = 0;
        private var ctfEnable:Boolean = false;
        private var tdmEnable:Boolean = false;
        private var domEnable:Boolean = false;
        private var typeGame:String = "DM";
        private var gameFormat:int = 0;
        private var gameFormatString:String = "Without Format";

        public function CreateBattleForm(haveSubscribe:Boolean)
        {
            addEventListener(Event.ADDED_TO_STAGE, this.ConfigUI);
            addEventListener(Event.ADDED_TO_STAGE, this.addResizeListener);
            addEventListener(Event.REMOVED_FROM_STAGE, this.removeResizeListener);
            this._haveSubscribe = haveSubscribe;
        }
        public function get gameName():String
        {
            return (this.nameGame.value);
        }
        public function set gameName(value:String):void
        {
            removeEventListener(LoginFormEvent.TEXT_CHANGED, this.checkName);
            this.nameGame.value = value;
            addEventListener(LoginFormEvent.TEXT_CHANGED, this.checkName);
            this.nameGameState = NAMEGAME_STATE_OFF;
            this.calculatePayment();
        }
        public function set maps(array:Array):void
        {
            var item:BattleMap;
            var theme:String;
            this.mapsarr = array;
            this.mapsCombo.clear();
            this.mapsThemes = new Dictionary();
            var i:int;
            while (i < array.length)
            {
                item = (array[i] as BattleMap);
                theme = item.themeName;
                if (this._currentRang <= item.maxRank)
                {
                    if (this.mapsThemes[item.gameName] == null)
                    {
                        this.mapsThemes[item.gameName] = new Dictionary();
                        this.mapsCombo.addItem( {
                                    "gameName": item.gameName,
                                    "id": item.id,
                                    "preview": item.preview,
                                    "minRank": item.minRank,
                                    "maxRank": item.maxRank,
                                    "rang": ((this._currentRang >= item.minRank) ? 0 : item.minRank),
                                    "maxP": item.maxPeople,
                                    "ctf": item.ctf,
                                    "tdm": item.tdm,
                                    "dom": item.dom,
                                    "hr": item.hr
                                });
                    }
                    this.mapsThemes[item.gameName][theme] = item.id;
                }
                i++;
            }
            this.mapsCombo.sortOn(["rang", "gameName"], [Array.NUMERIC, null]);
            var itemm:Object = this.mapsCombo.selectedItem;
            var min:int = ((itemm.minRank < 1) ? 1 : itemm.minRank);
            var max:int = ((itemm.maxRank > 30) ? 30 : itemm.maxRank);
            this.info.setUp("", "", 0, 0, 0, 0, 0);
            this.selectRang.maxValue = max;
            this.selectRang.minValue = min;
            if (this.selectRang.minRang < this.selectRang.minValue)
            {
                this.selectRang.minRang = this.selectRang.minValue;
            }
            if (this.selectRang.maxRang > this.selectRang.maxValue)
            {
                this.selectRang.maxRang = this.selectRang.maxValue;
            }
            this.players.maxValue = (this.players.value = ((!(this.dmCheck.enable)) ? itemm.maxP : int(int((itemm.maxP / 2)))));
            this.maxP = itemm.maxP;
            this.ctfEnable = itemm.ctf;
            this.tdmEnable = itemm.tdm;
            this.domEnable = itemm.dom;
            this.ctfCheck.visible = this.ctfEnable;
            this.hrModeCheck.visible = itemm.hr;
            this.hrModeCheck.checked = false;
            this.tdmCheck.visible = this.tdmEnable;
            if (((!(this.ctfEnable)) && (!(this.deathMatch))))
            {
                this.dmCheck.enable = true;
                this.tdmCheck.enable = false;
                this.ctfCheck.enable = true;
                this.domCheck.enable = true;
                this.friendlyfire.visible = true;
                this.autobalance.visible = true;
                this.players.maxValue = int((this.maxP / 2));
                this.players.minValue = 1;
                this.players.value = int((this.maxP / 2));
                this.players.label = this.STEPPER_MAX_TEAM_SIZE;
                this.flags.visible = false;
                this.kills.visible = true;
                this.points.visible = false;
            }
            else
            {
                if (this.ctfEnable)
                {
                    this.flags.visible = ((this.ctfEnable) && (!(this.ctfCheck.enable)));
                    this.kills.visible = ((!(this.flags.visible)) && (!(this.points.visible)));
                    this.points.visible = false;
                }
                else
                {
                    if (this.domEnable)
                    {
                        this.flags.visible = false;
                        this.kills.visible = false;
                        this.points.visible = true;
                    }
                }
            }
            if (stage != null)
            {
                this.onResize(null);
            }
            this.updateThemesCombo(this.mapsCombo.selectedItem);
            this.mapsCombo.dispatchEvent(new Event(Event.CHANGE));
        }
        public function set currentRang(value:int):void
        {
            this._currentRang = (this.selectRang.currentRang = value);
            this.selectRang.minRang = (this._currentRang - 2);
            this.selectRang.maxRang = (this._currentRang + 2);
            this.maps = this.mapsarr;
            this.onChange(null);
        }
        public function get mapName():String
        {
            return (this.mapsCombo.selectedItem.gameName);
        }
        public function get mapID():Object
        {
            return (this.themeCombo.selectedItem.id);
        }
        public function get deathMatch():Boolean
        {
            return (!(this.dmCheck.enable));
        }
        public function get autoBalance():Boolean
        {
            return (this.autobalance.checked);
        }
        public function get friendlyFire():Boolean
        {
            return (this.friendlyfire.checked);
        }
        public function get PrivateBattle():Boolean
        {
            return (this.privateCheck.checked);
        }
        public function get getMode():int
        {
            return (this.modeCombo.selectedItem.type);
        }
        public function get microUpradesEnabled():Boolean
        {
            return this.microUpgrades.checked;
        }
        public function get changeEquipment():Boolean
        {
            return this.equipmentChange.checked;
        }
        public function get proBattle():Boolean
        {
            return (this.payCheck.checked);
        }
        public function get inventoryBattle():Boolean
        {
            return ((this.payCheck.checked) && (this.inventoryCheck.checked));
        }
        public function get CaptureTheFlag():Boolean
        {
            return (!(this.ctfCheck.enable));
        }
        public function get Team():Boolean
        {
            return (!(this.tdmCheck.enable));
        }
        public function get DOM():Boolean
        {
            return (!(this.domCheck.enable));
        }
        public function get time():int
        {
            return (this.minutes.value * 60);
        }
        public function get numPlayers():int
        {
            return (this.players.value);
        }
        public function get numKills():int
        {
            return (this.kills.value);
        }
        public function get numFlags():int
        {
            return (this.flags.value);
        }
        public function get numPoints():int
        {
            return (this.points.value);
        }
        public function get haveSubscribe():Boolean
        {
            return (this._haveSubscribe);
        }
        public function set haveSubscribe(value:Boolean):void
        {
            this._haveSubscribe = value;
            this.onPayCheckClick();
        }
        public function get battleFormat():int
        {
            return this.gameFormat;
        }
        private function addResizeListener(e:Event):void
        {
            this.autoname = true;
            this.startButton.enable = false;
            this.nameGame.textField.addEventListener(FocusEvent.FOCUS_IN, this.checkAutoName);
            this.nameGame.textField.addEventListener(FocusEvent.FOCUS_OUT, this.checkAutoName);
            addEventListener(LoginFormEvent.TEXT_CHANGED, this.checkName);
            stage.addEventListener(Event.RESIZE, this.onResize);
            this.onResize(null);
        }
        private function removeResizeListener(e:Event):void
        {
            stage.removeEventListener(Event.RESIZE, this.onResize);
            removeEventListener(LoginFormEvent.TEXT_CHANGED, this.checkName);
            this.nameGame.textField.removeEventListener(FocusEvent.FOCUS_IN, this.checkAutoName);
            this.nameGame.textField.removeEventListener(FocusEvent.FOCUS_OUT, this.checkAutoName);
        }
        public function get minRang():int
        {
            return (this.selectRang.minRang);
        }
        public function get maxRang():int
        {
            return (this.selectRang.maxRang);
        }
        private function ConfigUI(e:Event):void
        {
            var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            this.MAP_NAME_LABEL = localeService.getText(TextConst.BATTLE_CREATE_PANEL_MAP_NAME_LABEL);
            this.MAP_TYPE_LABEL = localeService.getText(TextConst.BATTLE_CREATE_PANEL_MAP_TYPE_LABEL);
            this.MAP_THEME_LABEL = localeService.getText(TextConst.BATTLE_CREATE_PANEL_MAP_THEME_LABEL);
            this.BUTTON_DEATHMATCH = localeService.getText(TextConst.BATTLE_CREATE_PANEL_BUTTON_DEATHMATCH);
            this.BUTTON_TEAM_DEATHMATCH = localeService.getText(TextConst.BATTLE_CREATE_PANEL_BUTTON_TEAM_DEATHMATCH);
            this.BUTTON_CAPTURE_THE_FLAG = localeService.getText(TextConst.BATTLE_CREATE_PANEL_BUTTON_CAPTURE_THE_FLAG);
            this.BUTTON_START = localeService.getText(TextConst.BATTLE_CREATE_PANEL_BUTTON_START);
            this.STEPPER_MAX_PLAYERS = localeService.getText(TextConst.BATTLE_CREATE_PANEL_STEPPER_MAX_PLAYERS);
            this.STEPPER_MAX_TEAM_SIZE = localeService.getText(TextConst.BATTLE_CREATE_PANEL_STEPPER_MAX_TEAM_SIZE);
            this.STEPPER_TIME_LIMIT = localeService.getText(TextConst.BATTLE_CREATE_PANEL_STEPPER_TIME_LIMIT);
            this.STEPPER_KILLS_LIMIT = localeService.getText(TextConst.BATTLE_CREATE_PANEL_STEPPER_KILLS_LIMIT);
            this.STEPPER_FLAG_LIMIT = localeService.getText(TextConst.BATTLE_CREATE_PANEL_STEPPER_FLAG_LIMIT);
            this.CHECKBOX_AUTOBALANCE = localeService.getText(TextConst.BATTLE_CREATE_PANEL_CHECKBOX_AUTOBALANCE);
            this.CHECKBOX_FRIENDLY_FIRE = localeService.getText(TextConst.BATTLE_CREATE_PANEL_CHECKBOX_FRIENDLY_FIRE);
            this.CHECKBOX_PRIVATE_BATTLE = localeService.getText(TextConst.BATTLE_CREATE_PANEL_CHECKBOX_PRIVATE_BATTLE);
            this.CHECKBOX_PAY_BATTLE = localeService.getText(TextConst.BATTLE_CREATE_PANEL_CHECKBOX_PAY_BATTLE);
            this.CHECKBOX_HR_MODE = localeService.getText(TextConst.BATTLE_CREATE_PANEL_CHECKBOX_HR_MODE);
            this.CHECKBOX_BONUS = localeService.getText(TextConst.BATTLE_CREATE_PANEL_CHECKBOX_BONUS_BATTLE);
            this.COST_LABEL = (localeService.getText(TextConst.BATTLE_CREATE_PANEL_LABEL_COST_BATTLE) + ": ");
            removeEventListener(Event.ADDED_TO_STAGE, this.ConfigUI);
            this.mainBackground = new TankWindowWithHeader("CREATE A BATTLE");
            addChild(this.mainBackground);
            this.nameGame = new TankInput();
            this.nameGameCheckIcon = new InputCheckIcon();
            this.searchTimer.addEventListener(TimerEvent.TIMER, this.updateByTime);
            this.nameGame.label = this.MAP_NAME_LABEL;
            this.nameGame.x = ((this.nameGame.width - this.nameGame.textField.width) + 10);
            this.nameGame.y = 11;
            this.nameGameCheckIcon.y = 18;
            this.nameGame.maxChars = 25;
            addChild(this.nameGame);
            addChild(this.nameGameCheckIcon);
            this.nameGameState = NAMEGAME_STATE_OFF;
            addChild(this.autobalance);
            addChild(this.friendlyfire);
            addChild(this.privateCheck);
            addChild(this.hrModeCheck);
            addChild(this.payCheck);
            addChild(this.microUpgrades);
            addChild(this.equipmentChange);
            this.microUpgrades.label = "Micro upgrades";
            this.equipmentChange.label = "Equipment change";
            this.microUpgrades.checked = true;
            this.equipmentChange.checked = true;
            this.payCheck.type = TankCheckBox.PAY;
            this.payCheck.label = this.CHECKBOX_PAY_BATTLE;
            this.payCheck.addEventListener(MouseEvent.CLICK, this.onPayCheckClick);
            this.payCheck.visible = true;
            addChild(this.inventoryCheck);
            this.inventoryCheck.type = TankCheckBox.INVENTORY;
            this.inventoryCheck.label = this.CHECKBOX_BONUS;
            this.inventoryCheck.visible = false;
            addChild(this.players);
            this.players.icon = BattleInfoIcons.PLAYERS;
            this.players.addEventListener(Event.CHANGE, this.calculatePayment);
            addChild(this.minutes);
            this.minutes.label = this.STEPPER_TIME_LIMIT;
            this.minutes.icon = BattleInfoIcons.TIME_LIMIT;
            this.minutes.addEventListener(Event.CHANGE, this.calculatePayment);
            addChild(this.kills);
            this.kills.label = this.STEPPER_KILLS_LIMIT;
            this.kills.icon = BattleInfoIcons.KILL_LIMIT;
            this.kills.addEventListener(Event.CHANGE, this.calculatePayment);
            addChild(this.flags);
            this.flags.label = this.STEPPER_FLAG_LIMIT;
            this.flags.icon = BattleInfoIcons.CTF;
            this.flags.visible = false;
            this.flags.addEventListener(Event.CHANGE, this.calculatePayment);
            addChild(this.points);
            this.points.label = localeService.getText(TextConst.BATTLE_STAT_SCORE);
            this.points.icon = 100;
            this.points.visible = false;
            this.points.addEventListener(Event.CHANGE, this.calculatePayment);
            this.minutes.minValue = 0;
            this.minutes.maxValue = 999;
            this.minutes.value = 15;
            this.kills.minValue = 0;
            this.kills.maxValue = 999;
            this.flags.minValue = 0;
            this.flags.maxValue = 999;
            this.points.minValue = 0;
            this.points.maxValue = 999;
            this.players.label = this.STEPPER_MAX_PLAYERS;
            this.startButton.x = 320;
            addChild(this.startButton);
            addChild(this.info);
            this.info.x = 11;
            this.info.y = 81;
            addChild(this.selectRang);
            this.selectRang.x = 11;
            this.selectRang.minValue = 1;
            this.selectRang.maxValue = 30;
            this.selectRang.tickInterval = 1;
            this.selectRang.addEventListener(SliderEvent.CHANGE_VALUE, this.onSliderChangeValue);
            this.dmCheck.label = this.BUTTON_DEATHMATCH;
            this.tdmCheck.label = this.BUTTON_TEAM_DEATHMATCH;
            this.tdmCheck.enable = true;
            this.ctfCheck.label = this.BUTTON_CAPTURE_THE_FLAG;
            this.ctfCheck.enable = true;
            this.domCheck.label = "Control\nPoints";
            this.domCheck.enable = true;
            addChild(this.dmCheck);
            addChild(this.tdmCheck);
            addChild(this.ctfCheck);
            addChild(this.domCheck);
            this.dmCheck.enable = false;
            this.autobalance.checked = true;
            this.friendlyfire.checked = false;
            this.friendlyfire.visible = false;
            this.autobalance.visible = false;
            this.dmCheck.addEventListener(MouseEvent.CLICK, this.triggerTypeGame);
            this.tdmCheck.addEventListener(MouseEvent.CLICK, this.triggerTypeGame);
            this.ctfCheck.addEventListener(MouseEvent.CLICK, this.triggerTypeGame);
            this.domCheck.addEventListener(MouseEvent.CLICK, this.triggerTypeGame);
            this.autobalance.type = TankCheckBox.AUTO_BALANCE;
            this.autobalance.label = this.CHECKBOX_AUTOBALANCE;
            this.friendlyfire.type = TankCheckBox.FRIENDLY_FIRE;
            this.friendlyfire.label = this.CHECKBOX_FRIENDLY_FIRE;
            this.privateCheck.type = TankCheckBox.INVITE_ONLY;
            this.privateCheck.label = this.CHECKBOX_PRIVATE_BATTLE;
            this.hrModeCheck.type = TankCheckBox.CHECK_SIGN;
            this.hrModeCheck.label = this.CHECKBOX_HR_MODE;
            this.startButton.label = this.BUTTON_START;
            this.startButton.addEventListener(MouseEvent.CLICK, this.startGame);
            this.mapsCombo.label = this.MAP_TYPE_LABEL;
            this.mapsCombo.y = 46;
            this.mapsCombo.x = ((this.nameGame.width - this.nameGame.textField.width) + 10);
            addChild(this.mapsCombo);
            this.themeCombo.y = 46;
            this.themeCombo.label = this.MAP_THEME_LABEL;
            addChild(this.themeCombo);
            addChild(this.modeCombo);
            this.modeCombo.addItem( {
                        "gameName": "Without Format",
                        "type": 0,
                        "rang": 0
                    });
            this.modeCombo.addItem( {
                        "gameName": "XP/BP",
                        "type": 1,
                        "rang": 0
                    });
            this.modeCombo.addItem( {
                        "gameName": "XP",
                        "type": 2,
                        "rang": 0
                    });
            this.modeCombo.addItem( {
                        "gameName": "BP",
                        "type": 3,
                        "rang": 0
                    });
            // this.modeCombo.addItem( {
            //             "gameName": "Thunder Wasp",
            //             "type": 4,
            //             "rang": 0
            //         });
            this.modeCombo.addEventListener(Event.CHANGE, this.onModeChange);
            this.modeCombo.dispatchEvent(new Event(Event.CHANGE));
            this.modeCombo.sortOn(["type"], [Array.NUMERIC]);
            addChild(this.noSubscribeAlert);
            this.noSubscribeAlert.visible = false;
            visible = true;
            this.calculatePayment();
            this.mapsCombo.addEventListener(Event.CHANGE, this.onChange);
            this.onChange(null);
            this.mapsCombo.height = 270;
        }
        public function set nameGameState(value:int):void
        {
            this._nameGameState = value;
            if (value == NAMEGAME_STATE_OFF)
            {
                this.nameGameCheckIcon.visible = false;
                Main.writeVarsToConsoleChannel("BATTLE SELECT", "NameChechIcon OFF");
            }
            else
            {
                Main.writeVarsToConsoleChannel("BATTLE SELECT", "NameChechIcon ON");
                this.nameGameCheckIcon.visible = true;
                this.nameGameCheckIcon.gotoAndStop(value);
            }
        }
        public function get nameGameState():int
        {
            return (this._nameGameState);
        }
        private function onPayCheckClick(e:MouseEvent = null):void
        {
            if ((!(this._haveSubscribe)))
            {
                this.payCheck.checked = false;
            }
            this.inventoryCheck.visible = ((this.payCheck.checked) && (this._haveSubscribe));
            this.noSubscribeAlert.visible = (!(this._haveSubscribe));
            this.payCheck.visible = this._haveSubscribe;
            this.inventoryCheck.checked = (!(this.payCheck.checked));
            this.calculatePayment();
        }
        private function calculatePayment(e:Event = null):void
        {
            if (this.payCheck.checked)
            {
                this.startButton.enable = (((this._haveSubscribe) && (this.nameGame.validValue)) && (this.nameGameState == NAMEGAME_STATE_OFF));
            }
            else
            {
                this.startButton.enable = (((((((!(this.dmCheck.enable)) || (!(this.tdmCheck.enable))) && ((this.time > 0) || (this.numKills > 0))) || ((!(this.ctfCheck.enable)) && ((this.time > 0) || (this.numFlags > 0)))) || ((!(this.domCheck.enable)) && ((this.time > 0) || (this.numPoints > 0)))) && (this.nameGame.validValue)) && (this.nameGameState == NAMEGAME_STATE_OFF));
            }
            this.costLabel.value = ((this.COST_LABEL + this._haveSubscribe) ? "yes" : "no");
            this.onResize(null);
        }
        private function checkName(e:LoginFormEvent):void
        {
            this.nameGame.validValue = true;
            if (gameName != "")
            {
                this.startButton.enable = true;
                this.nameGame.validValue = true;
            }
            else
            {
                this.startButton.enable = false;
                this.nameGame.validValue = false;
            }
            // if (e != null)
            // {
            // this.searchTimer.stop();
            // this.searchTimer.start();
            // }
        }
        private function setAutoName():void
        {
            var item:Object = this.mapsCombo.selectedItem;
            var aname:String;
            if (this.gameFormatString != "Without Format")
            {
                aname = item.gameName + " " + this.typeGame + " " + this.gameFormatString;
            }
            else
            {
                aname = item.gameName + " " + this.typeGame;
            }
            if (this.autoname)
            {
                this.gameName = aname;
                this.nameGame.validValue = true;
                this.calculatePayment();
            }
            else
            {
                this.checkName(null);
            }
        }
        private function checkAutoName(e:FocusEvent = null):void
        {
            if (e.type == FocusEvent.FOCUS_IN)
            {
                this.nameGameState = NAMEGAME_STATE_OFF;
                this.startButton.enable = (this.nameGame.textField.length > 0);
                if (this.autoname)
                {
                    this.gameName = "";
                    this.autoname = false;
                    this.checkName(null);
                }
                this.nameGameState = NAMEGAME_STATE_OFF;
            }
            if (e.type == FocusEvent.FOCUS_OUT)
            {
                if (this.nameGame.textField.length == 0)
                {
                    this.autoname = true;
                    this.setAutoName();
                }
            }
        }
        private function updateThemesCombo(selectedMap:Object):void
        {
            var themeName:String;
            var themes:Dictionary = this.mapsThemes[selectedMap.gameName];
            var length:int;
            if (themes != null)
            {
                this.themeCombo.clear();
                for (themeName in themes)
                {
                    length++;
                    this.themeCombo.addItem( {
                                "gameName": themeName,
                                "id": themes[themeName],
                                "rang": 0
                            });
                }
                this.themeCombo.visible = (length > 1);
            }
            this.themeCombo.sortOn(["gameName"], Array.DESCENDING);
            this.themeCombo.dispatchEvent(new Event(Event.CHANGE));
            this.themeCombo.height = (35 + (length * 20));
            this.themeCombo.listWidth = (this.themeCombo.listWidth - 5);
        }
        private function onModeChange(e:Event = null):void
        {
            var item:Object = this.modeCombo.selectedItem;
            this.gameFormat = item.type;
            this.gameFormatString = item.gameName;
            var aname:String = this.mapName + " " + this.typeGame;
            this.gameName = aname;
            if (item.gameName == "Without Format")
            {
                this.microUpgrades.checked = true;
                this.equipmentChange.checked = true;
                this.equipmentChange.visible = true;
                this.onResize(null);
                return;
            }
            this.microUpgrades.checked = false;
            this.equipmentChange.checked = false;
            this.equipmentChange.visible = false;
            aname = this.mapName + " " + this.typeGame + " " + item.gameName;
            this.gameName = aname;
            this.onResize(null);
        }
        private function onChange(e:Event):void
        {
            var item:Object = this.mapsCombo.selectedItem;
            var min:int = ((item.minRank < 1) ? 1 : item.minRank);
            var max:int = ((item.maxRank > 30) ? 30 : item.maxRank);
            this.info.setUp("", "", 0, 0, 0, 0, 0);
            this.selectRang.maxValue = max;
            this.selectRang.minValue = min;
            if (this.selectRang.minRang < this.selectRang.minValue)
            {
                this.selectRang.minRang = this.selectRang.minValue;
            }
            if (this.selectRang.maxRang > this.selectRang.maxValue)
            {
                this.selectRang.maxRang = this.selectRang.maxValue;
            }
            this.players.maxValue = (this.players.value = ((!(this.dmCheck.enable)) ? item.maxP : int(int((item.maxP / 2)))));
            this.maxP = item.maxP;
            this.ctfEnable = item.ctf;
            this.ctfCheck.visible = this.ctfEnable;
            this.tdmEnable = item.tdm;
            this.ctfCheck.visible = this.ctfEnable;
            this.tdmCheck.visible = this.tdmEnable;
            this.domEnable = item.dom;
            this.hrModeCheck.visible = item.hr;
            this.hrModeCheck.checked = false;
            this.domCheck.visible = this.domEnable;
            if ((!(this.tdmEnable)))
            {
                this.triggerTypeGame();
            }
            if (((!(this.ctfEnable)) && (!(this.deathMatch))))
            {
                this.dmCheck.enable = true;
                this.tdmCheck.enable = false;
                this.ctfCheck.enable = true;
                this.friendlyfire.visible = true;
                this.autobalance.visible = true;
                this.players.maxValue = int((this.maxP / 2));
                this.players.minValue = 1;
                this.players.value = int((this.maxP / 2));
                this.players.label = this.STEPPER_MAX_TEAM_SIZE;
                this.flags.visible = false;
                this.kills.visible = true;
                this.points.visible = false;
            }
            else
            {
                if (this.ctfEnable)
                {
                    this.flags.visible = ((this.ctfEnable) && (!(this.ctfCheck.enable)));
                    this.kills.visible = (!(this.flags.visible));
                    this.points.visible = false;
                }
                else
                {
                    if (this.domEnable)
                    {
                        this.flags.visible = false;
                        this.kills.visible = false;
                        this.points.visible = true;
                    }
                }
            }
            this.updateThemesCombo(item);
            this.onResize(null);
            this.setAutoName();
            this.calculatePayment();
        }
        private function startGame(e:MouseEvent):void
        {
            dispatchEvent(new BattleListEvent(BattleListEvent.START_CREATED_GAME));
        }
        private function triggerTypeGame(e:MouseEvent = null):void
        {
            var trgt:TypeBattleButton;
            if (e != null)
            {
                trgt = (e.currentTarget as TypeBattleButton);
            }
            Main.writeVarsToConsoleChannel("BATTLE SELECT", "Create Battle type %1", e);
            if (((trgt == this.dmCheck) || (e == null)))
            {
                this.dmCheck.enable = false;
                this.tdmCheck.enable = true;
                this.ctfCheck.enable = true;
                this.domCheck.enable = true;
                this.friendlyfire.visible = false;
                this.autobalance.visible = false;
                this.players.maxValue = this.maxP;
                this.players.minValue = 2;
                this.players.value = this.maxP;
                this.typeGame = "DM";
                this.players.label = this.STEPPER_MAX_PLAYERS;
                this.flags.visible = false;
                this.kills.visible = true;
                this.points.visible = false;
            }
            else
            {
                if (trgt == this.tdmCheck)
                {
                    this.dmCheck.enable = true;
                    this.tdmCheck.enable = false;
                    this.ctfCheck.enable = true;
                    this.domCheck.enable = true;
                    this.friendlyfire.visible = true;
                    this.autobalance.visible = true;
                    this.players.maxValue = int((this.maxP / 2));
                    this.players.minValue = 1;
                    this.players.value = int((this.maxP / 2));
                    this.players.label = this.STEPPER_MAX_TEAM_SIZE;
                    this.typeGame = "TDM";
                    this.flags.visible = false;
                    this.kills.visible = true;
                    this.points.visible = false;
                }
                else
                {
                    if (trgt == this.ctfCheck)
                    {
                        this.dmCheck.enable = true;
                        this.ctfCheck.enable = false;
                        this.tdmCheck.enable = true;
                        this.domCheck.enable = true;
                        this.friendlyfire.visible = true;
                        this.autobalance.visible = true;
                        this.players.maxValue = int((this.maxP / 2));
                        this.players.minValue = 1;
                        this.players.value = int((this.maxP / 2));
                        this.players.label = this.STEPPER_MAX_TEAM_SIZE;
                        this.flags.visible = true;
                        this.kills.visible = false;
                        this.points.visible = false;
                        this.typeGame = "CTF";
                    }
                    else
                    {
                        this.dmCheck.enable = true;
                        this.ctfCheck.enable = true;
                        this.tdmCheck.enable = true;
                        this.domCheck.enable = false;
                        this.friendlyfire.visible = true;
                        this.autobalance.visible = true;
                        this.players.maxValue = int((this.maxP / 2));
                        this.players.minValue = 1;
                        this.players.value = int((this.maxP / 2));
                        this.players.label = this.STEPPER_MAX_TEAM_SIZE;
                        this.flags.visible = false;
                        this.kills.visible = false;
                        this.points.visible = true;
                        this.typeGame = "CP";
                    }
                }
            }
            this.onResize(null);
            this.setAutoName();
            stage.focus = null;
            this.calculatePayment();
        }
        private function onResize(e:Event):void
        {
            var numSpace:int;
            if (stage == null)
            {
                return;
            }
            var minWidth:int = int(Math.max(1000, stage.stageWidth));
            this.mainBackground.width = (minWidth / 3);
            this.mainBackground.height = Math.max((stage.stageHeight - 60), 530);
            this.x = (this.mainBackground.width * 2);
            this.y = 60;
            this.nameGame.width = ((this.mainBackground.width - this.nameGame._label.textWidth) - 35);
            this.nameGameCheckIcon.x = ((this.mainBackground.width - this.nameGameCheckIcon.width) - 11);
            var countOfThemes:int = this.amountOfThemesForMap(this.mapsCombo.selectedItem.gameName);
            if (countOfThemes > 1)
            {
                this.mapsCombo.width = int((((this.mainBackground.width / 2) - this.mapsCombo.x) - 11));
                this.themeCombo.x = ((this.mainBackground.width / 2) + this.mapsCombo.x);
                this.themeCombo.width = int((((this.mainBackground.width / 2) - this.mapsCombo.x) - 11));
            }
            else
            {
                this.mapsCombo.width = ((this.mainBackground.width - this.nameGame._label.textWidth) - 35);
            }
            this.info.width = (this.mainBackground.width - 22);
            this.info.height = int((this.mainBackground.height - 465));
            this.selectRang.y = (this.info.height + 86);
            this.selectRang.width = this.info.width;
            this.dmCheck.x = 11;
            this.dmCheck.y = (this.selectRang.y + 35);
            var countEnable:int = 1;
            if (this.domEnable)
            {
                countEnable++;
            }
            if (this.ctfEnable)
            {
                countEnable++;
            }
            if (this.tdmEnable)
            {
                countEnable++;
            }
            this.dmCheck.width = int(((this.info.width / countEnable) - 2.5));
            this.tdmCheck.x = (this.dmCheck.width + 16);
            this.tdmCheck.y = this.dmCheck.y;
            this.tdmCheck.width = this.dmCheck.width;
            this.ctfCheck.x = ((this.tdmEnable) ? ((this.tdmCheck.width + this.tdmCheck.x) + 5) : (this.dmCheck.width + 16));
            this.ctfCheck.y = this.dmCheck.y;
            this.ctfCheck.width = this.dmCheck.width;
            if (this.ctfEnable)
            {
                this.domCheck.x = this.ctfCheck.x + this.ctfCheck.width + 5;
            }
            else if (this.tdmEnable)
            {
                this.domCheck.x = this.tdmCheck.width + this.tdmCheck.x + 5;
            }
            else
            {
                this.domCheck.x = this.dmCheck.width + 16;
            }
            this.domCheck.y = this.dmCheck.y;
            this.domCheck.width = this.dmCheck.width;
            this.flags.y = (this.kills.y = (this.minutes.y = (this.players.y = (this.dmCheck.y + 80))));
            this.points.y = (this.kills.y = (this.minutes.y = (this.players.y = (this.dmCheck.y + 80))));
            numSpace = int(int(((((this.mainBackground.width - this.players.width) - this.minutes.width) - this.kills.width) / 4)));
            this.players.x = numSpace;
            this.minutes.x = int(this.players.width + (numSpace * 2));
            this.kills.x = int((this.players.width + this.minutes.width) + (numSpace * 3));
            this.flags.x = int((this.players.width + this.minutes.width) + (numSpace * 3));
            this.points.x = int((this.players.width + this.minutes.width) + (numSpace * 3));

            numSpace = int(int((((this.mainBackground.width - this.autobalance.width) - this.friendlyfire.width) / 3)));

            this.payCheck.x = 11;
            this.payCheck.y = this.players.y + 45;

            this.equipmentChange.x = 11;
            this.equipmentChange.y = this.payCheck.y + 40;

            if(equipmentChange.visible){
                this.autobalance.x = 11;
                this.autobalance.y = this.equipmentChange.y + 40;

                this.friendlyfire.x = 11;
                this.friendlyfire.y = this.autobalance.y + 40;
            }else{
                this.autobalance.x = 11;
                this.autobalance.y = this.payCheck.y + 40;

                this.friendlyfire.x = 11;
                this.friendlyfire.y = this.autobalance.y + 40;
            }

            this.modeCombo.x = (numSpace * 2) + this.autobalance.width;
            this.modeCombo.y = this.payCheck.y;
            this.modeCombo.width = this.info.width / 3 + 20;
            this.modeCombo.listWidth = this.info.width / 3 + 10;

            this.microUpgrades.x = (numSpace * 2) + this.autobalance.width;
            this.microUpgrades.y = this.equipmentChange.y;

            this.inventoryCheck.x = (numSpace * 2) + this.autobalance.width;
            this.inventoryCheck.y = this.microUpgrades.y + 40;

            this.noSubscribeAlert.x = numSpace;
            this.noSubscribeAlert.width = (this.mainBackground.width - (numSpace * 2));

            this.privateCheck.x = 11;
            this.privateCheck.y = (this.mainBackground.height - 42);

            this.startButton.x = ((this.mainBackground.width - this.startButton.width) - 11);
            this.startButton.y = (this.mainBackground.height - 42);
            this.hrModeCheck.x = this.autobalance.x;
            this.hrModeCheck.y = (this.payCheck.y + 40);
            this.noSubscribeAlert.y = this.payCheck.y;
            if (this.delayTimer == null)
            {
                this.delayTimer = new Timer(200, 1);
                this.delayTimer.addEventListener(TimerEvent.TIMER, this.resizeList);
            }
            this.delayTimer.reset();
            this.delayTimer.start();
        }
        private function resizeList(e:TimerEvent):void
        {
            var numSpace:int;
            if (stage == null)
            {
                return;
            }
            var minWidth:int = int(Math.max(1000, stage.stageWidth));
            this.mainBackground.width = (minWidth / 3);
            this.mainBackground.height = Math.max((stage.stageHeight - 60), 530);
            this.x = (this.mainBackground.width * 2);
            this.y = 60;
            this.nameGame.width = ((this.mainBackground.width - this.nameGame._label.textWidth) - 35);
            this.nameGameCheckIcon.x = ((this.mainBackground.width - this.nameGameCheckIcon.width) - 11);
            var countOfThemes:int = this.amountOfThemesForMap(this.mapsCombo.selectedItem.gameName);
            if (countOfThemes > 1)
            {
                this.mapsCombo.width = int((((this.mainBackground.width / 2) - this.mapsCombo.x) - 11));
                this.themeCombo.x = ((this.mainBackground.width / 2) + this.mapsCombo.x);
                this.themeCombo.width = int((((this.mainBackground.width / 2) - this.mapsCombo.x) - 11));
            }
            else
            {
                this.mapsCombo.width = ((this.mainBackground.width - this.nameGame._label.textWidth) - 35);
            }
            this.info.width = (this.mainBackground.width - 22);
            this.info.height = int((this.mainBackground.height - 465));
            this.selectRang.y = (this.info.height + 86);
            this.selectRang.width = this.info.width;
            this.dmCheck.x = 11;
            this.dmCheck.y = (this.selectRang.y + 35);
            var countEnable:int = 1;
            if (this.domEnable)
            {
                countEnable++;
            }
            if (this.ctfEnable)
            {
                countEnable++;
            }
            if (this.tdmEnable)
            {
                countEnable++;
            }
            this.dmCheck.width = int(((this.info.width / countEnable) - 2.5));
            this.tdmCheck.x = (this.dmCheck.width + 16);
            this.tdmCheck.y = this.dmCheck.y;
            this.tdmCheck.width = this.dmCheck.width;
            this.ctfCheck.x = ((this.tdmEnable) ? ((this.tdmCheck.width + this.tdmCheck.x) + 5) : (this.dmCheck.width + 16));
            this.ctfCheck.y = this.dmCheck.y;
            this.ctfCheck.width = this.dmCheck.width;
            if (this.ctfEnable)
            {
                this.domCheck.x = this.ctfCheck.x + this.ctfCheck.width + 5;
            }
            else if (this.tdmEnable)
            {
                this.domCheck.x = this.tdmCheck.width + this.tdmCheck.x + 5;
            }
            else
            {
                this.domCheck.x = this.dmCheck.width + 16;
            }
            this.domCheck.y = this.dmCheck.y;
            this.domCheck.width = this.dmCheck.width;
            this.flags.y = (this.kills.y = (this.minutes.y = (this.players.y = (this.dmCheck.y + 80))));
            this.points.y = (this.kills.y = (this.minutes.y = (this.players.y = (this.dmCheck.y + 80))));
            numSpace = int(int(((((this.mainBackground.width - this.players.width) - this.minutes.width) - this.kills.width) / 4)));
            this.players.x = numSpace;
            this.minutes.x = int(this.players.width + (numSpace * 2));
            this.kills.x = int((this.players.width + this.minutes.width) + (numSpace * 3));
            this.flags.x = int((this.players.width + this.minutes.width) + (numSpace * 3));
            this.points.x = int((this.players.width + this.minutes.width) + (numSpace * 3));

            numSpace = int(int((((this.mainBackground.width - this.autobalance.width) - this.friendlyfire.width) / 3)));

            this.payCheck.x = 11;
            this.payCheck.y = this.players.y + 45;

            this.equipmentChange.x = 11;
            this.equipmentChange.y = this.payCheck.y + 40;

            if(equipmentChange.visible){
                this.autobalance.x = 11;
                this.autobalance.y = this.equipmentChange.y + 40;

                this.friendlyfire.x = 11;
                this.friendlyfire.y = this.autobalance.y + 40;
            }else{
                this.autobalance.x = 11;
                this.autobalance.y = this.payCheck.y + 40;

                this.friendlyfire.x = 11;
                this.friendlyfire.y = this.autobalance.y + 40;
            }

            this.modeCombo.x = (numSpace * 2) + this.autobalance.width;
            this.modeCombo.y = this.payCheck.y;
            this.modeCombo.width = this.info.width / 3 + 20;
            this.modeCombo.listWidth = this.info.width / 3 + 10;

            this.microUpgrades.x = (numSpace * 2) + this.autobalance.width;
            this.microUpgrades.y = this.equipmentChange.y;

            this.inventoryCheck.x = (numSpace * 2) + this.autobalance.width;
            this.inventoryCheck.y = this.microUpgrades.y + 40;

            this.noSubscribeAlert.x = numSpace;
            this.noSubscribeAlert.width = (this.mainBackground.width - (numSpace * 2));

            this.privateCheck.x = 11;
            this.privateCheck.y = (this.mainBackground.height - 42);

            this.startButton.x = ((this.mainBackground.width - this.startButton.width) - 11);
            this.startButton.y = (this.mainBackground.height - 42);
            this.hrModeCheck.x = this.autobalance.x;
            this.hrModeCheck.y = (this.payCheck.y + 40);
            this.noSubscribeAlert.y = this.payCheck.y;
        }
        public function hide():void
        {
            this.dmCheck.removeEventListener(MouseEvent.CLICK, this.triggerTypeGame);
            this.tdmCheck.removeEventListener(MouseEvent.CLICK, this.triggerTypeGame);
            this.ctfCheck.removeEventListener(MouseEvent.CLICK, this.triggerTypeGame);
            this.startButton.removeEventListener(MouseEvent.CLICK, this.startGame);
            this.delayTimer.removeEventListener(TimerEvent.TIMER, this.resizeList);
        }
        private function onSliderChangeValue(e:SliderEvent):void
        {
        }
        private function amountOfThemesForMap(mapName:String):int
        {
            var themeName:String;
            if (this.mapsThemes[mapName] == null)
            {
                return (0);
            }
            var amount:int;
            for (themeName in this.mapsThemes[mapName])
            {
                amount++;
            }
            return (amount);
        }
        private function updateByTime(e:TimerEvent):void
        {
            this.nameGameState = NAMEGAME_STATE_PROGRESS;
            this.startButton.enable = false;
            dispatchEvent(new BattleListEvent(BattleListEvent.NEW_BATTLE_NAME_ADDED));
            this.searchTimer.stop();
        }

    }
}
