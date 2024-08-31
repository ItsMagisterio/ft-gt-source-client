package alternativa.tanks.model.shop.items.offeritem
{
   import alternativa.tanks.model.shop.items.base.ShopItemBase;
   import alternativa.tanks.model.shop.items.base.ShopItemSkins;
import alternativa.tanks.model.shop.items.premuimitem.PremiumPackageItemIcons;

import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.text.TextFieldAutoSize;
   import logic.utils.timeunit.TimeUnitService;
   import alternativa.tanks.model.shop.items.utils.FormatUtils;
   import alternativa.tanks.model.shop.items.crystallitem.CrystalPackageItem;
   import alternativa.tanks.model.shop.items.crystallitem.CrystalPackageItemIcons;
   import flash.display.Loader;
   import flash.net.URLRequest;
   import flash.events.IOErrorEvent;
   import flash.events.Event;
   import alternativa.tanks.model.shop.items.base.ButtonItemSkin;
   import flash.display.BitmapData;
   import logic.resource.ResourceUtil;
   import logic.resource.ResourceType;
   
   public class OfferPackageItem extends ShopItemBase
   {
      
      private static const LEFT_PADDING:int = 18;
      private static const TOP_PADDING:int = 17;
      
      private static const MONEY_TEXT_LABEL_COLOR:uint = 4144959;

      private static const CRYSTALS_TEXT_LABEL_COLOR:uint = 23704;
       
      
      private const PREMIUM_TEXT_LABEL_COLOR:uint = 3432728;
      
      private var premiumLabel:LabelBase;
      
      private var priceLabel:LabelBase;
      
      private var suppliesLabel:LabelBase;
      
      private var icon:Bitmap;
      
      private var additionalData:Object;

      private var crystalLabel:LabelBase;
      private var crystalBlueIcon:Bitmap;

      private var paintPreview:Bitmap;

		[Embed(source="supply.png")]
		private static var supplyClass:Class;

		private var supplies:Bitmap = new supplyClass();
      
      public function OfferPackageItem(itemId:String, additionalData:Object, skin:ButtonItemSkin)
      {
         this.additionalData = additionalData;
         super(itemId, additionalData.unique_id, skin);
      }
      
      override protected function init() : void
      {
         super.init();
         this.initCrystalsAndPrice();
         this.initPremiumIcon();
         this.render();
      }
      
      private function initCrystalsAndPrice() : void
      {
         this.suppliesLabel = new LabelBase();
         this.suppliesLabel.text = "+ " + this.additionalData.supplies;
         this.suppliesLabel.color = 0xFFFFFF;
         this.suppliesLabel.autoSize = TextFieldAutoSize.LEFT;
         this.suppliesLabel.size = 50;
         this.suppliesLabel.bold = true;
         this.suppliesLabel.mouseEnabled = false;

         this.premiumLabel = new LabelBase();
         this.premiumLabel.text = "+" + TimeUnitService.getLocalizedDaysString(this.additionalData.premium_duration);
         this.premiumLabel.color = 0xFFFFFF;
         this.premiumLabel.autoSize = TextFieldAutoSize.LEFT;
         this.premiumLabel.size = 30;
         this.premiumLabel.bold = true;
         this.premiumLabel.mouseEnabled = false;
         if(this.additionalData.premium_duration > 0){
            addChild(this.premiumLabel);
         }else if(this.additionalData.containers > 0){
            this.premiumLabel.text = this.additionalData.containers;
            addChild(this.premiumLabel);
         }
         this.priceLabel = new LabelBase();
         fixChineseCurrencyLabelRendering(this.priceLabel);
         this.priceLabel.text = this.additionalData.price + " " + this.additionalData.currency;
         this.priceLabel.color = MONEY_TEXT_LABEL_COLOR;
         this.priceLabel.autoSize = TextFieldAutoSize.LEFT;
         this.priceLabel.size = 38;
         this.priceLabel.bold = true;
         this.priceLabel.mouseEnabled = false;
         addChild(this.priceLabel);

         this.crystalLabel = new LabelBase();
         this.crystalLabel.text = FormatUtils.valueToString(this.additionalData.crystalls_count, 0, false);
         this.crystalBlueIcon = new Bitmap(CrystalPackageItemIcons.bigCrystall);
         this.crystalBlueIcon.smoothing = true;
         if(Number(this.additionalData.crystalls_count) == 0){
            this.crystalLabel.text = this.additionalData.name;
         }else{
            addChild(this.crystalBlueIcon);
         }
         if(Number(this.additionalData.supplies) != 0){
            addChild(supplies);
            addChild(suppliesLabel);
         }
         if(this.additionalData.image != ""){
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
               addChild(loader);
               loader.x = 520;
               loader.y = 14;
            });
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void {
               trace("Error loading image: " + event.text);
            });
            var urlRequest:URLRequest = new URLRequest(this.additionalData.image);
            loader.load(urlRequest);
         }
         if(this.additionalData.extra_paint != null){
            var extra_paint:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,this.additionalData.extra_paint + "_preview").bitmapData;
            this.paintPreview = new Bitmap(extra_paint);
            this.paintPreview.width *= 0.75;
            this.paintPreview.height *= 0.75;
            this.paintPreview.smoothing = true;
            addChild(this.paintPreview);
         }
         this.crystalLabel.color = CRYSTALS_TEXT_LABEL_COLOR;
         this.crystalLabel.autoSize = TextFieldAutoSize.LEFT;
         this.crystalLabel.size = 50;
         this.crystalLabel.bold = true;
         this.crystalLabel.mouseEnabled = false;
         addChild(this.crystalLabel);
      }
      
      private function initPremiumIcon() : void
      {
         if(this.additionalData.premium_duration > 0){
            this.icon = new Bitmap(OfferPackageItemIcons.offerIcon);
            addChild(this.icon);
         }else if(this.additionalData.containers > 0){
            this.icon = new Bitmap(OfferPackageItemIcons.offerContainer);
            addChild(this.icon);
         }
      }
      
      private function render() : void
      {
         this.crystalLabel.x = LEFT_PADDING;
         this.crystalLabel.y = TOP_PADDING;
         this.crystalBlueIcon.x = ((this.crystalLabel.x + this.crystalLabel.width) + 3);
         this.crystalBlueIcon.y = (TOP_PADDING + 8);
         this.icon.x = (WIDTH * 3) / 2 - LEFT_PADDING;
         this.premiumLabel.x = this.icon.x + (this.icon.width / 2 - this.premiumLabel.width / 2);
         this.priceLabel.x = LEFT_PADDING;
         this.icon.y = HEIGHT - this.icon.height - 20 >> 1;
         this.premiumLabel.y = this.icon.y + this.icon.height - LEFT_PADDING + 10;
         this.priceLabel.y = HEIGHT - this.priceLabel.height - LEFT_PADDING;
         this.supplies.width *= 0.9;
         this.supplies.height *= 0.9;
         this.supplies.smoothing = true;
         this.supplies.x = icon.x + icon.width + 40;
         this.supplies.y = 10;
         this.suppliesLabel.x = this.supplies.x + this.supplies.width - this.suppliesLabel.width - 10;
         this.suppliesLabel.y = this.icon.y + this.icon.height - LEFT_PADDING;
         if(paintPreview != null){
            this.paintPreview.y = 6;
            this.paintPreview.x = this.icon.x + this.icon.width - 18;
         }
      }
   }
}
