package alternativa.tanks.model.news
{
   import alternativa.tanks.model.news.frames.GreenFrame;
   import controls.Label;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;

   public class NewsItem extends Sprite
   {

      private static const WIDTH:int = 280;

      private static const TEXT_LEFT_MARGIN:int = 80;

      private static const GAP:int = 5;

      private static const MIN_HEIGHT:int = 80;

      private static const BOTTOM_GAP:int = 27;

      private var date:Label;

      private var text:Label;

      private var image:Bitmap;

      private var frame:GreenFrame;

      public function NewsItem()
      {
         this.date = new Label();
         this.text = new Label();
         super();
         this.date.color = 8454016;
         this.date.x = 180;
         this.text.color = 65280;
         this.text.x = 100;
         this.text.y = 23;
         this.text.multiline = true;
         this.text.wordWrap = true;
         this.text.align = TextFormatAlign.LEFT;
         this.text.width = 365;
         addChild(this.date);
         addChild(this.text);
         this.frame = new GreenFrame(WIDTH, MIN_HEIGHT);
         this.frame.y = 18;
         this.frame.x = 5;
         addChild(this.frame);
         this.resize(385);
      }

      public function set dataText(value:String):void
      {
         this.date.text = value;
      }

      public function set newText(value:String):void
      {
         var LinkPattern:RegExp = new RegExp("((^|\\s)(http(s)?:\\/\\/)?(www\\.)?((([a-z0-9]+)\\.){1,4})([a-z]{2,10})(\\/[a-z0-9\\.\\%\\-\\/\\?=\\:&]*)?(#([a-z0-9\\.\\%\\-\\/\\?=\\:&]*))?($|\\s))", "gi");
         var result:int = 0;
         var textStr:String = value;
         result = textStr.search(LinkPattern);
         if (result > -1)
         {
            textStr = textStr.replace(LinkPattern, "<u><a href='event:" + value.split(LinkPattern)[1] + "'>" + value.split(LinkPattern)[1] + "</a></u>");
            this.text.htmlText = textStr;
         }
         else
         {
            this.text.text = value;
         }
      }

      public function set iconId(value:String):void
      {
         this.image = new Bitmap(NewsIcons.getIcon(value));
         this.image.x = 15;
         this.image.y = 20;
         addChild(this.image);
      }

      public function get heigth():int
      {
         return this.height;
      }
      public function resize(param1:int):void
      {
         this.text.width = param1 - TEXT_LEFT_MARGIN - GAP;
         if (this.frame != null)
         {
            this.frame.setWidth(param1);
            this.frame.setHeight(this.getHeight());
         }

      }
      public function getHeight():int
      {
         return Math.max(this.text.textHeight + BOTTOM_GAP, MIN_HEIGHT) + 20;
      }
   }
}
