package forms
{
    import flash.display.Sprite;
    import controls.statassets.BlackRoundRect;
    import assets.IconAlarm;
    import controls.Label;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import flash.text.TextFieldAutoSize;

    public class FocusWarningWindow extends Sprite
    {

        private var bg:BlackRoundRect = new BlackRoundRect();
        private var icon:IconAlarm = new IconAlarm();
        private var label:Label = new Label();
        public var PADDING:int = 30;

        public function FocusWarningWindow()
        {
            var localeService:ILocaleService;
            super();
            localeService = (Main.osgi.getService(ILocaleService) as ILocaleService);
            addChild(this.bg);
            addChild(this.icon);
            addChild(this.label);
            this.icon.x = -(int((this.icon.width / 2)));
            this.icon.y = (-(this.icon.height) - 15);
            this.label.size = 16;
            this.label.text = localeService.getText(TextConst.FOCUS_WARNIG_TEXT);
            this.label.autoSize = TextFieldAutoSize.CENTER;
            this.label.x = -(int((this.label.width / 2)));
            this.bg.width = (width + (this.PADDING * 2));
            this.bg.height = (height + (this.PADDING * 2));
            this.bg.x = -(int((this.bg.width / 2)));
            this.bg.y = (this.icon.y - (this.PADDING * 1.1));
        }
    }
}
