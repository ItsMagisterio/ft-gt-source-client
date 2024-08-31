package alternativa.tanks.models.battlefield
{
   import controls.Label;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TouchEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import flash.ui.Multitouch;
   import flash.ui.MultitouchInputMode;

   public class Controllers extends Sprite
   {

      private const OFFSET_X:int = 70;

      private const OFFSET_Y:int = 74;

      private const FPS_OFFSET_X:int = 60;

      private const NUM_FRAMES:int = 10;

      private var fps:Label;

      private var label:Label;

      private var tfDelay:int = 0;

      private var tfTimer:int;

      private var filter:DropShadowFilter;

      public var colored:Boolean;

      public var ulko:Sprite;

      public var inside:Sprite;

      public var ulkotur:Sprite;

      public var insidetur:Sprite;

      public var scale_multiplyer:int = 2;

      public var touch:TouchEvent;

      public var touch_tur:TouchEvent;

      public function Controllers(color:Boolean = false)
      {
         Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
         this.ulko = this.DrawRectangle(-200 * this.scale_multiplyer, -200 * this.scale_multiplyer, 200 * this.scale_multiplyer, 200 * this.scale_multiplyer);
         addChild(this.ulko);
         this.inside = this.DrawRectangle(-200 * this.scale_multiplyer + 66.66 * this.scale_multiplyer, -200 * this.scale_multiplyer + 66.66 * this.scale_multiplyer, 66.666 * this.scale_multiplyer, 66.666 * this.scale_multiplyer);
         addChild(this.inside);
         this.ulkotur = this.DrawRectangle(-200 * this.scale_multiplyer, -200 * this.scale_multiplyer + 66.66 * this.scale_multiplyer, 200 * this.scale_multiplyer, 133.32 * this.scale_multiplyer);
         addChild(this.ulkotur);
         this.insidetur = this.DrawRectangle(100 + 66.666 / this.scale_multiplyer / 2 - 400, -200 * this.scale_multiplyer + 66.66 * this.scale_multiplyer + 66.66 * this.scale_multiplyer, 66.666 * this.scale_multiplyer, 66.666 * this.scale_multiplyer);
         addChild(this.insidetur);
         this.inside.addEventListener(TouchEvent.TOUCH_BEGIN, this.mouse_down);
         this.insidetur.addEventListener(TouchEvent.TOUCH_BEGIN, this.mouse_down_tur);
         super();
         addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
      }

      public function DrawRectangle(x:int, y:int, xs:int, ys:int):Sprite
      {
         var rect:Sprite = new Sprite();
         rect.graphics.beginFill(16777215, 0.05);
         rect.graphics.lineStyle(4);
         rect.graphics.drawRoundRect(0, 0, xs, ys, 5000, 5000);
         rect.graphics.endFill();
         rect.x = x;
         rect.y = y;
         return rect;
      }

      public function mouse_down(e:TouchEvent):void
      {
         this.inside.startTouchDrag(e.touchPointID, false, new Rectangle(-200 * this.scale_multiplyer, -200 * this.scale_multiplyer, 200 * this.scale_multiplyer - 66.66 * this.scale_multiplyer, 200 * this.scale_multiplyer - 66.66 * this.scale_multiplyer));
         stage.addEventListener(TouchEvent.TOUCH_MOVE, this.mouse_move);
         stage.addEventListener(TouchEvent.TOUCH_END, this.mouse_up);
         this.touch = e;
      }

      public function mouse_up(e:TouchEvent):void
      {
         if (e.touchPointID == this.touch.touchPointID)
         {
            this.inside.stopTouchDrag(e.touchPointID);
            this.inside.x = -200 * this.scale_multiplyer + 66.66 * this.scale_multiplyer;
            this.inside.y = -200 * this.scale_multiplyer + 66.66 * this.scale_multiplyer;
            this.mouse_move(null);
            if (this.touch.touchPointID == 1)
            {
               this.touch.touchPointID = 0;
            }
         }
      }

      public function mouse_down_tur(e:TouchEvent):void
      {
         this.touch_tur = e;
         this.insidetur.startTouchDrag(e.touchPointID, false, new Rectangle((0 - int(stage.stageWidth) / 100) * 90 + 150, -200 * this.scale_multiplyer + 66.66 * this.scale_multiplyer, 200 * this.scale_multiplyer - 66.66 * this.scale_multiplyer, 133.32 * this.scale_multiplyer - 66.66 * this.scale_multiplyer));
         stage.addEventListener(TouchEvent.TOUCH_MOVE, this.mouse_move_tur);
         stage.addEventListener(TouchEvent.TOUCH_END, this.mouse_up_tur);
      }

      public function mouse_up_tur(e:TouchEvent):void
      {
         if (e.touchPointID == this.touch_tur.touchPointID)
         {
            this.insidetur.stopTouchDrag(e.touchPointID);
            this.insidetur.x = (0 - int(stage.stageWidth) / 100) * 90 + 66.66 * this.scale_multiplyer + 150;
            this.insidetur.y = -200 * this.scale_multiplyer + 66.66 * this.scale_multiplyer + 66.66 * this.scale_multiplyer;
            this.mouse_move_tur(null);
            if (this.touch_tur.touchPointID == 1)
            {
               this.touch_tur.touchPointID = 0;
            }
         }
      }

      public function mouse_move(e:TouchEvent):void
      {
         if (this.inside.x >= 0 * this.scale_multiplyer - 200 * this.scale_multiplyer && this.inside.x <= 33.33 * this.scale_multiplyer - 200 * this.scale_multiplyer)
         {
            stage.dispatchEvent(new KeyboardEvent("keyDown", true, false, 65, 65, 0, false, false, false));
         }
         if (this.inside.x >= 100 * this.scale_multiplyer - 200 * this.scale_multiplyer && this.inside.x <= 166.66 * this.scale_multiplyer - 200 * this.scale_multiplyer)
         {
            stage.dispatchEvent(new KeyboardEvent("keyDown", true, false, 68, 68, 0, false, false, false));
         }
         if (this.inside.x >= 33.33 * this.scale_multiplyer - 200 * this.scale_multiplyer && this.inside.x <= 100 * this.scale_multiplyer - 200 * this.scale_multiplyer)
         {
            stage.dispatchEvent(new KeyboardEvent("keyUp", true, false, 65, 65, 0, false, false, false));
            stage.dispatchEvent(new KeyboardEvent("keyUp", true, false, 68, 68, 0, false, false, false));
         }
         if (this.inside.y >= 0 - 200 * this.scale_multiplyer && this.inside.y <= 33.33 * this.scale_multiplyer - 200 * this.scale_multiplyer)
         {
            stage.dispatchEvent(new KeyboardEvent("keyDown", true, false, 87, 87, 0, false, false, false));
         }
         if (this.inside.y >= 100 * this.scale_multiplyer - 200 * this.scale_multiplyer && this.inside.y <= 166.66 * this.scale_multiplyer - 200 * this.scale_multiplyer)
         {
            stage.dispatchEvent(new KeyboardEvent("keyDown", true, false, 83, 83, 0, false, false, false));
         }
         if (this.inside.y >= 33.33 * this.scale_multiplyer - 200 * this.scale_multiplyer && this.inside.y <= 100 * this.scale_multiplyer - 200 * this.scale_multiplyer)
         {
            stage.dispatchEvent(new KeyboardEvent("keyUp", true, false, 87, 87, 0, false, false, false));
            stage.dispatchEvent(new KeyboardEvent("keyUp", true, false, 83, 83, 0, false, false, false));
         }
      }

      public function mouse_move_tur(e:Event):void
      {
         if (this.insidetur.x >= 0 + (0 - int(stage.stageWidth) / 100) * 90 && this.insidetur.x <= 33.33 + 150 * this.scale_multiplyer + (0 - int(stage.stageWidth) / 100) * 90)
         {
            stage.dispatchEvent(new KeyboardEvent("keyDown", true, false, 90, 90, 0, false, false, false));
         }
         if (this.insidetur.x >= 100 * this.scale_multiplyer + (0 - int(stage.stageWidth) / 100) * 90 + 150 && this.insidetur.x <= 166.66 * this.scale_multiplyer + (0 - int(stage.stageWidth) / 100) * 90 + 150)
         {
            stage.dispatchEvent(new KeyboardEvent("keyDown", true, false, 88, 88, 0, false, false, false));
         }
         if (this.insidetur.x >= 33.33 * this.scale_multiplyer + (0 - int(stage.stageWidth) / 100) * 90 + 150 && this.insidetur.x <= 100 * this.scale_multiplyer + (0 - int(stage.stageWidth) / 100) * 90 + 150)
         {
            stage.dispatchEvent(new KeyboardEvent("keyUp", true, false, 88, 88, 0, false, false, false));
            stage.dispatchEvent(new KeyboardEvent("keyUp", true, false, 90, 90, 0, false, false, false));
         }
         if (this.insidetur.y >= 0 - 149.99 * this.scale_multiplyer && this.insidetur.y <= 33.33 * this.scale_multiplyer - 149.99 * this.scale_multiplyer)
         {
            stage.dispatchEvent(new KeyboardEvent("keyDown", true, false, 32, 32, 0, false, false, false));
         }
         if (this.insidetur.y >= 33.33 * this.scale_multiplyer - 149.99 * this.scale_multiplyer && this.insidetur.y <= 100 * this.scale_multiplyer - 149.99 * this.scale_multiplyer)
         {
            stage.dispatchEvent(new KeyboardEvent("keyUp", true, false, 32, 32, 0, false, false, false));
         }
      }

      private function onAddedToStage(e:Event):void
      {
         stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
         stage.addEventListener(Event.RESIZE, this.onResize);
      }

      private function onRemovedFromStage(e:Event):void
      {
         stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
         stage.removeEventListener(Event.RESIZE, this.onResize);
      }

      private function onEnterFrame(e:Event):void
      {
         var offset:Number = NaN;
      }

      public function onResize(e:Event = null):void
      {
         x = stage.stageWidth - this.OFFSET_X;
         y = stage.stageHeight - this.OFFSET_Y;
         this.ulkotur.x = (0 - int(stage.stageWidth) / 100) * 90 + 150;
         this.insidetur.x = (0 - int(stage.stageWidth) / 100) * 90 + 66.66 * this.scale_multiplyer + 150;
      }
   }
}
