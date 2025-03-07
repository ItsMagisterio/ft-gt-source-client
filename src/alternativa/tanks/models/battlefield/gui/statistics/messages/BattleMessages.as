﻿package alternativa.tanks.models.battlefield.gui.statistics.messages
{
    import flash.display.Sprite;
    import flash.events.Event;
    import alternativa.init.Main;
    import projects.tanks.client.battlefield.gui.models.statistics.UserStat;

    public class BattleMessages extends Sprite
    {

        private var output:BattleMessagesOutput = new BattleMessagesOutput();

        public function BattleMessages()
        {
            addEventListener(Event.ADDED_TO_STAGE, this.ConfigUI);
            addEventListener(Event.ADDED_TO_STAGE, this.addResizeListener);
            addEventListener(Event.REMOVED_FROM_STAGE, this.removeResizeListener);
        }
        public function ConfigUI(e:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.ConfigUI);
            addChild(this.output);
            this.output.tabEnabled = false;
            this.output.tabChildren = false;
        }
        private function addResizeListener(e:Event):void
        {
            stage.addEventListener(Event.RESIZE, this.onResize);
        }
        private function removeResizeListener(e:Event):void
        {
            stage.removeEventListener(Event.RESIZE, this.onResize);
        }
        public function onResize(e:Event):void
        {
            this.output.x = Main.stage.stageWidth;
            this.output.y = 50;
        }
        public function addMessage(source:UserStat, action:String, target:UserStat = null):void
        {
            this.output.addLine(new UserActionOutputLine(source, action, target));
            this.onResize(null);
        }
        public function addMessageWithImage(source:UserStat, action:String, target:UserStat = null):void
        {
            this.output.addLineImage(new UserActionImageLine(source, action, target));
            this.onResize(null);
        }

    }
}
