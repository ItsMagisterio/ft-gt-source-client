package alternativa.tanks.model.shop.items.promo
{
   import flash.events.IEventDispatcher;

   public interface IPromoCodeActivateService extends IEventDispatcher
   {

      function activatedSuccessfully():void;

      function activatedFailed():void;
   }
}
