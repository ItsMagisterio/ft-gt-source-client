package alternativa.tanks.model.shop.items.battlepassitem
{
   import flash.display.BitmapData;

   public class PassPackageItemIcons
   {

      private static const premiumIconClass:Class = PassPackageItemIcons_passIconClass;

      public static const premiumIcon:BitmapData = new premiumIconClass().bitmapData;

      public function PassPackageItemIcons()
      {
         super();
      }
   }
}
