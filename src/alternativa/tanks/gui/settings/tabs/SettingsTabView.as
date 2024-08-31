package alternativa.tanks.gui.settings.tabs
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.gui.settings.controls.CheckBoxSetting;
   import alternativa.tanks.gui.settings.controls.SettingControl;
   import alternativa.tanks.service.settings.SettingEnum;
   import base.DiscreteSprite;

   import controls.base.LabelBase;

   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.init.Main;

   public class SettingsTabView extends DiscreteSprite
   {

      public static const MARGIN:int = 8;

      public static const MARGIN_BEFORE_PARTITION_LABEL:int = 10;

      public static const MARGIN_AFTER_PARTITION_LABEL:int = 3;

      protected var settingsWithEvent:Vector.<DisplayObject>;

      public function SettingsTabView()
      {
         this.settingsWithEvent = new Vector.<DisplayObject>();
         super();
      }

      public function show():void
      {
      }

      public function hide():void
      {
      }
      protected function createLabel(text:String):LabelBase
      {
         var label:LabelBase = new LabelBase();
         label.text = text;
         return label;
      }

      protected function createCheckBox(setting:SettingEnum, label:String, isChecked:Boolean, x:int = 0, y:int = 0):CheckBoxSetting
      {
         var checkBoxSetting:CheckBoxSetting = new CheckBoxSetting(setting, label);
         checkBoxSetting.checked = isChecked;
         checkBoxSetting.addEventListener(MouseEvent.CLICK, this.onControlClick);
         checkBoxSetting.x = x;
         checkBoxSetting.y = y;
         this.settingsWithEvent.push(checkBoxSetting);
         checkBoxSetting.label = label;
         return checkBoxSetting;
      }

      protected function onControlClick(e:MouseEvent):void
      {
         if (e.target)
         {

            // TODO: optimize this
            if(e.target is CheckBoxSetting){
               var target:CheckBoxSetting = e.target as CheckBoxSetting;
               if (target)
               {
                  switch (target.getSetting())
                  {
                     case SettingEnum.MOUSE_CONTROL:
                        IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["mouseEnabled"] = (target.checked ? "true" : "false");
                        trace(target.checked);
                        break;
                  }
               }
            }else if(e.target is LabelBase){
               var lTarget:CheckBoxSetting = (e.target as LabelBase).parent as CheckBoxSetting;
               if (lTarget)
               {
                  switch (lTarget.getSetting())
                  {
                     case SettingEnum.MOUSE_CONTROL:
                        IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["mouseEnabled"] = (lTarget.checked ? "true" : "false");
                        trace(lTarget.checked);
                        break;
                  }
               }
            }
         }
      }

      public function destroy():void
      {
         for each (var setting:CheckBoxSetting in this.settingsWithEvent)
         {
            setting.removeEventListener(MouseEvent.CLICK, this.onControlClick);
         }
      }
   }
}
