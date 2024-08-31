package alternativa.tanks.model.quest.challenge.gui
{
   import controls.TankWindowInner;
   import fl.controls.ScrollBarDirection;
   import fl.controls.TileList;
   import fl.data.DataProvider;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import forms.Styles;
   import projects.tanks.client.panel.model.challenge.rewarding.Tier;
   import utils.ScrollStyleUtils;

   public class TierList extends TankWindowInner
   {

      public static const STATE_DEFAULT:int = 0;

      public static const STATE_CURRENT:int = 1;

      public static const STATE_DONE:int = 2;

      private static const MIN_POSSIBLE_SPEED:Number = 70;

      private static const MAX_DELTA_FOR_SELECT:Number = 7;

      private static const ADDITIONAL_SCROLL_AREA_HEIGHT:Number = 3;

      private var list:TileList;

      private var previousPositionX:Number;

      private var currentPositionX:Number;

      private var sumDragWay:Number;

      private var lastItemIndex:int;

      private var previousTime:int;

      private var currentTime:int;

      private var scrollSpeed:Number = 0;

      private var blinkTimer:Timer;

      public function TierList()
      {
         this.list = new TileList();
         super(0, 0, GREEN);
         this.list.x = 3;
         this.list.y = 3;
         this.list.rowCount = 1;
         this.list.rowHeight = 323;
         this.list.columnWidth = 196;
         this.list.focusEnabled = false;
         this.list.horizontalScrollBar.focusEnabled = false;
         this.list.direction = ScrollBarDirection.HORIZONTAL;
         this.list.setStyle(Styles.CELL_RENDERER, TierRenderer);
         this.list.dataProvider = new DataProvider();
         ScrollStyleUtils.setGreenStyle(this.list);
         addChild(this.list);
         addEventListener(Event.ADDED_TO_STAGE, this.addListeners);
         addEventListener(Event.REMOVED_FROM_STAGE, this.removeListeners);
      }

      override public function set width(param1:Number):void
      {
         super.width = Math.ceil(param1);
         this.list.width = width - 5;
      }

      override public function set height(param1:Number):void
      {
         super.height = Math.ceil(param1);
         this.list.height = height + 2;
      }

      public function setTiers(param1:Vector.<Tier>, param2:int, param3:int):void
      {
         var _loc5_:Object = null;
         this.list.dataProvider.removeAll();
         var _loc4_:int = 0;
         while (_loc4_ < param1.length)
         {
            _loc5_ = new Object();
            _loc5_.number = _loc4_ + 1;
            _loc5_.tier = param1[_loc4_];
            if (_loc4_ < param2)
            {
               _loc5_.state = STATE_DONE;
            }
            else if (_loc4_ == param2)
            {
               _loc5_.state = STATE_CURRENT;
               _loc5_.progress = param3;
               this.stopTimer();
               this.blinkTimer = new Timer(800);
               _loc5_.timer = this.blinkTimer;
            }
            else
            {
               _loc5_.state = STATE_DEFAULT;
            }
            this.list.dataProvider.addItem(_loc5_);
            _loc4_++;
         }
         this.list.scrollToIndex(Math.min(param2, param1.length - 1));
      }

      private function stopTimer():*
      {
         if (this.blinkTimer != null)
         {
            this.blinkTimer.stop();
            this.blinkTimer = null;
         }
      }

      private function scrollList(param1:MouseEvent):void
      {
         this.list.horizontalScrollPosition -= param1.delta * (Boolean(Capabilities.os.search("Linux") != -1) ? 50 : 10);
      }

      private function onMouseDown(param1:MouseEvent):void
      {
         this.scrollSpeed = 0;
         var _loc2_:Rectangle = this.list.horizontalScrollBar.getBounds(stage);
         _loc2_.top -= ADDITIONAL_SCROLL_AREA_HEIGHT;
         if (!_loc2_.contains(param1.stageX, param1.stageY))
         {
            this.sumDragWay = 0;
            this.previousPositionX = this.currentPositionX = param1.stageX;
            this.currentTime = this.previousTime = getTimer();
            this.lastItemIndex = this.list.selectedIndex;
            stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
         }
      }

      private function onMouseUp(param1:MouseEvent):void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
         var _loc2_:Number = (getTimer() - this.previousTime) / 1000;
         if (_loc2_ == 0)
         {
            _loc2_ = 0.1;
         }
         var _loc3_:Number = param1.stageX - this.previousPositionX;
         this.scrollSpeed = _loc3_ / _loc2_;
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
      }

      private function onEnterFrame(param1:Event):void
      {
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         var _loc2_:Number = (this.currentTime - this.previousTime) / 1000;
         this.list.horizontalScrollPosition -= this.scrollSpeed * _loc2_;
         var _loc3_:Number = this.list.horizontalScrollPosition;
         var _loc4_:Number = this.list.maxHorizontalScrollPosition;
         if (Math.abs(this.scrollSpeed) > MIN_POSSIBLE_SPEED && 0 < _loc3_ && _loc3_ < _loc4_)
         {
            this.scrollSpeed *= Math.exp(-1.5 * _loc2_);
         }
         else
         {
            this.scrollSpeed = 0;
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
         }
      }

      private function onMouseMove(param1:MouseEvent):void
      {
         this.previousPositionX = this.currentPositionX;
         this.currentPositionX = param1.stageX;
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         var _loc2_:Number = this.currentPositionX - this.previousPositionX;
         this.sumDragWay += Math.abs(_loc2_);
         if (this.sumDragWay > MAX_DELTA_FOR_SELECT)
         {
            this.list.horizontalScrollPosition -= _loc2_;
         }
         param1.updateAfterEvent();
      }

      private function addListeners(param1:Event):void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL, this.scrollList);
         addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
      }

      private function removeListeners(param1:Event):void
      {
         removeEventListener(MouseEvent.MOUSE_WHEEL, this.scrollList);
         removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
         removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
         stage.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
      }

      public function destroy():void
      {
         this.stopTimer();
      }
   }
}
