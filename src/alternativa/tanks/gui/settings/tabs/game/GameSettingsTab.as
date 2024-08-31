package alternativa.tanks.gui.settings.tabs.game
{
   import alternativa.init.Main;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.tanks.gui.settings.SettingsWindow;
   import alternativa.tanks.gui.settings.tabs.SettingsTabView;
   import alternativa.tanks.gui.settings.tabs.SoundSettingsTab;
   import alternativa.tanks.gui.settings.tabs.game.sound.SoundSettingsTab;
   import alternativa.tanks.service.settings.SettingEnum;
   import controls.Label;
   import controls.TankWindowInner;
   import controls.checkbox.CheckBoxBase;
   import controls.containers.StackPanel;
   import controls.containers.VerticalStackPanel;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;

   public class GameSettingsTab extends SettingsTabView
   {

      private var storage:SharedObject;

      private var soundTab:SoundSettingsTab;
      private var cbDamage:CheckBoxBase;
      private var cbChat:CheckBoxBase;

      public function GameSettingsTab()
      {
         super();
         this.storage = IStorageService(Main.osgi.getService(IStorageService)).getStorage();

         var verticalStackPanel:VerticalStackPanel = new VerticalStackPanel();
         verticalStackPanel.x = MARGIN;
         verticalStackPanel.y = MARGIN;
         verticalStackPanel.setMargin(MARGIN);
         this.cbDamage = createCheckBox(SettingEnum.SHOW_DAMAGE, "Show damage", this.storage.data["animatedDamage"]);
         verticalStackPanel.addItem(this.cbDamage);
         // _loc2_.addItem(createCheckBox(SettingEnum.SHOW_DROP_ZONES,"Show droppzones",false));
         verticalStackPanel.addItem(createCheckBox(SettingEnum.ALTERNATE_CAMERA, "Alternative camera behavior", false));
         var _loc3_:VerticalStackPanel = new VerticalStackPanel();
         _loc3_.setMargin(MARGIN);
         _loc3_.y = MARGIN;
         _loc3_.x = SettingsWindow.TAB_VIEW_MAX_WIDTH * 0.5;
         this.cbChat = createCheckBox(SettingEnum.SHOW_CHAT, "Show chat", this.storage.data["showBattleChat"]);
         _loc3_.addItem(this.cbChat);

         var _loc4_:TankWindowInner = new TankWindowInner(SettingsWindow.TAB_VIEW_MAX_WIDTH, verticalStackPanel.height + 2 * MARGIN, TankWindowInner.TRANSPARENT);
         _loc4_.addChild(verticalStackPanel);
         _loc4_.addChild(_loc3_);
         addChild(_loc4_);
         var _loc5_:StackPanel = new StackPanel();
         _loc5_ = this.createSoundPanel();
         _loc5_.y = _loc4_.y + _loc4_.height + MARGIN_BEFORE_PARTITION_LABEL;
         addChild(_loc5_);
      }

      public function saveData():void
      {

         this.storage.data["animatedDamage"] = this.cbDamage.checked;
         this.storage.data["showBattleChat"] = this.cbChat.checked;
         IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["bgSound"] = this.soundTab.bgSound.checked;
      }

      private function createSoundPanel():StackPanel
      {
         var _loc1_:VerticalStackPanel = new VerticalStackPanel();
         _loc1_.setMargin(MARGIN_AFTER_PARTITION_LABEL);
         var _loc2_:Label = new Label();
         _loc2_.text = "Sound";
         _loc1_.addItem(_loc2_);
         this.soundTab = new SoundSettingsTab();
         _loc1_.addItem(this.soundTab);
         return _loc1_;
      }

      protected function createCheckBoxWithoutAutoSave(param1:String, param2:Boolean, param3:int = 0, param4:int = 0):CheckBoxBase
      {
         var _loc5_:CheckBoxBase = new CheckBoxBase();
         _loc5_.checked = param2;
         _loc5_.x = param3;
         _loc5_.y = param4;
         _loc5_.label = param1;
         return _loc5_;
      }

      override public function destroy():void
      {
         this.soundTab.destroy();
         super.destroy();
      }
   }
}
