package forms.itemscategory.shoteffects 
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

	
	public class ShotEffectsWindow extends Sprite
	{
		
		private var windowSize:Point = new Point(496, 492);
		private const windowMargin:int = 12;
		public var window:TankWindowWithHeader = TankWindowWithHeader.createWindow("ALTERATIONS");
		private var windowInput:TankWindowInner = new TankWindowInner(1, 1, TankWindowInner.GREEN);

		private var scrollContainer:Sprite = new Sprite();
		private var scrollPane:ScrollPane = new ScrollPane();
		private var closeButton:CloseBut = new CloseBut();
		
		private var i1:Sprite = new Sprite();
		private var sh:Boolean = false;
		
		private var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
		
		private var gar:Sprite = new Sprite();
		private var lab:Label = new Label();
		private var lab1:Label = new Label();
		private var defaultSkinEquip:GarageButton = new GarageButton();
		
		private var id:String;
      
        public var skinequip:int = 0;
		private var extraSkinCount:int = 0;

		private var skins:Dictionary = new Dictionary();

		[Embed(source="sk.png")]
		private static const gg1:Class;
		public var sk:Bitmap = new gg1();
		
		public function ShotEffectsWindow() 
		{
			super();
			configureContainer(gar);
		}

		public function parseSkin(skinType:ShotEffectType) : void
		{
			extraSkinCount++;
			addSkinContainer(skinType.getName(), skinType.getDescription(), skinType.getSkinType(), skinType.getEquipped(), skinType.getPrice(), skinType.getPurchased());
		}

		public function addSkinContainer(skinName:String, skinDescription:String, skinType:String, equipped:Boolean, price:int, bought:Boolean):void{
			var skinContainerExtra:ShotEffectContainer = new ShotEffectContainer(skinName, skinDescription, skinType, equipped, price, bought);
			skins[extraSkinCount] = skinContainerExtra;
		}

		public function reconfigureSkins(firstLoad:Boolean = true):void{
			for each(var skinContainer:ShotEffectContainer in skins){
				if(!scrollContainer.contains(skinContainer)){
					skinContainer.y = scrollContainer.height + (firstLoad ? 20 : 40);
					scrollContainer.addChild(skinContainer);
					scrollPane.update();
				}
			}
		}

		private var savedId:String;
		
		public function init(n:String) : void 
		{
			var firstLoad:Boolean = n == savedId;
			savedId = n;
			id = n;

			this.window.visible = false;
			this.i1.visible = false;
			this.configWindow();

			closeButton.label = "Close";
			i1.addChild(closeButton);

			addStandardSettings();

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
			Network(Main.osgi.getService(INetworker)).send("garage;unequip_shot_effect;" + id.split("_")[0] + ";" + isSkinEquippable);
			this.defaultSkinEquip.removeEventListener(MouseEvent.CLICK, this.equipDefault);
		}
		
		public function hide(e:MouseEvent = null) : void 
		{
			this.window.visible = false;
			i1.visible = false;
			sh = false;
			Main.stage.removeEventListener(Event.RESIZE, resize);
			closeButton.removeEventListener(MouseEvent.CLICK,hide);
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
			for each(var skinContainer:ShotEffectContainer in skins){
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

			windowInput.height = windowMargin * 2;

			scrollContainer.x = windowInput.x;
			scrollContainer.y = 2;

			windowInput.height = windowMargin * 2 + 360;
			
			closeButton.width = 100;
			closeButton.x = this.window.width - closeButton.width - windowMargin;
			closeButton.y = windowInput.y + windowInput.height + windowMargin;

			lab.x = 90;
			lab.y = 15;
			lab1.x = 90;
			lab1.y = lab.y + lab.height + 15;

			defaultSkinEquip.x = (windowInput.width - windowMargin * 4) - defaultSkinEquip.width - windowMargin * 2;
			defaultSkinEquip.y = 50 - defaultSkinEquip.height / 2;

			this.window.height = 450;

			closeButton.y = windowInput.y + windowInput.height + windowMargin;

			this.x = Math.round((Main.stage.stageWidth - this.window.width) * 0.5);
			this.y = Math.round((Main.stage.stageHeight - this.window.height) * 0.5);

			sk.x = 10;
			sk.y = 14;

            this.scrollPane.setSize(windowInput.width, windowInput.height - 20);
		}
		
	}

}