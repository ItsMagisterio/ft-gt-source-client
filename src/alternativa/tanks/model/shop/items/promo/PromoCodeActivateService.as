package alternativa.tanks.model.shop.items.promo
{
   import flash.events.EventDispatcher;

   public class PromoCodeActivateService extends EventDispatcher implements IPromoCodeActivateService
   {

      public function PromoCodeActivateService()
      {
         super();
      }

      public function activatedSuccessfully():void
      {
         dispatchEvent(new PromoCodeActivatedEvent(PromoCodeActivatedEvent.ACTIVATED_SUCCESSFULLY));
      }

      public function activatedFailed():void
      {
         dispatchEvent(new PromoCodeActivatedEvent(PromoCodeActivatedEvent.ACTIVATED_FAILED));
      }
   }
}
