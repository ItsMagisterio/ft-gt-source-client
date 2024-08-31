package alternativa.tanks.model.profile
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import alternativa.osgi.service.locale.ILocaleService;
    import alternativa.tanks.model.challenge.greenpanel.GreenPanel;
    import controls.rangicons.RangIconSmall;
    import controls.Label;
    import forms.buttons.MainPanelGoldenButton;
    import alternativa.init.Main;
    import alternativa.tanks.locale.constants.TextConst;
    import flash.events.MouseEvent;
    import logic.networking.Network;
    import logic.networking.INetworker;

    public class GiftUserInfo extends Sprite
    {

        private static const emeraldBitmap:Class = GiftUserInfo_emeraldBitmap;
        private static const spinsBitmap:Class = GiftUserInfo_spinsBitmap;
        private static const incomingBitmap:Class = GiftUserInfo_incomingBitmap;
        private static const outcomingBitmap:Class = GiftUserInfo_outcomingBitmap;

        private var emerald:Bitmap = new Bitmap(new emeraldBitmap().bitmapData);
        private var spin:Bitmap = new Bitmap(new spinsBitmap().bitmapData);
        private var incoming:Bitmap = new Bitmap(new incomingBitmap().bitmapData);
        private var outcoming:Bitmap = new Bitmap(new outcomingBitmap().bitmapData);
        private var localeService:ILocaleService;
        private var panel:GreenPanel = new GreenPanel(160, 210);
        private var rankIcon:RangIconSmall;
        private var userName:Label;
        private var spinLabel:Label;
        private var emeraldLabel:Label;
        private var incomingGiftsLabel:Label;
        private var outcomingGiftsLabel:Label;
        private var button:MainPanelGoldenButton = new MainPanelGoldenButton();

        public function GiftUserInfo(userId:String, rank:int, spins:int, emeralds:int, incomingGifts:int, outcomingGifts:int)
        {
            super();
            this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
            addChild(this.panel);
            this.rankIcon = new RangIconSmall(rank);
            this.rankIcon.mouseEnabled = false;
            this.rankIcon.x = 10;
            this.rankIcon.y = 10;
            this.panel.addChild(this.rankIcon);
            this.userName = new Label();
            this.userName.color = 5898034;
            this.userName.text = userId;
            this.userName.x = ((this.rankIcon.x + this.rankIcon.width) + 3);
            this.userName.y = (this.rankIcon.y + ((this.rankIcon.height / 2) - (this.userName.height / 2)));
            this.panel.addChild(this.userName);
            this.spin.x = this.rankIcon.x;
            this.spin.y = ((this.rankIcon.y + this.rankIcon.height) + 10);
            this.panel.addChild(this.spin);
            this.emerald.x = this.rankIcon.x;
            this.emerald.y = ((this.spin.y + this.spin.height) + 10);
            this.panel.addChild(this.emerald);
            this.spinLabel = new Label();
            this.spinLabel.size = 18;
            this.spinLabel.text = spins.toString();
            this.spinLabel.x = ((this.spin.x + this.spin.width) + 5);
            this.spinLabel.y = (this.spin.y + ((this.spin.height / 2) - (this.spinLabel.height / 2)));
            this.panel.addChild(this.spinLabel);
            this.emeraldLabel = new Label();
            this.emeraldLabel.size = 18;
            this.emeraldLabel.text = emeralds.toString();
            this.emeraldLabel.x = ((this.emerald.x + this.emerald.width) + 5);
            this.emeraldLabel.y = (this.emerald.y + ((this.emerald.height / 2) - (this.emeraldLabel.height / 2)));
            this.panel.addChild(this.emeraldLabel);
            this.incoming.x = this.rankIcon.x;
            this.incoming.y = ((this.emerald.y + this.emerald.height) + 10);
            this.panel.addChild(this.incoming);
            this.outcoming.x = this.rankIcon.x;
            this.outcoming.y = ((this.incoming.y + this.incoming.height) + 10);
            this.panel.addChild(this.outcoming);
            this.incomingGiftsLabel = new Label();
            this.incomingGiftsLabel.size = 18;
            this.incomingGiftsLabel.text = incomingGifts.toString();
            this.incomingGiftsLabel.x = ((this.incoming.x + this.incoming.width) + 5);
            this.incomingGiftsLabel.y = (this.incoming.y + ((this.incoming.height / 2) - (this.incomingGiftsLabel.height / 2)));
            this.panel.addChild(this.incomingGiftsLabel);
            this.outcomingGiftsLabel = new Label();
            this.outcomingGiftsLabel.size = 18;
            this.outcomingGiftsLabel.text = outcomingGifts.toString();
            this.outcomingGiftsLabel.x = ((this.outcoming.x + this.outcoming.width) + 5);
            this.outcomingGiftsLabel.y = (this.outcoming.y + ((this.outcoming.height / 2) - (this.outcomingGiftsLabel.height / 2)));
            this.panel.addChild(this.outcomingGiftsLabel);
            this.button.label = this.localeService.getText(TextConst.PROFILE_WINDOW_SEND_GIFT_TEXT);
            this.button.x = ((this.panel.width / 2) - (this.button.width / 2));
            this.button.y = ((this.panel.height - this.button.height) - 5);
            this.button.addEventListener(MouseEvent.CLICK, function(e:MouseEvent = null):void
                {
                    Network(Main.osgi.getService(INetworker)).send("lobby;get_spins_url");
                });
            this.panel.addChild(this.button);
        }
    }
}
