// Decompiled by AS3 Sorcerer 6.30
// www.as3sorcerer.com

// projects.tanks.clients.fp10.libraries.tanksservices.utils.AlertUtils

package projects.tanks.clients.fp10.libraries.tanksservices.utils
{
    import projects.tanks.clients.fp10.libraries.tanksservices.service.fullscreen.FullscreenStateService;
    import flash.ui.Keyboard;

    public class AlertUtils
    {

        [Inject]
        public static var fullscreenStateService:FullscreenStateService;

        public static function isConfirmationKey(_arg_1:uint):Boolean
        {
            return (_arg_1 == Keyboard.ENTER);
        }
        public static function isCancelKey(_arg_1:uint):Boolean
        {
            return ((_arg_1 == Keyboard.ESCAPE) && (!(fullscreenStateService.isFullscreen())));
        }

    }
} // package projects.tanks.clients.fp10.libraries.tanksservices.utils