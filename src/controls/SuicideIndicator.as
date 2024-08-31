package controls
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import controls.base.LabelBase;
   import controls.statassets.BlackRoundRect;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getTimer;
   
   public class SuicideIndicator extends BlackRoundRect
   {
      
      public static var battleService:BattlefieldModel;
      
      public static var localeService:ILocaleService;
	  
    [Embed(source="1051.png")]  
      private static const reArmorIconClass:Class;
      
      private static const TIME_REPLACE_PATTERN:String = "{time}";
       
      
      private var _timeLabel:LabelBase;
      
      private var _throughText:String;
      
      private var _seconds:int;
      
      private var _isShow:Boolean;
      
      private var _idleTimeoutEndTime:int;
      
      public function SuicideIndicator(bfModel:BattlefieldModel)
      {
         super();
         battleService = bfModel;
         this.init();
      }
      
      private function init() : void
      {
         var _loc4_:int = 0;
         var _loc5_:Bitmap = null;
         var _loc6_:int = 0;
         this._throughText = "You will self-destruct in: {time}";
         var _loc1_:int = 33;
         var _loc2_:int = 33;
         var _loc3_:int = 5;
         _loc4_ = 16;
         _loc5_ = new Bitmap(new reArmorIconClass().bitmapData);
         addChild(_loc5_);
         _loc5_.y = _loc1_ - 5;
         _loc6_ = _loc5_.y + _loc5_.height + 2 * _loc3_;
         this._timeLabel = new LabelBase();
         this._timeLabel.size = _loc4_;
         this._timeLabel.autoSize = TextFieldAutoSize.LEFT;
         this._timeLabel.text = this._throughText.replace(TIME_REPLACE_PATTERN," 99:99");
         this._timeLabel.y = _loc6_;
         addChild(this._timeLabel);
         if(width < this._timeLabel.textWidth)
         {
            width = this._timeLabel.textWidth;
         }
         width += 2 * _loc2_;
         _loc5_.x = width - _loc5_.width >> 1;
         height = _loc6_ + this._timeLabel.height + _loc1_ - 5;
      }
      
      public function set seconds(param1:int) : void
      {
         if(this._seconds == param1)
         {
            return;
         }
         this._seconds = param1;
         var _loc2_:int = this._seconds / 60;
         this._seconds -= _loc2_ * 60;
         var _loc3_:String = this._seconds < 9 ? "0" + (this._seconds + 1) : (this._seconds + 1).toString();
         this._timeLabel.text = this._throughText.replace(TIME_REPLACE_PATTERN,_loc2_ + ":" + _loc3_);
         this._timeLabel.x = width - this._timeLabel.width >> 1;
      }
      
      public function show(param1:int) : void
      {
         if(this._isShow)
         {
            return;
         }
         this._idleTimeoutEndTime = getTimer() + param1;
         this._isShow = true;
         this.seconds = param1;
         battleService.bfData.viewport.addChild(this);
         this.onResize();
         Main.stage.addEventListener(Event.RESIZE,this.onResize);
         Main.stage.addEventListener(Event.ENTER_FRAME,this.updateTimer, false, 0, false);
      }
      
      private function onResize(param1:Event = null) : void
      {
         this.x = Main.stage.stageWidth - this.width >> 1;
         this.y = Main.stage.stageHeight - this.height >> 1;
      }
      
      private function updateTimer(param1:Event = null) : void
      {
         var time:int = getTimer();
         this.seconds = Math.max((this._idleTimeoutEndTime - time) / 1000,0);
      }
      
      public function hide() : void
      {
         if(!this._isShow)
         {
            return;
         }
         this._isShow = false;
         this.removeDisplayObject(this);
         Main.stage.removeEventListener(Event.RESIZE,this.onResize);
         Main.stage.removeEventListener(Event.ENTER_FRAME,this.updateTimer);
      }
      
      public function destroy() : void
      {
         this.hide();
         this._timeLabel = null;
      }
      
      private function removeDisplayObject(param1:DisplayObject) : void
      {
         if(param1 != null && param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
      }
   }
}
