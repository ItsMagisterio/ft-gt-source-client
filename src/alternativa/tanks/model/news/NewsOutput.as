﻿package alternativa.tanks.model.news
{
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import fl.containers.ScrollPane;
   import fl.controls.ScrollPolicy;
   import flash.display.Sprite;

   public class NewsOutput extends ScrollPane
   {

      private var _cont:Sprite;

      public function NewsOutput()
      {
         this._cont = new Sprite();
         super();
         this.source = this._cont;
         this.horizontalScrollPolicy = ScrollPolicy.OFF;
         this.focusEnabled = false;
         setStyle("downArrowUpSkin", ScrollArrowDownGreen);
         setStyle("downArrowDownSkin", ScrollArrowDownGreen);
         setStyle("downArrowOverSkin", ScrollArrowDownGreen);
         setStyle("downArrowDisabledSkin", ScrollArrowDownGreen);
         setStyle("upArrowUpSkin", ScrollArrowUpGreen);
         setStyle("upArrowDownSkin", ScrollArrowUpGreen);
         setStyle("upArrowOverSkin", ScrollArrowUpGreen);
         setStyle("upArrowDisabledSkin", ScrollArrowUpGreen);
         setStyle("trackUpSkin", ScrollTrackGreen);
         setStyle("trackDownSkin", ScrollTrackGreen);
         setStyle("trackOverSkin", ScrollTrackGreen);
         setStyle("trackDisabledSkin", ScrollTrackGreen);
         setStyle("thumbUpSkin", ScrollThumbSkinGreen);
         setStyle("thumbDownSkin", ScrollThumbSkinGreen);
         setStyle("thumbOverSkin", ScrollThumbSkinGreen);
         setStyle("thumbDisabledSkin", ScrollThumbSkinGreen);
         this.width = 480;
         this.height = NewsWindow.MAX_HEIGHT - 70;
      }

      public function resize(param1:int):void
      {
         this.width = param1;

      }

      public function addItem(item:NewsItem):void
      {
         this._cont.addChild(item);
         this.update();
      }
   }
}
