package alternativa.tanks.help
{
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;

    public class StoreListHelper extends BubbleHelper
    {

        public function StoreListHelper()
        {
            var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            text = localeService.getText(TextConst.HELP_GARAGE_STORE_LIST_HELPER_TEXT);
            arrowLehgth = int(localeService.getText(TextConst.HELP_GARAGE_STORE_LIST_HELPER_ARROW_LENGTH));
            arrowAlign = HelperAlign.MIDDLE_RIGHT;
            _showLimit = 3;
        }
    }
}
