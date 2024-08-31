package alternativa.tanks.model.tempdiscount
{
    import flash.display.Sprite;
    import alternativa.model.IResourceLoadListener;
    import flash.display.BitmapData;
    import forms.TankWindowWithHeader;
    import controls.TankWindowInner;
    import controls.Label;
    import assets.icons.GarageItemBackground;
    import flash.display.Bitmap;
    import controls.DefaultButton;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import logic.resource.images.ImageResource;
    import flash.text.TextFormatAlign;
    import flash.text.TextFieldAutoSize;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import alternativa.types.Long;

    public class TempDiscountWindow extends Sprite implements IResourceLoadListener
    {

        private static var _discountImage:Class = TempDiscountWindow__discountImage;
        private static var discountBitmap:BitmapData = new _discountImage().bitmapData;

        private var window:TankWindowWithHeader = TankWindowWithHeader.createWindow("СКИДКА");
        private var innerWindow:TankWindowInner = new TankWindowInner(0, 0, TankWindowInner.GREEN);
        private var congratsText:Label = new Label();
        private var panel:GarageItemBackground;
        private var preview:Bitmap;
        private var discount:String;
        public var closeBtn:DefaultButton = new DefaultButton();
        public var windowWidth:*;
        public var windowHeight:*;

        public function TempDiscountWindow(congrats:String, itemId:String, disc:String)
        {
            var discountLabel:Bitmap;
            var label:Label;
            super();
            this.window.width = 350;
            this.windowWidth = 350;
            this.window.height = 280;
            this.windowHeight = 280;
            addChild(this.window);
            this.innerWindow.width = (this.window.width - 30);
            this.innerWindow.height = (this.window.height - 65);
            this.innerWindow.x = 15;
            this.innerWindow.y = 15;
            addChild(this.innerWindow);
            this.congratsText.color = 5898034;
            this.congratsText.text = congrats;
            this.congratsText.x = ((this.innerWindow.width / 2) - (this.congratsText.width / 2));
            this.congratsText.y = 10;
            this.innerWindow.addChild(this.congratsText);
            this.panel = new GarageItemBackground(GarageItemBackground.ENGINE_NORMAL);
            this.panel.x = ((this.innerWindow.width / 2) - (this.panel.width / 2));
            this.panel.y = ((this.congratsText.y + this.congratsText.height) + 10);
            this.innerWindow.addChild(this.panel);
            this.discount = disc;
            var imageResource:ImageResource = (ResourceUtil.getResource(ResourceType.IMAGE, (itemId + "_preview")) as ImageResource).clone();
            if (imageResource != null)
            {
                if (imageResource.loaded())
                {
                    this.preview = new Bitmap((imageResource.bitmapData as BitmapData));
                    this.preview.x = ((this.panel.width / 2) - (this.preview.width / 2));
                    this.preview.y = ((this.panel.height / 2) - (this.preview.height / 2));
                    this.panel.addChild(this.preview);
                    discountLabel = new Bitmap(discountBitmap);
                    discountLabel.x = 0;
                    discountLabel.y = (this.panel.height - discountLabel.height);
                    this.panel.addChild(discountLabel);
                    label = new Label();
                    label.color = 0xFFFFFF;
                    label.align = TextFormatAlign.LEFT;
                    label.text = (("-" + this.discount) + "%");
                    label.height = 35;
                    label.width = 100;
                    label.thickness = 0;
                    label.autoSize = TextFieldAutoSize.NONE;
                    label.size = 16;
                    label.x = 10;
                    label.y = 90;
                    label.rotation = 45;
                    this.panel.addChild(label);
                }
                else
                {
                    if (((!(imageResource == null)) && (!(imageResource.loaded()))))
                    {
                        imageResource.completeLoadListener = this;
                        imageResource.load();
                    }
                }
            }
            this.closeBtn.x = ((this.window.width - this.closeBtn.width) - 15);
            this.closeBtn.y = ((this.window.height - this.closeBtn.height) - 15);
            this.closeBtn.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
            addChild(this.closeBtn);
        }
        public function resourceLoaded(resource:Object):void
        {
            this.preview = new Bitmap(((resource as ImageResource).bitmapData as BitmapData));
            this.preview.x = ((this.panel.width / 2) - (this.preview.width / 2));
            this.preview.y = ((this.panel.height / 2) - (this.preview.height / 2));
            this.panel.addChild(this.preview);
            var discountLabel:Bitmap = new Bitmap(discountBitmap);
            discountLabel.x = 0;
            discountLabel.y = (this.panel.height - discountLabel.height);
            this.panel.addChild(discountLabel);
            var label:Label = new Label();
            label.color = 0xFFFFFF;
            label.align = TextFormatAlign.LEFT;
            label.text = (("-" + this.discount) + "%");
            label.height = 35;
            label.width = 100;
            label.thickness = 0;
            label.autoSize = TextFieldAutoSize.NONE;
            label.size = 16;
            label.x = 10;
            label.y = 90;
            label.rotation = 45;
            this.panel.addChild(label);
        }
        public function resourceUnloaded(resource:Long):void
        {
        }

    }
}
