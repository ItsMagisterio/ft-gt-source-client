package alternativa.tanks.model.quest.common.gui.window
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.quest.common.gui.greenpanel.GreenPanel;
   import controls.base.LabelBase;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   import projects.tanks.client.panel.model.quest.showing.QuestInfoWithLevel;
   import projects.tanks.client.panel.model.quest.showing.QuestPrizeInfo;
   import projects.tanks.clients.fp10.libraries.TanksLocale;

   public class QuestItemViewInfoPanel extends Sprite
   {

      [Inject]
      public static var localeService:ILocaleService;

      private var questInfo:QuestInfoWithLevel;

      private var _width:int;

      private var _height:int;

      private var greenPanel:GreenPanel;

      private var goalLabel:LabelBase;

      private var progressLabel:LabelBase;

      private var goalHeaderLabel:LabelBase;

      private var prizeHeaderLabel:LabelBase;

      private var prizesContainer:Vector.<LabelBase>;

      private const TEXT_LEFT_MARGIN:int = 5;

      private const HEADER_TOP_MARGIN:int = 4;

      private const TEXT_VERTICAL_MARGIN:int = 14;

      private const TEXT_RIGHT_MARGIN:int = 9;

      private const PRIZE_ITEM_HEIGHT:int = 14;

      private const PRIZE_BOTTOM_MARGIN:int = 8;

      private const PANEL_PADDING:int = 10;

      private const HEADER_COLOR:uint = 5898034;

      private const TEXT_COLOR:uint = 16777215;

      public function QuestItemViewInfoPanel(param1:QuestInfoWithLevel, param2:int, param3:int)
      {
         super();
         this.questInfo = param1;
         this._width = param2;
         this._height = param3;
         this.prizesContainer = new Vector.<LabelBase>();
         this.addPanel();
         this.addGoalBlock();
         this.addPrizeBlock();
      }

      private function addPanel():void
      {
         this.greenPanel = new GreenPanel(this._width, this._height);
         addChild(this.greenPanel);
      }

      private function addGoalBlock():void
      {
         this.addGoalHeaderLabel();
         this.addProgressLabel();
         this.addGoalLabel();
      }

      private function addGoalHeaderLabel():void
      {
         this.goalHeaderLabel = new LabelBase();
         this.goalHeaderLabel.color = this.HEADER_COLOR;
         this.goalHeaderLabel.align = TextFormatAlign.LEFT;
         this.goalHeaderLabel.text = localeService.getText(TanksLocale.TEXT_DAILY_QUEST_GOAL);
         this.goalHeaderLabel.x = this.TEXT_LEFT_MARGIN;
         this.goalHeaderLabel.y = this.HEADER_TOP_MARGIN;
         this.greenPanel.addChild(this.goalHeaderLabel);
      }

      private function addProgressLabel():void
      {
         this.progressLabel = new LabelBase();
         this.progressLabel.color = this.TEXT_COLOR;
         this.progressLabel.align = TextFormatAlign.LEFT;
         this.progressLabel.text = this.getProgressLabelText();
         this.progressLabel.x = this._width - this.TEXT_RIGHT_MARGIN - this.progressLabel.textWidth;
         this.progressLabel.y = this.goalHeaderLabel.y + this.TEXT_VERTICAL_MARGIN;
         this.greenPanel.addChild(this.progressLabel);
      }

      private function addGoalLabel():void
      {
         this.goalLabel = new LabelBase();
         this.goalLabel.color = this.TEXT_COLOR;
         this.goalLabel.align = TextFormatAlign.LEFT;
         this.goalLabel.text = this.getDescription();
         this.goalLabel.wordWrap = true;
         this.goalLabel.width = this.progressLabel.x - this.PANEL_PADDING;
         this.goalLabel.x = this.goalHeaderLabel.x;
         this.goalLabel.y = this.progressLabel.y;
         this.greenPanel.addChild(this.goalLabel);
      }

      private function getDescription():String
      {
         return this.questInfo.description.replace("%COUNT%", this.questInfo.finishCriteria.toString());
      }

      private function getProgressLabelText():String
      {
         return this.questInfo.progress + "/" + this.questInfo.finishCriteria;
      }

      private function addPrizeBlock():void
      {
         this.prizeHeaderLabel = new LabelBase();
         this.prizeHeaderLabel.color = this.HEADER_COLOR;
         this.prizeHeaderLabel.align = TextFormatAlign.LEFT;
         this.prizeHeaderLabel.text = localeService.getText(TanksLocale.TEXT_DAILY_QUEST_PRIZE);
         this.prizeHeaderLabel.x = this.TEXT_LEFT_MARGIN;
         this.updatePrizesInfo();
         this.greenPanel.addChild(this.prizeHeaderLabel);
      }

      private function updateHeaderLabel():void
      {
         this.prizeHeaderLabel.y = this._height - this.PRIZE_ITEM_HEIGHT * (this.prizesContainer.length + 1) - this.PRIZE_BOTTOM_MARGIN;
      }

      public function updatePanel(param1:QuestInfoWithLevel):void
      {
         this.questInfo = param1;
         this.goalLabel.text = this.getDescription();
         this.progressLabel.text = this.getProgressLabelText();
         this.progressLabel.x = this._width - this.TEXT_RIGHT_MARGIN - this.progressLabel.textWidth;
         this.removeAllPrizes();
         this.updatePrizesInfo();
      }

      private function removeAllPrizes():void
      {
         var _loc1_:LabelBase = null;
         for each (_loc1_ in this.prizesContainer)
         {
            this.greenPanel.removeChild(_loc1_);
         }
         this.prizesContainer.splice(0, this.prizesContainer.length);
      }

      private function updatePrizesInfo():void
      {
         var _loc2_:QuestPrizeInfo = null;
         var _loc3_:LabelBase = null;
         var _loc1_:int = 0;
         while (_loc1_ < this.questInfo.prizes.length)
         {
            _loc2_ = this.questInfo.prizes[_loc1_];
            _loc3_ = new LabelBase();
            _loc3_.color = this.TEXT_COLOR;
            _loc3_.align = TextFormatAlign.LEFT;
            _loc3_.text = _loc2_.name + " × " + _loc2_.count;
            _loc3_.x = this.TEXT_LEFT_MARGIN;
            _loc3_.y = this._height - this.PRIZE_BOTTOM_MARGIN - (_loc1_ + 1) * this.PRIZE_ITEM_HEIGHT;
            this.greenPanel.addChild(_loc3_);
            this.prizesContainer.push(_loc3_);
            _loc1_++;
         }
         this.updateHeaderLabel();
      }

      override public function get width():Number
      {
         return this._width;
      }

      override public function get height():Number
      {
         return this._height;
      }
   }
}
