package forms
{
   import alternativa.osgi.service.locale.ILocaleService;
   import controls.Label;
   import controls.TankWindow;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import utils.windowheaders.background.BackgroundHeader;

   public class TankWindowWithHeader extends Sprite
   {

      private static const HEADER_BACKGROUND_HEIGHT:int = 25;

      private static const HEADER_BACKGROUND_INNER_HEIGHT:int = 22;

      public static var localeService:ILocaleService;

      private var filter:DropShadowFilter;

      private const GAP_11:int = 11;

      private var label:Label;

      private var window:TankWindow;

      private var headerBackground:Bitmap;

      public function TankWindowWithHeader(header:String = null)
      {
         this.label = new Label("MyriadPro2");
         super();
         this.window = new TankWindow();
         addChild(this.window);
         this.initHeaderStyle();
         if (header != null)
         {
            this.setHeader(header);
         }
      }

      public static function createWindow(param1:String, param2:int = -1, param3:int = -1):TankWindowWithHeader
      {
         var _loc4_:TankWindowWithHeader = new TankWindowWithHeader(param1);
         _loc4_.width = param2;
         _loc4_.height = param3;
         return _loc4_;
      }

      private function initHeaderStyle():void
      {
         this.filter = new DropShadowFilter(0, 0, 0, 1, 2, 2, 3, 3, false, false, false);
         this.label.size = 16;
         this.label.color = 12632256;
         this.label.bold = true;
         this.label.filters = [this.filter];
      }

      private function setHeader(param1:String):void
      {
         this.label.text = param1;
         if (this.label.width > this.label.height)
         {
            if (this.label.width + 2 * this.GAP_11 < BackgroundHeader.shortBackgroundHeader.width)
            {
               this.headerBackground = new Bitmap(BackgroundHeader.shortBackgroundHeader);
            }
            else
            {
               this.headerBackground = new Bitmap(BackgroundHeader.longBackgroundHeader);
            }
         }
         else
         {
            this.headerBackground = new Bitmap(BackgroundHeader.verticalBackgroundHeader);
         }
         addChild(this.headerBackground);
         addChild(this.label);
         this.resize();
      }

      public function setHeaderId(param1:String):void
      {
         this.setHeader(param1);
      }

      override public function set width(param1:Number):void
      {
         this.window.width = param1;
         this.resize();
      }

      override public function get width():Number
      {
         return this.window.width;
      }

      override public function set height(param1:Number):void
      {
         this.window.height = param1;
         this.resize();
      }

      override public function get height():Number
      {
         return this.window.height;
      }

      private function resize():void
      {
         if (this.headerBackground != null)
         {
            if (this.label.width > this.label.height)
            {
               this.headerBackground.x = this.window.width - this.headerBackground.width >> 1;
               this.headerBackground.y = -HEADER_BACKGROUND_HEIGHT;
               this.label.x = this.window.width - this.label.width >> 1;
               this.label.y = 5 - (HEADER_BACKGROUND_INNER_HEIGHT + this.label.height >> 1);
            }
            else
            {
               this.headerBackground.x = -HEADER_BACKGROUND_HEIGHT;
               this.headerBackground.y = this.window.height - this.headerBackground.height >> 1;
               this.label.x = 5 - (HEADER_BACKGROUND_INNER_HEIGHT + this.label.width >> 1);
               this.label.y = this.window.height - this.label.height >> 1;
            }
         }
      }
   }
}
