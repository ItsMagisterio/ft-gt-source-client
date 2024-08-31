package forms.itemscategory.skin 
{
	import alternativa.engine3d.core.View;
	import alternativa.init.Main;
	import alternativa.osgi.service.loader.ILoaderService;
	import alternativa.osgi.service.locale.ILocaleService;
	import forms.garage.ItemInfoPanel;
	import forms.garage.ItemPropertyIcon;
	import alternativa.tanks.locale.constants.TextConst;
	import alternativa.tanks.model.panel.IPanel;
	import alternativa.tanks.model.panel.PanelModel;
	import assets.icons.GarageItemBackground;
	import controls.Label;
	import controls.TankInput;
	import controls.TankWindowInner;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import forms.ColorConstants;
	import forms.TankWindowWithHeader;
	import forms.garage.GarageButton;
	import logic.networking.Network;
	import logic.networking.INetworker;
	import forms.garage.SkinButton;
	import flash.globalization.StringTools;
	import alternativa.tanks.gui.ItemInfoPanel;
	import forms.itemscategory.Ski;
	import alternativa.tanks.service.upgradingitems.ItemInfo;
	import alternativa.tanks.model.ItemParams;
	import alternativa.tanks.model.GarageModel;
	import alternativa.tanks.model.IGarage;
	import forms.events.AlertEvent;
	import forms.AlertAnswer;
	import forms.Alert;
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
    import assets.scroller.color.ScrollTrackGreen;
    import assets.scroller.color.ScrollThumbSkinGreen;
    import flash.utils.Dictionary;

	
	public class Skin extends Sprite
	{
		
		private var windowSize:Point = new Point(496, 492);
		private const windowMargin:int = 12;
		public var window:TankWindowWithHeader = TankWindowWithHeader.createWindow("ALTERATIONS");
		private var windowInput:TankWindowInner = new TankWindowInner(1, 1, TankWindowInner.GREEN);

		private var scrollContainer:Sprite = new Sprite();
		private var scrollPane:ScrollPane = new ScrollPane();
		private var closeButton:SkButton = new SkButton();
		
		private var i1:Sprite = new Sprite();
		private var sh:Boolean = false;
		
		private var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
		
		private var gar:Sprite = new Sprite();
		private var lab:Label = new Label();
		private var lab1:Label = new Label();
		private var defaultSkinEquip:GarageButton = new GarageButton();
		
		private var gar1:Sprite = new Sprite();
		private var lab2:Label = new Label();
		private var lab3:Label = new Label();
		private var xtSkinEquip:GarageButton = new GarageButton();
		
		private var id:String;

		[Embed(source="xt.png")]
		private static const gg:Class;
		public var xt:Bitmap = new gg();

		[Embed(source="sk.png")]
		private static const gg1:Class;
		public var sk:Bitmap = new gg1();
      
        public var skinequip:int = 0;
		private var extraSkinCount:int = 0;

		private var skins:Dictionary = new Dictionary();
		
		public function Skin() 
		{
			super();
			configureContainer(gar);
			configureContainer(gar1);
		}

		public function parseSkin(skinType:SkinType) : void
		{
			extraSkinCount++;
			addSkinContainer(skinType.getName(), skinType.getDescription(), skinType.getSkinType(), skinType.getEquipped(), skinType.getPrice(), skinType.getPurchased());
		}

		public function addSkinContainer(skinName:String, skinDescription:String, skinType:String, equipped:Boolean, price:int, bought:Boolean):void{
			var skinContainerExtra:SkinContainer = new SkinContainer(skinName, skinDescription, skinType, equipped, price, bought);
			skins[extraSkinCount] = skinContainerExtra;
		}

		public function reconfigureSkins(firstLoad:Boolean = true):void{
			for each(var skinContainer:SkinContainer in skins){
				if(!scrollContainer.contains(skinContainer)){
					skinContainer.y = scrollContainer.height + (firstLoad ? 20 : 40);
					scrollContainer.addChild(skinContainer);
					scrollPane.update();
				}
			}
		}

		private function saveData(n:String,d:String,i3:String): void
		{
			nString = n;
			dString = d;
			i3String = i3;
			id = i3;
		}

		private var nString:String;
		private var dString:String;
		private var i3String:String;
		
		public function init(n:String,d:String,i3:String) : void 
		{
			this.saveData(n,d,i3);
			var firstLoad:Boolean = n == nString;

			this.window.visible = false;
			this.i1.visible = false;
			this.configWindow();

			xtSkinEquip.label = "Buy";
			closeButton.label = "Close";
			i1.addChild(closeButton);

			addStandardSettings();
			addXTSettings();

			resize();

			reconfigureSkins(firstLoad);
		}

		private function configWindow():void{
			this.addChild(this.window);
			this.addChild(i1);
			i1.addChild(windowInput);
			
			this.confScroll();
            this.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
            this.scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
            this.scrollPane.source = scrollContainer;
            this.scrollPane.focusEnabled = false;
			i1.addChild(scrollPane);
		}

		private function addStandardSettings() : void
		{
			lab.text = "Standard settings";
			lab.size = 18;
			lab.color = 381208;
			lab1.text = "Standard factory settings without any special effects";
			lab1.color = 381208;
			lab1.multiline = true;
			lab1.wordWrap = true;
			lab1.width = 170;

			scrollContainer.addChild(gar);
			gar.addChild(defaultSkinEquip);
			gar.addChild(lab);
			gar.addChild(lab1);

			gar.addChild(this.sk);
		}

		private function addXTSettings() : void
		{
			lab2.text = nString;
			lab2.size = 18;
			lab2.color = 381208;
			lab2.multiline = true;
			lab2.wordWrap = true;
			lab2.width = 180;
			lab3.text = dString;
			lab3.color = 381208;
			lab3.multiline = true;
			lab3.wordWrap = true;
			lab3.width = 170;

			scrollContainer.addChild(gar1);
			gar1.addChild(xtSkinEquip);
			gar1.addChild(lab2);
			gar1.addChild(lab3);

			gar1.addChild(this.xt);
		}

        private function confScroll():void{
            this.scrollPane.setStyle("downArrowUpSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("downArrowDownSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("downArrowOverSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("downArrowDisabledSkin", ScrollArrowDownGreen);
            this.scrollPane.setStyle("upArrowUpSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("upArrowDownSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("upArrowOverSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("upArrowDisabledSkin", ScrollArrowUpGreen);
            this.scrollPane.setStyle("trackUpSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("trackDownSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("trackOverSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("trackDisabledSkin", ScrollTrackGreen);
            this.scrollPane.setStyle("thumbUpSkin", ScrollThumbSkinGreen);
            this.scrollPane.setStyle("thumbDownSkin", ScrollThumbSkinGreen);
            this.scrollPane.setStyle("thumbOverSkin", ScrollThumbSkinGreen);
            this.scrollPane.setStyle("thumbDisabledSkin", ScrollThumbSkinGreen);
        }

		private function configureContainer(boxContainer:Sprite):void{
			boxContainer.graphics.clear();
			boxContainer.graphics.lineStyle(2, 0x59ff31);
			boxContainer.graphics.drawRoundRect(0, 0, 200, 100, 6, 6);
		}
		
		public function configXT(cost:int,equipped:Boolean,bought:Boolean) : void 
		{
			if(bought){
				if(equipped){
					this.xtSkinEquip.label = "Equipped";
			 		this.xtSkinEquip.ena();
				}else{
					this.xtSkinEquip.label = "Equip";
			 		this.xtSkinEquip.enable = true;
					this.xtSkinEquip.addEventListener(MouseEvent.CLICK, equipXT);
				}
			}else{
				this.xtSkinEquip.label = "Buy";
				if(cost == 0){
					this.xtSkinEquip.visible = false;
				}else{
					this.xtSkinEquip.setInfo(cost);
					if (PanelModel(Main.osgi.getService(IPanel)).crystal<cost){
						this.xtSkinEquip.ena();
						this.xtSkinEquip.setInfo(-cost);
					}else{
						this.xtSkinEquip.enable = true;
						this.xtSkinEquip.addEventListener(MouseEvent.CLICK, dfet);
					}
				}
			}
			resize();
		}

		public function configDefault(equipped:Boolean) : void
		{
			if(equipped){
				this.defaultSkinEquip.label = "Equipped";
				this.defaultSkinEquip.ena();
			}else{
				this.defaultSkinEquip.label = "Equip";
				this.defaultSkinEquip.enable = true;
				this.defaultSkinEquip.addEventListener(MouseEvent.CLICK, this.equipDefault)
			}
		}
		
		public function show() : void 
		{
			if (!sh)
			{
				this.window.visible = true;
				i1.visible = true;
				sh = true;
				Main.stage.addEventListener(Event.RESIZE, resize);
				closeButton.addEventListener(MouseEvent.CLICK, hide);
			}
		}

		public function equipDefault(e:MouseEvent = null) : void
		{
			var isSkinEquippable:String = ItemInfoPanel.instance.buttonEquip.enable ? "false" : "true";
			Network(Main.osgi.getService(INetworker)).send("garage;unequip_skin;" + id.split("_")[0] + ";" + isSkinEquippable);
			this.defaultSkinEquip.removeEventListener(MouseEvent.CLICK, this.equipDefault);
		}
		
		public function equipXT(e:MouseEvent = null) : void 
		{
			var isSkinEquippable:String = ItemInfoPanel.instance.buttonEquip.enable ? "false" : "true";
			Network(Main.osgi.getService(INetworker)).send("garage;equip_skin;" + id + ";" + isSkinEquippable);
			this.xtSkinEquip.removeEventListener(MouseEvent.CLICK, equipXT);
		}

		public function dfet(e:MouseEvent = null):void{
			var panelModel:PanelModel;
			panelModel = (Main.osgi.getService(IPanel) as PanelModel);
			var alert:Alert;
			alert = new Alert();
			alert.showAlert("Do you confirm the purchase?", [AlertAnswer.YES, AlertAnswer.NO]);
			Main.noticesLayer.addChild(alert);
			xtSkinEquip.enable = false;
			alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED, function(ae:AlertEvent):void
			{
				if (ae.typeButton == localeService.getText(TextConst.ALERT_ANSWER_YES))
				{
					confirmBuy();
				}
				else
				{
					xtSkinEquip.enable = true;
				}
			});
		}
		
		public function confirmBuy(e:MouseEvent = null) : void 
		{
			Network(Main.osgi.getService(INetworker)).send("garage;buy_skin;" + id);
			this.xtSkinEquip.removeEventListener(MouseEvent.CLICK, dfet);
		}
		
		public function hide(e:MouseEvent = null) : void 
		{
			this.window.visible = false;
			i1.visible = false;
			sh = false;
			Main.stage.removeEventListener(Event.RESIZE, resize);
			closeButton.removeEventListener(MouseEvent.CLICK,hide);
			xtSkinEquip.removeEventListener(MouseEvent.CLICK,hop);
			if(this.contains(this.window)){
				this.removeChild(this.window);
			}
			if(this.contains(i1)){
				this.removeChild(i1);
			}
			destroySkins();
            (Main.osgi.getService(IPanel) as IPanel).unblur();
		}
		
		public function hop(e:Event = null) : void 
		{
			dispatchEvent(new Event("Da"))
		}
		
		public function destroySkins() : void 
		{
			for each(var skinContainer:SkinContainer in skins){
				if(scrollContainer.contains(skinContainer)){
					scrollContainer.removeChild(skinContainer);
				}
			}
			extraSkinCount = 0;
		}
		
		public function resize(e:Event = null) : void 
		{
			this.window.width = windowSize.x;
			windowInput.x = windowMargin;
			windowInput.y = windowMargin;

			scrollPane.x = windowMargin;
			scrollPane.y = windowMargin + 10;
			
			windowInput.width = this.window.width - windowMargin * 2;

			gar.graphics.clear();
			gar.graphics.lineStyle(2, 0x5d8342);
			gar.graphics.drawRoundRect(0, 0, 438, 120, 6, 6);

			gar1.y = windowInput.y + windowMargin + 120;
			gar1.graphics.clear();
			gar1.graphics.lineStyle(2, 0x5d8342);
			gar1.graphics.drawRoundRect(0,0,438, lab3.height + 20 + lab3.y,6,6);

			windowInput.height = windowMargin * 2;

			scrollContainer.x = windowInput.x;
			scrollContainer.y = 2;

			windowInput.height = windowMargin * 2 + 360;
			
			closeButton.x = this.window.width - closeButton.width - windowMargin;
			closeButton.y = windowInput.y + windowInput.height + windowMargin;
			closeButton.width = 100;

			xtSkinEquip.x = (windowInput.width - windowMargin * 4) - xtSkinEquip.width - windowMargin * 2;
			xtSkinEquip.y = 50 - xtSkinEquip.height / 2;

			lab.x = 90;
			lab.y = 15;
			lab1.x = 90;
			lab1.y = lab.y + lab.height + 15;

			defaultSkinEquip.x = (windowInput.width - windowMargin * 4) - defaultSkinEquip.width - windowMargin * 2;
			defaultSkinEquip.y = 50 - defaultSkinEquip.height / 2;

			lab2.x = 90;
			lab2.y = 15;
			lab3.x = 90;
			lab3.y = lab2.y + lab2.height + 15;

			this.window.height = 450;

			closeButton.y = windowInput.y + windowInput.height + windowMargin;

			this.x = Math.round((Main.stage.stageWidth - this.window.width) * 0.5);
			this.y = Math.round((Main.stage.stageHeight - this.window.height) * 0.5);

			sk.x = 10;
			sk.y = 14;
			xt.x = 6;
			xt.y = 14;

            this.scrollPane.setSize(windowInput.width, windowInput.height - 20);
		}
		
	}

}