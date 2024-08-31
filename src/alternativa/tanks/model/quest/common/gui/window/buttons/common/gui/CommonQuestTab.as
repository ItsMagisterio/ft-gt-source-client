package alternativa.tanks.model.quest.common.gui
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.quest.common.gui.window.CommonQuestView;
   import alternativa.tanks.model.quest.common.gui.window.QuestEmptyItemView;
   import alternativa.tanks.model.quest.common.gui.window.QuestWindow;
   import alternativa.tanks.model.quest.common.gui.window.QuestsTabView;
   import alternativa.types.Long;
   import flash.display.Sprite;
   import projects.tanks.client.panel.model.quest.common.specification.QuestLevel;
   import projects.tanks.client.panel.model.quest.showing.QuestInfoWithLevel;

   public class CommonQuestTab extends QuestsTabView
   {

      [Inject]
      public static var localeService:ILocaleService;

      public static const QUEST_VIEW_WIDTH:int = 280;

      public static const QUEST_PANEL_HEIGHT:int = 300;

      public static const BUTTON_HEIGHT:int = 50;

      protected var itemViews:Vector.<CommonQuestView>;

      private var stubs:Vector.<QuestEmptyItemView>;

      protected var timeToNextQuestInSeconds:int;

      public function CommonQuestTab()
      {
         super();
         this.itemViews = new Vector.<CommonQuestView>();
         this.stubs = new Vector.<QuestEmptyItemView>();
      }

      public function setTimeToNextQuest(param1:int):void
      {
         this.timeToNextQuestInSeconds = param1;
      }

      public function initViews(param1:Vector.<QuestInfoWithLevel>):void
      {
         var _loc2_:QuestLevel = null;
         var _loc3_:QuestInfoWithLevel = null;
         this.clearQuestViews();
         for each (_loc2_ in QuestLevel.values)
         {
            _loc3_ = this.findQuestBy(_loc2_, param1);
            if (_loc3_ != null)
            {
               this.addQuestItemView(_loc3_);
            }
            else
            {
               this.addQuestStub(_loc2_.value);
            }
         }
      }

      protected function clearQuestViews():void
      {
         var _loc1_:CommonQuestView = null;
         var _loc2_:QuestEmptyItemView = null;
         for each (_loc1_ in this.itemViews)
         {
            this.destroyQuestView(_loc1_);
         }
         this.itemViews.splice(0, this.itemViews.length);
         for each (_loc2_ in this.stubs)
         {
            if (this.contains(_loc2_))
            {
               removeChild(_loc2_);
            }
            _loc2_.destroy();
         }
         this.stubs.slice(0, this.stubs.length);
      }

      protected function destroyQuestView(param1:CommonQuestView):void
      {
         removeChild(param1);
         param1.destroy();
      }

      private function findQuestBy(param1:QuestLevel, param2:Vector.<QuestInfoWithLevel>):QuestInfoWithLevel
      {
         var _loc3_:QuestInfoWithLevel = null;
         for each (_loc3_ in param2)
         {
            if (_loc3_.level == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }

      protected function addQuestItemView(param1:QuestInfoWithLevel):void
      {
         var _loc2_:int = param1.level.value;
         var _loc3_:CommonQuestView = this.createQuestView(param1);
         this.alignQuestView(_loc3_, _loc2_);
         this.itemViews.push(_loc3_);
         addChild(_loc3_);
      }

      protected function createQuestView(param1:QuestInfoWithLevel):CommonQuestView
      {
         return null;
      }

      private function alignQuestView(param1:Sprite, param2:int):void
      {
         param1.x = (QUEST_VIEW_WIDTH + QuestWindow.INNER_MARGIN - 2) * param2;
         param1.y = 0;
      }

      protected function addQuestStub(param1:int):void
      {
         var _loc2_:QuestEmptyItemView = new QuestEmptyItemView(QUEST_VIEW_WIDTH, QUEST_PANEL_HEIGHT + QuestWindow.INNER_MARGIN + BUTTON_HEIGHT, this.getTextForStubView(), this.timeToNextQuestInSeconds);
         this.alignQuestView(_loc2_, param1);
         this.stubs.push(_loc2_);
         addChild(_loc2_);
      }

      protected function getTextForStubView():String
      {
         return null;
      }

      public function takePrize(param1:Long):void
      {
         var _loc3_:CommonQuestView = null;
         var _loc2_:int = 0;
         while (_loc2_ < this.itemViews.length)
         {
            _loc3_ = this.itemViews[_loc2_];
            if (_loc3_.getQuestId() == param1)
            {
               this.itemViews.splice(_loc2_, 1);
               this.destroyQuestView(_loc3_);
               this.addQuestStub(_loc3_.getQuestLevel().value);
               break;
            }
            _loc2_++;
         }
      }

      override public function close():void
      {
         this.clearQuestViews();
      }
   }
}
