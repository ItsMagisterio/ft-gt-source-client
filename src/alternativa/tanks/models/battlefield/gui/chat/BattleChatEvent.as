package alternativa.tanks.models.battlefield.gui.chat
{
    import flash.events.Event;

    public class BattleChatEvent extends Event
    {

        public static const SEND_MESSAGE:String = "sendMessage";
        public static const CHAT_EXIT:String = "closeChat";

        private var _message:String;

        public function BattleChatEvent(_arg_1:String, message:String)
        {
            super(_arg_1);
            this._message = message;
        }
        public function get message():String
        {
            return (this._message);
        }
        override public function clone():Event
        {
            return (new BattleChatEvent(type, this._message));
        }
        override public function toString():String
        {
            return (((("[BattleChatEvent type=" + type) + ", message=") + this._message) + "]");
        }

    }
}
