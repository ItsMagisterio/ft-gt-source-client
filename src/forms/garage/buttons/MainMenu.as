package forms.garage.buttons
{
    import flash.display.Sprite;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;

    public class MainMenu extends Sprite
    {

        [Inject]
        public static var localeService:ILocaleService = (Main.osgi.getService(ILocaleService) as ILocaleService);

        public var turrets:Turrets = new Turrets(localeService.getText(TextConst.GARAGE_PANEL_TURRETS_TEXT));
        public var hulls:Hulls = new Hulls(localeService.getText(TextConst.GARAGE_PANEL_HULLS_TEXT));
        public var colormaps:Colormaps = new Colormaps(localeService.getText(TextConst.GARAGE_PANEL_COLORMAPS_TEXT));
        public var inventory:Inventory = new Inventory(localeService.getText(TextConst.GARAGE_PANEL_INVENTORY_TEXT));
        public var kits:Kits = new Kits(localeService.getText(TextConst.GARAGE_PANEL_KITS_TEXT));

        public function MainMenu()
        {
            this.turrets.width = (this.turrets.width - 7);
            this.hulls.width = (this.hulls.width - 7);
            this.colormaps.width = (this.colormaps.width - 7);
            this.inventory.width = (this.inventory.width - 7);
            this.kits.width = (this.kits.width - 7);
            super();
            addChild(this.turrets);
            addChild(this.hulls);
            this.hulls.x = (this.turrets.width + 5);
            addChild(this.colormaps);
            this.colormaps.x = ((this.hulls.x + this.hulls.width) + 5);
            addChild(this.inventory);
            this.inventory.x = ((this.colormaps.x + this.colormaps.width) + 5);
            addChild(this.kits);
            this.kits.x = ((this.inventory.x + this.inventory.width) + 5);
        }
    }
}
