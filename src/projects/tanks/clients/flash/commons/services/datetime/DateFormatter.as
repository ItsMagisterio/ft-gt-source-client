package projects.tanks.clients.flash.commons.services.datetime
{
   import alternativa.osgi.service.locale.ILocaleService;
   import flash.globalization.DateTimeFormatter;

   public class DateFormatter
   {

      [Inject]
      public static var localeService:ILocaleService;

      private static var dateFormat:DateTimeFormatter;

      private static var timeFormat:DateTimeFormatter;

      private static var timeFormatMessageChat:DateTimeFormatter;

      public function DateFormatter()
      {
         super();
      }

      public static function formatDateToLocalized(param1:Date):String
      {
         if (dateFormat == null)
         {
            dateFormat = new DateTimeFormatter("");
            dateFormat.setDateTimePattern("HH:mm");
         }
         return dateFormat.format(param1);
      }

      public static function formatTime(param1:Date):String
      {
         if (timeFormat == null)
         {
            timeFormat = new DateTimeFormatter("");
            timeFormat.setDateTimePattern("HH:mm");
         }
         return timeFormat.format(param1);
      }

      public static function formatTimeForChatToLocalized(param1:Date):String
      {
         if (timeFormatMessageChat == null)
         {
            timeFormatMessageChat = new DateTimeFormatter("");
            timeFormatMessageChat.setDateTimePattern("HH:mm");
         }
         return timeFormatMessageChat.format(param1);
      }
   }
}
