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

	public class Ski extends GridItemBase
	{

		[Embed(source="1.png")]
		private static const gg:Class;
		public var ded:Bitmap = new gg();
		public var defaultSprite:Sprite = new Sprite();

		[Embed(source="2.png")]
		private static const gg1:Class;
		public var xt:Bitmap = new gg1();

		[Embed(source="3.png")]
		private static const gg2:Class;
		public var ice:Bitmap = new gg2();

		[Embed(source="4.png")]
		private static const gg3:Class;
		public var tx:Bitmap = new gg3();

		[Embed(source="5.png")]
		private static const gg4:Class;
		public var lc:Bitmap = new gg4();

		[Embed(source="6.png")]
		private static const gg5:Class;
		public var tiny:Bitmap = new gg5();

		[Embed(source="0.png")]
		private static const ga:Class;
		public var over:Bitmap = new ga();

		private var n:String = "";
		private var d:String = "";
		public var id:String = "";
		public var skinWindow:Skin = new Skin();
		public var panelModel:IPanel;
		public var skIndex:String = "";

		public function Ski(skinIndex:String, id:String)
		{
			id = id;
			if(skinIndex == null){
				skIndex = "";
			}else{
				skIndex = skinIndex;
			}
			super();
			defaultSprite.addChild(this.ded);
			defaultSprite.addChild(this.xt);
			defaultSprite.addChild(this.tx);
			defaultSprite.addChild(this.ice);
			defaultSprite.addChild(this.lc);
			defaultSprite.addChild(this.tiny);
			defaultSprite.addChild(over);
			this.xt.alpha = 0;
			this.ded.alpha = 0;
			this.tx.alpha = 0;
			this.ice.alpha = 0;
			this.lc.alpha = 0;
			this.tiny.alpha = 0;
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
				Network(Main.osgi.getService(INetworker)).send("garage;get_skins_info_for_item;" + id.split("_")[0]);
			}
		}

		public function removeAll():void
		{
			Main.dialogsLayer.removeChildren();
		}

		public function setSkin(skinIndex:String):void{
			var indexSkin = 0;
			if(skinIndex.indexOf("lc") >= 0){
				indexSkin = 4;
			}else if(skinIndex.indexOf("xt") >= 0){
				indexSkin = 1;
			}else if(skinIndex.indexOf("fr") >= 0){
				indexSkin = 2;
			}else if(skinIndex.indexOf("tx") >= 0){
				indexSkin = 3;
			}else if(skinIndex.indexOf("tiny") >= 0){
				indexSkin = 5;
			}
			switch(indexSkin){
				case 0:
					this.ded.alpha = 1;
					this.xt.alpha = 0;
					this.ice.alpha = 0;
					this.tx.alpha = 0;
					this.lc.alpha = 0;
					this.tiny.alpha = 0;
					break;
				case 1:
					this.ded.alpha = 0;
					this.xt.alpha = 1;
					this.ice.alpha = 0;
					this.tx.alpha = 0;
					this.lc.alpha = 0;
					this.tiny.alpha = 0;
					break;
				case 2:
					this.ded.alpha = 0;
					this.xt.alpha = 0;
					this.ice.alpha = 1;
					this.tx.alpha = 0;
					this.lc.alpha = 0;
					this.tiny.alpha = 0;
					break;
				case 3:
					this.ded.alpha = 0;
					this.xt.alpha = 0;
					this.ice.alpha = 0;
					this.tx.alpha = 1;
					this.lc.alpha = 0;
					this.tiny.alpha = 0;
					break;
				case 4:
					this.ded.alpha = 0;
					this.xt.alpha = 0;
					this.ice.alpha = 0;
					this.tx.alpha = 0;
					this.lc.alpha = 1;
					this.tiny.alpha = 0;
					break;
				case 5:
					this.ded.alpha = 0;
					this.xt.alpha = 0;
					this.ice.alpha = 0;
					this.tx.alpha = 0;
					this.lc.alpha = 0;
					this.tiny.alpha = 1;
					break;
			}
		}

	}

}