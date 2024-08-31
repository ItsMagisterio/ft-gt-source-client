package alternativa.tanks.model.shop
{
    import alternativa.osgi.service.locale.ILocaleService;
    import flash.display.DisplayObjectContainer;
    import alternativa.init.Main;
    import alternativa.osgi.service.mainContainer.IMainContainerService;
    import alternativa.tanks.model.shop.event.ShopItemChosen;
    import flash.events.Event;
    import alternativa.tanks.model.panel.PanelModel;
    import alternativa.tanks.model.panel.IPanel;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import alternativa.tanks.model.shop.items.promo.PromoCodeActivateForm;
    import alternativa.init.TanksServicesActivator;
    import flash.utils.setTimeout;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import alternativa.tanks.model.user.IUserData;
    import alternativa.tanks.model.user.UserData;
    import projects.tanks.client.panel.model.User;

    public class ShopModel
    {

        private var localeService:ILocaleService;
        private var dialogsService:DisplayObjectContainer;
        private var window:ShopWindow;

        public function init(json:Object):void
        {
            var category:Object;
            var items:Array;
            var item:Object;
            this.localeService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            this.dialogsService = ((Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer);
            ShopWindow.haveDoubleCrystalls = json.have_double_crystals;
            this.window = new ShopWindow();
            var data:Object = json.data;
            var lang:String = (Main.osgi.getService(ILocaleService) as ILocaleService).language;
            if (lang == null)
            {
                lang = "EN";
            }
            else
            {
                lang = lang.toUpperCase();
            }
            var categories:Array = data.categories;
            for each (category in categories)
            {
                this.window.addCategory(category.header_text[lang], category.description[lang], category.category_id);
            }
            items = data.items;
            for each (item in items)
            {
                // FIXME: hack, fix this on the server and move unique_id to additional_data
                item.additional_data.unique_id = item.unique_id;
                this.window.addItem(item.category_id, item.item_id, item.additional_data);
            }
            this.window.addEventListener(ShopItemChosen.EVENT_TYPE, this.onSelectItem);
            onResize();
        }
        private function onClose(e:Event):void
        {
            this.dialogsService.removeChild(this.window);
            this.window.removeEventListener(Event.CLOSE, this.onClose);
            Main.stage.removeEventListener(Event.RESIZE, this.onResize);
            PanelModel(Main.osgi.getService(IPanel)).closeShopWindow();
            this.window = null;
        }
        private function onResize(e:Event = null):void
        {
            this.window.x = Math.round(((Main.stage.stageWidth - 915) * 0.5));
            this.window.y = Math.round(((Main.stage.stageHeight - 691) * 0.5));
        }
        public function onEventWindow():void
        {
            this.window.addEventListener(Event.CLOSE, this.onClose);
            Main.stage.addEventListener(Event.RESIZE, this.onResize);
            this.dialogsService.addChild(this.window);
            this.onResize();
        }

        // FIXME: receive this from the gtanks server in order to update this on the fly FIXME:put link
        private static const BASE_PAYMENT_URL = "https://cybertankz.com"//"https://payment.primetanki.com/create-checkout-session";
        private function onSelectItem(e:ShopItemChosen):void
        {
            if (e.itemId != null)
            {
                var userData:UserData = Main.osgi.getService(IUserData) as UserData;
                var url:String = BASE_PAYMENT_URL + "?userid=" + userData.userId + "&itemId=" + e.itemId + "&username=" + userData.userName;
                var request:URLRequest = new URLRequest(url);
                // Open the link in the default browser
                navigateToURL(request, "_self");
            }
            else
            {
                this.window.addPromoActivator();
            }

        }

    }
}
