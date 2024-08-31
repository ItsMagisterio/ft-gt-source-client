package alternativa.tanks.gui.settings
{
    import alternativa.tanks.gui.settings.tabs.SettingsTabView;
    import alternativa.tanks.gui.settings.tabs.game.GameSettingsTab;
    import alternativa.tanks.gui.settings.tabs.graphic.GraphicSettingsTab;

    import controls.base.DefaultButtonBase;

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;

    import forms.TankWindowWithHeader;

    import alternativa.tanks.gui.settings.tabs.account.AccountSettingsTab;
    import alternativa.tanks.gui.settings.tabs.control.ControlSettingsTab;

    public class SettingsWindow extends Sprite
    {

        public static const WINDOW_MARGIN:int = 12;

        public static const BUTTON_HEIGHT:int = 33;

        public static const BUTTON_WIDTH:int = 104;

        private static const WINDOW_WIDTH:int = 775;

        public static const TAB_VIEW_MAX_WIDTH:int = WINDOW_WIDTH - 2 * WINDOW_MARGIN;

        private static const WINDOW_HEIGHT:int = 560;

        private static const MARGIN:int = 8;

        public static const TAB_VIEW_MAX_HEIGHT:int = WINDOW_HEIGHT - 2 * WINDOW_MARGIN - 2 * BUTTON_HEIGHT - MARGIN;

        private var closeButton:DefaultButtonBase;

        private var navigateTabPanel:SettingsTabButtonList;

        private var tabViews:Dictionary;

        private var currentTab:SettingsTabView = null;

        public function SettingsWindow()
        {
            this.tabViews = new Dictionary();
            super();
            var tankWindowWithHeader:TankWindowWithHeader = TankWindowWithHeader.createWindow("SETTINGS");
            addChild(tankWindowWithHeader);
            this.navigateTabPanel = new SettingsTabButtonList();
            this.navigateTabPanel.addCategoryButton(SettingsCategoryEnum.GAME);
            this.navigateTabPanel.addCategoryButton(SettingsCategoryEnum.GRAPHIC);
            this.navigateTabPanel.addCategoryButton(SettingsCategoryEnum.ACCOUNT);
            this.navigateTabPanel.addCategoryButton(SettingsCategoryEnum.CONTROL);

            this.navigateTabPanel.selectTabButton(SettingsCategoryEnum.GAME);
            this.navigateTabPanel.x = this.navigateTabPanel.y = WINDOW_MARGIN;
            this.navigateTabPanel.addEventListener(SelectTabEvent.SELECT_SETTING_TAB, this.tabSelected);
            addChild(this.navigateTabPanel);
            createTabs();
            this.closeButton = new DefaultButtonBase();
            addChild(this.closeButton);
            this.closeButton.label = "Close";
            this.closeButton.x = WINDOW_WIDTH - this.closeButton.width - WINDOW_MARGIN;
            this.closeButton.y = WINDOW_HEIGHT - this.closeButton.height - WINDOW_MARGIN;
            this.closeButton.addEventListener(MouseEvent.CLICK, this.onCloseClick);
            tankWindowWithHeader.height = WINDOW_HEIGHT;
            tankWindowWithHeader.width = WINDOW_WIDTH;
            this.navigateTabPanel.selectTabButton(SettingsCategoryEnum.GAME);
        }

        private function createTabs():void
        {
            var graphicSettingsTab:GraphicSettingsTab = new GraphicSettingsTab();
            graphicSettingsTab.y = this.navigateTabPanel.y + this.navigateTabPanel.height + MARGIN;
            graphicSettingsTab.x = WINDOW_MARGIN;
            this.tabViews[SettingsCategoryEnum.GRAPHIC] = graphicSettingsTab;

            var gameSettingsTab:GameSettingsTab = new GameSettingsTab();
            gameSettingsTab.y = this.navigateTabPanel.y + this.navigateTabPanel.height + MARGIN;
            gameSettingsTab.x = WINDOW_MARGIN;
            this.tabViews[SettingsCategoryEnum.GAME] = gameSettingsTab;

            var accountSettingsTab:AccountSettingsTab = new AccountSettingsTab();
            accountSettingsTab.y = this.navigateTabPanel.y + this.navigateTabPanel.height + MARGIN;
            accountSettingsTab.x = WINDOW_MARGIN;
            this.tabViews[SettingsCategoryEnum.ACCOUNT] = accountSettingsTab;

            var controlSettingsTabtr:ControlSettingsTab = new ControlSettingsTab();
            controlSettingsTabtr.y = this.navigateTabPanel.y + this.navigateTabPanel.height + MARGIN;
            controlSettingsTabtr.x = WINDOW_MARGIN;
            this.tabViews[SettingsCategoryEnum.CONTROL] = controlSettingsTabtr;
        }

        private function tabSelected(param1:SelectTabEvent):void
        {
            if (this.currentTab != null && contains(this.currentTab))
            {
                this.currentTab.hide();
                removeChild(this.currentTab);
            }
            var settingsTabView:SettingsTabView = this.tabViews[param1.getSelectedCategory()];
            if (settingsTabView != null)
            {
                this.currentTab = settingsTabView;
                addChild(this.currentTab);
                this.currentTab.show();
            }
        }

        public function saveData():void
        {
            this.tabViews[SettingsCategoryEnum.GRAPHIC].saveData();
            this.tabViews[SettingsCategoryEnum.GAME].saveData();
        }

        private function onCloseClick(param1:MouseEvent = null):void
        {
            destroy();
            dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.CLOSE_SETTINGS));
        }

        public function destroy():void
        {
            this.closeButton.removeEventListener(MouseEvent.CLICK, this.onCloseClick);
            this.navigateTabPanel.removeEventListener(SelectTabEvent.SELECT_SETTING_TAB, this.tabSelected);
            this.navigateTabPanel.destroy();
            for each (var settingsTabView:SettingsTabView in this.tabViews)
            {
                settingsTabView.destroy();
            }
        }
    }
}