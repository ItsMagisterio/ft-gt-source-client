package alternativa.tanks.gui.settings.tabs.control
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.gui.settings.SettingsWindow;
   import alternativa.tanks.gui.settings.tabs.SettingsTabView;
   import alternativa.tanks.service.settings.keybinding.GameActionEnum;
   import alternativa.tanks.service.settings.keybinding.KeysBindingService;
   import alternativa.tanks.service.settings.keybinding.KeysBindingServiceImpl;
   import base.DiscreteSprite;
   import controls.base.DefaultButtonBase;
   import controls.containers.StackPanel;
   import controls.containers.VerticalStackPanel;
   import flash.events.MouseEvent;
   import projects.tanks.clients.fp10.libraries.TanksLocale;
   import alternativa.init.Main;

   public class KeyBindingsPanel extends DiscreteSprite
   {

      public static var keysBindingService:KeysBindingServiceImpl = Main.osgi.getService(KeysBindingService) as KeysBindingServiceImpl;
      ;

      public static var localeService:ILocaleService;

      private var keyBindingsPanel:VerticalStackPanel;

      private var keyBindingVisualElements:Vector.<alternativa.tanks.gui.settings.tabs.control.KeyBinding>;

      private var restoreDefaultBindingsButton:DefaultButtonBase;

      public function KeyBindingsPanel()
      {
         this.keyBindingsPanel = new VerticalStackPanel();
         this.keyBindingVisualElements = new Vector.<KeyBinding>();
         this.restoreDefaultBindingsButton = new DefaultButtonBase();
         super();
         this.restoreDefaultBindingsButton.label = "Restore default buttons";
         this.restoreDefaultBindingsButton.width = 250;
         this.restoreDefaultBindingsButton.addEventListener(MouseEvent.CLICK, this.restoreDefaultBindings);
         addChild(this.restoreDefaultBindingsButton);
         this.keyBindingsPanel.setMargin(SettingsTabView.MARGIN * 2);
         this.keyBindingsPanel.addItem(this.createTurretActionsPanel());
         this.keyBindingsPanel.addItem(this.createChassisActionsPanel());
         this.keyBindingsPanel.addItem(this.createInventoryActionsPanel());
         this.keyBindingsPanel.addItem(this.createBattleActionsPanel());
         this.keyBindingsPanel.addItem(this.createWindowActionsPanel());
         this.keyBindingsPanel.addItem(this.createCameraActionsPanel());
         this.keyBindingsPanel.y = SettingsTabView.MARGIN + this.restoreDefaultBindingsButton.height;
         addChild(this.keyBindingsPanel);
      }

      private function restoreDefaultBindings(param1:MouseEvent):void
      {
         var _loc2_:KeyBinding = null;
         keysBindingService.restoreDefaultBindings();
         for each (_loc2_ in this.keyBindingVisualElements)
         {
            _loc2_.restoreDefaultBinding();
         }
      }

      private function createTurretActionsPanel():StackPanel
      {
         var _loc1_:StackPanel = new VerticalStackPanel();
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.ROTATE_TURRET_LEFT, "Rotate turret left"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.ROTATE_TURRET_RIGHT, "Rotate turret right"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.CENTER_TURRET, "Center turret"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.SHOT, "Shoot"));
         return _loc1_;
      }

      private function createChassisActionsPanel():StackPanel
      {
         var _loc1_:StackPanel = new VerticalStackPanel();
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.CHASSIS_LEFT_MOVEMENT, "Turn tank left"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.CHASSIS_FORWARD_MOVEMENT, "Move tank forward"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.CHASSIS_RIGHT_MOVEMENT, "Turn tank right"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.CHASSIS_BACKWARD_MOVEMENT, "Move tank backwards"));
         return _loc1_;
      }

      private function createInventoryActionsPanel():StackPanel
      {
         var _loc1_:StackPanel = new VerticalStackPanel();
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.USE_FIRS_AID, "Use first aid supply"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.USE_DOUBLE_ARMOR, "Use double armor supply"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.USE_DOUBLE_DAMAGE, "Use double damage supply"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.USE_NITRO, "Use nitro supply"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.USE_MINE, "Drop mine"));
         // _loc1_.addItem(this.createKeyBinding(GameActionEnum.DROP_GOLD_BOX, "Drop gold supply"));
         // _loc1_.addItem(this.createKeyBinding(GameActionEnum.ULTIMATE, "Activate overdrive"));
         return _loc1_;
      }

      private function createWindowActionsPanel():StackPanel
      {
         var _loc1_:StackPanel = new VerticalStackPanel();
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.BATTLE_VIEW_INCREASE, "Increase battle screen size"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.BATTLE_VIEW_DECREASE, "Decrease battle screen size"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.FULL_SCREEN, "Enable fullscreen"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.OPEN_GARAGE, "Open garage"));
         return _loc1_;
      }

      private function createBattleActionsPanel():StackPanel
      {
         var _loc1_:StackPanel = new VerticalStackPanel();
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.DROP_FLAG, "Drop flag"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.BATTLE_PAUSE, "Pause game"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.SHOW_TANK_PARAMETERS, "Show tank stats"));
         return _loc1_;
      }

      private function createCameraActionsPanel():StackPanel
      {
         var _loc1_:StackPanel = new VerticalStackPanel();
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.FOLLOW_CAMERA_UP, "Move camera up"));
         _loc1_.addItem(this.createKeyBinding(GameActionEnum.FOLLOW_CAMERA_DOWN, "Move camera down"));
         return _loc1_;
      }

      private function createKeyBinding(param1:GameActionEnum, param2:String):KeyBinding
      {
         var _loc3_:KeyBinding = new KeyBinding(param1, param2, SettingsTabView.MARGIN, SettingsWindow.TAB_VIEW_MAX_WIDTH);
         this.keyBindingVisualElements.push(_loc3_);
         return _loc3_;
      }

      public function destroy():void
      {
         var _loc1_:KeyBinding = null;
         this.restoreDefaultBindingsButton.removeEventListener(MouseEvent.CLICK, this.restoreDefaultBindings);
         for each (_loc1_ in this.keyBindingVisualElements)
         {
            _loc1_.destroy();
         }
         this.keyBindingsPanel = null;
         this.keyBindingVisualElements = null;
      }
   }
}
