package alternativa.tanks.models.battlefield.event
{
    import flash.events.Event;

    public class ExitEvent extends Event
    {

        public static const EXIT:String = "exit";

        public function ExitEvent(_arg_1:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(_arg_1, bubbles, cancelable);
        }
    }
}
