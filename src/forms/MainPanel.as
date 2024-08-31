package forms
{
    import flash.display.Sprite;
    import controls.rangicons.RangIconNormal;
    import controls.PlayerInfo;
    import flash.events.Event;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import flash.events.MouseEvent;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import forms.events.MainButtonBarEvents;

    public class MainPanel extends Sprite
    {

        public var rangIcon:RangIconNormal = new RangIconNormal();
        public var playerInfo:PlayerInfo = new PlayerInfo();
        public var buttonBar:ButtonBar;
        private var _rang:int;
        private var _isTester:Boolean = false;

        public function MainPanel()
        {
            this._isTester = this.isTester;
            this.buttonBar = new ButtonBar();
            addEventListener(Event.ADDED_TO_STAGE, this.configUI);
        }
        public function set rang(value:int):void
        {
            this._rang = value;
            this.playerInfo.rang = value;
            this.rangIcon.rang1 = this._rang;
        }
        public function set premium(value:int):void
        {
            this._rang = value;
            this.playerInfo.rang = value;
            this.rangIcon.premiumR = this._rang;
        }
        public function get rang():int
        {
            return (this._rang);
        }
        private function configUI(e:Event):void
        {
            this.y = 3;
            addChild(this.rangIcon);
            addChild(this.playerInfo);
            addChild(this.buttonBar);
            var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            this.rangIcon.y = -2;
            this.rangIcon.x = 2;
            removeEventListener(Event.ADDED_TO_STAGE, this.configUI);
            this.playerInfo.indicators.changeButton.addEventListener(MouseEvent.CLICK, this.listClick);
            this.buttonBar.addButton = this.playerInfo.indicators.changeButton;
            stage.addEventListener(Event.RESIZE, this.onResize);
            this.onResize(null);
            var timer:Timer = new Timer(100, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void
                {
                    onResize(null);
                });
            timer.start();
        }
        private function listClick(e:MouseEvent):void
        {
            this.buttonBar.dispatchEvent(new MainButtonBarEvents(1));
        }
        public function onResize(e:Event):void
        {
            var _loc1_:int = int(Math.max(970, stage.stageWidth));
            this.playerInfo.x = 15;
            var _loc2_:int = 7;
            this.playerInfo.width = _loc1_ - this.buttonBar.width + 13 - this.playerInfo.x - _loc2_ + 3;
            this.buttonBar.x = _loc1_ - this.buttonBar.width;
            this.buttonBar.draw();
            this.alignRankIcon();
        }
        public function hide():void
        {
            stage.removeEventListener(Event.RESIZE, this.onResize);
        }
        public function get isTester():Boolean
        {
            return (this._isTester);
        }
        public function set isTester(value:Boolean):void
        {
            this._isTester = value;
            this.buttonBar.isTester = this._isTester;
            this.buttonBar.draw();
            this.onResize(null);
        }

        private function alignRankIcon():void
        {
            this.rangIcon.y = 29 - (this.rangIcon.height >> 1);
            this.rangIcon.x = 38 - (this.rangIcon.width >> 1);
        }

    }
}
