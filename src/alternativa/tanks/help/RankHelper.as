package alternativa.tanks.help
{
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;

    public class RankHelper extends BubbleHelper
    {

        public function RankHelper()
        {
            var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            text = localeService.getText(TextConst.HELP_PANEL_RANK_HELPER_TEXT);
            arrowLehgth = int(localeService.getText(TextConst.HELP_PANEL_RANK_HELPER_ARROW_LENGTH));
            arrowAlign = HelperAlign.TOP_LEFT;
            _showLimit = 3;
            _targetPoint.x = 29;
            _targetPoint.y = 42;
        }
    }
}
