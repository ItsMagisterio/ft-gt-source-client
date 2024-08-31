package forms.notification
{
   import controls.ColorButton;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowInner;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import forms.events.MainButtonBarEvents;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.init.Main;
   import alternativa.tanks.model.panel.PanelModel;
   
   public class PremiumNotification extends Sprite
   {
      
      private static const soundClass:Class = soundC;
       
      
      private var w:TankWindow;
      
      private var wi:TankWindowInner;
      
      private var p:Sprite;
      
      private var _stage:Stage;
      
      private var b:ColorButton;
      
      private var e:ColorButton;
      
      private var l:Label;
      
      private var removeTimer:Timer;
      
      private var motionTimer:Timer;
      
      private var motionDelay:int = 5;
      
      public function PremiumNotification(param1:Stage)
      {
         this.w = new TankWindow(360,112);
         this.p = new Sprite();
         this.p.mouseEnabled = false;
         this.b = new ColorButton();
         this.e = new ColorButton();
         this.l = new Label();
         this.wi = new TankWindowInner(-1,-1,-15982067);
         this.removeTimer = new Timer(14000,1);
         this.motionTimer = new Timer(this.motionDelay,9);
         this.wi.width = 310;
         this.wi.height = 54;
         this.wi.x = 11;
         this.wi.y = 11;
         this.wi.showBlink = true;
         super();
         this._stage = param1;
         this._stage.addEventListener(Event.RESIZE,this.draw);
         this.p.graphics.beginFill(0,0);
         this.p.graphics.drawRect(0,0,4000,4000);
         this.b.y = 70;
         this.b.label = "Close";
         this.b.setStyle("def");
         this.b.addEventListener(MouseEvent.CLICK,this.remowe);
         this.e.y = 70;
         this.e.label = "Extend";
         this.e.setStyle("def");
         this.e.addEventListener(MouseEvent.CLICK,this.extend);
         this.l.y = 27 - this.l.height / 2;
         this.l.defaultTextFormat = new TextFormat("MyriadPro",12);
         this.l.textColor = 5898034;
         this.p.addChild(this.w);
         this.w.addChild(this.b);
         this.w.addChild(this.wi);
         this.wi.addChild(this.l);
      }
      
      private function draw(param1:Event = null) : void
      {
         this.w.width = 330;
         this.l.x = int((this.wi.width - this.l.width) / 2);
         this.l.y = 27 - this.l.height / 2;
         this.b.x = int(this.w.width - this.b.width - 11);
         this.e.x = 11;
         this.w.x = int(this._stage.stageWidth);
         this.w.y = int(50);
      }
      
      public function set add(param1:String) : void
      {
         this.l.htmlText = param1;
         this.draw();
         var sound:Sound = new soundClass();
         sound.play();
         this.motionTimer.start();
         this.motionTimer.addEventListener(TimerEvent.TIMER,this.motionHandler);
         this.motionTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.completeMotion);
         this.removeTimer.start();
         this.removeTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.removeHandler);
         this._stage.addChild(this.p);
      }
      
      public function remowe(param1:MouseEvent = null) : void
      {
         this._stage.removeChild(this.p);
      }
      
      public function extend(param1:MouseEvent = null) : void
      {
         PanelModel(Main.osgi.getService(IPanel)).mainPanel.buttonBar.dispatchEvent(new MainButtonBarEvents(1));
         this._stage.removeChild(this.p);
      }
      
      private function removeHandler(e:TimerEvent) : void
      {
		 try 
		 {
			this._stage.removeChild(this.p); 
		 }
		 catch (error:Error){
			trace("notification is already deleted by user")
		 }
		 
      }
      
      private function motionHandler(e:TimerEvent) : void
      {
         this.w.x -= 35;
      }
      
      private function completeMotion(e:TimerEvent) : void
      {
         this.w.x -= 16;
      }
   }
}
