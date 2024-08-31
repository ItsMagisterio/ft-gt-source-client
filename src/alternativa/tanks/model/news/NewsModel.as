package alternativa.tanks.model.news
{
   import alternativa.init.Main;
   import alternativa.tanks.model.panel.IPanel;
   import flash.display.DisplayObjectContainer;

   public class NewsModel implements INewsModel
   {

      public static var newsInited:Boolean = false;

      private var panelModel:IPanel;

      private var dialogsLayer:DisplayObjectContainer;

      private var window:NewsWindow;

      public var news:Array;

      public function NewsModel()
      {
         this.news = new Array();
         super();
         this.dialogsLayer = Main.dialogsLayer;
      }

      public function showNews(items:Vector.<NewsItemServer>):void
      {
         var item:NewsItemServer = null;
         var _item:NewsItem = null;
         this.news = new Array();
         for each (item in items)
         {
            _item = new NewsItem();
            _item.dataText = item.date;
            _item.newText = item.text;
            _item.iconId = item.iconId;
            this.news.push(_item);
         }
      }
   }
}
