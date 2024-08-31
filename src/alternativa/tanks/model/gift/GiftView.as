package alternativa.tanks.model.gift
{
    import flash.display.Sprite;
    import alternativa.osgi.service.locale.ILocaleService;
    import controls.TankWindow;
    import controls.DefaultButton;
    import controls.Label;
    import alternativa.init.Main;
    import controls.TankWindowInner;
    import alternativa.tanks.locale.constants.TextConst;
    import flash.events.MouseEvent;
    import logic.networking.Network;
    import logic.networking.INetworker;
    import flash.display.BitmapData;
    import alternativa.tanks.model.gift.opened.GivenItem;
    import com.alternativaplatform.projects.tanks.client.garage.garage.ItemInfo;
    import alternativa.tanks.model.GarageModel;
    import alternativa.tanks.model.IGarage;
    import logic.resource.ResourceUtil;
    import logic.resource.ResourceType;
    import alternativa.resource.StubBitmapData;
    import alternativa.tanks.model.gift.opened.GiftOpenedView_Background;
    import alternativa.tanks.model.gift.opened.GiftOpenedView;
    import alternativa.tanks.model.panel.PanelModel;
    import alternativa.tanks.model.panel.IPanel;
    import flash.utils.getTimer;
    import flash.events.Event;
    import controls.BigButton;
    import flash.display.Bitmap;
    import com.gskinner.motion.GTween;
    import com.gskinner.motion.easing.Sine;

    public class GiftView extends Sprite
    {

        public static const WINNER_ITEM_ID:int = 9;
        private static const ANIMATE_DURATION:int = 1;//9700;
        private static const MARGIN:int = 11;
        private static const WINDOW_WIDTH:int = (537 + (MARGIN * 2));
        private static const WINDOW_HEIGHT:int = ((456 + (MARGIN * 2)) + BUTTON_PANEL_HEIGHT);
        private static const BUTTON_PANEL_HEIGHT:int = 54;

		[Embed(source="1not.png")]
		private static const cont1not:Class;
		[Embed(source="5not.png")]
		private static const cont5not:Class;
		[Embed(source="15not.png")]
		private static const cont15not:Class;
		
		private var cont1:Bitmap = new cont1not();
		public var cont5:Bitmap = new cont5not();
		private var cont15:Bitmap = new cont15not();

        private var localeService:ILocaleService;
        private var window:TankWindow = new TankWindow();
        private var roller:GilfRoller;
        private var playButton:BigButton = new BigButton();
        private var playButton5:BigButton = new BigButton();
        private var playButton10:BigButton = new BigButton();
        public var closeButton:DefaultButton = new DefaultButton();
        private var giftInfoList:GiftInfoList;
        private var startTime:Number;
        private var finalPosition:Number;
        private var items:Array;
        private var firstRoll:* = true;
        private var openedCountLabel:Label;
        private var leftCountLabel:Label;
        private var opened:int = 0;
        private var lefted:int = 0;
        private var offsetCrystalls:int = -1;
        private var winnerItemId:String;
        private var winnerCountItems:Array;
        private var itemName:String;
        private var rarityItem:int;
        private var openMultiply:int;
        private static const Background:Class = GiftOpenedView_Background;
        private static const backgroundImg:BitmapData = new Background().bitmapData;

        public function GiftView(data:Array, count:int)
        {
            this.items = data;
            this.lefted = count;
            this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
            this.window.width = (537 + (MARGIN * 2));;
            this.window.height = ((456 + (MARGIN * 2)) + 54);
            var bg:Bitmap;
            var inner:TankWindowInner = new TankWindowInner((WINDOW_WIDTH - (2 * MARGIN)), (((WINDOW_HEIGHT - (2 * MARGIN)) - BUTTON_PANEL_HEIGHT) - 5), TankWindowInner.GREEN);
            inner.x = MARGIN;
            inner.y = MARGIN;
            addChild(this.window);
            addChild(inner);
            bg = new Bitmap(backgroundImg);
            bg.width = inner.width;
            bg.height = inner.height;
            inner.addChild(bg);
            inner.addChild(cont1);
            cont1.width *= 0.75;
            cont1.height *= 0.75;
            cont1.x = inner.width / 2 - cont1.width / 2;
            cont1.y = inner.height / 2 - cont1.height / 2;
            inner.addChild(cont5);
            cont5.x = inner.width / 2 - cont5.width / 2;
            cont5.y = inner.height / 2 - cont5.height / 2;
            inner.addChild(cont15);
            cont15.x = inner.width / 2 - cont15.width / 2;
            cont15.y = inner.height / 2 - cont15.height / 2;
            cont5.visible = false;
            cont15.visible = false;
            // this.roller = new GilfRoller(data, (this.window.width - 60), 128);
            // this.roller.x = 30;
            // this.roller.y = 30;
            // addChild(this.roller);
            this.playButton.label = this.localeService.getText(TextConst.GIFT_WINDOW_OPEN) + " 1";
            this.playButton5.x = ((this.window.width / 2) - (this.playButton.width / 2)) - 15;
            this.playButton.y = ((this.window.height - this.playButton.height) - 11);
            addChild(this.playButton);
            this.playButton.addEventListener(MouseEvent.CLICK, this.openGift);
            this.playButton5.label = (this.localeService.getText(TextConst.GIFT_WINDOW_OPEN) + " 5");
            this.playButton.x = ((this.window.width / 2) - (this.playButton.width / 2)) - this.playButton5.width - 20;
            this.playButton5.y = ((this.window.height - this.playButton.height) - 11);
            addChild(this.playButton5);
            this.playButton5.addEventListener(MouseEvent.CLICK, this.openGift);
            this.playButton10.label = (this.localeService.getText(TextConst.GIFT_WINDOW_OPEN) + " 15");
            this.playButton10.x = ((this.window.width / 2) - (this.playButton.width / 2)) + this.playButton10.width - 10;
            this.playButton10.y = ((this.window.height - this.playButton.height) - 11);
            addChild(this.playButton10);
            this.playButton10.addEventListener(MouseEvent.CLICK, this.openGift);

            this.playButton.enable = (this.lefted >= 1);
            this.playButton5.enable = (this.lefted >= 5);
            this.playButton10.enable = (this.lefted >= 15);

            this.giftInfoList = new GiftInfoList();
            this.giftInfoList.width = (this.window.width - 60);
            this.giftInfoList.height = 250;
            this.giftInfoList.x = 30;
            this.giftInfoList.y = ((inner.height - this.giftInfoList.height) + 5);
            this.giftInfoList.initData(data);
            // addChild(this.giftInfoList);
            this.closeButton.label = this.localeService.getText(TextConst.GIFT_WINDOW_CLOSE);
            this.closeButton.x = ((this.window.width - this.closeButton.width) - 10);
            this.closeButton.y = ((this.window.height - this.closeButton.height) - 11);
            addChild(this.closeButton);
            this.openedCountLabel = new Label();
            this.openedCountLabel.x = (this.playButton.x - 80);
            this.openedCountLabel.y = (this.playButton.y + 8);
            this.openedCountLabel.text = (this.localeService.getText(TextConst.GIFT_WINDOW_OPENED) + this.opened);
            this.openedCountLabel.size = 12;
            this.openedCountLabel.textColor = 7726175;
            // addChild(this.openedCountLabel);
            this.leftCountLabel = new Label();
            this.leftCountLabel.x = ((this.playButton.x + this.playButton.width) + 20);
            this.leftCountLabel.y = (this.playButton.y + 8);
            this.leftCountLabel.text = (this.localeService.getText(TextConst.GIFT_WINDOW_LEFTED) + this.lefted);
            this.leftCountLabel.size = 12;
            this.leftCountLabel.textColor = 7726175;
            // addChild(this.leftCountLabel);
            var infoText:Label = new Label();
            infoText.text = this.localeService.getText(TextConst.GIFT_WINDOW_INFO);
            infoText.x = 13;
            infoText.y = ((this.window.height - infoText.height) - 18);
            // addChild(infoText);
            playButton.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void{
                cont1.visible = true;
                cont5.visible = false;
                cont15.visible = false;
            });
            playButton5.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void{
                cont1.visible = false;
                cont5.visible = true;
                cont15.visible = false;
            });
            playButton10.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void{
                cont1.visible = false;
                cont5.visible = false;
                cont15.visible = true;
            });
        }
        private function openGift(event:MouseEvent):void
        {
            this.playButton.enable = false;
            this.playButton5.enable = false;
            this.playButton10.enable = false;
            this.closeButton.enable = false;
            if (event.currentTarget == this.playButton)
            {
                this.openMultiply = 1;
                Network(Main.osgi.getService(INetworker)).send("lobby;try_roll_item");
            }
            if (event.currentTarget == this.playButton5)
            {
                this.openMultiply = 5;
                Network(Main.osgi.getService(INetworker)).send("lobby;try_roll_items;5");
            }
            if (event.currentTarget == this.playButton10)
            {
                this.openMultiply = 15;
                Network(Main.osgi.getService(INetworker)).send("lobby;try_roll_items;15");
            }
            var tween:GTween = new GTween(this, 0.1, {alpha: 0});
            tween.ease = Sine.easeInOut;
            tween.onComplete = onTweenComplete;
        }
        private function onTweenComplete(tween:GTween):void {
            this.window.visible = false;
            //this.closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false));
        }
        public function rolls(param1:Array):void
        {
            var _loc3_:Object;
            var _loc4_:int;
            var _loc5_:Object;
            var _loc6_:BitmapData;
            var _loc7_:GivenItem;
            var _loc8_:* = undefined;
            var _loc9_:Array;
            var _loc10_:int;
            var _loc11_:ItemInfo;
            this.opened = (this.opened + this.openMultiply);
            this.lefted = (this.lefted - this.openMultiply);
            this.openedCountLabel.text = (this.localeService.getText(TextConst.GIFT_WINDOW_OPENED) + this.opened);
            this.leftCountLabel.text = (this.localeService.getText(TextConst.GIFT_WINDOW_LEFTED) + this.lefted);
            if (this.lefted < 1)
            {
                //GarageModel(Main.osgi.getService(IGarage)).removeItemFromWarehouse("gift_m0");
            }
            else
            {
                _loc4_ = 0;
                while (_loc4_ < this.openMultiply)
                {
                    //GarageModel(Main.osgi.getService(IGarage)).decreaseCountItems("gift_m0");
                    _loc4_++;
                }
            }
            var _loc2_:Array = new Array();
            for each (_loc3_ in param1)
            {
                if(ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_.itemId + "_m0_preview")) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_.itemId + "_m0_preview"));
                }else if(ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_.itemId + "_m0")) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_.itemId + "_m0"));
                }else if(ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_.itemId)) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_.itemId));
                }else if(ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_.itemId + "_preview")) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_.itemId + "_preview"));
                }else{
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, "red_m0")
                }
                _loc6_ = ((_loc5_ == null) ? new StubBitmapData(1) : _loc5_.bitmapData);
                _loc7_ = new GivenItem(_loc6_, _loc3_.visualItemName, _loc3_.rarity);
                _loc2_.push(_loc7_);
                _loc8_ = parseInt(_loc3_.offsetCrystalls);
                if (_loc8_ > 0)
                {
                    if (this.offsetCrystalls == -1)
                    {
                        this.offsetCrystalls = 0;
                    }
                    this.offsetCrystalls = (this.offsetCrystalls + _loc8_);
                }
                this.winnerCountItems = (_loc3_.numInventoryCounts as Array);
                this.winnerItemId = _loc3_.itemId;
                if (this.winnerItemId != "crystalls")
                {
                    if (this.winnerItemId.indexOf("set_") != -1)
                    {
                        _loc9_ = new Array("health_m0", "armor_m0", "double_damage_m0", "n2o_m0", "mine_m0");
                        _loc10_ = 0;
                        while (_loc10_ < _loc9_.length)
                        {
                            _loc11_ = new ItemInfo();
                            _loc11_.count = this.winnerCountItems[_loc10_];
                            _loc11_.itemId = _loc9_[_loc10_];
                            _loc11_.addable = true;
                            //GarageModel(Main.osgi.getService(IGarage)).buyItem(null, _loc11_);
                            _loc10_++;
                        }
                    }
                    else
                    {
                        if (this.offsetCrystalls < 1)
                        {
                            _loc11_ = new ItemInfo();
                            _loc11_.count = this.winnerCountItems[0];
                            _loc11_.itemId = (this.winnerItemId + "_m0");
                            _loc11_.addable = true;
                            //GarageModel(Main.osgi.getService(IGarage)).buyItem(null, _loc11_);
                        }
                    }
                }
            }
            Main.stage.addChild(new GiftOpenedView(_loc2_));
            // if (this.lefted < 1)
            // {
            //     this.closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false));
            // }
            if (this.offsetCrystalls != -1)
            {
                PanelModel(Main.osgi.getService(IPanel)).updateCrystal(null, (PanelModel(Main.osgi.getService(IPanel)).crystal + this.offsetCrystalls));
            }
            this.playButton.enable = (this.lefted > 0);
            this.playButton5.enable = (this.lefted >= 5);
            this.playButton10.enable = (this.lefted >= 10);
            this.closeButton.enable = true;
            this.offsetCrystalls = 0;
        }
        public function roll(winnerId:String, countItem:Array, offsetCrystalls:int, itemName:String, rarity:int):void
        {
            if ((!(this.firstRoll)))
            {
                //this.roller.init(this.items);
            }
            this.offsetCrystalls = 0;
            this.winnerItemId = winnerId;
            this.winnerCountItems = countItem;
            this.itemName = itemName;
            this.rarityItem = rarity;
            this.firstRoll = false;
            this.opened++;
            this.lefted--;
            this.openedCountLabel.text = (this.localeService.getText(TextConst.GIFT_WINDOW_OPENED) + this.opened);
            this.leftCountLabel.text = (this.localeService.getText(TextConst.GIFT_WINDOW_LEFTED) + this.lefted);
            // if (this.lefted < 1)
            // {
            //     GarageModel(Main.osgi.getService(IGarage)).removeItemFromWarehouse("gift_m0");
            // }
            // else
            // {
            //     GarageModel(Main.osgi.getService(IGarage)).decreaseCountItems("gift_m0");
            // }
            var _loc3_:String = winnerId;
            var _loc5_:Object;
            if(ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_ + "_m0_preview")) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_ + "_m0_preview"));
                }else if(ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_ + "_m0")) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_ + "_m0"));
                }else if(ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_)) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_));
                }else if(ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_ + "_preview")) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (_loc3_ + "_preview"));
                }else{
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, "red_m0")
                }
            //this.roller.list.update((WINNER_ITEM_ID + 4), "preview", _loc5_);
            var offset:Number = Math.random();
            var marketOffser:Number = (this.giftInfoList.width / 2);
            this.finalPosition = (((204 * WINNER_ITEM_ID) + marketOffser) + (offset * 180));
            this.startTime = getTimer();
            Main.stage.addEventListener(Event.ENTER_FRAME, this.update, false, 0, false);
        }
        private function update(param1:Event):void
        {
            var _loc5_:BitmapData;
            var _loc6_:GivenItem;
            var _loc7_:Array;
            var _loc8_:int;
            var _loc9_:ItemInfo;
            var _loc2_:Number = ((getTimer() - this.startTime) / ANIMATE_DURATION);
            if (_loc2_ > 1)
            {
                _loc2_ = 1;
                Main.stage.removeEventListener(Event.ENTER_FRAME, this.update);
                this.playButton.enable = (this.lefted >= 1);
                this.playButton5.enable = (this.lefted >= 5);
                this.playButton10.enable = (this.lefted >= 15);
                this.closeButton.enable = true;
                // if (this.lefted < 1)
                // {
                //     this.closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false));
                // }
                if (this.offsetCrystalls != -1)
                {
                    PanelModel(Main.osgi.getService(IPanel)).updateCrystal(null, (PanelModel(Main.osgi.getService(IPanel)).crystal + this.offsetCrystalls));
                }
                if(ResourceUtil.getResource(ResourceType.IMAGE, (winnerItemId + "_m0_preview")) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (winnerItemId + "_m0_preview")).bitmapData;
                }else if(ResourceUtil.getResource(ResourceType.IMAGE, (winnerItemId + "_m0")) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (winnerItemId + "_m0")).bitmapData;
                }else if(ResourceUtil.getResource(ResourceType.IMAGE, (winnerItemId)) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (winnerItemId)).bitmapData;
                }else if(ResourceUtil.getResource(ResourceType.IMAGE, (winnerItemId + "_preview")) != null){
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, (winnerItemId + "_preview")).bitmapData;
                }else{
                    _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE, "red_m0").bitmapData;
                }
                _loc6_ = new GivenItem(_loc5_, this.itemName, this.rarityItem);
                Main.stage.addChild(new GiftOpenedView(new Array(_loc6_)));
                if (this.winnerItemId == "crystalls")
                {
                    return;
                }
                if (this.winnerItemId.indexOf("set_") != -1)
                {
                    _loc7_ = new Array("health_m0", "armor_m0", "double_damage_m0", "n2o_m0", "mine_m0");
                    _loc8_ = 0;
                    while (_loc8_ < _loc7_.length)
                    {
                        _loc9_ = new ItemInfo();
                        if(this.winnerCountItems != null){
                            _loc9_.count = this.winnerCountItems[_loc8_];
                        }
                        _loc9_.itemId = _loc7_[_loc8_];
                        _loc9_.addable = true;
                        //GarageModel(Main.osgi.getService(IGarage)).buyItem(null, _loc9_);
                        _loc8_++;
                    }
                }
                else
                {
                    if (this.offsetCrystalls < 1)
                    {
                        _loc9_ = new ItemInfo();
                        if(this.winnerCountItems != null){
                            _loc9_.count = this.winnerCountItems[0];
                        }
                        _loc9_.itemId = (this.winnerItemId + "_m0");
                        _loc9_.addable = true;
                        //GarageModel(Main.osgi.getService(IGarage)).buyItem(null, _loc9_);
                    }
                }
            }
            var _loc3_:* = (_loc2_ * (2 - _loc2_));
            var _loc4_:* = (_loc3_ * this.finalPosition);
            //this.roller.list.list.horizontalScrollPosition = _loc4_;
        }

    }
}
