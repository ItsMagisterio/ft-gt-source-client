package alternativa.tanks.model.shop.items.offeritem
{
   import flash.display.BitmapData;

   public class OfferPackageItemIcons
   {

      private static const offerIconClass:Class = OfferPackageItemIcons_offerIconClass;

      public static const offerIcon:BitmapData = new offerIconClass().bitmapData;

      private static const offerContainerClass:Class = OfferPackageItemIcons_containerIconClass;

      public static const offerContainer:BitmapData = new offerContainerClass().bitmapData;

      public function OfferPackageItemIcons()
      {
         super();
      }
   }
}
