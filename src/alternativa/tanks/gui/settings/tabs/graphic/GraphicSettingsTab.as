package alternativa.tanks.gui.settings.tabs.graphic
{
    import alternativa.tanks.gui.settings.tabs.*;
    import alternativa.init.Main;
    import alternativa.osgi.service.storage.IStorageService;
    import alternativa.tanks.gui.settings.SettingsWindow;
    import alternativa.tanks.gui.settings.controls.GridLayout;
    import alternativa.tanks.service.settings.SettingEnum;

    import controls.TankWindowInner;
    import controls.checkbox.CheckBoxBase;

    import flash.events.MouseEvent;
    import flash.net.SharedObject;

    public class GraphicSettingsTab extends SettingsTabView
    {

        private var performanceInner:TankWindowInner;

        private var cbShowFPS:CheckBoxBase;

        private var cbAdaptiveFPS:CheckBoxBase;

        private var cbShowSkyBox:CheckBoxBase;

        private var cbAntialiasing:CheckBoxBase;

        private var cbDynamicLighting:CheckBoxBase;

        private var cbMipMapping:CheckBoxBase;

        private var cbFog:CheckBoxBase;

        private var cbTankShadow:CheckBoxBase;

        private var cbDynamicShadows:CheckBoxBase;

        private var cbSoftParticles:CheckBoxBase;

        private var cbDust:CheckBoxBase;

        private var cbSSAO:CheckBoxBase;

        private var storage:SharedObject;

        public function GraphicSettingsTab()
        {
            this.storage = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
            var _loc2_:int = 0;
            super();
            this.performanceInner = new TankWindowInner(0, 0, TankWindowInner.TRANSPARENT);
            this.performanceInner.width = SettingsWindow.TAB_VIEW_MAX_WIDTH;
            this.performanceInner.y = 0;
            this.performanceInner.x = 0;
            addChild(this.performanceInner);
            this.cbShowFPS = createCheckBox(SettingEnum.SHOW_FPS, "Show FPS and PING", this.storage.data["COLORED_FPS"]);
            addChild(this.cbShowFPS);
            this.cbAdaptiveFPS = createCheckBox(SettingEnum.ADAPTIVE_FPS, "Adaptive FPS", this.storage.data["adaptiveFPS"]);
            addChild(this.cbAdaptiveFPS);
            this.cbShowSkyBox = createCheckBox(SettingEnum.SHOW_SKY_BOX, "Show the skybox", this.storage.data["showSkyBox"]);
            addChild(this.cbShowSkyBox);
            this.cbMipMapping = createCheckBox(SettingEnum.MIPMAPPING, "Mip-mapping", this.storage.data["mipMapping"]);
            addChild(this.cbMipMapping);
            var _loc1_:GridLayout = new GridLayout(MARGIN, MARGIN, SettingsWindow.TAB_VIEW_MAX_WIDTH * 0.5, this.cbShowFPS.height + MARGIN);
            this.cbFog = createCheckBox(SettingEnum.FOG, "Fog", this.storage.data["fog"]);
            addChild(this.cbFog);
            this.cbTankShadow = createCheckBox(SettingEnum.SHADOWS_UNDER_TANK, "Shadow under tank", this.storage.data["shadowUnderTanks"]);
            addChild(this.cbTankShadow);
            this.cbDynamicShadows = createCheckBox(SettingEnum.DYNAMIC_SHADOWS, "Dynamic shadows", this.storage.data["shadows"]);
            addChild(this.cbDynamicShadows);
            this.cbSoftParticles = createCheckBox(SettingEnum.SOFT_PARTICLES, "Soft particles", this.storage.data["soft_particle"]);
            addChild(this.cbSoftParticles);
            this.cbSoftParticles.addEventListener(MouseEvent.CLICK, this.onSoftParticlesClick);
            this.cbDust = createCheckBox(SettingEnum.DUST, "Dust", this.storage.data["dust"]);
            addChild(this.cbDust);
            this.cbSSAO = createCheckBox(SettingEnum.SSAO, "Deep shadows", this.storage.data["use_ssao"]);
            addChild(this.cbSSAO);
            this.cbAntialiasing = createCheckBox(SettingEnum.ANTIALIASING, "Antialiasing", this.storage.data["antiAlias"]);
            addChild(this.cbAntialiasing);
            this.cbDynamicLighting = createCheckBox(SettingEnum.DYNAMIC_LIGHTING, "Dynamic lighting", this.storage.data["defferedLighting"]);
            addChild(this.cbDynamicLighting);
            _loc2_ = this.layoutPerformanceFull(_loc1_);

            this.performanceInner.height = _loc2_ + MARGIN;
        }

        public function saveData():void
        {
            this.storage.data["COLORED_FPS"] = this.cbShowFPS.checked;
            this.storage.data["adaptiveFPS"] = this.cbAdaptiveFPS.checked;
            this.storage.data["showSkyBox"] = this.cbShowSkyBox.checked;
            this.storage.data["mipMapping"] = this.cbMipMapping.checked;
            this.storage.data["fog"] = this.cbFog.checked;
            this.storage.data["shadowUnderTanks"] = this.cbTankShadow.checked;
            this.storage.data["shadows"] = this.cbDynamicShadows.checked;
            this.storage.data["soft_particle"] = this.cbSoftParticles.checked;
            this.storage.data["dust"] = this.cbDust.checked;
            this.storage.data["use_ssao"] = this.cbSSAO.checked;
            this.storage.data["defferedLighting"] = this.cbDynamicLighting.checked;
            this.storage.data["antiAlias"] = this.cbAntialiasing.checked;
        }

        private function onSoftParticlesClick(param1:MouseEvent):void
        {
            this.checkDustAvailable();
        }

        private function checkDustAvailable():void
        {
            this.cbDust.visible = this.cbSoftParticles && this.cbSoftParticles.checked;
        }

        private function layoutPerformanceConstrained(param1:GridLayout):int
        {
            return param1.layout([[this.cbShowFPS, this.cbAdaptiveFPS], [this.cbShowSkyBox, this.cbMipMapping]]);
        }

        private function layoutPerformanceFull(param1:GridLayout):int
        {
            return param1.layout([[this.cbShowFPS, this.cbAdaptiveFPS], [this.cbShowSkyBox, this.cbMipMapping], [this.cbDynamicShadows, this.cbSSAO], [this.cbDynamicLighting, this.cbFog], [this.cbTankShadow, this.cbAntialiasing], [this.cbSoftParticles, this.cbDust]]);
        }

        override public function destroy():void
        {
            this.cbSoftParticles.removeEventListener(MouseEvent.CLICK, this.onSoftParticlesClick);

            super.destroy();
        }
    }
}
