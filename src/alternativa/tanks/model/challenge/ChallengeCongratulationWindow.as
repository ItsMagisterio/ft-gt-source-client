package alternativa.tanks.model.challenge
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import forms.TankWindowWithHeader;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import controls.TankWindowInner;
    import controls.Label;
    import controls.DefaultButton;
    import assets.icons.GarageItemBackground;
    import flash.display.BitmapData;

    public class ChallengeCongratulationWindow extends Sprite
    {

        private static const congratsBitmap:Class = ChallengeCongratulationWindow_congratsBitmap;
        private static const healthBitmap:Class = ChallengeCongratulationWindow_healthBitmap;
        private static const armorBitmap:Class = ChallengeCongratulationWindow_armorBitmap;
        private static const damageBitmap:Class = ChallengeCongratulationWindow_damageBitmap;
        private static const n2oBitmap:Class = ChallengeCongratulationWindow_n2oBitmap;
        private static const mineBitmap:Class = ChallengeCongratulationWindow_mineBitmap;
        private static const cryBitmap:Class = ChallengeCongratulationWindow_cryBitmap;
        private static const flowBitmap:Class = ChallengeCongratulationWindow_flowBitmap;
        private static const impulseBitmap:Class = ChallengeCongratulationWindow_impulseBitmap;
        private static const white_khokhlomaBitmap:Class = ChallengeCongratulationWindow_white_khokhlomaBitmap;
        private static const floraBitmap:Class = ChallengeCongratulationWindow_floraBitmap;
        private static const foresterBitmap:Class = ChallengeCongratulationWindow_foresterBitmap;
        private static const lavaBitmap:Class = ChallengeCongratulationWindow_lavaBitmap;
        private static const leadBitmap:Class = ChallengeCongratulationWindow_leadBitmap;
        private static const marineBitmap:Class = ChallengeCongratulationWindow_marineBitmap;
        private static const marshBitmap:Class = ChallengeCongratulationWindow_marshBitmap;
        private static const metallicBitmap:Class = ChallengeCongratulationWindow_metallicBitmap;
        private static const safariBitmap:Class = ChallengeCongratulationWindow_safariBitmap;
        private static const stormBitmap:Class = ChallengeCongratulationWindow_stormBitmap;
        private static const maryBitmap:Class = ChallengeCongratulationWindow_maryBitmap;

        private var bitmap:Bitmap = new Bitmap(new congratsBitmap().bitmapData);
        private var window:TankWindowWithHeader = TankWindowWithHeader.createWindow(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.CONGRATS_WINDOW_TEXT));
        private var innerWindow:TankWindowInner = new TankWindowInner(0, 0, TankWindowInner.GREEN);
        private var congratsText:Label = new Label();
        public var closeBtn:DefaultButton = new DefaultButton();
        public var windowWidth:*;
        public var windowHeight:*;

        public function ChallengeCongratulationWindow(prizes:Array)
        {
            this.window.width = 460;
            this.windowWidth = 460;
            this.window.height = 405;
            this.windowHeight = 405;
            addChild(this.window);
            this.innerWindow.width = (this.window.width - 30);
            this.innerWindow.height = (this.window.height - 65);
            this.innerWindow.x = 15;
            this.innerWindow.y = 15;
            addChild(this.innerWindow);
            this.bitmap.x = ((this.innerWindow.width / 2) - (this.bitmap.width / 2));
            this.bitmap.y = 5;
            this.innerWindow.addChild(this.bitmap);
            this.congratsText.color = 5898034;
            this.congratsText.text = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.CONGRATS_WINDOW_CONGRATS_TEXT);
            this.congratsText.x = 5;
            this.congratsText.y = (this.bitmap.height + 10);
            this.innerWindow.addChild(this.congratsText);
            this.closeBtn.x = ((this.window.width - this.closeBtn.width) - 15);
            this.closeBtn.y = ((this.window.height - this.closeBtn.height) - 15);
            this.closeBtn.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
            addChild(this.closeBtn);
            this.setPrizes(prizes);
        }
        private function setPrizes(prizes:Array):void
        {
            var prize:ChallengePrizeInfo;
            var panel:GarageItemBackground;
            var previewBd:BitmapData;
            var preview:Bitmap;
            var numLabel:Label;
            var i:int;
            for each (prize in prizes)
            {
                panel = new GarageItemBackground(GarageItemBackground.ENGINE_NORMAL);
                panel.x = ((prizes.length < 2) ? ((this.innerWindow.width / 2) - (panel.width / 2)) : (i + 10));
                panel.y = ((this.congratsText.y + this.congratsText.height) + 10);
                this.innerWindow.addChild(panel);
                previewBd = this.getBitmap(prize.nameId);
                preview = new Bitmap(previewBd);
                preview.x = ((panel.width / 2) - (preview.width / 2));
                preview.y = ((panel.height / 2) - (preview.height / 2));
                panel.addChild(preview);
                numLabel = new Label();
                panel.addChild(numLabel);
                numLabel.size = 16;
                numLabel.color = 5898034;
                numLabel.text = ("×" + prize.count);
                numLabel.x = ((panel.width - numLabel.width) - 15);
                numLabel.y = ((panel.height - numLabel.height) - 10);
                i = (i + (panel.width + 10));
            }
        }
        private function getBitmap(id:String):BitmapData
        {
            switch (id)
            {
                case "health_m0":
                    return (new healthBitmap().bitmapData);
                case "armor_m0":
                    return (new armorBitmap().bitmapData);
                case "double_damage_m0":
                    return (new damageBitmap().bitmapData);
                case "n2o_m0":
                    return (new n2oBitmap().bitmapData);
                case "mine_m0":
                    return (new mineBitmap().bitmapData);
                case "crystalls_m0":
                    return (new cryBitmap().bitmapData);
                case "flow_m0":
                    return (new flowBitmap().bitmapData);
                case "storm_m0":
                    return (new stormBitmap().bitmapData);
                case "mary_m0":
                    return (new maryBitmap().bitmapData);
                case "safari_m0":
                    return (new safariBitmap().bitmapData);
                case "lead_m0":
                    return (new leadBitmap().bitmapData);
                case "lava_m0":
                    return (new lavaBitmap().bitmapData);
                case "metallic_m0":
                    return (new metallicBitmap().bitmapData);
                case "forester_m0":
                    return (new foresterBitmap().bitmapData);
                case "marsh_m0":
                    return (new marshBitmap().bitmapData);
                case "marine_m0":
                    return (new marineBitmap().bitmapData);
                case "flora_m0":
                    return (new floraBitmap().bitmapData);
                case "impulse_m0":
                    return (new impulseBitmap().bitmapData);
                case "white_khokhloma_m0":
                    return (new white_khokhlomaBitmap().bitmapData);
            }
            return (new cryBitmap().bitmapData);
        }

    }
}
