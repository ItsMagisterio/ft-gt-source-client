package alternativa.tanks.model.shop
{
    import flash.display.Sprite;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
    import controls.base.LabelBase;
    import controls.TankWindowInner;

    public class ShowWindowHeader extends Sprite
    {

        public static var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);
        private static var crystalsImageClass:Class = ShowWindowHeader_crystalsImageClass;
        private static const crystalsImage:BitmapData = new crystalsImageClass().bitmapData;
        public static const WINDOW_MARGIN:int = 11;

        private var headerIcon:Bitmap;
        private var header:LabelBase;
        private var headerInner:TankWindowInner;
        private var doubleCrystallsHeader:LabelBase = new LabelBase();

        public function ShowWindowHeader()
        {
            this.headerInner = new TankWindowInner(0, 0, TankWindowInner.TRANSPARENT);
            addChild(this.headerInner);
            this.headerIcon = new Bitmap(crystalsImage);
            addChild(this.headerIcon);
            this.headerIcon.x = WINDOW_MARGIN;
            this.headerIcon.y = 5;
            this.header = new LabelBase();
            addChild(this.header);
            this.header.multiline = true;
            this.header.wordWrap = true;
            this.header.x = ((this.headerIcon.x + this.headerIcon.width) + WINDOW_MARGIN);
            this.header.htmlText = "Welcome to our store! Find cool stuff to upgrade your tank and express your style. By purchasing, you agree items will be credited to your account, and refunds are not allowed per our <u><font color='#59ff32'><a href=\"https://cybertankz.com/\">Terms and Conditions</a></font></u>.";
            if (ShopWindow.haveDoubleCrystalls)
            {
                this.doubleCrystallsHeader.multiline = true;
                this.doubleCrystallsHeader.wordWrap = true;
                this.doubleCrystallsHeader.x = ((this.headerIcon.x + this.headerIcon.width) + WINDOW_MARGIN);
                //this.doubleCrystallsHeader.htmlText = '<font color="#ffbe23" size="+5">We`ve simplified things by removing the double crystals card, ensuring you always get the best amount!</font>';
                this.doubleCrystallsHeader.bold = true;
                this.doubleCrystallsHeader.color = 16760355;
                addChild(this.doubleCrystallsHeader);
            }
        }
        public function resize(width:int):void
        {
            this.headerInner.width = width;
            this.headerInner.height = (this.headerIcon.height + ((!(!(ShopWindow.haveDoubleCrystalls))) ? 55 : 35));
            this.header.width = ((width - this.header.x) - WINDOW_MARGIN);
            this.header.y = (this.headerIcon.y + ((this.headerIcon.height - this.header.textHeight) >> 1));
            this.doubleCrystallsHeader.width = ((width - this.header.x) - WINDOW_MARGIN);
            this.doubleCrystallsHeader.y = (this.header.y + this.header.height);
        }
        override public function get height():Number
        {
            return (this.headerInner.height);
        }

    }
}
