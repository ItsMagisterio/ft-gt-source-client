package alternativa.tanks.models.battlefield.inventory
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.model.panel.IPanelListener;
   import alternativa.tanks.models.inventory.IInventory;
   import alternativa.tanks.models.inventory.InventoryLock;
   import alternativa.tanks.models.tank.ITankEventDispatcher;
   import alternativa.tanks.models.tank.ITankEventListener;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankEvent;
   import controls.InventoryIcon;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import projects.tanks.client.battlefield.gui.models.inventory.IInventoryModelBase;
   import projects.tanks.client.battlefield.gui.models.inventory.InventoryModelBase;

   public class InventoryModel extends InventoryModelBase implements IInventoryModelBase, IObjectLoadListener, IInventoryPanel, IInventory, IPanelListener, ITankEventListener
   {

      private static const PANEL_OFFSET_Y:int = 50;

      private var container:DisplayObjectContainer;

      private var inventorySlots:Vector.<InventoryPanelSlot>;

      private var guiLayer:DisplayObjectContainer;

      private var slotIndexByKeyCode:Dictionary;

      private var inventoryItemModel:IInventoryItemModel;

      private var uiLockCounter:int;

      public function InventoryModel()
      {
         this.slotIndexByKeyCode = new Dictionary();
         super();
         _interfaces.push(IModel, IInventoryModelBase, IObjectLoadListener, IInventoryPanel, IInventory, IPanelListener);
         this.guiLayer = Main.contentUILayer;
      }

      public function killCurrentUser(clientObject:ClientObject):void
      {
         this.lockItems(InventoryLock.PLAYER_INACTIVE, true);
      }

      public function battleFinish(clientObject:ClientObject):void
      {
         this.lockItems(InventoryLock.PLAYER_INACTIVE, true);
      }

      public function battleRestart(clientObject:ClientObject):void
      {
      }

      public function objectLoaded(object:ClientObject):void
      {
         this.container = new Sprite();
         this.container.visible = false;
         this.guiLayer.addChild(this.container);
         this.initSlots();
         this.initKeyCodes();
         var tankEventDispatcher:ITankEventDispatcher = ITankEventDispatcher(Main.osgi.getService(ITankEventDispatcher));
         tankEventDispatcher.addTankEventListener(TankEvent.ACTIVATED, this);
         Main.stage.addEventListener(Event.RESIZE, this.onResize);
         this.onResize(null);
      }

      public function objectUnloaded(object:ClientObject):void
      {
         if (this.inventorySlots == null)
         {
            return;
         }
         for (var i:int = 0; i < this.inventorySlots.length; i++)
         {
            this.clearSlot(i);
         }
         this.inventorySlots = null;
         this.guiLayer.removeChild(this.container);
         this.container = null;
         var tankEventDispatcher:ITankEventDispatcher = ITankEventDispatcher(Main.osgi.getService(ITankEventDispatcher));
         tankEventDispatcher.removeTankEventListener(TankEvent.ACTIVATED, this);
         this.guiLayer.stage.removeEventListener(Event.RESIZE, this.onResize);
      }

      public function assignItemToSlot(item:InventoryItem, slotIndex:int):void
      {
         var modelService:IModelService = null;
         if (item == null)
         {
            return;
         }
         if (this.inventoryItemModel == null)
         {
            modelService = IModelService(Main.osgi.getService(IModelService));
            this.inventoryItemModel = IInventoryItemModel(modelService.getModelsByInterface(IInventoryItemModel)[0]);
         }
         if (this.getActiveSlotsCount() == 0)
         {
            this.guiLayer.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKey);
            this.guiLayer.stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame, false, 0, false);
         }
         var slot:InventoryPanelSlot = this.inventorySlots[slotIndex];
         slot.inventoryItem = item;
         slot.updateCounter();
         this.container.visible = true;
      }
      public function changeEffectTime(param1:int, param2:int, param3:Boolean, param4:Boolean):void
      {
         if (this.inventorySlots != null)
         {
            if (this.inventorySlots[param1] != null)
            {
               var _loc5_:InventoryPanelSlot = this.inventorySlots[param1];

               if (param4)
               {
                  _loc5_.startInfiniteEffect(param3);
               }
               else
               {
                  _loc5_.changeEffectTime(param2, param3);
               }
            }
         }
      }

      public function itemActivated(item:InventoryItem):void
      {
         var slot:InventoryPanelSlot = null;
         for each (slot in this.inventorySlots)
         {
            if (slot.inventoryItem == item)
            {
               slot.updateCounter();

            }
         }
      }

      public function activateCooldown(param1:int, param2:int):void
      {
         var _loc3_:InventoryPanelSlot = null;

         _loc3_ = this.inventorySlots[param1];
         _loc3_.activateCooldown(param2);

      }

      public function activateDependedCooldown(param1:int, param2:int):void
      {
         var _loc3_:InventoryPanelSlot = null;

         _loc3_ = this.inventorySlots[param1];
         _loc3_.activateDependedCooldown(param2);

      }
      public function setCooldownDuration(param1:int, param2:int):void
      {
         InventoryPanelSlot(this.inventorySlots[param1]).setCooldownDuration(param2);
      }

      public function lockItem(itemType:int, lockMask:int, lock:Boolean):void
      {
         var slot:InventoryPanelSlot = null;
         var item:InventoryItem = null;
         for each (slot in this.inventorySlots)
         {
            item = slot.inventoryItem;
            if (item != null && item.getId() == itemType)
            {
               slot.setLockMask(lockMask, lock);

            }
         }
      }

      public function lockItems(lockMask:int, lock:Boolean):void
      {
         var slot:InventoryPanelSlot = null;
         for each (slot in this.inventorySlots)
         {
            slot.setLockMask(lockMask, lock);

         }
      }

      public function bugReportOpened():void
      {
         this.updateUILock(1);
      }

      public function bugReportClosed():void
      {
         this.updateUILock(-1);
      }

      public function friendsOpened():void
      {
         this.updateUILock(1);
      }

      public function friendsClosed():void
      {
         this.updateUILock(-1);
      }

      public function settingsOpened():void
      {
         this.updateUILock(1);
      }

      public function onCloseGame():void
      {
         this.updateUILock(1);
      }

      public function onCloseGameExit():void
      {
         this.updateUILock(-1);
      }

      public function settingsAccepted():void
      {
         this.updateUILock(-1);
      }

      public function settingsCanceled():void
      {
         this.updateUILock(-1);
      }

      public function handleTankEvent(eventType:int, tankData:TankData):void
      {
         var slot:InventoryPanelSlot = null;
         var item:InventoryItem = null;
         if (eventType == TankEvent.ACTIVATED && tankData.local)
         {
            for each (slot in this.inventorySlots)
            {
               slot.setLockMask(InventoryLock.PLAYER_INACTIVE, false);
               item = slot.inventoryItem;
               if (item != null)
               {
                  item.clearCooldown();
               }
            }
         }
      }

      public function setMuteSound(mute:Boolean):void
      {
      }

      private function updateUILock(lockIncrement:int):void
      {
         var slot:InventoryPanelSlot = null;
         this.uiLockCounter += lockIncrement;
         if (this.uiLockCounter < 0)
         {
            this.uiLockCounter = 0;
         }
         if (this.inventorySlots != null)
         {
            for each (slot in this.inventorySlots)
            {
               slot.setLockMask(InventoryLock.GUI, this.uiLockCounter > 0);
            }
         }
      }

      private function onResize(e:Event):void
      {

         this.container.x = Main.stage.stageWidth / 2 - new InventoryIcon(InventoryIcon.EMPTY).width * 5 / 2 - 33;
         this.container.y = Main.stage.stageHeight - PANEL_OFFSET_Y;
      }

      private function initSlots():void
      {
         var slot:InventoryPanelSlot = null;
         var slotCanvas:DisplayObject = null;
         this.inventorySlots = new Vector.<InventoryPanelSlot>(5);
         var spacing:int = 10 + new InventoryIcon(InventoryIcon.EMPTY).width;
         var x:int = 10;
         for (var i:int = 0; i < 6; i++)
         {
            slot = new InventoryPanelSlot(i + 1);
            this.inventorySlots[i] = slot;

            slotCanvas = slot.getCanvas();
            slotCanvas.x = x;
            if (i == 5)
            {
               slotCanvas.visible = false;
            }
            this.container.addChild(slotCanvas);
            x += spacing;
         }
      }
      public function setVisible(param1:int, param2:Boolean, param3:Boolean):void
      {
         if (this.inventorySlots != null)
         {

            var slot:InventoryPanelSlot = null;
            var slotCanvas:DisplayObject = null;
            slot = this.inventorySlots[param1];
            slotCanvas = slot.getCanvas();

            slotCanvas.visible = param2;

            this.onResize(null);
         }
      }
      private function onKey(e:KeyboardEvent):void
      {
         var i:* = this.slotIndexByKeyCode[e.keyCode];
         if (i == null)
         {
            return;
         }
         var slotIndex:int = i;
         var slot:InventoryPanelSlot = this.inventorySlots[slotIndex];
         if (slot.isLocked())
         {
            return;
         }
         var item:InventoryItem = slot.inventoryItem;
         if (item != null)
         {
            this.inventoryItemModel.requestActivation(item, slot);
         }
      }

      private function getActiveSlotsCount():int
      {
         var count:int = 0;
         var slot:InventoryPanelSlot = null;
         for each (slot in this.inventorySlots)
         {
            if (slot.inventoryItem != null)
            {
               count++;
            }
         }
         return count;
      }

      private function clearSlot(slotIndex:int):void
      {
         var slot:InventoryPanelSlot = this.inventorySlots[slotIndex];
         slot.inventoryItem = null;
         if (this.getActiveSlotsCount() == 0)
         {
            this.guiLayer.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKey);
            this.guiLayer.stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
         }
      }

      private function onEnterFrame(e:Event):void
      {
         var slot:InventoryPanelSlot = null;
         var now:int = getTimer();
         for each (slot in this.inventorySlots)
         {
            slot.update(now);
         }
      }
      public function itemUpdated(item:InventoryItem):void
      {
         var slot:InventoryPanelSlot;
         for each (slot in this.inventorySlots)
         {
            if (slot.inventoryItem == item)
            {
               slot.updateCounter();
            }
         }
      }

      private function initKeyCodes():void
      {
         this.slotIndexByKeyCode[49] = 0;
         this.slotIndexByKeyCode[Keyboard.NUMPAD_1] = 0;
         this.slotIndexByKeyCode[50] = 1;
         this.slotIndexByKeyCode[Keyboard.NUMPAD_2] = 1;
         this.slotIndexByKeyCode[51] = 2;
         this.slotIndexByKeyCode[Keyboard.NUMPAD_3] = 2;
         this.slotIndexByKeyCode[52] = 3;
         this.slotIndexByKeyCode[Keyboard.NUMPAD_4] = 3;
         this.slotIndexByKeyCode[53] = 4;
         this.slotIndexByKeyCode[Keyboard.NUMPAD_5] = 4;
         this.slotIndexByKeyCode[54] = 5;
         this.slotIndexByKeyCode[Keyboard.NUMPAD_5] = 5;
      }
   }
}
