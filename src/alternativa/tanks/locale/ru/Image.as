package alternativa.tanks.locale.ru
{
    import flash.display.BitmapData;
    import alternativa.tanks.locale.constants.ImageConst;
    import alternativa.osgi.service.locale.ILocaleService;

    public class Image
    {

        private static const bitmapReferalHeader:Class = Image_bitmapReferalHeader;
        public static const REFERAL_WINDOW_HEADER_IMAGE:BitmapData = new bitmapReferalHeader().bitmapData;
        private static const bitmapAbon:Class = Image_bitmapAbon;
        private static const CONGRATULATION_WINDOW_TICKET_IMAGE:BitmapData = new bitmapAbon().bitmapData;

        public static function init(localeService:ILocaleService):void
        {
            localeService.registerImage(ImageConst.REFERAL_WINDOW_HEADER_IMAGE, Image.REFERAL_WINDOW_HEADER_IMAGE);
            localeService.registerImage(ImageConst.CONGRATULATION_WINDOW_TICKET_IMAGE, Image.CONGRATULATION_WINDOW_TICKET_IMAGE);
        }

    }
}
