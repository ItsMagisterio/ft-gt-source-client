package alternativa.tanks.gui.settings
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.gui.settings.controls.TabButton;
   import alternativa.tanks.gui.settings.controls.TabIcons;
   import alternativa.tanks.gui.settings.tabs.SettingsTabView;
   import base.DiscreteSprite;
   import controls.containers.HorizontalStackPanel;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;

   public class SettingsTabButtonList extends DiscreteSprite
   {

      [Inject]
      public static var localeService:ILocaleService;

      private var settingsCategoryToButton:Dictionary;

      private var tabButtons:Vector.<TabButton>;

      private var currentCategory:SettingsCategoryEnum;

      private var buttonPanel:HorizontalStackPanel;

      public function SettingsTabButtonList()
      {
         this.settingsCategoryToButton = new Dictionary();
         this.tabButtons = new Vector.<TabButton>();
         this.buttonPanel = new HorizontalStackPanel();
         super();
         this.buttonPanel.setMargin(SettingsTabView.MARGIN);
         addChild(this.buttonPanel);
      }

      public function addCategoryButton(param1:SettingsCategoryEnum):void
      {
         switch (param1)
         {
            case SettingsCategoryEnum.GAME:
               this.buttonPanel.addItem(this.createCategoryButton(SettingsCategoryEnum.GAME, "Game", TabIcons.gameTabIconClass));
               break;
            case SettingsCategoryEnum.GRAPHIC:
               this.buttonPanel.addItem(this.createCategoryButton(SettingsCategoryEnum.GRAPHIC, "Graphics", TabIcons.graphicTabIconClass));
               break;
            case SettingsCategoryEnum.ACCOUNT:
               this.buttonPanel.addItem(this.createCategoryButton(SettingsCategoryEnum.ACCOUNT, "Account", TabIcons.accountTabIconClass));
               break;
            case SettingsCategoryEnum.CONTROL:
               this.buttonPanel.addItem(this.createCategoryButton(SettingsCategoryEnum.CONTROL, "Controls", TabIcons.controlTabIconClass));
         }
      }

      private function createCategoryButton(param1:SettingsCategoryEnum, param2:String, param3:Class):TabButton
      {
         var _loc4_:TabButton = new TabButton(param1, param2, param3);
         this.settingsCategoryToButton[param1] = _loc4_;
         _loc4_.width = SettingsWindow.BUTTON_WIDTH;
         this.tabButtons.push(_loc4_);
         _loc4_.addEventListener(MouseEvent.CLICK, this.onButtonClick);
         return _loc4_;
      }

      private function onButtonClick(param1:MouseEvent):void
      {
         var _loc2_:SettingsCategoryEnum = param1.currentTarget.getCategory();
         if (this.currentCategory != _loc2_)
         {
            this.selectTabButton(_loc2_);
         }
      }

      public function selectTabButton(param1:SettingsCategoryEnum):void
      {
         if (this.currentCategory)
         {
            this.settingsCategoryToButton[this.currentCategory].enabled = true;
         }
         this.settingsCategoryToButton[param1].enabled = false;
         this.currentCategory = param1;
         dispatchEvent(new SelectTabEvent(param1));
      }

      override public function get height():Number
      {
         return this.tabButtons[0].height;
      }

      override public function get width():Number
      {
         return this.buttonPanel.width;
      }

      public function destroy():void
      {
         var _loc1_:TabButton = null;
         for each (_loc1_ in this.tabButtons)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK, this.onButtonClick);
         }
      }
   }
}
