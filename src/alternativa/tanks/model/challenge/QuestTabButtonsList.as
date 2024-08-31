package alternativa.tanks.model.challenge
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.quest.common.gui.window.*;
   import base.DiscreteSprite;
   import controls.buttons.CategoryButtonSkin;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   import projects.tanks.client.panel.model.quest.QuestTypeEnum;
   import projects.tanks.clients.fp10.libraries.TanksLocale;
   import logic.networking.Network;
   import logic.networking.INetworker;
   import alternativa.init.Main;

   public class QuestTabButtonsList extends DiscreteSprite
   {

      [Inject]
      public static var localeService:ILocaleService;

      [Inject]
      public static var starsEventService:ChallengeInfoService;

      public static var BUTTON_HEIGHT:int = 30;

      private static var BUTTON_WIDTH:int = 120;

      public var questCategoryToButton:Dictionary;

      private var tabButtons:Vector.<QuestTabButton>;

      private var currentQuestType:QuestTypeEnum;

      private var panelWidth:int = 0;

      public function QuestTabButtonsList()
      {
         this.questCategoryToButton = new Dictionary();
         this.tabButtons = new Vector.<QuestTabButton>();
         super();
      }

      public function addCategoryButton(param1:QuestTypeEnum):void
      {
         var _loc2_:QuestTabButton = null;
         switch (param1)
         {
            case QuestTypeEnum.MAIN:
               _loc2_ = this.createCategoryButton(QuestTypeEnum.MAIN, "Special");
               _loc2_.setSkin(CategoryButtonSkin.createDisableButtonSkin());
               this.addToPanel(_loc2_);
               break;
            case QuestTypeEnum.DAILY:
               this.addToPanel(this.createCategoryButton(QuestTypeEnum.DAILY, "Daily"));
               break;
            case QuestTypeEnum.WEEKLY:
               this.addToPanel(this.createCategoryButton(QuestTypeEnum.WEEKLY, "Weekly"));
               break;
            case QuestTypeEnum.CHALLENGE:
               _loc2_ = this.createCategoryButton(QuestTypeEnum.CHALLENGE, "Challenges");
               this.addToPanel(_loc2_);
               _loc2_.setSkin(CategoryButtonSkin.createDisableButtonSkin());
         }
      }

      private function addToPanel(param1:QuestTabButton):void
      {
         var _loc2_:int = this.panelWidth == 0 ? 0 : 10;
         param1.x = this.panelWidth + _loc2_;
         this.panelWidth += BUTTON_WIDTH + _loc2_;
         addChild(param1);
      }

      private function createCategoryButton(param1:QuestTypeEnum, param2:String):QuestTabButton
      {
         var _loc3_:QuestTabButton = new QuestTabButton(param1, param2);
         this.questCategoryToButton[param1] = _loc3_;
         this.tabButtons.push(_loc3_);
         _loc3_.addEventListener(MouseEvent.CLICK, this.onButtonClick);
         return _loc3_;
      }

      private function onButtonClick(param1:MouseEvent):void
      {
         var _loc2_:QuestTypeEnum = param1.currentTarget.getQuestType();
         if (this.currentQuestType != _loc2_)
         {
            if (_loc2_ == QuestTypeEnum.MAIN)
            {
               navigateToURL(new URLRequest("http://my.4399.com/forums/mtag-81938-1928?go_anc_kind"), "_blank");
            }
            else
            {
               if (_loc2_ == QuestTypeEnum.CHALLENGE)
               {
               }
               this.selectTabButton(_loc2_);
            }
         }
      }

      public function selectTabButton(param1:QuestTypeEnum):void
      {
         if (Boolean(this.currentQuestType))
         {
            this.questCategoryToButton[this.currentQuestType].enabled = true;
         }
         this.questCategoryToButton[param1].enabled = false;
         this.currentQuestType = param1;
         dispatchEvent(new SelectTabEvent(param1));
      }

      override public function get height():Number
      {
         return BUTTON_HEIGHT;
      }

      override public function get width():Number
      {
         return this.panelWidth;
      }

      public function destroy():void
      {
         var _loc1_:QuestTabButton = null;
         for each (_loc1_ in this.tabButtons)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK, this.onButtonClick);
         }
      }
   }
}
