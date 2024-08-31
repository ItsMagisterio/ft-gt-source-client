package forms.events
{
    import flash.events.Event;

    public class StatListEvent extends Event
    {

        public static const UPDATE_STAT:String = "StatListUpdate";
        public static const UPDATE_SORT:String = "StatListUpdateSort";

        public var beginPosition:int = 0;
        public var numRow:int = 0;
        public var sortField:int;

        public function StatListEvent(_arg_1:String, begin:int, num:int, sort:int = 1)
        {
            super(_arg_1, true, false);
            this.beginPosition = begin;
            this.numRow = num;
            this.sortField = sort;
        }
    }
}
