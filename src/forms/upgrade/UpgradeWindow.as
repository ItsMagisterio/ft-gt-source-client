package forms.upgrade 
{
	import alternativa.engine3d.core.View;
	import alternativa.init.Main;
	import alternativa.osgi.service.loader.ILoaderService;
	import alternativa.osgi.service.locale.ILocaleService;
	import alternativa.tanks.gui.ItemInfoPanel;
	import alternativa.tanks.gui.ItemPropertyIcon;
	import alternativa.tanks.locale.constants.TextConst;
	import alternativa.tanks.model.panel.IPanel;
	import alternativa.tanks.model.panel.PanelModel;
	import controls.Label;
	import controls.TankInput;
	import controls.TankWindowInner;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import forms.TankWindowWithHeader;
	import forms.garage.GarageButton;
	import flash.utils.Dictionary;
	import alternativa.tanks.model.ItemParams;
	import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;
	import logic.networking.Network;
	import logic.networking.INetworker;

	
	public class UpgradeWindow extends Sprite
	{
      
      [Embed(source="1.png")]
      private static const arrowClass:Class;
      private static const arrowIndicator:BitmapData = new arrowClass().bitmapData;
		
		private var windowSize:Point = new Point(496, 492);
		
		private const windowMargin:int = 12;
		
		public var window:TankWindowWithHeader = TankWindowWithHeader.createWindow("UPGRADE");
		
		private var windowInput:TankWindowInner = new TankWindowInner(1,1,TankWindowInner.GREEN);
		
		private var progress:UpgradeProgressForm = new UpgradeProgressForm();
		
		private var prog:Label = new Label();
		
		private var buttonUpgrade:GarageButton = new GarageButton();
		
		private var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
		
		private var closeButton:UpgrButton = new UpgrButton();
		
		private var imgs:Array;
		
		private var container:Sprite = new Sprite();
		
		private var rootContainer:Sprite = new Sprite();
		
		private var od:ItemPropertyIcon;
		
		private var v:Boolean = false;
		
		private var icons:Dictionary;
		
		private var propertiesArray:Array = new Array();
		
		private var arrowInd:Bitmap = new Bitmap(arrowIndicator);

		public var id:String;

		private var v1:int;
		private var v2:Array;
		private var v3:Array;
		private var v4:Array;
		private var v5:int;
		private var v6:Array;
		private var v7:ItemTypeEnum;
		
		public function UpgradeWindow() 
		{
			super();
		}
		
		public function init() : void 
		{
			this.addChild(this.window);
			this.addChild(rootContainer);
			rootContainer.addChild(windowInput);
			rootContainer.addChild(container);
			rootContainer.addChild(progress);
			prog.text = "Progress: 0/10"
			buttonUpgrade.label = "Upgrade";
			rootContainer.addChild(buttonUpgrade);
			closeButton.label = "Close";
			rootContainer.addChild(closeButton);
			this.window.visible = false;
			rootContainer.visible = false;
		}
		
		public function davay(p:int,initialRow:Array,upgradesAddRow:Array,resultRow:Array,cost:int,visibleIcons:Array,itemType:ItemTypeEnum) : void 
		{
			v1 = p;
			v2 = initialRow;
			v3 = upgradesAddRow;
			v4 = resultRow;
			v5 = cost;
			v6 = visibleIcons;
			v7 = itemType;
			buttonUpgrade.setInfo(cost, 0);
			if (PanelModel(Main.osgi.getService(IPanel)).crystal<cost)
			{
				buttonUpgrade.setInfo(-cost, 0);
				buttonUpgrade.enable = false;
			}else{
				buttonUpgrade.enable = true;
			}
			icons = new Dictionary();
			rootContainer.removeChild(windowInput);
			windowInput = new TankWindowInner(1, 1, TankWindowInner.GREEN);
			rootContainer.addChild(windowInput);
			rootContainer.removeChild(container);
			container = new Sprite();
			rootContainer.addChild(container);
			resize();
			progress.lev = p;
			progress.update();
			for (var fj:int = 0; fj < visibleIcons.length; fj++)
			{
				icons[fj] = visibleIcons[fj].clone();
				icons[fj].posUpgradeLabel(itemType, 0);
				if(fj == 1){
					if(icons[fj - 1].labelText == icons[fj].labelText){
						icons[fj - 1].posUpgradeLabel(itemType, 1);
					}
				}
			}
			var index:int = 0;
			var upgradingProperties:Array = new Array();

			var initialValues:Array = new Array();
			var upgradingIncrementValues:Array = new Array();
			var resultsValues:Array = new Array();
			var upgradeArrowIcons:Array = new Array();
			
			var itemIcon:ItemPropertyIcon = null;
			for each(itemIcon in icons)
			{
				for (var originalValue:int = 0; originalValue < initialRow.length; originalValue++)
				{
					var origValueLabel:Label = new Label();
					origValueLabel.color = 65291;
					if (upgradesAddRow[originalValue] == 0 || upgradesAddRow[originalValue] == null)
					{
						origValueLabel.color = 16580352;
					}
					origValueLabel.text = initialRow[originalValue] + "";
					initialValues.push(origValueLabel);
				}
				for (var upgradingValue:int = 0; upgradingValue < upgradesAddRow.length; upgradingValue++)
				{
					var upgrValueLabel:Label = new Label();
					upgrValueLabel.text = "+" + upgradesAddRow[upgradingValue];
					if (upgradesAddRow[upgradingValue] < 0)
					{
						upgrValueLabel.text = "" + upgradesAddRow[upgradingValue];
					}
					upgradingIncrementValues.push(upgrValueLabel);
					upgradeArrowIcons.push(new Bitmap(arrowIndicator));
				}
				for (var ip2:int = 0; ip2 < resultRow.length; ip2++)
				{
					var resultLabel:Label = new Label();
					resultLabel.color = 65291;
					if (upgradesAddRow[ip2] == 0 || upgradesAddRow[ip2] == null)
					{
						resultLabel.color = 16580352;
						upgradingIncrementValues[ip2] = null;
						upgradeArrowIcons[ip2] = null;
					}
					resultLabel.text = resultRow[ip2] + "";
					resultsValues.push(resultLabel);
				}
				container.addChild(itemIcon);
				container.addChild(initialValues[index]);
				buttonUpgrade.visible = false;
				if (upgradingIncrementValues[index] != null)
				{
					container.addChild(upgradeArrowIcons[index]);
					container.addChild(upgradingIncrementValues[index]);
					buttonUpgrade.visible = true;
				}
				if (resultsValues[index] != null)
				{
					container.addChild(resultsValues[index]);
					buttonUpgrade.visible = true;
				}
				initialValues[index].x = 496 / 2 - 20;
				if (upgradingIncrementValues[index] != null)
				{
					upgradingIncrementValues[index].x = (496 / 1.5) - 20;
				}
				if (resultsValues[index] != null)
				{
					resultsValues[index].x = (496 / 1.25) - 20;
				}
				if (upgradeArrowIcons[index] != null)
				{
					upgradeArrowIcons[index].x = (496 / 1.5) - 20;
				}
				if (index == 0)
				{
					itemIcon.y = 0;
					initialValues[index].y = itemIcon.height / 4;
					if (upgradingIncrementValues[index] != null)
					{
						upgradeArrowIcons[index].y = itemIcon.height / 4;
						upgradingIncrementValues[index].y = itemIcon.height / 4;
					}
					if (resultsValues[index] != null)
					{
						resultsValues[index].y = itemIcon.height / 4;
					}
				}else{
					if (upgradingProperties[index - 1] != null)
					{
						itemIcon.y = upgradingProperties[index - 1].y + windowMargin + upgradingProperties[index - 1].height;
						initialValues[index].y = initialValues[index - 1].y + itemIcon.height + windowMargin;
						if (upgradingIncrementValues[index] != null)
						{
							if(upgradeArrowIcons[index - 1] != null){
								upgradeArrowIcons[index].y = upgradeArrowIcons[index - 1].y + itemIcon.height + windowMargin;
								upgradingIncrementValues[index].y = upgradingIncrementValues[index - 1].y + itemIcon.height + windowMargin;
							}else if(index == 2){
								upgradeArrowIcons[index].y = upgradeArrowIcons[index - 2].y + itemIcon.height + windowMargin;
								upgradingIncrementValues[index].y = upgradingIncrementValues[index - 2].y + itemIcon.height + windowMargin;
							}
						}
						if (resultsValues[index] != null)
						{
							resultsValues[index].y = resultsValues[index - 1].y + itemIcon.height + windowMargin;
						}
					}
				}
				upgradingProperties.push(itemIcon);
				index++;
			}
			if(cost == 0){
				buttonUpgrade.visible = false;
			}
			resize();
		}

		public function update(progress:int, cost:int):void
		{
			this.davay(v1,v2,v3,v4,v5,v6,v7);
		}
		
		public function show() : void 
		{
			this.window.visible = true;
			rootContainer.visible = true;
			Main.stage.addEventListener(Event.RESIZE, resize);
			closeButton.addEventListener(MouseEvent.CLICK, hide);
			buttonUpgrade.enabled = true;
			buttonUpgrade.addEventListener(MouseEvent.CLICK,hop);
		}
		
		public function hide(e:MouseEvent = null) : void 
		{
			this.window.visible = false;
			rootContainer.visible = false;
			Main.stage.removeEventListener(Event.RESIZE, resize);
			closeButton.removeEventListener(MouseEvent.CLICK,hide);
			buttonUpgrade.removeEventListener(MouseEvent.CLICK,hop);
            (Main.osgi.getService(IPanel) as IPanel).unblur();
		}
		
		public function hop(e:Event = null) : void 
		{
			buttonUpgrade.enable = false;
			Network(Main.osgi.getService(INetworker)).send(("garage;try_microupgrade_item;" + id));
			dispatchEvent(new Event("Da"));
		}
		
		public function destroy() : void 
		{
			this.removeChild(this.window);
			this.removeChild(rootContainer);
			Main.stage.removeEventListener(Event.RESIZE, resize);
			closeButton.removeEventListener(MouseEvent.CLICK, hide);
			buttonUpgrade.removeEventListener(MouseEvent.CLICK,hop);
		}
		
		public function resize(e:Event = null) : void 
		{
            x = Main.stage.stageWidth / 2 - this.width / 2;
            y = Main.stage.stageHeight / 2 - this.height / 2;
			this.window.width = windowSize.x;
			windowInput.x = windowMargin;
			windowInput.y = windowMargin;
			windowInput.width = this.window.width - windowMargin * 2;
			windowInput.height = windowMargin * 2 + icons.length * 30;
			container.x = windowInput.x + windowMargin;
			container.y = windowInput.y + windowMargin;
			windowInput.height = windowMargin * 2 + container.height;
			progress.width = windowInput.width;
			progress.x = windowMargin;
			progress.y = windowInput.y + windowInput.height + windowMargin;
			closeButton.x = this.window.width - closeButton.width - windowMargin;
			closeButton.y = this.window.height - closeButton.height - windowMargin;
			closeButton.width = 100;
			buttonUpgrade.x = this.window.width/2 - buttonUpgrade.width/2;
			buttonUpgrade.y = progress.y + progress.height + windowMargin;
			this.window.height = buttonUpgrade.y + buttonUpgrade.height + windowMargin;
			closeButton.y = this.window.height - closeButton.height - windowMargin;
		}
		
	}

}