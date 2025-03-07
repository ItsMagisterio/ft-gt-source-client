﻿package controls
{
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;

    public class Rank
    {

        public static var ranks:Array;

        public static function name(value:int):String
        {
            var localeService:ILocaleService;
            var rankString:String;
            if (ranks == null)
            {
                localeService = (Main.osgi.getService(ILocaleService) as ILocaleService);
                rankString = localeService.getText(TextConst.RANK_NAMES);
                ranks = rankString.split(",");
            }
            return (ranks[(value - 1)]);
        }

    }
}
