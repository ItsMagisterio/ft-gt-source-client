package alternativa.tanks.models.battlefield.gui.statistics.table
{
    import flash.display.Sprite;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import projects.tanks.client.battleservice.model.team.BattleTeamType;
    import flash.events.Event;
    import __AS3__.vec.Vector;
    import projects.tanks.client.battlefield.gui.models.statistics.UserStat;
    import alternativa.tanks.models.battlefield.event.ExitEvent;
    import flash.events.MouseEvent;
    import alternativa.tanks.models.tank.TankModel;
    import alternativa.tanks.models.tank.ITank;
    import controls.Label;
    import alternativa.tanks.models.battlefield.gui.statistics.field.TimeLimitField;
    import controls.resultassets.ResultWindowGray;
    import controls.DefaultButton;
    import controls.RedButton;

    [Event(name="exit", type="alternativa.tanks.models.battlefield.event.ExitEvent")]
    public class TableStatistics extends Sprite
    {

        public static const LOG_CHANNEL:String = "STAT";
        public static const LOG_PREFIX:String = "[TableStatistics]";

        private var redTeamView:ViewStatistics;
        private var blueTeamView:ViewStatistics;
        private var dmView:ViewStatistics;
        private var exitPanel:Sprite;
        private var teamPlay:Boolean;
        private var battleNamePlate:BattleNamePlate;
        private var restartMessage:String;
        private var exitLabel:String;

        public function TableStatistics(battleName:String, teamPlay:Boolean)
        {
            this.teamPlay = teamPlay;
            visible = false;
            this.battleNamePlate = new BattleNamePlate(battleName, 18);
            var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            this.restartMessage = localeService.getText(TextConst.BATTLE_RESTART);
            this.exitLabel = localeService.getText(TextConst.BATTLE_EXIT);
        }
        public function show(localUserId:String, userStats:Vector.<UserStat>, battleFinished:Boolean, timeToRestart:int):void
        {
            if (visible)
            {
                return;
            }
            if (this.teamPlay)
            {
                this.redTeamView = this.createView(BattleTeamType.RED, localUserId, userStats, battleFinished);
                addChild(this.redTeamView);
                this.blueTeamView = this.createView(BattleTeamType.BLUE, localUserId, userStats, battleFinished);
                addChild(this.blueTeamView);
            }
            else
            {
                this.dmView = this.createView(BattleTeamType.NONE, localUserId, userStats, battleFinished);
                addChild(this.dmView);
            }
            if (battleFinished)
            {
                this.createExitPanel(timeToRestart);
            }
            else
            {
                this.createExitPanel(0);
            }
            addChild(this.battleNamePlate);
            visible = true;
            stage.addEventListener(Event.RESIZE, this.onResize);
            this.onResize(null);
        }
        public function hide():void
        {
            if ((!(visible)))
            {
                return;
            }
            if (stage != null)
            {
                stage.removeEventListener(Event.RESIZE, this.onResize);
            }
            removeChild(this.battleNamePlate);
            if (((this.blueTeamView) && (contains(this.blueTeamView))))
            {
                removeChild(this.blueTeamView);
                this.blueTeamView = null;
            }
            if (((this.redTeamView) && (contains(this.redTeamView))))
            {
                removeChild(this.redTeamView);
                this.redTeamView = null;
            }
            if (((this.dmView) && (contains(this.dmView))))
            {
                removeChild(this.dmView);
                this.dmView = null;
            }
            if (((this.exitPanel) && (contains(this.exitPanel))))
            {
                removeChild(this.exitPanel);
                this.exitPanel = null;
            }
            visible = false;
        }
        public function removePlayer(userId:String, teamType:BattleTeamType):void
        {
            if ((!(visible)))
            {
                return;
            }
            if ((((this.teamPlay) && (this.blueTeamView)) && (this.redTeamView)))
            {
                if (teamType == BattleTeamType.BLUE)
                {
                    this.blueTeamView.removePlayer(userId);
                }
                else
                {
                    this.redTeamView.removePlayer(userId);
                }
                this.setTeamViewHeight();
            }
            else
            {
                if (this.dmView)
                {
                    this.dmView.removePlayer(userId);
                    this.setViewHeight();
                }
            }
        }
        public function updatePlayer(userStat:UserStat):void
        {
            if ((!(visible)))
            {
                return;
            }
            if (this.teamPlay)
            {
                if (userStat.teamType == BattleTeamType.BLUE)
                {
                    this.blueTeamView.updatePlayer(userStat.userId, userStat.name, userStat.rank, userStat.kills, userStat.deaths, userStat.score, -1, userStat.isPremium);
                }
                else
                {
                    this.redTeamView.updatePlayer(userStat.userId, userStat.name, userStat.rank, userStat.kills, userStat.deaths, userStat.score, -1, userStat.isPremium);
                }
                this.setTeamViewHeight();
            }
            else
            {
                this.dmView.updatePlayer(userStat.userId, userStat.name, userStat.rank, userStat.kills, userStat.deaths, -1, -1, userStat.isPremium);
                this.setViewHeight();
            }
            this.onResize(null);
        }
        public function onResize(e:Event):void
        {
            var halfWidth:int = int((Main.stage.stageWidth / 2));
            var halfHeight:int = int((Main.stage.stageHeight / 2));
            var view1:ViewStatistics;
            var view2:ViewStatistics;
            if (this.dmView)
            {
                this.setViewHeight();
                this.dmView.x = (halfWidth - (this.dmView.width >> 1));
                this.dmView.y = (halfHeight - (this.dmView.height >> 1));
                view1 = (view2 = this.dmView);
            }
            else
            {
                if (((this.blueTeamView) && (this.redTeamView)))
                {
                    this.setTeamViewHeight();
                    this.blueTeamView.x = (halfWidth - (this.blueTeamView.width >> 1));
                    this.redTeamView.x = this.blueTeamView.x;
                    this.redTeamView.y = (halfHeight - (((this.blueTeamView.height + this.redTeamView.height) + 5) >> 1));
                    this.blueTeamView.y = ((this.redTeamView.y + this.redTeamView.height) + 5);
                    view1 = this.redTeamView;
                    view2 = this.blueTeamView;
                }
            }
            this.battleNamePlate.x = view1.x;
            this.battleNamePlate.y = ((view1.y - this.battleNamePlate.height) - 5);
            this.battleNamePlate.width = view1.width;
            if (this.exitPanel)
            {
                this.exitPanel.x = (halfWidth - (this.exitPanel.width >> 1));
                this.exitPanel.y = ((view2.y + view2.height) + 10);
            }
        }
        private function onExitClick(e:MouseEvent):void
        {
            dispatchEvent(new ExitEvent(ExitEvent.EXIT));
        }
        private function createView(teamType:BattleTeamType, localUserId:String, userStats:Vector.<UserStat>, battleFinished:Boolean):ViewStatistics
        {
            var userStat:UserStat;
            var reward:int;
            var score:int;
            var viewType:int = ((teamType == BattleTeamType.NONE) ? int(ViewStatistics.GREEN) : ((teamType == BattleTeamType.RED) ? int(ViewStatistics.RED) : int(ViewStatistics.BLUE)));
            var view:ViewStatistics = new ViewStatistics(viewType, localUserId, battleFinished);
            var len:int = userStats.length;
            var model:TankModel = TankModel(Main.osgi.getService(ITank));
            var i:int;
            while (i < len)
            {
                userStat = userStats[i];
                if (((userStat.teamType == teamType) && (!(model.tankDataById[userStat.userId] == null))))
                {
                    reward = ((!(!(battleFinished))) ? int(userStat.reward) : int(-1));
                    score = ((teamType == BattleTeamType.NONE) ? int(-1) : int(userStat.score));
                    view.updatePlayer(userStat.userId, userStat.name, userStat.rank, userStat.kills, userStat.deaths, score, reward, userStat.isPremium);
                }
                else
                {
                    if (userStat.teamType == teamType)
                    {
                        trace(("Found and removed wrong player: " + userStat.name));
                        this.removePlayer(userStat.userId, teamType);
                    }
                }
                i++;
            }
            return (view);
        }
        private function setViewHeight():void
        {
            var deltaHeight:Number = (Main.stage.stageHeight - 200);
            this.dmView.resize(deltaHeight);
        }
        private function setTeamViewHeight():void
        {
            var half:Number = NaN;
            var deltaHeight:Number = (Main.stage.stageHeight - 200);
            this.blueTeamView.resize(deltaHeight);
            this.redTeamView.resize(deltaHeight);
            if ((this.blueTeamView.height + this.redTeamView.height) > deltaHeight)
            {
                half = (0.5 * deltaHeight);
                if (((this.blueTeamView.height > half) && (this.redTeamView.height > half)))
                {
                    this.blueTeamView.resize(half);
                    this.redTeamView.resize(half);
                }
                else
                {
                    if (this.blueTeamView.height < half)
                    {
                        this.redTeamView.resize((deltaHeight - this.blueTeamView.height));
                    }
                    else
                    {
                        this.blueTeamView.resize((deltaHeight - this.redTeamView.height));
                    }
                }
            }
        }
        private function createExitPanel(timeToRestart:int):void
        {
            var beginStr:Label;
            var restartField:TimeLimitField;
            this.exitPanel = new Sprite();
            var bg:ResultWindowGray = new ResultWindowGray();
            bg.width = width;
            this.exitPanel.addChild(bg);
            var exitButton:RedButton = new RedButton();
            bg.height = (exitButton.height + 8);
            exitButton.addEventListener(MouseEvent.CLICK, this.onExitClick);
            exitButton.label = this.exitLabel;
            exitButton.x = ((width - exitButton.width) - 4);
            exitButton.y = 4;
            this.exitPanel.addChild(exitButton);
            if (timeToRestart > 0)
            {
                beginStr = new Label();
                beginStr.text = (this.restartMessage + ": ");
                this.exitPanel.addChild(beginStr);
                beginStr.x = 4;
                beginStr.y = 10;
                restartField = new TimeLimitField(-1, -1, null, true);
                restartField.initTime(timeToRestart);
                this.exitPanel.addChild(restartField);
                restartField.x = (beginStr.x + beginStr.width);
                restartField.y = 4;
                restartField.size = 22;
            }
            addChild(this.exitPanel);
        }

    }
}
