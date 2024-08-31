package alternativa.tanks.model.shop.items.promo
{
   import flash.events.Event;

   public class PromoCodeActivatedEvent extends Event
   {

      public static const ACTIVATED_SUCCESSFULLY:String = "activatedSuccessfully";

      public static const ACTIVATED_FAILED:String = "activatedFailed";

      public function PromoCodeActivatedEvent(param1:String)
      {
         super(param1, true);
      }
   }
}
