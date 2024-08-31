package alternativa.tanks.model.news
{
    import flash.display.BitmapData;

    public class NewsIcons
    {

        private static const crystalls_box:Class = NewsIcons_crystalls_box;
        private static const crystalls_book:Class = NewsIcons_crystalls_book;
        private static const fev_14:Class = NewsIcons_fev_14;
        private static const crystall:Class = NewsIcons_crystall;
        private static const magazine:Class = NewsIcons_magazine;
        private static const hand_crystalls:Class = NewsIcons_hand_crystalls;
        private static const happy_birthday:Class = NewsIcons_happy_birthday;
        private static const helm_space:Class = NewsIcons_helm_space;
        private static const news_lamp:Class = NewsIcons_news_lamp;
        private static const no_cheats:Class = NewsIcons_no_cheats;
        private static const shaft:Class = NewsIcons_shaft;
        private static const shaft_secret:Class = NewsIcons_shaft_secret;
        private static const sale_20:Class = NewsIcons_sale_20;
        private static const shaft_targeting:Class = NewsIcons_shaft_targeting;
        private static const technical:Class = NewsIcons_technical;
        private static const fight:Class = NewsIcons_fight;
        private static const update:Class = NewsIcons_update;
        private static const ml5:Class = NewsIcons_ml5;
        private static const _8march:Class = NewsIcons__8march;
        private static var instance:NewsIcons = new (NewsIcons)();
        private static var Y:int = 100;

        private var crystalls_box_bd:BitmapData = new crystalls_box().bitmapData;
        private var crystalls_book_bd:BitmapData = new crystalls_book().bitmapData;
        private var fev_14_bd:BitmapData = new fev_14().bitmapData;
        private var crystall_bd:BitmapData = new crystall().bitmapData;
        private var magazine_bd:BitmapData = new magazine().bitmapData;
        private var hand_crystalls_bd:BitmapData = new hand_crystalls().bitmapData;
        private var happy_birthday_bd:BitmapData = new happy_birthday().bitmapData;
        private var helm_space_bd:BitmapData = new helm_space().bitmapData;
        private var news_lamp_bd:BitmapData = new news_lamp().bitmapData;
        private var no_cheats_bd:BitmapData = new no_cheats().bitmapData;
        private var shaft_bd:BitmapData = new shaft().bitmapData;
        private var shaft_secret_bd:BitmapData = new shaft_secret().bitmapData;
        private var sale_20_bd:BitmapData = new sale_20().bitmapData;
        private var shaft_targeting_bd:BitmapData = new shaft_targeting().bitmapData;
        private var technical_bd:BitmapData = new technical().bitmapData;
        private var fight_bd:BitmapData = new fight().bitmapData;
        private var update_bd:BitmapData = new update().bitmapData;
        private var ml5_bd:BitmapData = new ml5().bitmapData;
        private var _8_march_bd:BitmapData = new _8march().bitmapData;

        public static function getIcon(id:String):BitmapData
        {
            var bitmapData:BitmapData = instance.update_bd;
            try
            {
                bitmapData = instance[(id + "_bd")];
            }
            catch (e:Error)
            {
                bitmapData = instance.fight_bd;
            }
            return (bitmapData);
        }

    }
}
