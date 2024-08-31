package alternativa.tanks.model.shop.items.promo
{
   import alternativa.tanks.model.shop.items.base.ShopItemBase;
   import alternativa.tanks.model.shop.items.base.ShopItemSkins;
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.text.TextFieldAutoSize;
   
   public class PromoPackageItem extends ShopItemBase
   {
	   
    [Embed(source="1043.png")]  
      private static const promoIconClass:Class;
      
      public static const promoIcon:BitmapData = new promoIconClass().bitmapData;
      
      private static const LEFT_PADDING:int = 17;
      
      private static const TEXT_LABEL_COLOR:uint = 23704;
       
      
      private var promoLabel:LabelBase;
      
      private var icon:Bitmap;
      
      private var additionalData:Object;
      
      public function PromoPackageItem(itemId:String, additionalData:Object)
      {
         this.additionalData = additionalData;
         super(itemId,additionalData.unique_id,ShopItemSkins.GREY);
      }
      
      override protected function init() : void
      {
         super.init();
         this.initPromoIcon();
         this.render();
      }
      
      private function initPromoIcon() : void
      {
         this.promoLabel = new LabelBase();
         this.promoLabel.text = Game.currLocale == null ? "Promocodes" : (Game.currLocale == "EN" ? "Promocodes" : "Промокоды");
         this.promoLabel.color = TEXT_LABEL_COLOR;
         this.promoLabel.autoSize = TextFieldAutoSize.LEFT;
         this.promoLabel.size = 22;
         this.promoLabel.bold = true;
         this.promoLabel.mouseEnabled = false;
         this.promoLabel.wordWrap = true;
         this.promoLabel.width = this.width / 2;
         addChild(this.promoLabel);
         this.icon = new Bitmap(promoIcon);
         addChild(this.icon);
      }
      
      private function render() : void
      {
         this.icon.x = this.width - LEFT_PADDING - 150 - LEFT_PADDING;
         this.promoLabel.x = LEFT_PADDING;
         this.icon.y = 16;
         this.promoLabel.y = this.height / 2 - this.promoLabel.height / 2;
      }
   }
}
