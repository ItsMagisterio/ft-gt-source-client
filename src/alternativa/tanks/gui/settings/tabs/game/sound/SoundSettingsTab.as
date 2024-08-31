package alternativa.tanks.gui.settings.tabs.game.sound
{
   import alternativa.tanks.gui.settings.tabs.*;
   import alternativa.init.Main;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.tanks.gui.settings.SettingsWindow;
   import alternativa.tanks.service.settings.SettingEnum;
   import controls.Slider;
   import controls.TankWindowInner;
   import controls.base.LabelBase;
   import controls.checkbox.CheckBoxBase;
   import forms.events.SliderEvent;

   public class SoundSettingsTab extends SettingsTabView
   {

      private var volumeLevel:Slider;

      public var bgSound:CheckBoxBase;

      public function SoundSettingsTab()
      {
         super();
         var _loc1_:TankWindowInner = new TankWindowInner(SettingsWindow.TAB_VIEW_MAX_WIDTH - 20, 0, TankWindowInner.TRANSPARENT);
         var _loc2_:LabelBase = new LabelBase();
         _loc1_.addChild(_loc2_);
         _loc2_.text = "Sound volume:";
         _loc2_.x = MARGIN;
         this.volumeLevel = new Slider();
         this.volumeLevel.maxValue = 100;
         this.volumeLevel.minValue = 0;
         this.volumeLevel.tickInterval = 5;
         this.volumeLevel.x = int(_loc2_.x + _loc2_.textWidth + MARGIN);
         this.volumeLevel.y = MARGIN;
         this.volumeLevel.width = SettingsWindow.TAB_VIEW_MAX_WIDTH - 2 * MARGIN - _loc2_.width - 30;
         this.volumeLevel.value = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["volume"] * 100;
         // this.volume = ;
         this.volumeLevel.addEventListener(SliderEvent.CHANGE_VALUE, this.onChangeVolume);
         _loc1_.addChild(this.volumeLevel);
         this.bgSound = createCheckBox(SettingEnum.BG_SOUND, "Background sound", false, MARGIN, 0);
         this.bgSound.x = int(MARGIN);
         this.bgSound.y = MARGIN + this.volumeLevel.y + this.volumeLevel.height;
         this.bgSound.checked = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["bgSound"];
         _loc1_.addChild(this.bgSound);
         _loc1_.height = MARGIN + this.bgSound.y + this.bgSound.height;
         _loc2_.y = this.volumeLevel.y + Math.round((this.volumeLevel.height - _loc2_.textHeight) * 0.5) - 2;
         addChild(_loc1_);
      }

      private function onChangeVolume(param1:SliderEvent):void
      {
         IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["bgSound"] = this.bgSound.checked;
         IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["volume"] = this.volumeLevel.value / 100;
      }

      override public function hide():void
      {
         super.hide();
      }

      public function getBgSound():Boolean
      {
         return this.bgSound.checked;
      }

      public function setBgSound(param1:Boolean):void
      {
         this.bgSound.checked = param1;
      }

      public function get volume():Number
      {
         return this.volumeLevel.value;
      }

      public function set volume(param1:Number):void
      {
         this.volumeLevel.value = int(param1 * 100);
      }

      override public function destroy():void
      {
         this.volumeLevel.removeEventListener(SliderEvent.CHANGE_VALUE, this.onChangeVolume);
         super.destroy();
      }
   }
}
