package alternativa.tanks.models.battlefield.event
{
    import flash.events.Event;
    import alternativa.tanks.models.battlefield.common.MessageLine;

    public class ChatOutputLineEvent extends Event
    {

        public static const KILL_ME:String = "KillMe";

        private var _line:MessageLine;

        public function ChatOutputLineEvent(_arg_1:String, line:MessageLine)
        {
            super(_arg_1, false, false);
            this._line = line;
        }
        public function get line():MessageLine
        {
            return (this._line);
        }

    }
}
