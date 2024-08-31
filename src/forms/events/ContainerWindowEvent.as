package forms.events
{
   import flash.events.Event;

   public class ContainerWindowEvent extends Event
   {

      public static const ON_OPEN_CONTAINER_WINDOW_DATA:String = "OnOpenContainerWindowData";
      public static const ON_OPEN_CONTAINER_DATA:String = "OnOpenContainerData";

      private var _data:String;
      public function ContainerWindowEvent(type:String, data:String)
      {
         this._data = data;
         super(type, true, false);
      }

      public function get data():String
      {
         return this._data;
      }
   }
}
