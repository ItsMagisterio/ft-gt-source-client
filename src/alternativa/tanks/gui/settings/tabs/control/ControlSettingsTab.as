package alternativa.tanks.gui.settings.tabs.control
{
    import alternativa.init.Main;
    import alternativa.tanks.gui.settings.SettingsWindow;
    import alternativa.tanks.gui.settings.tabs.ScrollableSettingsTabView;
    import alternativa.tanks.service.settings.SettingEnum;

    import base.DiscreteSprite;

    import controls.Slider;
    import controls.TankWindowInner;
    import controls.base.LabelBase;
    import controls.containers.VerticalStackPanel;

    import forms.events.SliderEvent;

    import projects.tanks.clients.fp10.libraries.tanksservices.service.fullscreen.FullscreenService;
    import alternativa.osgi.service.storage.IStorageService;
    import alternativa.tanks.camera.FollowCameraController;

    public class ControlSettingsTab extends ScrollableSettingsTabView
    {

        public static const MIN_SENSITIVITY_MOUSE:int = 1;

        public static const MAX_SENSITIVITY_MOUSE:int = 20;

        private var fullScreenService:FullscreenService;
        private var keyBindingPanel:KeyBindingsPanel;
        private var mouseSensitivity:Slider;

        public function ControlSettingsTab()
        {
            super();
            this.fullScreenService = Main.osgi.getService(FullscreenService) as FullscreenService;
            var _loc1_:TankWindowInner = new TankWindowInner(SettingsWindow.TAB_VIEW_MAX_WIDTH, SettingsWindow.TAB_VIEW_MAX_HEIGHT, TankWindowInner.TRANSPARENT);
            addChildAt(_loc1_, 0);
            var verticalStackPanel:VerticalStackPanel = new VerticalStackPanel();
            verticalStackPanel.setMargin(MARGIN);
            verticalStackPanel.x = MARGIN;
            verticalStackPanel.y = TOP_MARGIN_FOR_SCROLL_TAB;

            verticalStackPanel.addItem(this.createMouseControlPanel());
            this.keyBindingPanel = new KeyBindingsPanel();
            verticalStackPanel.addItem(createCheckBox(SettingEnum.INVERSE_BACK_DRIVING, "Inverse turn controls when going backwards", false));
            verticalStackPanel.addItem(this.keyBindingPanel);
            addItem(verticalStackPanel);
        }

        private function createMouseControlPanel():DiscreteSprite
        {
            var _loc1_:VerticalStackPanel = new VerticalStackPanel();
            _loc1_.setMargin(MARGIN);
            _loc1_.addItem(createCheckBox(SettingEnum.MOUSE_CONTROL, "Mouse controls", (IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["mouseEnabled"] == "true") ? true : false));
            _loc1_.addItem(this.createMouseSensitivityBlock());
            _loc1_.addItem(createCheckBox(SettingEnum.MOUSE_Y_INVERSE, "Mouse turn vertical inversion", false));
            _loc1_.addItem(createCheckBox(SettingEnum.MOUSE_Y_INVERSE_SHAFT_AIM, "Mouse view vertical for shaft aim", false));
            return _loc1_;
        }

        private function createMouseSensitivityBlock():DiscreteSprite
        {
            var _loc1_:DiscreteSprite = new DiscreteSprite();
            var _loc2_:LabelBase = new LabelBase();
            _loc2_.text = "Mouse look sensitivity:";
            _loc1_.addChild(_loc2_);
            this.mouseSensitivity = new Slider();
            this.mouseSensitivity.maxValue = MAX_SENSITIVITY_MOUSE;
            this.mouseSensitivity.minValue = MIN_SENSITIVITY_MOUSE;
            this.mouseSensitivity.tickInterval = 1;
            this.mouseSensitivity.x = int(_loc2_.x + _loc2_.textWidth + MARGIN);
            this.mouseSensitivity.y = MARGIN;
            this.mouseSensitivity.width = SettingsWindow.TAB_VIEW_MAX_WIDTH - 2 * MARGIN - _loc2_.width - 30;
            this.mouseSensitivity.value = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["mouseSens"];
            // this.volume = ;
            this.mouseSensitivity.addEventListener(SliderEvent.CHANGE_VALUE, this.onChangeMouseSensitivity);
            _loc2_.y = Math.round((this.mouseSensitivity.height - _loc2_.textHeight) * 0.5) - 2;
            _loc1_.addChild(this.mouseSensitivity);
            return _loc1_;
        }

        private function onChangeMouseSensitivity(param1:SliderEvent):void
        {
            IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["mouseSens"] = mouseSensitivity.value;
            FollowCameraController.setMouseSensitivity(mouseSensitivity.value);
        }

        override public function destroy():void
        {
            if (this.mouseSensitivity != null)
            {
                this.mouseSensitivity.removeEventListener(SliderEvent.CHANGE_VALUE, this.onChangeMouseSensitivity);
            }
            this.keyBindingPanel.destroy();
            super.destroy();
        }
    }
}
