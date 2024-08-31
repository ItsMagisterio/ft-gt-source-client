package forms.itemscategory
{
	import alternativa.init.Main;
	import forms.itemscategory.skin.Skin;
	import fl.events.ListEvent;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import logic.networking.Network;
	import logic.networking.INetworker;
	import alternativa.tanks.gui.ItemInfoPanel;
	import alternativa.tanks.model.panel.IPanel;
	import mx.core.BitmapAsset;
	import flash.display.Sprite;
	import alternativa.tanks.model.ItemParams;
	import alternativa.tanks.model.GarageModel;
	import alternativa.init.OSGi;
	import alternativa.tanks.model.IGarage;
	import forms.itemscategory.shoteffects.ShotEffectsWindow;
	import logic.resource.ResourceUtil;
	import logic.resource.ResourceType;

	public class ShotEffectButton extends GridItemBase
	{

		[Embed(source="sefback.png")]
		private static const gg:Class;
		public var ded:Bitmap = new gg();
		public var defaultSprite:Sprite = new Sprite();

		[Embed(source="0.png")]
		private static const ga:Class;
		public var over:Bitmap = new ga();

		private var n:String = "";
		private var d:String = "";
		public var id:String = "";
		public var skinWindow:ShotEffectsWindow = new ShotEffectsWindow();
		public var panelModel:IPanel;
		public var skIndex:String = "";

		public var iconToShow:Bitmap;

		public function ShotEffectButton(skinIndex:String, id:String)
		{
			this.id = id;
			if(skinIndex == null || skinIndex == "" || skinIndex == "default"){
				skIndex = "";
			}else{
				skIndex = skinIndex;
			}
			super();
			defaultSprite.addChild(this.ded);
			defaultSprite.addChild(over);
			this.ded.alpha = 1;
			over.alpha = 0;
			addChild(defaultSprite);
			this.setSkin(skIndex);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, this.sd);
			this.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
				over.alpha = 1;
				defaultSprite.y = 2;
			});
			this.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void{
				defaultSprite.y = 0;
				over.alpha = 0;
			});
			this.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void{
				defaultSprite.y = 0;
				over.alpha = 0;
			});
			this.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void{
				defaultSprite.y = 0;
				over.alpha = 1;
			});
		}

		public function sd(e:Event = null, already:Boolean = false) : void
		{
            this.panelModel = (Main.osgi.getService(IPanel) as IPanel);
			this.panelModel.blur();
			Main.dialogsLayer.addChild(skinWindow);
			defaultSprite.y = 0;
			over.alpha = 0;
			if(already == false){
				Network(Main.osgi.getService(INetworker)).send("garage;get_shot_effects_info_for_item;" + id.split("_")[0]);
			}
		}

		public function removeAll():void
		{
			Main.dialogsLayer.removeChildren();
		}

		public function setSkin(skinNameToShow:String):void{

			if(skinNameToShow == null || skinNameToShow == "" || skinNameToShow == "default"){
				iconToShow = new Bitmap(ResourceUtil.getResource(ResourceType.IMAGE,"standard").bitmapData);
			}else{
				iconToShow = new Bitmap(ResourceUtil.getResource(ResourceType.IMAGE,skinNameToShow).bitmapData);
			}
			defaultSprite.addChild(iconToShow);
			iconToShow.x = 9;
			iconToShow.y = 11;
		}

	}

}