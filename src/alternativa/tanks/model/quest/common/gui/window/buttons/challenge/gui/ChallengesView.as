package alternativa.tanks.model.quest.challenge.gui
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.challenge.battlepass.notifier.BattlePassPurchaseService;
   import alternativa.tanks.model.quest.challenge.stars.StarsInfoService;
   import alternativa.tanks.model.quest.common.MissionsWindowsService;
   import controls.Label;
   import controls.TankWindowInner;
   import controls.buttons.h30px.H30ButtonSkin;
   import controls.buttons.h30px.OrangeMediumButton;
   import controls.timer.CountDownTimer;
   import controls.timer.CountDownTimerWithIcon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import platform.client.fp10.core.resource.BatchResourceLoader;
   import platform.client.fp10.core.resource.Resource;
   import platform.client.fp10.core.resource.types.ImageResource;
   import platform.clients.fp10.libraries.alternativapartners.service.IPartnerService;
   import projects.tanks.client.commons.types.ShopCategoryEnum;
   import projects.tanks.client.panel.model.challenge.rewarding.Tier;
   import projects.tanks.client.panel.model.challenge.rewarding.TierItem;
   import projects.tanks.clients.flash.commons.models.challenge.ChallengeInfoService;
   import projects.tanks.clients.flash.commons.models.challenge.shopitems.ChallengeShopItems;
   import projects.tanks.clients.flash.commons.services.payment.PaymentDisplayService;
   import projects.tanks.clients.fp10.libraries.TanksLocale;
   import projects.tanks.clients.fp10.libraries.tanksservices.service.user.IUserInfoService;

   public class ChallengesView extends Sprite
   {

      [Inject]
      public static var challengeInfoService:ChallengeInfoService;

      [Inject]
      public static var challengeShopItems:ChallengeShopItems;

      [Inject]
      public static var starsInfoService:StarsInfoService;

      [Inject]
      public static var battlePassPurchaseService:BattlePassPurchaseService;

      [Inject]
      public static var paymentDisplayService:PaymentDisplayService;

      [Inject]
      public static var localeService:ILocaleService;

      [Inject]
      public static var userInfoService:IUserInfoService;

      [Inject]
      public static var missionsWindowService:MissionsWindowsService;

      [Inject]
      public static var partnerService:IPartnerService;

      private static const goldenStarClass:Class = ChallengesView_goldenStarClass;

      private static const goldenStarBitmapData:BitmapData = new goldenStarClass().bitmapData;

      private static const silverStarClass:Class = ChallengesView_silverStarClass;

      private static const silverStarBitmapData:BitmapData = new silverStarClass().bitmapData;

      private static const goldenStarBgClass:Class = ChallengesView_goldenStarBgClass;

      private static const goldenStarBgBitmapData:BitmapData = new goldenStarBgClass().bitmapData;

      private static const silverStarBgClass:Class = ChallengesView_silverStarBgClass;

      private static const silverStarBgBitmapData:BitmapData = new silverStarBgClass().bitmapData;

      private static var GAP:int = 3;

      private static var TIER_LIST_WIDTH:int = 724;

      private static var TIER_LIST_HEIGHT:int = 335;

      private static var DESCRIPTION_LABEL_WIDTH:int = 520;

      private static var BUY_BUTTON_WIDTH:int = 180;

      private var tierView:alternativa.tanks.model.quest.challenge.gui.TierNumberView;

      private var progressView:alternativa.tanks.model.quest.challenge.gui.ChallengesProgressView;

      private var tierList:alternativa.tanks.model.quest.challenge.gui.TierList;

      private var buyButton:OrangeMediumButton;

      private var timer:CountDownTimer;

      private var descriptionLabel:Label;

      private var tiersInfo:Vector.<Tier>;

      private var showBuyButton:Boolean;

      public function ChallengesView()
      {
         this.tierView = new alternativa.tanks.model.quest.challenge.gui.TierNumberView();
         this.progressView = new alternativa.tanks.model.quest.challenge.gui.ChallengesProgressView();
         this.tierList = new alternativa.tanks.model.quest.challenge.gui.TierList();
         this.buyButton = new OrangeMediumButton();
         this.timer = new CountDownTimer();
         this.descriptionLabel = new Label();
         super();
         this.initTierLabel();
         this.initStarLabels();
         this.initProgressBar();
         this.initTimerLabel();
         this.initTiersList();
         this.initBuyButton();
         this.initDescriptionLabel();
         this.showBuyButton = !partnerService.isRunningInsidePartnerEnvironment() || !partnerService.hasPaymentAction();
         this.initView();
      }

      public function refreshTierListView():void
      {
         this.initResourcesLoading();
      }

      private function initResourcesLoading():void
      {
         var tier:Tier = null;
         var freeItem:TierItem = null;
         var battlePassItem:TierItem = null;
         var resources:Vector.<Resource> = new Vector.<Resource>();
         for each (tier in this.tiersInfo)
         {
            freeItem = tier.freeItem;
            if (freeItem != null)
            {
               this.addToLoad(freeItem.preview, resources);
            }
            battlePassItem = tier.battlePassItem;
            if (battlePassItem != null)
            {
               this.addToLoad(battlePassItem.preview, resources);
            }
         }
         if (resources.length > 0)
         {
            new BatchResourceLoader(function():void
               {
                  refresh();
               }).load(resources);
         }
         else
         {
            this.refresh();
         }
      }

      public function setTiersInfo(param1:Vector.<Tier>):void
      {
         this.tiersInfo = param1;
      }

      private function refresh():void
      {
         var _loc1_:int = int(starsInfoService.getStars());
         if (this.tiersInfo == null || this.tiersInfo.length == 0)
         {
            return;
         }
         var _loc2_:int = this.getCurrentTierIndex(_loc1_);
         var _loc3_:int = this.tiersInfo[_loc2_].stars;
         var _loc4_:int = _loc2_ == 0 ? 0 : this.tiersInfo[_loc2_ - 1].stars;
         var _loc5_:int = _loc1_ >= _loc3_ ? 100 : int((_loc1_ - _loc4_) * 100 / (_loc3_ - _loc4_));
         this.tierView.level = _loc2_ + 1;
         this.tierList.setTiers(this.tiersInfo, _loc2_, _loc5_);
         this.progressView.setProgress(_loc5_, _loc1_, _loc3_);
         if (this.showBuyButton)
         {
            this.updateBuyButton(_loc5_ == 100);
         }
      }

      public function getUserTierIndex(param1:int):int
      {
         var _loc2_:int = 0;
         while (_loc2_ < this.tiersInfo.length - 1)
         {
            if (this.tiersInfo[_loc2_].stars >= param1)
            {
               return _loc2_ + 1;
            }
            _loc2_++;
         }
         return this.tiersInfo.length;
      }

      private function getCurrentTierIndex(param1:int):int
      {
         var _loc2_:int = 0;
         while (_loc2_ < this.tiersInfo.length - 1)
         {
            if (this.tiersInfo[_loc2_].stars > param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return this.tiersInfo.length - 1;
      }

      private function addToLoad(param1:ImageResource, param2:Vector.<Resource>):void
      {
         if (param1.isLazy && !param1.isLoaded && param2.indexOf(param1) < 0)
         {
            param2.push(param1);
         }
      }

      private function initTiersList():void
      {
         this.tierList.x = this.progressView.x;
         this.tierList.y = this.progressView.y + this.progressView.height + 8;
         this.tierList.width = TIER_LIST_WIDTH;
         this.tierList.height = TIER_LIST_HEIGHT;
         addChild(this.tierList);
      }

      private function initBuyButton():void
      {
         this.buyButton.labelSize = H30ButtonSkin.DEFAULT_LABEL_SIZE;
         this.buyButton.labelHeight = H30ButtonSkin.DEFAULT_LABEL_HEIGHT;
         this.buyButton.labelPositionY = H30ButtonSkin.DEFAULT_LABEL_Y - 2;
         this.buyButton.width = BUY_BUTTON_WIDTH;
         this.buyButton.y = 378;
         this.buyButton.visible = false;
         this.buyButton.buttonMode = true;
         this.buyButton.useHandCursor = true;
         addChild(this.buyButton);
      }

      private function updateBuyButton(param1:Boolean):void
      {
         var _loc2_:Boolean = Boolean(battlePassPurchaseService.isPurchased());
         var _loc3_:Boolean = Boolean(userInfoService.hasPremium(userInfoService.getCurrentUserId()));
         if (!_loc2_)
         {
            this.buyButton.label = localeService.getText(TanksLocale.TEXT_CHALLENGE_BUY_BATTLE_PASS);
            this.buyButton.visible = true;
            this.descriptionLabel.text = localeService.getText(TanksLocale.TEXT_CHALLENGE_BUY_BATTLE_PASS_TIP);
            this.alignDescriptionLabel();
            return;
         }
         if (param1)
         {
            this.buyButton.visible = false;
            this.descriptionLabel.text = localeService.getText(TanksLocale.TEXT_CHALLENGE_FINISH);
            this.alignDescriptionLabel();
            return;
         }
         if (!_loc3_)
         {
            this.buyButton.label = localeService.getText(TanksLocale.TEXT_CHALLENGE_BUY_PREMIUM);
            this.buyButton.visible = true;
            this.descriptionLabel.text = localeService.getText(TanksLocale.TEXT_CHALLENGE_BUY_PREMIUM_TIP);
            this.alignDescriptionLabel();
            return;
         }
         this.buyButton.visible = true;
         this.buyButton.label = localeService.getText(TanksLocale.TEXT_CHALLENGE_BUY_STARS);
         this.descriptionLabel.text = localeService.getText(TanksLocale.TEXT_CHALLENGE_BUY_STARS_TIP);
         this.alignDescriptionLabel();
      }

      private function alignDescriptionLabel():void
      {
         this.descriptionLabel.x = this.buyButton.visible ? this.buyButton.width + GAP * 2 : this.buyButton.x;
      }

      private function initDescriptionLabel():void
      {
         this.descriptionLabel.width = DESCRIPTION_LABEL_WIDTH;
         this.descriptionLabel.y = this.buyButton.y + GAP;
         this.descriptionLabel.visible = true;
         addChild(this.descriptionLabel);
      }

      public function initView():void
      {
         this.buyButton.addEventListener(MouseEvent.CLICK, this.onBuyButtonClick);
      }

      private function onBuyButtonClick(param1:MouseEvent):void
      {
         var _loc2_:Boolean = Boolean(battlePassPurchaseService.isPurchased());
         var _loc3_:Boolean = Boolean(userInfoService.hasPremium(userInfoService.getCurrentUserId()));
         if (!_loc2_ && challengeShopItems.battlePass != null)
         {
            paymentDisplayService.openPaymentForShopItem(challengeShopItems.battlePass);
         }
         else if (!_loc3_)
         {
            paymentDisplayService.openPaymentAt(ShopCategoryEnum.PREMIUM);
         }
         else
         {
            paymentDisplayService.openPaymentAt(ShopCategoryEnum.STARS);
         }
      }

      private function initTierLabel():void
      {
         addChild(this.tierView);
      }

      private function initStarLabels():void
      {
         var _loc1_:Bitmap = new Bitmap(silverStarBgBitmapData);
         _loc1_.y = this.tierView.height + GAP;
         var _loc2_:Bitmap = new Bitmap(silverStarBitmapData);
         _loc2_.y = _loc1_.y + (_loc1_.height - _loc2_.height) / 2;
         _loc2_.x = (_loc1_.width - _loc2_.width) / 2;
         addChild(_loc1_);
         addChild(_loc2_);
         var _loc3_:Bitmap = new Bitmap(goldenStarBgBitmapData);
         _loc3_.y = _loc1_.y + _loc1_.height + GAP;
         var _loc4_:Bitmap = new Bitmap(goldenStarBitmapData);
         _loc4_.y = _loc3_.y + (_loc3_.height - _loc4_.height) / 2;
         _loc4_.x = (_loc3_.width - _loc4_.width) / 2;
         addChild(_loc3_);
         addChild(_loc4_);
      }

      private function initProgressBar():void
      {
         this.progressView.x = this.tierView.width + 7;
         this.progressView.y = 1;
         addChild(this.progressView);
      }

      private function initTimerLabel():void
      {
         var _loc1_:TankWindowInner = new TankWindowInner(131, 25);
         _loc1_.x = this.progressView.x + this.progressView.width + 8;
         var _loc2_:CountDownTimerWithIcon = new CountDownTimerWithIcon(false);
         _loc2_.start(this.timer);
         _loc2_.x = 10;
         _loc2_.y = 5;
         _loc1_.addChild(_loc2_);
         addChild(_loc1_);
         this.timer.stop();
         this.timer.start(challengeInfoService.getEndTime());
      }

      public function clear():void
      {
         if (this.timer != null)
         {
            this.timer.destroy();
            this.timer = null;
         }
         this.tierList.destroy();
         this.buyButton.removeEventListener(MouseEvent.CLICK, this.onBuyButtonClick);
      }
   }
}
