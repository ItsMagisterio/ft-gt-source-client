package alternativa.tanks.gui.settings.tabs.account
{
    import alternativa.tanks.gui.settings.SettingEvent;

    public class AccountSettingsEvent extends SettingEvent
    {
        public static const SET_EMAIL:String = "AccountSettingsEventSetEmail";
        public static const CHANGE_PASSWORD:String = "AccountSettingsEventChangePassword";
        public static const UNBIND_EMAIL:String = "AccountSettingsEventUnbindEmail";
        public static const CONFIRM_EMAIL:String = "AccountSettingsEventConfirmEmail";

        public function AccountSettingsEvent(type:String)
        {
            super(type);
        }
    }
}
