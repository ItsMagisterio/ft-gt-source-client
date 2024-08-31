package alternativa.tanks.service.settings
{
   import flash.events.Event;

   public class SettingsServiceEvent extends Event
   {

      public static const SETTINGS_CHANGED:String = "SettingsServiceEvent.SETTINGS_CHANGED";

      private var setting:alternativa.tanks.service.settings.SettingEnum;

      public function SettingsServiceEvent(param1:String, param2:alternativa.tanks.service.settings.SettingEnum)
      {
         super(param1, true, false);
         this.setting = param2;
      }

      public function getSetting():alternativa.tanks.service.settings.SettingEnum
      {
         return this.setting;
      }
   }
}
