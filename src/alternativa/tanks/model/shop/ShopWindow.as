package alternativa.tanks.model.shop
{
    import flash.display.Sprite;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import controls.TankWindow;
    import alternativa.tanks.model.shop.bugreport.PaymentBugReportBlock;
    import controls.base.DefaultButtonBase;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import alternativa.tanks.model.shop.items.crystallitem.CrystalPackageItem;
    import alternativa.tanks.model.shop.items.promo.PromoPackageItem;
    import alternativa.tanks.model.shop.items.promo.PromoCodeActivateForm;
    import alternativa.tanks.model.shop.items.premuimitem.PremiumPackageItem;
    import alternativa.tanks.model.shop.items.offeritem.OfferPackageItem;
    import alternativa.tanks.model.shop.items.containeritem.ContainerPackageItem;
    import alternativa.tanks.model.shop.items.battlepassitem.PassPackageItem;
    import alternativa.tanks.model.shop.items.base.ShopItemSkins;
    import alternativa.tanks.model.shop.items.paintsitem.PaintsPackageItem;

    public class ShopWindow extends Sprite
    {

        public static var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);
        public static const WINDOW_PADDING:int = 11;
        public static const SPACE_MODULE:int = 7;
        public static var haveDoubleCrystalls:Boolean = false;

        private var tankWindow:TankWindow = new TankWindow();
        private var categories:ShopCategorysView = new ShopCategorysView();
        private var bugReportBlock:PaymentBugReportBlock;
        public var header:ShowWindowHeader = new ShowWindowHeader();
        private var closeButton:DefaultButtonBase;

        public function ShopWindow()
        {
            addChild(this.tankWindow);
            this.tankWindow.width = 915;
            this.tankWindow.height = 691;
            this.header.x = WINDOW_PADDING;
            this.header.y = WINDOW_PADDING;
            this.header.resize((915 - (WINDOW_PADDING * 2)));
            this.closeButton = new DefaultButtonBase();
            this.closeButton.tabEnabled = false;
            this.closeButton.label = "Close";
            this.closeButton.x = ((this.tankWindow.width - this.closeButton.width) - (2 * WINDOW_PADDING));
            this.closeButton.y = ((this.tankWindow.height - this.closeButton.height) - WINDOW_PADDING);
            this.closeButton.addEventListener(MouseEvent.CLICK, this.onClickClose);
            addChild(this.closeButton);
            this.bugReportBlock = new PaymentBugReportBlock();
            this.bugReportBlock.x = WINDOW_PADDING;
            this.bugReportBlock.y = ((this.closeButton.y - WINDOW_PADDING) - this.bugReportBlock.height);
            this.bugReportBlock.width = ((this.tankWindow.width - WINDOW_PADDING) - this.bugReportBlock.x);
            addChild(this.bugReportBlock);
            this.tankWindow.addChild(this.categories);
            this.tankWindow.addChild(this.header);
            this.categories.x = WINDOW_PADDING;
            this.categories.y = (((this.header.y + this.header.height) + SPACE_MODULE) - 2);
        }
        private function onClickClose(e:MouseEvent):void
        {
            dispatchEvent(new Event(Event.CLOSE));
        }
        public function addPromoActivator():void
        {
            var promoActivator:PromoCodeActivateForm = new PromoCodeActivateForm();
            addChild(promoActivator);
            promoActivator.render(this.tankWindow.width, this.categories.height + WINDOW_PADDING);
            promoActivator.x = 0;
            promoActivator.y = WINDOW_PADDING + header.height;
        }
        public function addCategory(header:String, description:String, categoryId:String):void
        {
            if (categoryId == "special_offers")
            {
                //FIXME: temp disable special offers
                this.categories.addCategory(new ShopCategoryView(header, description, categoryId, 1));
            }
            else
            {
                this.categories.addCategory(new ShopCategoryView(header, description, categoryId));
            }
            this.categories.render((this.tankWindow.width - (WINDOW_PADDING * 2)), ((this.bugReportBlock.y - this.categories.y) - WINDOW_PADDING));
        }
        public function addItem(categoryId:String, itemId:String, additionalData:Object):void
        {
            if (itemId.indexOf("crystal") >= 0)
            {
                this.categories.addItem(categoryId, new CrystalPackageItem(itemId, additionalData));
            }
            if (itemId.indexOf("premium") >= 0)
            {
                this.categories.addItem(categoryId, new PremiumPackageItem(itemId, additionalData));
            }
            if (itemId.indexOf("special") >= 0)
            {
                //FIXME: temp disable special offers
                if (additionalData.bg_type == 0)
                {
                    this.categories.addItem(categoryId, new OfferPackageItem(itemId, additionalData, ShopItemSkins.LONG_YELLOW));
                }
                // else if (additionalData.bg_type == 1)
                // {
                //     this.categories.addItem(categoryId, new OfferPackageItem(itemId, additionalData, ShopItemSkins.LONG_BLUE));
                // }
                // else if (additionalData.bg_type == 2)
                // {
                //     this.categories.addItem(categoryId, new OfferPackageItem(itemId, additionalData, ShopItemSkins.LONG_RED));
                // }
                // else if (additionalData.bg_type == 3)
                // {
                //     this.categories.addItem(categoryId, new OfferPackageItem(itemId, additionalData, ShopItemSkins.LONG_GREEN));
                // }
            }
            if (itemId.indexOf("battle_pass") >= 0)
            {
                this.categories.addItem(categoryId, new PassPackageItem(itemId, additionalData));
            }
            if (itemId.indexOf("container") >= 0)
            {
                this.categories.addItem(categoryId, new ContainerPackageItem(itemId, additionalData));
            }
            if (itemId.indexOf("promo") >= 0)
            {
                this.categories.addItem(categoryId, new PromoPackageItem(itemId, additionalData));
            }
            if (itemId.indexOf("preview") >= 0)
            {
                this.categories.addItem(categoryId, new PaintsPackageItem(itemId, additionalData));
            }
            this.categories.render((this.tankWindow.width - (WINDOW_PADDING * 2)), ((this.bugReportBlock.y - this.categories.y) - WINDOW_PADDING));
        }

    }
}
