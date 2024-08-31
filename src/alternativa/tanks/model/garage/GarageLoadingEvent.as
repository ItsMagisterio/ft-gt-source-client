package alternativa.tanks.model.garage
{
    import flash.events.Event;

    public class GarageLoadingEvent extends Event
    {
        public static const COMPLETE:String = "garageLoadingCompleteEvent";

        public function GarageLoadingEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
        }

        override public function clone():Event
        {
            return new GarageLoadingEvent(type, bubbles, cancelable);
        }
    }
}