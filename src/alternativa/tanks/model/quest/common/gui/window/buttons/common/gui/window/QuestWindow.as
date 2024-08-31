package alternativa.tanks.model.quest.common.gui.window
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.quest.challenge.gui.ChallengesTab;
   import alternativa.tanks.model.quest.common.MissionsWindowsService;
   import alternativa.tanks.model.quest.common.gui.CommonQuestTab;
   import alternativa.tanks.model.quest.common.gui.window.events.QuestWindowCloseEvent;
   import alternativa.tanks.model.quest.common.gui.window.navigatepanel.QuestTabButtonsList;
   import alternativa.tanks.model.quest.common.gui.window.navigatepanel.SelectTabEvent;
   import alternativa.tanks.model.quest.daily.gui.DailyQuestTab;
   import alternativa.tanks.model.quest.weekly.gui.WeeklyQuestTab;
   import controls.base.DefaultButtonBase;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import forms.TankWindowWithHeader;
   import forms.events.MainButtonBarEvents;
   import projects.tanks.client.panel.model.quest.QuestTypeEnum;
   import projects.tanks.clients.flash.commons.services.flashshutdown.FlashShutdownService;
   import projects.tanks.clients.fp10.libraries.TanksLocale;
   import projects.tanks.clients.fp10.libraries.tanksservices.service.dialogs.gui.DialogWindow;
   import projects.tanks.clients.fp10.libraries.tanksservices.service.logging.gamescreen.UserChangeGameScreenService;
   import services.buttonbar.IButtonBarService;

   public class QuestWindow extends DialogWindow implements MissionsWindowsService
   {

      public static const BORDER_MARGIN:int = 12;

      public static const INNER_MARGIN:int = 8;

      public static const WINDOW_WIDTH:int = 868 + INNER_MARGIN;

      public static const WINDOW_HEIGHT:int = 460 + INNER_MARGIN;

      [Inject]
      public static var localeService:ILocaleService;

      [Inject]
      public static var userChangeGameScreenService:UserChangeGameScreenService;

      [Inject]
      public static var buttonBarService:IButtonBarService;

      [Inject]
      public static var flashShutdownService:FlashShutdownService;

      private var isOpened:Boolean;

      private var window:TankWindowWithHeader;

      private var navigateTabPanel:QuestTabButtonsList;

      private var closeButton:DefaultButtonBase;

      private var tabViews:Dictionary;

      private var currentTab:alternativa.tanks.model.quest.common.gui.window.QuestsTabView = null;

      private var inited:Boolean = false;

      public function QuestWindow()
      {
         this.tabViews = new Dictionary();
         super();
         this.createTabs();
      }

      public function initWindow():void
      {
         if (!this.inited)
         {
            buttonBarService.addEventListener(MainButtonBarEvents.PANEL_BUTTON_PRESSED, this.onButtonBarButtonClick);
            this.addWindow();
            this.addNavigatePanel();
            this.addCloseButton();
            this.inited = true;
         }
      }

      private function createTabs():void
      {
         this.createDailyTab();
         this.createWeeklyTab();
         this.createChallengeTab();
      }

      private function onButtonBarButtonClick(param1:MainButtonBarEvents):void
      {
         if (param1.typeButton == MainButtonBarEvents.QUESTS)
         {
            this.openInTab(QuestTypeEnum.DAILY);
         }
      }

      private function addNavigatePanel():void
      {
         var _loc1_:alternativa.tanks.model.quest.common.gui.window.QuestsTabView = null;
         this.navigateTabPanel = new QuestTabButtonsList();
         this.navigateTabPanel.addCategoryButton(QuestTypeEnum.MAIN);
         this.navigateTabPanel.addCategoryButton(QuestTypeEnum.DAILY);
         this.navigateTabPanel.addCategoryButton(QuestTypeEnum.WEEKLY);
         this.navigateTabPanel.addCategoryButton(QuestTypeEnum.CHALLENGE);
         this.navigateTabPanel.x = BORDER_MARGIN;
         this.navigateTabPanel.y = BORDER_MARGIN;
         addChild(this.navigateTabPanel);
         this.navigateTabPanel.selectTabButton(QuestTypeEnum.DAILY);
         for each (_loc1_ in this.tabViews)
         {
            this.alignTabByNavPanel(_loc1_);
         }
      }

      private function addWindow():void
      {
         this.window = TankWindowWithHeader.createWindow(TanksLocale.TEXT_HEADER_MISSIONS, WINDOW_WIDTH, WINDOW_HEIGHT);
         addChild(this.window);
      }

      private function addCloseButton():void
      {
         this.closeButton = new DefaultButtonBase();
         this.closeButton.label = localeService.getText(TanksLocale.TEXT_CLOSE_LABEL);
         this.closeButton.x = WINDOW_WIDTH - this.closeButton.width - BORDER_MARGIN;
         this.closeButton.y = WINDOW_HEIGHT - this.closeButton.height - BORDER_MARGIN;
         this.window.addChild(this.closeButton);
      }

      private function createDailyTab():void
      {
         var _loc1_:DailyQuestTab = new DailyQuestTab();
         this.tabViews[QuestTypeEnum.DAILY] = _loc1_;
      }

      private function createWeeklyTab():void
      {
         var _loc1_:WeeklyQuestTab = new WeeklyQuestTab();
         this.tabViews[QuestTypeEnum.WEEKLY] = _loc1_;
      }

      private function createChallengeTab():void
      {
         var _loc1_:ChallengesTab = new ChallengesTab();
         this.tabViews[QuestTypeEnum.CHALLENGE] = _loc1_;
      }

      private function alignTabByNavPanel(param1:alternativa.tanks.model.quest.common.gui.window.QuestsTabView):void
      {
         param1.x = BORDER_MARGIN;
         param1.y = this.navigateTabPanel.y + this.navigateTabPanel.height + INNER_MARGIN;
      }

      private function tabSelected(param1:SelectTabEvent):void
      {
         this.selectTab(param1.selectedType);
      }

      private function selectTab(param1:QuestTypeEnum):void
      {
         if (this.currentTab != null && this.window.contains(this.currentTab))
         {
            this.currentTab.hide();
            this.window.removeChild(this.currentTab);
         }
         var _loc2_:alternativa.tanks.model.quest.common.gui.window.QuestsTabView = this.tabViews[param1];
         if (_loc2_ != null)
         {
            this.currentTab = _loc2_;
            this.window.addChild(this.currentTab);
            this.currentTab.show();
         }
      }

      private function onCloseButtonClick(param1:MouseEvent = null):void
      {
         this.closeWindow();
      }

      public function closeWindow():void
      {
         var _loc1_:alternativa.tanks.model.quest.common.gui.window.QuestsTabView = null;
         if (!this.isOpened)
         {
            return;
         }
         this.removeListeners();
         dispatchEvent(new QuestWindowCloseEvent(QuestWindowCloseEvent.QUEST_WINDOW_CLOSE));
         userChangeGameScreenService.questWindowClosed();
         this.clearCurrentTab();
         for each (_loc1_ in this.tabViews)
         {
            _loc1_.close();
         }
         dialogService.removeDialog(this);
         this.isOpened = false;
      }

      private function clearCurrentTab():void
      {
         if (this.currentTab != null && this.window.contains(this.currentTab))
         {
            this.window.removeChild(this.currentTab);
         }
         this.currentTab = null;
      }

      private function removeListeners():void
      {
         this.navigateTabPanel.removeEventListener(SelectTabEvent.SELECT_QUESTS_TAB, this.tabSelected);
         this.closeButton.removeEventListener(MouseEvent.CLICK, this.onCloseButtonClick);
      }

      override protected function cancelKeyPressed():void
      {
         this.closeWindow();
      }

      override protected function confirmationKeyPressed():void
      {
         this.closeWindow();
      }

      override public function get width():Number
      {
         return this.window.width;
      }

      public function getQuestTab(param1:QuestTypeEnum):CommonQuestTab
      {
         return this.tabViews[param1];
      }

      public function getDailyQuestsTab():DailyQuestTab
      {
         return this.tabViews[QuestTypeEnum.DAILY];
      }

      public function getWeeklyQuestsTab():WeeklyQuestTab
      {
         return this.tabViews[QuestTypeEnum.WEEKLY];
      }

      public function getChallengesTab():ChallengesTab
      {
         return this.tabViews[QuestTypeEnum.CHALLENGE];
      }

      public function openInTab(param1:QuestTypeEnum):void
      {
         if (!flashShutdownService.fullFeaturesEnabled)
         {
            flashShutdownService.gotoHtml5();
            return;
         }
         if (this.isOpened)
         {
            return;
         }
         this.isOpened = true;
         userChangeGameScreenService.questWindowOpened();
         this.navigateTabPanel.selectTabButton(param1);
         this.selectTab(param1);
         this.prepareToOpen();
         dialogService.enqueueDialog(this);
      }

      private function prepareToOpen():void
      {
         this.navigateTabPanel.addEventListener(SelectTabEvent.SELECT_QUESTS_TAB, this.tabSelected);
         this.closeButton.addEventListener(MouseEvent.CLICK, this.onCloseButtonClick);
      }

      public function isWindowOpen():Boolean
      {
         return this.isOpened;
      }
   }
}
