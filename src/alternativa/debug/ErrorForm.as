package alternativa.debug
{
   import controls.TankWindow;
   import controls.TankWindowInner;
   import controls.base.DefaultButtonBase;
   import controls.base.LabelBase;
   import flash.desktop.NativeApplication;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.filesystem.File;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFieldAutoSize;

   public class ErrorForm extends Sprite
   {

      private static const IconImage:Class = ErrorForm_IconImage;

      private static const iconImage:BitmapData = new IconImage().bitmapData;

      private var _refreshButton:DefaultButtonBase;

      private var _supportLink:LabelBase;

      private var window:TankWindow;

      private var description:LabelBase;

      private var field:TankWindowInner;

      private var icon:Bitmap;

      private var SUPPORT_URL:String = "https://cybertankz.com/";

      public function ErrorForm()
      {
         var _loc2_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         _loc2_ = NaN;
         super();

         _loc5_ = 10;
         _loc2_ = -2;
         var _loc6_:Number = 47;
         _loc7_ = 33;
         _loc8_ = 100;
         this.icon = new Bitmap(iconImage);
         this.icon.x = 23;
         this.icon.y = 23;
         this.description = new LabelBase();
         this.description.color = 5898035;
         this.description.multiline = true;
         this.description.autoSize = TextFieldAutoSize.LEFT;
         this.description.x = this.icon.x + this.icon.width + 12 - 4;
         this.description.y = 12 + 12 - 3;
         this.description.text = "Unknown";
         this.description.selectable = true;
         if (this.description.y + this.description.height > this.icon.y + this.icon.height)
         {
            _loc6_ += this.description.y + this.description.height - this.icon.y - this.icon.height;
         }
         this.window = new TankWindow(300, 12 + _loc6_ + _loc5_ + _loc7_ + _loc5_ + _loc2_ + _loc7_ + 12);
         this.field = new TankWindowInner(300 - 12 * 2, _loc6_, TankWindowInner.GREEN);
         this.field.x = 12;
         this.field.y = 12;
         addChild(this.window);
         this.window.addChild(this.field);
         this.window.addChild(this.icon);
         this.window.addChild(this.description);
         this._refreshButton = new DefaultButtonBase();
         this._refreshButton.label = "Re-enter the game";
         this._refreshButton.x = 12 + 1;
         this._refreshButton.y = 12 + _loc6_ + _loc5_;
         this._refreshButton.width += 24 * 2;
         this._refreshButton.addEventListener(MouseEvent.CLICK, this.onRefreshButtonClick);
         this.window.addChild(this._refreshButton);
         this._supportLink = new LabelBase();
         this._supportLink.htmlText = "<a href='event:haveAcc'><font color='#31FE01'><u>" + "Solutions" + "</u></font></a>";
         this._supportLink.x = 300 - 12 - _loc8_ - 1;
         this._supportLink.y = 12 + _loc6_ + _loc5_ + _loc7_ + _loc5_ + _loc2_;
         this._supportLink.addEventListener(TextEvent.LINK, this.onSupportClick);
         this.window.addChild(this._supportLink);

      }

      private function onSupportClick(param1:TextEvent):void
      {
         navigateToURL(new URLRequest(this.SUPPORT_URL), "_blank");
      }

      private function onRefreshButtonClick(param1:MouseEvent = null):void
      {
         var appFile:File = File.applicationDirectory.resolvePath(File.applicationDirectory.nativePath + File.separator + "CyberTankz.exe");
         NativeApplication.nativeApplication.exit();
         appFile.openWithDefaultApplication();
      }

      private function redraw():void
      {
         this.field.width = 12 + this.icon.width + 8 + this.description.width + 20;
         this.field.height = Math.max(this.icon.height, this.description.height) + 2 * 10;
         this.window.width = this.field.width + 2 * 12;
         this.window.height = 12 + this.field.height + 12 + this._refreshButton.height + 12 + this._supportLink.height + 14 - 10;
         if (this.description.height < this.icon.height)
         {
            this.description.y = this.icon.y + (this.icon.height - this.description.textHeight >> 1) - 3;
         }
         this._refreshButton.x = this.window.width - this._refreshButton.width >> 1;
         this._refreshButton.y = this.field.y + this.field.height + 12 - 4;
         this._supportLink.x = this.window.width - this._supportLink.width >> 1;
         this._supportLink.y = this._refreshButton.y + this._refreshButton.height + 12 - 7;

      }

      public function setErrorText(param1:String):void
      {
         this.description.text = param1;
         this.redraw();
      }

      public function setSupportUrl(param1:String):void
      {
         this.SUPPORT_URL = param1;
      }
   }
}
