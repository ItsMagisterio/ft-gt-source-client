package alternativa.tanks.utils
{
   import alternativa.tanks.services.Services;
   import flash.ui.Keyboard;

   public class AlertUtils
   {

      public function AlertUtils()
      {
         super();
      }

      public static function isConfirmationKey(param1:uint):Boolean
      {
         return param1 == Keyboard.ENTER;
      }

      public static function isCancelKey(param1:uint):Boolean
      {
         return param1 == Keyboard.ESCAPE && !Services.fullScreenStateService.isFullscreen();
      }
   }
}
