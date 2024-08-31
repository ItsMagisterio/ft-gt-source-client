package alternativa.tanks.model.shop.items.premuimitem
{
   import alternativa.tanks.model.shop.items.base.ShopItemBase;
   import alternativa.tanks.model.shop.items.base.ShopItemSkins;
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.text.TextFieldAutoSize;
   import logic.utils.timeunit.TimeUnitService;

   public class PremiumPackageItem extends ShopItemBase
   {

      private static const LEFT_PADDING:int = 18;

      private static const MONEY_TEXT_LABEL_COLOR:uint = 4144959;

      private const PREMIUM_TEXT_LABEL_COLOR:uint = 3432728;

      private var premiumLabel:LabelBase;

      private var priceLabel:LabelBase;

      private var icon:Bitmap;

      private var additionalData:Object;

      public function PremiumPackageItem(itemId:String, additionalData:Object)
      {
         this.additionalData = additionalData;
         super(itemId, additionalData.unique_id, ShopItemSkins.GREY);
      }

      override protected function init():void
      {
         super.init();
         this.initCrystalsAndPrice();
         this.initPremiumIcon();
         this.render();
      }

      private function initCrystalsAndPrice():void
      {
         this.premiumLabel = new LabelBase();
         this.premiumLabel.text = "+" + TimeUnitService.getLocalizedDaysString(this.additionalData.premium_duration);
         this.premiumLabel.color = this.PREMIUM_TEXT_LABEL_COLOR;
         this.premiumLabel.autoSize = TextFieldAutoSize.LEFT;
         this.premiumLabel.size = 30;
         this.premiumLabel.bold = true;
         this.premiumLabel.mouseEnabled = false;
         addChild(this.premiumLabel);
         this.priceLabel = new LabelBase();
         fixChineseCurrencyLabelRendering(this.priceLabel);
         this.priceLabel.text = this.additionalData.price + " " + this.additionalData.currency;
         this.priceLabel.color = MONEY_TEXT_LABEL_COLOR;
         this.priceLabel.autoSize = TextFieldAutoSize.LEFT;
         this.priceLabel.size = 22;
         this.priceLabel.bold = true;
         this.priceLabel.mouseEnabled = false;
         addChild(this.priceLabel);
      }

      private function initPremiumIcon():void
      {
         this.icon = new Bitmap(PremiumPackageItemIcons.premiumIcon);
         addChild(this.icon);
      }

      private function render():void
      {
         this.icon.x = LEFT_PADDING - 5;
         this.premiumLabel.x = this.icon.x + this.icon.width - 7;
         this.priceLabel.x = this.premiumLabel.x;
         this.icon.y = HEIGHT - this.icon.height >> 1;
         this.premiumLabel.y = this.icon.y + 2;
         this.priceLabel.y = this.icon.y + this.icon.height - this.priceLabel.height;
      }
   }
}
