package alternativa.tanks.models.battlefield.common
{
    import flash.display.Sprite;
    import projects.tanks.client.battleservice.model.team.BattleTeamType;

    public class MessageContainer extends Sprite
    {

        private static const BLUE_TEAM_FONT_COLOR:uint = 4691967;
        private static const RED_TEAM_FONT_COLOR:uint = 15741974;
        private static const DEFAULT_FONT_COLOR:uint = 0xFF00;

        public var messageSpacing:int = 3;
        protected var container:Sprite = new Sprite();
        protected var shift:Number;

        public function MessageContainer()
        {
            addChild(this.container);
        }
        public static function getTeamFontColor(teamType:BattleTeamType):uint
        {
            switch (teamType)
            {
                case BattleTeamType.BLUE:
                    return (BLUE_TEAM_FONT_COLOR);
                case BattleTeamType.RED:
                    return (RED_TEAM_FONT_COLOR);
                default:
                    return (DEFAULT_FONT_COLOR);
            }
        }

        public function shiftMessages(deleteFromBuffer:Boolean = false):MessageLine
        {
            var len:int = this.container.numChildren;
            if (len == 0)
            {
                return (null);
            }
            var element:MessageLine = MessageLine(this.container.getChildAt(0));
            this.shift = int(((element.height + element.y) + this.messageSpacing));
            this.container.removeChild(element);
            len--;
            var i:int;
            while (i < len)
            {
                this.container.getChildAt(i).y = (this.container.getChildAt(i).y - this.shift);
                i++;
            }
            return (element);
        }
        protected function unshiftMessage(line:MessageLine):void
        {
            line.y = 0;
            line.alpha = 1;
            this.container.addChildAt(line, 0);
            var len:int = this.container.numChildren;
            var i:int = 1;
            while (i < len)
            {
                this.container.getChildAt(i).y = (this.container.getChildAt(i).y + int((line.height + this.messageSpacing)));
                i++;
            }
        }
        protected function pushMessage(line:MessageLine):void
        {
            var curY:int = ((this.container.numChildren > 0) ? int(int((this.container.height + this.messageSpacing))) : int(0));
            line.y = curY;
            this.container.addChild(line);
        }

    }
}
