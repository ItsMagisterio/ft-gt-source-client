package alternativa.tanks.models.battlefield
{
    import projects.tanks.client.battlefield.gui.models.statistics.StatisticsModelBase;
    import projects.tanks.client.battlefield.gui.models.statistics.IStatisticsModelBase;
    import alternativa.model.IObjectLoadListener;
    import alternativa.osgi.service.focus.IFocusListener;
    import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
    import alternativa.tanks.model.panel.IPanelListener;
    import alternativa.object.ClientObject;
    import flash.display.DisplayObjectContainer;
    import alternativa.service.IModelService;
    import alternativa.tanks.models.battlefield.gui.statistics.table.TableStatistics;
    import alternativa.tanks.models.battlefield.gui.statistics.field.FieldStatistics;
    import alternativa.tanks.models.dom.hud.panel.KeyPointsHUDPanel;
    import alternativa.tanks.models.battlefield.gui.statistics.messages.BattleMessages;
    import __AS3__.vec.Vector;
    import projects.tanks.client.battlefield.gui.models.statistics.UserStat;
    import alternativa.tanks.loader.ILoaderWindowService;
    import alternativa.tanks.models.battlefield.gui.statistics.fps.FPSText;
    import alternativa.tanks.models.battlefield.gui.help.ControlsHelper;
    import controls.lifeindicator.LifeIndicator;
    import forms.FocusWarningWindow;
    import alternativa.tanks.models.battlefield.gui.PauseIndicator;
    import alternativa.model.IModel;
    import alternativa.init.Main;
    import alternativa.tanks.models.battlefield.gui.statistics.field.WinkManager;
    import alternativa.tanks.model.panel.PanelModel;
    import alternativa.tanks.model.panel.IPanel;
    import flash.events.Event;
    import alternativa.osgi.service.focus.IFocusService;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.tanks.locale.constants.TextConst;
    import alternativa.tanks.model.panel.IBattleSettings;
    import flash.events.KeyboardEvent;
    import alternativa.tanks.models.tank.TankModel;
    import alternativa.tanks.models.tank.ITank;
    import alternativa.tanks.models.ctf.CTFModel;
    import alternativa.tanks.models.dom.DOMModel;
    import com.alternativaplatform.projects.tanks.client.models.ctf.ICaptureTheFlagModelBase;
    import alternativa.tanks.models.dom.IDOMModel;
    import projects.tanks.client.battlefield.gui.models.statistics.BattleStatInfo;
    import projects.tanks.client.battleservice.model.team.BattleTeamType;
    import alternativa.tanks.models.battlefield.event.ExitEvent;
    import flash.ui.Keyboard;
    import alternativa.tanks.help.IHelpService;
    import flash.display.DisplayObject;
    import __AS3__.vec.*;
    import alternativa.tanks.model.GarageModel;

    public class StatisticsModel extends StatisticsModelBase implements IStatisticsModelBase, IObjectLoadListener, IFocusListener, IBattlefieldGUI, IUserStat, IChatListener, IPanelListener
    {

        public static const LOG_CHANNEL:String = "STAT";
        public static const LOG_PREFIX:String = "[StatisticsModel]";

        private var battleClientObject:ClientObject;
        private var contentLayer:DisplayObjectContainer;
        private var modelService:IModelService;
        private var teamPlay:Boolean;
        private var tableStatistics:TableStatistics;
        private var fieldStatistics:FieldStatistics;
        private var pointsHUD:KeyPointsHUDPanel;
        private var battleMessages:BattleMessages;
        private var userStats:Vector.<UserStat>;
        private var battleFinished:Boolean = false;
        private var loaderWindow:ILoaderWindowService;
        private var fpsIndicator:FPSText;
        private var controlsHelper:ControlsHelper;
        private var localUserId:String;
        private var userStatListeners:Vector.<IUserStatListener> = new Vector.<IUserStatListener>();
        private var battleName:String;
        private var joinMessage:String;
        private var leaveMessage:String;
        private var lifeIndicator:LifeIndicator;
        private var focusWarningIndicator:FocusWarningWindow;
        private var pauseIndicator:PauseIndicator;
        private var paused:Boolean;
        private var bfModel:BattlefieldModel;
        private var goldBoxText:String;
        private var rubyBoxText:String;
        private var spinBoxText:String;
        private var prizeBoxText:String;

        public function StatisticsModel()
        {
            _interfaces.push(IModel, IStatisticsModelBase, IObjectLoadListener, IFocusListener, IBattlefieldGUI, IUserStat, IChatListener, IPanelListener);
            this.contentLayer = Main.contentUILayer;
            this.fpsIndicator = new FPSText();
            WinkManager.init(500);
            Main.osgi.registerService(IBattlefieldGUI, this);
            this.localUserId = PanelModel(Main.osgi.getService(IPanel)).userName;
        }
        public function objectLoaded(object:ClientObject):void
        {
            this.paused = false;
            this.loaderWindow = (Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService);
            this.loaderWindow.hideLoaderWindow();
            this.loaderWindow.lockLoaderWindow();
            Main.stage.addEventListener(Event.RESIZE, this.onResize);
            var focusService:IFocusService = IFocusService(Main.osgi.getService(IFocusService));
            focusService.addFocusListener(this);
            var locale:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            this.pauseIndicator = new PauseIndicator(locale.getText(TextConst.BATTLE_PAUSE_ENABLED), locale.getText(TextConst.BATTLE_PAUSE_PRESS_ANY_KEY), locale.getText(TextConst.BATTLE_PAUSE_BATTLE_LEAVE));
            this.bfModel = BattlefieldModel(Main.osgi.getService(IBattleField));
            this.goldBoxText = locale.getText(TextConst.BATTLE_PLAYER_TAKEN_GOLD_BOX);
            this.rubyBoxText = locale.getText(TextConst.BATTLE_PLAYER_TAKEN_RUBY_BOX);
            this.spinBoxText = locale.getText(TextConst.BATTLE_PLAYER_TAKEN_SPIN_BOX);
            this.prizeBoxText = locale.getText(TextConst.BATTLE_PLAYER_TAKEN_PRIZE_BOX);
        }
        public function objectUnloaded(object:ClientObject):void
        {
            this.showFocusWarning(false);
            this.showPauseIndicator(false);
            this.pauseIndicator = null;
            var focusService:IFocusService = IFocusService(Main.osgi.getService(IFocusService));
            focusService.removeFocusListener(this);
            Main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            Main.stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            Main.stage.removeEventListener(Event.RESIZE, this.onResize);
            if (this.contentLayer.contains(this.tableStatistics))
            {
                this.tableStatistics.hide();
                this.contentLayer.removeChild(this.tableStatistics);
            }
            this.removeDisplayObject(this.contentLayer, this.fieldStatistics);
            this.removeDisplayObject(this.contentLayer, this.pointsHUD);
            this.removeDisplayObject(this.contentLayer, this.battleMessages);
            this.removeDisplayObject(this.contentLayer, this.fpsIndicator);
            this.removeDisplayObject(this.contentLayer, this.lifeIndicator);
            this.lifeIndicator = null;
            this.unregisterControlsHelpScreen();
            this.loaderWindow.unlockLoaderWindow();
            this.battleClientObject = null;
            this.userStats = null;
            this.battleMessages = null;
        }
        public function deactivate():void
        {
            if (this.battleClientObject == null)
            {
                return;
            }
            if ((!(this.battleFinished)))
            {
                this.tableStatistics.hide();
            }
            this.doShowPauseIndicator(false);
            this.showFocusWarning(true);
        }
        public function activate():void
        {
            if (this.battleClientObject == null)
            {
                return;
            }
            this.showFocusWarning(false);
            if (this.paused)
            {
                this.doShowPauseIndicator(true);
            }
        }
        public function focusOut(exfocusedObject:Object):void
        {
        }
        public function focusIn(focusedObject:Object):void
        {
        }
        public function initObject(clientObject:ClientObject, battleName:String):void
        {
            this.battleName = battleName;
            var locale:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            this.joinMessage = locale.getText(TextConst.BATTLE_PLAYER_JOINED);
            this.leaveMessage = locale.getText(TextConst.BATTLE_PLAYER_LEFT);
            this.userStatListeners.push(TankModel(Main.osgi.getService(ITank)));
        }
        public function init(clientObject:ClientObject, initData:BattleStatInfo, userStats:Array):void
        {
            var battleType:BattleType;
            var userStat:UserStat;
            var ctfModel:CTFModel;
            var domModel:DOMModel;
            this.battleClientObject = clientObject;
            this.teamPlay = initData.teamPlay;
            this.userStats = Vector.<UserStat>(userStats);
            this.battleFinished = false;
            this.tableStatistics = new TableStatistics(this.battleName, this.teamPlay);
            this.contentLayer.addChild(this.tableStatistics);
            if (this.teamPlay)
            {
                ctfModel = CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase));
                domModel = DOMModel(Main.osgi.getService(IDOMModel));
                battleType = ((!(ctfModel == null)) ? BattleType.CTF : ((!(domModel == null)) ? BattleType.DOM : BattleType.TDM));
            }
            else
            {
                battleType = BattleType.DM;
            }
            this.fieldStatistics = new FieldStatistics(this.localUserId, initData, this.userStats, battleType);
            this.contentLayer.addChild(this.fieldStatistics);
            this.fieldStatistics.adjustFields();
            this.battleMessages = new BattleMessages();
            this.contentLayer.addChild(this.battleMessages);
            this.registerControlsHelpScreen();
            var settings:IBattleSettings = IBattleSettings(Main.osgi.getService(IBattleSettings));
            if (settings.showFPS)
            {
                this.contentLayer.addChild(this.fpsIndicator);
            }
            Main.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            Main.stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
            for each (userStat in this.userStats)
            {
                this.dispatchStatChange(userStat);
            }
            this.objectLoaded(clientObject);
            this.tableStatistics.addEventListener(ExitEvent.EXIT, this.onExit);
            this.onResize(null);
        }
        public function createPointsHUD(HUDPanel:KeyPointsHUDPanel):void
        {
            this.pointsHUD = HUDPanel;
            this.contentLayer.addChild(this.pointsHUD);
        }
        public function updatePointsHUD():void
        {
            this.pointsHUD.update();
        }
        public function setBattleState(clientObject:ClientObject):void
        {
        }
        public function changeUserTeam(clientObject:ClientObject, userId:String, teamType:BattleTeamType):void
        {
            var userStat:UserStat = this.getUserStatByID(userId);
            if (userStat != null)
            {
                this.tableStatistics.removePlayer(userId, userStat.teamType);
                userStat.teamType = teamType;
                this.tableStatistics.updatePlayer(userStat);
            }
        }
        public function userConnect(clientObject:ClientObject, userId:String, teamType:BattleTeamType, name:String, rank:int, showMessage:Boolean = true, weaponId:String = "smoky", premium:Boolean = false):void
        {
            var userStat:UserStat = new UserStat(0, 0, name, rank, 0, 0, teamType, name, weaponId, premium);
            this.userStats.push(userStat);
            if (showMessage == true)
            {
                this.battleMessages.addMessage(userStat, this.joinMessage);
            }
            this.tableStatistics.updatePlayer(userStat);
            this.dispatchStatChange(userStat);
        }
        public function userDisconnect(clientObject:ClientObject, userId:String, showMessage:Boolean = true):void
        {
            var idx:int = this.getUserIndexByID(userId);
            if (idx < 0)
            {
                return;
            }
            var userStat:UserStat = this.userStats[idx];
            if ((!(this.battleFinished)))
            {
                this.tableStatistics.removePlayer(userId, userStat.teamType);
            }
            if (showMessage == true)
            {
                this.battleMessages.addMessage(userStat, this.leaveMessage);
            }
            else
            {
                Main.openingToGarage = false;
            }
            this.userStats.splice(idx, 1);
        }
        public function fundChange(clientObject:ClientObject, fund:int):void
        {
            if (this.fieldStatistics == null)
            {
                return;
            }
            this.fieldStatistics.updateFund(fund);
            this.onResize(null);
        }
        public function finish(clientObject:ClientObject, users:Array, timeToRestart:int):void
        {
            if (this.tableStatistics != null)
            {
                this.tableStatistics.hide();
                this.tableStatistics.show(this.localUserId, Vector.<UserStat>(users), true, timeToRestart);
            }
            this.battleFinished = true;
            if (this.fieldStatistics != null)
            {
                this.fieldStatistics.finish();
            }
        }
        public function restart(clientObject:ClientObject, newTimeLimit:int):void
        {
            var userStat:UserStat;
            this.tableStatistics.hide();
            this.fieldStatistics.timeLimit = newTimeLimit;
            this.fieldStatistics.resetFields();
            this.battleFinished = false;
            var len:int = this.userStats.length;
            var i:int;
            while (i < len)
            {
                userStat = this.userStats[i];
                userStat.deaths = 0;
                userStat.kills = 0;
                userStat.score = 0;
                i++;
            }
        }
        public function changeTeamScore(clientObject:ClientObject, teamType:BattleTeamType, score:int):void
        {
            if (this.battleClientObject == null)
            {
                return;
            }
            this.fieldStatistics.setTeamScore(teamType, score);
            this.onResize(null);
        }
        public function changeUsersStat(clientObject:ClientObject, userStats:Array):void
        {
            var userStat:UserStat;
            var localUserStat:UserStat;
            if (userStats == null)
            {
                return;
            }
            var len:int = userStats.length;
            var i:int;
            while (i < len)
            {
                userStat = userStats[i];
                localUserStat = this.getUserStatByID(userStat.userId);
                if (localUserStat != null)
                {
                    localUserStat.score = userStat.score;
                    localUserStat.kills = userStat.kills;
                    localUserStat.deaths = userStat.deaths;
                    localUserStat.rank = userStat.rank;
                    if ((!(this.battleFinished)))
                    {
                        this.tableStatistics.updatePlayer(localUserStat);
                    }
                    this.fieldStatistics.updateUserKills(userStat);
                    this.dispatchStatChange(userStat);
                }
                i++;
            }
        }
        public function logUserAction(userId:String, actionText:String, targetUserId:String = null):void
        {
            var color:uint;
            var userStat:UserStat = this.getUserStatByID(userId);
            var targetUserStat:UserStat = ((targetUserId == null) ? null : this.getUserStatByID(targetUserId));
            if (((!(actionText.indexOf("спин ящик") == -1)) || (!(actionText.indexOf("spin box") == -1))))
            {
                color = ((this.bfModel.spectatorMode) ? 0xFFA500 : ((userId == this.localUserId) ? CTFModel.COLOR_POSITIVE : CTFModel.COLOR_NEGATIVE));
                this.bfModel.messages.addMessage(color, ((userId + " ") + this.spinBoxText));
            }
            if (((!(actionText.indexOf("подарочный ящик") == -1)) || (!(actionText.indexOf("prize box") == -1))))
            {
                color = ((this.bfModel.spectatorMode) ? 0xFFA500 : ((userId == this.localUserId) ? CTFModel.COLOR_POSITIVE : CTFModel.COLOR_NEGATIVE));
                this.bfModel.messages.addMessage(color, ((userId + " ") + this.prizeBoxText));
            }
            if (((!(actionText.indexOf("рубиновый ящик") == -1)) || (!(actionText.indexOf("ruby box") == -1))))
            {
                color = ((this.bfModel.spectatorMode) ? 0xFFA500 : ((userId == this.localUserId) ? CTFModel.COLOR_POSITIVE : CTFModel.COLOR_NEGATIVE));
                this.bfModel.messages.addMessage(color, ((userId + " ") + this.rubyBoxText));
            }
            if (((!(actionText.indexOf("золотой ящик") == -1)) || (!(actionText.indexOf("gold box") == -1))))
            {
                color = 0xFFA500;
                this.bfModel.messages.addMessage(color, ((userId + " ") + this.goldBoxText));
                this.battleMessages.addMessage(userStat, this.goldBoxText);
            }
            else
            {
                if (targetUserId != null)
                {
                    this.battleMessages.addMessageWithImage(userStat, (actionText == "mine") ? "mine" : userStat.weapon, targetUserStat);
                    return;
                }
                this.battleMessages.addMessage(userStat, actionText, targetUserStat);
            }
        }
        public function logAction(actionText:String, targetUserId:String = null):void
        {
            var targetUserStat:UserStat = ((targetUserId == null) ? null : this.getUserStatByID(targetUserId));
            this.battleMessages.addMessage(null, actionText, targetUserStat);
        }
        public function ctfShowFlagAtBase(teamType:BattleTeamType):void
        {
            if (this.fieldStatistics != null)
            {
                this.fieldStatistics.ctfShowFlagAtBase(teamType);
            }
        }
        public function ctfShowFlagCarried(teamType:BattleTeamType):void
        {
            if (this.fieldStatistics != null)
            {
                this.fieldStatistics.ctfShowFlagCarried(teamType);
            }
        }
        public function ctfShowFlagDropped(teamType:BattleTeamType):void
        {
            if (this.fieldStatistics != null)
            {
                this.fieldStatistics.ctfShowFlagDropped(teamType);
            }
        }
        public function updateHealthIndicator(health:Number):void
        {
            if (this.lifeIndicator != null)
            {
                this.lifeIndicator.life = health;
            }
        }
        public function updateWeaponIndicator(weaponStatus:Number):void
        {
            if (this.lifeIndicator != null)
            {
                this.lifeIndicator.charge = weaponStatus;
            }
        }
        public function showPauseIndicator(show:Boolean):void
        {
            if (this.paused == show)
            {
                return;
            }
            this.paused = show;
            this.doShowPauseIndicator(show);
        }
        public function setPauseTimeout(seconds:int):void
        {
            if (this.pauseIndicator != null)
            {
                this.pauseIndicator.seconds = seconds;
            }
        }
        public function getUserName(userId:String):String
        {
            var userStat:UserStat = this.getUserStatByID(userId);
            return ((userStat == null) ? ("Unknown " + userId.toString()) : userStat.name);
        }
        public function getUserRank(userId:String):int
        {
            var userStat:UserStat = this.getUserStatByID(userId);
            return ((userStat == null) ? int(-1) : int(userStat.rank));
        }
        public function addUserStatListener(listener:IUserStatListener):void
        {
            var idx:int = this.userStatListeners.indexOf(listener);
            if (idx > -1)
            {
                return;
            }
            this.userStatListeners.push(listener);
        }
        public function removeUserStatListener(listener:IUserStatListener):void
        {
            var idx:int = this.userStatListeners.indexOf(listener);
            if (idx < 0)
            {
                return;
            }
            this.userStatListeners.splice(idx, 1);
        }
        public function chatOpened():void
        {
            this.hideScores();
        }
        public function chatClosed():void
        {
        }
        public function bugReportOpened():void
        {
        }
        public function bugReportClosed():void
        {
        }
        public function friendsOpened():void
        {
        }
        public function friendsClosed():void
        {
        }
        public function onCloseGame():void
        {
        }
        public function onCloseGameExit():void
        {
        }
        public function settingsAccepted():void
        {
            var settings:IBattleSettings = IBattleSettings(Main.osgi.getService(IBattleSettings));
            var panelModel:PanelModel = PanelModel(Main.osgi.getService(IPanel));
            if (settings.showFPS && panelModel.isInBattle)
            {
                this.contentLayer.addChild(this.fpsIndicator);
            }
            else
            {
                this.removeDisplayObject(this.contentLayer, this.fpsIndicator);
            }
        }
        public function settingsCanceled():void
        {
        }
        public function settingsOpened():void
        {
        }
        public function setMuteSound(mute:Boolean):void
        {
        }
        private function onExit(e:ExitEvent):void
        {
            this.exit(this.battleClientObject);
            var panel:PanelModel = (Main.osgi.getService(IPanel) as PanelModel);
            panel.lock();
            panel.showBattleSelect(null, false);
        }
        private function exit(battle:ClientObject):void
        {
        }
        private function onKeyDown(e:KeyboardEvent):void
        {
            if (((e.keyCode == Keyboard.TAB) && (!(this.battleFinished))))
            {
                this.showScores();
            }
        }
        private function onKeyUp(e:KeyboardEvent):void
        {
            if (((e.keyCode == Keyboard.TAB) && (!(this.battleFinished))))
            {
                this.hideScores();
            }
        }
        private function showScores():void
        {
            if (this.battleFinished)
            {
                return;
            }
            this.tableStatistics.show(this.localUserId, this.userStats, false, 0);
        }
        private function hideScores():void
        {
            if (((this.battleFinished) && (this.tableStatistics == null)))
            {
                return;
            }
            if (this.battleFinished)
            {
                return;
            }
            if (this.tableStatistics != null)
            {
                this.tableStatistics.hide();
            }
        }
        private function getUserIndexByID(userId:String):int
        {
            var i:int;
            if (this.userStats != null)
            {
                i = (this.userStats.length - 1);
                while (i >= 0)
                {
                    if (UserStat(this.userStats[i]).userId == userId)
                    {
                        return (i);
                    }
                    i--;
                }
            }
            return (-1);
        }
        private function getUserStatByID(userId:String):UserStat
        {
            var i:int;
            var userStat:UserStat;
            if (this.userStats != null)
            {
                i = (this.userStats.length - 1);
                while (i >= 0)
                {
                    userStat = this.userStats[i];
                    if (userStat.userId == userId)
                    {
                        return (userStat);
                    }
                    i--;
                }
            }
            return (null);
        }
        private function registerControlsHelpScreen():void
        {
            if (this.controlsHelper == null)
            {
                this.controlsHelper = new ControlsHelper();
            }
            var helpService:IHelpService = (Main.osgi.getService(IHelpService) as IHelpService);
            helpService.registerHelper(ControlsHelper.GROUP_ID, ControlsHelper.HELPER_ID, this.controlsHelper, true);
        }
        private function unregisterControlsHelpScreen():void
        {
            var helpService:IHelpService = (Main.osgi.getService(IHelpService) as IHelpService);
            helpService.unregisterHelper(ControlsHelper.GROUP_ID, ControlsHelper.HELPER_ID);
        }
        private function dispatchStatChange(userStat:UserStat):void
        {
            var i:int = (this.userStatListeners.length - 1);
            while (i >= 0)
            {
                IUserStatListener(this.userStatListeners[i]).userStatChanged(userStat.userId, userStat.name, userStat.rank);
                i--;
            }
        }
        private function removeDisplayObject(container:DisplayObjectContainer, object:DisplayObject):void
        {
            if (((!(object == null)) && (container.contains(object))))
            {
                container.removeChild(object);
            }
        }
        private function onResize(e:Event):void
        {
            var sw:int = Main.stage.stageWidth;
            var sh:int = Main.stage.stageHeight;
            if (this.lifeIndicator != null)
            {
                this.lifeIndicator.x = 260;
                this.lifeIndicator.y = (Main.stage.stageHeight - 50);
            }
            if (this.focusWarningIndicator != null)
            {
                this.focusWarningIndicator.x = (sw >> 1);
                this.focusWarningIndicator.y = (sh >> 1);
            }
            if (((!(this.pauseIndicator == null)) && (!(this.pauseIndicator.parent == null))))
            {
                this.pauseIndicator.x = ((sw - this.pauseIndicator.width) >> 1);
                this.pauseIndicator.y = ((sh - this.pauseIndicator.height) >> 1);
            }
            if (this.pointsHUD != null)
            {
                this.pointsHUD.x = ((this.fieldStatistics.getPositionX() - this.pointsHUD.width) - 10);
                this.pointsHUD.y = this.fieldStatistics.getPositionY();
            }
        }
        private function showFocusWarning(show:Boolean):void
        {
            if (show)
            {
                if (this.focusWarningIndicator == null)
                {
                    this.focusWarningIndicator = new FocusWarningWindow();
                    this.focusWarningIndicator.mouseEnabled = false;
                    this.focusWarningIndicator.mouseChildren = false;
                }
                Main.stage.addChild(this.focusWarningIndicator);
                this.onResize(null);
            }
            else
            {
                if (((!(this.focusWarningIndicator == null)) && (!(this.focusWarningIndicator.parent == null))))
                {
                    this.focusWarningIndicator.parent.removeChild(this.focusWarningIndicator);
                }
            }
        }
        private function doShowPauseIndicator(show:Boolean):void
        {
            if (show)
            {
                if (((this.focusWarningIndicator == null) || ((this.focusWarningIndicator.parent == null) && (!(this.pauseIndicator == null)))))
                {
                    Main.stage.addChild(this.pauseIndicator);
                    this.onResize(null);
                }
            }
            else
            {
                if (((!(this.pauseIndicator == null)) && (!(this.pauseIndicator.parent == null))))
                {
                    this.pauseIndicator.parent.removeChild(this.pauseIndicator);
                }
            }
        }

    }
}
