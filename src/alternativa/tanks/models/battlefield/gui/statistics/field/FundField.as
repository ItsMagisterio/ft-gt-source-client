package alternativa.tanks.models.battlefield.gui.statistics.field
{
    import assets.Diamond;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import controls.Money;

    public class FundField extends IconField
    {

        private var diamond:Diamond = new Diamond();

        public function FundField(iconType:int)
        {
            super(iconType);
        }
        override protected function init():void
        {
            super.init();
            addChild(this.diamond);
            this.diamond.y = 4;
            this.update();
        }
        public function initFund(fund:int):void
        {
            var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
            var caption:String = localeService.getText(TextConst.BATTLE_FUND);
            label.text = ((caption + ": ") + Money.numToString(fund, false));
            this.update();
        }
        private function update():void
        {
            this.diamond.x = ((label.x + label.width) + 2);
        }

    }
}
