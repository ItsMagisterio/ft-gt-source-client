package alternativa.tanks.model.challenge
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextFormatAlign;
	import forms.TankWindowWithHeader;
	import alternativa.osgi.service.locale.ILocaleService;
	import alternativa.init.Main;
	import alternativa.tanks.locale.constants.TextConst;
	import controls.TankWindowInner;
	import alternativa.tanks.model.challenge.greenpanel.GreenPanel;
	import controls.Label;
	import forms.garage.GarageButton;
	import controls.DefaultButton;
	import flash.events.MouseEvent;
	import alternativa.tanks.model.challenge.server.ChallengeServerData;
	import flash.utils.Timer;
	import logic.networking.Network;
	import logic.networking.INetworker;
	import flash.events.TimerEvent;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import projects.tanks.client.panel.model.quest.QuestTypeEnum;
	import alternativa.tanks.model.quest.common.gui.window.QuestsTabView;
	import forms.zad.Challenge;
	import controls.buttons.FixedHeightButtonSkin;
	import controls.buttons.CategoryButtonSkin;

	public class ChallengeWindow extends Sprite
	{

		private static const noQuestBitmap:Class = ChallengeWindow_noQuestBitmap;
		private var bitmap:Bitmap = new Bitmap(new noQuestBitmap().bitmapData);
		private var window:TankWindowWithHeader = TankWindowWithHeader.createWindow("MISSIONS");
		private var dailyMission3:SpecialChallengePanel;
		private var dailyMission2:SpecialChallengePanel;
		private var dailyMission:SpecialChallengePanel;
		private var innerWindow:TankWindowInner = new TankWindowInner(0, 0, TankWindowInner.GREEN);
		public var closeBtn:DefaultButton = new DefaultButton();
		private var quest1:Boolean;
		private var quest2:Boolean;
		private var quest3:Boolean;
		private var quest0:Boolean;
		private var offset:int;
		private var completed:Label = new Label();
		private var info:Label = new Label();
		public var navigateTabPanel:QuestTabButtonsList = new QuestTabButtonsList();
		private var currentTab:QuestsTabView = null;
		private var dailySprite:QuestsTabView = new QuestsTabView();
		private var weeklySprite:QuestsTabView = new QuestsTabView();
		private var challengeSprite:QuestsTabView = new QuestsTabView();
		public var challengeInfo:Challenge = new Challenge();

		private var tabViews:Dictionary = new Dictionary();
		public function ChallengeWindow(quest1:Boolean, quest2:Boolean, quest3:Boolean)
		{

			this.quest1 = quest1;
			this.quest2 = quest2;
			this.quest3 = quest3;

			this.setOffset();
			this.addNavigatePanel();
			this.createDailyTab();
			this.createWeeklyTab();
			this.createChallengeTab();

		}

		private function setOffset():void
		{
			var i:int = 3;
			// if (quest1)
			// {
			// i++;
			// }
			// if (quest2)
			// {
			// i++;
			// }
			// if (quest3)
			// {
			// i++;
			// }

			if (i == 0)
			{
				this.quest0 = true;
				this.offset = 30;
			}
			if (i == 2)
			{
				this.offset = 285;
			}
			if (i == 3)
			{
				this.offset = 572;
			}
		}

		private function addNavigatePanel():void
		{
			var _loc1_:* = null;
			this.navigateTabPanel = new QuestTabButtonsList();
			this.navigateTabPanel.addCategoryButton(QuestTypeEnum.MAIN);
			this.navigateTabPanel.addCategoryButton(QuestTypeEnum.DAILY);
			this.navigateTabPanel.addCategoryButton(QuestTypeEnum.WEEKLY);
			this.navigateTabPanel.addCategoryButton(QuestTypeEnum.CHALLENGE);
			(this.navigateTabPanel.questCategoryToButton[QuestTypeEnum.CHALLENGE] as QuestTabButton).enabled = false;
			(this.navigateTabPanel.questCategoryToButton[QuestTypeEnum.MAIN] as QuestTabButton).enabled = false;
			(this.navigateTabPanel.questCategoryToButton[QuestTypeEnum.DAILY] as QuestTabButton).enabled = false;
			(this.navigateTabPanel.questCategoryToButton[QuestTypeEnum.WEEKLY] as QuestTabButton).enabled = false;
			this.navigateTabPanel.x = 12;
			this.navigateTabPanel.y = 12;
			this.window.addChild(this.navigateTabPanel);
			// this.selectTab(QuestTypeEnum.WEEKLY);
			// this.navigateTabPanel.selectTabButton(QuestTypeEnum.WEEKLY);
			for each (_loc1_ in this.tabViews)
			{
				this.alignTabByNavPanel(_loc1_);
			}
			this.navigateTabPanel.addEventListener(SelectTabEvent.SELECT_QUESTS_TAB, this.tabSelected);
			(navigateTabPanel.questCategoryToButton[QuestTypeEnum.DAILY] as QuestTabButton).setSkin(CategoryButtonSkin.createDisableButtonSkin());
			(navigateTabPanel.questCategoryToButton[QuestTypeEnum.WEEKLY] as QuestTabButton).setSkin(CategoryButtonSkin.createDisableButtonSkin());
		}

		public function tabSelected(param1:SelectTabEvent):void
		{
			this.selectTab(param1.selectedType);
		}

		public function selectTab(param1:QuestTypeEnum):void
		{
			if (this.currentTab != null && this.window.contains(this.currentTab))
			{
				this.currentTab.hide();
				this.window.removeChild(this.currentTab);
			}
			var _loc2_:QuestsTabView = this.tabViews[param1];
			if (_loc2_ != null)
			{
				this.currentTab = _loc2_;
				this.window.addChild(this.currentTab);
				this.currentTab.show();
			}
		}

		private function alignTabByNavPanel(param1:*):void
		{
			param1.x = 12;
			param1.y = this.navigateTabPanel.y + this.navigateTabPanel.height + 8;
		}

		private function createWeeklyTab():void
		{
			this.tabViews[QuestTypeEnum.WEEKLY] = weeklySprite;
		}

		private function createChallengeTab():void
		{
			challengeSprite.addChild(challengeInfo);
			this.tabViews[QuestTypeEnum.CHALLENGE] = challengeSprite;
			challengeInfo.y = navigateTabPanel.height + 20;
			challengeInfo.x = 10;
			Network(Main.osgi.getService(INetworker)).send("lobby;get_challenges_info");
		}

		private function createDailyTab():void
		{
			var xpoz:int = 10;
			this.window.width = (302 + this.offset);
			this.window.height = 460; // /(this.quest0) ? 239 : 350;
			addChild(this.window);
			this.window.addChild(dailySprite);
			dailySprite.visible = false;
			this.tabViews[QuestTypeEnum.DAILY] = dailySprite;
			this.currentTab = dailySprite;
			if (this.quest1)
			{
				this.dailyMission = new SpecialChallengePanel(((this.window.width - 21) - this.offset), (this.window.height - 132) - (navigateTabPanel.height + 12), 1);
				this.dailyMission.x = 10;
				this.dailyMission.y = navigateTabPanel.height + 20;
				dailySprite.addChild(this.dailyMission);
				xpoz += 286;
			}
			if (this.quest2)
			{
				this.dailyMission2 = new SpecialChallengePanel(((this.window.width - 21) - this.offset), (this.window.height - 132) - (navigateTabPanel.height + 12), 2);
				this.dailyMission2.x = xpoz;
				this.dailyMission2.y = navigateTabPanel.height + 20;
				dailySprite.addChild(this.dailyMission2);
				xpoz += 286;

			}
			if (this.quest3)
			{
				this.dailyMission3 = new SpecialChallengePanel(((this.window.width - 21) - this.offset), (this.window.height - 132) - (navigateTabPanel.height + 12), 3);
				this.dailyMission3.x = xpoz;
				this.dailyMission3.y = navigateTabPanel.height + 20;
				dailySprite.addChild(this.dailyMission3);
			}
			this.closeBtn.x = ((this.window.width - this.closeBtn.width) - 10) - 1;
			this.closeBtn.y = ((this.window.height - this.closeBtn.height) - 10);
			this.closeBtn.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
			addChild(this.closeBtn);

			this.info.color = 5898034;
			this.info.htmlText = "<u>Information</u>";
			this.info.x = 11;
			this.info.y = this.window.height - this.info.height - 11;
			// this.window.addChild(this.info);

			// if (quest0)
			// {
			// this.innerWindow.width = 280 + this.offset;
			// this.innerWindow.height = 182;
			// this.innerWindow.x =int( (this.window.width / 2) - (this.innerWindow.width / 2));
			// this.innerWindow.y = 10;
			// this.window.addChild(innerWindow);
			// this.bitmap.x = ((this.innerWindow.width / 2) - (this.bitmap.width / 2)) + 11;
			// this.bitmap.y = 21;
			// this.window.addChild(bitmap);
			// this.completed.text = "                  These were all the tasks for today!\nCome back to the game tomorrow to get new ones.";

			// this.completed.x = ((this.innerWindow.width / 2) - (this.completed.width / 2)) + 11;
			// this.completed.y = 151;
			// this.window.addChild(this.completed);
			// }

		}

		public function setChallegneData(quest:ChallengeServerData):void
		{

		}

		public function show(quest:ChallengeServerData):void
		{

			if (quest.changeCost > 0)
			{
				if (quest1 != false)
				{
					this.dailyMission.changeBtn.setInfo(quest.changeCost);
				}
				if (quest2)
				{
					this.dailyMission2.changeBtn.setInfo(quest.changeCost);
				}
				if (quest3)
				{
					this.dailyMission3.changeBtn.setInfo(quest.changeCost);
				}

			}

			if (quest.quest1 != null)
			{
				this.dailyMission.setChallegneData(quest.quest1);
			}

			if (quest.quest2 != null)
			{
				this.dailyMission2.setChallegneData(quest.quest2);
			}
			if (quest.quest3 != null)
			{
				this.dailyMission3.setChallegneData(quest.quest3);
			}

		}

	}
}
