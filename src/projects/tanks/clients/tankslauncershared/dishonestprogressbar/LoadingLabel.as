package projects.tanks.clients.tankslauncershared.dishonestprogressbar
{
   import flash.display.BitmapData;
   import projects.tanks.clients.tankslauncershared.service.Locale;

   public class LoadingLabel
   {

      private static const loadingLabelRuClass:Class = LoadingLabel_loadingLabelRuClass;

      private static const loadingLabelEnClass:Class = LoadingLabel_loadingLabelEnClass;

      private static const loadingLabelDeClass:Class = LoadingLabel_loadingLabelDeClass;

      private static const loadingLabelCnClass:Class = LoadingLabel_loadingLabelCnClass;

      private static const loadingLabelBrClass:Class = LoadingLabel_loadingLabelBrClass;

      public function LoadingLabel()
      {
         super();
      }

      public static function getLocalizedBitmapData(locale:String):BitmapData
      {
         var result:BitmapData = null;
         switch (locale)
         {
            case Locale.RU:
               result = new loadingLabelRuClass().bitmapData;
               break;
            case Locale.EN:
               result = new loadingLabelEnClass().bitmapData;
               break;
            case Locale.DE:
               result = new loadingLabelDeClass().bitmapData;
               break;
            case Locale.CN:
               result = new loadingLabelCnClass().bitmapData;
               break;
            case Locale.PT_BR:
               result = new loadingLabelBrClass().bitmapData;
         }
         return result;
      }
   }
}
