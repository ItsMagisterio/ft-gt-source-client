package alternativa.tanks.gui.settings
{
   import flash.events.Event;

   public class SettingEvent extends Event
   {

      public function SettingEvent(type:String)
      {
         super(type, true, false);
      }
   }
}
