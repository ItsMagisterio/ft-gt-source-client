package forms.itemscategory.skin 
{
    import flash.display.Sprite;
    import controls.Label;
    import forms.garage.GarageButton;
    import flash.events.MouseEvent;
    import logic.networking.INetworker;
    import logic.networking.Network;
    import alternativa.init.Main;
    import alternativa.tanks.model.panel.PanelModel;
    import forms.Alert;
    import alternativa.tanks.model.panel.IPanel;
    import forms.events.AlertEvent;
    import alternativa.tanks.locale.constants.TextConst;
    import forms.AlertAnswer;
    import alternativa.osgi.service.locale.ILocaleService;
    import flash.display.Bitmap;

    public class SkinContainer extends Sprite{

		private var box:Sprite = new Sprite();
		private var skinNameLabel:Label = new Label();
		private var skinDescLabel:Label = new Label();
		private var getButton:GarageButton = new GarageButton();
		private var skinType:String;

		private var overlay:Sprite = new Sprite();

		[Embed(source="fr.png")]
		private static const gg:Class;

		[Embed(source="tx.png")]
		private static const gg1:Class;

		[Embed(source="lc.png")]
		private static const gg2:Class;

		[Embed(source="small.png")]
		private static const gg3:Class;

		public var iconToShow:Bitmap;

        public function SkinContainer(skinName:String, skinDescription:String, skinType:String, equip:Boolean, price:int, bought:Boolean) 
		{
			this.skinType = skinType;
			skinNameLabel.text = skinName;
			skinNameLabel.size = 18;
			skinNameLabel.color = 381208;
			skinNameLabel.multiline = true;
			skinNameLabel.wordWrap = true;
			skinNameLabel.width = 200;
			skinDescLabel.text = skinDescription;
			skinDescLabel.color = 381208;
			skinDescLabel.multiline = true;
			skinDescLabel.wordWrap = true;
			skinDescLabel.width = 170;

			skinNameLabel.x = 90;
			skinNameLabel.y = 15;
			skinDescLabel.x = 90;
			skinDescLabel.y = skinNameLabel.y + skinNameLabel.height + 15;

			box.addChild(getButton);
			box.addChild(skinNameLabel);
			box.addChild(skinDescLabel);

			box.graphics.clear();
			box.graphics.lineStyle(2, 0x5d8342);
			box.graphics.drawRoundRect(0,0,438, skinDescLabel.y + skinDescLabel.height + 20,6,6);

			getButton.x = 410 - getButton.width - 10;
			getButton.y = 50 - getButton.height / 2;

            addChild(box);
			overlay.graphics.clear();
			overlay.graphics.lineStyle(0, 0x5d8342);
			overlay.graphics.drawRoundRect(0,0,428, skinDescLabel.y + skinDescLabel.height + 24,6,6);
			overlay.alpha = 0;
			addChild(overlay);

			if(bought){
				if(equip){
					getButton.enable = false;
					getButton.label = "Equipped";
				}else{
					getButton.enable = true;
					getButton.label = "Equip";
					getButton.addEventListener(MouseEvent.CLICK, this.doEquip);
				}
			}else{
				if(price == 0){
					getButton.visible = false;
				}else{
					getButton.setInfo(price);
					getButton.label = "Buy";
					getButton.addEventListener(MouseEvent.CLICK, this.dfet);
				}
			}
			addIcon(skinType);
        }

		public function doEquip(e:MouseEvent):void
		{
			Network(Main.osgi.getService(INetworker)).send("garage;equip_skin;" + skinType);
		}

		public function dfet(e:MouseEvent = null):void{
		    var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
			var panelModel:PanelModel;
			panelModel = (Main.osgi.getService(IPanel) as PanelModel);
			var alert:Alert;
			alert = new Alert();
			alert.showAlert("Do you confirm the purchase?", [AlertAnswer.YES, AlertAnswer.NO]);
			Main.noticesLayer.addChild(alert);
			alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED, function(ae:AlertEvent):void
			{
				if (ae.typeButton == localeService.getText(TextConst.ALERT_ANSWER_YES))
				{
					confirmBuy();
				}
				else
				{

				}
			});
		}

		public function addIcon(skinIcon:String): void
		{
			if(skinIcon.indexOf("fr") >= 0){
				iconToShow = new gg();
			}else if(skinIcon.indexOf("lc") >= 0){
				iconToShow = new gg2();
			}else if(skinIcon.indexOf("tx") >= 0){
				iconToShow = new gg1();
			}else if(skinIcon.indexOf("tiny") >= 0){
				iconToShow = new gg3();
			}
			box.addChild(iconToShow);
			iconToShow.x = 10;
			iconToShow.y = 14;
		}
		
		public function confirmBuy(e:MouseEvent = null) : void 
		{
			Network(Main.osgi.getService(INetworker)).send("garage;buy_skin;" + skinType);
			getButton.removeEventListener(MouseEvent.CLICK, dfet);
		}
    }
}