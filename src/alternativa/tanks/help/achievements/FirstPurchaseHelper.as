﻿package alternativa.tanks.help.achievements
{
    import alternativa.tanks.help.BubbleHelper;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import alternativa.tanks.help.HelperAlign;

    public class FirstPurchaseHelper extends BubbleHelper
    {

        public function FirstPurchaseHelper()
        {
            var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            text = localeService.getText(TextConst.HELP_FIRST_PURCHASE_HELPER_TEXT);
            arrowLehgth = int(localeService.getText(TextConst.HELP_FIRST_PURCHASE_HELPER_ARROW_LENGTH));
            arrowAlign = HelperAlign.TOP_LEFT;
            _showLimit = 100;
        }
    }
}
