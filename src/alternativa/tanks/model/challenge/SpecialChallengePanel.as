package alternativa.tanks.model.challenge
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.display.Bitmap;
   import controls.TankWindowInner;
   import alternativa.tanks.model.challenge.greenpanel.GreenPanel;
   import controls.Label;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.init.Main;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.challenge.server.ChallengeServerData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import forms.garage.GarageButton;
   import logic.networking.INetworker;
   import logic.networking.Network;

   public class SpecialChallengePanel extends Sprite
   {

      private static const noQuestBitmap:Class = SpecialChallengePanel_noQuestBitmap;

      private var bitmap:Bitmap = new Bitmap(new noQuestBitmap().bitmapData);
      private var innerWindow:TankWindowInner = new TankWindowInner(0, 0, TankWindowInner.GREEN);
      private var panel:GreenPanel = new GreenPanel(260, 116);
      private var task:Label = new Label();
      private var taskValue:Label = new Label();
      private var progressLabel:Label = new Label();
      private var prize:Label = new Label();
      private var prizeValue:Label = new Label();
      private var innerWidth:int;
      private var idPanel:int;
      private var comp:Boolean = false;
      public var inited:Boolean = false;
      private var innerHeight:int;
      public var changeBtn:GarageButton = new GarageButton();
      public function SpecialChallengePanel(width:int, height:int, id:int)
      {
         this.innerWidth = width;
         this.innerHeight = height;
         this.createPanel();
         this.idPanel = id;
         this.addPanel();
         addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
      }
      private function onAddedToStage(e:Event):void
      {
         this.inited = true;
      }
      private function createPanel():void
      {
         this.innerWindow.width = this.innerWidth;
         this.innerWindow.height = this.innerHeight;
         addChild(this.innerWindow);
      }
      private function addPanel():void
      {
         this.bitmap.x = ((this.innerWindow.width / 2) - (this.bitmap.width / 2));
         this.bitmap.y = 35;
         this.innerWindow.addChild(this.bitmap);
         this.panel.x = 11;
         this.panel.y = 161;
         this.innerWindow.addChild(this.panel);
         this.task.color = 5898034;
         this.task.text = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.CHALLENGES_WINDOW_LABEL_CHALLENGE_TEXT);
         this.task.x = 5;
         this.task.y = 5;
         this.panel.addChild(this.task);
         this.taskValue.color = 0xFFFFFF;
         this.taskValue.x = 5;
         this.taskValue.y = 18;
         this.panel.addChild(this.taskValue);
         this.progressLabel.color = 0xFFFFFF;
         this.progressLabel.x = ((this.panel.width - this.progressLabel.width) - 5);
         this.progressLabel.y = 18;
         this.panel.addChild(this.progressLabel);
         this.prize.color = 5898034;
         this.prize.text = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.CHALLENGES_WINDOW_LABEL_PRIZE_TEXT);
         this.prize.x = 5;
         this.prize.y = 80;
         this.panel.addChild(this.prize);
         this.prizeValue.color = 0xFFFFFF;
         this.prizeValue.x = 5;
         this.prizeValue.y = 110;
         this.panel.addChild(this.prizeValue);
         this.changeBtn.x = 81;
         this.changeBtn.y = 295;
         this.changeBtn.addEventListener(MouseEvent.CLICK, this.onChangeQuest);
         this.changeBtn.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.CHALLENGES_WINDOW_BUTTON_CHANGE_TEXT);
         addChild(this.changeBtn);
      }
      public function setChallegneData(quest:ChallengeServerData):void
      {
         var prize:String;
         this.taskValue.text = quest.description;
         this.progressLabel.text = ((quest.progress + "/") + quest.target_progress);
         this.progressLabel.x = ((this.panel.width - this.progressLabel.width) - 5);
         this.prize.y = 85;
         this.prizeValue.text = "";
         this.prizeValue.y = 110;
         var countPrizes:int = quest.prizes.length;
         for each (prize in quest.prizes)
         {
            this.prizeValue.text = (this.prizeValue.text + (prize + "\n"));
         }
         this.prize.y = (this.prize.y - (countPrizes * (this.prize.height - 9))) - 2;
         this.prizeValue.y = (this.prize.y + 15);
         if (quest.progress >= quest.target_progress)
         {
            this.progressLabel.text = ((quest.target_progress + "/") + quest.target_progress);
            this.changeBtn.label = "Claim reward";
            this.changeBtn.setInfo(0);
            this.comp = true;
         }
         this.createNewIcon(quest.id);
      }
      private function onChangeQuest(event:MouseEvent):void
      {
         if (this.comp)
         {
            Network(Main.osgi.getService(INetworker)).send("lobby;сlean_quest;" + idPanel + ";");
         }
         else
         {
            var buttonTimer:Timer = null;
            Network(Main.osgi.getService(INetworker)).send("lobby;change_quest;" + idPanel + ";");
            this.changeBtn.enable = false;
            buttonTimer = new Timer(1000, 1);
            buttonTimer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent = null):void
               {
                  changeBtn.enable = true;
                  buttonTimer.stop();
                  buttonTimer = null;
               });
            buttonTimer.start();
         }
      }
      private function createNewIcon(id:String):void
      {
         this.innerWindow.removeChild(this.bitmap);
         this.bitmap = new Bitmap(this.getBitmapData(id));
         this.bitmap.x = this.innerWindow.width / 2 - this.bitmap.width / 2;
         this.bitmap.y = 11;

         this.innerWindow.addChild(this.bitmap);
      }
      private function getBitmapData(id:String):BitmapData
      {
         switch (id)
         {
            case "killTank":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "damage":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "gainScore":
               return new ChallengesIcons.winScoreBitmap().bitmapData;
            case "score_dm":
               return new ChallengesIcons.winScoreTypeBitmap().bitmapData;
            case "gainBattleScoresInTDM":
               return new ChallengesIcons.winScoreTypeBitmap().bitmapData;
            case "gainBattleScoresInCTF":
               return new ChallengesIcons.winScoreTypeBitmap().bitmapData;
            case "score_dom":
               return new ChallengesIcons.winScoreTypeBitmap().bitmapData;
            case "captureTheFlag":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "flag_return":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "capture_point":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "neutralize_point":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "win_score":
               return new ChallengesIcons.winScoreBitmap().bitmapData;
            case "win_cry":
               return new ChallengesIcons.winCryBitmap().bitmapData;
            case "first_place":
               return new ChallengesIcons.firstPlaceBitmap().bitmapData;
            case "first_place_dm":
               return new ChallengesIcons.firstPlaceBitmap().bitmapData;
            case "first_place_tdm":
               return new ChallengesIcons.firstPlaceBitmap().bitmapData;
            case "first_place_ctf":
               return new ChallengesIcons.firstPlaceBitmap().bitmapData;
            case "first_place_dom":
               return new ChallengesIcons.firstPlaceBitmap().bitmapData;
            case "takeBonusGold":
               return new ChallengesIcons.takeBonusBitmap().bitmapData;
            case "takeBonus":
               return new ChallengesIcons.takeBonusBitmap().bitmapData;
            default:
               return new noQuestBitmap().bitmapData;
         }
      }
   }
}
