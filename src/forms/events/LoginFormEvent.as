package forms.events
{
    import flash.events.Event;

    public class LoginFormEvent extends Event
    {

        public static const TEXT_CHANGED:String = "LoginChanged";
        public static const PLAY_PRESSED:String = "PlayButtonPressed";
        public static const RESTORE_PRESSED:String = "RestoreButtonPressed";
        public static const RESET_PASSWORD:String = "ResetButtonPressed";
        public static const RESTORE_PRESSED_CODE:String = "RestoreButtonPressedCode";
        public static const SHOW_RULES:String = "ShowRules";
        public static const SHOW_TERMS:String = "ShowTerms";
        public static const CHANGE_STATE:String = "LoginFormStateChanged";

        public function LoginFormEvent(_arg_1:String)
        {
            super(_arg_1, true, false);
        }
    }
}
