package alternativa.tanks.help.achievements
{
    import alternativa.tanks.help.BubbleHelper;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import alternativa.tanks.help.HelperAlign;

    public class SetEmailHelper extends BubbleHelper
    {

        public function SetEmailHelper()
        {
            var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            text = localeService.getText(TextConst.HELP_SET_EMAIL_HELPER_TEXT);
            arrowLehgth = int(localeService.getText(TextConst.HELP_SET_EMAIL_HELPER_ARROW_LENGTH));
            arrowAlign = HelperAlign.TOP_RIGHT;
            _showLimit = 100;
        }
    }
}
