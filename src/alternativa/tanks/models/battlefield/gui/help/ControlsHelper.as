package alternativa.tanks.models.battlefield.gui.help
{
    import alternativa.tanks.help.Helper;
    import assets.icons.HelpWindow;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;

    public class ControlsHelper extends Helper
    {

        public static const GROUP_ID:String = "Tank.ControlsHelper";
        public static const HELPER_ID:int = 1;

        private var helpWindow:HelpWindow;

        public function ControlsHelper()
        {
            this.init();
        }
        override public function align(stageWidth:int, stageHeight:int):void
        {
            this.helpWindow.x = ((stageWidth - this.helpWindow.width) / 2);
            this.helpWindow.y = ((stageHeight - this.helpWindow.height) / 2);
        }
        private function init():void
        {
            var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            this.helpWindow = new HelpWindow(localeService.getText(TextConst.GUI_LANG));
            this.helpWindow.mouseEnabled = false;
            addChild(this.helpWindow);
            _showLimit = 10;
        }

    }
}
