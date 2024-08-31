package alternativa.tanks.models.battlefield.gui.chat
{
    import alternativa.tanks.models.battlefield.common.MessageContainer;
    import alternativa.tanks.models.battlefield.event.ChatOutputLineEvent;
    import projects.tanks.client.battleservice.model.team.BattleTeamType;
    import alternativa.tanks.models.battlefield.common.MessageLine;

    public class BattleChatOutput extends MessageContainer
    {

        private const MAX_MESSAGES:int = 100;
        private const MIN_MESSAGES:int = 5;

        private var buffer:Array = [];
        private var minimizedMode:Boolean = true;

        public function addLine(messageLabel:String, userRank:int, chatLevel:int, userName:String, teamType:BattleTeamType, text:String, premium:Boolean):void
        {
            if ((((this.minimizedMode) && (container.numChildren > this.MIN_MESSAGES)) || ((!(this.minimizedMode)) && (container.numChildren >= this.MAX_MESSAGES))))
            {
                this.shiftMessages();
            }
            var color:uint = getTeamFontColor(teamType);
            var line:BattleChatLine = new BattleChatLine(300, messageLabel, userRank, chatLevel, userName, text, color, premium);
            line.addEventListener(ChatOutputLineEvent.KILL_ME, this.onKillLine);
            this.buffer.push(line);
            if (this.buffer.length > this.MAX_MESSAGES)
            {
                this.buffer.shift();
            }
            pushMessage(line);
        }
        public function addSpectatorLine(text:String):void
        {
            if ((((this.minimizedMode) && (container.numChildren > this.MIN_MESSAGES)) || ((!(this.minimizedMode)) && (container.numChildren >= this.MAX_MESSAGES))))
            {
                this.shiftMessages();
            }
            var line:SpectatorMessageLine = new SpectatorMessageLine(300, text);
            line.addEventListener(ChatOutputLineEvent.KILL_ME, this.onKillLine);
            this.buffer.push(line);
            if (this.buffer.length > this.MAX_MESSAGES)
            {
                this.buffer.shift();
            }
            pushMessage(line);
        }
        public function addSystemMessage(text:String):void
        {
            if ((((this.minimizedMode) && (container.numChildren > this.MIN_MESSAGES)) || ((!(this.minimizedMode)) && (container.numChildren >= this.MAX_MESSAGES))))
            {
                this.shiftMessages();
            }
            var line:BattleChatSystemLine = new BattleChatSystemLine(300, text);
            line.addEventListener(ChatOutputLineEvent.KILL_ME, this.onKillLine);
            this.buffer.push(line);
            if (this.buffer.length > this.MAX_MESSAGES)
            {
                this.buffer.shift();
            }
            pushMessage(line);
        }
        override public function shiftMessages(deleteFromBuffer:Boolean = false):MessageLine
        {
            var line:MessageLine = super.shiftMessages();
            this.y = (this.y + shift);
            if (deleteFromBuffer)
            {
                this.buffer.shift();
            }
            return (line);
        }
        public function maximize():void
        {
            var i:int;
            var line:MessageLine;
            this.minimizedMode = false;
            var len:int = (this.buffer.length - container.numChildren);
            i = 0;
            while (i < container.numChildren)
            {
                line = MessageLine(container.getChildAt(i));
                line.killStop();
                i++;
            }
            i = (len - 1);
            while (i >= 0)
            {
                try
                {
                    unshiftMessage(MessageLine(this.buffer[i]));
                }
                catch (err:Error)
                {
                }
                i--;
            }
        }
        public function minimize():void
        {
            var i:int;
            var line:MessageLine;
            this.minimizedMode = true;
            var len:int = (container.numChildren - this.MIN_MESSAGES);
            i = 0;
            while (i < len)
            {
                this.shiftMessages();
                i++;
            }
            i = 0;
            while (i < container.numChildren)
            {
                line = MessageLine(container.getChildAt(i));
                if ((!(line.live)))
                {
                    this.shiftMessages();
                    i--;
                }
                else
                {
                    line.killStart();
                }
                i++;
            }
        }
        public function clear():void
        {
            this.buffer.length = 0;
            var i:int = (container.numChildren - 1);
            while (i >= 0)
            {
                container.removeChildAt(i);
                i--;
            }
        }
        private function onKillLine(e:ChatOutputLineEvent):void
        {
            if (((this.minimizedMode) && (container.contains(e.line))))
            {
                this.shiftMessages();
            }
            e.line.removeEventListener(ChatOutputLineEvent.KILL_ME, this.onKillLine);
        }

    }
}
