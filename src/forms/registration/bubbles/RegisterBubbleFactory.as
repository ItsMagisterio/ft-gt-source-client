package forms.registration.bubbles
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.help.HelperAlign;
   import alternativa.tanks.locale.constants.TextConst;
   import flash.geom.Point;

   public class RegisterBubbleFactory
   {

      private static var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;

      public function RegisterBubbleFactory()
      {
         super();
      }

      public static function passwordIsTooEasyBubble():Bubble
      {
         return customBubble("Pasword is too simple", HelperAlign.TOP_LEFT);
      }

      public static function passwordsDoNotMatchBubble():Bubble
      {
         return customBubble("Passwords don't match", HelperAlign.TOP_LEFT);
      }

      public static function nameIsIncorrectBubble():Bubble
      {
         return customBubble("Nickname is not suitable", HelperAlign.TOP_LEFT);
      }

      private static function customBubble(text:String, arrowAlign:int):Bubble
      {
         var bubble:Bubble = new Bubble(new Point(10, 10));
         bubble.text = text;
         bubble.arrowLehgth = 20;
         bubble.arrowAlign = HelperAlign.TOP_LEFT;
         return bubble;
      }
   }
}
